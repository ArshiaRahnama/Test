local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1
L0_1 = 26
L1_1 = {}
L2_1 = {}
L3_1 = 10000
function L4_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L6_2 = TriggerClientEvent
  L7_2 = "apex_clothing:exportDone"
  L8_2 = A0_2
  if A1_2 then
    L9_2 = true
    if L9_2 then
      goto lbl_10
    end
  end
  L9_2 = false
  ::lbl_10::
  L10_2 = A2_2
  L11_2 = A3_2
  L12_2 = A4_2
  L13_2 = A5_2
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_15
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_15::
  L3_2 = tostring
  L4_2 = L2_2.mode
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  if "live" ~= L3_2 and "package" ~= L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = Utils
  L4_2 = L4_2.Slug
  L5_2 = tostring
  L6_2 = L2_2.name
  if not L6_2 then
    L6_2 = ""
  end
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  if "" == L4_2 then
    L5_2 = nil
    L6_2 = L3_2
    return L5_2, L6_2
  end
  L5_2 = type
  L6_2 = L2_2.textures
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = L2_2.textures
    L5_2 = #L5_2
    if 0 ~= L5_2 then
      goto lbl_54
    end
  end
  L5_2 = nil
  L6_2 = L3_2
  L7_2 = "export_err_nothing"
  do return L5_2, L6_2, L7_2 end
  ::lbl_54::
  L5_2 = L2_2.textures
  L5_2 = #L5_2
  L6_2 = L0_1
  if L5_2 > L6_2 then
    L5_2 = nil
    L6_2 = L3_2
    L7_2 = "export_err_too_many"
    return L5_2, L6_2, L7_2
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L2_2.textures
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = type
      L13_2 = L11_2.png
      L12_2 = L12_2(L13_2)
      if "string" == L12_2 then
        goto lbl_82
      end
    end
    L12_2 = nil
    L13_2 = L3_2
    do return L12_2, L13_2 end
    ::lbl_82::
    L12_2 = Utils
    L12_2 = L12_2.B64Decode
    L13_2 = L11_2.png
    L14_2 = L13_2
    L13_2 = L13_2.gsub
    L15_2 = "^data:image/[%w+.-]+;base64,"
    L16_2 = ""
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L13_2(L14_2, L15_2, L16_2)
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
    if L12_2 then
      L13_2 = #L12_2
      if 0 ~= L13_2 then
        goto lbl_98
      end
    end
    L13_2 = nil
    L14_2 = L3_2
    do return L13_2, L14_2 end
    ::lbl_98::
    L13_2 = {}
    L14_2 = ipairs
    L15_2 = L11_2.candidates
    if not L15_2 then
      L15_2 = {}
    end
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = type
      L21_2 = L19_2
      L20_2 = L20_2(L21_2)
      if "table" == L20_2 then
        L20_2 = type
        L21_2 = L19_2.txd
        L20_2 = L20_2(L21_2)
        if "string" == L20_2 then
          L20_2 = L19_2.txd
          if "" ~= L20_2 then
            L20_2 = type
            L21_2 = L19_2.txn
            L20_2 = L20_2(L21_2)
            if "string" == L20_2 then
              L20_2 = L19_2.txn
              if "" ~= L20_2 then
                L20_2 = #L13_2
                L20_2 = L20_2 + 1
                L21_2 = {}
                L22_2 = L19_2.txd
                L21_2.txd = L22_2
                L22_2 = L19_2.txn
                L21_2.txn = L22_2
                L13_2[L20_2] = L21_2
              end
            end
          end
        end
      end
    end
    L14_2 = #L13_2
    if 0 == L14_2 then
      L14_2 = type
      L15_2 = L11_2.txd
      L14_2 = L14_2(L15_2)
      if "string" == L14_2 then
        L14_2 = L11_2.txd
        if "" ~= L14_2 then
          L14_2 = type
          L15_2 = L11_2.txn
          L14_2 = L14_2(L15_2)
          if "string" == L14_2 then
            L14_2 = L11_2.txn
            if "" ~= L14_2 then
              L14_2 = {}
              L15_2 = L11_2.txd
              L14_2.txd = L15_2
              L15_2 = L11_2.txn
              L14_2.txn = L15_2
              L13_2[1] = L14_2
            end
          end
        end
      end
    end
    L14_2 = #L13_2
    if 0 == L14_2 then
      L14_2 = nil
      L15_2 = L3_2
      return L14_2, L15_2
    end
    L14_2 = L13_2[1]
    L14_2 = L14_2.txn
    L15_2 = L13_2[1]
    L15_2 = L15_2.txd
    L16_2 = {}
    L16_2.bytes = L12_2
    L17_2 = L11_2.png
    L16_2.dataUrl = L17_2
    L16_2.candidates = L13_2
    L16_2.txn = L14_2
    L16_2.txd = L15_2
    L5_2[L10_2] = L16_2
  end
  L6_2 = type
  L7_2 = L2_2.worn
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L6_2 = L2_2.worn
    if "" ~= L6_2 then
      L6_2 = L2_2.worn
      L7_2 = L6_2
      L6_2 = L6_2.sub
      L8_2 = 1
      L9_2 = 200
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      if L6_2 then
        goto lbl_206
      end
    end
  end
  L6_2 = nil
  ::lbl_206::
  L7_2 = {}
  L7_2.mode = L3_2
  L7_2.slug = L4_2
  L7_2.textures = L5_2
  L7_2.worn = L6_2
  return L7_2
end
L6_1 = GetCurrentResourceName
L6_1 = L6_1()
L7_1 = "data/live.json"
L8_1 = 2000000
L9_1 = 64
L10_1 = nil
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L10_1
  if nil ~= L0_2 then
    L0_2 = L10_1
    return L0_2
  end
  L0_2 = {}
  L10_1 = L0_2
  L0_2 = LoadResourceFile
  L1_2 = L6_1
  L2_2 = L7_1
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 and "" ~= L0_2 then
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
          L3_2 = L2_2.outfits
          L10_1 = L3_2
        end
      end
    end
  end
  L1_2 = L10_1
  return L1_2
end
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = json
  L0_2 = L0_2.encode
  L1_2 = {}
  L2_2 = L10_1
  if not L2_2 then
    L2_2 = {}
  end
  L1_2.outfits = L2_2
  L0_2 = L0_2(L1_2)
  L1_2 = SaveResourceFile
  L2_2 = L6_1
  L3_2 = L7_1
  L4_2 = L0_2
  L5_2 = #L0_2
  return L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L2_2.name = A0_2
  L3_2 = {}
  L2_2.textures = L3_2
  L3_2 = ipairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_2.textures
    L10_2 = L2_2.textures
    L10_2 = #L10_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2.dataUrl
    if not L12_2 then
      L12_2 = L8_2.image
    end
    L11_2.image = L12_2
    L12_2 = L8_2.candidates
    L11_2.candidates = L12_2
    L9_2[L10_2] = L11_2
  end
  return L2_2
