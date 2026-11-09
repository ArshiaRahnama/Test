local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1
L0_1 = CreateThread
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_match_profiles` (
        `id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `phone` VARCHAR(20) NOT NULL, `name` VARCHAR(24) NOT NULL, `age` INT NOT NULL DEFAULT 18,
        `gender` VARCHAR(12) NOT NULL DEFAULT 'Outro', `seeking` VARCHAR(12) NOT NULL DEFAULT 'Todos', `bio` VARCHAR(160) NULL, `location` VARCHAR(30) NULL,
        `photos` LONGTEXT NULL, `extras` LONGTEXT NULL, `paused` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, UNIQUE KEY `owner` (`owner`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
  L2_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_match_swipes` (`owner` VARCHAR(64) NOT NULL, `target` INT NOT NULL, `liked` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, PRIMARY KEY (`owner`, `target`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
  L3_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_matches` (`id` INT AUTO_INCREMENT PRIMARY KEY, `a` VARCHAR(64) NOT NULL, `b` VARCHAR(64) NOT NULL, `created` BIGINT NOT NULL, KEY `a` (`a`), KEY `b` (`b`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
  L0_2[1] = L1_2
  L0_2[2] = L2_2
  L0_2[3] = L3_2
  L1_2 = ipairs
  L2_2 = L0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = L6_2
    L7_2(L8_2)
    L7_2 = pcall
    L8_2 = MigrateTable
    L9_2 = L6_2
    L7_2(L8_2, L9_2)
  end
  L1_2 = FW
  L1_2 = L1_2.WidenColumns
  L2_2 = {}
  L3_2 = {}
  L4_2 = "apex_phone_match_profiles"
  L5_2 = "owner"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L4_2 = {}
  L5_2 = "apex_phone_match_swipes"
  L6_2 = "owner"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L5_2 = {}
  L6_2 = "apex_phone_matches"
  L7_2 = "a"
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L6_2 = {}
  L7_2 = "apex_phone_matches"
  L8_2 = "b"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L1_2(L2_2)
end
L0_1(L1_1)
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2.photos
  if not L3_2 then
    L3_2 = "[]"
  end
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 and L2_2 then
      goto lbl_24
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = {}
  ::lbl_24::
  A0_2.photos = L3_2
  L3_2 = ipairs
  L4_2 = A0_2.photos
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = tonumber
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L9_2 = A0_2.photos
      L10_2 = tonumber
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      L9_2[L7_2] = L10_2
    end
  end
  L3_2 = A0_2.paused
  L3_2 = 1 == L3_2
  A0_2.paused = L3_2
  L3_2 = pcall
  L4_2 = json
  L4_2 = L4_2.decode
  L5_2 = A0_2.extras
  if not L5_2 then
    L5_2 = "{}"
  end
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 and L4_2 then
      goto lbl_67
      L5_2 = L4_2 or L5_2
    end
  end
  L5_2 = {}
  ::lbl_67::
  A0_2.extras = L5_2
  A0_2.owner = nil
  return A0_2
end
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 and L2_2 == L2_2 then
    L3_2 = math
    L3_2 = L3_2.huge
    if L2_2 ~= L3_2 then
      L3_2 = math
      L3_2 = L3_2.huge
      L3_2 = -L3_2
      if L2_2 ~= L3_2 then
        goto lbl_18
      end
    end
  end
  do return A1_2 end
  ::lbl_18::
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = L2_2
  L4_2, L5_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = A1_2
  end
  return L3_2
end
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Match
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Match
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = L1_1
  L2_2 = L0_2.photoMax
  L3_2 = 512
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L1_1
  L3_2 = L0_2.photosMax
  L4_2 = 2048
  L2_2 = L2_2(L3_2, L4_2)
  if L1_2 < 16 then
    L1_2 = 16
  end
  if L2_2 < L1_2 then
    L2_2 = L1_2
  end
  L3_2 = L1_2
  L4_2 = L2_2
  return L3_2, L4_2
end
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = L2_1
  L2_2, L3_2 = L2_2()
  L4_2 = {}
  L5_2 = 0
  L6_2 = type
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if "table" ~= L6_2 then
    L6_2 = L4_2
    L7_2 = true
    return L6_2, L7_2
  end
  L6_2 = ipairs
  L7_2 = A0_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    if L10_2 > 3 then
      break
    end
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "string" ~= L12_2 then
      L12_2 = type
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "number" ~= L12_2 then
        goto lbl_118
      end
    end
    L12_2 = tostring
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    L13_2 = L12_2
    L12_2 = L12_2.gsub
    L14_2 = "%c"
    L15_2 = ""
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    L14_2 = L12_2
    L13_2 = L12_2.match
    L15_2 = "^m:(%d+)$"
    L13_2 = L13_2(L14_2, L15_2)
    if L13_2 then
      L14_2 = type
      L15_2 = MediaInfo
      L14_2 = L14_2(L15_2)
      if "function" == L14_2 then
        L14_2 = MediaInfo
        L15_2 = tonumber
        L16_2 = L13_2
        L15_2, L16_2, L17_2 = L15_2(L16_2)
        L14_2 = L14_2(L15_2, L16_2, L17_2)
        if L14_2 then
          goto lbl_55
        end
      end
      L14_2 = nil
      ::lbl_55::
      if L14_2 then
        L15_2 = L14_2.complete
        if L15_2 then
          L15_2 = tostring
          L16_2 = L14_2.owner
          L15_2 = L15_2(L16_2)
          L16_2 = tostring
          L17_2 = A1_2 or L17_2
          if not A1_2 then
            L17_2 = ""
          end
          L16_2 = L16_2(L17_2)
          if L15_2 == L16_2 then
            goto lbl_73
          end
        end
      end
      L15_2 = nil
      L16_2 = false
      do return L15_2, L16_2 end
      ::lbl_73::
      L15_2 = L14_2.kind
      if "image" ~= L15_2 then
        L15_2 = tostring
        L16_2 = L14_2.mime
        if not L16_2 then
          L16_2 = ""
        end
        L15_2 = L15_2(L16_2)
        L16_2 = L15_2
        L15_2 = L15_2.match
        L17_2 = "^image/"
        L15_2 = L15_2(L16_2, L17_2)
        if not L15_2 then
          L15_2 = nil
          L16_2 = false
          return L15_2, L16_2
        end
      end
      L15_2 = #L4_2
      L15_2 = L15_2 + 1
      L16_2 = "m:"
      L17_2 = L13_2
      L16_2 = L16_2 .. L17_2
      L4_2[L15_2] = L16_2
    elseif "" ~= L12_2 then
      L14_2 = #L12_2
      if L2_2 < L14_2 then
        L14_2 = nil
        L15_2 = false
        return L14_2, L15_2
      end
      L14_2 = #L12_2
      L5_2 = L5_2 + L14_2
      if L3_2 < L5_2 then
        L14_2 = nil
        L15_2 = false
        return L14_2, L15_2
      end
      L14_2 = #L4_2
      L14_2 = L14_2 + 1
      L4_2[L14_2] = L12_2
    end
    ::lbl_118::
  end
  L6_2 = #L4_2
  if L6_2 > 0 then
    L6_2 = json
    L6_2 = L6_2.encode
    L7_2 = L4_2
    L6_2 = L6_2(L7_2)
    L6_2 = #L6_2
    if L3_2 < L6_2 then
      L6_2 = nil
      L7_2 = false
      return L6_2, L7_2
    end
  end
  L6_2 = L4_2
  L7_2 = true
  return L6_2, L7_2
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L2_1
  L1_2, L2_2 = L1_2()
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
  L4_2 = "photos"
  L3_2 = L3_2 .. L4_2
  L4_2 = "IF(LENGTH(%s) <= %d, %s, NULL) AS photos"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L3_2
  L7_2 = L2_2
  L8_2 = L3_2
  return L4_2(L5_2, L6_2, L7_2, L8_2)
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L0_1
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT id, phone, name, age, gender, seeking, bio, location, extras, paused, created, %s FROM apex_phone_match_profiles WHERE id = ?"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L4_1
  L5_2 = L5_2()
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  return L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      L2_2 = nil
      return L2_2
    end
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "[%c]"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2 or L3_2
  if "" == L2_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = {}
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 then
    return L3_2
  end
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L6_1
    L11_2 = L9_2
    L12_2 = A2_2
    L10_2 = L10_2(L11_2, L12_2)
    if L10_2 then
      L11_2 = #L3_2
      if A1_2 > L11_2 then
        L11_2 = #L3_2
        L11_2 = L11_2 + 1
        L3_2[L11_2] = L10_2
      end
    end
  end
  return L3_2
end
L8_1 = {}
L8_1.job = 40
L8_1.school = 40
L8_1.zodiac = 12
L8_1.want = 24
L8_1.drinks = 16
L8_1.smoke = 16
L8_1.pets = 16
L8_1.workout = 16
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = {}
    return L1_2
  end
  L1_2 = {}
  L2_2 = type
  L3_2 = A0_2.song
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L6_1
    L3_2 = A0_2.song
    L3_2 = L3_2.t
    L4_2 = 80
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L3_2 = L6_1
      L4_2 = A0_2.song
      L4_2 = L4_2.img
      L5_2 = 400
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        L5_2 = L3_2
        L4_2 = L3_2.match
        L6_2 = "^https://"
        L4_2 = L4_2(L5_2, L6_2)
        if not L4_2 then
          L3_2 = nil
        end
      end
      L4_2 = L6_1
      L5_2 = A0_2.song
      L5_2 = L5_2.vid
      L6_2 = 24
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        L6_2 = L4_2
        L5_2 = L4_2.match
        L7_2 = "^[%w_%-]+$"
        L5_2 = L5_2(L6_2, L7_2)
        if not L5_2 then
          L4_2 = nil
        end
      end
      L5_2 = {}
      L5_2.t = L2_2
      L6_2 = L6_1
      L7_2 = A0_2.song
      L7_2 = L7_2.a
      L8_2 = 60
      L6_2 = L6_2(L7_2, L8_2)
      if not L6_2 then
        L6_2 = ""
      end
      L5_2.a = L6_2
      L5_2.img = L3_2
      L5_2.vid = L4_2
      L1_2.song = L5_2
    end
  end
  L2_2 = L7_1
  L3_2 = A0_2.artists
  L4_2 = 5
  L5_2 = 30
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2.artists = L2_2
  L2_2 = L7_1
  L3_2 = A0_2.interests
  L4_2 = 5
  L5_2 = 24
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2.interests = L2_2
  L2_2 = {}
  L1_2.prompts = L2_2
  L2_2 = type
  L3_2 = A0_2.prompts
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = ipairs
    L3_2 = A0_2.prompts
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L8_2 = L1_2.prompts
        L8_2 = #L8_2
        if L8_2 < 3 then
          L8_2 = L6_1
          L9_2 = L7_2.q
          L10_2 = 60
          L8_2 = L8_2(L9_2, L10_2)
          L9_2 = L6_1
          L10_2 = L7_2.a
          L11_2 = 120
          L9_2 = L9_2(L10_2, L11_2)
          if L8_2 and L9_2 then
            L10_2 = L1_2.prompts
            L11_2 = L1_2.prompts
            L11_2 = #L11_2
            L11_2 = L11_2 + 1
            L12_2 = {}
            L12_2.q = L8_2
            L12_2.a = L9_2
            L10_2[L11_2] = L12_2
          end
        end
      end
    end
  end
  L2_2 = pairs
  L3_2 = L8_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L6_1
    L9_2 = A0_2[L6_2]
    L10_2 = L7_2
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L6_2] = L8_2
  end
  L2_2 = tonumber
  L3_2 = A0_2.height
  L2_2 = L2_2(L3_2)
  if L2_2 and L2_2 >= 120 then
    L3_2 = 230
    if L2_2 <= L3_2 then
      L3_2 = math
      L3_2 = L3_2.floor
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      L1_2.height = L3_2
    end
  end
  return L1_2
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L0_1
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_match_profiles WHERE owner = ?"
  L4_2 = {}
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2, L6_2 = L5_2(L6_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2, L4_2)
  return L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT id, owner, phone, gender, seeking FROM apex_phone_match_profiles WHERE owner = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  return L2_2(L3_2, L4_2)
end
L12_1 = RPC
function L13_1(A0_2)
  local L1_2, L2_2
  L1_2 = L10_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
L12_1["match.profile"] = L13_1
L12_1 = RPC
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A1_2.name
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 24
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if "" == L3_2 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = L3_1
  L5_2 = A1_2.photos
  L6_2 = L2_2
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "toolarge"
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = [[
INSERT INTO apex_phone_match_profiles (owner, phone, name, age, gender, seeking, bio, location, photos, extras, paused, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?)
        ON DUPLICATE KEY UPDATE phone = VALUES(phone), name = VALUES(name), age = VALUES(age), gender = VALUES(gender), seeking = VALUES(seeking), bio = VALUES(bio), location = VALUES(location), photos = VALUES(photos), extras = VALUES(extras)]]
  L8_2 = {}
  L9_2 = L2_2
  L10_2 = GetPlayerNumber
  L11_2 = A0_2
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = ""
  end
  L11_2 = L3_2
  L12_2 = math
  L12_2 = L12_2.max
  L13_2 = 18
  L14_2 = math
  L14_2 = L14_2.min
  L15_2 = 99
  L16_2 = tonumber
  L17_2 = A1_2.age
  L16_2 = L16_2(L17_2)
  if not L16_2 then
    L16_2 = 18
  end
  L14_2 = L14_2(L15_2, L16_2)
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = tostring
  L14_2 = A1_2.gender
  if not L14_2 then
    L14_2 = "Outro"
  end
  L13_2 = L13_2(L14_2)
  L14_2 = L13_2
  L13_2 = L13_2.sub
  L15_2 = 1
  L16_2 = 12
  L13_2 = L13_2(L14_2, L15_2, L16_2)
  L14_2 = tostring
  L15_2 = A1_2.seeking
  if not L15_2 then
    L15_2 = "Todos"
  end
  L14_2 = L14_2(L15_2)
  L15_2 = L14_2
  L14_2 = L14_2.sub
  L16_2 = 1
  L17_2 = 12
  L14_2 = L14_2(L15_2, L16_2, L17_2)
  L15_2 = tostring
  L16_2 = A1_2.bio
  if not L16_2 then
    L16_2 = ""
  end
  L15_2 = L15_2(L16_2)
  L16_2 = L15_2
  L15_2 = L15_2.sub
  L17_2 = 1
  L18_2 = 160
  L15_2 = L15_2(L16_2, L17_2, L18_2)
  L16_2 = tostring
  L17_2 = A1_2.location
  if not L17_2 then
    L17_2 = ""
  end
  L16_2 = L16_2(L17_2)
  L17_2 = L16_2
  L16_2 = L16_2.sub
  L18_2 = 1
  L19_2 = 30
  L16_2 = L16_2(L17_2, L18_2, L19_2)
  L17_2 = json
  L17_2 = L17_2.encode
  L18_2 = L4_2
  L17_2 = L17_2(L18_2)
  L18_2 = json
  L18_2 = L18_2.encode
  L19_2 = L9_1
  L20_2 = A1_2.extras
  L19_2, L20_2 = L19_2(L20_2)
  L18_2 = L18_2(L19_2, L20_2)
  L19_2 = Now
  L19_2, L20_2 = L19_2()
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L8_2[7] = L15_2
  L8_2[8] = L16_2
  L8_2[9] = L17_2
  L8_2[10] = L18_2
  L8_2[11] = L19_2
  L8_2[12] = L20_2
  L6_2(L7_2, L8_2)
  L6_2 = L10_1
  L7_2 = A0_2
  return L6_2(L7_2)
end
L12_1["match.createProfile"] = L13_1
L12_1 = RPC
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_match_profiles WHERE owner = ?"
  L4_2 = {}
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L5_2(L6_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L4_2[6] = L10_2
  L4_2[7] = L11_2
  L4_2[8] = L12_2
  L4_2[9] = L13_2
  L4_2[10] = L14_2
  L4_2[11] = L15_2
  L4_2[12] = L16_2
  L4_2[13] = L17_2
  L4_2[14] = L18_2
  L4_2[15] = L19_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = L2_2.photos
  L4_2 = A1_2.photos
  if L4_2 then
    L4_2 = L3_1
    L5_2 = A1_2.photos
    L6_2 = GetCid
    L7_2 = A0_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L6_2(L7_2)
    L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    if not L5_2 then
      L6_2 = {}
      L6_2.error = "toolarge"
      return L6_2
    end
    L6_2 = json
    L6_2 = L6_2.encode
    L7_2 = L4_2
    L6_2 = L6_2(L7_2)
    L3_2 = L6_2
  end
  L4_2 = L2_2.extras
  L5_2 = A1_2.extras
  if nil ~= L5_2 then
    L5_2 = json
    L5_2 = L5_2.encode
    L6_2 = L9_1
    L7_2 = A1_2.extras
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L6_2(L7_2)
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L4_2 = L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_match_profiles SET name = ?, age = ?, gender = ?, seeking = ?, bio = ?, location = ?, photos = ?, extras = ?, paused = ?, phone = ? WHERE owner = ?"
  L7_2 = {}
  L8_2 = A1_2.name
  if L8_2 then
    L8_2 = tostring
    L9_2 = A1_2.name
    L8_2 = L8_2(L9_2)
    L9_2 = L8_2
    L8_2 = L8_2.sub
    L10_2 = 1
    L11_2 = 24
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if L8_2 then
      goto lbl_69
    end
  end
  L8_2 = L2_2.name
  ::lbl_69::
  L9_2 = A1_2.age
  if L9_2 then
    L9_2 = math
    L9_2 = L9_2.max
    L10_2 = 18
    L11_2 = math
    L11_2 = L11_2.min
    L12_2 = 99
    L13_2 = tonumber
    L14_2 = A1_2.age
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = L2_2.age
    end
    L11_2 = L11_2(L12_2, L13_2)
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      goto lbl_89
    end
  end
  L9_2 = L2_2.age
  ::lbl_89::
  L10_2 = A1_2.gender
  if L10_2 then
    L10_2 = tostring
    L11_2 = A1_2.gender
    L10_2 = L10_2(L11_2)
    L11_2 = L10_2
    L10_2 = L10_2.sub
    L12_2 = 1
    L13_2 = 12
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    if L10_2 then
      goto lbl_102
    end
  end
  L10_2 = L2_2.gender
  ::lbl_102::
  L11_2 = A1_2.seeking
  if L11_2 then
    L11_2 = tostring
    L12_2 = A1_2.seeking
    L11_2 = L11_2(L12_2)
    L12_2 = L11_2
    L11_2 = L11_2.sub
    L13_2 = 1
    L14_2 = 12
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    if L11_2 then
      goto lbl_115
    end
  end
  L11_2 = L2_2.seeking
  ::lbl_115::
  L12_2 = A1_2.bio
  if nil ~= L12_2 then
    L12_2 = tostring
    L13_2 = A1_2.bio
    L12_2 = L12_2(L13_2)
    L13_2 = L12_2
    L12_2 = L12_2.sub
    L14_2 = 1
    L15_2 = 160
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    if L12_2 then
      goto lbl_128
    end
  end
  L12_2 = L2_2.bio
  ::lbl_128::
  L13_2 = A1_2.location
  if nil ~= L13_2 then
    L13_2 = tostring
    L14_2 = A1_2.location
    L13_2 = L13_2(L14_2)
    L14_2 = L13_2
    L13_2 = L13_2.sub
    L15_2 = 1
    L16_2 = 30
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    if L13_2 then
      goto lbl_141
    end
  end
  L13_2 = L2_2.location
  ::lbl_141::
  L14_2 = L3_2
  L15_2 = L4_2
  L16_2 = A1_2.paused
  if nil ~= L16_2 then
    L16_2 = A1_2.paused
    if L16_2 then
      L16_2 = 1
      if L16_2 then
        goto lbl_156
      end
    end
    L16_2 = 0
    if L16_2 then
      goto lbl_156
    end
  end
  L16_2 = L2_2.paused
  ::lbl_156::
  L17_2 = GetPlayerNumber
  L18_2 = A0_2
  L17_2 = L17_2(L18_2)
  if not L17_2 then
    L17_2 = L2_2.phone
  end
  L18_2 = GetCid
  L19_2 = A0_2
  L18_2, L19_2 = L18_2(L19_2)
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L7_2[7] = L14_2
  L7_2[8] = L15_2
  L7_2[9] = L16_2
  L7_2[10] = L17_2
  L7_2[11] = L18_2
  L7_2[12] = L19_2
  L5_2(L6_2, L7_2)
  L5_2 = L10_1
  L6_2 = A0_2
  return L5_2(L6_2)
end
L12_1["match.updateProfile"] = L13_1
L12_1 = RPC
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_match_profiles WHERE owner = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_match_swipes WHERE owner = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_matches WHERE a = ? OR b = ?"
  L4_2 = {}
  L5_2 = L1_2
  L6_2 = L1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2(L3_2, L4_2)
  L2_2 = {}
  L2_2.ok = true
  return L2_2
end
L12_1["match.deleteProfile"] = L13_1
L12_1 = RPC
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L11_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = [[
SELECT p.id, p.name, p.age, p.gender, p.seeking, p.bio, p.location, p.extras, p.created, %s,
        (SELECT s.liked FROM apex_phone_match_swipes s WHERE s.owner = p.owner AND s.target = ?) AS liked_me FROM apex_phone_match_profiles p
        WHERE p.owner <> ? AND p.paused = 0 AND p.id NOT IN (SELECT target FROM apex_phone_match_swipes WHERE owner = ?) ORDER BY p.created DESC LIMIT 30]]
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L4_1
  L6_2 = "p."
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = {}
  L5_2 = L1_2.id
  L6_2 = L1_2.owner
  L7_2 = L1_2.owner
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = tonumber
    L11_2 = L9_2.liked_me
    L10_2 = L10_2(L11_2)
    L10_2 = 2 == L10_2
    L9_2.superMe = L10_2
    L9_2.liked_me = nil
    L10_2 = L0_1
    L11_2 = L9_2
    L10_2(L11_2)
    L10_2 = L1_2.seeking
    L10_2 = "Todos" == L10_2
    L11_2 = L9_2.seeking
    L11_2 = "Todos" == L11_2
    if L10_2 and L11_2 then
      L12_2 = #L3_2
      L12_2 = L12_2 + 1
      L3_2[L12_2] = L9_2
    end
  end
  return L3_2
end
L12_1["match.cards"] = L13_1
L12_1 = RPC
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L11_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT id, owner FROM apex_phone_match_profiles WHERE id = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A1_2.target
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = -1
  end
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.matched = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "INSERT INTO apex_phone_match_swipes (owner, target, liked, created) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE liked = VALUES(liked)"
  L6_2 = {}
  L7_2 = L2_2.owner
  L8_2 = L3_2.id
  L9_2 = A1_2.like
  if L9_2 then
    L9_2 = A1_2.super
    if L9_2 then
      L9_2 = 2
      if L9_2 then
        goto lbl_51
      end
    end
    L9_2 = 1
    if L9_2 then
      goto lbl_51
    end
  end
  L9_2 = 0
  ::lbl_51::
  L10_2 = Now
  L10_2, L11_2, L12_2, L13_2 = L10_2()
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L6_2[7] = L13_2
  L4_2(L5_2, L6_2)
  L4_2 = A1_2.like
  if not L4_2 then
    L4_2 = {}
    L4_2.matched = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT liked FROM apex_phone_match_swipes WHERE owner = ? AND target = ?"
  L6_2 = {}
  L7_2 = L3_2.owner
  L8_2 = L2_2.id
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = tonumber
    L6_2 = L4_2.liked
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = 0
    end
    if L5_2 >= 1 then
      L5_2 = MySQL
      L5_2 = L5_2.single
      L5_2 = L5_2.await
      L6_2 = "SELECT id FROM apex_phone_matches WHERE (a = ? AND b = ?) OR (a = ? AND b = ?)"
      L7_2 = {}
      L8_2 = L2_2.owner
      L9_2 = L3_2.owner
      L10_2 = L3_2.owner
      L11_2 = L2_2.owner
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L7_2[4] = L11_2
      L5_2 = L5_2(L6_2, L7_2)
      if not L5_2 then
        L6_2 = MySQL
        L6_2 = L6_2.insert
        L6_2 = L6_2.await
        L7_2 = "INSERT INTO apex_phone_matches (a, b, created) VALUES (?, ?, ?)"
        L8_2 = {}
        L9_2 = L2_2.owner
        L10_2 = L3_2.owner
        L11_2 = Now
        L11_2, L12_2, L13_2 = L11_2()
        L8_2[1] = L9_2
        L8_2[2] = L10_2
        L8_2[3] = L11_2
        L8_2[4] = L12_2
        L8_2[5] = L13_2
        L6_2(L7_2, L8_2)
      end
      L6_2 = L5_1
      L7_2 = L3_2.id
      L6_2 = L6_2(L7_2)
      L7_2 = FW
      L7_2 = L7_2.GetPlayerByCid
      L8_2 = L3_2.owner
      L7_2 = L7_2(L8_2)
      if L7_2 then
        L8_2 = Push
        L9_2 = L7_2.src
        L10_2 = "match"
        L11_2 = {}
        L12_2 = L5_1
        L13_2 = L2_2.id
        L12_2 = L12_2(L13_2)
        L11_2.profile = L12_2
        L8_2(L9_2, L10_2, L11_2)
      end
      L8_2 = {}
      L8_2.matched = true
      L8_2.profile = L6_2
      return L8_2
    end
  end
  L5_2 = {}
  L5_2.matched = false
  return L5_2
end
L12_1["match.swipe"] = L13_1
L12_1 = RPC
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L1_2 = L11_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = [[
SELECT m.id AS m_id, m.created AS m_created,
        p.id, p.phone, p.name, p.age, p.gender, p.seeking, p.bio, p.location, p.extras, p.paused, p.created, %s
        FROM apex_phone_matches m
        JOIN apex_phone_match_profiles p ON p.owner = IF(m.a = ?, m.b, m.a)
        WHERE m.a = ? OR m.b = ? ORDER BY m.created DESC]]
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L4_1
  L6_2 = "p."
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L5_2(L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L4_2 = {}
  L5_2 = L1_2.owner
  L6_2 = L1_2.owner
  L7_2 = L1_2.owner
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.phone
    if nil ~= L11_2 then
      L11_2 = L10_2.phone
      L11_2 = L4_2[L11_2]
      if not L11_2 then
        L11_2 = L10_2.phone
        L4_2[L11_2] = true
        L11_2 = #L3_2
        L11_2 = L11_2 + 1
        L12_2 = L10_2.phone
        L3_2[L11_2] = L12_2
      end
    end
  end
  L5_2 = {}
  L6_2 = #L3_2
  if L6_2 > 0 then
    L6_2 = "?,"
    L7_2 = L6_2
    L6_2 = L6_2.rep
    L8_2 = #L3_2
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = -2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L7_2 = {}
    L8_2 = L1_2.phone
    L9_2 = L1_2.phone
    L10_2 = L1_2.phone
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L8_2 = ipairs
    L9_2 = L3_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = #L7_2
      L14_2 = L14_2 + 1
      L7_2[L14_2] = L13_2
    end
    L8_2 = #L7_2
    L8_2 = L8_2 + 1
    L9_2 = L1_2.phone
    L7_2[L8_2] = L9_2
    L8_2 = ipairs
    L9_2 = L3_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = #L7_2
      L14_2 = L14_2 + 1
      L7_2[L14_2] = L13_2
    end
    L8_2 = #L7_2
    L8_2 = L8_2 + 1
    L9_2 = L1_2.phone
    L7_2[L8_2] = L9_2
    L8_2 = #L7_2
    L8_2 = L8_2 + 1
    L9_2 = L1_2.phone
    L7_2[L8_2] = L9_2
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = [[
SELECT x.*, k.other AS k_other, k.unread AS k_unread FROM (
                SELECT IF(sender = ?, receiver, sender) AS other, MAX(id) AS last_id,
                       COUNT(CASE WHEN receiver = ? AND `read` = 0 THEN 1 END) AS unread
                FROM apex_phone_messages
                WHERE app = 'match' AND ((sender = ? AND receiver IN (%s)) OR (receiver = ? AND sender IN (%s)))
                  AND conversation_id IS NULL AND NOT (sender = ? AND deleted_sender = 1) AND NOT (receiver = ? AND deleted_receiver = 1)
                GROUP BY other) k
            JOIN apex_phone_messages x ON x.id = k.last_id]]
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L6_2
    L12_2 = L6_2
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = L7_2
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = {}
    end
    L9_2 = ipairs
    L10_2 = L8_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = L14_2.k_other
      L16_2 = L14_2.k_unread
      L17_2 = nil
      L14_2.k_unread = nil
      L14_2.k_other = L17_2
      if nil ~= L15_2 then
        L17_2 = {}
        L17_2.last = L14_2
        L18_2 = tonumber
        L19_2 = L16_2
        L18_2 = L18_2(L19_2)
        if not L18_2 then
          L18_2 = 0
        end
        L17_2.unread = L18_2
        L5_2[L15_2] = L17_2
      end
    end
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.m_id
    L14_2 = L12_2.m_created
    L15_2 = nil
    L12_2.m_created = nil
    L12_2.m_id = L15_2
    L15_2 = L0_1
    L16_2 = L12_2
    L15_2 = L15_2(L16_2)
    L16_2 = L15_2.phone
    L16_2 = L5_2[L16_2]
    L17_2 = #L6_2
    L17_2 = L17_2 + 1
    L18_2 = {}
    L18_2.id = L13_2
    L18_2.profile = L15_2
    if L16_2 then
      L19_2 = L16_2.last
      if L19_2 then
        goto lbl_184
      end
    end
    L19_2 = nil
    ::lbl_184::
    L18_2.last = L19_2
    if L16_2 then
      L19_2 = L16_2.unread
      if L19_2 then
        goto lbl_191
      end
    end
    L19_2 = 0
    ::lbl_191::
    L18_2.unread = L19_2
    L18_2.created = L14_2
    L6_2[L17_2] = L18_2
  end
  L7_2 = table
  L7_2 = L7_2.sort
  L8_2 = L6_2
  function L9_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.last
    if L2_3 then
      L2_3 = A0_3.last
      L2_3 = L2_3.created
      if L2_3 then
        goto lbl_9
      end
    end
    L2_3 = A0_3.created
    ::lbl_9::
    L3_3 = A1_3.last
    if L3_3 then
      L3_3 = A1_3.last
      L3_3 = L3_3.created
      if L3_3 then
        goto lbl_17
      end
    end
    L3_3 = A1_3.created
    ::lbl_17::
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L7_2(L8_2, L9_2)
  return L6_2
end
L12_1["match.matches"] = L13_1
L12_1 = RPC
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_matches WHERE id = ? AND (a = ? OR b = ?)"
  L5_2 = {}
  L6_2 = A1_2.id
  L7_2 = L2_2
  L8_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L12_1["match.unmatch"] = L13_1
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 or L2_2 < 1 then
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
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT id FROM apex_phone_match_profiles WHERE owner = ? LIMIT 1"
  L6_2 = {}
  L7_2 = L3_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = "%\"m:"
  L6_2 = L2_2
  L7_2 = "\"%"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT id FROM apex_phone_match_profiles WHERE photos LIKE ? LIMIT 1"
  L8_2 = {}
  L9_2 = L5_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = nil ~= L6_2
  return L7_2
end
MatchMediaCanRead = L12_1
