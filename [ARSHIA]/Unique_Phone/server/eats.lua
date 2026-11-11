local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1
L0_1 = Config
L0_1 = L0_1.Eats
if not L0_1 then
  L0_1 = {}
end
L1_1 = L0_1.enabled
if false == L1_1 then
  return
end
L1_1 = {}
L2_1 = {}
L3_1 = CreateThread
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L0_2 = ipairs
  L1_2 = L0_1.restaurants
  if not L1_2 then
    L1_2 = {}
  end
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L7_2 = L5_2.id
    L6_2 = L1_1
    L6_2[L7_2] = L5_2
    L7_2 = L5_2.id
    L6_2 = L2_1
    L8_2 = {}
    L6_2[L7_2] = L8_2
    L6_2 = ipairs
    L7_2 = L5_2.menu
    if not L7_2 then
      L7_2 = {}
    end
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = ipairs
      L13_2 = L11_2.items
      if not L13_2 then
        L13_2 = {}
      end
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
      for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
        L19_2 = L5_2.id
        L18_2 = L2_1
        L18_2 = L18_2[L19_2]
        L19_2 = L17_2.id
        L18_2[L19_2] = L17_2
      end
    end
  end
end
L3_1(L4_1)
L3_1 = false
L4_1 = " DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L5_1 = CreateThread
function L6_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_eats_orders` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `owner` VARCHAR(64) NOT NULL, `phone` VARCHAR(20) NULL, `name` VARCHAR(64) NULL,
        `restaurant` VARCHAR(40) NOT NULL, `items` LONGTEXT NULL, `note` VARCHAR(200) NULL,
        `subtotal` DECIMAL(10,2) NOT NULL DEFAULT 0, `fee` DECIMAL(10,2) NOT NULL DEFAULT 0,
        `service` DECIMAL(10,2) NOT NULL DEFAULT 0, `smallfee` DECIMAL(10,2) NOT NULL DEFAULT 0,
        `discount` DECIMAL(10,2) NOT NULL DEFAULT 0, `tip` DECIMAL(10,2) NOT NULL DEFAULT 0,
        `total` DECIMAL(10,2) NOT NULL DEFAULT 0,
        `pay` VARCHAR(10) NOT NULL DEFAULT 'card', `promo` VARCHAR(24) NULL,
        `addr_label` VARCHAR(64) NULL, `addr_x` FLOAT NULL, `addr_y` FLOAT NULL,
        `status` VARCHAR(16) NOT NULL DEFAULT 'pending',
        `courier` VARCHAR(64) NULL, `courier_name` VARCHAR(64) NULL, `courier_phone` VARCHAR(20) NULL,
        `courier_npc` TINYINT NOT NULL DEFAULT 0,
        `created` BIGINT NOT NULL, `ready_at` BIGINT NULL, `delivered` BIGINT NULL,
        `rating` TINYINT NULL, `rating_note` VARCHAR(200) NULL,
        KEY `owner` (`owner`), KEY `st` (`status`), KEY `cour` (`courier`))]]
  L1_2 = L4_1
  L0_2 = L0_2 .. L1_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = L0_2
  L1_2(L2_2)
  L1_2 = pcall
  L2_2 = MigrateTable
  L3_2 = L0_2
  L1_2(L2_2, L3_2)
  L1_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_eats_addresses` (
        `id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL,
        `label` VARCHAR(64) NOT NULL, `note` VARCHAR(120) NULL,
        `x` FLOAT NOT NULL, `y` FLOAT NOT NULL, `created` BIGINT NOT NULL,
        KEY `owner` (`owner`))]]
  L2_2 = L4_1
  L1_2 = L1_2 .. L2_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = L1_2
  L2_2(L3_2)
  L2_2 = pcall
  L3_2 = MigrateTable
  L4_2 = L1_2
  L2_2(L3_2, L4_2)
  L2_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_eats_meta` (
        `owner` VARCHAR(64) NOT NULL PRIMARY KEY,
        `favorites` TEXT NULL, `promos` TEXT NULL, `pro_until` BIGINT NULL,
        `deliveries` INT NOT NULL DEFAULT 0, `earnings` DECIMAL(12,2) NOT NULL DEFAULT 0,
        `rating_sum` INT NOT NULL DEFAULT 0, `rating_n` INT NOT NULL DEFAULT 0)]]
  L3_2 = L4_1
  L2_2 = L2_2 .. L3_2
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = L2_2
  L3_2(L4_2)
  L3_2 = pcall
  L4_2 = MigrateTable
  L5_2 = L2_2
  L3_2(L4_2, L5_2)
  L3_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_eats_pending` (
        `id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `order_id` INT NOT NULL DEFAULT 0,
        `item` VARCHAR(64) NOT NULL, `count` INT NOT NULL DEFAULT 1, `dish` VARCHAR(64) NULL,
        `refund` DECIMAL(10,2) NOT NULL DEFAULT 0, `pay` VARCHAR(10) NOT NULL DEFAULT 'card',
        `status` VARCHAR(12) NOT NULL DEFAULT 'pending', `tries` INT NOT NULL DEFAULT 0,
        `created` BIGINT NOT NULL, `updated` BIGINT NOT NULL,
        KEY `own` (`owner`, `status`), KEY `st` (`status`, `updated`))]]
  L4_2 = L4_1
  L3_2 = L3_2 .. L4_2
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L3_2
    L0_3(L1_3)
    L0_3 = pcall
    L1_3 = MigrateTable
    L2_3 = L3_2
    L0_3(L1_3, L2_3)
  end
  L4_2, L5_2 = L4_2(L5_2)
  L6_2 = true == L4_2
  L3_1 = L6_2
  L6_2 = L3_1
  if L6_2 then
    L6_2 = pcall
    L7_2 = EnsureIndex
    L8_2 = "apex_phone_eats_pending"
    L9_2 = "st"
    L10_2 = {}
    L11_2 = "status"
    L12_2 = "updated"
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L6_2(L7_2, L8_2, L9_2, L10_2)
  end
  L6_2 = L3_1
  if not L6_2 then
    L6_2 = print
    L7_2 = "^1[unique_phone]^0 eats: could not create apex_phone_eats_pending (%s): deliveries that fail are refunded immediately"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = tostring
    L10_2 = L5_2
    L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2)
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  end
  L6_2 = FW
  L6_2 = L6_2.WidenColumns
  L7_2 = {}
  L8_2 = {}
  L9_2 = "apex_phone_eats_orders"
  L10_2 = "owner"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L9_2 = {}
  L10_2 = "apex_phone_eats_orders"
  L11_2 = "courier"
  L12_2 = true
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = "apex_phone_eats_addresses"
  L12_2 = "owner"
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L11_2 = {}
  L12_2 = "apex_phone_eats_meta"
  L13_2 = "owner"
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L6_2(L7_2)
end
L5_1(L6_1)
function L5_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L2_2 = L2_2 * 100
  L2_2 = L2_2 + 0.5
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 / 100
  return L1_2
end
function L6_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2 or A0_2
  if not L3_2 then
    A0_2 = A1_2
  end
  if A1_2 > A0_2 then
    return A1_2
  end
  if A2_2 < A0_2 then
    return A2_2
  end
  return A0_2
end
L7_1 = 15000
L8_1 = {}
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = "|"
  L4_2 = A1_2
  L2_2 = L2_2 .. L3_2 .. L4_2
  L3_2 = L8_1
  L3_2 = L3_2[L2_2]
  if L3_2 then
    L4_2 = Now
    L4_2 = L4_2()
    L4_2 = L4_2 - L3_2
    L5_2 = L7_1
    if L4_2 < L5_2 then
      L4_2 = false
      return L4_2
    end
  end
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = L8_1
  L5_2[L2_2] = L4_2
  return L4_2
end
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  if not A0_2 then
    return
  end
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = "|"
  L5_2 = A1_2
  L3_2 = L3_2 .. L4_2 .. L5_2
  L4_2 = L8_1
  L4_2 = L4_2[L3_2]
  if L4_2 == A2_2 then
    L4_2 = L8_1
    L4_2[L3_2] = nil
  end
end
function L11_1(A0_2, A1_2, A2_2, ...)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L9_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "busy"
    return L4_2
  end
  L4_2 = pcall
  L5_2 = A2_2
  L6_2, L7_2, L8_2, L9_2 = ...
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L6_2 = L10_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = L3_2
  L6_2(L7_2, L8_2, L9_2)
  if not L4_2 then
    L6_2 = error
    L7_2 = L5_2
    L8_2 = 0
    L6_2(L7_2, L8_2)
  end
  return L5_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetPlayerPed
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 or 0 == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = GetEntityCoords
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.x
  L4_2 = L4_2 + 0.0
  L3_2.x = L4_2
  L4_2 = L2_2.y
  L4_2 = L4_2 + 0.0
  L3_2.y = L4_2
  return L3_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 or not A1_2 then
    L2_2 = math
    L2_2 = L2_2.huge
    return L2_2
  end
  L2_2 = A0_2.x
  if not L2_2 then
    L2_2 = 0
  end
  L3_2 = A1_2.x
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2 - L3_2
  L3_2 = A0_2.y
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = A1_2.y
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2 - L4_2
  L4_2 = L2_2 * L2_2
  L5_2 = L3_2 * L3_2
  L4_2 = L4_2 + L5_2
  return L4_2
end
L14_1 = 12
function L15_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = math
    L2_2 = L2_2.floor
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    L2_2 = L2_2 % 24
    L14_1 = L2_2
  end
  L2_2 = L14_1
  return L2_2
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = A0_2.open
  if L2_2 then
    L3_2 = L2_2[1]
    if 0 ~= L3_2 then
      goto lbl_12
    end
    L3_2 = L2_2[2]
    if 24 ~= L3_2 then
      goto lbl_12
    end
  end
  L3_2 = true
  do return L3_2 end
  ::lbl_12::
  L3_2 = tonumber
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L14_1
  end
  L4_2 = L2_2[1]
  L4_2 = L4_2 % 24
  L5_2 = L2_2[2]
  L5_2 = L5_2 % 24
  if L4_2 == L5_2 then
    L6_2 = true
    return L6_2
  end
  if L4_2 < L5_2 then
    L6_2 = L3_2 >= L4_2 and L3_2 < L5_2
    return L6_2
  end
  L6_2 = L3_2 >= L4_2 or L3_2 < L5_2
  return L6_2
end
L17_1 = {}
L18_1 = "Rui Marques"
L19_1 = "Ana Ferreira"
L20_1 = "Tiago Sousa"
L21_1 = "Marta Nunes"
L22_1 = "Bruno Alves"
L23_1 = "Carla Pinto"
L24_1 = "Diogo Cunha"
L25_1 = "Ines Ramos"
L26_1 = "Pedro Matos"
L27_1 = "Sofia Leal"
L17_1[1] = L18_1
L17_1[2] = L19_1
L17_1[3] = L20_1
L17_1[4] = L21_1
L17_1[5] = L22_1
L17_1[6] = L23_1
L17_1[7] = L24_1
L17_1[8] = L25_1
L17_1[9] = L26_1
L17_1[10] = L27_1
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT * FROM apex_phone_eats_meta WHERE owner = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = MySQL
    L2_2 = L2_2.insert
    L2_2 = L2_2.await
    L3_2 = "INSERT IGNORE INTO apex_phone_eats_meta (owner, favorites, promos, pro_until) VALUES (?, \"[]\", \"{}\", 0)"
    L4_2 = {}
    L5_2 = A0_2
    L4_2[1] = L5_2
    L2_2(L3_2, L4_2)
    L2_2 = {}
    L2_2.owner = A0_2
    L2_2.favorites = "[]"
    L2_2.promos = "{}"
    L2_2.pro_until = 0
    L2_2.deliveries = 0
    L2_2.earnings = 0
    L2_2.rating_sum = 0
    L2_2.rating_n = 0
    L1_2 = L2_2
  end
  L2_2 = pcall
  L3_2 = json
  L3_2 = L3_2.decode
  L4_2 = L1_2.favorites
  if not L4_2 then
    L4_2 = "[]"
  end
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  L4_2 = pcall
  L5_2 = json
  L5_2 = L5_2.decode
  L6_2 = L1_2.promos
  if not L6_2 then
    L6_2 = "{}"
  end
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if L2_2 then
    L6_2 = type
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 and L3_2 then
      goto lbl_63
      L6_2 = L3_2 or L6_2
    end
  end
  L6_2 = {}
  ::lbl_63::
  L1_2.favorites = L6_2
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 and L5_2 then
      goto lbl_75
      L6_2 = L5_2 or L6_2
    end
  end
  L6_2 = {}
  ::lbl_75::
  L1_2.promos = L6_2
  return L1_2
end
function L19_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2 or nil
  if A0_2 then
    L1_2 = tonumber
    L2_2 = A0_2.pro_until
    if not L2_2 then
      L2_2 = 0
    end
    L1_2 = L1_2(L2_2)
    L2_2 = Now
    L2_2 = L2_2()
    L1_2 = L1_2 > L2_2
  end
  return L1_2
end
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2
  L2_2 = L1_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L3_2 = nil
    L4_2 = "restaurant"
    return L3_2, L4_2
  end
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = #A1_2
    if 0 ~= L3_2 then
      goto lbl_19
    end
  end
  L3_2 = nil
  L4_2 = "empty"
  do return L3_2, L4_2 end
  ::lbl_19::
  L3_2 = #A1_2
  if L3_2 > 40 then
    L3_2 = nil
    L4_2 = "toomany"
    return L3_2, L4_2
  end
  L3_2 = {}
  L4_2 = 0.0
  L5_2 = ipairs
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L2_1
    L11_2 = L11_2[A0_2]
    if L11_2 then
      L11_2 = L2_1
      L11_2 = L11_2[A0_2]
      L12_2 = tostring
      L13_2 = L10_2.id
      if not L13_2 then
        L13_2 = ""
      end
      L12_2 = L12_2(L13_2)
      L11_2 = L11_2[L12_2]
    end
    if not L11_2 then
      L12_2 = nil
      L13_2 = "dish"
      return L12_2, L13_2
    end
    L12_2 = math
    L12_2 = L12_2.floor
    L13_2 = L6_1
    L14_2 = L10_2.qty
    L15_2 = 1
    L16_2 = 20
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2 = L13_2(L14_2, L15_2, L16_2)
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2)
    L13_2 = tonumber
    L14_2 = L11_2.price
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = 0
    end
    L14_2 = {}
    L15_2 = ipairs
    L16_2 = L11_2.options
    if not L16_2 then
      L16_2 = {}
    end
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
      L21_2 = L10_2.opts
      if L21_2 then
        L21_2 = L10_2.opts
        L22_2 = L20_2.id
        L21_2 = L21_2[L22_2]
      end
      L22_2 = type
      L23_2 = L21_2
      L22_2 = L22_2(L23_2)
      if "table" ~= L22_2 then
        if L21_2 then
          L22_2 = {}
          L23_2 = L21_2
          L22_2[1] = L23_2
          if L22_2 then
            goto lbl_96
            L21_2 = L22_2 or L21_2
          end
        end
        L22_2 = {}
        L21_2 = L22_2
      end
      ::lbl_96::
      L22_2 = 0
      L23_2 = ipairs
      L24_2 = L21_2
      L23_2, L24_2, L25_2, L26_2 = L23_2(L24_2)
      for L27_2, L28_2 in L23_2, L24_2, L25_2, L26_2 do
        L29_2 = nil
        L30_2 = ipairs
        L31_2 = L20_2.choices
        if not L31_2 then
          L31_2 = {}
        end
        L30_2, L31_2, L32_2, L33_2 = L30_2(L31_2)
        for L34_2, L35_2 in L30_2, L31_2, L32_2, L33_2 do
          L36_2 = L35_2.id
          if L36_2 == L28_2 then
            L29_2 = L35_2
            break
          end
        end
        if not L29_2 then
          L30_2 = nil
          L31_2 = "option"
          return L30_2, L31_2
        end
        L22_2 = L22_2 + 1
        L30_2 = tonumber
        L31_2 = L29_2.price
        L30_2 = L30_2(L31_2)
        if not L30_2 then
          L30_2 = 0
        end
        L13_2 = L13_2 + L30_2
        L30_2 = #L14_2
        L30_2 = L30_2 + 1
        L31_2 = {}
        L32_2 = L20_2.id
        L31_2.g = L32_2
        L32_2 = L29_2.id
        L31_2.id = L32_2
        L32_2 = L29_2.name
        L31_2.name = L32_2
        L32_2 = tonumber
        L33_2 = L29_2.price
        L32_2 = L32_2(L33_2)
        if not L32_2 then
          L32_2 = 0
        end
        L31_2.price = L32_2
        L14_2[L30_2] = L31_2
      end
      L23_2 = L20_2.min
      if not L23_2 then
        L23_2 = 0
      end
      if L22_2 < L23_2 then
        L23_2 = nil
        L24_2 = "optmin"
        return L23_2, L24_2
      end
      L23_2 = L20_2.max
      if not L23_2 then
        L23_2 = 99
      end
      if L22_2 > L23_2 then
        L23_2 = nil
        L24_2 = "optmax"
        return L23_2, L24_2
      end
    end
    L15_2 = L5_1
    L16_2 = L13_2
    L15_2 = L15_2(L16_2)
    L13_2 = L15_2
    L15_2 = L13_2 * L12_2
    L4_2 = L4_2 + L15_2
    L15_2 = #L3_2
    L15_2 = L15_2 + 1
    L16_2 = {}
    L17_2 = L11_2.id
    L16_2.id = L17_2
    L17_2 = L11_2.name
    L16_2.name = L17_2
    L16_2.qty = L12_2
    L16_2.unit = L13_2
    L17_2 = L5_1
    L18_2 = L13_2 * L12_2
    L17_2 = L17_2(L18_2)
    L16_2.total = L17_2
    L16_2.opts = L14_2
    L17_2 = tostring
    L18_2 = L10_2.note
    if not L18_2 then
      L18_2 = ""
    end
    L17_2 = L17_2(L18_2)
    L18_2 = L17_2
    L17_2 = L17_2.sub
    L19_2 = 1
    L20_2 = 80
    L17_2 = L17_2(L18_2, L19_2, L20_2)
    L16_2.note = L17_2
    L17_2 = L11_2.item
    L16_2.item = L17_2
    L3_2[L15_2] = L16_2
  end
  L5_2 = L3_2
  L6_2 = L5_1
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2 = L6_2(L7_2)
  return L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2