end
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = L11_1
  L2_2()
  L2_2 = L10_1
  L2_2 = #L2_2
  L3_2 = 1
  L4_2 = -1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = type
    L7_2 = L10_1
    L7_2 = L7_2[L5_2]
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = L10_1
      L6_2 = L6_2[L5_2]
      L6_2 = L6_2.name
      L7_2 = A1_2.slug
      if L6_2 == L7_2 then
        L6_2 = table
        L6_2 = L6_2.remove
        L7_2 = L10_1
        L8_2 = L5_2
        L6_2(L7_2, L8_2)
      end
    end
  end
  L2_2 = {}
  L3_2 = A1_2.slug
  L2_2.name = L3_2
  L3_2 = {}
  L2_2.textures = L3_2
  L3_2 = ipairs
  L4_2 = A1_2.textures
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2.dataUrl
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L8_2.dataUrl
      if "" ~= L9_2 then
        L9_2 = L2_2.textures
        L10_2 = L2_2.textures
        L10_2 = #L10_2
        L10_2 = L10_2 + 1
        L11_2 = {}
        L12_2 = L8_2.dataUrl
        L11_2.dataUrl = L12_2
        L12_2 = L8_2.candidates
        L11_2.candidates = L12_2
        L9_2[L10_2] = L11_2
      end
    end
  end
  L3_2 = L2_2.textures
  L3_2 = #L3_2
  if 0 == L3_2 then
    L3_2 = L4_1
    L4_2 = A0_2
    L5_2 = false
    L6_2 = "live"
    L7_2 = nil
    L8_2 = "export_err_name"
    return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  end
  L3_2 = L10_1
  L3_2 = #L3_2
  L4_2 = L3_2 + 1
  L3_2 = L10_1
  L3_2[L4_2] = L2_2
  while true do
    L3_2 = L10_1
    L3_2 = #L3_2
    L4_2 = L9_1
    if not (L3_2 > L4_2) then
      break
    end
    L3_2 = table
    L3_2 = L3_2.remove
    L4_2 = L10_1
    L5_2 = 1
    L3_2(L4_2, L5_2)
  end
  L3_2 = L12_1
  L3_2 = L3_2()
  L4_2 = TriggerLatentClientEvent
  L5_2 = "apex_clothing:live:apply"
  L6_2 = -1
  L7_2 = L8_1
  L8_2 = L13_1
  L9_2 = A1_2.slug
  L10_2 = L2_2.textures
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L8_2(L9_2, L10_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L4_2 = 0
  L5_2 = ipairs
  L6_2 = L2_2.textures
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.candidates
    if not L11_2 then
      L11_2 = {}
    end
    L11_2 = #L11_2
    L4_2 = L4_2 + L11_2
  end
  L5_2 = print
  L6_2 = "^2[apex_clothing]^7 live export \"%s\" by %d \226\134\146 broadcast to %d player(s) "
  L7_2 = "(%d texture(s), %d name pair(s))%s"
  L6_2 = L6_2 .. L7_2
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = A1_2.slug
  L9_2 = A0_2
  L10_2 = GetPlayers
  L10_2 = L10_2()
  L10_2 = #L10_2
  L11_2 = L2_2.textures
  L11_2 = #L11_2
  L12_2 = L4_2
  if L3_2 then
    L13_2 = ""
    if L13_2 then
      goto lbl_135
    end
  end
  L13_2 = " ^1[WARN: data/live.json not written]^7"
  ::lbl_135::
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L5_2 = ipairs
  L6_2 = L2_2.textures
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = ipairs
    L12_2 = L10_2.candidates
    if not L12_2 then
      L12_2 = {}
    end
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = print
      L18_2 = "^2[apex_clothing]^7   replaces: %s / %s"
      L19_2 = L18_2
      L18_2 = L18_2.format
      L20_2 = L16_2.txd
      L21_2 = L16_2.txn
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2, L20_2, L21_2)
      L17_2(L18_2, L19_2, L20_2, L21_2)
    end
  end
  L5_2 = A1_2.worn
  if L5_2 then
    L5_2 = print
    L6_2 = "^2[apex_clothing]^7   exporter was wearing: %s"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = A1_2.worn
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L6_2(L7_2, L8_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  end
  L5_2 = L4_1
  L6_2 = A0_2
  L7_2 = true
  L8_2 = "live"
  L9_2 = nil
  L10_2 = "export_ok_live"
  L11_2 = {}
  L12_2 = A1_2.slug
  L11_2.slug = L12_2
  L12_2 = L2_2.textures
  L12_2 = #L12_2
  L11_2.textures = L12_2
  L11_2.pairs = L4_2
  L12_2 = GetPlayers
  L12_2 = L12_2()
  L12_2 = #L12_2
  L11_2.players = L12_2
  if L3_2 then
    L12_2 = true
    if L12_2 then
      goto lbl_195
    end
  end
  L12_2 = false
  ::lbl_195::
  L11_2.persisted = L12_2
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = table
  L1_2 = L1_2.concat
  L2_2 = {}
  L3_2 = "-- Generated by Apex Clothing Studio - standalone retexture pack"
  L4_2 = "-- Drop this folder into your server's resources directory and"
  L5_2 = "-- add:  ensure "
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  L6_2 = ""
  L7_2 = "fx_version 'cerulean'"
  L8_2 = "game 'gta5'"
  L9_2 = "lua54 'yes'"
  L10_2 = ""
  L11_2 = "author 'Apex Clothing Studio'"
  L12_2 = "description 'Runtime clothing retexture pack ("
  L13_2 = A0_2
  L14_2 = ")'"
  L12_2 = L12_2 .. L13_2 .. L14_2
  L13_2 = "version '1.0.0'"
  L14_2 = ""
  L15_2 = "client_script 'client.lua'"
  L16_2 = ""
  L17_2 = "files {"
  L18_2 = "    '*.png',"
  L19_2 = "}"
  L20_2 = ""
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L2_2[8] = L10_2
  L2_2[9] = L11_2
  L2_2[10] = L12_2
  L2_2[11] = L13_2
  L2_2[12] = L14_2
  L2_2[13] = L15_2
  L2_2[14] = L16_2
  L2_2[15] = L17_2
  L2_2[16] = L18_2
  L2_2[17] = L19_2
  L2_2[18] = L20_2
  L3_2 = "\n"
  return L1_2(L2_2, L3_2)
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = {}
  L3_2 = "-- Generated by Apex Clothing Studio. Applies this pack's PNGs"
  L4_2 = "-- over the original clothing textures at runtime. Every original"
  L5_2 = "-- name candidate is replaced - wrong candidates are harmless."
  L6_2 = ""
  L7_2 = "local RT_BASE = 'apex_pkg_"
  L8_2 = A0_2
  L9_2 = "'"
  L7_2 = L7_2 .. L8_2 .. L9_2
  L8_2 = ""
  L9_2 = "local REPLACEMENTS = {"
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L3_2 = ipairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = "    { file = 'tex_%d.png', rt = %q, pairs = {"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L7_2
    L13_2 = "%s_%d"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = A0_2
    L16_2 = L7_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L13_2(L14_2, L15_2, L16_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L2_2[L9_2] = L10_2
    L9_2 = ipairs
    L10_2 = L8_2.candidates
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = #L2_2
      L15_2 = L15_2 + 1
      L16_2 = "        { txd = %q, txn = %q },"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = L14_2.txd
      L19_2 = L14_2.txn
      L16_2 = L16_2(L17_2, L18_2, L19_2)
      L2_2[L15_2] = L16_2
    end
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L2_2[L9_2] = "    } },"
  end
  L3_2 = "}\n\nlocal applied = {}\n\n-- AddReplaceTexture only shows once the clothing texture dictionary is\n-- (re)streamed. For a ped already standing in the world that can be\n-- many minutes away - the classic \"the resource started but the city\n-- looks exactly the same\". Re-applying every component/prop variation\n-- forces the game to reload those textures NOW.\nlocal function refreshPed(ped)\n    if not ped or ped == 0 or not DoesEntityExist(ped) then return end\n    for comp = 0, 11 do\n        local d = GetPedDrawableVariation(ped, comp)\n        if d and d >= 0 then\n            local t = GetPedTextureVariation(ped, comp)\n            local p = GetPedPaletteVariation(ped, comp)\n            SetPedComponentVariation(ped, comp, d, t >= 0 and t or 0, p >= 0 and p or 0)\n        end\n    end\n    for _, prop in ipairs({ 0, 1, 2, 6, 7 }) do\n        local d = GetPedPropIndex(ped, prop)\n        if d and d >= 0 then\n            local t = GetPedPropTextureIndex(ped, prop)\n            SetPedPropIndex(ped, prop, d, t >= 0 and t or 0, true)\n        end\n    end\nend\n\n-- The local player plus every other player already rendered nearby.\nlocal function refreshAllPeds()\n    local me = PlayerPedId()\n    refreshPed(me)\n    for _, plId in ipairs(GetActivePlayers()) do\n        local ped = GetPlayerPed(plId)\n        if ped and ped ~= me then refreshPed(ped) end\n    end\nend\n\n-- Runtime dictionaries are global to the client and cannot be freed, so\n-- after a `restart` of this resource the old name is still taken and\n-- CreateRuntimeTxd hands back nil - every texture built on that nil\n-- handle then fails SILENTLY and the pack never applies again until the\n-- player reconnects. Take the next free name instead.\n-- WARNING: CreateRuntimeTxd answers \"no\" with 0, and 0 is TRUTHY in Lua, so\n-- `while not txd` never ran and the first refusal was returned as a handle.\n-- Every texture then bound to nothing and this pack silently did nothing.\nlocal RT_TXD = RT_BASE\nlocal function createTxd()\n    local function mint(name)\n        local h = CreateRuntimeTxd(name)\n        if h == 0 then return nil end\n        return h\n    end\n    local txd = mint(RT_TXD)\n    local n = 0\n    while not txd and n < 64 do\n        n = n + 1\n        RT_TXD = ('%s_%d'):format(RT_BASE, n)\n        txd = mint(RT_TXD)\n    end\n    if not txd then\n        print('^1[' .. GetCurrentResourceName() .. '] no runtime texture dictionary available, '\n            .. 'nothing was applied. Rejoin the server to clear it.^7')\n    end\n    return txd\nend\n\nCreateThread(function()\n    Wait(500)\n    -- Create the runtime dictionary ONCE and reuse its handle for\n    -- every texture (re-creating it per texture returns nil \226\134\146 nothing\n    -- was applied, which is the classic \"export did nothing\" bug).\n    local res = GetCurrentResourceName()\n    local txd = createTxd()\n    local missing = {}\n    if not txd then\n        print(('^1[%s] no runtime texture dictionary could be created - '\n            .. 'nothing was applied^7'):format(res))\n    end\n    for _, entry in ipairs(REPLACEMENTS) do\n        -- Prove the PNG is really here before reporting success. After\n        -- the manual file move a renamed or misplaced texture fails\n        -- SILENTLY, and a pack that says \"applied 1\" while nothing was\n        -- loaded sends people hunting the wrong problem for hours.\n        local present = LoadResourceFile(res, entry.file) ~= nil\n        local made = txd and present\n            and pcall(CreateRuntimeTextureFromImage, txd, entry.rt, entry.file)\n        if made then\n            for _, pair in ipairs(entry.pairs) do\n                AddReplaceTexture(pair.txd, pair.txn, RT_TXD, entry.rt)\n                applied[#applied + 1] = pair\n            end\n        else\n            missing[#missing + 1] = entry.file\n        end\n    end\n    for _, file in ipairs(missing) do\n        print(('^1[%s] \"%s\" could not be loaded - that texture was NOT applied. '\n            .. 'The file must sit in this resource exactly under that name '\n            .. '(check you dropped the \"<name>__\" prefix when moving the files).^7')\n            :format(res, file))\n    end\n    if #applied > 0 then\n        print(('^2[%s]^7 applied %d clothing texture replacement(s)'):format(res, #applied))\n        -- Show the swap immediately instead of waiting for a re-stream.\n        refreshAllPeds()\n    else\n        print(('^1[%s] applied NOTHING - see the lines above / the README^7'):format(res))\n    end\nend)\n\n-- Spawning (and respawning) re-streams the clothing, so re-assert the\n-- variations or the player comes back wearing the original texture.\nAddEventHandler('playerSpawned', function()\n    if #applied == 0 then return end\n    Wait(1500)\n    refreshAllPeds()\nend)\n\nAddEventHandler('onResourceStop', function(res)\n    if res ~= GetCurrentResourceName() then return end\n    for _, pair in ipairs(applied) do\n        RemoveReplaceTexture(pair.txd, pair.txn)\n    end\n    refreshAllPeds()          -- the original clothing comes back at once\nend)\n"
  L4_2 = table
  L4_2 = L4_2.concat
  L5_2 = L2_2
  L6_2 = "\n"
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = "\n"
  L6_2 = L3_2
  L4_2 = L4_2 .. L5_2 .. L6_2
  return L4_2
end
L17_1 = {}
L17_1.head = "Head / Face"
L17_1.berd = "Mask / Beard"
L17_1.hair = "Hair"
L17_1.uppr = "Arms / Upper body"
L17_1.lowr = "Legs / Pants"
L17_1.hand = "Bags / Parachute"
L17_1.feet = "Shoes"
L17_1.teef = "Neck / Accessory"
L17_1.accs = "Undershirt"
L17_1.task = "Body armor / Vest"
L17_1.decl = "Decals / Badges"
L17_1.jbib = "Torso / Top"
L17_1.p_head = "Hat / Helmet"
L17_1.p_eyes = "Glasses"
L17_1.p_ears = "Ears"
L17_1.p_lwrist = "Left wrist"
L17_1.p_rwrist = "Right wrist"
L18_1 = {}
L19_1 = ipairs
L20_1 = Config
L20_1 = L20_1.components
if not L20_1 then
  L20_1 = {}
end
L19_1, L20_1, L21_1, L22_1 = L19_1(L20_1)
for L23_1, L24_1 in L19_1, L20_1, L21_1, L22_1 do
  L25_1 = L24_1.key
  L26_1 = {}
  L27_1 = L24_1.id
  L26_1.id = L27_1
  L26_1.kind = "component"
  L18_1[L25_1] = L26_1
end
L19_1 = ipairs
L20_1 = Config
L20_1 = L20_1.props
if not L20_1 then
  L20_1 = {}
end
L19_1, L20_1, L21_1, L22_1 = L19_1(L20_1)
for L23_1, L24_1 in L19_1, L20_1, L21_1, L22_1 do
  L25_1 = L24_1.key
  L26_1 = {}
  L27_1 = L24_1.id
  L26_1.id = L27_1
  L26_1.kind = "prop"
  L18_1[L25_1] = L26_1
end
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = tostring
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.match
  L4_2 = "^(.-)_diff_(%d+)_(%a)"
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L18_1
  L5_2 = L5_2[L2_2]
  L6_2 = tostring
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.match
  L8_2 = "^([^/]+)"
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = ""
  end
  L8_2 = L6_2
  L7_2 = L6_2.match
  L9_2 = "^mp_f_"
  L7_2 = L7_2(L8_2, L9_2)
  if L7_2 then
    L7_2 = "female"
    if L7_2 then
      goto lbl_39
    end
  end
  L8_2 = L6_2
  L7_2 = L6_2.match
  L9_2 = "^mp_m_"
  L7_2 = L7_2(L8_2, L9_2)
  if L7_2 then
    L7_2 = "male"
    if L7_2 then
      goto lbl_39
    end
  end
  L7_2 = nil
  ::lbl_39::
  L9_2 = L6_2
  L8_2 = L6_2.match
  L10_2 = "^mp_[mf]_freemode_01_(.+)$"
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = ""
  end
  L9_2 = {}
  L9_2.model = L6_2
  L9_2.gender = L7_2
  L9_2.collection = L8_2
  L10_2 = L17_1
  L10_2 = L10_2[L2_2]
  if not L10_2 then
    L10_2 = L2_2
  end
  L9_2.slot = L10_2
  if L5_2 then
    L10_2 = L5_2.id
    if L10_2 then
      goto lbl_62
    end
  end
  L10_2 = nil
  ::lbl_62::
  L9_2.id = L10_2
  if L5_2 then
    L10_2 = L5_2.kind
    if L10_2 then
      goto lbl_69
    end
  end
  L10_2 = "component"
  ::lbl_69::
  L9_2.kind = L10_2
  L10_2 = tonumber
  L11_2 = L3_2
  L10_2 = L10_2(L11_2)
  L9_2.drawable = L10_2
  L9_2.letter = L4_2
  L10_2 = string
  L10_2 = L10_2.byte
  L11_2 = L4_2
  L10_2 = L10_2(L11_2)
  L10_2 = L10_2 - 97
  L9_2.variant = L10_2
  return L9_2
end
function L20_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L4_2 = {}
  L5_2 = "# "
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  L6_2 = ""
  L7_2 = "Clothing retexture pack generated with **Apex Clothing Studio**."
  L8_2 = ""
  L9_2 = "## Install"
  L10_2 = ""
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L4_2[6] = L10_2
  if A1_2 then
    L5_2 = #L4_2
    L5_2 = L5_2 + 1
    L4_2[L5_2] = "1. Move this whole folder into your server's `resources/` directory."
  else
    L5_2 = #L4_2
    L5_2 = L5_2 + 1
    L6_2 = "1. Make a folder called `%s` inside your server's `resources/`."
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = A0_2
    L6_2 = L6_2(L7_2, L8_2)
    L4_2[L5_2] = L6_2
    L5_2 = #L4_2
    L5_2 = L5_2 + 1
    L6_2 = "2. Move the %d files that start with `%s__` into it, and remove that"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = A2_2
    L9_2 = A0_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L4_2[L5_2] = L6_2
    L5_2 = #L4_2
    L5_2 = L5_2 + 1
    L4_2[L5_2] = "   prefix from each name (so this file becomes `README.md`)."
  end
  if A1_2 then
    L5_2 = 2
    if L5_2 then
      goto lbl_46
    end
  end
  L5_2 = 3
  ::lbl_46::
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L7_2 = "%d. Add `ensure %s` to `server.cfg`."
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = L5_2
  L10_2 = A0_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L4_2[L6_2] = L7_2
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L7_2 = "%d. Restart the server (or run `refresh` then `ensure %s`)."
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = L5_2 + 1
  L10_2 = A0_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L4_2[L6_2] = L7_2
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "## Wearing it"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "This pack REPLACES the texture of a garment that already exists in the"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "game. It does **not** add a new clothing item, and nothing new shows up"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "in a shop or clothing menu - the garment below is what changes."
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "**Put this exact item on and you are wearing the design:**"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = ipairs
  L7_2 = A3_2 or L7_2
  if not A3_2 then
    L7_2 = {}
  end
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.candidates
    if not L12_2 then
      L12_2 = {}
    end
    L12_2 = L12_2[1]
    L13_2 = L12_2 or L13_2
    if L12_2 then
      L13_2 = L19_1
      L14_2 = L12_2.txd
      L15_2 = L12_2.txn
      L13_2 = L13_2(L14_2, L15_2)
    end
    if L13_2 then
      L14_2 = L13_2.slot
      L15_2 = L13_2.id
      if L15_2 then
        L15_2 = "%s (%s %d)"
        L16_2 = L15_2
        L15_2 = L15_2.format
        L17_2 = L14_2
        L18_2 = L13_2.kind
        if "prop" == L18_2 then
          L18_2 = "prop"
          if L18_2 then
            goto lbl_136
          end
        end
        L18_2 = "component"
        ::lbl_136::
        L19_2 = L13_2.id
        L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
        L14_2 = L15_2
      end
      L15_2 = #L4_2
      L15_2 = L15_2 + 1
      L16_2 = "- **%s** - drawable **%d**, texture variant **%d** (`%s`), %s ped"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = L14_2
      L19_2 = L13_2.drawable
      L20_2 = L13_2.variant
      L21_2 = L13_2.letter
      L22_2 = L13_2.gender
      if not L22_2 then
        L22_2 = L13_2.model
      end
      L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
      L4_2[L15_2] = L16_2
      L15_2 = L13_2.collection
      if "" ~= L15_2 then
        L15_2 = #L4_2
        L15_2 = L15_2 + 1
        L16_2 = "  - addon collection `%s` - the drawable number is the index"
        L17_2 = L16_2
        L16_2 = L16_2.format
        L18_2 = L13_2.collection
        L16_2 = L16_2(L17_2, L18_2)
        L4_2[L15_2] = L16_2
        L15_2 = #L4_2
        L15_2 = L15_2 + 1
        L4_2[L15_2] = "    **inside that collection**, not the global clothing-menu number."
      end
    elseif L12_2 then
      L14_2 = #L4_2
      L14_2 = L14_2 + 1
      L15_2 = "- `%s`"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L12_2.txn
      L15_2 = L15_2(L16_2, L17_2)
      L4_2[L14_2] = L15_2
    end
  end
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "A different drawable, a different texture variant, the other gender or"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "an addon version of the same-looking garment is a DIFFERENT texture and"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "this pack will not touch it. That is by far the most common reason for"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "\"I installed it and nothing changed\"."
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "## It is running but nothing changed"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L7_2 = "1. The client console (F8) must print `[%s] applied N clothing"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = A0_2
  L7_2 = L7_2(L8_2, L9_2)
  L4_2[L6_2] = L7_2
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "   texture replacement(s)`. No line at all = the resource never started"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "   (`ensure` missing); a red line = the PNG is not where `client.lua`"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "   expects it (check the file names after the manual move)."
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "2. Wear the garment listed above - with a clothing menu, on the right"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "   gender, at that exact drawable AND variant."
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "3. Still nothing? Take the item off and put it back on, or relog. The"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "   swap only lands when the game re-streams that clothing texture."
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = "Texture names replaced by this pack:"
  L6_2 = #L4_2
  L6_2 = L6_2 + 1
  L4_2[L6_2] = ""
  return L4_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2
  L2_2 = GetCurrentResourceName
  L2_2 = L2_2()
  L3_2 = Config
  L3_2 = L3_2.export
  if L3_2 then
    L3_2 = Config
    L3_2 = L3_2.export
    L3_2 = L3_2.packageDir
    if L3_2 then
      goto lbl_13
    end
  end
  L3_2 = "exports"
  ::lbl_13::
  L4_2 = false
  L5_2 = Config
  L5_2 = L5_2.export
  if L5_2 then
    L5_2 = Config
    L5_2 = L5_2.export
    L5_2 = L5_2.createFolder
    if true == L5_2 then
      L5_2 = pcall
      function L6_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
        L0_3 = os
        L0_3 = L0_3.createdir
        L1_3 = "@%s/%s"
        L2_3 = L1_3
        L1_3 = L1_3.format
        L3_3 = L2_2
        L4_3 = L3_2
        L1_3, L2_3, L3_3, L4_3, L5_3 = L1_3(L2_3, L3_3, L4_3)
        L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
        L0_3 = os
        L0_3 = L0_3.createdir
        L1_3 = "@%s/%s/%s"
        L2_3 = L1_3
        L1_3 = L1_3.format
        L3_3 = L2_2
        L4_3 = L3_2
        L5_3 = A1_2.slug
        L1_3, L2_3, L3_3, L4_3, L5_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
        L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
      end
      L5_2 = L5_2(L6_2)
      L4_2 = L5_2
    end
  end
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = L4_2
    if L1_3 then
      L1_3 = "%s/%s/%s"
      L2_3 = L1_3
      L1_3 = L1_3.format
      L3_3 = L3_2
      L4_3 = A1_2.slug
      L5_3 = A0_3
      return L1_3(L2_3, L3_3, L4_3, L5_3)
    end
    L1_3 = "%s/%s__%s"
    L2_3 = L1_3
    L1_3 = L1_3.format
    L3_3 = L3_2
    L4_3 = A1_2.slug
    L5_3 = A0_3
    return L1_3(L2_3, L3_3, L4_3, L5_3)
  end
  L6_2 = {}
  L7_2 = "fxmanifest.lua"
  L8_2 = "client.lua"
  L9_2 = "README.md"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = 1
  L8_2 = A1_2.textures
  L8_2 = #L8_2
  L9_2 = 1
  for L10_2 = L7_2, L8_2, L9_2 do
    L11_2 = #L6_2
    L11_2 = L11_2 + 1
    L12_2 = "tex_%d.png"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L10_2
    L12_2 = L12_2(L13_2, L14_2)
    L6_2[L11_2] = L12_2
  end
  L7_2 = L20_1
  L8_2 = A1_2.slug
  L9_2 = L4_2
  L10_2 = #L6_2
  L11_2 = A1_2.textures
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  L8_2 = ipairs
  L9_2 = A1_2.textures
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = ipairs
    L15_2 = L13_2.candidates
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = #L7_2
      L20_2 = L20_2 + 1
      L21_2 = "- `%s` / `%s`"
      L22_2 = L21_2
      L21_2 = L21_2.format
      L23_2 = L19_2.txd
      L24_2 = L19_2.txn
      L21_2 = L21_2(L22_2, L23_2, L24_2)
      L7_2[L20_2] = L21_2
    end
  end
  L8_2 = #L7_2
  L8_2 = L8_2 + 1
  L7_2[L8_2] = ""
  L8_2 = table
  L8_2 = L8_2.concat
  L9_2 = L7_2
  L10_2 = "\n"
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = L15_1
  L10_2 = A1_2.slug
  L9_2 = L9_2(L10_2)
  L10_2 = L16_1
  L11_2 = A1_2.slug
  L12_2 = A1_2.textures
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = SaveResourceFile
  L12_2 = L2_2
  L13_2 = L5_2
  L14_2 = "fxmanifest.lua"
  L13_2 = L13_2(L14_2)
  L14_2 = L9_2
  L15_2 = #L9_2
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
  if L11_2 then
    L12_2 = SaveResourceFile
    L13_2 = L2_2
    L14_2 = L5_2
    L15_2 = "client.lua"
    L14_2 = L14_2(L15_2)
    L15_2 = L10_2
    L16_2 = #L10_2
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
    L11_2 = L12_2
  end
  if L11_2 then
    L12_2 = SaveResourceFile
    L13_2 = L2_2
    L14_2 = L5_2
    L15_2 = "README.md"
    L14_2 = L14_2(L15_2)
    L15_2 = L8_2
    L16_2 = #L8_2
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
    L11_2 = L12_2
  end
  L12_2 = ipairs
  L13_2 = A1_2.textures
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    if L11_2 then
      L18_2 = SaveResourceFile
      L19_2 = L2_2
      L20_2 = L5_2
      L21_2 = "tex_%d.png"
      L22_2 = L21_2
      L21_2 = L21_2.format
      L23_2 = L16_2
      L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L21_2(L22_2, L23_2)
      L20_2 = L20_2(L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
      L21_2 = L17_2.bytes
      L22_2 = L17_2.bytes
      L22_2 = #L22_2
      L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
      L11_2 = L18_2
    end
  end
  if not L11_2 then
    L12_2 = Utils
    L12_2 = L12_2.Err
    L13_2 = "package export \"%s\" could not be written into %s/ - "
    L14_2 = "the resource folder must be writable by the server user"
    L13_2 = L13_2 .. L14_2
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = A1_2.slug
    L16_2 = L3_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L13_2(L14_2, L15_2, L16_2)
    L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
    L12_2 = L4_1
    L13_2 = A0_2
    L14_2 = false
    L15_2 = "package"
    L16_2 = nil
    L17_2 = "export_err_perm"
    return L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  end
  L12_2 = GetResourcePath
  L13_2 = L2_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = L2_2
  end
  L13_2 = L12_2
  L12_2 = L12_2.gsub
  L14_2 = "\\"
  L15_2 = "/"
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = L12_2
  L12_2 = L12_2.gsub
  L14_2 = "/+$"
  L15_2 = ""
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = L12_2
  L14_2 = "/"
  L15_2 = L3_2
  if L4_2 then
    L16_2 = "/"
    L17_2 = A1_2.slug
    L16_2 = L16_2 .. L17_2
    if L16_2 then
      goto lbl_190
    end
  end
  L16_2 = ""
  ::lbl_190::
  L13_2 = L13_2 .. L14_2 .. L15_2 .. L16_2
  L14_2 = print
  L15_2 = "^2[apex_clothing]^7 package export \"%s\" by %d \226\134\146 %s (%d files, %s layout)"
  L16_2 = L15_2
  L15_2 = L15_2.format
  L17_2 = A1_2.slug
  L18_2 = A0_2
  L19_2 = L13_2
  L20_2 = #L6_2
  if L4_2 then
    L21_2 = "nested"
    if L21_2 then
      goto lbl_204
    end
  end
  L21_2 = "flat"
  ::lbl_204::
  L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
  L14_2 = ipairs
  L15_2 = A1_2.textures
  L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
  for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
    L20_2 = ipairs
    L21_2 = L19_2.candidates
    if not L21_2 then
      L21_2 = {}
    end
    L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
    for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
      L26_2 = print
      L27_2 = "^2[apex_clothing]^7   replaces: %s / %s"
      L28_2 = L27_2
      L27_2 = L27_2.format
      L29_2 = L25_2.txd
      L30_2 = L25_2.txn
      L27_2, L28_2, L29_2, L30_2 = L27_2(L28_2, L29_2, L30_2)
      L26_2(L27_2, L28_2, L29_2, L30_2)
    end
  end
  L14_2 = A1_2.worn
  if L14_2 then
    L14_2 = print
    L15_2 = "^2[apex_clothing]^7   exporter was wearing: %s"
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = A1_2.worn
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L15_2(L16_2, L17_2)
    L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
  end
  if not L4_2 then
    L14_2 = Utils
    L14_2 = L14_2.Log
    L15_2 = "  the %d files are in %s, all named %s__*"
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = #L6_2
    L18_2 = L13_2
    L19_2 = A1_2.slug
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
    L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
    L14_2 = Utils
    L14_2 = L14_2.Log
    L15_2 = "  make a folder called \"%s\" next to them, move them in, drop the prefix,"
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = A1_2.slug
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L15_2(L16_2, L17_2)
    L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
    L14_2 = Utils
    L14_2 = L14_2.Log
    L15_2 = "  then add:  ensure %s"
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = A1_2.slug
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L15_2(L16_2, L17_2)
    L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
  end
  L14_2 = L4_1
  L15_2 = A0_2
  L16_2 = true
  L17_2 = "package"
  L18_2 = L13_2
  L19_2 = "export_ok_package"
  L20_2 = {}
  L21_2 = A1_2.slug
  L20_2.slug = L21_2
  L20_2.nested = L4_2
  L20_2.files = L6_2
  if L4_2 then
    L21_2 = ""
    if L21_2 then
      goto lbl_285
    end
  end
  L21_2 = A1_2.slug
  L22_2 = "__"
  L21_2 = L21_2 .. L22_2
  ::lbl_285::
  L20_2.prefix = L21_2
  L21_2 = A1_2.textures
  L21_2 = #L21_2
  L20_2.textures = L21_2
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
end
function L22_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = Config
  L0_2 = L0_2.export
  if L0_2 then
    L0_2 = Config
    L0_2 = L0_2.export
    L0_2 = L0_2.downloadDir
  end
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 and "" ~= L0_2 then
    L2_2 = L0_2
    L1_2 = L0_2.gsub
    L3_2 = "\\"
    L4_2 = "/"
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    L2_2 = L1_2
    L1_2 = L1_2.gsub
    L3_2 = "/+$"
    L4_2 = ""
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    L2_2 = true
    return L1_2, L2_2
  end
  L1_2 = os
  L1_2 = L1_2.getenv
  L2_2 = "USERPROFILE"
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = os
    L1_2 = L1_2.getenv
    L2_2 = "HOME"
    L1_2 = L1_2(L2_2)
  end
  if L1_2 and "" ~= L1_2 then
    L3_2 = L1_2
    L2_2 = L1_2.gsub
    L4_2 = "\\"
    L5_2 = "/"
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L3_2 = L2_2
    L2_2 = L2_2.gsub
    L4_2 = "/+$"
    L5_2 = ""
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L3_2 = "/Desktop"
    L2_2 = L2_2 .. L3_2
    L3_2 = false
    return L2_2, L3_2
  end
  L2_2 = nil
  L3_2 = false
  return L2_2, L3_2
end
L23_1 = Apex
L23_1 = L23_1.OnLarge
L24_1 = "texture_dl"
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L3_2 = Apex
  L3_2 = L3_2.IsAllowed
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    return
  end
  L3_2 = pcall
  L4_2 = json
  L4_2 = L4_2.decode
  L5_2 = A2_2
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      goto lbl_27
    end
  end
  L5_2 = TriggerClientEvent
  L6_2 = "apex_clothing:downloadDone"
  L7_2 = A0_2
  L8_2 = false
  L9_2 = "#dl_fail"
  do return L5_2(L6_2, L7_2, L8_2, L9_2) end
  ::lbl_27::
  L5_2 = Utils
  L5_2 = L5_2.B64Decode
  L6_2 = tostring
  L7_2 = L4_2.png
  if not L7_2 then
    L7_2 = ""
  end
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.gsub
  L8_2 = "^data:image/[%w+.-]+;base64,"
  L9_2 = ""
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L6_2(L7_2, L8_2, L9_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  if L5_2 then
    L6_2 = #L5_2
    if 0 ~= L6_2 then
      goto lbl_52
    end
  end
  L6_2 = TriggerClientEvent
  L7_2 = "apex_clothing:downloadDone"
  L8_2 = A0_2
  L9_2 = false
  L10_2 = "#dl_fail"
  do return L6_2(L7_2, L8_2, L9_2, L10_2) end
  ::lbl_52::
  L6_2 = tostring
  L7_2 = L4_2.name
  if not L7_2 then
    L7_2 = "texture"
  end
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.gsub
  L8_2 = "[^%w._-]+"
  L9_2 = "_"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if "" == L6_2 then
    L6_2 = "texture"
  end
  L7_2 = "%s_%s.png"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = L6_2
  L10_2 = os
  L10_2 = L10_2.date
  L11_2 = "%Y%m%d_%H%M%S"
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L10_2(L11_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  function L8_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = print
    L2_3 = "^2[apex_clothing]^7 PNG saved on the SERVER machine \226\134\146 %s"
    L3_3 = L2_3
    L2_3 = L2_3.format
    L4_3 = A0_3
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3, L4_3)
    L1_3(L2_3, L3_3, L4_3, L5_3)
    L1_3 = TriggerClientEvent
    L2_3 = "apex_clothing:downloadDone"
    L3_3 = A0_2
    L4_3 = true
    L5_3 = A0_3
    return L1_3(L2_3, L3_3, L4_3, L5_3)
  end
  L9_2 = L22_1
  L9_2, L10_2 = L9_2()
  if L9_2 then
    L11_2 = io
    if L11_2 then
      L11_2 = io
      L11_2 = L11_2.open
      if L11_2 then
        L11_2 = L9_2
        L12_2 = "/"
        L13_2 = L7_2
        L11_2 = L11_2 .. L12_2 .. L13_2
        L12_2 = pcall
        function L13_2()
          local L0_3, L1_3, L2_3, L3_3
          L0_3 = assert
          L1_3 = io
          L1_3 = L1_3.open
          L2_3 = L11_2
          L3_3 = "wb"
          L1_3, L2_3, L3_3 = L1_3(L2_3, L3_3)
          L0_3 = L0_3(L1_3, L2_3, L3_3)
          L2_3 = L0_3
          L1_3 = L0_3.write
          L3_3 = L5_2
          L1_3(L2_3, L3_3)
          L2_3 = L0_3
          L1_3 = L0_3.close
          L1_3(L2_3)
        end
        L12_2 = L12_2(L13_2)
        if L12_2 then
          L13_2 = L8_2
          L14_2 = L11_2
          return L13_2(L14_2)
        end
        if L10_2 then
          L13_2 = Utils
          L13_2 = L13_2.Warn
          L14_2 = "could not write %s (Config.export.downloadDir) - "
          L15_2 = "falling back to exports/downloads/"
          L14_2 = L14_2 .. L15_2
          L15_2 = L14_2
          L14_2 = L14_2.format
          L16_2 = L11_2
          L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2, L16_2)
          L13_2(L14_2, L15_2, L16_2, L17_2)
        end
      end
    end
  end
  L11_2 = GetCurrentResourceName
  L11_2 = L11_2()
  L12_2 = "exports/downloads/"
  L13_2 = L7_2
  L12_2 = L12_2 .. L13_2
  L13_2 = SaveResourceFile
  L14_2 = L11_2
  L15_2 = L12_2
  L16_2 = L5_2
  L17_2 = #L5_2
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
  if L13_2 then
    L13_2 = GetResourcePath
    L14_2 = L11_2
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = L11_2
    end
    L14_2 = L13_2
    L13_2 = L13_2.gsub
    L15_2 = "\\"
    L16_2 = "/"
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    L14_2 = L13_2
    L13_2 = L13_2.gsub
    L15_2 = "/+$"
    L16_2 = ""
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    L14_2 = L8_2
    L15_2 = L13_2
    L16_2 = "/"
    L17_2 = L12_2
    L15_2 = L15_2 .. L16_2 .. L17_2
    return L14_2(L15_2)
  end
  L13_2 = Utils
  L13_2 = L13_2.Err
  L14_2 = "could not write %s/%s - the resource folder must be writable "
  L15_2 = "by the user the server runs as"
  L14_2 = L14_2 .. L15_2
  L15_2 = L14_2
  L14_2 = L14_2.format
  L16_2 = L11_2
  L17_2 = L12_2
  L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2, L16_2, L17_2)
  L13_2(L14_2, L15_2, L16_2, L17_2)
  L13_2 = TriggerClientEvent
  L14_2 = "apex_clothing:downloadDone"
  L15_2 = A0_2
  L16_2 = false
  L17_2 = "#dl_fail"
  L13_2(L14_2, L15_2, L16_2, L17_2)
end
L23_1(L24_1, L25_1)
L23_1 = Apex
L23_1 = L23_1.OnLarge
L24_1 = "export_run"
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = Apex
  L3_2 = L3_2.IsAllowed
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    return
  end
  L3_2 = L1_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = L4_1
    L4_2 = A0_2
    L5_2 = false
    L6_2 = nil
    L7_2 = nil
    L8_2 = "export_err_busy"
    return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  end
  L3_2 = L5_1
  L4_2 = A2_2
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  if not L3_2 then
    L6_2 = L4_1
    L7_2 = A0_2
    L8_2 = false
    L9_2 = L4_2 or L9_2
    if not L4_2 then
      L9_2 = "package"
    end
    L10_2 = nil
    L11_2 = L5_2 or L11_2
    if not L5_2 then
      L11_2 = "export_err_name"
    end
    return L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  end
  L6_2 = L1_1
  L6_2[A0_2] = true
  L6_2 = pcall
  function L7_2()
    local L0_3, L1_3, L2_3
    L0_3 = L3_2.mode
    if "live" == L0_3 then
      L0_3 = L14_1
      L1_3 = A0_2
      L2_3 = L3_2
      L0_3(L1_3, L2_3)
    else
      L0_3 = L21_1
      L1_3 = A0_2
      L2_3 = L3_2
      L0_3(L1_3, L2_3)
    end
  end
  L6_2, L7_2 = L6_2(L7_2)
  L8_2 = L1_1
  L8_2[A0_2] = nil
  if not L6_2 then
    L8_2 = Utils
    L8_2 = L8_2.Err
    L9_2 = "export crashed:"
    L10_2 = tostring
    L11_2 = L7_2
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    L8_2 = L4_1
    L9_2 = A0_2
    L10_2 = false
    L11_2 = L3_2.mode
    L12_2 = nil
    L13_2 = "export_err_artifact"
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  end
end
L23_1(L24_1, L25_1)
L23_1 = AddEventHandler
L24_1 = "playerDropped"
function L25_1()
  local L0_2, L1_2
  L0_2 = source
  if L0_2 then
    L1_2 = L1_1
    L1_2[L0_2] = nil
    L1_2 = L2_1
    L1_2[L0_2] = nil
  end
end
L23_1(L24_1, L25_1)
L23_1 = RegisterNetEvent
L24_1 = "apex_clothing:live:request"
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L0_2 = source
  if not L0_2 or L0_2 <= 0 then
    return
  end
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L2_1
  L2_2 = L2_2[L0_2]
  if L2_2 then
    L3_2 = L1_2 - L2_2
    L4_2 = L3_1
    if L3_2 < L4_2 then
      return
    end
  end
  L3_2 = L2_1
  L3_2[L0_2] = L1_2
  L3_2 = L11_1
  L3_2()
  L3_2 = ipairs
  L4_2 = L10_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = TriggerLatentClientEvent
    L10_2 = "apex_clothing:live:apply"
    L11_2 = L0_2
    L12_2 = L8_1
    L13_2 = L13_1
    L14_2 = L8_2.name
    L15_2 = L8_2.textures
    L13_2, L14_2, L15_2 = L13_2(L14_2, L15_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  end
end
L23_1(L24_1, L25_1)
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if 0 ~= A0_2 then
    L1_2 = Apex
    L1_2 = L1_2.IsAllowed
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if not L1_2 then
      L1_2 = false
      return L1_2
    end
  end
  L1_2 = {}
  L10_1 = L1_2
  L1_2 = L12_1
  L1_2()
  L1_2 = TriggerLatentClientEvent
  L2_2 = "apex_clothing:live:clear"
  L3_2 = -1
  L4_2 = 100000
  L5_2 = {}
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = true
  return L1_2
end
L24_1 = RegisterCommand
L25_1 = "clothingliveclear"
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    if 0 == A0_2 then
      L1_2 = print
      L2_2 = "^2[apex_clothing]^7 all live retextures cleared"
      L1_2(L2_2)
    else
      L1_2 = Apex
      L1_2 = L1_2.Notify
      L2_2 = A0_2
      L3_2 = "#live_cleared"
      L4_2 = "info"
      L1_2(L2_2, L3_2, L4_2)
    end
  elseif 0 ~= A0_2 then
    L1_2 = Apex
    L1_2 = L1_2.Notify
    L2_2 = A0_2
    L3_2 = "#err_no_access"
    L4_2 = "error"
    L1_2(L2_2, L3_2, L4_2)
  end
end
L27_1 = false
L24_1(L25_1, L26_1, L27_1)
L24_1 = exports
L25_1 = "ClearLiveTextures"
function L26_1()
  local L0_2, L1_2
  L0_2 = L23_1
  L1_2 = 0
  return L0_2(L1_2)
end
L24_1(L25_1, L26_1)
L24_1 = Apex
L24_1 = L24_1.RegisterCallback
L25_1 = "live:list"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = Apex
  L2_2 = L2_2.IsAllowed
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A1_2
    L3_2 = {}
    return L2_2(L3_2)
  end
  L2_2 = L11_1
  L2_2()
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L10_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L10_2 = ipairs
    L11_2 = L8_2.textures
    if not L11_2 then
      L11_2 = {}
    end
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = L15_2.candidates
      if L16_2 then
        L16_2 = L15_2.candidates
        L16_2 = L16_2[1]
      end
      L17_2 = #L9_2
      L17_2 = L17_2 + 1
      if L16_2 then
        L18_2 = L16_2.txn
        if L18_2 then
          goto lbl_47
        end
      end
      L18_2 = L15_2.txn
      if not L18_2 then
        L18_2 = "?"
      end
      ::lbl_47::
      L9_2[L17_2] = L18_2
    end
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2.name
    L11_2.name = L12_2
    L12_2 = L8_2.textures
    if not L12_2 then
      L12_2 = {}
    end
    L12_2 = #L12_2
    L11_2.count = L12_2
    L11_2.txns = L9_2
    L2_2[L10_2] = L11_2
  end
  L3_2 = A1_2
  L4_2 = L2_2
  L3_2(L4_2)
end
L24_1(L25_1, L26_1)
L24_1 = Apex
L24_1 = L24_1.RegisterCallback
L25_1 = "live:remove"
function L26_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = Apex
  L3_2 = L3_2.IsAllowed
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = A1_2
    L4_2 = false
    return L3_2(L4_2)
  end
  L3_2 = L11_1
  L3_2()
  L3_2 = tostring
  L4_2 = A2_2 or L4_2
  if not A2_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  L3_2 = false
  L4_2 = L10_1
  L4_2 = #L4_2
  L5_2 = 1
  L6_2 = -1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L10_1
    L8_2 = L8_2[L7_2]
    L8_2 = L8_2.name
    if L8_2 == A2_2 then
      L8_2 = table
      L8_2 = L8_2.remove
      L9_2 = L10_1
      L10_2 = L7_2
      L8_2(L9_2, L10_2)
      L3_2 = true
    end
  end
  if L3_2 then
    L4_2 = L12_1
    L4_2()
    L4_2 = TriggerLatentClientEvent
    L5_2 = "apex_clothing:live:removeOne"
    L6_2 = -1
    L7_2 = 100000
    L8_2 = A2_2
    L4_2(L5_2, L6_2, L7_2, L8_2)
    L4_2 = Utils
    L4_2 = L4_2.Log
    L5_2 = "live outfit \"%s\" removed by %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = A2_2
    L8_2 = tostring
    L9_2 = A0_2
    L8_2, L9_2, L10_2 = L8_2(L9_2)
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  end
  L4_2 = A1_2
  L5_2 = L3_2
  L4_2(L5_2)
end
L24_1(L25_1, L26_1)
L24_1 = Apex
L24_1 = L24_1.RegisterCallback
L25_1 = "live:clear"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A1_2
  L3_2 = L23_1
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  L2_2(L3_2, L4_2)
end
L24_1(L25_1, L26_1)
