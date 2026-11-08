local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1
L0_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_app_ratings` (`owner` VARCHAR(64) NOT NULL, `app` VARCHAR(64) NOT NULL, `stars` TINYINT NOT NULL, `title` VARCHAR(60) NULL, `text` VARCHAR(300) NULL, `username` VARCHAR(32) NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`owner`,`app`), KEY `app` (`app`))"
L1_1 = CreateThread
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L0_1
    L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 apex_phone_app_ratings: %s"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2(L3_2, L4_2, L5_2, L6_2)
    return
  end
  L2_2 = MigrateTable
  if L2_2 then
    L2_2 = pcall
    L3_2 = MigrateTable
    L4_2 = L0_1
    L2_2(L3_2, L4_2)
  end
end
L1_1(L2_1)
function L1_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = #A0_2
  if 0 ~= L1_2 then
    L1_2 = #A0_2
    if not (L1_2 > 64) then
      L2_2 = A0_2
      L1_2 = A0_2.find
      L3_2 = "[^%w_%.%:%-]"
      L1_2 = L1_2(L2_2, L3_2)
      if not L1_2 then
        goto lbl_21
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_21::
  return A0_2
end
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = MySQL
  L1_2 = L1_2.scalar
  L1_2 = L1_2.await
  L2_2 = "SELECT username FROM apex_phone_accounts WHERE citizenid = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 and "" ~= L1_2 then
    L2_2 = tostring
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_20
    end
  end
  L2_2 = nil
  ::lbl_20::
  return L2_2
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT stars, COUNT(*) AS n FROM apex_phone_app_ratings WHERE app = ? GROUP BY stars"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = {}
  L3_2 = 0
  L4_2 = 0
  L5_2 = 0
  L6_2 = 0
  L7_2 = 0
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L3_2 = 0
  L4_2 = 0
  L5_2 = ipairs
  L6_2 = L1_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = math
    L11_2 = L11_2.tointeger
    L12_2 = tonumber
    L13_2 = L10_2.stars
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = 0
    end
    L12_2 = tonumber
    L13_2 = L10_2.n
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    if L11_2 >= 1 and L11_2 <= 5 then
      L2_2[L11_2] = L12_2
      L3_2 = L3_2 + L12_2
      L13_2 = L11_2 * L12_2
      L4_2 = L4_2 + L13_2
    end
  end
  L5_2 = {}
  if L3_2 > 0 then
    L6_2 = math
    L6_2 = L6_2.floor
    L7_2 = L4_2 / L3_2
    L7_2 = L7_2 * 10
    L7_2 = L7_2 + 0.5
    L6_2 = L6_2(L7_2)
    L6_2 = L6_2 / 10
    if L6_2 then
      goto lbl_78
    end
  end
  L6_2 = 0
  ::lbl_78::
  L5_2.avg = L6_2
  L5_2.count = L3_2
  L5_2.dist = L2_2
  return L5_2
end
L4_1 = RPC
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L1_1
  L4_2 = A1_2.app
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = L3_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT stars, title, text, created FROM apex_phone_app_ratings WHERE owner = ? AND app = ?"
  L7_2 = {}
  L8_2 = L2_2
  L9_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L6_2 = {}
    L7_2 = tonumber
    L8_2 = L5_2.stars
    L7_2 = L7_2(L8_2)
    L6_2.stars = L7_2
    L7_2 = L5_2.title
    L6_2.title = L7_2
    L7_2 = L5_2.text
    L6_2.text = L7_2
    L7_2 = tonumber
    L8_2 = L5_2.created
    L7_2 = L7_2(L8_2)
    L6_2.created = L7_2
    L4_2.mine = L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT username, stars, title, text, created FROM apex_phone_app_ratings WHERE app = ? AND (text IS NOT NULL AND text <> '' OR title IS NOT NULL AND title <> '') ORDER BY created DESC LIMIT 20"
  L8_2 = {}
  L9_2 = L3_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = {}
    L15_2 = L13_2.username
    if not L15_2 then
      L15_2 = "jogador"
    end
    L14_2.username = L15_2
    L15_2 = tonumber
    L16_2 = L13_2.stars
    L15_2 = L15_2(L16_2)
    L14_2.stars = L15_2
    L15_2 = L13_2.title
    L14_2.title = L15_2
    L15_2 = L13_2.text
    L14_2.text = L15_2
    L15_2 = tonumber
    L16_2 = L13_2.created
    L15_2 = L15_2(L16_2)
    L14_2.created = L15_2
    L7_2[L12_2] = L14_2
  end
  L4_2.reviews = L7_2
  return L4_2
end
L4_1["apps.ratings"] = L5_1
L4_1 = RPC
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = {}
    L1_2.error = "noplayer"
    return L1_2
  end
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT app, AVG(stars) AS avg, COUNT(*) AS n FROM apex_phone_app_ratings GROUP BY app LIMIT 500"
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2.app
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L8_2.app
      L10_2 = {}
      L11_2 = math
      L11_2 = L11_2.floor
      L12_2 = tonumber
      L13_2 = L8_2.avg
      L12_2 = L12_2(L13_2)
      if not L12_2 then
        L12_2 = 0
      end
      L12_2 = L12_2 * 10
      L12_2 = L12_2 + 0.5
      L11_2 = L11_2(L12_2)
      L11_2 = L11_2 / 10
      L10_2.avg = L11_2
      L11_2 = tonumber
      L12_2 = L8_2.n
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L10_2.count = L11_2
      L2_2[L9_2] = L10_2
    end
  end
  return L2_2
end
L4_1["apps.ratingsAll"] = L5_1
L4_1 = RPC
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L1_1
  L4_2 = A1_2.app
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A1_2.stars
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 or L4_2 < 1 or L4_2 > 5 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "stars"
    return L5_2
  end
  L5_2 = A1_2.title
  if nil ~= L5_2 then
    L5_2 = tostring
    L6_2 = A1_2.title
    L5_2 = L5_2(L6_2)
    L6_2 = L5_2
    L5_2 = L5_2.gsub
    L7_2 = "^%s+"
    L8_2 = ""
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    L6_2 = L5_2
    L5_2 = L5_2.gsub
    L7_2 = "%s+$"
    L8_2 = ""
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    L6_2 = L5_2
    L5_2 = L5_2.sub
    L7_2 = 1
    L8_2 = 60
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    if L5_2 then
      goto lbl_62
    end
  end
  L5_2 = ""
  ::lbl_62::
  L6_2 = A1_2.text
  if nil ~= L6_2 then
    L6_2 = tostring
    L7_2 = A1_2.text
    L6_2 = L6_2(L7_2)
    L7_2 = L6_2
    L6_2 = L6_2.gsub
    L8_2 = "^%s+"
    L9_2 = ""
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L7_2 = L6_2
    L6_2 = L6_2.gsub
    L8_2 = "%s+$"
    L9_2 = ""
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = 300
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_83
    end
  end
  L6_2 = ""
  ::lbl_83::
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "INSERT INTO apex_phone_app_ratings (owner, app, stars, title, text, username, created) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE stars = VALUES(stars), title = VALUES(title), text = VALUES(text), username = VALUES(username), created = VALUES(created)"
  L9_2 = {}
  L10_2 = L2_2
  L11_2 = L3_2
  L12_2 = L4_2
  L13_2 = L5_2 or L13_2
  if "" == L5_2 or not L5_2 then
    L13_2 = nil
  end
  L14_2 = L6_2 or L14_2
  if "" == L6_2 or not L6_2 then
    L14_2 = nil
  end
  L15_2 = L2_1
  L16_2 = L2_2
  L15_2 = L15_2(L16_2)
  L16_2 = Now
  L16_2 = L16_2()
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L7_2(L8_2, L9_2)
  L7_2 = L3_1
  L8_2 = L3_2
  L7_2 = L7_2(L8_2)
  L8_2 = {}
  L8_2.ok = true
  L9_2 = L7_2.avg
  L8_2.avg = L9_2
  L9_2 = L7_2.count
  L8_2.count = L9_2
  return L8_2
end
L4_1["apps.rate"] = L5_1
L4_1 = RPC
function L5_1(A0_2, A1_2)
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
  L3_2 = L1_1
  L4_2 = A1_2.app
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_app_ratings WHERE owner = ? AND app = ?"
  L6_2 = {}
  L7_2 = L2_2
  L8_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L4_1["apps.unrate"] = L5_1