end
function L21_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if not A1_2 or "" == A1_2 then
    L3_2 = 0
    L4_2 = false
    return L3_2, L4_2
  end
  L3_2 = tostring
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.upper
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 24
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A1_2 = L3_2
  L3_2 = nil
  L4_2 = ipairs
  L5_2 = L0_1.promos
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.code
    if L10_2 == A1_2 then
      L3_2 = L9_2
      break
    end
  end
  if not L3_2 then
    L4_2 = 0
    L5_2 = false
    L6_2 = "invalid"
    return L4_2, L5_2, L6_2
  end
  L4_2 = tonumber
  L5_2 = A0_2.promos
  if not L5_2 then
    L5_2 = {}
  end
  L5_2 = L5_2[A1_2]
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L3_2.uses
  if not L5_2 then
    L5_2 = 1
  end
  if L4_2 >= L5_2 then
    L5_2 = 0
    L6_2 = false
    L7_2 = "used"
    return L5_2, L6_2, L7_2
  end
  L5_2 = L3_2.min
  if L5_2 then
    L5_2 = L3_2.min
    if A2_2 < L5_2 then
      L5_2 = 0
      L6_2 = false
      L7_2 = "min"
      return L5_2, L6_2, L7_2
    end
  end
  L5_2 = 0.0
  L6_2 = L3_2.percent
  if L6_2 then
    L6_2 = L3_2.percent
    L6_2 = L6_2 / 100
    L5_2 = A2_2 * L6_2
  end
  L6_2 = L3_2.max
  if L6_2 then
    L6_2 = L3_2.max
    if L5_2 > L6_2 then
      L5_2 = L3_2.max
    end
  end
  L6_2 = L3_2.off
  if L6_2 then
    L6_2 = L3_2.off
    L5_2 = L5_2 + L6_2
  end
  if A2_2 < L5_2 then
    L5_2 = A2_2
  end
  L6_2 = L5_1
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L7_2 = L3_2.freeDelivery
  L7_2 = true == L7_2
  return L6_2, L7_2
end
function L22_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L5_2 = L20_1
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L7_2 = nil
    L8_2 = L6_2
    return L7_2, L8_2
  end
  L7_2 = L1_1
  L7_2 = L7_2[A0_2]
  L8_2 = L21_1
  L9_2 = A4_2
  L10_2 = A3_2
  L11_2 = L6_2
  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2, L11_2)
  L11_2 = tonumber
  L12_2 = L7_2.fee
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = 0
  end
  if not L9_2 then
    L12_2 = L19_1
    L13_2 = A4_2
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      goto lbl_31
    end
  end
  L11_2 = 0
  ::lbl_31::
  L12_2 = 0.0
  L13_2 = L0_1.smallOrder
  if L13_2 then
    L14_2 = L13_2.under
    if L14_2 then
      L14_2 = L13_2.under
      if L6_2 < L14_2 then
        L14_2 = tonumber
        L15_2 = L13_2.fee
        L14_2 = L14_2(L15_2)
        L12_2 = L14_2 or L12_2
        if not L14_2 then
          L12_2 = 0
        end
      end
    end
  end
  L14_2 = tonumber
  L15_2 = L0_1.serviceFee
  L14_2 = L14_2(L15_2)
  if not L14_2 then
    L14_2 = 0
  end
  L15_2 = L5_1
  L16_2 = L6_1
  L17_2 = A2_2
  L18_2 = 0
  L19_2 = 500
  L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2, L18_2, L19_2)
  L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
  A2_2 = L15_2
  L15_2 = L5_1
  L16_2 = L6_2 - L8_2
  L16_2 = L16_2 + L11_2
  L16_2 = L16_2 + L12_2
  L16_2 = L16_2 + L14_2
  L16_2 = L16_2 + A2_2
  L15_2 = L15_2(L16_2)
  if L15_2 < 0 then
    L15_2 = 0
  end
  L16_2 = {}
  L16_2.lines = L5_2
  L16_2.subtotal = L6_2
  L16_2.discount = L8_2
  L17_2 = L5_1
  L18_2 = L11_2
  L17_2 = L17_2(L18_2)
  L16_2.fee = L17_2
  L17_2 = L5_1
  L18_2 = L12_2
  L17_2 = L17_2(L18_2)
  L16_2.smallfee = L17_2
  L17_2 = L5_1
  L18_2 = L14_2
  L17_2 = L17_2(L18_2)
  L16_2.service = L17_2
  L16_2.tip = A2_2
  L16_2.total = L15_2
  if L8_2 > 0 or L9_2 then
    L17_2 = tostring
    L18_2 = A3_2 or L18_2
    if not A3_2 then
      L18_2 = ""
    end
    L17_2 = L17_2(L18_2)
    L18_2 = L17_2
    L17_2 = L17_2.upper
    L17_2 = L17_2(L18_2)
    if L17_2 then
      goto lbl_109
    end
  end
  L17_2 = nil
  ::lbl_109::
  L16_2.promo = L17_2
  L16_2.promoError = L10_2
  L17_2 = L19_1
  L18_2 = A4_2
  L17_2 = L17_2(L18_2)
  L17_2 = true == L17_2
  L16_2.pro = L17_2
  return L16_2
end
L23_1 = {}
L24_1 = {}
L25_1 = {}
function L26_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = A0_2.id
  L1_2.id = L2_2
  L2_2 = A0_2.restaurant
  L1_2.restaurant = L2_2
  L3_2 = A0_2.restaurant
  L2_2 = L1_1
  L2_2 = L2_2[L3_2]
  if not L2_2 then
    L2_2 = {}
  end
  L2_2 = L2_2.name
  L1_2.restName = L2_2
  L2_2 = A0_2.lines
  L1_2.items = L2_2
  L2_2 = A0_2.note
  L1_2.note = L2_2
  L2_2 = A0_2.subtotal
  L1_2.subtotal = L2_2
  L2_2 = A0_2.fee
  L1_2.fee = L2_2
  L2_2 = A0_2.service
  L1_2.service = L2_2
  L2_2 = A0_2.smallfee
  L1_2.smallfee = L2_2
  L2_2 = A0_2.discount
  L1_2.discount = L2_2
  L2_2 = A0_2.tip
  L1_2.tip = L2_2
  L2_2 = A0_2.total
  L1_2.total = L2_2
  L2_2 = A0_2.pay
  L1_2.pay = L2_2
  L2_2 = A0_2.promo
  L1_2.promo = L2_2
  L2_2 = {}
  L3_2 = A0_2.addr_label
  L2_2.label = L3_2
  L3_2 = A0_2.addr_x
  L2_2.x = L3_2
  L3_2 = A0_2.addr_y
  L2_2.y = L3_2
  L1_2.addr = L2_2
  L2_2 = A0_2.status
  L1_2.status = L2_2
  L2_2 = A0_2.created
  L1_2.created = L2_2
  L2_2 = A0_2.ready_at
  L1_2.readyAt = L2_2
  L2_2 = A0_2.delivered
  L1_2.delivered = L2_2
  L2_2 = A0_2.courier_name
  L1_2.courier = L2_2
  L2_2 = A0_2.courier_phone
  L1_2.courierPhone = L2_2
  L2_2 = A0_2.courier_npc
  L2_2 = 1 == L2_2
  L1_2.courierNpc = L2_2
  L2_2 = A0_2.eta
  L1_2.eta = L2_2
  L2_2 = A0_2.rating
  L1_2.rating = L2_2
  return L1_2
end
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayerByCid
  L3_2 = A0_2.owner
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = Push
    L4_2 = L2_2.src
    L5_2 = A1_2 or L5_2
    if not A1_2 then
      L5_2 = "eats:update"
    end
    L6_2 = L26_1
    L7_2 = A0_2
    L6_2, L7_2 = L6_2(L7_2)
    L3_2(L4_2, L5_2, L6_2, L7_2)
  end
end
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  A0_2.status = A1_2
  L3_2 = {}
  L4_2 = "status = ?"
  L3_2[1] = L4_2
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  L5_2 = pairs
  L6_2 = A2_2 or L6_2
  if not A2_2 then
    L6_2 = {}
  end
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L3_2
    L11_2 = L11_2 + 1
    L12_2 = L9_2
    L13_2 = " = ?"
    L12_2 = L12_2 .. L13_2
    L3_2[L11_2] = L12_2
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L4_2[L11_2] = L10_2
    A0_2[L9_2] = L10_2
  end
  L5_2 = #L4_2
  L5_2 = L5_2 + 1
  L6_2 = A0_2.id
  L4_2[L5_2] = L6_2
  L5_2 = MySQL
  L5_2 = L5_2.update
  L6_2 = "UPDATE apex_phone_eats_orders SET "
  L7_2 = table
  L7_2 = L7_2.concat
  L8_2 = L3_2
  L9_2 = ", "
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = " WHERE id = ?"
  L6_2 = L6_2 .. L7_2 .. L8_2
  L7_2 = L4_2
  L5_2(L6_2, L7_2)
  L5_2 = L27_1
  L6_2 = A0_2
  L5_2(L6_2)
  L5_2 = A0_2.courier
  if L5_2 then
    L5_2 = A0_2.courier_npc
    if 1 ~= L5_2 then
      L5_2 = FW
      L5_2 = L5_2.GetPlayerByCid
      L6_2 = A0_2.courier
      L5_2 = L5_2(L6_2)
      if L5_2 then
        L6_2 = Push
        L7_2 = L5_2.src
        L8_2 = "eats:job"
        L9_2 = L26_1
        L10_2 = A0_2
        L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2)
        L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
      end
    end
  end
end
function L29_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L24_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L0_1.courierJob
  if L1_2 then
    L1_2 = L0_1.courierJob
    if "" ~= L1_2 then
      L1_2 = FW
      L1_2 = L1_2.GetPlayer
      L2_2 = A0_2
      L1_2 = L1_2(L2_2)
      if L1_2 then
        L2_2 = L1_2.job
        if L2_2 then
          L2_2 = L1_2.job
          L2_2 = L2_2.name
          L3_2 = L0_1.courierJob
          if L2_2 == L3_2 then
            goto lbl_29
          end
        end
      end
      L2_2 = false
      return L2_2
    end
  end
  ::lbl_29::
  L1_2 = true
  return L1_2
end
function L30_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = A0_2.restaurant
  L1_2 = L1_1
  L1_2 = L1_2[L2_2]
  L2_2 = L1_2
  if L1_2 then
    L2_2 = L1_2.coords
  end
  L3_2 = tonumber
  L4_2 = L0_1.courierRadius
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 1200.0
  end
  L3_2 = L3_2 ^ 2
  L4_2 = 0
  L5_2 = pairs
  L6_2 = L24_1
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L29_1
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = L10_2.cid
      L11_2 = L25_1
      L11_2 = L11_2[L12_2]
      if not L11_2 then
        L11_2 = L12_1
        L12_2 = L9_2
        L11_2 = L11_2(L12_2)
        if L2_2 and L11_2 then
          L12_2 = L13_1
          L13_2 = L11_2
          L14_2 = L2_2
          L12_2 = L12_2(L13_2, L14_2)
          if not (L3_2 >= L12_2) then
            goto lbl_109
          end
        end
        L12_2 = Push
        L13_2 = L9_2
        L14_2 = "eats:offer"
        L15_2 = {}
        L16_2 = A0_2.id
        L15_2.id = L16_2
        L16_2 = A0_2.restaurant
        L15_2.restaurant = L16_2
        if L1_2 then
          L16_2 = L1_2.name
          if L16_2 then
            goto lbl_58
          end
        end
        L16_2 = A0_2.restaurant
        ::lbl_58::
        L15_2.restName = L16_2
        L15_2.restCoords = L2_2
        L16_2 = {}
        L17_2 = A0_2.addr_label
        L16_2.label = L17_2
        L17_2 = A0_2.addr_x
        L16_2.x = L17_2
        L17_2 = A0_2.addr_y
        L16_2.y = L17_2
        L15_2.addr = L16_2
        L16_2 = A0_2.lines
        L16_2 = #L16_2
        L15_2.items = L16_2
        L16_2 = A0_2.total
        L15_2.total = L16_2
        L16_2 = L5_1
        L17_2 = tonumber
        L18_2 = A0_2.fee
        L17_2 = L17_2(L18_2)
        if not L17_2 then
          L17_2 = 0
        end
        L18_2 = tonumber
        L19_2 = L0_1.courierCutPct
        L18_2 = L18_2(L19_2)
        if not L18_2 then
          L18_2 = 70
        end
        L18_2 = L18_2 / 100
        L17_2 = L17_2 * L18_2
        L18_2 = tonumber
        L19_2 = A0_2.tip
        L18_2 = L18_2(L19_2)
        if not L18_2 then
          L18_2 = 0
        end
        L17_2 = L17_2 + L18_2
        L16_2 = L16_2(L17_2)
        L15_2.pay = L16_2
        L16_2 = L0_1.offerSeconds
        if not L16_2 then
          L16_2 = 30
        end
        L15_2.seconds = L16_2
        L12_2(L13_2, L14_2, L15_2)
        L4_2 = L4_2 + 1
      end
    end
    ::lbl_109::
  end
  return L4_2
