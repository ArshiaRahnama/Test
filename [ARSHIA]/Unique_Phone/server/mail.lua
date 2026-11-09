local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1
L0_1 = {}
L0_1.inbox = true
L0_1.sent = true
L0_1.drafts = true
L0_1.trash = true
L0_1.archive = true
L1_1 = "id, owner, sender, email, subject, body, `read`, folder, created, recipient, attachments, flagged"
L2_1 = 30
L3_1 = 100
L4_1 = "{\"src\":\"mail\""
L5_1 = {}
L5_1["image/jpeg"] = true
L5_1["image/png"] = true
L5_1["image/webp"] = true
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 and L1_2 == L1_2 then
    L2_2 = math
    L2_2 = L2_2.huge
    if L1_2 ~= L2_2 then
      L2_2 = math
      L2_2 = L2_2.huge
      L2_2 = -L2_2
      if L1_2 ~= L2_2 then
        goto lbl_19
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_19::
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = L1_2
  L3_2, L4_2 = L3_2(L4_2)
  return L2_2(L3_2, L4_2)
end
function L7_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2 or "1" == A0_2
  return L1_2
end
function L8_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2
  L5_2 = Config
  L5_2 = L5_2[A0_2]
  L6_2 = L6_1
  L7_2 = type
  L8_2 = L5_2
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = L5_2[A1_2]
    if L7_2 then
      goto lbl_13
    end
  end
  L7_2 = nil
  ::lbl_13::
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = A2_2
  end
  if A3_2 > L6_2 then
    L6_2 = A3_2
  elseif A4_2 < L6_2 then
    L6_2 = A4_2
  end
  return L6_2
end
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L8_1
  L1_2 = "Mail"
  L2_2 = "maxAttachments"
  L3_2 = 4
  L4_2 = 0
  L5_2 = 10
  return L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
end
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L8_1
  L1_2 = "Mail"
  L2_2 = "draftsMax"
  L3_2 = 50
  L4_2 = 1
  L5_2 = 500
  return L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
end
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L8_1
  L1_2 = "Media"
  L2_2 = "chunkBytes"
  L3_2 = 48000
  L4_2 = 8000
  L5_2 = 60000
  return L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
end
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L8_1
  L1_2 = "Media"
  L2_2 = "maxImageBytes"
  L3_2 = L6_1
  L4_2 = Config
  L4_2 = L4_2.PhotoMaxBytes
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 260000
  end
  L4_2 = 1000
  L5_2 = 4000000
  return L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if nil == A0_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = 1
  L4_2 = 3
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = utf8
    L7_2 = L7_2.len
    L8_2 = L2_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      break
    end
    L8_2 = L2_2
    L7_2 = L2_2.sub
    L9_2 = 1
    L10_2 = -2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L2_2 = L7_2
  end
  return L2_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 or "number" == L1_2 then
    L2_2 = tostring
    L3_2 = A0_2
    return L2_2(L3_2)
  end
  L2_2 = ""
  return L2_2
end
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 and "number" ~= L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "%c"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L5_2 = L3_2
  L4_2 = L3_2.match
  L6_2 = "^%s*(.-)%s*$"
  L4_2 = L4_2(L5_2, L6_2)
  L3_2 = L4_2
  L4_2 = L13_1
  L5_2 = L3_2
  L6_2 = A1_2
  return L4_2(L5_2, L6_2)
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "[!%%_]"
  L4_2 = "!%0"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "[%c\"\\]"
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    if "\"" == A0_3 then
      L1_3 = "\\\""
      return L1_3
    end
    if "\\" == A0_3 then
      L1_3 = "\\\\"
      return L1_3
    end
    if "\n" == A0_3 then
      L1_3 = "\\n"
      return L1_3
    end
    if "\r" == A0_3 then
      L1_3 = "\\r"
      return L1_3
    end
    if "\t" == A0_3 then
      L1_3 = "\\t"
      return L1_3
    end
    L1_3 = string
    L1_3 = L1_3.format
    L2_3 = "\\u%04x"
    L4_3 = A0_3
    L3_3 = A0_3.byte
    L3_3, L4_3 = L3_3(L4_3)
    return L1_3(L2_3, L3_3, L4_3)
  end
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = "\""
  L3_2 = L1_2
  L4_2 = "\""
  L2_2 = L2_2 .. L3_2 .. L4_2
  return L2_2
end
L18_1 = {}
L19_1 = "type"
L20_1 = "mediaId"
L21_1 = "kind"
L22_1 = "mime"
L23_1 = "size"
L24_1 = "duration"
L25_1 = "url"
L26_1 = "seed"
L27_1 = "x"
L28_1 = "y"
L29_1 = "label"
L30_1 = "name"
L31_1 = "number"
L18_1[1] = L19_1
L18_1[2] = L20_1
L18_1[3] = L21_1
L18_1[4] = L22_1
L18_1[5] = L23_1
L18_1[6] = L24_1
L18_1[7] = L25_1
L18_1[8] = L26_1
L18_1[9] = L27_1
L18_1[10] = L28_1
L18_1[11] = L29_1
L18_1[12] = L30_1
L18_1[13] = L31_1
L19_1 = {}
L19_1.x = true
L19_1.y = true
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = #A0_2
    if 0 ~= L1_2 then
      goto lbl_11
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_11::
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = {}
    L9_2 = ipairs
    L10_2 = L18_1
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = L7_2[L14_2]
      L16_2 = type
      L17_2 = L15_2
      L16_2 = L16_2(L17_2)
      if "number" == L16_2 then
        L16_2 = #L8_2
        L16_2 = L16_2 + 1
        L17_2 = "\""
        L18_2 = L14_2
        L19_2 = "\":"
        L20_2 = L19_1
        L20_2 = L20_2[L14_2]
        if L20_2 then
          L20_2 = string
          L20_2 = L20_2.format
          L21_2 = "%.2f"
          L22_2 = L15_2
          L20_2 = L20_2(L21_2, L22_2)
          if L20_2 then
            goto lbl_57
          end
        end
        L20_2 = string
        L20_2 = L20_2.format
        L21_2 = "%d"
        L22_2 = math
        L22_2 = L22_2.tointeger
        L23_2 = L15_2
        L22_2 = L22_2(L23_2)
        if not L22_2 then
          L22_2 = 0
        end
        L20_2 = L20_2(L21_2, L22_2)
        ::lbl_57::
        L17_2 = L17_2 .. L18_2 .. L19_2 .. L20_2
        L8_2[L16_2] = L17_2
      else
        L16_2 = type
        L17_2 = L15_2
        L16_2 = L16_2(L17_2)
        if "string" == L16_2 then
          L16_2 = #L8_2
          L16_2 = L16_2 + 1
          L17_2 = "\""
          L18_2 = L14_2
          L19_2 = "\":"
          L20_2 = L17_1
          L21_2 = L15_2
          L20_2 = L20_2(L21_2)
          L17_2 = L17_2 .. L18_2 .. L19_2 .. L20_2
          L8_2[L16_2] = L17_2
        end
      end
    end
    L9_2 = "{"
    L10_2 = table
    L10_2 = L10_2.concat
    L11_2 = L8_2
    L12_2 = ","
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = "}"
    L9_2 = L9_2 .. L10_2 .. L11_2
    L1_2[L6_2] = L9_2
  end
  L2_2 = "["
  L3_2 = table
  L3_2 = L3_2.concat
  L4_2 = L1_2
  L5_2 = ","
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = "]"
  L2_2 = L2_2 .. L3_2 .. L4_2
  return L2_2
end
function L21_1(A0_2)
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
    if "table" == L3_2 then
      L3_2 = #L2_2
      if 0 ~= L3_2 then
        goto lbl_27
      end
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_27::
  return L2_2
