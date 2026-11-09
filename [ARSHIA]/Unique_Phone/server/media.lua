local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1
L0_1 = {}
L0_1["image/jpeg"] = "image"
L0_1["image/png"] = "image"
L0_1["image/webp"] = "image"
L0_1["audio/webm"] = "audio"
L0_1["audio/ogg"] = "audio"
L0_1["audio/mp4"] = "audio"
L1_1 = {}
L1_1["image/jpeg"] = "/9j/"
L1_1["image/png"] = "iVBORw0KGgo"
L1_1["image/webp"] = "UklGR"
L1_1["audio/webm"] = "GkXf"
L1_1["audio/ogg"] = "T2dnU"
L2_1 = 512
L3_1 = 3
L4_1 = 300
L5_1 = 600000
function L6_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Media
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Media
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = tonumber
  L4_2 = L0_2.chunkBytes
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 48000
  end
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L1_2 then
    L1_2 = 48000
  end
  L2_2 = 4000
  if L1_2 < L2_2 then
    L1_2 = 4000
  else
    L2_2 = 64000
    if L1_2 > L2_2 then
      L1_2 = 64000
    end
  end
  L2_2 = {}
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 1
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = tonumber
  L8_2 = L0_2.maxImageBytes
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 260000
  end
  L6_2, L7_2, L8_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L5_2 = 260000
  end
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.maxImage = L3_2
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 1
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = tonumber
  L8_2 = L0_2.maxAudioBytes
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 700000
  end
  L6_2, L7_2, L8_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L5_2 = 700000
  end
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.maxAudio = L3_2
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 1
  L5_2 = tonumber
  L6_2 = L0_2.maxAudioSec
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 60
  end
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.maxSec = L3_2
  L2_2.chunk = L1_2
  L3_2 = tonumber
  L4_2 = L0_2.keepDays
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 60
  end
  L2_2.keepDays = L3_2
  return L2_2
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 and L1_2 > 0 then
    return L1_2
  end
  L2_2 = nil
  return L2_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.sub
  L3_2 = 1
  L4_2 = 80
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.match
  L3_2 = "^%s*([%w%-%.%+]+/[%w%-%.%+]+)"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = L1_2
    L2_2 = L1_2.lower
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_22
      L1_2 = L2_2 or L1_2
    end
  end
  L1_2 = nil
  ::lbl_22::
  if L1_2 then
    L2_2 = L0_1
    L2_2 = L2_2[L1_2]
    if L2_2 then
      return L1_2
    end
  end
  L2_2 = nil
  return L2_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = 0
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L7_2
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L10_2 = L7_2
      L9_2 = L7_2.match
      L11_2 = "^[%w_]+$"
      L9_2 = L9_2(L10_2, L11_2)
      if L9_2 then
        L9_2 = #L7_2
        if L9_2 <= 24 then
          L9_2 = type
          L10_2 = L8_2
          L9_2 = L9_2(L10_2)
          L10_2 = nil
          if "number" == L9_2 then
            if L8_2 == L8_2 then
              L11_2 = -1.0E12
              if L8_2 > L11_2 then
                L11_2 = 1.0E12
                if L8_2 < L11_2 then
                  L10_2 = L8_2
                end
              end
            end
          elseif "boolean" == L9_2 then
            L10_2 = L8_2
          elseif "string" == L9_2 then
            L12_2 = L8_2
            L11_2 = L8_2.sub
            L13_2 = 1
            L14_2 = 120
            L11_2 = L11_2(L12_2, L13_2, L14_2)
            L10_2 = L11_2
            L11_2 = 1
            L12_2 = 3
            L13_2 = 1
            for L14_2 = L11_2, L12_2, L13_2 do
              L15_2 = utf8
              L15_2 = L15_2.len
              L16_2 = L10_2
              L15_2 = L15_2(L16_2)
              if L15_2 then
                break
              end
              L16_2 = L10_2
              L15_2 = L10_2.sub
              L17_2 = 1
              L18_2 = -2
              L15_2 = L15_2(L16_2, L17_2, L18_2)
              L10_2 = L15_2
            end
          elseif "table" == L9_2 then
            L11_2 = {}
            L12_2 = ipairs
            L13_2 = L8_2
            L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
            for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
              if L16_2 > 64 then
                break
              end
              L18_2 = tonumber
              L19_2 = L17_2
              L18_2 = L18_2(L19_2)
              if L18_2 and L18_2 == L18_2 then
                L19_2 = #L11_2
                L19_2 = L19_2 + 1
                L20_2 = math
                L20_2 = L20_2.floor
                L21_2 = L18_2 * 1000
                L21_2 = L21_2 + 0.5
                L20_2 = L20_2(L21_2)
                L20_2 = L20_2 / 1000
                L11_2[L19_2] = L20_2
              end
            end
            L12_2 = #L11_2
            if L12_2 > 0 then
              L10_2 = L11_2
            end
          end
          if nil ~= L10_2 then
            L1_2[L7_2] = L10_2
            L2_2 = L2_2 + 1
            if L2_2 >= 12 then
              break
            end
          end
        end
      end
    end
  end
  if 0 == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = pcall
  L4_2 = json
  L4_2 = L4_2.encode
  L5_2 = L1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "string" == L5_2 then
      L5_2 = #L4_2
      L6_2 = 2000
      if not (L5_2 > L6_2) then
        goto lbl_141
      end
    end
  end
  L5_2 = nil
  do return L5_2 end
  ::lbl_141::
  return L4_2
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 and L2_2 then
      goto lbl_25
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = nil
  ::lbl_25::
  return L3_2