end
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = math
  L1_2 = L1_2.random
  L2_2 = L17_1
  L2_2 = #L2_2
  L1_2 = L1_2(L2_2)
  L2_2 = L17_1
  L1_2 = L2_2[L1_2]
  A0_2.courier_npc = 1
  A0_2.courier_name = L1_2
  A0_2.courier = nil
  A0_2.courier_phone = nil
  L2_2 = L28_1
  L3_2 = A0_2
  L4_2 = "accepted"
  L5_2 = {}
  L5_2.courier_npc = 1
  L5_2.courier_name = L1_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = NotifyCitizen
  L3_2 = A0_2.owner
  L4_2 = "eats"
  L5_2 = "Pedido aceite"
  L6_2 = L1_2
  L7_2 = " vai tratar da tua entrega."
  L6_2 = L6_2 .. L7_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = A0_2.restaurant
  L1_2 = L1_1
  L1_2 = L1_2[L2_2]
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = L5_1
  L3_2 = tonumber
  L4_2 = A0_2.subtotal
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = tonumber
  L5_2 = A0_2.discount
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2 - L4_2
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = L1_2.society
  if L4_2 then
    L4_2 = L1_2.society
    if "" ~= L4_2 and L3_2 >= 1 then
      L4_2 = pcall
      L5_2 = FW
      L5_2 = L5_2.AddSocietyMoney
      L6_2 = L1_2.society
      L7_2 = L3_2
      L8_2 = "eats-"
      L9_2 = tostring
      L10_2 = A0_2.id
      L9_2 = L9_2(L10_2)
      L8_2 = L8_2 .. L9_2
      L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
      if not L4_2 or false == L5_2 then
        L6_2 = print
        L7_2 = "^3[unique_phone]^0 eats #%s: the %s for the food did not reach society %s (%s)"
        L8_2 = L7_2
        L7_2 = L7_2.format
        L9_2 = tostring
        L10_2 = A0_2.id
        L9_2 = L9_2(L10_2)
        L10_2 = FormatMoney
        L11_2 = L3_2
        L10_2 = L10_2(L11_2)
        L11_2 = tostring
        L12_2 = L1_2.society
        L11_2 = L11_2(L12_2)
        if L4_2 then
          L12_2 = "refused"
          if L12_2 then
            goto lbl_71
          end
        end
        L12_2 = tostring
        L13_2 = L5_2
        L12_2 = L12_2(L13_2)
        ::lbl_71::
        L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
        L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
      end
    end
  end
  L4_2 = tonumber
  L5_2 = L0_1.courierCutPct
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 70
  end
  L4_2 = L4_2 / 100
  L5_2 = L5_1
  L6_2 = tonumber
  L7_2 = A0_2.fee
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L6_2 = L6_2 * L4_2
  L7_2 = tonumber
  L8_2 = A0_2.tip
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L6_2 = L6_2 + L7_2
  L5_2 = L5_2(L6_2)
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L7_2 = 0
  L8_2 = A0_2.courier
  if L8_2 then
    L8_2 = A0_2.courier_npc
    if 1 ~= L8_2 then
      if L6_2 >= 1 then
        L8_2 = FW
        L8_2 = L8_2.GetPlayerByCid
        L9_2 = A0_2.courier
        L8_2 = L8_2(L9_2)
        L9_2 = false
        if L8_2 then
          L10_2 = L8_2.AddMoney
          L11_2 = "cash"
          L12_2 = L6_2
          L13_2 = "eats-delivery-"
          L14_2 = tostring
          L15_2 = A0_2.id
          L14_2 = L14_2(L15_2)
          L13_2 = L13_2 .. L14_2
          L10_2 = L10_2(L11_2, L12_2, L13_2)
          L9_2 = false ~= L10_2
        end
        if not L9_2 then
          L10_2 = FW
          L10_2 = L10_2.AddMoneyOffline
          L11_2 = A0_2.courier
          L12_2 = "bank"
          L13_2 = L6_2
          L10_2 = L10_2(L11_2, L12_2, L13_2)
          L9_2 = true == L10_2
        end
        if L9_2 then
          L7_2 = L6_2
          L10_2 = NotifyCitizen
          L11_2 = A0_2.courier
          L12_2 = "eats"
          L13_2 = "Entrega concluida"
          L14_2 = "Ganhaste %s."
          L15_2 = L14_2
          L14_2 = L14_2.format
          L16_2 = FormatMoney
          L17_2 = L6_2
          L16_2, L17_2 = L16_2(L17_2)
          L14_2 = L14_2(L15_2, L16_2, L17_2)
          L15_2 = nil
          L16_2 = {}
          L16_2.throttle = false
          L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
          L10_2 = AddTransaction
          L11_2 = A0_2.courier
          L12_2 = "Eats: entrega #"
          L13_2 = tostring
          L14_2 = A0_2.id
          L13_2 = L13_2(L14_2)
          L12_2 = L12_2 .. L13_2
          L13_2 = L6_2
          L10_2(L11_2, L12_2, L13_2)
        else
          L10_2 = print
          L11_2 = "^1[unique_phone]^0 eats #%s: could not pay %s to courier %s"
          L12_2 = L11_2
          L11_2 = L11_2.format
          L13_2 = tostring
          L14_2 = A0_2.id
          L13_2 = L13_2(L14_2)
          L14_2 = FormatMoney
          L15_2 = L6_2
          L14_2 = L14_2(L15_2)
          L15_2 = tostring
          L16_2 = A0_2.courier
          L15_2, L16_2, L17_2 = L15_2(L16_2)
          L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
          L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
          L10_2 = NotifyCitizen
          L11_2 = A0_2.courier
          L12_2 = "eats"
          L13_2 = "Entrega concluida"
          L14_2 = "Nao consegui pagar os %s desta entrega; fala com a administracao."
          L15_2 = L14_2
          L14_2 = L14_2.format
          L16_2 = FormatMoney
          L17_2 = L6_2
          L16_2, L17_2 = L16_2(L17_2)
          L14_2 = L14_2(L15_2, L16_2, L17_2)
          L15_2 = nil
          L16_2 = {}
          L16_2.throttle = false
          L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
        end
      else
        L8_2 = NotifyCitizen
        L9_2 = A0_2.courier
        L10_2 = "eats"
        L11_2 = "Entrega concluida"
        if L5_2 > 0 then
          L12_2 = "Esta entrega rendeu %s: a carteira so mexe valores inteiros e nao entrou nada."
          L13_2 = L12_2
          L12_2 = L12_2.format
          L14_2 = FormatMoney
          L15_2 = L5_2
          L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
          L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
          if L12_2 then
            goto lbl_217
          end
        end
        L12_2 = "Esta entrega nao tinha taxa de entrega nem gorjeta."
        ::lbl_217::
        L13_2 = nil
        L14_2 = {}
        L14_2.throttle = false
        L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      end
      L8_2 = MySQL
      L8_2 = L8_2.update
      L9_2 = "UPDATE apex_phone_eats_meta SET deliveries = deliveries + 1, earnings = earnings + ? WHERE owner = ?"
      L10_2 = {}
      L11_2 = L7_2
      L12_2 = A0_2.courier
      L10_2[1] = L11_2
      L10_2[2] = L12_2
      L8_2(L9_2, L10_2)
    end
  end
  return L7_2
end
L33_1 = {}
L34_1 = 300000
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L33_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = L1_2.v
    if L2_2 then
      goto lbl_18
    end
  end
  L2_2 = nil
  ::lbl_18::
  if "no" == L2_2 then
    L3_2 = Now
    L3_2 = L3_2()
    L4_2 = L1_2.t
    if not L4_2 then
      L4_2 = 0
    end
    L3_2 = L3_2 - L4_2
    L4_2 = L34_1
    if L3_2 >= L4_2 then
      L2_2 = nil
    end
  end
  if nil == L2_2 then
    L3_2 = FW
    L3_2 = L3_2.InventoryName
    L3_2 = L3_2()
    if "ox_inventory" == L3_2 then
      L4_2 = pcall
      function L5_2()
        local L0_3, L1_3, L2_3
        L0_3 = exports
        L0_3 = L0_3.ox_inventory
        L1_3 = L0_3
        L0_3 = L0_3.Items
        L2_3 = A0_2
        return L0_3(L1_3, L2_3)
      end
      L4_2, L5_2 = L4_2(L5_2)
      if L4_2 then
        L6_2 = type
        L7_2 = L5_2
        L6_2 = L6_2(L7_2)
        if "table" == L6_2 then
          L6_2 = "yes"
          L2_2 = L6_2 or L2_2
        end
        if not L6_2 then
          L2_2 = "no"
        end
      end
    elseif "qb" == L3_2 then
      L4_2 = pcall
      function L5_2()
        local L0_3, L1_3
        L0_3 = exports
        L0_3 = L0_3["qb-core"]
        L1_3 = L0_3
        L0_3 = L0_3.GetCoreObject
        L0_3 = L0_3(L1_3)
        L0_3 = L0_3.Shared
        L0_3 = L0_3.Items
        L1_3 = A0_2
        L0_3 = L0_3[L1_3]
        return L0_3
      end
      L4_2, L5_2 = L4_2(L5_2)
      if L4_2 then
        L6_2 = type
        L7_2 = L5_2
        L6_2 = L6_2(L7_2)
        if "table" == L6_2 then
          L6_2 = "yes"
          if L6_2 then
            goto lbl_70
            L2_2 = L6_2 or L2_2
          end
        end
        L2_2 = "no"
      end
    end
    ::lbl_70::
    if L2_2 then
      L4_2 = L33_1
      L5_2 = {}
      L5_2.v = L2_2
      L6_2 = Now
      L6_2 = L6_2()
      L5_2.t = L6_2
      L4_2[A0_2] = L5_2
    end
  end
  if "yes" == L2_2 then
    L3_2 = true
    return L3_2
  end
  if "no" == L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = nil
  return L3_2
end
L36_1 = AddEventHandler
L37_1 = "onResourceStart"
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if "ox_inventory" == A0_2 or "qb-inventory" == A0_2 or "qb-core" == A0_2 or "qbx_core" == A0_2 or "es_extended" == A0_2 then
    L1_2 = {}
    L33_1 = L1_2
    L1_2 = print
    L2_2 = "[unique_phone] eats: %s restarted \226\128\148 the known-items cache was cleared"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = tostring
    L5_2 = A0_2
    L4_2, L5_2 = L4_2(L5_2)
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2)
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
end
L36_1(L37_1, L38_1)
function L36_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = FW
  L3_2 = L3_2.InventoryName
  L3_2 = L3_2()
  if "ox_inventory" == L3_2 then
    L3_2 = pcall
    function L4_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.CanCarryItem
      L2_3 = A0_2
      L3_3 = A1_2
      L4_3 = A2_2
      return L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L3_2, L4_2 = L3_2(L4_2)
    if L3_2 and true ~= L4_2 then
      L5_2 = false
      return L5_2
    end
  end
  L3_2 = pcall
  L4_2 = FW
  L4_2 = L4_2.AddItem
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = A2_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L5_2 = L3_2 or L5_2
  L5_2 = L3_2 and true == L4_2
  return L5_2
end
function L37_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = tonumber
  L4_2 = A0_2.subtotal
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = tonumber
  L5_2 = A0_2.discount
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L4_2 = L3_2 - L4_2
  if L3_2 <= 0 or L4_2 <= 0 then
    L5_2 = 0
    return L5_2
  end
  L5_2 = math
  L5_2 = L5_2.max
  L6_2 = 1
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = tonumber
  L9_2 = A1_2.qty
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 1
  end
  L7_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = A1_2.unit
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = tonumber
    L7_2 = A1_2.total
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 0
    end
    L6_2 = L6_2 / L5_2
  end
  L7_2 = math
  L7_2 = L7_2.min
  L8_2 = L5_2
  L9_2 = math
  L9_2 = L9_2.max
  L10_2 = 0
  L11_2 = math
  L11_2 = L11_2.floor
  L12_2 = tonumber
  L13_2 = A2_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = L5_2
  end
  L11_2 = L11_2(L12_2)
  L9_2 = L9_2(L10_2, L11_2)
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = L5_1
  L9_2 = L6_2 * L7_2
  L10_2 = L4_2 / L3_2
  L9_2 = L9_2 * L10_2
  return L8_2(L9_2)
end
function L38_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = L5_1
  L6_2 = A2_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  A2_2 = L4_2
  if not A0_2 or A2_2 < 1 then
    L4_2 = 0
    return L4_2
  end
  L4_2 = FW
  L4_2 = L4_2.GetPlayerByCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = false
  if L4_2 then
    L6_2 = L4_2.AddMoney
    if "cash" == A1_2 then
      L7_2 = "cash"
      if L7_2 then
        goto lbl_28
      end
    end
    L7_2 = "bank"
    ::lbl_28::
    L8_2 = A2_2
    L9_2 = "eats-refund-"
    L10_2 = tostring
    L11_2 = A3_2
    L10_2 = L10_2(L11_2)
    L9_2 = L9_2 .. L10_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L5_2 = false ~= L6_2
  end
  if not L5_2 then
    L6_2 = FW
    L6_2 = L6_2.AddMoneyOffline
    L7_2 = A0_2
    L8_2 = "bank"
    L9_2 = A2_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L5_2 = true == L6_2
  end
  if not L5_2 then
    L6_2 = 0
    return L6_2
  end
  L6_2 = AddTransaction
  L7_2 = A0_2
  L8_2 = "Eats: reembolso #"
  L9_2 = tostring
  L10_2 = A3_2
  L9_2 = L9_2(L10_2)
  L8_2 = L8_2 .. L9_2
  L9_2 = A2_2
  L6_2(L7_2, L8_2, L9_2)
  return A2_2
