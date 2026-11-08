local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1
function L0_1(A0_2)
  local L1_2
  L1_2 = A0_2.favorite
  L1_2 = 1 == L1_2
  A0_2.favorite = L1_2
  L1_2 = A0_2.video
  L1_2 = 1 == L1_2
  A0_2.video = L1_2
  L1_2 = A0_2.hasPoster
  if nil ~= L1_2 then
    L1_2 = A0_2.hasPoster
    L1_2 = 1 == L1_2
    A0_2.hasPoster = L1_2
  end
  return A0_2
end
L1_1 = {}
L1_1["video/webm"] = true
L1_1["video/mp4"] = true
L2_1 = 16000
function L3_1()
  local L0_2, L1_2, L2_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Camera
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = tonumber
    L1_2 = Config
    L1_2 = L1_2.Camera
    L1_2 = L1_2.VideoMaxBytes
    L0_2 = L0_2(L1_2)
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = nil
  ::lbl_15::
  if L0_2 then
    L1_2 = 200000
    if not (L0_2 < L1_2) then
      goto lbl_21
    end
  end
  L0_2 = 1600000
  ::lbl_21::
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = L0_2
  return L1_2(L2_2)
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 and "" ~= A0_2 then
    L1_2 = #A0_2
    L2_2 = L2_1
    if not (L1_2 > L2_2) then
      goto lbl_14
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_14::
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^data:(image/[%w%.%+%-]+);base64,"
  L1_2 = L1_2(L2_2, L3_2)
  if "image/jpeg" ~= L1_2 and "image/jpg" ~= L1_2 and "image/png" ~= L1_2 and "image/webp" ~= L1_2 then
    L2_2 = nil
    return L2_2
  end
  return A0_2
end
L5_1 = 48000
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = A1_2
  end
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  A0_2 = L2_2 or A0_2
  if not L2_2 then
    A0_2 = A1_2
  end
  if A0_2 < 1 then
    A0_2 = 1
  else
    L2_2 = 5000
    if A0_2 > L2_2 then
      A0_2 = 5000
    end
  end
  return A0_2
end
L7_1 = RPC
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = L6_1
  L3_2 = Config
  L3_2 = L3_2.MaxPhotos
  if not L3_2 then
    L3_2 = 60
  end
  L4_2 = 60
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT COUNT(*) FROM apex_phone_photos WHERE owner = ? AND favorite = 1"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT id, owner, seed, favorite, video, duration, created, CHAR_LENGTH(url) AS len, "
  L6_2 = "CASE WHEN poster IS NULL THEN 0 ELSE 1 END AS hasPoster, "
  L7_2 = "CASE WHEN url LIKE 'data:%' THEN NULL ELSE url END AS url "
  L8_2 = "FROM apex_phone_photos WHERE owner = ? ORDER BY created DESC LIMIT "
  L9_2 = L6_1
  L10_2 = L2_2 + L3_2
  L11_2 = 60
  L9_2 = L9_2(L10_2, L11_2)
  L5_2 = L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2
  L6_2 = {}
  L7_2 = L1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L0_1
    L12_2 = L10_2
    L11_2(L12_2)
  end
  return L4_2
end
L7_1["photos.list"] = L8_1
L7_1 = RPC
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2 or L5_2
  if A1_2 then
    L5_2 = A1_2.id
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 < 1 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT poster FROM apex_phone_photos WHERE id = ? AND owner = ?"
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
  L5_2 = {}
  L5_2.id = L3_2
  L6_2 = type
  L7_2 = L4_2.poster
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L6_2 = L4_2.poster
    if "" ~= L6_2 then
      L6_2 = L4_2.poster
      if L6_2 then
        goto lbl_60
      end
    end
  end
  L6_2 = nil
  ::lbl_60::
  L5_2.poster = L6_2
  return L5_2