end
L11_1 = {}
L12_1 = {}
L13_1 = {}
L14_1 = 60
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = 0
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  L4_2 = pairs
  L5_2 = L11_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.src
    if L10_2 == A0_2 then
      L10_2 = L9_2.cid
      if L10_2 == A1_2 then
        L10_2 = L9_2.t
        L10_2 = L3_2 - L10_2
        L11_2 = L14_1
        if not (L10_2 > L11_2) then
          goto lbl_24
        end
      end
      L10_2 = L11_1
      L10_2[L8_2] = nil
      goto lbl_26
      ::lbl_24::
      L2_2 = L2_2 + 1
    end
    ::lbl_26::
  end
  return L2_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L7_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L12_1
  L2_2 = L2_2[L1_2]
  if L2_2 then
    L3_2 = os
    L3_2 = L3_2.time
    L3_2 = L3_2()
    L2_2.t = L3_2
    L3_2 = {}
    L3_2.id = L1_2
    L4_2 = L2_2.owner
    L3_2.owner = L4_2
    L4_2 = L2_2.kind
    L3_2.kind = L4_2
    L4_2 = L2_2.mime
    L3_2.mime = L4_2
    L4_2 = L2_2.duration
    L3_2.duration = L4_2
    L4_2 = L2_2.meta
    L3_2.meta = L4_2
    L4_2 = L2_2.size
    L3_2.size = L4_2
    L3_2.complete = true
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT owner, kind, mime, duration, meta, complete, size FROM apex_phone_media WHERE id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = L3_2.complete
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L4_2 = 1 == L4_2
  L5_2 = {}
  L5_2.id = L1_2
  L6_2 = L3_2.owner
  L5_2.owner = L6_2
  L6_2 = L3_2.kind
  L5_2.kind = L6_2
  L6_2 = L3_2.mime
  L5_2.mime = L6_2
  L6_2 = L3_2.duration
  if L6_2 then
    L6_2 = math
    L6_2 = L6_2.tointeger
    L7_2 = tonumber
    L8_2 = L3_2.duration
    L7_2, L8_2 = L7_2(L8_2)
    L6_2 = L6_2(L7_2, L8_2)
    if L6_2 then
      goto lbl_77
    end
  end
  L6_2 = nil
  ::lbl_77::
  L5_2.duration = L6_2
  L6_2 = L10_1
  L7_2 = L3_2.meta
  L6_2 = L6_2(L7_2)
  L5_2.meta = L6_2
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = L3_2.size
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2.size = L6_2
  L5_2.complete = L4_2
  if L4_2 then
    L6_2 = L12_1
    L7_2 = {}
    L8_2 = L5_2.owner
    L7_2.owner = L8_2
    L8_2 = L5_2.kind
    L7_2.kind = L8_2
    L8_2 = L5_2.mime
    L7_2.mime = L8_2
    L8_2 = L5_2.duration
    L7_2.duration = L8_2
    L8_2 = L5_2.meta
    L7_2.meta = L8_2
    L8_2 = L5_2.size
    L7_2.size = L8_2
    L8_2 = os
    L8_2 = L8_2.time
    L8_2 = L8_2()
    L7_2.t = L8_2
    L6_2[L1_2] = L7_2
  end
  return L5_2
end
MediaInfo = L16_1
L16_1 = RPC
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L6_1
  L3_2 = L3_2()
  L4_2 = A1_2.kind
  if "image" ~= L4_2 then
    L4_2 = A1_2.kind
    if "audio" ~= L4_2 then
      goto lbl_21
    end
  end
  L4_2 = A1_2.kind
  ::lbl_21::
  if not L4_2 then
    L4_2 = nil
  end
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "badkind"
    return L5_2
  end
  L5_2 = L8_1
  L6_2 = A1_2.mime
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L0_1
    L6_2 = L6_2[L5_2]
    if L6_2 == L4_2 then
      goto lbl_41
    end
  end
  L6_2 = {}
  L6_2.error = "badmime"
  do return L6_2 end
  ::lbl_41::
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = A1_2.size
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  if not L6_2 or L6_2 < 1 then
    L7_2 = {}
    L7_2.error = "badsize"
    return L7_2
  end
  if "image" == L4_2 then
    L7_2 = L3_2.maxImage
    if L7_2 then
      goto lbl_61
    end
  end
  L7_2 = L3_2.maxAudio
  ::lbl_61::
  L8_2 = "image" == L4_2
  if L8_2 then
    L9_2 = type
    L10_2 = Config
    L10_2 = L10_2.Recado
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = math
      L9_2 = L9_2.tointeger
      L10_2 = math
      L10_2 = L10_2.floor
      L11_2 = tonumber
      L12_2 = Config
      L12_2 = L12_2.Recado
      L12_2 = L12_2.hdImageBytes
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L10_2(L11_2)
      L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      if not L9_2 then
        L9_2 = 0
      end
      if L7_2 < L9_2 then
        L10_2 = math
        L10_2 = L10_2.min
        L11_2 = L9_2
        L12_2 = 4000000
        L10_2 = L10_2(L11_2, L12_2)
        L7_2 = L10_2
      end
    end
  end
  if L6_2 > L7_2 then
    L9_2 = {}
    L9_2.error = "toolarge"
    L9_2.max = L7_2
    return L9_2
  end
  L9_2 = nil
  L10_2 = A1_2.duration
  if nil ~= L10_2 then
    L10_2 = tonumber
    L11_2 = A1_2.duration
    L10_2 = L10_2(L11_2)
    if not L10_2 or L10_2 ~= L10_2 or L10_2 < 0 then
      L11_2 = {}
      L11_2.error = "badduration"
      return L11_2
    end
    L11_2 = math
    L11_2 = L11_2.tointeger
    L12_2 = math
    L12_2 = L12_2.floor
    L13_2 = L10_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L12_2(L13_2)
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L9_2 = L11_2
    if not L9_2 then
      L11_2 = {}
      L11_2.error = "badduration"
      return L11_2
    end
  end
  if "audio" == L4_2 and L9_2 then
    L10_2 = math
    L10_2 = L10_2.floor
    L11_2 = L3_2.maxSec
    L11_2 = L11_2 * 1000
    L10_2 = L10_2(L11_2)
    L10_2 = L10_2 + 1500
    if L9_2 > L10_2 then
      L10_2 = {}
      L10_2.error = "toolong"
      L11_2 = L3_2.maxSec
      L10_2.maxSec = L11_2
      return L10_2
    end
  end
  if "image" == L4_2 then
    L9_2 = nil
  end
  L10_2 = L15_1
  L11_2 = A0_2
  L12_2 = L2_2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = L3_1
  if L10_2 >= L11_2 then
    L10_2 = {}
    L10_2.error = "busy"
    return L10_2
  end
  L10_2 = MySQL
  L10_2 = L10_2.insert
  L10_2 = L10_2.await
  L11_2 = "INSERT INTO apex_phone_media (owner, kind, mime, data, size, duration, meta, complete, created) VALUES (?, ?, ?, NULL, ?, ?, ?, 0, ?)"
  L12_2 = {}
  L13_2 = L2_2
  L14_2 = L4_2
  L15_2 = L5_2
  L16_2 = L6_2
  L17_2 = L9_2
  L18_2 = L9_1
  L19_2 = A1_2.meta
  L18_2 = L18_2(L19_2)
  L19_2 = Now
  L19_2 = L19_2()
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L12_2[4] = L16_2
  L12_2[5] = L17_2
  L12_2[6] = L18_2
  L12_2[7] = L19_2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = L7_1
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  L10_2 = L11_2
  if not L10_2 then
    L11_2 = {}
    L11_2.error = "db"
    return L11_2
  end
  L11_2 = L11_1
  L12_2 = {}
  L12_2.src = A0_2
  L12_2.cid = L2_2
  L12_2.kind = L4_2
  L12_2.mime = L5_2
  L12_2.size = L6_2
  L12_2.next = 1
  L12_2.len = 0
  L12_2.lastLen = 0
  L13_2 = {}
  L12_2.parts = L13_2
  L13_2 = os
  L13_2 = L13_2.time
  L13_2 = L13_2()
  L12_2.t = L13_2
  L11_2[L10_2] = L12_2
  L11_2 = Dbg
  L12_2 = "media"
  L13_2 = "begin #%s %s %s %d chars (src %s)"
  L14_2 = L10_2
  L15_2 = L4_2
  L16_2 = L5_2
  L17_2 = L6_2
  L18_2 = A0_2
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L11_2 = {}
  L11_2.id = L10_2
  L12_2 = L3_2.chunk
  L11_2.chunk = L12_2
  return L11_2