end
function L39_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L4_2 = L3_1
  if not L4_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = pcall
  L6_2 = MySQL
  L6_2 = L6_2.insert
  L6_2 = L6_2.await
  L7_2 = [[
INSERT INTO apex_phone_eats_pending
        (`owner`, `order_id`, `item`, `count`, `dish`, `refund`, `pay`, `status`, `tries`, `created`, `updated`)
        VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', 0, ?, ?)]]
  L8_2 = {}
  L9_2 = A0_2.owner
  L10_2 = tonumber
  L11_2 = A0_2.id
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 0
  end
  L11_2 = A1_2.item
  L12_2 = A2_2
  L13_2 = tostring
  L14_2 = A1_2.name
  if not L14_2 then
    L14_2 = A1_2.item
  end
  L13_2 = L13_2(L14_2)
  L14_2 = L13_2
  L13_2 = L13_2.sub
  L15_2 = 1
  L16_2 = 64
  L13_2 = L13_2(L14_2, L15_2, L16_2)
  L14_2 = L5_1
  L15_2 = A3_2
  L14_2 = L14_2(L15_2)
  L15_2 = A0_2.pay
  if "cash" == L15_2 then
    L15_2 = "cash"
    if L15_2 then
      goto lbl_44
    end
  end
  L15_2 = "card"
  ::lbl_44::
  L16_2 = L4_2
  L17_2 = L4_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L8_2[7] = L15_2
  L8_2[8] = L16_2
  L8_2[9] = L17_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L7_2 = tonumber
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L7_2 = true
      return L7_2
    end
  end
  L7_2 = print
  L8_2 = "^1[unique_phone]^0 eats #%s: %dx %s did not enter the delivery queue (%s)"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = tostring
  L11_2 = A0_2.id
  L10_2 = L10_2(L11_2)
  L11_2 = A2_2
  L12_2 = tostring
  L13_2 = A1_2.item
  L12_2 = L12_2(L13_2)
  L13_2 = tostring
  L14_2 = L6_2
  L13_2, L14_2, L15_2, L16_2, L17_2 = L13_2(L14_2)
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L7_2 = false
  return L7_2
end
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if A1_2 >= 1 then
    L2_2 = "Devolvemos %s."
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = FormatMoney
    L5_2 = A1_2
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    return L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = L0_1.itemRefund
  if false == L2_2 then
    L2_2 = "O valor deste prato nao e devolvido; fala com a administracao."
    return L2_2
  end
  if A0_2 <= 0 then
    L2_2 = "Nao havia valor a devolver por este prato."
    return L2_2
  end
  if A0_2 < 1 then
    L2_2 = "Custou %s e a carteira so mexe valores inteiros: nao houve nada a devolver."
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = FormatMoney
    L5_2 = A0_2
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    return L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = "Nao consegui devolver os %s; fala com a administracao."
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = FormatMoney
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = A0_2
  L5_2, L6_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if A1_2 >= 1 then
    L2_2 = "refunded %s (of %s calculated)"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = FormatMoney
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    L5_2 = FormatMoney
    L6_2 = A0_2
    L5_2, L6_2 = L5_2(L6_2)
    return L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = L0_1.itemRefund
  if false == L2_2 then
    L2_2 = "no refund (Config.Eats.itemRefund = false)"
    return L2_2
  end
  if A0_2 <= 0 then
    L2_2 = "no refund (nothing to refund)"
    return L2_2
  end
  if A0_2 < 1 then
    L2_2 = "no refund (%s is under 1: the wallet only moves whole amounts)"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = FormatMoney
    L5_2 = A0_2
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    return L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = "REFUND REFUSED for %s"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = FormatMoney
  L5_2 = A0_2
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L42_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L4_2 = L0_1.itemRefund
  if false ~= L4_2 then
    L4_2 = L37_1
    L5_2 = A0_2
    L6_2 = A1_2
    L7_2 = A2_2
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_12
    end
  end
  L4_2 = 0
  ::lbl_12::
  if L4_2 > 0 then
    L5_2 = L38_1
    L6_2 = A0_2.owner
    L7_2 = A0_2.pay
    L8_2 = L4_2
    L9_2 = A0_2.id
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
    if L5_2 then
      goto lbl_23
    end
  end
  L5_2 = 0
  ::lbl_23::
  L6_2 = tostring
  L7_2 = A1_2.name
  if not L7_2 then
    L7_2 = A1_2.item
  end
  L6_2 = L6_2(L7_2)
  L7_2 = print
  L8_2 = "^1[unique_phone]^0 eats #%s: %dx %s (%s) was not delivered \226\128\148 %s; %s"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = tostring
  L11_2 = A0_2.id
  L10_2 = L10_2(L11_2)
  L11_2 = A2_2
  L12_2 = tostring
  L13_2 = A1_2.item
  L12_2 = L12_2(L13_2)
  L13_2 = L6_2
  L14_2 = A3_2
  L15_2 = L41_1
  L16_2 = L4_2
  L17_2 = L5_2
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2, L17_2)
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L7_2 = NotifyCitizen
  L8_2 = A0_2.owner
  L9_2 = "eats"
  L10_2 = "Prato em falta"
  L11_2 = "%s nao pode ser entregue. %s"
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = L6_2
  L14_2 = L40_1
  L15_2 = L4_2
  L16_2 = L5_2
  L14_2, L15_2, L16_2, L17_2, L18_2 = L14_2(L15_2, L16_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L12_2 = nil
  L13_2 = {}
  L14_2 = "eats-miss-"
  L15_2 = tostring
  L16_2 = A0_2.id
  L15_2 = L15_2(L16_2)
  L16_2 = "-"
  L17_2 = tostring
  L18_2 = A1_2.item
  L17_2 = L17_2(L18_2)
  L14_2 = L14_2 .. L15_2 .. L16_2 .. L17_2
  L13_2.throttleKey = L14_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
end
function L43_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = L0_1.giveItems
  if not L1_2 then
    return
  end
  L1_2 = FW
  L1_2 = L1_2.InventoryName
  L1_2 = L1_2()
  if not L1_2 then
    return
  end
  L2_2 = FW
  L2_2 = L2_2.GetPlayerByCid
  L3_2 = A0_2.owner
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  if L2_2 then
    L3_2 = tonumber
    L4_2 = L2_2.src
    L3_2 = L3_2(L4_2)
  end
  L4_2 = ipairs
  L5_2 = A0_2.lines
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2.item
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L10_2 = L9_2.item
      if "" ~= L10_2 then
        L10_2 = math
        L10_2 = L10_2.max
        L11_2 = 1
        L12_2 = math
        L12_2 = L12_2.floor
        L13_2 = tonumber
        L14_2 = L9_2.qty
        L13_2 = L13_2(L14_2)
        if not L13_2 then
          L13_2 = 1
        end
        L12_2 = L12_2(L13_2)
        L10_2 = L10_2(L11_2, L12_2)
        L11_2 = L35_1
        L12_2 = L9_2.item
        L11_2 = L11_2(L12_2)
        if false == L11_2 then
          L11_2 = L42_1
          L12_2 = A0_2
          L13_2 = L9_2
          L14_2 = L10_2
          L15_2 = "the inventory (%s) does not know the item"
          L16_2 = L15_2
          L15_2 = L15_2.format
          L17_2 = L1_2
          L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2(L16_2, L17_2)
          L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        else
          if L3_2 then
            L11_2 = L36_1
            L12_2 = L3_2
            L13_2 = L9_2.item
            L14_2 = L10_2
            L11_2 = L11_2(L12_2, L13_2, L14_2)
            if L11_2 then
              goto lbl_136
            end
          end
          L11_2 = L0_1.itemRefund
          if false ~= L11_2 then
            L11_2 = L37_1
            L12_2 = A0_2
            L13_2 = L9_2
            L14_2 = L10_2
            L11_2 = L11_2(L12_2, L13_2, L14_2)
            if L11_2 then
              goto lbl_84
            end
          end
          L11_2 = 0
          ::lbl_84::
          L12_2 = L39_1
          L13_2 = A0_2
          L14_2 = L9_2
          L15_2 = L10_2
          L16_2 = L11_2
          L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
          if L12_2 then
            L12_2 = NotifyCitizen
            L13_2 = A0_2.owner
            L14_2 = "eats"
            if L3_2 then
              L15_2 = "Sem espaco na mochila"
              if L15_2 then
                goto lbl_101
              end
            end
            L15_2 = "Comida a tua espera"
            ::lbl_101::
            L16_2 = "%s entra no inventario quando houver espaco."
            L17_2 = L16_2
            L16_2 = L16_2.format
            L18_2 = tostring
            L19_2 = L9_2.name
            if not L19_2 then
              L19_2 = L9_2.item
            end
            L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2)
            L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
            L17_2 = nil
            L18_2 = {}
            L19_2 = "eats-wait-"
            L20_2 = tostring
            L21_2 = A0_2.id
            L20_2 = L20_2(L21_2)
            L21_2 = "-"
            L22_2 = tostring
            L23_2 = L9_2.item
            L22_2 = L22_2(L23_2)
            L19_2 = L19_2 .. L20_2 .. L21_2 .. L22_2
            L18_2.throttleKey = L19_2
            L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
          else
            L12_2 = L42_1
            L13_2 = A0_2
            L14_2 = L9_2
            L15_2 = L10_2
            if L3_2 then
              L16_2 = "the inventory refused and the queue did not save"
              if L16_2 then
                goto lbl_135
              end
            end
            L16_2 = "player offline and the queue did not save"
            ::lbl_135::
            L12_2(L13_2, L14_2, L15_2, L16_2)
          end
        end
      end
    end
    ::lbl_136::
  end
end
function L44_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L28_1
  L2_2 = A0_2
  L3_2 = "delivered"
  L4_2 = {}
  L5_2 = Now
  L5_2 = L5_2()
  L4_2.delivered = L5_2
  L1_2(L2_2, L3_2, L4_2)
  L1_2 = L32_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L43_1
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = A0_2.courier
  if L2_2 then
    L3_2 = A0_2.courier
    L2_2 = L25_1
    L2_2[L3_2] = nil
  end
  L3_2 = A0_2.id
  L2_2 = L23_1
  L2_2[L3_2] = nil
  L2_2 = NotifyCitizen
  L3_2 = A0_2.owner
  L4_2 = "eats"
  L5_2 = "Pedido entregue"
  L6_2 = "Bom apetite!"
  L7_2 = nil
  L8_2 = {}
  L8_2.throttle = false
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  return L1_2
end
L45_1 = CreateThread
function L46_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  while true do
    L0_2 = Wait
    L1_2 = 2000
    L0_2(L1_2)
    L0_2 = Now
    L0_2 = L0_2()
    L1_2 = pairs
    L2_2 = L23_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = pcall
      function L8_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
        L0_3 = L6_2.status
        if "pending" == L0_3 then
          L0_3 = L0_2
          L1_3 = L6_2.created
          L0_3 = L0_3 - L1_3
          L1_3 = L0_1.npcAfter
          if not L1_3 then
            L1_3 = 75
          end
          L1_3 = L1_3 * 1000
          if L0_3 > L1_3 then
            L0_3 = L31_1
            L1_3 = L6_2
            L0_3(L1_3)
          else
            L0_3 = L6_2._reoffer
            if L0_3 then
              L0_3 = L0_2
              L1_3 = L6_2._reoffer
              L0_3 = L0_3 - L1_3
              L1_3 = 10000
            end
            if L0_3 > L1_3 then
              L0_3 = L0_2
              L6_2._reoffer = L0_3
              L0_3 = L30_1
              L1_3 = L6_2
              L0_3(L1_3)
            end
          end
        else
          L0_3 = L6_2.status
          if "accepted" == L0_3 then
            L0_3 = L0_2
            L1_3 = L6_2._readyDue
            if not L1_3 then
              L1_3 = 0
            end
            if L0_3 >= L1_3 then
              L0_3 = L28_1
              L1_3 = L6_2
              L2_3 = "ready"
              L3_3 = {}
              L4_3 = L0_2
              L3_3.ready_at = L4_3
              L0_3(L1_3, L2_3, L3_3)
              L0_3 = L6_2.courier_npc
              if 1 == L0_3 then
                L0_3 = L0_2
                L0_3 = L0_3 + 4000
                L6_2._pickDue = L0_3
              else
                L0_3 = NotifyCitizen
                L1_3 = L6_2.courier
                L2_3 = "eats"
                L3_3 = "Pedido pronto"
                L4_3 = "Podes levantar em "
                L6_3 = L6_2.restaurant
                L5_3 = L1_1
                L5_3 = L5_3[L6_3]
                if not L5_3 then
                  L5_3 = {}
                end
                L5_3 = L5_3.name
                if not L5_3 then
                  L5_3 = ""
                end
                L6_3 = "."
                L4_3 = L4_3 .. L5_3 .. L6_3
                L0_3(L1_3, L2_3, L3_3, L4_3)
              end
            end
          else
            L0_3 = L6_2.status
            if "ready" == L0_3 then
              L0_3 = L6_2.courier_npc
              if 1 == L0_3 then
                L0_3 = L0_2
                L1_3 = L6_2._pickDue
                if not L1_3 then
                  L1_3 = 0
                end
                if L0_3 >= L1_3 then
                  L0_3 = L28_1
                  L1_3 = L6_2
                  L2_3 = "picked"
                  L0_3(L1_3, L2_3)
                  L0_3 = L0_2
                  L6_2._tripStart = L0_3
                end
              end
            else
              L0_3 = L6_2.status
              if "picked" == L0_3 then
                L0_3 = L6_2.courier_npc
                if 1 == L0_3 then
                  L1_3 = L6_2.restaurant
                  L0_3 = L1_1
                  L0_3 = L0_3[L1_3]
                  L1_3 = {}
                  L2_3 = L6_2.addr_x
                  L1_3.x = L2_3
                  L2_3 = L6_2.addr_y
                  L1_3.y = L2_3
                  L2_3 = math
                  L2_3 = L2_3.sqrt
                  L3_3 = L13_1
                  L4_3 = L0_3
                  if L0_3 then
                    L4_3 = L0_3.coords
                  end
                  L5_3 = L1_3
                  L3_3, L4_3, L5_3, L6_3, L7_3, L8_3 = L3_3(L4_3, L5_3)
                  L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
                  L3_3 = math
                  L3_3 = L3_3.max
                  L4_3 = 20
                  L5_3 = math
                  L5_3 = L5_3.max
                  L6_3 = 1.0
                  L7_3 = tonumber
                  L8_3 = L0_1.npcSpeed
                  L7_3 = L7_3(L8_3)
                  if not L7_3 then
                    L7_3 = 13.0
                  end
                  L5_3 = L5_3(L6_3, L7_3)
                  L5_3 = L2_3 / L5_3
                  L3_3 = L3_3(L4_3, L5_3)
                  L4_3 = L0_2
                  L5_3 = L6_2._tripStart
                  if not L5_3 then
                    L5_3 = L0_2
                  end
                  L4_3 = L4_3 - L5_3
                  L5_3 = L3_3 * 1000
                  if L4_3 >= L5_3 then
                    L4_3 = L44_1
                    L5_3 = L6_2
                    L4_3(L5_3)
                  end
                end
              end
            end
          end
        end
      end
      L7_2 = L7_2(L8_2)
      if not L7_2 then
        L8_2 = L23_1
        L8_2[L5_2] = nil
      end
    end
  end
end
L45_1(L46_1)
L45_1 = CreateThread
function L46_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = Wait
  L1_2 = 2500
  L0_2(L1_2)
  L0_2 = MySQL
  L0_2 = L0_2.query
  L0_2 = L0_2.await
  L1_2 = "SELECT * FROM apex_phone_eats_orders WHERE status IN ('pending','accepted','ready','picked')"
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = {}
  end
  L1_2 = ipairs
  L2_2 = L0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = pcall
    L8_2 = json
    L8_2 = L8_2.decode
    L9_2 = L6_2.items
    if not L9_2 then
      L9_2 = "[]"
    end
    L7_2, L8_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 and L8_2 then
        goto lbl_36
        L9_2 = L8_2 or L9_2
      end
    end
    L9_2 = {}
    ::lbl_36::
    L6_2.lines = L9_2
    L9_2 = Now
    L9_2 = L9_2()
    L9_2 = L9_2 + 15000
    L6_2._readyDue = L9_2
    L9_2 = Now
    L9_2 = L9_2()
    L9_2 = L9_2 + 20000
    L6_2._pickDue = L9_2
    L9_2 = Now
    L9_2 = L9_2()
    L6_2._tripStart = L9_2
    L9_2 = L6_2.status
    if "pending" ~= L9_2 then
      L9_2 = L6_2.courier
      if L9_2 then
        L9_2 = L6_2.courier_npc
        if 1 ~= L9_2 then
          L9_2 = FW
          L9_2 = L9_2.GetPlayerByCid
          L10_2 = L6_2.courier
          L9_2 = L9_2(L10_2)
          if not L9_2 then
            L6_2.courier = nil
            L9_2 = MySQL
            L9_2 = L9_2.update
            L10_2 = "UPDATE apex_phone_eats_orders SET courier = NULL WHERE id = ?"
            L11_2 = {}
            L12_2 = L6_2.id
            L11_2[1] = L12_2
            L9_2(L10_2, L11_2)
            L9_2 = L31_1
            L10_2 = L6_2
            L9_2(L10_2)
          end
        end
      end
    end
    L10_2 = L6_2.id
    L9_2 = L23_1
    L9_2[L10_2] = L6_2
  end
  L1_2 = #L0_2
  if L1_2 > 0 then
    L1_2 = print
    L2_2 = "[unique_phone] eats: %d in-progress order(s) recovered"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = #L0_2
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L2_2(L3_2, L4_2)
    L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
end
L45_1(L46_1)
L45_1 = {}
function L46_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_eats_pending SET status = ?, tries = ?, updated = ? WHERE id = ? AND status = ?"
  L8_2 = {}
  L9_2 = "refunded"
  L10_2 = math
  L10_2 = L10_2.max
  L11_2 = 0
  L12_2 = math
  L12_2 = L12_2.floor
  L13_2 = tonumber
  L14_2 = A3_2
  L13_2 = L13_2(L14_2)
  if not L13_2 then
    L13_2 = 0
  end
  L12_2 = L12_2(L13_2)
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = Now
  L11_2 = L11_2()
  L12_2 = A0_2.id
  L13_2 = A2_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = tonumber
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  if 1 ~= L7_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = L5_1
  L8_2 = tonumber
  L9_2 = A0_2.refund
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  L7_2 = L7_2(L8_2)
  if L7_2 >= 1 then
    L8_2 = L38_1
    L9_2 = A1_2
    L10_2 = A0_2.pay
    L11_2 = L7_2
    L12_2 = A0_2.order_id
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
    if L8_2 then
      goto lbl_56
    end
  end
  L8_2 = 0
  ::lbl_56::
  if L7_2 >= 1 and L8_2 < 1 then
    L9_2 = MySQL
    L9_2 = L9_2.update
    L9_2 = L9_2.await
    L10_2 = "UPDATE apex_phone_eats_pending SET status = ?, updated = ? WHERE id = ? AND status = ?"
    L11_2 = {}
    L12_2 = "owed"
    L13_2 = Now
    L13_2 = L13_2()
    L14_2 = A0_2.id
    L15_2 = "refunded"
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L11_2[3] = L14_2
    L11_2[4] = L15_2
    L9_2(L10_2, L11_2)
  else
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "DELETE FROM apex_phone_eats_pending WHERE id = ? AND status = ?"
    L11_2 = {}
    L12_2 = A0_2.id
    L13_2 = "refunded"
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L9_2(L10_2, L11_2)
  end
  L9_2 = print
  L10_2 = "^3[unique_phone]^0 eats #%s: %dx %s of %s left the queue (%s); %s"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = tostring
  L13_2 = A0_2.order_id
  L12_2 = L12_2(L13_2)
  L13_2 = math
  L13_2 = L13_2.max
  L14_2 = 1
  L15_2 = math
  L15_2 = L15_2.floor
  L16_2 = tonumber
  L17_2 = A0_2.count
  L16_2 = L16_2(L17_2)
  if not L16_2 then
    L16_2 = 1
  end
  L15_2 = L15_2(L16_2)
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = tostring
  L15_2 = A0_2.item
  L14_2 = L14_2(L15_2)
  L15_2 = tostring
  L16_2 = A1_2
  L15_2 = L15_2(L16_2)
  L16_2 = A4_2
  L17_2 = L41_1
  L18_2 = L7_2
  L19_2 = L8_2
  L17_2, L18_2, L19_2 = L17_2(L18_2, L19_2)
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L9_2 = NotifyCitizen
  L10_2 = A1_2
  L11_2 = "eats"
  L12_2 = "Entrega desistida"
  L13_2 = "%s %s %s"
  L14_2 = L13_2
  L13_2 = L13_2.format
  L15_2 = tostring
  L16_2 = A0_2.dish
  if not L16_2 then
    L16_2 = A0_2.item
  end
  L15_2 = L15_2(L16_2)
  L16_2 = A5_2
  L17_2 = L40_1
  L18_2 = L7_2
  L19_2 = L8_2
  L17_2, L18_2, L19_2 = L17_2(L18_2, L19_2)
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L14_2 = nil
  L15_2 = {}
  L16_2 = "eats-giveup-"
  L17_2 = tostring
  L18_2 = A0_2.id
  L17_2 = L17_2(L18_2)
  L16_2 = L16_2 .. L17_2
  L15_2.throttleKey = L16_2
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  return L8_2
end
function L47_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = A0_2 or L1_2
  if A0_2 then
    L1_2 = GetCid
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  if L1_2 then
    L2_2 = L3_1
    if L2_2 then
      L2_2 = L45_1
      L2_2 = L2_2[L1_2]
      if not L2_2 then
        goto lbl_22
      end
    end
  end
  L2_2 = 0
  L3_2 = 0
  do return L2_2, L3_2 end
  ::lbl_22::
  L2_2 = FW
  L2_2 = L2_2.InventoryName
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = 0
    L3_2 = 0
    return L2_2, L3_2
  end
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 1
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = tonumber
  L6_2 = L0_1.itemRetries
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 60
  end
  L4_2 = L4_2(L5_2)
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = 0
  L4_2 = 0
  L5_2 = {}
  L6_2 = L45_1
  L6_2[L1_2] = true
  L6_2 = pcall
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT * FROM apex_phone_eats_pending WHERE owner = ? AND status = ? ORDER BY id ASC LIMIT 50"
    L2_3 = {}
    L3_3 = L1_2
    L4_3 = "pending"
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L0_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = ipairs
    L2_3 = L0_3
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = math
      L7_3 = L7_3.max
      L8_3 = 1
      L9_3 = math
      L9_3 = L9_3.floor
      L10_3 = tonumber
      L11_3 = L6_3.count
      L10_3 = L10_3(L11_3)
      if not L10_3 then
        L10_3 = 1
      end
      L9_3 = L9_3(L10_3)
      L7_3 = L7_3(L8_3, L9_3)
      L8_3 = tostring
      L9_3 = L6_3.dish
      if not L9_3 then
        L9_3 = L6_3.item
      end
      L8_3 = L8_3(L9_3)
      L9_3 = MySQL
      L9_3 = L9_3.update
      L9_3 = L9_3.await
      L10_3 = "UPDATE apex_phone_eats_pending SET status = ?, updated = ? WHERE id = ? AND status = ?"
      L11_3 = {}
      L12_3 = "given"
      L13_3 = Now
      L13_3 = L13_3()
      L14_3 = L6_3.id
      L15_3 = "pending"
      L11_3[1] = L12_3
      L11_3[2] = L13_3
      L11_3[3] = L14_3
      L11_3[4] = L15_3
      L9_3 = L9_3(L10_3, L11_3)
      L10_3 = tonumber
      L11_3 = L9_3
      L10_3 = L10_3(L11_3)
      if not L10_3 then
        L10_3 = 0
      end
      if 1 == L10_3 then
        L10_3 = L36_1
        L11_3 = A0_2
        L12_3 = L6_3.item
        L13_3 = L7_3
        L10_3 = L10_3(L11_3, L12_3, L13_3)
        if L10_3 then
          L10_3 = MySQL
          L10_3 = L10_3.query
          L10_3 = L10_3.await
          L11_3 = "DELETE FROM apex_phone_eats_pending WHERE id = ? AND status = ?"
          L12_3 = {}
          L13_3 = L6_3.id
          L14_3 = "given"
          L12_3[1] = L13_3
          L12_3[2] = L14_3
          L10_3(L11_3, L12_3)
          L10_3 = L3_2
          L10_3 = L10_3 + 1
          L3_2 = L10_3
          L10_3 = L5_2
          L10_3 = #L10_3
          if L10_3 < 3 then
            L10_3 = L5_2
            L10_3 = #L10_3
            L11_3 = L10_3 + 1
            L10_3 = L5_2
            L10_3[L11_3] = L8_3
          end
        else
          L10_3 = tonumber
          L11_3 = L6_3.tries
          L10_3 = L10_3(L11_3)
          if not L10_3 then
            L10_3 = 0
          end
          L10_3 = L10_3 + 1
          L11_3 = L2_2
          if L10_3 >= L11_3 then
            L11_3 = L46_1
            L12_3 = L6_3
            L13_3 = L1_2
            L14_3 = "given"
            L15_3 = L10_3
            L16_3 = "did not fit in the inventory after %d attempts"
            L17_3 = L16_3
            L16_3 = L16_3.format
            L18_3 = L10_3
            L16_3 = L16_3(L17_3, L18_3)
            L17_3 = "nao chegou a caber na mochila."
            L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3)
          else
            L11_3 = MySQL
            L11_3 = L11_3.update
            L11_3 = L11_3.await
            L12_3 = "UPDATE apex_phone_eats_pending SET status = ?, tries = ?, updated = ? WHERE id = ? AND status = ?"
            L13_3 = {}
            L14_3 = "pending"
            L15_3 = L10_3
            L16_3 = Now
            L16_3 = L16_3()
            L17_3 = L6_3.id
            L18_3 = "given"
            L13_3[1] = L14_3
            L13_3[2] = L15_3
            L13_3[3] = L16_3
            L13_3[4] = L17_3
            L13_3[5] = L18_3
            L11_3(L12_3, L13_3)
            L11_3 = L4_2
            L11_3 = L11_3 + 1
            L4_2 = L11_3
          end
        end
      end
    end
  end
  L6_2, L7_2 = L6_2(L7_2)
  L8_2 = L45_1
  L8_2[L1_2] = nil
  if not L6_2 then
    L8_2 = print
    L9_2 = "^1[unique_phone]^0 eats: delivery queue of %s: %s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = tostring
    L12_2 = L1_2
    L11_2 = L11_2(L12_2)
    L12_2 = tostring
    L13_2 = L7_2
    L12_2, L13_2, L14_2, L15_2, L16_2 = L12_2(L13_2)
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L8_2 = 0
    L9_2 = 0
    return L8_2, L9_2
  end
  if L3_2 > 0 then
    L8_2 = table
    L8_2 = L8_2.concat
    L9_2 = L5_2
    L10_2 = ", "
    L8_2 = L8_2(L9_2, L10_2)
    L9_2 = #L5_2
    if L3_2 > L9_2 then
      L9_2 = "Recebeste %s e mais %s no invent\195\161rio."
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = L8_2
      L12_2 = #L5_2
      L12_2 = L3_2 - L12_2
      L9_2 = L9_2(L10_2, L11_2, L12_2)
      if L9_2 then
        goto lbl_93
      end
    end
    L9_2 = "Recebeste %s no invent\195\161rio."
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L8_2
    L9_2 = L9_2(L10_2, L11_2)
    ::lbl_93::
    L10_2 = NotifyCitizen
    L11_2 = L1_2
    L12_2 = "eats"
    L13_2 = "Comida entregue"
    L14_2 = L9_2
    L15_2 = nil
    L16_2 = {}
    L16_2.throttle = false
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  end
  if L3_2 > 0 or L4_2 > 0 then
    L8_2 = Dbg
    L9_2 = "eats"
    L10_2 = "queue of %s: %d delivered, %d waiting for space"
    L11_2 = L1_2
    L12_2 = L3_2
    L13_2 = L4_2
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  end
  L8_2 = L3_2
  L9_2 = L4_2
  return L8_2, L9_2