end
L7_1["photos.poster"] = L8_1
L7_1 = RPC
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A1_2.i
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 1
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 1
  end
  if not L3_2 or L3_2 < 1 or L4_2 < 1 or L4_2 > 64 then
    L5_2 = {}
    L5_2.error = "badchunk"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT CHAR_LENGTH(url) AS len, SUBSTRING(url, ?, ?) AS part FROM apex_phone_photos WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L4_2 - 1
  L9_2 = L5_1
  L8_2 = L8_2 * L9_2
  L8_2 = L8_2 + 1
  L9_2 = L5_1
  L10_2 = L3_2
  L11_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "notfound"
    return L6_2
  end
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = L5_2.len
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if L6_2 <= 0 then
    L7_2 = {}
    L7_2.i = L4_2
    L7_2.total = 0
    L7_2.len = 0
    L7_2.data = ""
    return L7_2
  end
  L7_2 = {}
  L7_2.i = L4_2
  L8_2 = math
  L8_2 = L8_2.ceil
  L9_2 = L5_1
  L9_2 = L6_2 / L9_2
  L8_2 = L8_2(L9_2)
  L7_2.total = L8_2
  L7_2.len = L6_2
  L8_2 = L5_2.part
  if not L8_2 then
    L8_2 = ""
  end
  L7_2.data = L8_2
  return L7_2
end
L7_1["photos.data"] = L8_1
function L7_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L6_2 = Now
  L6_2 = L6_2()
  if not A3_2 then
    A5_2 = nil
  end
  L7_2 = MySQL
  L7_2 = L7_2.insert
  L7_2 = L7_2.await
  L8_2 = "INSERT INTO apex_phone_photos (owner, url, seed, favorite, video, duration, poster, created) VALUES (?, ?, ?, 0, ?, ?, ?, ?)"
  L9_2 = {}
  L10_2 = A0_2
  L11_2 = A1_2
  L12_2 = A2_2
  if A3_2 then
    L13_2 = 1
    if L13_2 then
      goto lbl_21
    end
  end
  L13_2 = 0
  ::lbl_21::
  L14_2 = A4_2
  L15_2 = A5_2
  L16_2 = L6_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = L6_1
  L9_2 = Config
  L9_2 = L9_2.MaxPhotos
  if not L9_2 then
    L9_2 = 60
  end
  L10_2 = 60
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = MySQL
  L9_2 = L9_2.scalar
  L9_2 = L9_2.await
  L10_2 = "SELECT COUNT(*) FROM apex_phone_photos WHERE owner = ?"
  L11_2 = {}
  L12_2 = A0_2
  L11_2[1] = L12_2
  L9_2 = L9_2(L10_2, L11_2)
  if not L9_2 then
    L9_2 = 0
  end
  if L8_2 < L9_2 then
    L10_2 = MySQL
    L10_2 = L10_2.query
    L11_2 = "DELETE FROM apex_phone_photos WHERE owner = ? AND favorite = 0 ORDER BY created ASC LIMIT "
    L12_2 = L6_1
    L13_2 = L9_2 - L8_2
    L14_2 = 1
    L12_2 = L12_2(L13_2, L14_2)
    L11_2 = L11_2 .. L12_2
    L12_2 = {}
    L13_2 = A0_2
    L12_2[1] = L13_2
    L10_2(L11_2, L12_2)
  end
  L10_2 = type
  L11_2 = A1_2
  L10_2 = L10_2(L11_2)
  L10_2 = "string" == L10_2
  L11_2 = {}
  L11_2.id = L7_2
  L11_2.owner = A0_2
  L12_2 = A1_2 or L12_2
  if L10_2 or not A1_2 then
    L12_2 = nil
  end
  L11_2.url = L12_2
  L11_2.seed = A2_2
  L11_2.favorite = false
  if A3_2 then
    L12_2 = true
    if L12_2 then
      goto lbl_93
    end
  end
  L12_2 = false
  ::lbl_93::
  L11_2.video = L12_2
  L11_2.duration = A4_2
  L11_2.created = L6_2
  L12_2 = nil ~= A5_2
  L11_2.hasPoster = L12_2
  L11_2.poster = A5_2
  L12_2 = type
  L13_2 = A1_2
  L12_2 = L12_2(L13_2)
  if "string" == L12_2 then
    L12_2 = #A1_2
    if L12_2 then
      goto lbl_111
    end
  end
  L12_2 = 0
  ::lbl_111::
  L11_2.len = L12_2
  return L11_2