end
L16_1["media.begin"] = L17_1
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if 1 == A1_2 then
    L4_2 = A2_2
    L3_2 = A2_2.sub
    L5_2 = 1
    L6_2 = 5
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if "data:" == L3_2 then
      L4_2 = A2_2
      L3_2 = A2_2.find
      L5_2 = ","
      L6_2 = 1
      L7_2 = true
      L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
      if L3_2 then
        L4_2 = 160
        if not (L3_2 > L4_2) then
          goto lbl_21
        end
      end
      L4_2 = false
      do return L4_2 end
      ::lbl_21::
      L5_2 = A2_2
      L4_2 = A2_2.sub
      L6_2 = 6
      L7_2 = L3_2 - 1
      L4_2 = L4_2(L5_2, L6_2, L7_2)
      L6_2 = L4_2
      L5_2 = L4_2.match
      L7_2 = "^([%w%-%.%+]+/[%w%-%.%+]+)"
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L7_2 = L5_2
        L6_2 = L5_2.lower
        L6_2 = L6_2(L7_2)
        L7_2 = A0_2.mime
        if L6_2 == L7_2 then
          L7_2 = L4_2
          L6_2 = L4_2.find
          L8_2 = ";base64$"
          L6_2 = L6_2(L7_2, L8_2)
          if L6_2 then
            goto lbl_43
          end
        end
      end
      L6_2 = false
      do return L6_2 end
      ::lbl_43::
      A0_2.header = L3_2
      L7_2 = A2_2
      L6_2 = A2_2.sub
      L8_2 = L3_2 + 1
      L6_2 = L6_2(L7_2, L8_2)
      A2_2 = L6_2
    end
  end
  L4_2 = A2_2
  L3_2 = A2_2.find
  L5_2 = "[^%w%+/=]"
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = nil == L3_2
  return L3_2
end
function L17_1(A0_2)
  local L1_2
  L1_2 = L11_1
  L1_2[A0_2] = nil
end
L18_1 = RPC
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L7_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "notfound"
    return L4_2
  end
  L4_2 = L11_1
  L4_2 = L4_2[L3_2]
  if L4_2 then
    L5_2 = L4_2.cid
    if L5_2 == L2_2 then
      goto lbl_30
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_30::
  L5_2 = L6_1
  L5_2 = L5_2()
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = A1_2.i
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = math
  L7_2 = L7_2.tointeger
  L8_2 = tonumber
  L9_2 = A1_2.total
  L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L8_2 = type
  L9_2 = A1_2.data
  L8_2 = L8_2(L9_2)
  if "string" == L8_2 then
    L8_2 = A1_2.data
    if L8_2 then
      goto lbl_53
    end
  end
  L8_2 = nil
  ::lbl_53::
  if not (L6_2 and L7_2 and L8_2) or "" == L8_2 then
    L9_2 = {}
    L9_2.error = "badchunk"
    return L9_2
  end
  L9_2 = math
  L9_2 = L9_2.ceil
  L10_2 = L4_2.size
  L11_2 = L5_2.chunk
  L10_2 = L10_2 / L11_2
  L9_2 = L9_2(L10_2)
  if not (L7_2 < L9_2) then
    L9_2 = L2_1
    if not (L7_2 > L9_2 or L6_2 < 1 or L6_2 > L7_2) then
      goto lbl_85
    end
  end
  L9_2 = {}
  L9_2.error = "badchunk"
  do return L9_2 end
  ::lbl_85::
  L9_2 = L4_2.total
  if L9_2 then
    L9_2 = L4_2.total
    if L9_2 ~= L7_2 then
      L9_2 = L17_1
      L10_2 = L3_2
      L9_2(L10_2)
      L9_2 = {}
      L9_2.error = "badchunk"
      return L9_2
    end
  end
  L9_2 = #L8_2
  L10_2 = L5_2.chunk
  if L9_2 > L10_2 then
    L9_2 = {}
    L9_2.error = "toolarge"
    L10_2 = L5_2.chunk
    L9_2.chunk = L10_2
    return L9_2
  end
  L9_2 = L4_2.next
  if L6_2 < L9_2 then
    L9_2 = L4_2.next
    L9_2 = L9_2 - 1
    if L6_2 == L9_2 then
      L9_2 = #L8_2
      L10_2 = L4_2.lastLen
      if L9_2 == L10_2 then
        L9_2 = {}
        L9_2.ok = true
        L9_2.i = L6_2
        L9_2.dup = true
        return L9_2
      end
    end
    L9_2 = {}
    L9_2.error = "order"
    L10_2 = L4_2.next
    L9_2.expected = L10_2
    return L9_2
  end
  L9_2 = L4_2.next
  if L6_2 ~= L9_2 then
    L9_2 = {}
    L9_2.error = "order"
    L10_2 = L4_2.next
    L9_2.expected = L10_2
    return L9_2
  end
  L9_2 = L16_1
  L10_2 = L4_2
  L11_2 = L6_2
  L12_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  if not L9_2 then
    L9_2 = L17_1
    L10_2 = L3_2
    L9_2(L10_2)
    L9_2 = {}
    L9_2.error = "baddata"
    return L9_2
  end
  L9_2 = L4_2.len
  L10_2 = #L8_2
  L9_2 = L9_2 + L10_2
  L10_2 = L4_2.size
  if L9_2 > L10_2 then
    L9_2 = L17_1
    L10_2 = L3_2
    L9_2(L10_2)
    L9_2 = {}
    L9_2.error = "toolarge"
    return L9_2
  end
  L4_2.total = L7_2
  L9_2 = L4_2.parts
  L9_2[L6_2] = L8_2
  L9_2 = L4_2.len
  L10_2 = #L8_2
  L9_2 = L9_2 + L10_2
  L4_2.len = L9_2
  L9_2 = #L8_2
  L4_2.lastLen = L9_2
  L9_2 = L6_2 + 1
  L4_2.next = L9_2
  L9_2 = os
  L9_2 = L9_2.time
  L9_2 = L9_2()
  L4_2.t = L9_2
  L9_2 = {}
  L9_2.ok = true
  L9_2.i = L6_2
  return L9_2