end
L48_1 = 7
function L49_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L0_2 = math
  L0_2 = L0_2.floor
  L1_2 = tonumber
  L2_2 = L0_1.pendingDays
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = L48_1
  end
  L0_2 = L0_2(L1_2)
  if L0_2 <= 0 then
    L1_2 = 0
    return L1_2
  end
  L1_2 = Now
  L1_2 = L1_2()
  L2_2 = L0_2 * 86400000
  L1_2 = L1_2 - L2_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_eats_pending WHERE status = ? AND created < ? ORDER BY id ASC LIMIT 100"
  L4_2 = {}
  L5_2 = "pending"
  L6_2 = L1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = 0
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L46_1
    L11_2 = L9_2
    L12_2 = tostring
    L13_2 = L9_2.owner
    L12_2 = L12_2(L13_2)
    L13_2 = "pending"
    L14_2 = tonumber
    L15_2 = L9_2.tries
    L14_2 = L14_2(L15_2)
    if not L14_2 then
      L14_2 = 0
    end
    L15_2 = "%d day(s) in the queue without fitting"
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = L0_2
    L15_2 = L15_2(L16_2, L17_2)
    L16_2 = "ficou %d dia(s) a espera de espaco na mochila."
    L17_2 = L16_2
    L16_2 = L16_2.format
    L18_2 = L0_2
    L16_2, L17_2, L18_2 = L16_2(L17_2, L18_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    if nil ~= L10_2 then
      L3_2 = L3_2 + 1
    end
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_eats_pending WHERE status = ? AND updated < ? LIMIT 200"
  L6_2 = {}
  L7_2 = "given"
  L8_2 = Now
  L8_2 = L8_2()
  L8_2 = L8_2 - 86400000
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = tonumber
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  if L5_2 > 0 then
    L5_2 = Dbg
    L6_2 = "eats"
    L7_2 = "queue: %d delivered row(s) cleaned"
    L8_2 = L4_2
    L5_2(L6_2, L7_2, L8_2)
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_eats_pending SET status = ?, updated = ? WHERE status = ? AND updated < ? LIMIT 200"
  L7_2 = {}
  L8_2 = "owed"
  L9_2 = Now
  L9_2 = L9_2()
  L10_2 = "refunded"
  L11_2 = Now
  L11_2 = L11_2()
  L11_2 = L11_2 - 86400000
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if L6_2 > 0 then
    L6_2 = print
    L7_2 = "^3[unique_phone]^0 eats: %d queue row(s) were marked for refund without knowing whether it went through (\"owed\" status in apex_phone_eats_pending) \226\128\148 check before paying by hand"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = L5_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L7_2(L8_2, L9_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  end
  if L3_2 > 0 then
    L6_2 = Dbg
    L7_2 = "eats"
    L8_2 = "queue: %d dish(es) older than %d day(s) refunded and removed"
    L9_2 = L3_2
    L10_2 = L0_2
    L6_2(L7_2, L8_2, L9_2, L10_2)
  end
  return L3_2
end
L50_1 = FW
L50_1 = L50_1.OnPlayerLoaded
function L51_1(A0_2)
  local L1_2, L2_2
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3
    L0_3 = Wait
    L1_3 = 8000
    L0_3(L1_3)
    L0_3 = GetPlayerName
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    if L0_3 then
      L0_3 = L47_1
      L1_3 = A0_2
      L0_3(L1_3)
    end
  end
  L1_2(L2_2)
end
L50_1(L51_1)
L50_1 = CreateThread
function L51_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  while true do
    L0_2 = DBReady
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 2000
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 45000
  L0_2(L1_2)
  L0_2 = L3_1
  if not L0_2 then
    return
  end
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = MySQL
    L0_3 = L0_3.update
    L0_3 = L0_3.await
    L1_3 = "UPDATE apex_phone_eats_pending SET status = ?, tries = tries + 1, updated = ? WHERE status = ?"
    L2_3 = {}
    L3_3 = "pending"
    L4_3 = Now
    L4_3 = L4_3()
    L5_3 = "giving"
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L0_3 = L0_3(L1_3, L2_3)
    L1_3 = tonumber
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = 0
    end
    if L1_3 > 0 then
      L1_3 = print
      L2_3 = "^3[unique_phone]^0 eats: %d delivery queue row(s) from a previous version went back to waiting for space"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = L0_3
      L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3, L4_3)
      L1_3(L2_3, L3_3, L4_3, L5_3)
    end
  end
  L0_2(L1_2)
  L0_2 = 0
  while true do
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
      L0_3 = Now
      L0_3 = L0_3()
      L1_3 = L0_2
      if L0_3 >= L1_3 then
        L0_3 = Now
        L0_3 = L0_3()
        L0_3 = L0_3 + 1800000
        L0_2 = L0_3
        L0_3 = L49_1
        L0_3()
      end
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "SELECT DISTINCT owner FROM apex_phone_eats_pending WHERE status = ? LIMIT 200"
      L2_3 = {}
      L3_3 = "pending"
      L2_3[1] = L3_3
      L0_3 = L0_3(L1_3, L2_3)
      if not L0_3 then
        L0_3 = {}
      end
      L1_3 = ipairs
      L2_3 = L0_3
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
      for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
        L7_3 = L6_3.owner
        if L7_3 then
          L7_3 = FW
          L7_3 = L7_3.GetPlayerByCid
          L8_3 = L6_3.owner
          L7_3 = L7_3(L8_3)
        end
        if L7_3 then
          L8_3 = L7_3.src
          if L8_3 then
            L8_3 = L47_1
            L9_3 = L7_3.src
            L8_3(L9_3)
          end
        end
      end
    end
    L1_2, L2_2 = L1_2(L2_2)
    if not L1_2 then
      L3_2 = print
      L4_2 = "^1[unique_phone]^0 eats: delivery queue cycle: %s"
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = tostring
      L7_2 = L2_2
      L6_2, L7_2 = L6_2(L7_2)
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
      L3_2(L4_2, L5_2, L6_2, L7_2)
    end
    L3_2 = Wait
    L4_2 = 60000
    L3_2(L4_2)
  end
end
L50_1(L51_1)
L50_1 = CreateThread
function L51_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = L0_1.giveItems
  if L0_2 then
    L0_2 = L0_1.itemWarn
    if false ~= L0_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L0_2 = Wait
  L1_2 = 20000
  L0_2(L1_2)
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3
    L0_3 = FW
    L0_3 = L0_3.InventoryName
    L0_3 = L0_3()
    if not L0_3 then
      L1_3 = print
      L2_3 = "^3[unique_phone]^0 eats: Config.Eats.giveItems is on but no inventory was detected \226\128\148 no dish delivers an item"
      L1_3(L2_3)
      return
    end
    L1_3 = {}
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L0_1.restaurants
    if not L4_3 then
      L4_3 = {}
    end
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = ipairs
      L10_3 = L8_3.menu
      if not L10_3 then
        L10_3 = {}
      end
      L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
      for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
        L15_3 = ipairs
        L16_3 = L14_3.items
        if not L16_3 then
          L16_3 = {}
        end
        L15_3, L16_3, L17_3, L18_3 = L15_3(L16_3)
        for L19_3, L20_3 in L15_3, L16_3, L17_3, L18_3 do
          L21_3 = L20_3.item
          L22_3 = type
          L23_3 = L21_3
          L22_3 = L22_3(L23_3)
          if "string" == L22_3 and "" ~= L21_3 then
            L22_3 = L1_3[L21_3]
            if not L22_3 then
              L1_3[L21_3] = true
              L22_3 = #L2_3
              L22_3 = L22_3 + 1
              L2_3[L22_3] = L21_3
            end
          end
        end
      end
    end
    L3_3 = {}
    L4_3 = 0
    L5_3 = ipairs
    L6_3 = L2_3
    L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
    for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
      L11_3 = L35_1
      L12_3 = L10_3
      L11_3 = L11_3(L12_3)
      if false == L11_3 then
        L12_3 = #L3_3
        L12_3 = L12_3 + 1
        L3_3[L12_3] = L10_3
      elseif nil == L11_3 then
        L4_3 = L4_3 + 1
      end
    end
    L5_3 = #L3_3
    if L5_3 > 0 then
      L5_3 = print
      L6_3 = "^1[unique_phone]^0 eats: the inventory (%s) does not know %d of the %d menu items: %s"
      L7_3 = L6_3
      L6_3 = L6_3.format
      L8_3 = L0_3
      L9_3 = #L3_3
      L10_3 = #L2_3
      L11_3 = table
      L11_3 = L11_3.concat
      L12_3 = L3_3
      L13_3 = ", "
      L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L11_3(L12_3, L13_3)
      L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      L5_3 = print
      L6_3 = "^1[unique_phone]^0 eats: anyone ordering those dishes pays and the dish money is refunded \226\128\148 add the items to the inventory or remove the `item` field from the dish in config.lua"
      L5_3(L6_3)
    else
      L5_3 = #L2_3
      if L4_3 >= L5_3 then
        L5_3 = #L2_3
        if L5_3 > 0 then
          L5_3 = Dbg
          L6_3 = "eats"
          L7_3 = "the inventory (%s) does not allow checking the %d menu items"
          L8_3 = L0_3
          L9_3 = #L2_3
          L5_3(L6_3, L7_3, L8_3, L9_3)
      end
      else
        L5_3 = Dbg
        L6_3 = "eats"
        L7_3 = "the %d menu items exist in the inventory (%s)"
        L8_3 = #L2_3
        L9_3 = L0_3
        L5_3(L6_3, L7_3, L8_3, L9_3)
      end
    end
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^3[unique_phone]^0 eats: could not check the menu items (%s)"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
end
L50_1(L51_1)
L50_1 = AddEventHandler
L51_1 = "playerDropped"
function L52_1()
  local L0_2, L1_2
  L0_2 = source
  L1_2 = L24_1
  L1_2 = L1_2[L0_2]
  if L1_2 then
    L1_2 = L24_1
    L1_2[L0_2] = nil
  end
end
L50_1(L51_1, L52_1)
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L15_1
  L3_2 = A1_2 or L3_2
  if A1_2 then
    L3_2 = A1_2.hour
  end
  L2_2(L3_2)
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L18_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = {}
    L4_2 = {}
    L3_2.favorites = L4_2
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2.favorites
  if not L6_2 then
    L6_2 = {}
  end
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L4_2[L10_2] = true
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L0_1.restaurants
  if not L7_2 then
    L7_2 = {}
  end
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L13_2 = {}
    L14_2 = L11_2.id
    L13_2.id = L14_2
    L14_2 = L11_2.name
    L13_2.name = L14_2
    L14_2 = L11_2.tagline
    L13_2.tagline = L14_2
    L14_2 = L11_2.cats
    L13_2.cats = L14_2
    L14_2 = L11_2.rating
    L13_2.rating = L14_2
    L14_2 = L11_2.votes
    L13_2.votes = L14_2
    L14_2 = L11_2.time
    L13_2.time = L14_2
    L14_2 = L11_2.fee
    L13_2.fee = L14_2
    L14_2 = L11_2.min
    L13_2.min = L14_2
    L14_2 = L11_2.art
    L13_2.art = L14_2
    L14_2 = L11_2.glyph
    L13_2.glyph = L14_2
    L14_2 = L11_2.promo
    L13_2.promo = L14_2
    L14_2 = L16_1
    L15_2 = L11_2
    L14_2 = L14_2(L15_2)
    L13_2.open = L14_2
    L14_2 = L11_2.id
    L14_2 = L4_2[L14_2]
    L14_2 = true == L14_2
    L13_2.fav = L14_2
    L14_2 = L11_2.coords
    L13_2.coords = L14_2
    L5_2[L12_2] = L13_2
  end
  L6_2 = {}
  L6_2.restaurants = L5_2
  L7_2 = L0_1.categories
  if not L7_2 then
    L7_2 = {}
  end
  L6_2.categories = L7_2
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = tonumber
  L9_2 = L0_1.ratingWindow
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  L7_2 = L7_2(L8_2)
  L6_2.ratingWindow = L7_2
  L7_2 = {}
  L8_2 = L0_1.serviceFee
  L7_2.service = L8_2
  L8_2 = L0_1.smallOrder
  L7_2.small = L8_2
  L8_2 = L0_1.tipPresets
  L7_2.tips = L8_2
  L8_2 = L0_1.payMethods
  L7_2.pay = L8_2
  L6_2.fees = L7_2
  L7_2 = {}
  L8_2 = L19_1
  L9_2 = L3_2
  L8_2 = L8_2(L9_2)
  L7_2.active = L8_2
  L8_2 = tonumber
  L9_2 = L3_2.pro_until
  if not L9_2 then
    L9_2 = 0
  end
  L8_2 = L8_2(L9_2)
  L7_2.until_ = L8_2
  L8_2 = math
  L8_2 = L8_2.floor
  L9_2 = tonumber
  L10_2 = L0_1.proPrice
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = 0
  end
  L8_2 = L8_2(L9_2)
  L7_2.price = L8_2
  L8_2 = L0_1.proDays
  L7_2.days = L8_2
  L6_2.pro = L7_2
  L7_2 = {}
  L8_2 = L24_1
  L8_2 = L8_2[A0_2]
  L8_2 = nil ~= L8_2
  L7_2.on = L8_2
  L8_2 = L0_1.courierJob
  if not L8_2 then
    L8_2 = ""
  end
  L7_2.job = L8_2
  L8_2 = L0_1.courierCutPct
  L7_2.cut = L8_2
  L6_2.courier = L7_2
  L7_2 = {}
  L8_2 = L3_2.deliveries
  if not L8_2 then
    L8_2 = 0
  end
  L7_2.deliveries = L8_2
  L8_2 = tonumber
  L9_2 = L3_2.earnings
  if not L9_2 then
    L9_2 = 0
  end
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  L7_2.earnings = L8_2
  L6_2.stats = L7_2
  return L6_2
end
L50_1["eats.home"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L15_1
  L3_2 = A1_2 or L3_2
  if A1_2 then
    L3_2 = A1_2.hour
  end
  L2_2(L3_2)
  L2_2 = tostring
  if A1_2 then
    L3_2 = A1_2.id
    if L3_2 then
      goto lbl_13
    end
  end
  L3_2 = ""
  ::lbl_13::
  L2_2 = L2_2(L3_2)
  L3_2 = L1_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.id
  L3_2.id = L4_2
  L4_2 = L2_2.name
  L3_2.name = L4_2
  L4_2 = L2_2.tagline
  L3_2.tagline = L4_2
  L4_2 = L2_2.rating
  L3_2.rating = L4_2
  L4_2 = L2_2.votes
  L3_2.votes = L4_2
  L4_2 = L2_2.time
  L3_2.time = L4_2
  L4_2 = L2_2.fee
  L3_2.fee = L4_2
  L4_2 = L2_2.min
  L3_2.min = L4_2
  L4_2 = L2_2.art
  L3_2.art = L4_2
  L4_2 = L2_2.glyph
  L3_2.glyph = L4_2
  L4_2 = L2_2.promo
  L3_2.promo = L4_2
  L4_2 = L16_1
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L3_2.open = L4_2
  L4_2 = L2_2.open
  L3_2.hours = L4_2
  L4_2 = L2_2.coords
  L3_2.coords = L4_2
  L4_2 = L2_2.menu
  L3_2.menu = L4_2
  L4_2 = L2_2.cats
  L3_2.cats = L4_2
  return L3_2
end
L50_1["eats.menu"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L2_2 = L15_1
  L3_2 = A1_2 or L3_2
  if A1_2 then
    L3_2 = A1_2.hour
  end
  L2_2(L3_2)
  L2_2 = tostring
  if A1_2 then
    L3_2 = A1_2.q
    if L3_2 then
      goto lbl_13
    end
  end
  L3_2 = ""
  ::lbl_13::
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  if "" == L2_2 then
    L3_2 = {}
    L4_2 = {}
    L3_2.restaurants = L4_2
    L4_2 = {}
    L3_2.dishes = L4_2
    return L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L0_1.restaurants
  if not L6_2 then
    L6_2 = {}
  end
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = tostring
    L12_2 = L10_2.name
    L11_2 = L11_2(L12_2)
    L12_2 = " "
    L13_2 = tostring
    L14_2 = L10_2.tagline
    if not L14_2 then
      L14_2 = ""
    end
    L13_2 = L13_2(L14_2)
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = L11_2
    L11_2 = L11_2.lower
    L11_2 = L11_2(L12_2)
    L13_2 = L11_2
    L12_2 = L11_2.find
    L14_2 = L2_2
    L15_2 = 1
    L16_2 = true
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
    if L12_2 then
      L12_2 = #L3_2
      L12_2 = L12_2 + 1
      L13_2 = {}
      L14_2 = L10_2.id
      L13_2.id = L14_2
      L14_2 = L10_2.name
      L13_2.name = L14_2
      L14_2 = L10_2.tagline
      L13_2.tagline = L14_2
      L14_2 = L10_2.rating
      L13_2.rating = L14_2
      L14_2 = L10_2.time
      L13_2.time = L14_2
      L14_2 = L10_2.fee
      L13_2.fee = L14_2
      L14_2 = L10_2.art
      L13_2.art = L14_2
      L14_2 = L10_2.glyph
      L13_2.glyph = L14_2
      L14_2 = L16_1
      L15_2 = L10_2
      L14_2 = L14_2(L15_2)
      L13_2.open = L14_2
      L14_2 = L10_2.cats
      L13_2.cats = L14_2
      L3_2[L12_2] = L13_2
    end
    L12_2 = ipairs
    L13_2 = L10_2.menu
    if not L13_2 then
      L13_2 = {}
    end
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
    for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
      L18_2 = ipairs
      L19_2 = L17_2.items
      if not L19_2 then
        L19_2 = {}
      end
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L24_2 = #L4_2
        if L24_2 < 30 then
          L24_2 = tostring
          L25_2 = L23_2.name
          L24_2 = L24_2(L25_2)
          L25_2 = L24_2
          L24_2 = L24_2.lower
          L24_2 = L24_2(L25_2)
          L25_2 = L24_2
          L24_2 = L24_2.find
          L26_2 = L2_2
          L27_2 = 1
          L28_2 = true
          L24_2 = L24_2(L25_2, L26_2, L27_2, L28_2)
          if not L24_2 then
            L24_2 = tostring
            L25_2 = L23_2.desc
            if not L25_2 then
              L25_2 = ""
            end
            L24_2 = L24_2(L25_2)
            L25_2 = L24_2
            L24_2 = L24_2.lower
            L24_2 = L24_2(L25_2)
            L25_2 = L24_2
            L24_2 = L24_2.find
            L26_2 = L2_2
            L27_2 = 1
            L28_2 = true
            L24_2 = L24_2(L25_2, L26_2, L27_2, L28_2)
            if not L24_2 then
              goto lbl_159
            end
          end
          L24_2 = #L4_2
          L24_2 = L24_2 + 1
          L25_2 = {}
          L26_2 = L23_2.id
          L25_2.id = L26_2
          L26_2 = L23_2.name
          L25_2.name = L26_2
          L26_2 = L23_2.desc
          L25_2.desc = L26_2
          L26_2 = L23_2.price
          L25_2.price = L26_2
          L26_2 = L23_2.art
          L25_2.art = L26_2
          L26_2 = L23_2.glyph
          L25_2.glyph = L26_2
          L26_2 = L10_2.id
          L25_2.rest = L26_2
          L26_2 = L10_2.name
          L25_2.restName = L26_2
          L26_2 = L16_1
          L27_2 = L10_2
          L26_2 = L26_2(L27_2)
          L25_2.open = L26_2
          L4_2[L24_2] = L25_2
        end
        ::lbl_159::
      end
    end
  end
  L5_2 = {}
  L5_2.restaurants = L3_2
  L5_2.dishes = L4_2
  return L5_2
end
L50_1["eats.search"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L18_1
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L2_2 then
    L2_2 = {}
    L3_2 = {}
    L2_2.promos = L3_2
  end
  L3_2 = L22_1
  L4_2 = tostring
  L5_2 = A1_2.id
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L5_2 = A1_2.cart
  L6_2 = A1_2.tip
  L7_2 = A1_2.promo
  L8_2 = L2_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L3_2 then
    L5_2 = {}
    L5_2.error = L4_2
    return L5_2
  end
  return L3_2
end
L50_1["eats.quote"] = L51_1
function L50_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2
  L3_2 = A2_2.cid
  L4_2 = tostring
  L5_2 = A1_2.id
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L1_1
  L4_2 = L5_2[L4_2]
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "restaurant"
    return L5_2
  end
  L5_2 = L16_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = {}
    L5_2.error = "closed"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT COUNT(*) FROM apex_phone_eats_orders WHERE owner = ? AND status IN ('pending','accepted','ready','picked')"
  L7_2 = {}
  L8_2 = L3_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = 0
  end
  L6_2 = L0_1.maxActive
  if not L6_2 then
    L6_2 = 3
  end
  if L5_2 >= L6_2 then
    L6_2 = {}
    L6_2.error = "toomanyactive"
    return L6_2
  end
  L6_2 = L18_1
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L7_2 = L22_1
  L8_2 = L4_2.id
  L9_2 = A1_2.cart
  L10_2 = A1_2.tip
  L11_2 = A1_2.promo
  L12_2 = L6_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  if not L7_2 then
    L9_2 = {}
    L9_2.error = L8_2
    return L9_2
  end
  L9_2 = L7_2.subtotal
  L10_2 = tonumber
  L11_2 = L4_2.min
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 0
  end
  if L9_2 < L10_2 then
    L9_2 = {}
    L9_2.error = "min"
    L10_2 = L4_2.min
    L9_2.min = L10_2
    return L9_2
  end
  L9_2 = tonumber
  L10_2 = A1_2.x
  L9_2 = L9_2(L10_2)
  L10_2 = tonumber
  L11_2 = A1_2.y
  L10_2 = L10_2(L11_2)
  if not L9_2 or not L10_2 then
    L11_2 = L12_1
    L12_2 = A0_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L12_2 = {}
      L12_2.error = "nocoords"
      return L12_2
    end
    L12_2 = L11_2.x
    L10_2 = L11_2.y
    L9_2 = L12_2
  end
  L11_2 = A1_2.pay
  if "cash" == L11_2 then
    L11_2 = "cash"
    if L11_2 then
      goto lbl_107
    end
  end
  L11_2 = "bank"
  ::lbl_107::
  L12_2 = A2_2.GetMoney
  L13_2 = L11_2
  L12_2 = L12_2(L13_2)
  L13_2 = L7_2.total
  if L12_2 < L13_2 then
    L12_2 = {}
    L12_2.error = "funds"
    L13_2 = L7_2.total
    L12_2.need = L13_2
    return L12_2
  end
  L12_2 = A2_2.RemoveMoney
  L13_2 = L11_2
  L14_2 = L7_2.total
  L15_2 = "eats-"
  L16_2 = L4_2.id
  L15_2 = L15_2 .. L16_2
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  if not L12_2 then
    L12_2 = {}
    L12_2.error = "funds"
    return L12_2
  end
  L12_2 = Now
  L12_2 = L12_2()
  L13_2 = pcall
  L14_2 = MySQL
  L14_2 = L14_2.insert
  L14_2 = L14_2.await
  L15_2 = [[
INSERT INTO apex_phone_eats_orders
        (owner, phone, name, restaurant, items, note, subtotal, fee, service, smallfee, discount, tip, total, pay, promo,
         addr_label, addr_x, addr_y, status, created)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', ?)]]
  L16_2 = {}
  L17_2 = L3_2
  L18_2 = GetPlayerNumber
  L19_2 = A0_2
  L18_2 = L18_2(L19_2)
  L19_2 = A2_2.firstname
  if not L19_2 then
    L19_2 = ""
  end
  L20_2 = " "
  L21_2 = A2_2.lastname
  if not L21_2 then
    L21_2 = ""
  end
  L19_2 = L19_2 .. L20_2 .. L21_2
  L20_2 = L4_2.id
  L21_2 = json
  L21_2 = L21_2.encode
  L22_2 = L7_2.lines
  L21_2 = L21_2(L22_2)
  L22_2 = tostring
  L23_2 = A1_2.note
  if not L23_2 then
    L23_2 = ""
  end
  L22_2 = L22_2(L23_2)
  L23_2 = L22_2
  L22_2 = L22_2.sub
  L24_2 = 1
  L25_2 = 200
  L22_2 = L22_2(L23_2, L24_2, L25_2)
  L23_2 = L7_2.subtotal
  L24_2 = L7_2.fee
  L25_2 = L7_2.service
  L26_2 = L7_2.smallfee
  L27_2 = L7_2.discount
  L28_2 = L7_2.tip
  L29_2 = L7_2.total
  if "cash" == L11_2 then
    L30_2 = "cash"
    if L30_2 then
      goto lbl_183
    end
  end
  L30_2 = "card"
  ::lbl_183::
  L31_2 = L7_2.promo
  L32_2 = tostring
  L33_2 = A1_2.label
  if not L33_2 then
    L33_2 = "Morada atual"
  end
  L32_2 = L32_2(L33_2)
  L33_2 = L32_2
  L32_2 = L32_2.sub
  L34_2 = 1
  L35_2 = 64
  L32_2 = L32_2(L33_2, L34_2, L35_2)
  L33_2 = L9_2
  L34_2 = L10_2
  L35_2 = L12_2
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L16_2[4] = L20_2
  L16_2[5] = L21_2
  L16_2[6] = L22_2
  L16_2[7] = L23_2
  L16_2[8] = L24_2
  L16_2[9] = L25_2
  L16_2[10] = L26_2
  L16_2[11] = L27_2
  L16_2[12] = L28_2
  L16_2[13] = L29_2
  L16_2[14] = L30_2
  L16_2[15] = L31_2
  L16_2[16] = L32_2
  L16_2[17] = L33_2
  L16_2[18] = L34_2
  L16_2[19] = L35_2
  L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2)
  if L13_2 then
    L15_2 = tonumber
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    if L15_2 then
      goto lbl_207
    end
  end
  L15_2 = nil
  ::lbl_207::
  if L15_2 and L15_2 <= 0 then
    L15_2 = nil
  end
  if not L15_2 then
    L16_2 = A2_2.AddMoney
    L17_2 = L11_2
    L18_2 = L7_2.total
    L19_2 = "eats-refund-order"
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L16_2 = false ~= L16_2
    L17_2 = print
    L18_2 = "^1[unique_phone]^0 eats: the order of %s was not saved (%s); %s"
    L19_2 = L18_2
    L18_2 = L18_2.format
    L20_2 = tostring
    L21_2 = L3_2
    L20_2 = L20_2(L21_2)
    if L13_2 then
      L21_2 = "no id"
      if L21_2 then
        goto lbl_237
      end
    end
    L21_2 = tostring
    L22_2 = L14_2
    L21_2 = L21_2(L22_2)
    ::lbl_237::
    if L16_2 then
      L22_2 = "money refunded"
      if L22_2 then
        goto lbl_243
      end
    end
    L22_2 = "MONEY NOT REFUNDED"
    ::lbl_243::
    L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
    L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2)
    L17_2 = {}
    L17_2.error = "db"
    return L17_2
  end
  L16_2 = L7_2.promo
  if L16_2 then
    L16_2 = L6_2.promos
    L17_2 = L7_2.promo
    L18_2 = tonumber
    L19_2 = L6_2.promos
    L20_2 = L7_2.promo
    L19_2 = L19_2[L20_2]
    if not L19_2 then
      L19_2 = 0
    end
    L18_2 = L18_2(L19_2)
    L18_2 = L18_2 + 1
    L16_2[L17_2] = L18_2
    L16_2 = MySQL
    L16_2 = L16_2.update
    L17_2 = "UPDATE apex_phone_eats_meta SET promos = ? WHERE owner = ?"
    L18_2 = {}
    L19_2 = json
    L19_2 = L19_2.encode
    L20_2 = L6_2.promos
    L19_2 = L19_2(L20_2)
    L20_2 = L3_2
    L18_2[1] = L19_2
    L18_2[2] = L20_2
    L16_2(L17_2, L18_2)
  end
  L16_2 = AddTransaction
  L17_2 = L3_2
  L18_2 = "Eats: "
  L19_2 = L4_2.name
  L18_2 = L18_2 .. L19_2
  L19_2 = math
  L19_2 = L19_2.floor
  L20_2 = L7_2.total
  L19_2 = L19_2(L20_2)
  L19_2 = -L19_2
  L16_2(L17_2, L18_2, L19_2)
  L16_2 = L0_1.prepSeconds
  if not L16_2 then
    L16_2 = {}
    L17_2 = 90
    L18_2 = 210
    L16_2[1] = L17_2
    L16_2[2] = L18_2
  end
  L17_2 = {}
  L17_2.id = L15_2
  L17_2.owner = L3_2
  L18_2 = GetPlayerNumber
  L19_2 = A0_2
  L18_2 = L18_2(L19_2)
  L17_2.phone = L18_2
  L18_2 = A2_2.firstname
  if not L18_2 then
    L18_2 = ""
  end
  L19_2 = " "
  L20_2 = A2_2.lastname
  if not L20_2 then
    L20_2 = ""
  end
  L18_2 = L18_2 .. L19_2 .. L20_2
  L17_2.name = L18_2
  L18_2 = L4_2.id
  L17_2.restaurant = L18_2
  L18_2 = L7_2.lines
  L17_2.lines = L18_2
  L18_2 = tostring
  L19_2 = A1_2.note
  if not L19_2 then
    L19_2 = ""
  end
  L18_2 = L18_2(L19_2)
  L19_2 = L18_2
  L18_2 = L18_2.sub
  L20_2 = 1
  L21_2 = 200
  L18_2 = L18_2(L19_2, L20_2, L21_2)
  L17_2.note = L18_2
  L18_2 = L7_2.subtotal
  L17_2.subtotal = L18_2
  L18_2 = L7_2.fee
  L17_2.fee = L18_2
  L18_2 = L7_2.service
  L17_2.service = L18_2
  L18_2 = L7_2.smallfee
  L17_2.smallfee = L18_2
  L18_2 = L7_2.discount
  L17_2.discount = L18_2
  L18_2 = L7_2.tip
  L17_2.tip = L18_2
  L18_2 = L7_2.total
  L17_2.total = L18_2
  if "cash" == L11_2 then
    L18_2 = "cash"
    if L18_2 then
      goto lbl_350
    end
  end
  L18_2 = "card"
  ::lbl_350::
  L17_2.pay = L18_2
  L18_2 = L7_2.promo
  L17_2.promo = L18_2
  L18_2 = tostring
  L19_2 = A1_2.label
  if not L19_2 then
    L19_2 = "Morada atual"
  end
  L18_2 = L18_2(L19_2)
  L19_2 = L18_2
  L18_2 = L18_2.sub
  L20_2 = 1
  L21_2 = 64
  L18_2 = L18_2(L19_2, L20_2, L21_2)
  L17_2.addr_label = L18_2
  L17_2.addr_x = L9_2
  L17_2.addr_y = L10_2
  L17_2.status = "pending"
  L17_2.created = L12_2
  L17_2.courier_npc = 0
  L18_2 = math
  L18_2 = L18_2.random
  L19_2 = L16_2[1]
  if not L19_2 then
    L19_2 = 90
  end
  L20_2 = L16_2[2]
  if not L20_2 then
    L20_2 = 210
  end
  L18_2 = L18_2(L19_2, L20_2)
  L18_2 = L18_2 * 1000
  L18_2 = L12_2 + L18_2
  L17_2._readyDue = L18_2
  L18_2 = L23_1
  L18_2[L15_2] = L17_2
  L18_2 = L4_2.job
  if L18_2 then
    L18_2 = L4_2.job
    if "" ~= L18_2 then
      L18_2 = ipairs
      L19_2 = FW
      L19_2 = L19_2.GetJobPlayers
      L20_2 = L4_2.job
      L19_2 = L19_2(L20_2)
      if not L19_2 then
        L19_2 = {}
      end
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L24_2 = Push
        L25_2 = L23_2
        L26_2 = "eats:kitchen"
        L27_2 = L26_1
        L28_2 = L17_2
        L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L27_2(L28_2)
        L24_2(L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2)
      end
    end
  end
  L18_2 = L30_1
  L19_2 = L17_2
  L18_2(L19_2)
  L18_2 = {}
  L18_2.ok = true
  L19_2 = L26_1
  L20_2 = L17_2
  L19_2 = L19_2(L20_2)
  L18_2.order = L19_2
  return L18_2
end
L51_1 = RPC
function L52_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L11_1
  L4_2 = L2_2.cid
  L5_2 = "order"
  L6_2 = L50_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = L2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
end
L51_1["eats.order"] = L52_1
L51_1 = RPC
function L52_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT * FROM apex_phone_eats_orders WHERE owner = ? ORDER BY created DESC LIMIT 30"
  L3_2 = {}
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2)
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L3_2[6] = L9_2
  L3_2[7] = L10_2
  L3_2[8] = L11_2
  L3_2[9] = L12_2
  L3_2[10] = L13_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = pcall
    L10_2 = json
    L10_2 = L10_2.decode
    L11_2 = L8_2.items
    if not L11_2 then
      L11_2 = "[]"
    end
    L9_2, L10_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L11_2 = type
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if "table" == L11_2 and L10_2 then
        goto lbl_41
        L11_2 = L10_2 or L11_2
      end
    end
    L11_2 = {}
    ::lbl_41::
    L8_2.lines = L11_2
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L12_2 = L26_1
    L13_2 = L8_2
    L12_2 = L12_2(L13_2)
    L2_2[L11_2] = L12_2
  end
  return L2_2
end
L51_1["eats.orders"] = L52_1
L51_1 = RPC
function L52_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = tonumber
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L23_1
  L2_2 = L3_2[L2_2]
  if L2_2 then
    L3_2 = L2_2.owner
    L4_2 = GetCid
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L3_2 == L4_2 then
      L3_2 = L26_1
      L4_2 = L2_2
      return L3_2(L4_2)
    end
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_eats_orders WHERE id = ? AND owner = ?"
  L5_2 = {}
  L6_2 = A1_2.id
  L7_2 = GetCid
  L8_2 = A0_2
  L7_2, L8_2 = L7_2(L8_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = pcall
  L5_2 = json
  L5_2 = L5_2.decode
  L6_2 = L3_2.items
  if not L6_2 then
    L6_2 = "[]"
  end
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 and L5_2 then
      goto lbl_56
      L6_2 = L5_2 or L6_2
    end
  end
  L6_2 = {}
  ::lbl_56::
  L3_2.lines = L6_2
  L6_2 = L26_1
  L7_2 = L3_2
  return L6_2(L7_2)
end
L51_1["eats.order.get"] = L52_1
L51_1 = RPC
function L52_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = tonumber
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L23_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L2_2.owner
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L3_2 = L3_2 == L4_2
  L4_2 = L2_2.courier
  if L4_2 then
    L4_2 = L2_2.courier
    L5_2 = GetCid
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    L4_2 = L4_2 == L5_2
  end
  if not L3_2 and not L4_2 then
    L5_2 = nil
    return L5_2
  end
  L6_2 = L2_2.restaurant
  L5_2 = L1_1
  L5_2 = L5_2[L6_2]
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = {}
  L7_2 = L2_2.addr_x
  L6_2.x = L7_2
  L7_2 = L2_2.addr_y
  L6_2.y = L7_2
  L7_2 = nil
  L8_2 = L2_2.courier_npc
  if 1 == L8_2 then
    L8_2 = L2_2.status
    if "picked" == L8_2 then
      L8_2 = L5_2.coords
      L9_2 = L6_2
      L10_2 = math
      L10_2 = L10_2.sqrt
      L11_2 = L13_1
      L12_2 = L8_2
      L13_2 = L9_2
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L11_2(L12_2, L13_2)
      L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      L11_2 = math
      L11_2 = L11_2.max
      L12_2 = 20
      L13_2 = math
      L13_2 = L13_2.max
      L14_2 = 1.0
      L15_2 = tonumber
      L16_2 = L0_1.npcSpeed
      L15_2 = L15_2(L16_2)
      if not L15_2 then
        L15_2 = 13.0
      end
      L13_2 = L13_2(L14_2, L15_2)
      L13_2 = L10_2 / L13_2
      L11_2 = L11_2(L12_2, L13_2)
      L12_2 = math
      L12_2 = L12_2.min
      L13_2 = 1
      L14_2 = Now
      L14_2 = L14_2()
      L15_2 = L2_2._tripStart
      if not L15_2 then
        L15_2 = Now
        L15_2 = L15_2()
      end
      L14_2 = L14_2 - L15_2
      L15_2 = L11_2 * 1000
      L14_2 = L14_2 / L15_2
      L12_2 = L12_2(L13_2, L14_2)
      if L8_2 and L9_2 then
        L13_2 = {}
        L14_2 = L8_2.x
        L15_2 = L9_2.x
        L16_2 = L8_2.x
        L15_2 = L15_2 - L16_2
        L15_2 = L15_2 * L12_2
        L14_2 = L14_2 + L15_2
        L13_2.x = L14_2
        L14_2 = L8_2.y
        L15_2 = L9_2.y
        L16_2 = L8_2.y
        L15_2 = L15_2 - L16_2
        L15_2 = L15_2 * L12_2
        L14_2 = L14_2 + L15_2
        L13_2.y = L14_2
        L7_2 = L13_2
      end
    else
      L7_2 = L5_2.coords
    end
  else
    L8_2 = L2_2.courier
    if L8_2 then
      L8_2 = FW
      L8_2 = L8_2.GetPlayerByCid
      L9_2 = L2_2.courier
      L8_2 = L8_2(L9_2)
      if L8_2 then
        L9_2 = L12_1
        L10_2 = L8_2.src
        L9_2 = L9_2(L10_2)
        L7_2 = L9_2
      end
    end
  end
  L8_2 = nil
  L9_2 = L2_2.status
  if "pending" ~= L9_2 then
    L9_2 = L2_2.status
    if "accepted" ~= L9_2 then
      goto lbl_171
    end
  end
  L9_2 = math
  L9_2 = L9_2.max
  L10_2 = 0
  L11_2 = math
  L11_2 = L11_2.floor
  L12_2 = L2_2._readyDue
  if not L12_2 then
    L12_2 = Now
    L12_2 = L12_2()
  end
  L13_2 = Now
  L13_2 = L13_2()
  L12_2 = L12_2 - L13_2
  L12_2 = L12_2 / 1000
  L11_2 = L11_2(L12_2)
  L9_2 = L9_2(L10_2, L11_2)
  L8_2 = L9_2 + 300
  goto lbl_196
  ::lbl_171::
  if L7_2 then
    L9_2 = math
    L9_2 = L9_2.floor
    L10_2 = math
    L10_2 = L10_2.sqrt
    L11_2 = L13_1
    L12_2 = L7_2
    L13_2 = L6_2
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L11_2(L12_2, L13_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L11_2 = math
    L11_2 = L11_2.max
    L12_2 = 1.0
    L13_2 = tonumber
    L14_2 = L0_1.npcSpeed
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = 13.0
    end
    L11_2 = L11_2(L12_2, L13_2)
    L10_2 = L10_2 / L11_2
    L9_2 = L9_2(L10_2)
    L8_2 = L9_2
  end
  ::lbl_196::
  L9_2 = {}
  L10_2 = L2_2.status
  L9_2.status = L10_2
  L9_2.courier = L7_2
  L10_2 = L5_2.coords
  L9_2.rest = L10_2
  L9_2.dest = L6_2
  L9_2.eta = L8_2
  L10_2 = L2_2.courier_npc
  L10_2 = 1 == L10_2
  L9_2.npc = L10_2
  return L9_2
end
L51_1["eats.track"] = L52_1
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = tonumber
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L23_1
  L2_2 = L3_2[L2_2]
  if L2_2 then
    L3_2 = L2_2.owner
    L4_2 = GetCid
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L3_2 == L4_2 then
      goto lbl_21
    end
  end
  L3_2 = {}
  L3_2.error = "notfound"
  do return L3_2 end
  ::lbl_21::
  L3_2 = L2_2.status
  if "pending" ~= L3_2 then
    L3_2 = L2_2.status
    if "accepted" ~= L3_2 then
      L3_2 = {}
      L3_2.error = "toolate"
      return L3_2
    end
  end
  L3_2 = L5_1
  L4_2 = tonumber
  L5_2 = L2_2.total
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  if L3_2 >= 1 then
    L4_2 = L38_1
    L5_2 = L2_2.owner
    L6_2 = L2_2.pay
    L7_2 = L3_2
    L8_2 = L2_2.id
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
    if L4_2 then
      goto lbl_50
    end
  end
  L4_2 = 0
  ::lbl_50::
  if L3_2 >= 1 and L4_2 < 1 then
    L5_2 = print
    L6_2 = "^1[unique_phone]^0 eats #%s: could not refund %s for the cancellation; order NOT cancelled"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = tostring
    L9_2 = L2_2.id
    L8_2 = L8_2(L9_2)
    L9_2 = FormatMoney
    L10_2 = L3_2
    L9_2, L10_2 = L9_2(L10_2)
    L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    L5_2 = {}
    L5_2.error = "refund"
    return L5_2
  end
  L5_2 = L28_1
  L6_2 = L2_2
  L7_2 = "cancelled"
  L5_2(L6_2, L7_2)
  L5_2 = L2_2.courier
  if L5_2 then
    L6_2 = L2_2.courier
    L5_2 = L25_1
    L5_2[L6_2] = nil
  end
  L6_2 = L2_2.id
  L5_2 = L23_1
  L5_2[L6_2] = nil
  L5_2 = {}
  L5_2.ok = true
  L5_2.refund = L4_2
  return L5_2
end
L52_1 = RPC
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = L11_1
  L4_2 = L2_2
  L5_2 = "cancel"
  L6_2 = L51_1
  L7_2 = A0_2
  L8_2 = A1_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L52_1["eats.cancel"] = L53_1
L52_1 = RPC
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = L6_1
  L5_2 = A1_2.stars
  L6_2 = 1
  L7_2 = 5
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT id, courier, rating, delivered, created FROM apex_phone_eats_orders WHERE id = ? AND owner = ? AND status = ?"
  L6_2 = {}
  L7_2 = A1_2.id
  L8_2 = L2_2
  L9_2 = "delivered"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L4_2.rating
    if not L5_2 then
      goto lbl_32
    end
  end
  L5_2 = {}
  L5_2.error = "invalid"
  do return L5_2 end
  ::lbl_32::
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = L0_1.ratingWindow
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2(L6_2)
  L6_2 = tonumber
  L7_2 = L4_2.delivered
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = tonumber
    L7_2 = L4_2.created
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 0
    end
  end
  if L5_2 > 0 and L6_2 > 0 then
    L7_2 = Now
    L7_2 = L7_2()
    L7_2 = L7_2 - L6_2
    L8_2 = L5_2 * 86400000
    if L7_2 > L8_2 then
      L7_2 = {}
      L7_2.error = "late"
      L7_2.days = L5_2
      return L7_2
    end
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_eats_orders SET rating = ?, rating_note = ? WHERE id = ? AND rating IS NULL"
  L9_2 = {}
  L10_2 = L3_2
  L11_2 = tostring
  L12_2 = A1_2.note
  if not L12_2 then
    L12_2 = ""
  end
  L11_2 = L11_2(L12_2)
  L12_2 = L11_2
  L11_2 = L11_2.sub
  L13_2 = 1
  L14_2 = 200
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L12_2 = L4_2.id
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = tonumber
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  if 1 ~= L8_2 then
    L8_2 = {}
    L8_2.error = "invalid"
    return L8_2
  end
  L8_2 = L4_2.courier
  if L8_2 then
    L8_2 = MySQL
    L8_2 = L8_2.update
    L9_2 = "UPDATE apex_phone_eats_meta SET rating_sum = rating_sum + ?, rating_n = rating_n + 1 WHERE owner = ?"
    L10_2 = {}
    L11_2 = L3_2
    L12_2 = L4_2.courier
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L8_2(L9_2, L10_2)
  end
  L8_2 = {}
  L8_2.ok = true
  return L8_2
end
L52_1["eats.rate"] = L53_1
L52_1 = RPC
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L18_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "noplayer"
    return L4_2
  end
  L4_2 = tostring
  L5_2 = A1_2.id
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L1_1
  L5_2 = L5_2[L4_2]
  if not L5_2 then
    L5_2 = {}
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = {}
  L6_2 = false
  L7_2 = ipairs
  L8_2 = L3_2.favorites
  if not L8_2 then
    L8_2 = {}
  end
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    if L12_2 == L4_2 then
      L6_2 = true
    else
      L13_2 = #L5_2
      L13_2 = L13_2 + 1
      L5_2[L13_2] = L12_2
    end
  end
  if not L6_2 then
    L7_2 = #L5_2
    L7_2 = L7_2 + 1
    L5_2[L7_2] = L4_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L8_2 = "UPDATE apex_phone_eats_meta SET favorites = ? WHERE owner = ?"
  L9_2 = {}
  L10_2 = json
  L10_2 = L10_2.encode
  L11_2 = L5_2
  L10_2 = L10_2(L11_2)
  L11_2 = L2_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L7_2(L8_2, L9_2)
  L7_2 = {}
  L7_2.ok = true
  L8_2 = not L6_2
  L7_2.fav = L8_2
  return L7_2
end
L52_1["eats.fav"] = L53_1
L52_1 = RPC
function L53_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT id, label, note, x, y FROM apex_phone_eats_addresses WHERE owner = ? ORDER BY created ASC LIMIT 12"
  L3_2 = {}
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  return L1_2
end
L52_1["eats.addresses"] = L53_1
function L52_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT COUNT(*) FROM apex_phone_eats_addresses WHERE owner = ?"
  L5_2 = {}
  L6_2 = A2_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = 0
  end
  if L3_2 >= 12 then
    L4_2 = {}
    L4_2.error = "toomany"
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = A1_2.x
  L4_2 = L4_2(L5_2)
  L5_2 = tonumber
  L6_2 = A1_2.y
  L5_2 = L5_2(L6_2)
  if not L4_2 or not L5_2 then
    L6_2 = L12_1
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L7_2 = {}
      L7_2.error = "nocoords"
      return L7_2
    end
    L7_2 = L6_2.x
    L5_2 = L6_2.y
    L4_2 = L7_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.insert
  L6_2 = L6_2.await
  L7_2 = "INSERT INTO apex_phone_eats_addresses (owner, label, note, x, y, created) VALUES (?, ?, ?, ?, ?, ?)"
  L8_2 = {}
  L9_2 = A2_2
  L10_2 = tostring
  L11_2 = A1_2.label
  if not L11_2 then
    L11_2 = "Casa"
  end
  L10_2 = L10_2(L11_2)
  L11_2 = L10_2
  L10_2 = L10_2.sub
  L12_2 = 1
  L13_2 = 64
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  L11_2 = tostring
  L12_2 = A1_2.note
  if not L12_2 then
    L12_2 = ""
  end
  L11_2 = L11_2(L12_2)
  L12_2 = L11_2
  L11_2 = L11_2.sub
  L13_2 = 1
  L14_2 = 120
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L12_2 = L4_2
  L13_2 = L5_2
  L14_2 = Now
  L14_2 = L14_2()
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = {}
  L7_2.ok = true
  L7_2.id = L6_2
  L7_2.x = L4_2
  L7_2.y = L5_2
  return L7_2
end
L53_1 = RPC
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L11_1
  L4_2 = L2_2
  L5_2 = "addr"
  L6_2 = L52_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = L2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
end
L53_1["eats.address.add"] = L54_1
L53_1 = RPC
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L3_2 = "DELETE FROM apex_phone_eats_addresses WHERE id = ? AND owner = ?"
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
L53_1["eats.address.del"] = L54_1
L53_1 = RPC
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = L1_2.cid
  L3_2 = L18_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "db"
    return L4_2
  end
  L4_2 = L19_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = {}
    L4_2.error = "already"
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = tonumber
  L6_2 = L0_1.proPrice
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  if L4_2 >= 1 then
    L5_2 = L1_2.GetMoney
    L6_2 = "bank"
    L5_2 = L5_2(L6_2)
    if L4_2 > L5_2 then
      L5_2 = {}
      L5_2.error = "funds"
      return L5_2
    end
  end
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = L3_2.pro_until
  if not L7_2 then
    L7_2 = 0
  end
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2(L6_2)
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = tonumber
  L8_2 = L0_1.proDays
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 30
  end
  L7_2 = L7_2 * 86400000
  L6_2 = L6_2 + L7_2
  L7_2 = pcall
  L8_2 = MySQL
  L8_2 = L8_2.update
  L8_2 = L8_2.await
  L9_2 = "UPDATE apex_phone_eats_meta SET pro_until = ? WHERE owner = ? AND (pro_until IS NULL OR pro_until <= ?)"
  L10_2 = {}
  L11_2 = L6_2
  L12_2 = L2_2
  L13_2 = Now
  L13_2, L14_2, L15_2 = L13_2()
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L9_2 = print
    L10_2 = "^1[unique_phone]^0 eats: the Eats Pro of %s was not saved (%s); nothing was charged"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = tostring
    L13_2 = L2_2
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = L8_2
    L13_2, L14_2, L15_2 = L13_2(L14_2)
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L9_2 = {}
    L9_2.error = "db"
    return L9_2
  end
  L9_2 = tonumber
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = 0
  end
  if 1 ~= L9_2 then
    L9_2 = pcall
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = tonumber
      L1_3 = MySQL
      L1_3 = L1_3.scalar
      L1_3 = L1_3.await
      L2_3 = "SELECT pro_until FROM apex_phone_eats_meta WHERE owner = ?"
      L3_3 = {}
      L4_3 = L2_2
      L3_3[1] = L4_3
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3, L3_3)
      return L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L9_2, L10_2 = L9_2(L10_2)
    if L9_2 then
      L11_2 = tonumber
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L12_2 = Now
      L12_2 = L12_2()
      if L11_2 > L12_2 then
        L11_2 = {}
        L11_2.error = "already"
        return L11_2
      end
    end
    L11_2 = print
    L12_2 = "^1[unique_phone]^0 eats: the Eats Pro of %s was not saved (does the meta row exist?); nothing was charged"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = tostring
    L15_2 = L2_2
    L14_2, L15_2 = L14_2(L15_2)
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2)
    L11_2(L12_2, L13_2, L14_2, L15_2)
    L11_2 = {}
    L11_2.error = "db"
    return L11_2
  end
  if L4_2 >= 1 then
    L9_2 = L1_2.RemoveMoney
    L10_2 = "bank"
    L11_2 = L4_2
    L12_2 = "eats-pro"
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if not L9_2 then
      L9_2 = pcall
      L10_2 = MySQL
      L10_2 = L10_2.update
      L10_2 = L10_2.await
      L11_2 = "UPDATE apex_phone_eats_meta SET pro_until = ? WHERE owner = ? AND pro_until = ?"
      L12_2 = {}
      L13_2 = L5_2
      L14_2 = L2_2
      L15_2 = L6_2
      L12_2[1] = L13_2
      L12_2[2] = L14_2
      L12_2[3] = L15_2
      L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
      if L9_2 then
        L11_2 = tonumber
        L12_2 = L10_2
        L11_2 = L11_2(L12_2)
        if not L11_2 then
          L11_2 = 0
        end
        if 1 == L11_2 then
          goto lbl_182
        end
      end
      L11_2 = print
      L12_2 = "^1[unique_phone]^0 eats: %s has Eats Pro UNPAID (the charge failed and it could not be undone)"
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = tostring
      L15_2 = L2_2
      L14_2, L15_2 = L14_2(L15_2)
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2)
      L11_2(L12_2, L13_2, L14_2, L15_2)
      ::lbl_182::
      L11_2 = {}
      L11_2.error = "funds"
      return L11_2
    end
  end
  if L4_2 >= 1 then
    L9_2 = AddTransaction
    L10_2 = L2_2
    L11_2 = "Eats Pro"
    L12_2 = -L4_2
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = {}
  L9_2.ok = true
  L9_2.until_ = L6_2
  return L9_2
end
L53_1["eats.pro"] = L54_1
L53_1 = RPC
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = A1_2.on
  if L3_2 then
    L3_2 = L0_1.courierJob
    if L3_2 then
      L3_2 = L0_1.courierJob
      if "" ~= L3_2 then
        L3_2 = L2_2.job
        if L3_2 then
          L3_2 = L2_2.job
          L3_2 = L3_2.name
          L4_2 = L0_1.courierJob
          if L3_2 == L4_2 then
            goto lbl_34
          end
        end
        L3_2 = {}
        L3_2.error = "job"
        L4_2 = L0_1.courierJob
        L3_2.job = L4_2
        return L3_2
      end
    end
    ::lbl_34::
    L3_2 = L24_1
    L4_2 = {}
    L5_2 = L2_2.cid
    L4_2.cid = L5_2
    L5_2 = L2_2.firstname
    if not L5_2 then
      L5_2 = ""
    end
    L6_2 = " "
    L7_2 = L2_2.lastname
    if not L7_2 then
      L7_2 = ""
    end
    L5_2 = L5_2 .. L6_2 .. L7_2
    L4_2.name = L5_2
    L5_2 = GetPlayerNumber
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    L4_2.phone = L5_2
    L5_2 = Now
    L5_2 = L5_2()
    L4_2.since = L5_2
    L3_2[A0_2] = L4_2
    L3_2 = pairs
    L4_2 = L23_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L8_2.status
      if "pending" == L9_2 then
        L9_2 = L30_1
        L10_2 = L8_2
        L9_2(L10_2)
      end
    end
  else
    L3_2 = L24_1
    L3_2[A0_2] = nil
  end
  L3_2 = {}
  L3_2.ok = true
  L4_2 = L24_1
  L4_2 = L4_2[A0_2]
  L4_2 = nil ~= L4_2
  L3_2.on = L4_2
  return L3_2
end
L53_1["eats.courier.toggle"] = L54_1
L53_1 = RPC
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L29_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = {}
    L3_2.error = "offline"
    return L3_2
  end
  L4_2 = L2_2.cid
  L3_2 = L25_1
  L3_2 = L3_2[L4_2]
  if L3_2 then
    L3_2 = {}
    L3_2.error = "busy"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = -1
  end
  L4_2 = L23_1
  L3_2 = L4_2[L3_2]
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "gone"
    return L4_2
  end
  L4_2 = L3_2.status
  if "pending" ~= L4_2 then
    L4_2 = {}
    L4_2.error = "taken"
    return L4_2
  end
  L4_2 = L3_2.owner
  L5_2 = L2_2.cid
  if L4_2 == L5_2 then
    L4_2 = {}
    L4_2.error = "self"
    return L4_2
  end
  L5_2 = L2_2.cid
  L4_2 = L25_1
  L6_2 = L3_2.id
  L4_2[L5_2] = L6_2
  L4_2 = L2_2.cid
  L3_2.courier = L4_2
  L4_2 = L2_2.firstname
  if not L4_2 then
    L4_2 = ""
  end
  L5_2 = " "
  L6_2 = L2_2.lastname
  if not L6_2 then
    L6_2 = ""
  end
  L4_2 = L4_2 .. L5_2 .. L6_2
  L3_2.courier_name = L4_2
  L4_2 = GetPlayerNumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L3_2.courier_phone = L4_2
  L3_2.courier_npc = 0
  L4_2 = L28_1
  L5_2 = L3_2
  L6_2 = "accepted"
  L7_2 = {}
  L8_2 = L3_2.courier
  L7_2.courier = L8_2
  L8_2 = L3_2.courier_name
  L7_2.courier_name = L8_2
  L8_2 = L3_2.courier_phone
  L7_2.courier_phone = L8_2
  L7_2.courier_npc = 0
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = NotifyCitizen
  L5_2 = L3_2.owner
  L6_2 = "eats"
  L7_2 = "Pedido aceite"
  L8_2 = L3_2.courier_name
  L9_2 = " vai buscar a tua comida."
  L8_2 = L8_2 .. L9_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = {}
  L4_2.ok = true
  L5_2 = L26_1
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L4_2.order = L5_2
  L6_2 = L3_2.restaurant
  L5_2 = L1_1
  L5_2 = L5_2[L6_2]
  if not L5_2 then
    L5_2 = {}
  end
  L5_2 = L5_2.coords
  L4_2.rest = L5_2
  return L4_2
end
L53_1["eats.courier.accept"] = L54_1
L53_1 = RPC
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = -1
  end
  L4_2 = L23_1
  L3_2 = L4_2[L3_2]
  if L3_2 then
    L4_2 = L3_2.courier
    L5_2 = L2_2.cid
    if L4_2 == L5_2 then
      goto lbl_29
    end
  end
  L4_2 = {}
  L4_2.error = "notyours"
  do return L4_2 end
  ::lbl_29::
  L4_2 = L3_2.status
  if "ready" ~= L4_2 then
    L4_2 = {}
    L5_2 = L3_2.status
    if "accepted" == L5_2 then
      L5_2 = "notready"
      if L5_2 then
        goto lbl_41
      end
    end
    L5_2 = "state"
    ::lbl_41::
    L4_2.error = L5_2
    return L4_2
  end
  L5_2 = L3_2.restaurant
  L4_2 = L1_1
  L4_2 = L4_2[L5_2]
  L5_2 = L12_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if L4_2 then
    L6_2 = L4_2.coords
    if L6_2 and L5_2 then
      L6_2 = L13_1
      L7_2 = L5_2
      L8_2 = L4_2.coords
      L6_2 = L6_2(L7_2, L8_2)
      L7_2 = 3600
      if L6_2 > L7_2 then
        L6_2 = {}
        L6_2.error = "far"
        return L6_2
      end
    end
  end
  L6_2 = L28_1
  L7_2 = L3_2
  L8_2 = "picked"
  L6_2(L7_2, L8_2)
  L6_2 = Now
  L6_2 = L6_2()
  L3_2._tripStart = L6_2
  L6_2 = NotifyCitizen
  L7_2 = L3_2.owner
  L8_2 = "eats"
  L9_2 = "A caminho"
  L10_2 = L3_2.courier_name
  L11_2 = " levantou o teu pedido."
  L10_2 = L10_2 .. L11_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
  L6_2 = {}
  L6_2.ok = true
  L7_2 = {}
  L8_2 = L3_2.addr_x
  L7_2.x = L8_2
  L8_2 = L3_2.addr_y
  L7_2.y = L8_2
  L6_2.dest = L7_2
  return L6_2
end
L53_1["eats.courier.pickup"] = L54_1
L53_1 = RPC
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = -1
  end
  L4_2 = L23_1
  L3_2 = L4_2[L3_2]
  if L3_2 then
    L4_2 = L3_2.courier
    L5_2 = L2_2.cid
    if L4_2 == L5_2 then
      goto lbl_29
    end
  end
  L4_2 = {}
  L4_2.error = "notyours"
  do return L4_2 end
  ::lbl_29::
  L4_2 = L3_2.status
  if "picked" ~= L4_2 then
    L4_2 = {}
    L4_2.error = "state"
    return L4_2
  end
  L4_2 = L12_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L13_1
    L6_2 = L4_2
    L7_2 = {}
    L8_2 = L3_2.addr_x
    L7_2.x = L8_2
    L8_2 = L3_2.addr_y
    L7_2.y = L8_2
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = 3600
    if L5_2 > L6_2 then
      L5_2 = {}
      L5_2.error = "far"
      return L5_2
    end
  end
  L5_2 = L44_1
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L6_2 = {}
  L6_2.ok = true
  L6_2.earned = L5_2
  return L6_2
end
L53_1["eats.courier.deliver"] = L54_1
L53_1 = RPC
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = {}
  L3_2 = pairs
  L4_2 = L23_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.courier
    if L9_2 == L1_2 then
      L9_2 = #L2_2
      L9_2 = L9_2 + 1
      L10_2 = L26_1
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      L2_2[L9_2] = L10_2
    end
  end
  L3_2 = {}
  L4_2 = L29_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = L25_1
    L4_2 = L4_2[L1_2]
    if not L4_2 then
      L4_2 = tonumber
      L5_2 = L0_1.courierRadius
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = 1200.0
      end
      L4_2 = L4_2 ^ 2
      L5_2 = L12_1
      L6_2 = A0_2
      L5_2 = L5_2(L6_2)
      L6_2 = pairs
      L7_2 = L23_1
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = L11_2.status
        if "pending" == L12_2 then
          L13_2 = L11_2.restaurant
          L12_2 = L1_1
          L12_2 = L12_2[L13_2]
          if not L12_2 then
            L12_2 = {}
          end
          L12_2 = L12_2.coords
          if L12_2 and L5_2 then
            L13_2 = L13_1
            L14_2 = L5_2
            L15_2 = L12_2
            L13_2 = L13_2(L14_2, L15_2)
            if not (L4_2 >= L13_2) then
              goto lbl_127
            end
          end
          L13_2 = #L3_2
          L13_2 = L13_2 + 1
          L14_2 = {}
          L15_2 = L11_2.id
          L14_2.id = L15_2
          L16_2 = L11_2.restaurant
          L15_2 = L1_1
          L15_2 = L15_2[L16_2]
          if not L15_2 then
            L15_2 = {}
          end
          L15_2 = L15_2.name
          L14_2.restName = L15_2
          L14_2.restCoords = L12_2
          L15_2 = {}
          L16_2 = L11_2.addr_label
          L15_2.label = L16_2
          L16_2 = L11_2.addr_x
          L15_2.x = L16_2
          L16_2 = L11_2.addr_y
          L15_2.y = L16_2
          L14_2.addr = L15_2
          L15_2 = L11_2.lines
          L15_2 = #L15_2
          L14_2.items = L15_2
          L15_2 = L5_1
          L16_2 = tonumber
          L17_2 = L11_2.fee
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = 0
          end
          L17_2 = tonumber
          L18_2 = L0_1.courierCutPct
          L17_2 = L17_2(L18_2)
          if not L17_2 then
            L17_2 = 70
          end
          L17_2 = L17_2 / 100
          L16_2 = L16_2 * L17_2
          L17_2 = tonumber
          L18_2 = L11_2.tip
          L17_2 = L17_2(L18_2)
          if not L17_2 then
            L17_2 = 0
          end
          L16_2 = L16_2 + L17_2
          L15_2 = L15_2(L16_2)
          L14_2.pay = L15_2
          L3_2[L13_2] = L14_2
        end
        ::lbl_127::
      end
    end
  end
  L4_2 = {}
  L4_2.mine = L2_2
  L4_2.offers = L3_2
  L5_2 = L24_1
  L5_2 = L5_2[A0_2]
  L5_2 = nil ~= L5_2
  L4_2.on = L5_2
  return L4_2
end
L53_1["eats.courier.jobs"] = L54_1
L53_1 = RPC
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L18_1
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = tonumber
  L3_2 = L1_2.rating_n
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L3_2 = {}
  L4_2 = L1_2.deliveries
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.deliveries = L4_2
  L4_2 = tonumber
  L5_2 = L1_2.earnings
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.earnings = L4_2
  if L2_2 > 0 then
    L4_2 = L5_1
    L5_2 = tonumber
    L6_2 = L1_2.rating_sum
    if not L6_2 then
      L6_2 = 0
    end
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = 0
    end
    L5_2 = L5_2 / L2_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_54
    end
  end
  L4_2 = nil
  ::lbl_54::
  L3_2.rating = L4_2
  L3_2.ratings = L2_2
  return L3_2
end
L53_1["eats.courier.stats"] = L54_1
L53_1 = RPC
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.job
    if L2_2 then
      goto lbl_13
    end
  end
  L2_2 = {}
  do return L2_2 end
  ::lbl_13::
  L2_2 = L1_2.job
  L2_2 = L2_2.name
  L3_2 = {}
  L4_2 = pairs
  L5_2 = L23_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L11_2 = L9_2.restaurant
    L10_2 = L1_1
    L10_2 = L10_2[L11_2]
    if L10_2 then
      L11_2 = L10_2.job
      if L11_2 == L2_2 then
        L11_2 = #L3_2
        L11_2 = L11_2 + 1
        L12_2 = L26_1
        L13_2 = L9_2
        L12_2 = L12_2(L13_2)
        L3_2[L11_2] = L12_2
      end
    end
  end
  return L3_2
end
L53_1["eats.kitchen"] = L54_1
L53_1 = RPC
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = L2_2.job
    if L3_2 then
      goto lbl_14
    end
  end
  L3_2 = {}
  L3_2.error = "nojob"
  do return L3_2 end
  ::lbl_14::
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = -1
  end
  L4_2 = L23_1
  L3_2 = L4_2[L3_2]
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "gone"
    return L4_2
  end
  L5_2 = L3_2.restaurant
  L4_2 = L1_1
  L4_2 = L4_2[L5_2]
  if L4_2 then
    L5_2 = L4_2.job
    L6_2 = L2_2.job
    L6_2 = L6_2.name
    if L5_2 == L6_2 then
      goto lbl_42
    end
  end
  L5_2 = {}
  L5_2.error = "notyours"
  do return L5_2 end
  ::lbl_42::
  L5_2 = L3_2.status
  if "accepted" ~= L5_2 then
    L5_2 = {}
    L5_2.error = "state"
    return L5_2
  end
  L3_2._readyDue = 0
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L53_1["eats.kitchen.ready"] = L54_1