end
AddPhoto = L7_1
L7_1 = {}
L7_1["image/jpeg"] = true
L7_1["image/jpg"] = true
L7_1["image/png"] = true
L7_1["image/webp"] = true
L7_1["image/gif"] = true
function L8_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = Config
  L0_2 = L0_2.PhotoLinks
  L1_2 = Config
  L1_2 = L1_2.WallpaperLinks
  L2_2 = type
  L3_2 = L0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = type
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    L0_2 = L1_2 or L0_2
    if "table" ~= L2_2 or not L1_2 then
      L2_2 = {}
      L0_2 = L2_2
    end
  end
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L1_2 = L0_2
  end
  L2_2 = L0_2
  L3_2 = L1_2
  return L2_2, L3_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = L8_1
  L1_2, L2_2 = L1_2()
  L3_2 = L1_2.enabled
  if false == L3_2 then
    L3_2 = L2_2.enabled
    if false == L3_2 then
      L3_2 = false
      L4_2 = "disabled"
      return L3_2, L4_2
    end
  end
  L3_2 = tonumber
  L4_2 = L1_2.maxLength
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 512
  end
  if L3_2 >= 16 then
    L4_2 = #A0_2
    if L3_2 < L4_2 then
      L4_2 = false
      L5_2 = "badimage"
      return L4_2, L5_2
    end
  end
  L4_2 = type
  L5_2 = L1_2.hosts
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L1_2.hosts
    if L4_2 then
      goto lbl_36
    end
  end
  L4_2 = {}
  ::lbl_36::
  L5_2 = next
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if nil == L5_2 then
    L5_2 = true
    return L5_2
  end
  L6_2 = A0_2
  L5_2 = A0_2.match
  L7_2 = "^https?://([^/?#]+)"
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = ""
  end
  L7_2 = L5_2
  L6_2 = L5_2.gsub
  L8_2 = "^.*@"
  L9_2 = ""
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = L6_2
  L6_2 = L6_2.gsub
  L8_2 = ":%d+$"
  L9_2 = ""
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = L6_2
  L6_2 = L6_2.lower
  L6_2 = L6_2(L7_2)
  L5_2 = L6_2
  if "" == L5_2 then
    L6_2 = false
    L7_2 = "host"
    return L6_2, L7_2
  end
  L6_2 = pairs
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "string" == L12_2 and "" ~= L11_2 then
      L13_2 = L11_2
      L12_2 = L11_2.lower
      L12_2 = L12_2(L13_2)
      L11_2 = L12_2
      if L5_2 ~= L11_2 then
        L13_2 = L5_2
        L12_2 = L5_2.sub
        L14_2 = #L11_2
        L14_2 = L14_2 + 1
        L14_2 = -L14_2
        L12_2 = L12_2(L13_2, L14_2)
        L13_2 = "."
        L14_2 = L11_2
        L13_2 = L13_2 .. L14_2
        if L12_2 ~= L13_2 then
          goto lbl_94
        end
      end
      L12_2 = true
      return L12_2
    end
    ::lbl_94::
  end
  L6_2 = false
  L7_2 = "host"
  return L6_2, L7_2
end
PhotoLinkAllowed = L9_1
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if nil == A0_2 or false == A0_2 or "" == A0_2 then
    L2_2 = nil
    L3_2 = true
    return L2_2, L3_2
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = nil
    L3_2 = false
    return L2_2, L3_2
  end
  if A1_2 then
    L2_2 = L3_1
    L2_2 = L2_2()
    if L2_2 then
      goto lbl_31
    end
  end
  L2_2 = tonumber
  L3_2 = Config
  L3_2 = L3_2.PhotoMaxBytes
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 260000
  end
  ::lbl_31::
  L3_2 = #A0_2
  if L2_2 < L3_2 then
    L3_2 = nil
    L4_2 = false
    L5_2 = "toolarge"
    return L3_2, L4_2, L5_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.match
  L5_2 = "^data:([%w]+/[%w%.%+%-]+);base64,"
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L7_1
    L4_2 = L4_2[L3_2]
    if L4_2 then
      L4_2 = A0_2
      L5_2 = true
      return L4_2, L5_2
    end
    if A1_2 then
      L4_2 = L1_1
      L4_2 = L4_2[L3_2]
      if L4_2 then
        L4_2 = A0_2
        L5_2 = true
        return L4_2, L5_2
      end
    end
    L4_2 = nil
    L5_2 = false
    return L4_2, L5_2
  end
  L4_2 = #A0_2
  L5_2 = 512
  if L4_2 <= L5_2 then
    L5_2 = A0_2
    L4_2 = A0_2.match
    L6_2 = "^https?://"
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L5_2 = A0_2
      L4_2 = A0_2.find
      L6_2 = "[%s\"'<>\\]"
      L4_2 = L4_2(L5_2, L6_2)
      if not L4_2 then
        L4_2 = L9_1
        L5_2 = A0_2
        L4_2, L5_2 = L4_2(L5_2)
        if not L4_2 then
          L6_2 = nil
          L7_2 = false
          L8_2 = L5_2
          return L6_2, L7_2, L8_2
        end
        L6_2 = A0_2
        L7_2 = true
        return L6_2, L7_2
      end
    end
  end
  L4_2 = nil
  L5_2 = false
  return L4_2, L5_2