end
function L22_1(A0_2)
  local L1_2, L2_2
  L1_2 = L7_1
  L2_2 = A0_2.read
  L1_2 = L1_2(L2_2)
  A0_2.read = L1_2
  L1_2 = L7_1
  L2_2 = A0_2.flagged
  L1_2 = L1_2(L2_2)
  A0_2.flagged = L1_2
  L1_2 = L21_1
  L2_2 = A0_2.attachments
  L1_2 = L1_2(L2_2)
  A0_2.attachments = L1_2
  return A0_2
end
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = "\"mediaId\":"
  L2_2 = string
  L2_2 = L2_2.format
  L3_2 = "%d"
  L4_2 = A0_2
  L2_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2 .. L2_2
  return L1_2
end
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  A1_2 = L2_2
  if not (A0_2 and A1_2) or A1_2 < 1 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L23_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT id FROM apex_phone_mail WHERE owner = ? AND (attachments LIKE ? OR attachments LIKE ?) LIMIT 1"
  L5_2 = {}
  L6_2 = tostring
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = "%"
  L8_2 = L2_2
  L9_2 = ",%"
  L7_2 = L7_2 .. L8_2 .. L9_2
  L8_2 = "%"
  L9_2 = L2_2
  L10_2 = "}%"
  L8_2 = L8_2 .. L9_2 .. L10_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = nil ~= L3_2
  return L4_2
end
MailCanReadMedia = L24_1
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = {}
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return L1_2
  end
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L6_1
      L9_2 = L7_2.mediaId
      L8_2 = L8_2(L9_2)
      if L8_2 then
        goto lbl_24
      end
    end
    L8_2 = nil
    ::lbl_24::
    if L8_2 and L8_2 > 0 then
      L1_2[L8_2] = true
    end
  end
  return L1_2
end
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    if A1_2 then
      L7_2 = A1_2[L6_2]
      if L7_2 then
        goto lbl_33
      end
    end
    L7_2 = L23_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "DELETE FROM apex_phone_media WHERE id = ? AND meta LIKE ? AND NOT EXISTS (SELECT 1 FROM apex_phone_mail WHERE attachments LIKE ? OR attachments LIKE ?)"
    L10_2 = {}
    L11_2 = L6_2
    L12_2 = L4_1
    L13_2 = "%"
    L12_2 = L12_2 .. L13_2
    L13_2 = "%"
    L14_2 = L7_2
    L15_2 = ",%"
    L13_2 = L13_2 .. L14_2 .. L15_2
    L14_2 = "%"
    L15_2 = L7_2
    L16_2 = "}%"
    L14_2 = L14_2 .. L15_2 .. L16_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L10_2[4] = L14_2
    L8_2(L9_2, L10_2)
    ::lbl_33::
  end
end
function L26_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = next
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if nil == L2_2 then
    return
  end
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = pcall
    L1_3 = L25_1
    L2_3 = A0_2
    L3_3 = A1_2
    L0_3, L1_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L2_3 = print
      L3_3 = "^3[unique_phone]^0 mail: attachment cleanup failed (%s)"
      L4_3 = L3_3
      L3_3 = L3_3.format
      L5_3 = tostring
      L6_3 = L1_3
      L5_3, L6_3 = L5_3(L6_3)
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
      L2_3(L3_3, L4_3, L5_3, L6_3)
    end
  end
  L2_2(L3_2)
end
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT id, owner, kind, mime, size, duration, complete FROM apex_phone_media WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L7_1
    L5_2 = L3_2.complete
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_19
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_19::
  L4_2 = A2_2.system
  if not L4_2 then
    if not A0_2 then
      goto lbl_28
    end
    L4_2 = L3_2.owner
    if L4_2 ~= A0_2 then
      goto lbl_28
    end
  end
  do return L3_2 end
  ::lbl_28::
  if A0_2 then
    L4_2 = MailCanReadMedia
    L5_2 = A0_2
    L6_2 = A1_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      return L3_2
    end
  end
  L4_2 = A2_2.src
  if L4_2 then
    L4_2 = type
    L5_2 = MediaCanRead
    L4_2 = L4_2(L5_2)
    if "function" == L4_2 then
      L4_2 = pcall
      L5_2 = MediaCanRead
      L6_2 = A2_2.src
      L7_2 = A1_2
      L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
      if L4_2 and L5_2 then
        return L3_2
      end
    end
  end
  L4_2 = nil
  return L4_2