end
L18_1["media.upload"] = L19_1
L18_1 = RPC
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L7_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "notfound"
    return L4_2
  end
  L4_2 = L11_1
  L4_2 = L4_2[L3_2]
  if L4_2 then
    L5_2 = L4_2.cid
    if L5_2 == L2_2 then
      goto lbl_30
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_30::
  L5_2 = L4_2.total
  if L5_2 then
    L5_2 = L4_2.next
    L5_2 = L5_2 - 1
    L6_2 = L4_2.total
    if L5_2 == L6_2 then
      goto lbl_45
    end
  end
  L5_2 = {}
  L5_2.error = "missing"
  L6_2 = L4_2.next
  L5_2.expected = L6_2
  do return L5_2 end
  ::lbl_45::
  L5_2 = L4_2.len
  L6_2 = L4_2.size
  if L5_2 ~= L6_2 then
    L5_2 = L17_1
    L6_2 = L3_2
    L5_2(L6_2)
    L5_2 = {}
    L5_2.error = "badsize"
    L6_2 = L4_2.len
    L5_2.got = L6_2
    L6_2 = L4_2.size
    L5_2.size = L6_2
    return L5_2
  end
  L5_2 = table
  L5_2 = L5_2.concat
  L6_2 = L4_2.parts
  L7_2 = ""
  L8_2 = 1
  L9_2 = L4_2.total
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L6_2 = L17_1
  L7_2 = L3_2
  L6_2(L7_2)
  L6_2 = nil
  L7_2 = L4_2.header
  if L7_2 then
    L8_2 = L5_2
    L7_2 = L5_2.sub
    L9_2 = L4_2.header
    L9_2 = L9_2 + 1
    L7_2 = L7_2(L8_2, L9_2)
    L6_2 = L7_2
  else
    L6_2 = L5_2
    L7_2 = "data:"
    L8_2 = L4_2.mime
    L9_2 = ";base64,"
    L10_2 = L5_2
    L7_2 = L7_2 .. L8_2 .. L9_2 .. L10_2
    L5_2 = L7_2
  end
  L7_2 = #L6_2
  if not (L7_2 < 8) then
    L7_2 = #L6_2
    L7_2 = L7_2 % 4
    if 0 == L7_2 then
      goto lbl_100
    end
  end
  L7_2 = {}
  L7_2.error = "baddata"
  do return L7_2 end
  ::lbl_100::
  L8_2 = L6_2
  L7_2 = L6_2.find
  L9_2 = "="
  L10_2 = 1
  L11_2 = true
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  if L7_2 then
    L8_2 = #L6_2
    L8_2 = L8_2 - 1
    if not (L7_2 < L8_2) then
      L9_2 = L6_2
      L8_2 = L6_2.find
      L10_2 = "[^=]"
      L11_2 = L7_2
      L8_2 = L8_2(L9_2, L10_2, L11_2)
      if not L8_2 then
        goto lbl_122
      end
    end
    L8_2 = {}
    L8_2.error = "baddata"
    return L8_2
  end
  ::lbl_122::
  L9_2 = L4_2.mime
  L8_2 = L1_1
  L8_2 = L8_2[L9_2]
  if L8_2 then
    L10_2 = L6_2
    L9_2 = L6_2.sub
    L11_2 = 1
    L12_2 = #L8_2
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if L9_2 ~= L8_2 then
      L9_2 = {}
      L9_2.error = "baddata"
      return L9_2
    end
  end
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = "UPDATE apex_phone_media SET data = ?, size = ?, complete = 1 WHERE id = ? AND owner = ? AND complete = 0"
  L11_2 = {}
  L12_2 = L5_2
  L13_2 = #L5_2
  L14_2 = L3_2
  L15_2 = L2_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = tonumber
  L11_2 = L9_2
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 0
  end
  if L10_2 < 1 then
    L10_2 = {}
    L10_2.error = "notfound"
    return L10_2
  end
  L10_2 = Dbg
  L11_2 = "media"
  L12_2 = "finish #%s %d chars"
  L13_2 = L3_2
  L14_2 = #L5_2
  L10_2(L11_2, L12_2, L13_2, L14_2)
  L10_2 = {}
  L10_2.ok = true
  L10_2.id = L3_2
  L11_2 = #L5_2
  L10_2.size = L11_2
  return L10_2
end
L18_1["media.finish"] = L19_1
L18_1 = "('sms','match','marketplace','recado')"
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = "%%\"mediaId\":%d,%%"
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = "%%\"mediaId\":%d}%%"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = A0_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = "%%\"mediaId\":\"%d\"%%"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = A0_2
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  return L1_2, L2_2, L3_2, L4_2, L5_2
end
L20_1 = 10000
L21_1 = 30
L22_1 = 10000
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L13_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = L2_2.cid
    if L3_2 == A1_2 then
      goto lbl_22
    end
  end
  L3_2 = {}
  L3_2.cid = A1_2
  L4_2 = {}
  L3_2.ids = L4_2
  L4_2 = {}
  L3_2.deny = L4_2
  L3_2.misses = 0
  L3_2.missT = 0
  L2_2 = L3_2
  L3_2 = L13_1
  L3_2[A0_2] = L2_2
  ::lbl_22::
  return L2_2
end
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L23_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L3_2.ids
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L6_2 = L5_1
  L5_2 = L5_2 + L6_2
  L4_2[A2_2] = L5_2
  L4_2 = L3_2.deny
  L4_2[A2_2] = nil
end
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L23_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L5_2 = L3_2.deny
  L6_2 = L20_1
  L6_2 = L4_2 + L6_2
  L5_2[A2_2] = L6_2
  L5_2 = L3_2.missT
  L5_2 = L4_2 - L5_2
  L6_2 = L22_1
  if L5_2 > L6_2 then
    L5_2 = 0
    L3_2.missT = L4_2
    L3_2.misses = L5_2
  end
  L5_2 = L3_2.misses
  L5_2 = L5_2 + 1
  L3_2.misses = L5_2