end
CleanPhotoUrl = L10_1
L11_1 = RPC
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = A1_2.video
  L3_2 = true == L3_2
  L4_2 = L10_1
  L5_2 = A1_2.url
  L6_2 = L3_2
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  if not L5_2 then
    L7_2 = {}
    L8_2 = L6_2 or L8_2
    if not L6_2 then
      L8_2 = "badimage"
    end
    L7_2.error = L8_2
    return L7_2
  end
  L7_2 = AddPhoto
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = tonumber
  L11_2 = A1_2.seed
  L10_2 = L10_2(L11_2)
  L11_2 = L3_2
  L12_2 = tonumber
  L13_2 = A1_2.duration
  L12_2 = L12_2(L13_2)
  if L3_2 then
    L13_2 = L4_1
    L14_2 = A1_2.poster
    L13_2 = L13_2(L14_2)
    if L13_2 then
      goto lbl_49
    end
  end
  L13_2 = nil
  ::lbl_49::
  return L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
end
L11_1["photos.add"] = L12_1
L11_1 = 64000
L12_1 = 64
L13_1 = {}
function L14_1(A0_2)
  local L1_2
  L1_2 = L13_1
  L1_2[A0_2] = nil
end
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.i
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A1_2.total
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = type
  L6_2 = A1_2.data
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = A1_2.data
    if L5_2 then
      goto lbl_43
    end
  end
  L5_2 = ""
  ::lbl_43::
  if not (L4_2 < 1) then
    L6_2 = L12_1
    if not (L4_2 > L6_2 or L3_2 < 1 or L3_2 > L4_2) then
      goto lbl_56
    end
  end
  L6_2 = {}
  L6_2.error = "badchunk"
  do return L6_2 end
  ::lbl_56::
  L6_2 = #L5_2
  L7_2 = L11_1
  if L6_2 > L7_2 then
    L6_2 = {}
    L6_2.error = "toolarge"
    return L6_2
  end
  L6_2 = L13_1
  L6_2 = L6_2[A0_2]
  if 1 ~= L3_2 and L6_2 then
    L7_2 = L6_2.total
    if L7_2 == L4_2 then
      goto lbl_96
    end
  end
  L7_2 = {}
  L8_2 = {}
  L7_2.parts = L8_2
  L7_2.total = L4_2
  L7_2.len = 0
  L8_2 = os
  L8_2 = L8_2.time
  L8_2 = L8_2()
  L7_2.t = L8_2
  L8_2 = A1_2.video
  L8_2 = true == L8_2
  L7_2.video = L8_2
  L6_2 = L7_2
  L7_2 = L13_1
  L7_2[A0_2] = L6_2
  ::lbl_96::
  L7_2 = L6_2.parts
  L7_2 = L7_2[L3_2]
  if L7_2 then
    L7_2 = {}
    L7_2.error = "dup"
    return L7_2
  end
  L7_2 = L6_2.parts
  L7_2[L3_2] = L5_2
  L7_2 = L6_2.len
  L8_2 = #L5_2
  L7_2 = L7_2 + L8_2
  L6_2.len = L7_2
  L7_2 = L6_2.video
  if L7_2 then
    L7_2 = L3_1
    L7_2 = L7_2()
    if L7_2 then
      goto lbl_125
    end
  end
  L7_2 = tonumber
  L8_2 = Config
  L8_2 = L8_2.PhotoMaxBytes
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 260000
  end
  ::lbl_125::
  L8_2 = L6_2.len
  if L7_2 < L8_2 then
    L8_2 = L14_1
    L9_2 = A0_2
    L8_2(L9_2)
    L8_2 = {}
    L8_2.error = "toolarge"
    return L8_2
  end
  if L3_2 < L4_2 then
    L8_2 = {}
    L8_2.ok = true
    L8_2.part = L3_2
    return L8_2
  end
  L8_2 = 1
  L9_2 = L4_2
  L10_2 = 1
  for L11_2 = L8_2, L9_2, L10_2 do
    L12_2 = L6_2.parts
    L12_2 = L12_2[L11_2]
    if not L12_2 then
      L12_2 = L14_1
      L13_2 = A0_2
      L12_2(L13_2)
      L12_2 = {}
      L13_2 = "missing:"
      L14_2 = L11_2
      L13_2 = L13_2 .. L14_2
      L12_2.error = L13_2
      return L12_2
    end
  end
  L8_2 = table
  L8_2 = L8_2.concat
  L9_2 = L6_2.parts
  L10_2 = ""
  L11_2 = 1
  L12_2 = L4_2
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  L9_2 = L14_1
  L10_2 = A0_2
  L9_2(L10_2)
  L10_2 = L8_2
  L9_2 = L8_2.match
  L11_2 = "^data:([%w]+/[%w%.%+%-]+);base64,"
  L9_2 = L9_2(L10_2, L11_2)
  if L9_2 then
    L10_2 = L7_1
    L10_2 = L10_2[L9_2]
    if L10_2 then
      goto lbl_191
    end
    L10_2 = L6_2.video
    if L10_2 then
      L10_2 = L1_1
      L10_2 = L10_2[L9_2]
      if L10_2 then
        goto lbl_191
      end
    end
  end
  L10_2 = {}
  L10_2.error = "badimage"
  do return L10_2 end
  ::lbl_191::
  L10_2 = AddPhoto
  L11_2 = L2_2
  L12_2 = L8_2
  L13_2 = tonumber
  L14_2 = A1_2.seed
  L13_2 = L13_2(L14_2)
  L14_2 = L6_2.video
  L15_2 = tonumber
  L16_2 = A1_2.duration
  L15_2 = L15_2(L16_2)
  L16_2 = L6_2.video
  if L16_2 then
    L16_2 = L4_1
    L17_2 = A1_2.poster
    L16_2 = L16_2(L17_2)
    if L16_2 then
      goto lbl_210
    end
  end
  L16_2 = nil
  ::lbl_210::
  return L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