end
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.scalar
  L2_2 = L2_2.await
  L3_2 = "SELECT id FROM apex_phone_photos WHERE owner = ? AND url = ? LIMIT 1"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = "%\"url\":"
  L3_2 = L16_1
  L4_2 = L17_1
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = "%"
  L2_2 = L2_2 .. L3_2 .. L4_2
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT id FROM apex_phone_mail WHERE owner = ? AND attachments LIKE ? ESCAPE '!' LIMIT 1"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = nil ~= L3_2
  return L3_2
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT id, video, seed, CHAR_LENGTH(url) AS len, LEFT(url, 64) AS head, CASE WHEN url LIKE 'data:%' THEN NULL ELSE url END AS link FROM apex_phone_photos WHERE id = ? AND owner = ?"
  L4_2 = {}
  L5_2 = A1_2
  L6_2 = A0_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = "photo"
    return L3_2, L4_2
  end
  L3_2 = L7_1
  L4_2 = L2_2.video
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L3_2 = nil
    L4_2 = "video"
    return L3_2, L4_2
  end
  L3_2 = type
  L4_2 = L2_2.link
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = L2_2.link
    if "" ~= L3_2 then
      L3_2 = L2_2.link
      L3_2 = #L3_2
      L4_2 = 512
      if L3_2 <= L4_2 then
        L3_2 = L2_2.link
        L4_2 = L3_2
        L3_2 = L3_2.match
        L5_2 = "^https?://"
        L3_2 = L3_2(L4_2, L5_2)
        if L3_2 then
          L3_2 = L2_2.link
          L4_2 = L3_2
          L3_2 = L3_2.find
          L5_2 = "[%s\"'<>\\]"
          L3_2 = L3_2(L4_2, L5_2)
          if not L3_2 then
            L3_2 = {}
            L3_2.type = "photo"
            L4_2 = L2_2.link
            L3_2.url = L4_2
            return L3_2
          end
        end
      end
      L3_2 = nil
      L4_2 = "photo"
      return L3_2, L4_2
    end
  end
  L3_2 = L6_1
  L4_2 = L2_2.len
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  if L3_2 <= 0 then
    L4_2 = L6_1
    L5_2 = L2_2.seed
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L5_2 = {}
      L5_2.type = "photo"
      L5_2.seed = L4_2
      return L5_2
    end
    L5_2 = nil
    L6_2 = "photo"
    return L5_2, L6_2
  end
  L4_2 = type
  L5_2 = L2_2.head
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L2_2.head
    L5_2 = L4_2
    L4_2 = L4_2.match
    L6_2 = "^data:(image/[%w%.%+%-]+);base64,"
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      goto lbl_91
    end
  end
  L4_2 = nil
  ::lbl_91::
  if L4_2 then
    L5_2 = L5_1
    L5_2 = L5_2[L4_2]
    if L5_2 then
      goto lbl_100
    end
  end
  L5_2 = nil
  L6_2 = "photo"
  do return L5_2, L6_2 end
  ::lbl_100::
  L5_2 = L12_1
  L5_2 = L5_2()
  if L3_2 > L5_2 then
    L5_2 = nil
    L6_2 = "toolarge"
    return L5_2, L6_2
  end
  L5_2 = L4_1
  L6_2 = ",\"photo\":"
  L7_2 = string
  L7_2 = L7_2.format
  L8_2 = "%d"
  L9_2 = A1_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = "}"
  L5_2 = L5_2 .. L6_2 .. L7_2 .. L8_2
  L6_2 = MySQL
  L6_2 = L6_2.single
  L6_2 = L6_2.await
  L7_2 = "SELECT id, mime, size FROM apex_phone_media WHERE owner = ? AND meta = ? AND kind = 'image' AND complete = 1 ORDER BY id DESC LIMIT 1"
  L8_2 = {}
  L9_2 = A0_2
  L10_2 = L5_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L7_2 = L6_1
    L8_2 = L6_2.id
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_134
    end
  end
  L7_2 = nil
  ::lbl_134::
  if L7_2 and L7_2 > 0 then
    L8_2 = {}
    L8_2.type = "photo"
    L8_2.mediaId = L7_2
    L9_2 = L13_1
    L10_2 = L6_2.mime
    L11_2 = 40
    L9_2 = L9_2(L10_2, L11_2)
    if not L9_2 then
      L9_2 = L4_2
    end
    L8_2.mime = L9_2
    L9_2 = L6_1
    L10_2 = L6_2.size
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = L3_2
    end
    L8_2.size = L9_2
    L9_2 = nil
    L10_2 = false
    return L8_2, L9_2, L10_2
  end
  L8_2 = L6_1
  L9_2 = MySQL
  L9_2 = L9_2.insert
  L9_2 = L9_2.await
  L10_2 = "INSERT INTO apex_phone_media (owner, kind, mime, data, size, meta, complete, created) SELECT ?, 'image', ?, url, CHAR_LENGTH(url), ?, 1, ? FROM apex_phone_photos WHERE id = ? AND owner = ?"
  L11_2 = {}
  L12_2 = A0_2
  L13_2 = L4_2
  L14_2 = L5_2
  L15_2 = Now
  L15_2 = L15_2()
  L16_2 = A1_2
  L17_2 = A0_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L9_2(L10_2, L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  if not L8_2 or L8_2 < 1 then
    L9_2 = nil
    L10_2 = "photo"
    return L9_2, L10_2
  end
  L9_2 = {}
  L9_2.type = "photo"
  L9_2.mediaId = L8_2
  L9_2.mime = L4_2
  L9_2.size = L3_2
  L10_2 = nil
  L11_2 = true
  return L9_2, L10_2, L11_2
end
function L30_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 or not A2_2 then
    L3_2 = {}
    A2_2 = L3_2
  end
  if nil == A0_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = nil
    L4_2 = "type"
    L5_2 = 0
    return L3_2, L4_2, L5_2
  end
  L3_2 = #A0_2
  L4_2 = 0
  L5_2 = pairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2 in L5_2, L6_2, L7_2, L8_2 do
    L4_2 = L4_2 + 1
  end
  if L4_2 ~= L3_2 then
    L5_2 = nil
    L6_2 = "type"
    L7_2 = 0
    return L5_2, L6_2, L7_2
  end
  if 0 == L3_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L9_1
  L5_2 = L5_2()
  if L3_2 > L5_2 then
    L5_2 = nil
    L6_2 = "toomany"
    L7_2 = L3_2
    return L5_2, L6_2, L7_2
  end
  L5_2 = {}
  L6_2 = {}
  function L7_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L2_3 = ipairs
    L3_3 = L6_2
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = pcall
      L9_3 = MySQL
      L9_3 = L9_3.query
      L9_3 = L9_3.await
      L10_3 = "DELETE FROM apex_phone_media WHERE id = ?"
      L11_3 = {}
      L12_3 = L7_3
      L11_3[1] = L12_3
      L8_3(L9_3, L10_3, L11_3)
    end
    L2_3 = nil
    L3_3 = A0_3
    L4_3 = A1_3
    return L2_3, L3_3, L4_3
  end
  L8_2 = 1
  L9_2 = L3_2
  L10_2 = 1
  for L11_2 = L8_2, L9_2, L10_2 do
    L12_2 = A0_2[L11_2]
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" ~= L13_2 then
      L13_2 = L7_2
      L14_2 = "type"
      L15_2 = L11_2
      return L13_2(L14_2, L15_2)
    end
    L13_2 = L12_2.type
    if "photo" == L13_2 then
      L14_2 = L6_1
      L15_2 = L12_2.mediaId
      L14_2 = L14_2(L15_2)
      L15_2 = L6_1
      L16_2 = L12_2.id
      if not L16_2 then
        L16_2 = L12_2.photoId
      end
      L15_2 = L15_2(L16_2)
      if L14_2 and L14_2 > 0 then
        L16_2 = L27_1
        L17_2 = A1_2
        L18_2 = L14_2
        L19_2 = A2_2
        L16_2 = L16_2(L17_2, L18_2, L19_2)
        if L16_2 then
          L17_2 = L16_2.kind
          if "image" == L17_2 then
            goto lbl_104
          end
        end
        L17_2 = L7_2
        L18_2 = "photo"
        L19_2 = L11_2
        do return L17_2(L18_2, L19_2) end
        ::lbl_104::
        L17_2 = {}
        L17_2.type = "photo"
        L17_2.mediaId = L14_2
        L18_2 = L13_1
        L19_2 = L16_2.mime
        L20_2 = 40
        L18_2 = L18_2(L19_2, L20_2)
        L17_2.mime = L18_2
        L18_2 = L6_1
        L19_2 = L16_2.size
        L18_2 = L18_2(L19_2)
        if not L18_2 then
          L18_2 = 0
        end
        L17_2.size = L18_2
        L5_2[L11_2] = L17_2
      elseif L15_2 and L15_2 > 0 then
        L16_2 = A2_2.system
        if L16_2 or not A1_2 then
          L16_2 = L7_2
          L17_2 = "photo"
          L18_2 = L11_2
          return L16_2(L17_2, L18_2)
        end
        L16_2 = L29_1
        L17_2 = A1_2
        L18_2 = L15_2
        L16_2, L17_2, L18_2 = L16_2(L17_2, L18_2)
        if not L16_2 then
          L19_2 = L7_2
          L20_2 = L17_2 or L20_2
          if not L17_2 then
            L20_2 = "photo"
          end
          L21_2 = L11_2
          return L19_2(L20_2, L21_2)
        end
        L19_2 = L16_2.mediaId
        if L19_2 and L18_2 then
          L19_2 = #L6_2
          L19_2 = L19_2 + 1
          L20_2 = L16_2.mediaId
          L6_2[L19_2] = L20_2
        end
        L5_2[L11_2] = L16_2
      else
        L16_2 = type
        L17_2 = L12_2.url
        L16_2 = L16_2(L17_2)
        if "string" == L16_2 then
          L16_2 = L12_2.url
          L17_2 = #L16_2
          L18_2 = 512
          if not (L17_2 > L18_2) then
            L18_2 = L16_2
            L17_2 = L16_2.match
            L19_2 = "^https?://"
            L17_2 = L17_2(L18_2, L19_2)
            if L17_2 then
              L18_2 = L16_2
              L17_2 = L16_2.find
              L19_2 = "[%s\"'<>\\]"
              L17_2 = L17_2(L18_2, L19_2)
              if not L17_2 then
                goto lbl_186
              end
            end
          end
          L17_2 = L7_2
          L18_2 = "photo"
          L19_2 = L11_2
          do return L17_2(L18_2, L19_2) end
          ::lbl_186::
          L17_2 = A2_2.system
          if not L17_2 then
            if A1_2 then
              L17_2 = L28_1
              L18_2 = A1_2
              L19_2 = L16_2
              L17_2 = L17_2(L18_2, L19_2)
              if L17_2 then
                goto lbl_202
              end
            end
            L17_2 = L7_2
            L18_2 = "photo"
            L19_2 = L11_2
            return L17_2(L18_2, L19_2)
          end
          ::lbl_202::
          L17_2 = {}
          L17_2.type = "photo"
          L17_2.url = L16_2
          L5_2[L11_2] = L17_2
        else
          L16_2 = L6_1
          L17_2 = L12_2.seed
          L16_2 = L16_2(L17_2)
          if L16_2 then
            L16_2 = {}
            L16_2.type = "photo"
            L17_2 = math
            L17_2 = L17_2.max
            L18_2 = 0
            L19_2 = math
            L19_2 = L19_2.min
            L20_2 = 1000000
            L21_2 = L6_1
            L22_2 = L12_2.seed
            L21_2 = L21_2(L22_2)
            L19_2 = L19_2(L20_2, L21_2)
            L17_2 = L17_2(L18_2, L19_2)
            L16_2.seed = L17_2
            L5_2[L11_2] = L16_2
          else
            L16_2 = L7_2
            L17_2 = "photo"
            L18_2 = L11_2
            return L16_2(L17_2, L18_2)
          end
        end
      end
    elseif "location" == L13_2 then
      L14_2 = tonumber
      L15_2 = L12_2.x
      L14_2 = L14_2(L15_2)
      L15_2 = tonumber
      L16_2 = L12_2.y
      L15_2 = L15_2(L16_2)
      if L14_2 and L15_2 and L14_2 == L14_2 and L15_2 == L15_2 then
        L16_2 = math
        L16_2 = L16_2.abs
        L17_2 = L14_2
        L16_2 = L16_2(L17_2)
        L17_2 = 20000
        if not (L16_2 > L17_2) then
          L16_2 = math
          L16_2 = L16_2.abs
          L17_2 = L15_2
          L16_2 = L16_2(L17_2)
          L17_2 = 20000
          if not (L16_2 > L17_2) then
            goto lbl_271
          end
        end
      end
      L16_2 = L7_2
      L17_2 = "location"
      L18_2 = L11_2
      do return L16_2(L17_2, L18_2) end
      ::lbl_271::
      L16_2 = L15_1
      L17_2 = L12_2.label
      L18_2 = 64
      L16_2 = L16_2(L17_2, L18_2)
      if not L16_2 or "" == L16_2 then
        L16_2 = "Localiza\195\167\195\163o"
      end
      L17_2 = {}
      L17_2.type = "location"
      L18_2 = math
      L18_2 = L18_2.floor
      L19_2 = L14_2 * 100
      L19_2 = L19_2 + 0.5
      L18_2 = L18_2(L19_2)
      L18_2 = L18_2 / 100
      L17_2.x = L18_2
      L18_2 = math
      L18_2 = L18_2.floor
      L19_2 = L15_2 * 100
      L19_2 = L19_2 + 0.5
      L18_2 = L18_2(L19_2)
      L18_2 = L18_2 / 100
      L17_2.y = L18_2
      L17_2.label = L16_2
      L5_2[L11_2] = L17_2
    elseif "contact" == L13_2 then
      L14_2 = L15_1
      L15_2 = L12_2.name
      L16_2 = 64
      L14_2 = L14_2(L15_2, L16_2)
      L15_2 = L15_1
      L16_2 = L12_2.number
      L17_2 = 20
      L15_2 = L15_2(L16_2, L17_2)
      if L14_2 and "" ~= L14_2 and L15_2 then
        L17_2 = L15_2
        L16_2 = L15_2.match
        L18_2 = "^[%d%+%-%s%(%)]+$"
        L16_2 = L16_2(L17_2, L18_2)
        if L16_2 then
          L17_2 = L15_2
          L16_2 = L15_2.find
          L18_2 = "%d"
          L16_2 = L16_2(L17_2, L18_2)
          if L16_2 then
            goto lbl_337
          end
        end
      end
      L16_2 = L7_2
      L17_2 = "contact"
      L18_2 = L11_2
      do return L16_2(L17_2, L18_2) end
      ::lbl_337::
      L16_2 = {}
      L16_2.type = "contact"
      L16_2.name = L14_2
      L16_2.number = L15_2
      L5_2[L11_2] = L16_2
    elseif "media" == L13_2 then
      L14_2 = L6_1
      L15_2 = L12_2.mediaId
      L14_2 = L14_2(L15_2)
      if L14_2 and L14_2 > 0 then
        L15_2 = L27_1
        L16_2 = A1_2
        L17_2 = L14_2
        L18_2 = A2_2
        L15_2 = L15_2(L16_2, L17_2, L18_2)
        if L15_2 then
          goto lbl_361
        end
      end
      L15_2 = nil
      ::lbl_361::
      if L15_2 then
        L16_2 = L15_2.kind
        if "image" == L16_2 then
          goto lbl_374
        end
        L16_2 = L15_2.kind
        if "audio" == L16_2 then
          goto lbl_374
        end
      end
      L16_2 = L7_2
      L17_2 = "media"
      L18_2 = L11_2
      do return L16_2(L17_2, L18_2) end
      ::lbl_374::
      L16_2 = {}
      L16_2.type = "media"
      L16_2.mediaId = L14_2
      L17_2 = L15_2.kind
      L16_2.kind = L17_2
      L17_2 = L13_1
      L18_2 = L15_2.mime
      L19_2 = 40
      L17_2 = L17_2(L18_2, L19_2)
      L16_2.mime = L17_2
      L17_2 = L6_1
      L18_2 = L15_2.size
      L17_2 = L17_2(L18_2)
      if not L17_2 then
        L17_2 = 0
      end
      L16_2.size = L17_2
      L17_2 = L6_1
      L18_2 = L15_2.duration
      L17_2 = L17_2(L18_2)
      L16_2.duration = L17_2
      L5_2[L11_2] = L16_2
    else
      L14_2 = L7_2
      L15_2 = "type"
      L16_2 = L11_2
      return L14_2(L15_2, L16_2)
    end
  end
  L8_2 = L20_1
  L9_2 = L5_2
  L8_2 = L8_2(L9_2)
  if L8_2 then
    L9_2 = #L8_2
    L10_2 = 60000
    if L9_2 > L10_2 then
      L9_2 = L7_2
      L10_2 = "toolarge"
      L11_2 = 0
      return L9_2(L10_2, L11_2)
    end
  end
  return L5_2
end
CleanMailAttachments = L30_1
function L30_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = {}
  L2_2.ok = false
  L2_2.error = "attachments"
  L2_2.reason = A0_2
  L2_2.index = A1_2
  L3_2 = L9_1
  L3_2 = L3_2()
  L2_2.max = L3_2
  return L2_2
end
L31_1 = RPC
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2.folder
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.folder
    if L3_2 then
      goto lbl_19
    end
  end
  L3_2 = nil
  ::lbl_19::
  L4_2 = A1_2.flagged
  L4_2 = true == L4_2
  if not L3_2 and not L4_2 then
    L5_2 = MySQL
    L5_2 = L5_2.query
    L5_2 = L5_2.await
    L6_2 = "SELECT "
    L7_2 = L1_1
    L8_2 = " FROM apex_phone_mail WHERE owner = ? ORDER BY created DESC LIMIT 200"
    L6_2 = L6_2 .. L7_2 .. L8_2
    L7_2 = {}
    L8_2 = L2_2
    L7_2[1] = L8_2
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = {}
    end
    L6_2 = ipairs
    L7_2 = L5_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = L22_1
      L13_2 = L11_2
      L12_2(L13_2)
    end
    return L5_2
  end
  if L3_2 then
    L5_2 = L0_1
    L5_2 = L5_2[L3_2]
    if not L5_2 then
      L5_2 = {}
      L5_2.error = "folder"
      return L5_2
    end
  end
  L5_2 = {}
  L6_2 = "owner = ?"
  L5_2[1] = L6_2
  L6_2 = {}
  L7_2 = L2_2
  L6_2[1] = L7_2
  if L3_2 then
    L7_2 = #L5_2
    L7_2 = L7_2 + 1
    L5_2[L7_2] = "folder = ?"
    L7_2 = #L6_2
    L7_2 = L7_2 + 1
    L6_2[L7_2] = L3_2
  else
    L7_2 = #L5_2
    L7_2 = L7_2 + 1
    L5_2[L7_2] = "folder <> 'trash'"
  end
  if L4_2 then
    L7_2 = #L5_2
    L7_2 = L7_2 + 1
    L5_2[L7_2] = "flagged = 1"
  end
  L7_2 = L6_1
  L8_2 = A1_2.before
  L7_2 = L7_2(L8_2)
  if L7_2 and L7_2 > 0 then
    L8_2 = MySQL
    L8_2 = L8_2.single
    L8_2 = L8_2.await
    L9_2 = "SELECT created FROM apex_phone_mail WHERE id = ? AND owner = ?"
    L10_2 = {}
    L11_2 = L7_2
    L12_2 = L2_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L8_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L9_2 = L8_2.created
      if L9_2 then
        L9_2 = #L5_2
        L9_2 = L9_2 + 1
        L5_2[L9_2] = "(created < ? OR (created = ? AND id < ?))"
        L9_2 = #L6_2
        L9_2 = L9_2 + 1
        L10_2 = L8_2.created
        L6_2[L9_2] = L10_2
        L9_2 = #L6_2
        L9_2 = L9_2 + 1
        L10_2 = L8_2.created
        L6_2[L9_2] = L10_2
        L9_2 = #L6_2
        L9_2 = L9_2 + 1
        L6_2[L9_2] = L7_2
    end
    else
      L9_2 = #L5_2
      L9_2 = L9_2 + 1
      L5_2[L9_2] = "id < ?"
      L9_2 = #L6_2
      L9_2 = L9_2 + 1
      L6_2[L9_2] = L7_2
    end
  end
  L8_2 = L15_1
  L9_2 = A1_2.q
  L10_2 = 64
  L8_2 = L8_2(L9_2, L10_2)
  if L8_2 and "" ~= L8_2 then
    L9_2 = "%"
    L10_2 = L16_1
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    L11_2 = "%"
    L9_2 = L9_2 .. L10_2 .. L11_2
    L10_2 = #L5_2
    L10_2 = L10_2 + 1
    L5_2[L10_2] = "(subject LIKE ? ESCAPE '!' OR sender LIKE ? ESCAPE '!' OR email LIKE ? ESCAPE '!' OR recipient LIKE ? ESCAPE '!' OR body LIKE ? ESCAPE '!')"
    L10_2 = 1
    L11_2 = 5
    L12_2 = 1
    for L13_2 = L10_2, L11_2, L12_2 do
      L14_2 = #L6_2
      L14_2 = L14_2 + 1
      L6_2[L14_2] = L9_2
    end
  end
  L9_2 = math
  L9_2 = L9_2.max
  L10_2 = 1
  L11_2 = math
  L11_2 = L11_2.min
  L12_2 = L3_1
  L13_2 = L6_1
  L14_2 = A1_2.limit
  L13_2 = L13_2(L14_2)
  if not L13_2 then
    L13_2 = L2_1
  end
  L11_2 = L11_2(L12_2, L13_2)
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = MySQL
  L10_2 = L10_2.query
  L10_2 = L10_2.await
  L11_2 = "SELECT "
  L12_2 = L1_1
  L13_2 = " FROM apex_phone_mail WHERE "
  L14_2 = table
  L14_2 = L14_2.concat
  L15_2 = L5_2
  L16_2 = " AND "
  L14_2 = L14_2(L15_2, L16_2)
  L15_2 = " ORDER BY created DESC, id DESC LIMIT "
  L16_2 = string
  L16_2 = L16_2.format
  L17_2 = "%d"
  L18_2 = L9_2
  L16_2 = L16_2(L17_2, L18_2)
  L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2 .. L15_2 .. L16_2
  L12_2 = L6_2
  L10_2 = L10_2(L11_2, L12_2)
  if not L10_2 then
    L10_2 = {}
  end
  L11_2 = ipairs
  L12_2 = L10_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = L22_1
    L18_2 = L16_2
    L17_2(L18_2)
  end
  return L10_2
end
L31_1["mail.list"] = L32_1
L31_1 = RPC
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.unread = 0
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.scalar
  L2_2 = L2_2.await
  L3_2 = "SELECT COUNT(*) FROM apex_phone_mail WHERE owner = ? AND folder = 'inbox' AND `read` = 0"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = {}
  L4_2 = tonumber
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.unread = L4_2
  return L3_2
end
L31_1["mail.unread"] = L32_1
L31_1 = RPC
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT folder, COUNT(*) AS n, SUM(CASE WHEN `read` = 0 THEN 1 ELSE 0 END) AS u, SUM(CASE WHEN flagged = 1 THEN 1 ELSE 0 END) AS f FROM apex_phone_mail WHERE owner = ? GROUP BY folder"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = 0
  L6_2 = pairs
  L7_2 = L0_1
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2 in L6_2, L7_2, L8_2, L9_2 do
    L3_2[L10_2] = 0
    L4_2[L10_2] = 0
  end
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L13_2 = L11_2.folder
    L12_2 = L0_1
    L12_2 = L12_2[L13_2]
    if L12_2 then
      L12_2 = L11_2.folder
      L13_2 = tonumber
      L14_2 = L11_2.n
      L13_2 = L13_2(L14_2)
      if not L13_2 then
        L13_2 = 0
      end
      L3_2[L12_2] = L13_2
      L12_2 = L11_2.folder
      L13_2 = tonumber
      L14_2 = L11_2.u
      L13_2 = L13_2(L14_2)
      if not L13_2 then
        L13_2 = 0
      end
      L4_2[L12_2] = L13_2
      L12_2 = L11_2.folder
      if "trash" ~= L12_2 then
        L12_2 = tonumber
        L13_2 = L11_2.f
        L12_2 = L12_2(L13_2)
        if not L12_2 then
          L12_2 = 0
        end
        L5_2 = L5_2 + L12_2
      end
    end
  end
  L6_2 = {}
  L6_2.total = L3_2
  L6_2.unread = L4_2
  L6_2.flagged = L5_2
  return L6_2
end
L31_1["mail.counts"] = L32_1
L31_1 = RPC
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L6_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 < 1 then
    L4_2 = {}
    L4_2.error = "notfound"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT "
  L6_2 = L1_1
  L7_2 = " FROM apex_phone_mail WHERE id = ? AND owner = ?"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "notfound"
    return L5_2
  end
  L5_2 = L22_1
  L6_2 = L4_2
  return L5_2(L6_2)
end
L31_1["mail.get"] = L32_1
L31_1 = RPC
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L6_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  L4_2 = L6_1
  L5_2 = A1_2.index
  L4_2 = L4_2(L5_2)
  L5_2 = L6_1
  L6_2 = A1_2.i
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 1
  end
  if L3_2 and L4_2 and not (L4_2 < 1) and not (L4_2 > 10) and not (L5_2 < 1) then
    L6_2 = 512
    if not (L5_2 > L6_2) then
      goto lbl_39
    end
  end
  L6_2 = {}
  L6_2.error = "badchunk"
  do return L6_2 end
  ::lbl_39::
  L6_2 = MySQL
  L6_2 = L6_2.single
  L6_2 = L6_2.await
  L7_2 = "SELECT attachments FROM apex_phone_mail WHERE id = ? AND owner = ?"
  L8_2 = {}
  L9_2 = L3_2
  L10_2 = L2_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.error = "notfound"
    return L7_2
  end
  L7_2 = L21_1
  L8_2 = L6_2.attachments
  L7_2 = L7_2(L8_2)
  L8_2 = L7_2 or L8_2
  if L7_2 then
    L8_2 = L7_2[L4_2]
  end
  L9_2 = type
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = L6_1
    L10_2 = L8_2.mediaId
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_72
    end
  end
  L9_2 = nil
  ::lbl_72::
  if not L9_2 then
    L10_2 = {}
    L10_2.error = "notfound"
    return L10_2
  end
  L10_2 = L11_1
  L10_2 = L10_2()
  L11_2 = MySQL
  L11_2 = L11_2.single
  L11_2 = L11_2.await
  L12_2 = "SELECT kind, mime, duration, CHAR_LENGTH(data) AS len, SUBSTRING(data, ?, ?) AS part FROM apex_phone_media WHERE id = ? AND complete = 1"
  L13_2 = {}
  L14_2 = L5_2 - 1
  L14_2 = L14_2 * L10_2
  L14_2 = L14_2 + 1
  L15_2 = L10_2
  L16_2 = L9_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L11_2 = L11_2(L12_2, L13_2)
  if not L11_2 then
    L12_2 = {}
    L12_2.error = "gone"
    return L12_2
  end
  L12_2 = L6_1
  L13_2 = L11_2.len
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 0
  end
  L13_2 = {}
  L13_2.i = L5_2
  if L12_2 > 0 then
    L14_2 = math
    L14_2 = L14_2.ceil
    L15_2 = L12_2 / L10_2
    L14_2 = L14_2(L15_2)
    if L14_2 then
      goto lbl_121
    end
  end
  L14_2 = 0
  ::lbl_121::
  L13_2.total = L14_2
  L13_2.len = L12_2
  L14_2 = L11_2.kind
  L13_2.kind = L14_2
  L14_2 = L11_2.mime
  L13_2.mime = L14_2
  L14_2 = L11_2.duration
  L13_2.duration = L14_2
  L14_2 = L11_2.part
  if not L14_2 then
    L14_2 = ""
  end
  L13_2.data = L14_2
  return L13_2
end
L31_1["mail.attachment"] = L32_1
function L31_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  if not A0_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = type
  L8_2 = A6_2
  L7_2 = L7_2(L8_2)
  if "table" ~= L7_2 or not A6_2 then
    L7_2 = {}
    A6_2 = L7_2
  end
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = L13_1
  L9_2 = A1_2
  L10_2 = 64
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = "Sistema"
  end
  L9_2 = L13_1
  L10_2 = A2_2
  L11_2 = 96
  L9_2 = L9_2(L10_2, L11_2)
  A2_2 = L9_2
  A1_2 = L8_2
  L8_2 = L13_1
  L9_2 = A3_2
  L10_2 = 160
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = "(sem assunto)"
  end
  L9_2 = L13_1
  L10_2 = A4_2
  L11_2 = 4000
  L9_2 = L9_2(L10_2, L11_2)
  A4_2 = L9_2 or A4_2
  if not L9_2 then
    A4_2 = ""
  end
  A3_2 = L8_2
  if "" == A3_2 then
    A3_2 = "(sem assunto)"
  end
  L8_2 = A6_2.folder
  if "trash" == L8_2 then
    L8_2 = "trash"
    if L8_2 then
      goto lbl_55
    end
  end
  L8_2 = "inbox"
  ::lbl_55::
  L9_2 = L13_1
  L10_2 = A6_2.recipient
  L11_2 = 64
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = L20_1
  L11_2 = A5_2
  L10_2 = L10_2(L11_2)
  L11_2 = MySQL
  L11_2 = L11_2.insert
  L11_2 = L11_2.await
  L12_2 = "INSERT INTO apex_phone_mail (owner, sender, email, subject, body, `read`, folder, created, recipient, attachments, flagged) VALUES (?, ?, ?, ?, ?, 0, ?, ?, ?, ?, 0)"
  L13_2 = {}
  L14_2 = A0_2
  L15_2 = A1_2
  L16_2 = A2_2
  L17_2 = A3_2
  L18_2 = A4_2
  L19_2 = L8_2
  L20_2 = L7_2
  L21_2 = L9_2
  L22_2 = L10_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L13_2[6] = L19_2
  L13_2[7] = L20_2
  L13_2[8] = L21_2
  L13_2[9] = L22_2
  L11_2 = L11_2(L12_2, L13_2)
  if not L11_2 then
    L12_2 = nil
    return L12_2
  end
  L12_2 = {}
  L12_2.id = L11_2
  L12_2.owner = A0_2
  L12_2.sender = A1_2
  L12_2.email = A2_2
  L12_2.subject = A3_2
  L12_2.body = A4_2
  L12_2.read = false
  L12_2.folder = L8_2
  L12_2.created = L7_2
  L12_2.recipient = L9_2
  L13_2 = L21_1
  L14_2 = L10_2
  L13_2 = L13_2(L14_2)
  L12_2.attachments = L13_2
  L12_2.flagged = false
  if "inbox" == L8_2 then
    L13_2 = A6_2.notify
    if false ~= L13_2 then
      goto lbl_106
    end
  end
  do return L12_2 end
  ::lbl_106::
  L13_2 = FW
  L13_2 = L13_2.GetPlayerByCid
  L14_2 = A0_2
  L13_2 = L13_2(L14_2)
  if L13_2 then
    L14_2 = L13_2.src
    if L14_2 then
      L14_2 = HasPhoneItem
      if L14_2 then
        L14_2 = HasPhoneItem
        L15_2 = L13_2.src
        L14_2 = L14_2(L15_2)
      end
      if L14_2 then
        L14_2 = NotifyCitizen
        L14_2 = nil ~= L14_2
        L12_2.notified = L14_2
        L14_2 = Push
        L15_2 = L13_2.src
        L16_2 = "mail"
        L17_2 = L12_2
        L14_2(L15_2, L16_2, L17_2)
        L14_2 = NotifyCitizen
        if L14_2 then
          L14_2 = NotifyCitizen
          L15_2 = A0_2
          L16_2 = "mail"
          L17_2 = A1_2
          L18_2 = A3_2
          L19_2 = {}
          L19_2.mailId = L11_2
          L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
        end
      end
  end
  else
    L14_2 = NotifyCitizen
    if L14_2 then
      L14_2 = NotifyCitizen
      L15_2 = A0_2
      L16_2 = "mail"
      L17_2 = A1_2
      L18_2 = A3_2
      L19_2 = {}
      L19_2.mailId = L11_2
      L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
    end
  end
  return L12_2
end
SendMailInternal = L31_1
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = GetCitizenIdByNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    return L1_2
  end
  L3_2 = A0_2
  L2_2 = A0_2.lower
  L2_2 = L2_2(L3_2)
  L4_2 = L2_2
  L3_2 = L2_2.match
  L5_2 = "^@?([%w_%.]+)$"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = L2_2
    L3_2 = L2_2.match
    L5_2 = "^([%w_%.]+)@apex%.ls$"
    L3_2 = L3_2(L4_2, L5_2)
  end
  if L3_2 then
    L4_2 = #L3_2
    if not (L4_2 < 3) then
      L4_2 = #L3_2
      if not (L4_2 > 32) then
        goto lbl_31
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_31::
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT citizenid FROM apex_phone_accounts WHERE username = ?"
  L6_2 = {}
  L7_2 = L3_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L4_2 or L5_2
  if L4_2 then
    L5_2 = L4_2.citizenid
  end
  return L5_2
end
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L13_1
  L4_2 = L14_1
  L5_2 = A1_2.to
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.match
  L6_2 = "^%s*(.-)%s*$"
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = 96
  L3_2 = L3_2(L4_2, L5_2)
  if "" == L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "target"
    return L4_2
  end
  L4_2 = L13_1
  L5_2 = A1_2.subject
  if nil ~= L5_2 then
    L5_2 = L14_1
    L6_2 = A1_2.subject
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_37
    end
  end
  L5_2 = "(sem assunto)"
  ::lbl_37::
  L6_2 = 160
  L4_2 = L4_2(L5_2, L6_2)
  if "" == L4_2 then
    L4_2 = "(sem assunto)"
  end
  L5_2 = L13_1
  L6_2 = L14_1
  L7_2 = A1_2.body
  L6_2 = L6_2(L7_2)
  L7_2 = 4000
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = CleanMailAttachments
  L7_2 = A1_2.attachments
  L8_2 = L2_2
  L9_2 = {}
  L9_2.src = A0_2
  L6_2, L7_2, L8_2 = L6_2(L7_2, L8_2, L9_2)
  if L7_2 then
    L9_2 = L30_1
    L10_2 = L7_2
    L11_2 = L8_2
    return L9_2(L10_2, L11_2)
  end
  L9_2 = Now
  L9_2 = L9_2()
  L10_2 = MySQL
  L10_2 = L10_2.insert
  L10_2 = L10_2.await
  L11_2 = "INSERT INTO apex_phone_mail (owner, sender, email, subject, body, `read`, folder, created, recipient, attachments, flagged) VALUES (?, ?, ?, ?, ?, 1, ?, ?, ?, ?, 0)"
  L12_2 = {}
  L13_2 = L2_2
  L14_2 = "Eu"
  L15_2 = L3_2
  L16_2 = L4_2
  L17_2 = L5_2
  L18_2 = "sent"
  L19_2 = L9_2
  L20_2 = L13_1
  L21_2 = L3_2
  L22_2 = 64
  L20_2 = L20_2(L21_2, L22_2)
  L21_2 = L20_1
  L22_2 = L6_2
  L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L21_2(L22_2)
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L12_2[4] = L16_2
  L12_2[5] = L17_2
  L12_2[6] = L18_2
  L12_2[7] = L19_2
  L12_2[8] = L20_2
  L12_2[9] = L21_2
  L12_2[10] = L22_2
  L12_2[11] = L23_2
  L12_2[12] = L24_2
  L12_2[13] = L25_2
  L12_2[14] = L26_2
  L10_2 = L10_2(L11_2, L12_2)
  if not L10_2 then
    L11_2 = L26_1
    L12_2 = L24_1
    L13_2 = L6_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L12_2(L13_2)
    L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
    L11_2 = {}
    L11_2.ok = false
    L11_2.error = "db"
    return L11_2
  end
  L11_2 = L6_1
  L12_2 = A1_2.draftId
  L11_2 = L11_2(L12_2)
  if L11_2 and L11_2 > 0 then
    L12_2 = MySQL
    L12_2 = L12_2.single
    L12_2 = L12_2.await
    L13_2 = "SELECT id, attachments FROM apex_phone_mail WHERE id = ? AND owner = ? AND folder = 'drafts'"
    L14_2 = {}
    L15_2 = L11_2
    L16_2 = L2_2
    L14_2[1] = L15_2
    L14_2[2] = L16_2
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      L13_2 = MySQL
      L13_2 = L13_2.query
      L13_2 = L13_2.await
      L14_2 = "DELETE FROM apex_phone_mail WHERE id = ? AND owner = ? AND folder = 'drafts'"
      L15_2 = {}
      L16_2 = L11_2
      L17_2 = L2_2
      L15_2[1] = L16_2
      L15_2[2] = L17_2
      L13_2(L14_2, L15_2)
      L13_2 = L26_1
      L14_2 = L24_1
      L15_2 = L21_1
      L16_2 = L12_2.attachments
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L15_2(L16_2)
      L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
    end
  end
  L12_2 = L31_1
  L13_2 = L3_2
  L12_2 = L12_2(L13_2)
  L13_2 = false
  if L12_2 and L12_2 ~= L2_2 then
    L14_2 = Accounts
    L14_2 = L14_2[L2_2]
    L15_2 = GetPlayerNumber
    L16_2 = A0_2
    L15_2 = L15_2(L16_2)
    if L14_2 then
      L16_2 = L14_2.username
      if L16_2 then
        L16_2 = L14_2.username
        if "" ~= L16_2 then
          L16_2 = "@"
          L17_2 = L14_2.username
          L16_2 = L16_2 .. L17_2
        end
      end
    end
    L16_2 = L15_2 or L16_2
    if not L16_2 and not L15_2 then
      L16_2 = "Jogador"
    end
    L17_2 = false
    if L15_2 then
      L18_2 = type
      L19_2 = IsBlocked
      L18_2 = L18_2(L19_2)
      if "function" == L18_2 then
        L18_2 = pcall
        L19_2 = IsBlocked
        L20_2 = L12_2
        L21_2 = L15_2
        L18_2, L19_2 = L18_2(L19_2, L20_2, L21_2)
        L17_2 = L18_2 or L17_2
        L17_2 = L18_2 and true == L19_2
      end
    end
    L18_2 = SendMailInternal
    L19_2 = L12_2
    L20_2 = L16_2
    L21_2 = L15_2
    L22_2 = L4_2
    L23_2 = L5_2
    L24_2 = L6_2
    L25_2 = {}
    L25_2.recipient = L3_2
    if L17_2 then
      L26_2 = "trash"
      if L26_2 then
        goto lbl_198
      end
    end
    L26_2 = "inbox"
    ::lbl_198::
    L25_2.folder = L26_2
    L26_2 = not L17_2
    L25_2.notify = L26_2
    L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L13_2 = nil ~= L18_2
  end
  L14_2 = {}
  L14_2.id = L10_2
  L14_2.ok = true
  L14_2.delivered = L13_2
  L14_2.attachments = L6_2
  return L14_2
end
L32_1["mail.send"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L13_1
  L4_2 = L14_1
  L5_2 = A1_2.to
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.match
  L6_2 = "^%s*(.-)%s*$"
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = 96
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L13_1
  L5_2 = L14_1
  L6_2 = A1_2.subject
  L5_2 = L5_2(L6_2)
  L6_2 = 160
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L13_1
  L6_2 = L14_1
  L7_2 = A1_2.body
  L6_2 = L6_2(L7_2)
  L7_2 = 4000
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L6_1
  L7_2 = A1_2.id
  L6_2 = L6_2(L7_2)
  if L6_2 and L6_2 > 0 then
    L7_2 = MySQL
    L7_2 = L7_2.single
    L7_2 = L7_2.await
    L8_2 = "SELECT id, attachments FROM apex_phone_mail WHERE id = ? AND owner = ? AND folder = 'drafts'"
    L9_2 = {}
    L10_2 = L6_2
    L11_2 = L2_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      goto lbl_52
    end
  end
  L7_2 = nil
  ::lbl_52::
  if not L7_2 then
    L8_2 = tonumber
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT COUNT(*) FROM apex_phone_mail WHERE owner = ? AND folder = 'drafts'"
    L11_2 = {}
    L12_2 = L2_2
    L11_2[1] = L12_2
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L9_2(L10_2, L11_2)
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    if not L8_2 then
      L8_2 = 0
    end
    L9_2 = L10_1
    L9_2 = L9_2()
    if L8_2 >= L9_2 then
      L9_2 = {}
      L9_2.ok = false
      L9_2.error = "draftsfull"
      L10_2 = L10_1
      L10_2 = L10_2()
      L9_2.max = L10_2
      return L9_2
    end
  end
  L8_2 = CleanMailAttachments
  L9_2 = A1_2.attachments
  L10_2 = L2_2
  L11_2 = {}
  L11_2.src = A0_2
  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2, L11_2)
  if L9_2 then
    L11_2 = L30_1
    L12_2 = L9_2
    L13_2 = L10_2
    return L11_2(L12_2, L13_2)
  end
  if "" == L3_2 then
    L12_2 = L4_2
    L11_2 = L4_2.find
    L13_2 = "%S"
    L11_2 = L11_2(L12_2, L13_2)
    if not L11_2 then
      L12_2 = L5_2
      L11_2 = L5_2.find
      L13_2 = "%S"
      L11_2 = L11_2(L12_2, L13_2)
      if not L11_2 and not L8_2 then
        L11_2 = {}
        L11_2.ok = false
        L11_2.error = "empty"
        return L11_2
      end
    end
  end
  L11_2 = L20_1
  L12_2 = L8_2
  L11_2 = L11_2(L12_2)
  L12_2 = Now
  L12_2 = L12_2()
  if L7_2 then
    L13_2 = MySQL
    L13_2 = L13_2.update
    L13_2 = L13_2.await
    L14_2 = "UPDATE apex_phone_mail SET email = ?, recipient = ?, subject = ?, body = ?, attachments = ?, created = ? WHERE id = ? AND owner = ? AND folder = 'drafts'"
    L15_2 = {}
    L16_2 = L3_2
    L17_2 = L13_1
    L18_2 = L3_2
    L19_2 = 64
    L17_2 = L17_2(L18_2, L19_2)
    L18_2 = L4_2
    L19_2 = L5_2
    L20_2 = L11_2
    L21_2 = L12_2
    L22_2 = L6_2
    L23_2 = L2_2
    L15_2[1] = L16_2
    L15_2[2] = L17_2
    L15_2[3] = L18_2
    L15_2[4] = L19_2
    L15_2[5] = L20_2
    L15_2[6] = L21_2
    L15_2[7] = L22_2
    L15_2[8] = L23_2
    L13_2(L14_2, L15_2)
    L13_2 = L26_1
    L14_2 = L24_1
    L15_2 = L21_1
    L16_2 = L7_2.attachments
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2(L16_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L15_2 = L24_1
    L16_2 = L8_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2(L16_2)
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  else
    L13_2 = MySQL
    L13_2 = L13_2.insert
    L13_2 = L13_2.await
    L14_2 = "INSERT INTO apex_phone_mail (owner, sender, email, subject, body, `read`, folder, created, recipient, attachments, flagged) VALUES (?, 'Eu', ?, ?, ?, 1, 'drafts', ?, ?, ?, 0)"
    L15_2 = {}
    L16_2 = L2_2
    L17_2 = L3_2
    L18_2 = L4_2
    L19_2 = L5_2
    L20_2 = L12_2
    L21_2 = L13_1
    L22_2 = L3_2
    L23_2 = 64
    L21_2 = L21_2(L22_2, L23_2)
    L22_2 = L11_2
    L15_2[1] = L16_2
    L15_2[2] = L17_2
    L15_2[3] = L18_2
    L15_2[4] = L19_2
    L15_2[5] = L20_2
    L15_2[6] = L21_2
    L15_2[7] = L22_2
    L13_2 = L13_2(L14_2, L15_2)
    L6_2 = L13_2
    if not L6_2 then
      L13_2 = L26_1
      L14_2 = L24_1
      L15_2 = L8_2
      L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L14_2(L15_2)
      L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
      L13_2 = {}
      L13_2.ok = false
      L13_2.error = "db"
      return L13_2
    end
  end
  L13_2 = {}
  L13_2.ok = true
  L13_2.id = L6_2
  L13_2.attachments = L8_2
  L13_2.created = L12_2
  return L13_2
end
L32_1["mail.saveDraft"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L6_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2.folder
  L5_2 = type
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = L0_1
    L5_2 = L5_2[L4_2]
    if L5_2 then
      goto lbl_29
    end
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "folder"
  do return L5_2 end
  ::lbl_29::
  if not L3_2 or L3_2 < 1 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "notfound"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT folder, sender FROM apex_phone_mail WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L3_2
  L9_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "notfound"
    return L6_2
  end
  L6_2 = L5_2.folder
  if L6_2 == L4_2 then
    L6_2 = {}
    L6_2.ok = true
    L6_2.folder = L4_2
    return L6_2
  end
  L6_2 = L5_2.sender
  L6_2 = "Eu" == L6_2
  L7_2 = L5_2.folder
  if "drafts" == L7_2 and "trash" ~= L4_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "folder"
    return L7_2
  end
  if ("drafts" == L4_2 or "sent" == L4_2) and not L6_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "folder"
    return L7_2
  end
  if "drafts" == L4_2 then
    L7_2 = tonumber
    L8_2 = MySQL
    L8_2 = L8_2.scalar
    L8_2 = L8_2.await
    L9_2 = "SELECT COUNT(*) FROM apex_phone_mail WHERE owner = ? AND folder = 'drafts'"
    L10_2 = {}
    L11_2 = L2_2
    L10_2[1] = L11_2
    L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2, L10_2)
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
    if not L7_2 then
      L7_2 = 0
    end
    L8_2 = L10_1
    L8_2 = L8_2()
    if L7_2 >= L8_2 then
      L8_2 = {}
      L8_2.ok = false
      L8_2.error = "draftsfull"
      L9_2 = L10_1
      L9_2 = L9_2()
      L8_2.max = L9_2
      return L8_2
    end
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_mail SET folder = ? WHERE id = ? AND owner = ?"
  L9_2 = {}
  L10_2 = L4_2
  L11_2 = L3_2
  L12_2 = L2_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L7_2(L8_2, L9_2)
  L7_2 = {}
  L7_2.ok = true
  L7_2.folder = L4_2
  return L7_2
end
L32_1["mail.move"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L6_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 < 1 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "notfound"
    return L4_2
  end
  L4_2 = A1_2.on
  L4_2 = false ~= L4_2
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT id FROM apex_phone_mail WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L3_2
  L9_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "notfound"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_mail SET flagged = ? WHERE id = ? AND owner = ?"
  L7_2 = {}
  if L4_2 then
    L8_2 = 1
    if L8_2 then
      goto lbl_60
    end
  end
  L8_2 = 0
  ::lbl_60::
  L9_2 = L3_2
  L10_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  L5_2.flagged = L4_2
  return L5_2
end
L32_1["mail.flag"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L6_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = -1
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT folder, attachments FROM apex_phone_mail WHERE id = ? AND owner = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "notfound"
    return L5_2
  end
  L5_2 = L4_2.folder
  if "trash" ~= L5_2 then
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "UPDATE apex_phone_mail SET folder = 'trash' WHERE id = ? AND owner = ?"
    L7_2 = {}
    L8_2 = L3_2
    L9_2 = L2_2
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L5_2(L6_2, L7_2)
    L5_2 = {}
    L5_2.ok = true
    L5_2.deleted = false
    L5_2.folder = "trash"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM apex_phone_mail WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L3_2
  L9_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2(L6_2, L7_2)
  L5_2 = L26_1
  L6_2 = L24_1
  L7_2 = L21_1
  L8_2 = L4_2.attachments
  L7_2, L8_2, L9_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = {}
  L5_2.ok = true
  L5_2.deleted = true
  return L5_2
end
L32_1["mail.delete"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.update
  L4_2 = "UPDATE apex_phone_mail SET `read` = ? WHERE id = ? AND owner = ?"
  L5_2 = {}
  L6_2 = A1_2.read
  if false == L6_2 then
    L6_2 = 0
    if L6_2 then
      goto lbl_23
    end
  end
  L6_2 = 1
  ::lbl_23::
  L7_2 = L6_1
  L8_2 = A1_2.id
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = -1
  end
  L8_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L32_1["mail.read"] = L33_1