end
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L2_2 and nil ~= L3_2
  return L4_2
end
function L27_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if A0_2 then
    L1_2 = L13_1
    L1_2[A0_2] = nil
  end
end
MediaRevoke = L27_1
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    return
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = pairs
  L2_2 = L13_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.cid
    if L7_2 == A0_2 then
      L7_2 = L13_1
      L7_2[L5_2] = nil
    end
  end
  L1_2 = pairs
  L2_2 = L11_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.cid
    if L7_2 == A0_2 then
      L7_2 = L11_1
      L7_2[L5_2] = nil
    end
  end
end
MediaForget = L27_1
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = L7_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not A0_2 or not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = type
  L5_2 = RecadoMediaDenied
  L4_2 = L4_2(L5_2)
  if "function" == L4_2 then
    L4_2 = pcall
    L5_2 = RecadoMediaDenied
    L6_2 = A0_2
    L7_2 = L2_2
    L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 and true == L5_2 then
      L6_2 = false
      return L6_2
    end
  end
  L4_2 = L13_1
  L4_2 = L4_2[A0_2]
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  if L4_2 then
    L6_2 = L4_2.cid
    if L6_2 == L3_2 then
      L6_2 = L4_2.ids
      L6_2 = L6_2[L2_2]
      if not L6_2 then
        L6_2 = 0
      end
      if L5_2 < L6_2 then
        L6_2 = true
        return L6_2
      end
      L6_2 = L4_2.deny
      L6_2 = L6_2[L2_2]
      if not L6_2 then
        L6_2 = 0
      end
      if L5_2 < L6_2 then
        L6_2 = false
        return L6_2
      end
    end
  end
  L6_2 = MediaInfo
  L7_2 = L2_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L7_2 = L25_1
    L8_2 = A0_2
    L9_2 = L3_2
    L10_2 = L2_2
    L7_2(L8_2, L9_2, L10_2)
    L7_2 = false
    return L7_2
  end
  L7_2 = L6_2.owner
  if L7_2 == L3_2 then
    L7_2 = L24_1
    L8_2 = A0_2
    L9_2 = L3_2
    L10_2 = L2_2
    L7_2(L8_2, L9_2, L10_2)
    L7_2 = true
    return L7_2
  end
  if L4_2 then
    L7_2 = L4_2.cid
    if L7_2 == L3_2 then
      L7_2 = L4_2.misses
      L8_2 = L21_1
      if L7_2 >= L8_2 then
        L7_2 = L4_2.missT
        L7_2 = L5_2 - L7_2
        L8_2 = L22_1
        if L7_2 <= L8_2 then
          L7_2 = false
          return L7_2
        end
      end
    end
  end
  L7_2 = L19_1
  L8_2 = L2_2
  L7_2, L8_2, L9_2 = L7_2(L8_2)
  L10_2 = false
  L11_2 = GetPlayerNumber
  L12_2 = A0_2
  L11_2 = L11_2(L12_2)
  L12_2 = {}
  if L11_2 and "" ~= L11_2 then
    L13_2 = #L12_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L14_2.number = L11_2
    L12_2[L13_2] = L14_2
  end
  L13_2 = pcall
  L14_2 = MySQL
  L14_2 = L14_2.query
  L14_2 = L14_2.await
  L15_2 = "SELECT app, username FROM apex_phone_social_accounts WHERE owner = ? LIMIT 20"
  L16_2 = {}
  L17_2 = L3_2
  L16_2[1] = L17_2
  L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2)
  if L13_2 then
    L15_2 = type
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    if "table" == L15_2 then
      L15_2 = ipairs
      L16_2 = L14_2
      L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
      for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
        L21_2 = #L12_2
        L21_2 = L21_2 + 1
        L22_2 = {}
        L23_2 = L20_2.app
        L22_2.app = L23_2
        L23_2 = L20_2.username
        L22_2.username = L23_2
        L12_2[L21_2] = L22_2
      end
    end
  end
  L15_2 = ipairs
  L16_2 = L12_2
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    if L10_2 then
      break
    end
    L21_2 = nil
    L22_2 = nil
    L23_2 = L20_2.number
    if L23_2 then
      L23_2 = "app IN "
      L24_2 = L18_1
      L23_2 = L23_2 .. L24_2
      L22_2 = L20_2.number
      L21_2 = L23_2
    else
      L23_2 = "app = ?"
      L22_2 = L20_2.username
      L21_2 = L23_2
    end
    L23_2 = " AND type IN ('image','audio') AND deleted_all IS NULL AND (payload LIKE ? OR payload LIKE ? OR payload LIKE ?) LIMIT 1"
    L24_2 = L20_2.number
    if L24_2 then
      L24_2 = {}
      L25_2 = L22_2
      L26_2 = L7_2
      L27_2 = L8_2
      L28_2 = L9_2
      L24_2[1] = L25_2
      L24_2[2] = L26_2
      L24_2[3] = L27_2
      L24_2[4] = L28_2
      if L24_2 then
        goto lbl_197
      end
    end
    L24_2 = {}
    L25_2 = L22_2
    L26_2 = L20_2.app
    L27_2 = L7_2
    L28_2 = L8_2
    L29_2 = L9_2
    L24_2[1] = L25_2
    L24_2[2] = L26_2
    L24_2[3] = L27_2
    L24_2[4] = L28_2
    L24_2[5] = L29_2
    ::lbl_197::
    L25_2 = L26_1
    L26_2 = "SELECT id FROM apex_phone_messages WHERE sender = ? AND "
    L27_2 = L21_2
    L28_2 = L23_2
    L26_2 = L26_2 .. L27_2 .. L28_2
    L27_2 = L24_2
    L25_2 = L25_2(L26_2, L27_2)
    L10_2 = L25_2
    if not L10_2 then
      L25_2 = L26_1
      L26_2 = "SELECT id FROM apex_phone_messages WHERE receiver = ? AND "
      L27_2 = L21_2
      L28_2 = " AND conversation_id IS NULL AND deleted_receiver = 0"
      L29_2 = L23_2
      L26_2 = L26_2 .. L27_2 .. L28_2 .. L29_2
      L27_2 = L24_2
      L25_2 = L25_2(L26_2, L27_2)
      L10_2 = L25_2
    end
    if not L10_2 then
      L25_2 = L20_2.number
      if L25_2 then
        L25_2 = L20_2.number
        L26_2 = L26_1
        L27_2 = [[
SELECT m.id FROM apex_phone_conversation_members cm
                JOIN apex_phone_messages m ON m.conversation_id = cm.conversation_id
                WHERE cm.member = ? AND cm.left_at IS NULL AND m.created >= cm.joined AND m.type IN ('image','audio') AND m.deleted_all IS NULL
                  AND (m.payload LIKE ? OR m.payload LIKE ? OR m.payload LIKE ?) LIMIT 1]]
        L28_2 = {}
        L29_2 = L25_2
        L30_2 = L7_2
        L31_2 = L8_2
        L32_2 = L9_2
        L28_2[1] = L29_2
        L28_2[2] = L30_2
        L28_2[3] = L31_2
        L28_2[4] = L32_2
        L26_2 = L26_2(L27_2, L28_2)
        L10_2 = L26_2
        if not L10_2 then
          L26_2 = L26_1
          L27_2 = [[
SELECT c.id FROM apex_phone_conversations c
                    JOIN apex_phone_conversation_members cm ON cm.conversation_id = c.id
                    WHERE c.avatar = ? AND cm.member = ? AND cm.left_at IS NULL LIMIT 1]]
          L28_2 = {}
          L29_2 = L2_2
          L30_2 = L25_2
          L28_2[1] = L29_2
          L28_2[2] = L30_2
          L26_2 = L26_2(L27_2, L28_2)
          L10_2 = L26_2
        end
      end
    end
  end
  if not L10_2 then
    L15_2 = L26_1
    L16_2 = "SELECT id FROM apex_phone_mail WHERE owner = ? AND (attachments LIKE ? OR attachments LIKE ? OR attachments LIKE ?) LIMIT 1"
    L17_2 = {}
    L18_2 = L3_2
    L19_2 = L7_2
    L20_2 = L8_2
    L21_2 = L9_2
    L17_2[1] = L18_2
    L17_2[2] = L19_2
    L17_2[3] = L20_2
    L17_2[4] = L21_2
    L15_2 = L15_2(L16_2, L17_2)
    L10_2 = L15_2
  end
  if not L10_2 then
    L15_2 = type
    L16_2 = RecadoMediaCanRead
    L15_2 = L15_2(L16_2)
    if "function" == L15_2 then
      L15_2 = pcall
      L16_2 = RecadoMediaCanRead
      L17_2 = A0_2
      L18_2 = L2_2
      L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
      L10_2 = L15_2 or L10_2
      L10_2 = L15_2 and true == L16_2
    end
  end
  if not L10_2 then
    L15_2 = type
    L16_2 = RecadoSocialCanSeeMedia
    L15_2 = L15_2(L16_2)
    if "function" == L15_2 then
      L15_2 = pcall
      L16_2 = RecadoSocialCanSeeMedia
      L17_2 = A0_2
      L18_2 = L2_2
      L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
      L10_2 = L15_2 or L10_2
      L10_2 = L15_2 and true == L16_2
    end
  end
  if not L10_2 then
    L15_2 = type
    L16_2 = MatchMediaCanRead
    L15_2 = L15_2(L16_2)
    if "function" == L15_2 then
      L15_2 = pcall
      L16_2 = MatchMediaCanRead
      L17_2 = A0_2
      L18_2 = L2_2
      L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
      L10_2 = L15_2 or L10_2
      L10_2 = L15_2 and true == L16_2
    end
  end
  if L10_2 then
    L15_2 = L24_1
    L16_2 = A0_2
    L17_2 = L3_2
    L18_2 = L2_2
    L15_2(L16_2, L17_2, L18_2)
  else
    L15_2 = L25_1
    L16_2 = A0_2
    L17_2 = L3_2
    L18_2 = L2_2
    L15_2(L16_2, L17_2, L18_2)
  end
  return L10_2