end
L15_1["photos.upload"] = L16_1
L15_1 = AddEventHandler
L16_1 = "playerDropped"
function L17_1()
  local L0_2, L1_2
  L0_2 = L14_1
  L1_2 = source
  L0_2(L1_2)
end
L15_1(L16_1, L17_1)
L15_1 = CreateThread
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  while true do
    L0_2 = Wait
    L1_2 = 60000
    L0_2(L1_2)
    L0_2 = os
    L0_2 = L0_2.time
    L0_2 = L0_2()
    L1_2 = pairs
    L2_2 = L13_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = L6_2.t
      L7_2 = L0_2 - L7_2
      if L7_2 > 60 then
        L7_2 = L13_1
        L7_2[L5_2] = nil
      end
    end
  end
end
L15_1(L16_1)
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_photos WHERE id = ? AND owner = ?"
  L4_2 = {}
  L5_2 = A1_2.id
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2, L7_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2(L3_2, L4_2)
  L2_2 = {}
  L2_2.ok = true
  return L2_2
end
L15_1["photos.remove"] = L16_1
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 < 1 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = A1_2.favorite
  if L4_2 then
    L4_2 = 1
    if L4_2 then
      goto lbl_34
    end
  end
  L4_2 = 0
  ::lbl_34::
  if 1 == L4_2 then
    L5_2 = math
    L5_2 = L5_2.floor
    L6_2 = tonumber
    L7_2 = Config
    L7_2 = L7_2.MaxFavPhotos
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 60
    end
    L5_2 = L5_2(L6_2)
    if L5_2 > 0 then
      L6_2 = tonumber
      L7_2 = MySQL
      L7_2 = L7_2.scalar
      L7_2 = L7_2.await
      L8_2 = "SELECT COUNT(*) FROM apex_phone_photos WHERE owner = ? AND favorite = 1 AND id <> ?"
      L9_2 = {}
      L10_2 = L2_2
      L11_2 = L3_2
      L9_2[1] = L10_2
      L9_2[2] = L11_2
      L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2(L8_2, L9_2)
      L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
      if not L6_2 then
        L6_2 = 0
      end
      if L5_2 <= L6_2 then
        L7_2 = {}
        L7_2.error = "toomany"
        L7_2.max = L5_2
        return L7_2
      end
    end
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L6_2 = "UPDATE apex_phone_photos SET favorite = ? WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L3_2
  L10_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L15_1["photos.fav"] = L16_1