end
MediaCanRead = L27_1
L27_1 = RPC
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L7_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "notfound"
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A1_2.i
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 1
  end
  L4_2 = L4_2(L5_2)
  if L4_2 and not (L4_2 < 1) then
    L5_2 = L2_1
    if not (L4_2 > L5_2) then
      goto lbl_39
    end
  end
  L5_2 = {}
  L5_2.error = "badchunk"
  do return L5_2 end
  ::lbl_39::
  L5_2 = MediaInfo
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L5_2.complete
    if L6_2 then
      goto lbl_51
    end
  end
  L6_2 = {}
  L6_2.error = "notfound"
  do return L6_2 end
  ::lbl_51::
  L6_2 = type
  L7_2 = RecadoMediaDenied
  L6_2 = L6_2(L7_2)
  if "function" == L6_2 then
    L6_2 = pcall
    L7_2 = RecadoMediaDenied
    L8_2 = A0_2
    L9_2 = L3_2
    L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 and true == L7_2 then
      L8_2 = {}
      L8_2.error = "notfound"
      return L8_2
    end
  end
  L6_2 = L5_2.owner
  if L6_2 ~= L2_2 then
    L6_2 = MediaCanRead
    L7_2 = A0_2
    L8_2 = L3_2
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "notfound"
      return L6_2
    end
  end
  L6_2 = L6_1
  L6_2 = L6_2()
  L7_2 = MySQL
  L7_2 = L7_2.single
  L7_2 = L7_2.await
  L8_2 = "SELECT CHAR_LENGTH(data) AS len, SUBSTRING(data, ?, ?) AS part FROM apex_phone_media WHERE id = ? AND complete = 1"
  L9_2 = {}
  L10_2 = L4_2 - 1
  L11_2 = L6_2.chunk
  L10_2 = L10_2 * L11_2
  L10_2 = L10_2 + 1
  L11_2 = L6_2.chunk
  L12_2 = L3_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L8_2 = L12_1
    L8_2[L3_2] = nil
    L8_2 = {}
    L8_2.error = "notfound"
    return L8_2
  end
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = L7_2.len
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = 0
  end
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  L9_2 = math
  L9_2 = L9_2.max
  L10_2 = 1
  L11_2 = math
  L11_2 = L11_2.ceil
  L12_2 = L6_2.chunk
  L12_2 = L8_2 / L12_2
  L11_2 = L11_2(L12_2)
  L9_2 = L9_2(L10_2, L11_2)
  if L4_2 > L9_2 then
    L10_2 = {}
    L10_2.error = "badchunk"
    L10_2.total = L9_2
    return L10_2
  end
  L10_2 = {}
  L10_2.id = L3_2
  L11_2 = L5_2.kind
  L10_2.kind = L11_2
  L11_2 = L5_2.mime
  L10_2.mime = L11_2
  L11_2 = L5_2.duration
  L10_2.duration = L11_2
  L11_2 = L5_2.meta
  L10_2.meta = L11_2
  L10_2.i = L4_2
  L10_2.total = L9_2
  L10_2.size = L8_2
  L11_2 = L7_2.part
  if not L11_2 then
    L11_2 = ""
  end
  L10_2.data = L11_2
  return L10_2
end
L27_1["media.get"] = L28_1
L27_1 = AddEventHandler
L28_1 = "playerDropped"
function L29_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  L1_2 = L13_1
  L1_2[L0_2] = nil
  L1_2 = pairs
  L2_2 = L11_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.src
    if L7_2 == L0_2 then
      L7_2 = L11_1
      L7_2[L5_2] = nil
    end
  end
end
L27_1(L28_1, L29_1)
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = Now
  L0_2 = L0_2()
  L0_2 = L0_2 - 3600000
  L1_2 = 0
  L2_2 = 1
  L3_2 = 20
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = tonumber
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "DELETE FROM apex_phone_media WHERE complete = 0 AND created < ? LIMIT 1000"
    L9_2 = {}
    L10_2 = L0_2
    L9_2[1] = L10_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    if not L6_2 then
      L6_2 = 0
    end
    L1_2 = L1_2 + L6_2
    L7_2 = 1000
    if L6_2 < L7_2 then
      break
    end
    L7_2 = Wait
    L8_2 = 100
    L7_2(L8_2)
  end
  if L1_2 > 0 then
    L2_2 = Dbg
    L3_2 = "media"
    L4_2 = "cleanup: %d incomplete media deleted"
    L5_2 = L1_2
    L2_2(L3_2, L4_2, L5_2)
  end
end
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    return
  end
  L3_2 = A0_2
  L2_2 = A0_2.gmatch
  L4_2 = "\"mediaId\"%s*:%s*\"?(%d+)"
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = math
    L7_2 = L7_2.tointeger
    L8_2 = tonumber
    L9_2 = L6_2
    L8_2, L9_2 = L8_2(L9_2)
    L7_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      A1_2[L7_2] = nil
    end
  end
end
function L29_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = MySQL
  L7_2 = L7_2.scalar
  L7_2 = L7_2.await
  L8_2 = "SELECT MAX(id) FROM %s"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = A0_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L8_2(L9_2, L10_2)
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L6_2 = A3_2 or L6_2
  if not A3_2 then
    L6_2 = 0
  end
  while L5_2 > L6_2 do
    L7_2 = next
    L8_2 = A4_2
    L7_2 = L7_2(L8_2)
    if nil == L7_2 then
      break
    end
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = "SELECT %s AS txt FROM %s WHERE id > ? AND id <= ? AND %s"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = A1_2
    L11_2 = A0_2
    L12_2 = A2_2
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
    L9_2 = {}
    L10_2 = L6_2
    L11_2 = L6_2 + 5000
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = {}
    end
    L8_2 = ipairs
    L9_2 = L7_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = L28_1
      L15_2 = L13_2.txt
      L16_2 = A4_2
      L14_2(L15_2, L16_2)
    end
    L6_2 = L6_2 + 5000
    L8_2 = Wait
    L9_2 = 25
    L8_2(L9_2)
  end
end
L30_1 = 500
L31_1 = 4
L32_1 = 0
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT id, created FROM apex_phone_media WHERE complete = 1 AND created < ? AND id > ? ORDER BY id ASC LIMIT "
  L3_2 = L30_1
  L2_2 = L2_2 .. L3_2
  L3_2 = {}
  L4_2 = A0_2
  L5_2 = L32_1
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = #L1_2
  if 0 == L2_2 then
    L2_2 = 0
    L32_1 = L2_2
    L2_2 = false
    return L2_2
  end
  L2_2 = {}
  L3_2 = nil
  L4_2 = L32_1
  L5_2 = ipairs
  L6_2 = L1_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = math
    L11_2 = L11_2.tointeger
    L12_2 = tonumber
    L13_2 = L10_2.id
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L12_2(L13_2)
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    if L11_2 then
      L2_2[L11_2] = true
      if L4_2 < L11_2 then
        L4_2 = L11_2
      end
    end
    L12_2 = tonumber
    L13_2 = L10_2.created
    L12_2 = L12_2(L13_2)
    if L12_2 and (not L3_2 or L3_2 > L12_2) then
      L3_2 = L12_2
    end
  end
  L5_2 = #L1_2
  L6_2 = L30_1
  L5_2 = L5_2 >= L6_2
  L6_2 = L4_2 or L6_2
  if not L5_2 or not L4_2 then
    L6_2 = 0
  end
  L32_1 = L6_2
  L6_2 = 0
  if L3_2 then
    L7_2 = pcall
    L8_2 = MySQL
    L8_2 = L8_2.scalar
    L8_2 = L8_2.await
    L9_2 = "SELECT id FROM apex_phone_messages WHERE created >= ? ORDER BY id ASC LIMIT 1"
    L10_2 = {}
    L11_2 = L3_2
    L10_2[1] = L11_2
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 and L8_2 then
      L9_2 = math
      L9_2 = L9_2.max
      L10_2 = 0
      L11_2 = math
      L11_2 = L11_2.tointeger
      L12_2 = tonumber
      L13_2 = L8_2
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L12_2(L13_2)
      L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
      if not L11_2 then
        L11_2 = 1
      end
      L11_2 = L11_2 - 1
      L9_2 = L9_2(L10_2, L11_2)
      L6_2 = L9_2
    end
  end
  L7_2 = L29_1
  L8_2 = "apex_phone_messages"
  L9_2 = "payload"
  L10_2 = "type IN ('image','audio') AND payload LIKE '%\"mediaId\"%'"
  L11_2 = L6_2
  L12_2 = L2_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = next
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  if nil ~= L7_2 then
    L7_2 = pcall
    L8_2 = L29_1
    L9_2 = "apex_phone_mail"
    L10_2 = "attachments"
    L11_2 = "attachments LIKE '%\"mediaId\"%'"
    L12_2 = 0
    L13_2 = L2_2
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  end
  L7_2 = next
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  if nil ~= L7_2 then
    L7_2 = {}
    L8_2 = pairs
    L9_2 = L2_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2 in L8_2, L9_2, L10_2, L11_2 do
      L13_2 = #L7_2
      L13_2 = L13_2 + 1
      L7_2[L13_2] = L12_2
    end
    L8_2 = pcall
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "SELECT avatar FROM apex_phone_conversations WHERE avatar IN (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = string
    L12_2 = L12_2.rep
    L13_2 = "?"
    L14_2 = #L7_2
    L15_2 = ", "
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L12_2(L13_2, L14_2, L15_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L11_2 = L7_2
    L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
    if L8_2 then
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = ipairs
        L11_2 = L9_2
        L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
        for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
          L16_2 = math
          L16_2 = L16_2.tointeger
          L17_2 = tonumber
          L18_2 = L15_2.avatar
          L17_2, L18_2 = L17_2(L18_2)
          L16_2 = L16_2(L17_2, L18_2)
          if L16_2 then
            L2_2[L16_2] = nil
          end
        end
      end
    end
  end
  L7_2 = next
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  if nil ~= L7_2 then
    L7_2 = {}
    L8_2 = pairs
    L9_2 = L2_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2 in L8_2, L9_2, L10_2, L11_2 do
      L13_2 = #L7_2
      L13_2 = L13_2 + 1
      L7_2[L13_2] = L12_2
    end
    L8_2 = pcall
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "SELECT avatar_media FROM apex_phone_recado_profiles WHERE avatar_media IN (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = string
    L12_2 = L12_2.rep
    L13_2 = "?"
    L14_2 = #L7_2
    L15_2 = ", "
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L12_2(L13_2, L14_2, L15_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L11_2 = L7_2
    L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
    if L8_2 then
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = ipairs
        L11_2 = L9_2
        L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
        for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
          L16_2 = math
          L16_2 = L16_2.tointeger
          L17_2 = tonumber
          L18_2 = L15_2.avatar_media
          L17_2, L18_2 = L17_2(L18_2)
          L16_2 = L16_2(L17_2, L18_2)
          if L16_2 then
            L2_2[L16_2] = nil
          end
        end
      end
    end
  end
  L7_2 = next
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  if nil ~= L7_2 then
    L7_2 = type
    L8_2 = RecadoSocialMediaRefs
    L7_2 = L7_2(L8_2)
    if "function" == L7_2 then
      L7_2 = pcall
      L8_2 = RecadoSocialMediaRefs
      L9_2 = L2_2
      L7_2(L8_2, L9_2)
    end
  end
  L7_2 = {}
  L8_2 = pairs
  L9_2 = L2_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2 in L8_2, L9_2, L10_2, L11_2 do
    L13_2 = #L7_2
    L13_2 = L13_2 + 1
    L7_2[L13_2] = L12_2
  end
  L8_2 = #L7_2
  if 0 == L8_2 then
    return L5_2
  end
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L9_2 = ipairs
  L10_2 = L7_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = #L8_2
    L15_2 = L15_2 + 1
    L8_2[L15_2] = L14_2
  end
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = "DELETE FROM apex_phone_media WHERE complete = 1 AND created < ? AND id IN (%s)"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = string
  L12_2 = L12_2.rep
  L13_2 = "?"
  L14_2 = #L7_2
  L15_2 = ", "
  L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L12_2(L13_2, L14_2, L15_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L11_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = ipairs
  L11_2 = L7_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L12_1
    L16_2[L15_2] = nil
  end
  L10_2 = Dbg
  L11_2 = "media"
  L12_2 = "cleanup: %s old unreferenced media deleted"
  L13_2 = tostring
  L14_2 = L9_2
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L13_2(L14_2)
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  return L5_2
end
function L34_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = L6_1
  L0_2 = L0_2()
  L1_2 = L0_2.keepDays
  if L1_2 <= 0 then
    return
  end
  L1_2 = Now
  L1_2 = L1_2()
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L0_2.keepDays
  L3_2 = L3_2 * 86400000
  L2_2 = L2_2(L3_2)
  L1_2 = L1_2 - L2_2
  L2_2 = 1
  L3_2 = L31_1
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = L33_1
    L7_2 = L1_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      break
    end
    L6_2 = L31_1
    if L5_2 < L6_2 then
      L6_2 = Wait
      L7_2 = 1000
      L6_2(L7_2)
    end
  end
end
L35_1 = CreateThread
function L36_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  while true do
    L0_2 = DBReady
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 90000
  L0_2(L1_2)
  L0_2 = 0
  while true do
    L1_2 = os
    L1_2 = L1_2.time
    L1_2 = L1_2()
    L2_2 = pairs
    L3_2 = L11_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L7_2.t
      L8_2 = L1_2 - L8_2
      L9_2 = L4_1
      if L8_2 > L9_2 then
        L8_2 = L11_1
        L8_2[L6_2] = nil
      end
    end
    L2_2 = pairs
    L3_2 = L12_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L7_2.t
      if not L8_2 then
        L8_2 = 0
      end
      L8_2 = L1_2 - L8_2
      L9_2 = 1800
      if L8_2 > L9_2 then
        L8_2 = L12_1
        L8_2[L6_2] = nil
      end
    end
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L3_2 = pairs
    L4_2 = L13_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = pairs
      L10_2 = L8_2.ids
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
        if L14_2 <= L2_2 then
          L15_2 = L8_2.ids
          L15_2[L13_2] = nil
        end
      end
      L9_2 = pairs
      L10_2 = L8_2.deny
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
        if L14_2 <= L2_2 then
          L15_2 = L8_2.deny
          L15_2[L13_2] = nil
        end
      end
      L9_2 = next
      L10_2 = L8_2.ids
      L9_2 = L9_2(L10_2)
      if nil == L9_2 then
        L9_2 = next
        L10_2 = L8_2.deny
        L9_2 = L9_2(L10_2)
        if nil == L9_2 then
          L9_2 = L13_1
          L9_2[L7_2] = nil
        end
      end
    end
    L3_2 = pcall
    L4_2 = L27_1
    L3_2, L4_2 = L3_2(L4_2)
    if not L3_2 then
      L5_2 = print
      L6_2 = "^3[unique_phone]^0 incomplete media cleanup: %s"
      L7_2 = L6_2
      L6_2 = L6_2.format
      L8_2 = tostring
      L9_2 = L4_2
      L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L8_2(L9_2)
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    end
    L5_2 = L1_2 - L0_2
    L6_2 = 21600
    if L5_2 >= L6_2 then
      L0_2 = L1_2
      L5_2 = pcall
      L6_2 = L34_1
      L5_2, L6_2 = L5_2(L6_2)
      if not L5_2 then
        L7_2 = print
        L8_2 = "^3[unique_phone]^0 old media cleanup: %s"
        L9_2 = L8_2
        L8_2 = L8_2.format
        L10_2 = tostring
        L11_2 = L6_2
        L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L10_2(L11_2)
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      end
    end
    L5_2 = Wait
    L6_2 = 600000
    L5_2(L6_2)
  end
end
L35_1(L36_1)
