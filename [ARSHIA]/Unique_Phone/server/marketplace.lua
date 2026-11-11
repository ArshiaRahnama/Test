local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1
L0_1 = CreateThread
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_market` (
        `id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `seller_name` VARCHAR(64) NULL, `seller_phone` VARCHAR(20) NULL,
        `title` VARCHAR(80) NOT NULL, `description` TEXT NULL, `price` INT NOT NULL, `category` VARCHAR(30) NOT NULL DEFAULT 'Outros',
        `image` LONGTEXT NULL, `sold` TINYINT NOT NULL DEFAULT 0, `buyer` VARCHAR(64) NULL, `created` BIGINT NOT NULL,
        `kind` VARCHAR(10) NOT NULL DEFAULT 'other', `item_name` VARCHAR(64) NULL,
        KEY `owner` (`owner`), KEY `cat` (`category`, `sold`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = L0_2
  L1_2(L2_2)
  L1_2 = pcall
  L2_2 = MigrateTable
  L3_2 = L0_2
  L1_2(L2_2, L3_2)
  L1_2 = FW
  L1_2 = L1_2.WidenColumns
  L2_2 = {}
  L3_2 = {}
  L4_2 = "apex_phone_market"
  L5_2 = "owner"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L4_2 = {}
  L5_2 = "apex_phone_market"
  L6_2 = "buyer"
  L7_2 = true
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L1_2(L2_2)
end
L0_1(L1_1)
function L0_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.sold
  L1_2 = 1 == L1_2
  A0_2.sold = L1_2
  L1_2 = A0_2.image
  if L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2.image
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = tonumber
      L2_2 = A0_2.image
      L1_2 = L1_2(L2_2)
      A0_2.image = L1_2
    end
  end
  L1_2 = A0_2.escrow_count
  L1_2 = nil ~= L1_2
  A0_2.escrow = L1_2
  L1_2 = A0_2.escrow
  if L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2.escrow_count
    L1_2 = L1_2(L2_2)
    A0_2.item_count = L1_2
  end
  L1_2 = A0_2.custody
  if nil ~= L1_2 then
    L1_2 = A0_2.custody
    L1_2 = 1 == L1_2
    A0_2.custody = L1_2
  end
  A0_2.escrow_count = nil
  return A0_2
end
L1_1 = ItemEscrow
if not L1_1 then
  L1_1 = {}
end
ItemEscrow = L1_1
L1_1 = ItemEscrow
L1_1.ready = false
L1_1 = {}
L1_1.market = "marketplace"
L1_1.onion = "onion"
L2_1 = 5000
L3_1 = {}
L4_1 = {}
L5_1 = {}
L6_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_item_escrow` (
        `id` INT AUTO_INCREMENT PRIMARY KEY, `source` VARCHAR(10) NOT NULL, `ref_id` INT NOT NULL DEFAULT 0,
        `owner` VARCHAR(64) NOT NULL, `item` VARCHAR(64) NOT NULL, `count` INT NOT NULL DEFAULT 1, `meta` TEXT NULL,
        `status` VARCHAR(16) NOT NULL DEFAULT 'held', `target` VARCHAR(64) NULL, `created` BIGINT NOT NULL, `updated` BIGINT NOT NULL,
        KEY `owner` (`owner`), KEY `target_status` (`target`, `status`), KEY `ref` (`source`, `ref_id`), KEY `status` (`status`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
L7_1 = CreateThread
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L6_1
    L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 could not create apex_phone_item_escrow (%s): item listings with escrow become unavailable"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
    return
  end
  L2_2 = pcall
  L3_2 = MigrateTable
  L4_2 = L6_1
  L2_2(L3_2, L4_2)
  L2_2 = pcall
  L3_2 = EnsureIndex
  L4_2 = "apex_phone_item_escrow"
  L5_2 = "ref"
  L6_2 = {}
  L7_2 = "source"
  L8_2 = "ref_id"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = pcall
  L3_2 = EnsureIndex
  L4_2 = "apex_phone_item_escrow"
  L5_2 = "status"
  L6_2 = {}
  L7_2 = "status"
  L6_2[1] = L7_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = pcall
  L3_2 = EnsureIndex
  L4_2 = "apex_phone_item_escrow"
  L5_2 = "target_status"
  L6_2 = {}
  L7_2 = "target"
  L8_2 = "status"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = ItemEscrow
  L2_2.ready = true
  L2_2 = Dbg
  L3_2 = "escrow"
  L4_2 = "escrow table ready"
  L2_2(L3_2, L4_2)
end
L7_1(L8_1)
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 and L3_2 == L3_2 then
    L4_2 = math
    L4_2 = L4_2.huge
    if L3_2 ~= L4_2 then
      L4_2 = math
      L4_2 = L4_2.huge
      L4_2 = -L4_2
      if L3_2 ~= L4_2 then
        goto lbl_19
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_19::
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L3_2 = L4_2
  if A1_2 > L3_2 or A2_2 < L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_2
  end
  return L4_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 < 1) then
      L1_2 = #A0_2
      if not (L1_2 > 64) then
        L2_2 = A0_2
        L1_2 = A0_2.match
        L3_2 = "^[%w_%-%.]+$"
        L1_2 = L1_2(L2_2, L3_2)
        if L1_2 then
          goto lbl_19
        end
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_19::
  return A0_2
end
function L9_1(A0_2)
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
  L2_2 = "?"
  do return L2_2 end
  ::lbl_19::
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L1_2 = L2_2
  L2_2 = tostring
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L1_2
  end
  return L2_2(L3_2)
end
L10_1 = ItemEscrow
L10_1.key = L9_1
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2.id
    L1_2 = L1_2(L2_2)
  end
  A0_2.id = L1_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2.ref_id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  A0_2.ref_id = L1_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2.count
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  A0_2.count = L1_2
  return A0_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L10_1
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_item_escrow WHERE id = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  return L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2.meta
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = A0_2.meta
    if "" ~= L1_2 then
      goto lbl_11
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_11::
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2.meta
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 and L2_2 then
      goto lbl_26
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = nil
  ::lbl_26::
  return L3_2
end
L13_1 = ItemEscrow
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetResourceState
  L2_2 = "ox_inventory"
  L1_2 = L1_2(L2_2)
  if "started" == L1_2 then
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3, L2_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.Items
      L2_3 = A0_2
      return L0_3(L1_3, L2_3)
    end
    L1_2, L2_2 = L1_2(L2_2)
    if L1_2 then
      L3_2 = type
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        L3_2 = L2_2.label
        if L3_2 then
          L3_2 = tostring
          L4_2 = L2_2.label
          return L3_2(L4_2)
        end
      end
    end
  end
  L1_2 = tostring
  L2_2 = A0_2
  return L1_2(L2_2)
end
L13_1.label = L14_1
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = "%d\195\151 %s"
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = A0_2.count
  L4_2 = ItemEscrow
  L4_2 = L4_2.label
  L5_2 = A0_2.item
  L4_2, L5_2 = L4_2(L5_2)
  return L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L14_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if A0_2 and "" ~= A0_2 then
    L4_2 = NotifyCitizen
    L5_2 = A0_2
    L7_2 = A1_2.source
    L6_2 = L1_1
    L6_2 = L6_2[L7_2]
    if not L6_2 then
      L6_2 = "marketplace"
    end
    L7_2 = A2_2
    L8_2 = A3_2
    L9_2 = nil
    L10_2 = {}
    L10_2.throttle = false
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  end
end
L15_1 = ItemEscrow
function L16_1(A0_2)
  local L1_2, L2_2, L3_2
  if "onion" == A0_2 then
    L1_2 = Config
    L1_2 = L1_2.Onion
    if L1_2 then
      goto lbl_9
    end
  end
  L1_2 = Config
  L1_2 = L1_2.Marketplace
  ::lbl_9::
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L2_2 = "table" ~= L2_2
  return L2_2
end
L15_1.enabled = L16_1
L15_1 = ItemEscrow
function L16_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = ItemEscrow
  L1_2 = L1_2.ready
  if L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  while true do
    L2_2 = ItemEscrow
    L2_2 = L2_2.ready
    if L2_2 then
      break
    end
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L2_2 = L2_2 - L1_2
    L3_2 = A0_2 or L3_2
    if not A0_2 then
      L3_2 = L2_1
    end
    if not (L2_2 < L3_2) then
      break
    end
    L2_2 = Wait
    L3_2 = 100
    L2_2(L3_2)
  end
  L2_2 = ItemEscrow
  L2_2 = L2_2.ready
  return L2_2
end
L15_1.waitReady = L16_1
L15_1 = ItemEscrow
function L16_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  while true do
    L3_2 = L3_1
    L3_2 = L3_2[A0_2]
    if not L3_2 then
      break
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_2 = L3_2 - L2_2
    L4_2 = L2_1
    if L3_2 > L4_2 then
      L3_2 = Dbg
      L4_2 = "escrow"
      L5_2 = "lock %s held for more than %d ms"
      L6_2 = A0_2
      L7_2 = L2_1
      L3_2(L4_2, L5_2, L6_2, L7_2)
      L3_2 = {}
      L3_2.ok = false
      L3_2.error = "busy"
      return L3_2
    end
    L3_2 = Wait
    L4_2 = 25
    L3_2(L4_2)
  end
  L3_2 = L3_1
  L3_2[A0_2] = true
  L3_2 = table
  L3_2 = L3_2.pack
  L4_2 = pcall
  L5_2 = A1_2
  L6_2, L7_2 = ...
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L3_1
  L4_2[A0_2] = nil
  L4_2 = L3_2[1]
  if not L4_2 then
    L4_2 = error
    L5_2 = L3_2[2]
    L6_2 = 0
    L4_2(L5_2, L6_2)
  end
  L4_2 = table
  L4_2 = L4_2.unpack
  L5_2 = L3_2
  L6_2 = 2
  L7_2 = L3_2.n
  return L4_2(L5_2, L6_2, L7_2)
end
L15_1.withLock = L16_1
L15_1 = ItemEscrow
function L16_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L3_1
  L2_2[A0_2] = true
  L2_2 = pcall
  L3_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = ...
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L3_1
  L4_2[A0_2] = nil
  if not L2_2 then
    L4_2 = print
    L5_2 = "^1[unique_phone]^0 escrow (%s): %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = A0_2
    L8_2 = tostring
    L9_2 = L3_2
    L8_2, L9_2 = L8_2(L9_2)
    L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  end
  L4_2 = true
  return L4_2
end
L15_1.tryLock = L16_1
L15_1 = 60000
function L16_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = next
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if nil ~= L1_2 then
      goto lbl_13
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_13::
  return A0_2
end
function L17_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if not A2_2 then
    A2_2 = 0
  end
  if 0 == A2_2 then
    L3_2 = L16_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = {}
    end
    L4_2 = L16_1
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    A1_2 = L4_2 or A1_2
    if not L4_2 then
      L4_2 = {}
      A1_2 = L4_2
    end
    A0_2 = L3_2
  end
  if A0_2 == A1_2 then
    L3_2 = true
    return L3_2
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = type
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if not ("table" ~= L3_2 or A2_2 > 16) then
      goto lbl_40
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_40::
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L17_1
    L10_2 = L8_2
    L11_2 = A1_2[L7_2]
    L12_2 = A2_2 + 1
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if not L9_2 then
      L9_2 = false
      return L9_2
    end
  end
  L3_2 = pairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = A0_2[L7_2]
    if nil == L8_2 then
      L8_2 = false
      return L8_2
    end
  end
  L3_2 = true
  return L3_2
end
function L18_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = exports
    L0_3 = L0_3.ox_inventory
    L1_3 = L0_3
    L0_3 = L0_3.GetSlotsWithItem
    L2_3 = A0_2
    L3_3 = A1_2
    return L0_3(L1_3, L2_3, L3_3)
  end
  L4_2, L5_2 = L4_2(L5_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_14
    end
  end
  L6_2 = nil
  L7_2 = "noinv"
  do return L6_2, L7_2 end
  ::lbl_14::
  L6_2 = {}
  L7_2 = 0
  L8_2 = pairs
  L9_2 = L5_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = type
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = math
      L14_2 = L14_2.tointeger
      L15_2 = tonumber
      L16_2 = L13_2.count
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L15_2(L16_2)
      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
      if L14_2 then
        goto lbl_35
      end
    end
    L14_2 = nil
    ::lbl_35::
    L15_2 = type
    L16_2 = L13_2
    L15_2 = L15_2(L16_2)
    if "table" == L15_2 then
      L15_2 = math
      L15_2 = L15_2.tointeger
      L16_2 = tonumber
      L17_2 = L13_2.slot
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L16_2(L17_2)
      L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
      if L15_2 then
        goto lbl_49
      end
    end
    L15_2 = nil
    ::lbl_49::
    if L14_2 and L14_2 > 0 and L15_2 then
      if nil ~= A3_2 then
        L16_2 = L17_1
        L17_2 = L13_2.metadata
        L18_2 = A3_2
        L16_2 = L16_2(L17_2, L18_2)
        if not L16_2 then
          goto lbl_77
        end
      end
      L16_2 = #L6_2
      L16_2 = L16_2 + 1
      L17_2 = {}
      L17_2.slot = L15_2
      L17_2.count = L14_2
      L18_2 = L16_1
      L19_2 = L13_2.metadata
      L18_2 = L18_2(L19_2)
      L17_2.meta = L18_2
      L6_2[L16_2] = L17_2
      L7_2 = L7_2 + L14_2
    end
    ::lbl_77::
  end
  if A2_2 > L7_2 then
    L8_2 = nil
    L9_2 = "noitem"
    return L8_2, L9_2
  end
  L8_2 = table
  L8_2 = L8_2.sort
  L9_2 = L6_2
  function L10_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.slot
    L3_3 = A1_3.slot
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L8_2(L9_2, L10_2)
  L8_2 = {}
  L9_2 = A2_2
  L10_2 = ipairs
  L11_2 = L6_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    if L9_2 <= 0 then
      break
    end
    L16_2 = math
    L16_2 = L16_2.min
    L17_2 = L9_2
    L18_2 = L15_2.count
    L16_2 = L16_2(L17_2, L18_2)
    L17_2 = pcall
    function L18_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.RemoveItem
      L2_3 = A0_2
      L3_3 = A1_2
      L4_3 = L16_2
      L5_3 = nil
      L6_3 = L15_2.slot
      return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
    end
    L17_2, L18_2 = L17_2(L18_2)
    if not L17_2 or not L18_2 then
      L19_2 = Dbg
      L20_2 = "escrow"
      L21_2 = "ox RemoveItem(%s, %s, %d, slot %d) refused"
      L22_2 = A0_2
      L23_2 = A1_2
      L24_2 = L16_2
      L25_2 = L15_2.slot
      L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
      L19_2 = ipairs
      L20_2 = L8_2
      L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
      for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
        L25_2 = pcall
        L26_2 = FW
        L26_2 = L26_2.AddItem
        L27_2 = A0_2
        L28_2 = A1_2
        L29_2 = L24_2.count
        L30_2 = L24_2.meta
        L25_2(L26_2, L27_2, L28_2, L29_2, L30_2)
      end
      L19_2 = nil
      L20_2 = "noitem"
      return L19_2, L20_2
    end
    L9_2 = L9_2 - L16_2
    L19_2 = nil
    L20_2 = ipairs
    L21_2 = L8_2
    L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
    for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
      L26_2 = L17_1
      L27_2 = L25_2.meta
      L28_2 = L15_2.meta
      L26_2 = L26_2(L27_2, L28_2)
      if L26_2 then
        L19_2 = L25_2
        break
      end
    end
    if L19_2 then
      L20_2 = L19_2.count
      L20_2 = L20_2 + L16_2
      L19_2.count = L20_2
    else
      L20_2 = #L8_2
      L20_2 = L20_2 + 1
      L21_2 = {}
      L21_2.count = L16_2
      L22_2 = L15_2.meta
      L21_2.meta = L22_2
      L8_2[L20_2] = L21_2
    end
  end
  return L8_2
end
function L19_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L4_2 = type
  L5_2 = FW
  L5_2 = L5_2.HasItem
  L4_2 = L4_2(L5_2)
  if "function" == L4_2 then
    L4_2 = type
    L5_2 = FW
    L5_2 = L5_2.RemoveItem
    L4_2 = L4_2(L5_2)
    if "function" == L4_2 then
      goto lbl_16
    end
  end
  L4_2 = nil
  L5_2 = "noinv"
  do return L4_2, L5_2 end
  ::lbl_16::
  L4_2 = FW
  L4_2 = L4_2.InventoryName
  L4_2 = L4_2()
  if not L4_2 then
    L5_2 = nil
    L6_2 = "noinv"
    return L5_2, L6_2
  end
  if "ox_inventory" == L4_2 then
    L5_2 = L18_1
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = A2_2
    L9_2 = A3_2
    return L5_2(L6_2, L7_2, L8_2, L9_2)
  end
  L5_2 = pcall
  L6_2 = FW
  L6_2 = L6_2.HasItem
  L7_2 = A0_2
  L8_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L7_2 = tonumber
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_47
      L6_2 = L7_2 or L6_2
    end
  end
  L6_2 = nil
  ::lbl_47::
  if not L6_2 then
    L7_2 = nil
    L8_2 = "noinv"
    return L7_2, L8_2
  end
  if A2_2 > L6_2 then
    L7_2 = nil
    L8_2 = "noitem"
    return L7_2, L8_2
  end
  L7_2 = pcall
  L8_2 = FW
  L8_2 = L8_2.RemoveItem
  L9_2 = A0_2
  L10_2 = A1_2
  L11_2 = A2_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  if not L7_2 or not L8_2 then
    L9_2 = Dbg
    L10_2 = "escrow"
    L11_2 = "FW.RemoveItem(%s, %s, %d) refused"
    L12_2 = A0_2
    L13_2 = A1_2
    L14_2 = A2_2
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L9_2 = nil
    L10_2 = "noitem"
    return L9_2, L10_2
  end
  L9_2 = {}
  L10_2 = {}
  L10_2.count = A2_2
  L9_2[1] = L10_2
  return L9_2
end
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L12_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = FW
  L3_2 = L3_2.InventoryName
  L3_2 = L3_2()
  if "ox_inventory" == L3_2 then
    L3_2 = pcall
    function L4_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.CanCarryItem
      L2_3 = A0_2
      L3_3 = A1_2.item
      L4_3 = A1_2.count
      L5_3 = L2_2
      return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
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
  L6_2 = A1_2.item
  L7_2 = A1_2.count
  L8_2 = L2_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L5_2 = L3_2 or L5_2
  L5_2 = L3_2 and true == L4_2
  return L5_2
end
function L21_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L6_2 = nil
  if nil ~= A5_2 then
    L7_2 = pcall
    L8_2 = json
    L8_2 = L8_2.encode
    L9_2 = A5_2
    L7_2, L8_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "string" == L9_2 then
        L9_2 = #L8_2
        L10_2 = L15_1
        if not (L9_2 > L10_2) then
          goto lbl_23
        end
      end
    end
    L9_2 = nil
    L10_2 = "metadados ilegiveis ou grandes demais"
    do return L9_2, L10_2 end
    ::lbl_23::
    L6_2 = L8_2
  end
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = {}
  L9_2 = A0_2
  L10_2 = A1_2
  L11_2 = A2_2
  L12_2 = A3_2
  L13_2 = A4_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  if L6_2 then
    L9_2 = #L8_2
    L9_2 = L9_2 + 1
    L8_2[L9_2] = L6_2
  end
  L9_2 = #L8_2
  L9_2 = L9_2 + 1
  L8_2[L9_2] = L7_2
  L9_2 = #L8_2
  L9_2 = L9_2 + 1
  L8_2[L9_2] = L7_2
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.insert
  L10_2 = L10_2.await
  L11_2 = "INSERT INTO apex_phone_item_escrow (`source`, `ref_id`, `owner`, `item`, `count`, `meta`, `status`, `target`, `created`, `updated`) VALUES (?, ?, ?, ?, ?, "
  if L6_2 then
    L12_2 = "?"
    if L12_2 then
      goto lbl_59
    end
  end
  L12_2 = "NULL"
  ::lbl_59::
  L13_2 = ", 'held', NULL, ?, ?)"
  L11_2 = L11_2 .. L12_2 .. L13_2
  L12_2 = L8_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  if L9_2 then
    L11_2 = tonumber
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      goto lbl_71
    end
  end
  L11_2 = nil
  ::lbl_71::
  if not L11_2 then
    L12_2 = nil
    L13_2 = L10_2
    return L12_2, L13_2
  end
  L12_2 = math
  L12_2 = L12_2.tointeger
  L13_2 = L11_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = L11_2
  end
  return L12_2
end
L22_1 = ItemEscrow
function L23_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2
  L6_2 = L1_1
  L6_2 = L6_2[A1_2]
  if not L6_2 then
    L6_2 = nil
    L7_2 = "invalid"
    return L6_2, L7_2
  end
  L6_2 = L7_1
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = 0
  end
  L8_2 = 0
  L9_2 = 2147483647
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  A2_2 = L6_2
  L6_2 = L7_1
  L7_2 = A4_2 or L7_2
  if not A4_2 then
    L7_2 = 1
  end
  L8_2 = 1
  L9_2 = 10000
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  A4_2 = L6_2
  L6_2 = L8_1
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  A3_2 = L6_2
  if not (A2_2 and A4_2) or not A3_2 then
    L6_2 = nil
    L7_2 = "invalid"
    return L6_2, L7_2
  end
  L6_2 = ItemEscrow
  L6_2 = L6_2.waitReady
  L6_2 = L6_2()
  if not L6_2 then
    L6_2 = nil
    L7_2 = "escrow"
    return L6_2, L7_2
  end
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L7_2 = nil
    L8_2 = "noplayer"
    return L7_2, L8_2
  end
  L7_2 = L19_1
  L8_2 = A0_2
  L9_2 = A3_2
  L10_2 = A4_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L9_2 = nil
    L10_2 = L8_2
    return L9_2, L10_2
  end
  L9_2 = #L7_2
  if 1 == L9_2 then
    L9_2 = L7_2[1]
    L9_2 = L9_2.meta
    if nil == L9_2 then
      L9_2 = type
      L10_2 = A5_2
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = L7_2[1]
        L10_2 = L16_1
        L11_2 = A5_2
        L10_2 = L10_2(L11_2)
        L9_2.meta = L10_2
      end
    end
  end
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L7_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L21_1
    L17_2 = A1_2
    L18_2 = A2_2
    L19_2 = L6_2
    L20_2 = A3_2
    L21_2 = L15_2.count
    L22_2 = L15_2.meta
    L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
    if not L16_2 then
      L18_2 = L14_2
      L19_2 = #L7_2
      L20_2 = 1
      for L21_2 = L18_2, L19_2, L20_2 do
        L22_2 = pcall
        L23_2 = FW
        L23_2 = L23_2.AddItem
        L24_2 = A0_2
        L25_2 = A3_2
        L26_2 = L7_2[L21_2]
        L26_2 = L26_2.count
        L27_2 = L7_2[L21_2]
        L27_2 = L27_2.meta
        L22_2(L23_2, L24_2, L25_2, L26_2, L27_2)
      end
      L18_2 = ipairs
      L19_2 = L9_2
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L24_2 = ItemEscrow
        L24_2 = L24_2.returnToOwner
        L25_2 = L23_2
        L26_2 = {}
        L26_2.silent = true
        L24_2(L25_2, L26_2)
      end
      L18_2 = print
      L19_2 = "^1[unique_phone]^0 escrow: %dx %s left the inventory of %s but the row was not saved (%s); returned"
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = A4_2
      L22_2 = A3_2
      L23_2 = tostring
      L24_2 = L6_2
      L23_2 = L23_2(L24_2)
      L24_2 = tostring
      L25_2 = L17_2
      L24_2, L25_2, L26_2, L27_2 = L24_2(L25_2)
      L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
      L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
      L18_2 = nil
      L19_2 = "escrow"
      return L18_2, L19_2
    end
    L18_2 = #L9_2
    L18_2 = L18_2 + 1
    L9_2[L18_2] = L16_2
    L18_2 = Dbg
    L19_2 = "escrow"
    L20_2 = "hold #%d %s ref=%d owner=%s %dx%s%s"
    L21_2 = L16_2
    L22_2 = A1_2
    L23_2 = A2_2
    L24_2 = L6_2
    L25_2 = L15_2.count
    L26_2 = A3_2
    L27_2 = L15_2.meta
    if L27_2 then
      L27_2 = " (with metadata)"
      if L27_2 then
        goto lbl_161
      end
    end
    L27_2 = ""
    ::lbl_161::
    L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
  end
  L10_2 = L9_2[1]
  L11_2 = nil
  L12_2 = L9_2
  return L10_2, L11_2, L12_2
end
L22_1.hold = L23_1
L22_1 = ItemEscrow
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = A0_2 or L2_2
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    L3_2 = A0_2
    L2_2[1] = L3_2
  end
  L3_2 = #L2_2
  L3_2 = L3_2 > 0
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = MySQL
    L10_2 = L10_2.update
    L10_2 = L10_2.await
    L11_2 = "UPDATE apex_phone_item_escrow SET ref_id = ?, updated = ? WHERE id = ? AND ref_id = 0 AND status = ?"
    L12_2 = {}
    L13_2 = A1_2
    L14_2 = Now
    L14_2 = L14_2()
    L15_2 = L9_2
    L16_2 = "held"
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L12_2[3] = L15_2
    L12_2[4] = L16_2
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = tonumber
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = 0
    end
    if 1 ~= L11_2 then
      L3_2 = false
    end
  end
  return L3_2
end
L22_1.link = L23_1
L22_1 = ItemEscrow
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L3_2 = L7_1
  L4_2 = A2_2
  L5_2 = 1
  L6_2 = 10000
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A2_2 = L3_2
  L3_2 = L7_1
  L4_2 = A1_2
  L5_2 = 1
  L6_2 = 2147483647
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A1_2 = L3_2
  if not A2_2 or not A1_2 then
    L3_2 = nil
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = L11_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.status
    if "held" == L4_2 then
      goto lbl_31
    end
  end
  L4_2 = nil
  L5_2 = "escrow"
  do return L4_2, L5_2 end
  ::lbl_31::
  L4_2 = L3_2.owner
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if L4_2 ~= L5_2 then
    L4_2 = nil
    L5_2 = "forbidden"
    return L4_2, L5_2
  end
  L4_2 = L3_2.count
  L4_2 = L4_2 + A2_2
  L5_2 = 10000
  if L4_2 > L5_2 then
    L4_2 = nil
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = L19_1
  L5_2 = A0_2
  L6_2 = L3_2.item
  L7_2 = A2_2
  L8_2 = L12_1
  L9_2 = L3_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = {}
  end
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if not L4_2 then
    L6_2 = nil
    L7_2 = L5_2
    return L6_2, L7_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_item_escrow SET `count` = `count` + ?, updated = ? WHERE id = ? AND status = ?"
  L8_2 = {}
  L9_2 = A2_2
  L10_2 = Now
  L10_2 = L10_2()
  L11_2 = A1_2
  L12_2 = "held"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = tonumber
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  if 1 ~= L7_2 then
    L7_2 = ipairs
    L8_2 = L4_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = pcall
      L14_2 = FW
      L14_2 = L14_2.AddItem
      L15_2 = A0_2
      L16_2 = L3_2.item
      L17_2 = L12_2.count
      L18_2 = L12_2.meta
      L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
    end
    L7_2 = nil
    L8_2 = "escrow"
    return L7_2, L8_2
  end
  L7_2 = Dbg
  L8_2 = "escrow"
  L9_2 = "addUnits #%d +%d (%s)"
  L10_2 = A1_2
  L11_2 = A2_2
  L12_2 = L3_2.item
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = true
  return L7_2
end
L22_1.addUnits = L23_1
L22_1 = ItemEscrow
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L3_2 = L7_1
  L4_2 = A0_2
  L5_2 = 1
  L6_2 = 2147483647
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L3_2 = L7_1
  L4_2 = A1_2
  L5_2 = 1
  L6_2 = 10000
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A1_2 = L3_2
  if not A0_2 or not A1_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L11_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.status
    if "held" == L4_2 then
      L4_2 = L3_2.count
      if not (A1_2 > L4_2) then
        goto lbl_32
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_32::
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_item_escrow SET `count` = `count` - ?, updated = ? WHERE id = ? AND status = ? AND `count` >= ?"
  L7_2 = {}
  L8_2 = A1_2
  L9_2 = L4_2
  L10_2 = A0_2
  L11_2 = "held"
  L12_2 = A1_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 1 ~= L6_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = type
  L7_2 = A2_2
  L6_2 = L6_2(L7_2)
  if "table" ~= L6_2 or not A2_2 then
    L6_2 = {}
    A2_2 = L6_2
  end
  L6_2 = L7_1
  L7_2 = A2_2.ref_id
  L8_2 = 0
  L9_2 = 2147483647
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = L3_2.ref_id
  end
  L7_2 = A2_2.target
  if nil ~= L7_2 then
    L7_2 = tostring
    L8_2 = A2_2.target
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_84
    end
  end
  L7_2 = L3_2.target
  ::lbl_84::
  L8_2 = {}
  L9_2 = L3_2.source
  L10_2 = L6_2
  L11_2 = L3_2.owner
  L12_2 = L3_2.item
  L13_2 = A1_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L9_2 = L3_2.meta
  if L9_2 then
    L9_2 = #L8_2
    L9_2 = L9_2 + 1
    L10_2 = L3_2.meta
    L8_2[L9_2] = L10_2
  end
  if L7_2 then
    L9_2 = #L8_2
    L9_2 = L9_2 + 1
    L8_2[L9_2] = L7_2
  end
  L9_2 = #L8_2
  L9_2 = L9_2 + 1
  L8_2[L9_2] = L4_2
  L9_2 = #L8_2
  L9_2 = L9_2 + 1
  L8_2[L9_2] = L4_2
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.insert
  L10_2 = L10_2.await
  L11_2 = "INSERT INTO apex_phone_item_escrow (`source`, `ref_id`, `owner`, `item`, `count`, `meta`, `status`, `target`, `created`, `updated`) VALUES (?, ?, ?, ?, ?, "
  L12_2 = L3_2.meta
  if L12_2 then
    L12_2 = "?"
    if L12_2 then
      goto lbl_126
    end
  end
  L12_2 = "NULL"
  ::lbl_126::
  L13_2 = ", 'held', "
  if L7_2 then
    L14_2 = "?"
    if L14_2 then
      goto lbl_133
    end
  end
  L14_2 = "NULL"
  ::lbl_133::
  L15_2 = ", ?, ?)"
  L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2 .. L15_2
  L12_2 = L8_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  if L9_2 then
    L11_2 = tonumber
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      goto lbl_145
    end
  end
  L11_2 = nil
  ::lbl_145::
  if not L11_2 then
    L12_2 = MySQL
    L12_2 = L12_2.update
    L12_2 = L12_2.await
    L13_2 = "UPDATE apex_phone_item_escrow SET `count` = `count` + ?, updated = ? WHERE id = ? AND status = ?"
    L14_2 = {}
    L15_2 = A1_2
    L16_2 = Now
    L16_2 = L16_2()
    L17_2 = A0_2
    L18_2 = "held"
    L14_2[1] = L15_2
    L14_2[2] = L16_2
    L14_2[3] = L17_2
    L14_2[4] = L18_2
    L12_2 = L12_2(L13_2, L14_2)
    L13_2 = print
    L14_2 = "^1[unique_phone]^0 escrow: split of #%d failed (%s); units restored: %s"
    L15_2 = L14_2
    L14_2 = L14_2.format
    L16_2 = A0_2
    L17_2 = tostring
    L18_2 = L10_2
    L17_2 = L17_2(L18_2)
    L18_2 = tostring
    L19_2 = tonumber
    L20_2 = L12_2
    L19_2 = L19_2(L20_2)
    if not L19_2 then
      L19_2 = 0
    end
    L19_2 = 1 == L19_2
    L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L13_2 = nil
    return L13_2
  end
  L12_2 = Dbg
  L13_2 = "escrow"
  L14_2 = "split #%d -> #%d (%dx%s ref=%d target=%s)"
  L15_2 = A0_2
  L16_2 = L11_2
  L17_2 = A1_2
  L18_2 = L3_2.item
  L19_2 = L6_2
  L20_2 = tostring
  L21_2 = L7_2
  L20_2, L21_2 = L20_2(L21_2)
  L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  return L11_2
end
L22_1.split = L23_1
function L22_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L4_2 = type
  L5_2 = A3_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 or not A3_2 then
    L4_2 = {}
    A3_2 = L4_2
  end
  L4_2 = L7_1
  L5_2 = A0_2
  L6_2 = 1
  L7_2 = 2147483647
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  A0_2 = L4_2
  if not A0_2 then
    L4_2 = nil
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = ItemEscrow
  L4_2 = L4_2.waitReady
  L4_2 = L4_2()
  if not L4_2 then
    L4_2 = nil
    L5_2 = "escrow"
    return L4_2, L5_2
  end
  L4_2 = L11_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = "notfound"
    return L5_2, L6_2
  end
  L5_2 = L4_2.status
  if "held" ~= L5_2 then
    L5_2 = nil
    L6_2 = "state"
    return L5_2, L6_2
  end
  L5_2 = "give" == A1_2
  if L5_2 then
    L6_2 = tostring
    L7_2 = A2_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      goto lbl_56
    end
  end
  L6_2 = L4_2.owner
  ::lbl_56::
  if not L6_2 or "" == L6_2 then
    L7_2 = nil
    L8_2 = "invalid"
    return L7_2, L8_2
  end
  if L5_2 then
    L7_2 = "given"
    if L7_2 then
      goto lbl_69
    end
  end
  L7_2 = "returned"
  ::lbl_69::
  if L5_2 then
    L8_2 = "pending_give"
    if L8_2 then
      goto lbl_75
    end
  end
  L8_2 = "pending_return"
  ::lbl_75::
  L9_2 = Now
  L9_2 = L9_2()
  function L10_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = {}
    L2_3 = A0_3
    L3_3 = L9_2
    L1_3[1] = L2_3
    L1_3[2] = L3_3
    L2_3 = L5_2
    if L2_3 then
      L2_3 = #L1_3
      L2_3 = L2_3 + 1
      L3_3 = L6_2
      L1_3[L2_3] = L3_3
    end
    L2_3 = #L1_3
    L2_3 = L2_3 + 1
    L3_3 = A0_2
    L1_3[L2_3] = L3_3
    L2_3 = #L1_3
    L2_3 = L2_3 + 1
    L1_3[L2_3] = "held"
    L2_3 = #L1_3
    L2_3 = L2_3 + 1
    L3_3 = L4_2.count
    L1_3[L2_3] = L3_3
    L2_3 = MySQL
    L2_3 = L2_3.update
    L2_3 = L2_3.await
    L3_3 = "UPDATE apex_phone_item_escrow SET status = ?, updated = ?"
    L4_3 = L5_2
    if L4_3 then
      L4_3 = ", target = ?"
      if L4_3 then
        goto lbl_39
      end
    end
    L4_3 = ""
    ::lbl_39::
    L5_3 = " WHERE id = ? AND status = ? AND `count` = ?"
    L3_3 = L3_3 .. L4_3 .. L5_3
    L4_3 = L1_3
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = tonumber
    L4_3 = L2_3
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = 0
    end
    L3_3 = 1 == L3_3
    return L3_3
  end
  L11_2 = L4_2.count
  if L11_2 <= 0 then
    L11_2 = L10_2
    L12_2 = L7_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = nil
      L12_2 = "state"
      return L11_2, L12_2
    end
    return L7_2
  end
  L11_2 = FW
  L11_2 = L11_2.GetPlayerByCid
  L12_2 = L6_2
  L11_2 = L11_2(L12_2)
  L12_2 = L11_2
  if L11_2 then
    L12_2 = tonumber
    L13_2 = L11_2.src
    L12_2 = L12_2(L13_2)
  end
  if L12_2 then
    L13_2 = L10_2
    L14_2 = L7_2
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = nil
      L14_2 = "state"
      return L13_2, L14_2
    end
    L13_2 = L20_1
    L14_2 = L12_2
    L15_2 = L4_2
    L13_2 = L13_2(L14_2, L15_2)
    if L13_2 then
      L13_2 = Dbg
      L14_2 = "escrow"
      L15_2 = "#%d %s: %s -> %s (%s)"
      L16_2 = A0_2
      L17_2 = L7_2
      L18_2 = L4_2.owner
      L19_2 = L6_2
      L20_2 = L13_1
      L21_2 = L4_2
      L20_2, L21_2 = L20_2(L21_2)
      L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
      return L7_2
    end
    L13_2 = MySQL
    L13_2 = L13_2.update
    L13_2 = L13_2.await
    L14_2 = "UPDATE apex_phone_item_escrow SET status = ?, updated = ? WHERE id = ? AND status = ?"
    L15_2 = {}
    L16_2 = L8_2
    L17_2 = Now
    L17_2 = L17_2()
    L18_2 = A0_2
    L19_2 = L7_2
    L15_2[1] = L16_2
    L15_2[2] = L17_2
    L15_2[3] = L18_2
    L15_2[4] = L19_2
    L13_2(L14_2, L15_2)
    L13_2 = Dbg
    L14_2 = "escrow"
    L15_2 = "#%d %s: inventory of %s refused %s"
    L16_2 = A0_2
    L17_2 = L8_2
    L18_2 = L6_2
    L19_2 = L13_1
    L20_2 = L4_2
    L19_2, L20_2, L21_2 = L19_2(L20_2)
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L13_2 = A3_2.silent
    if not L13_2 then
      L13_2 = L14_1
      L14_2 = L6_2
      L15_2 = L4_2
      L16_2 = "Invent\195\161rio cheio"
      L17_2 = L13_1
      L18_2 = L4_2
      L17_2 = L17_2(L18_2)
      L18_2 = " vai para o teu invent\195\161rio quando houver espa\195\167o."
      L17_2 = L17_2 .. L18_2
      L13_2(L14_2, L15_2, L16_2, L17_2)
    end
    L13_2 = "pending"
    L14_2 = "invfull"
    return L13_2, L14_2
  end
  L13_2 = L10_2
  L14_2 = L8_2
  L13_2 = L13_2(L14_2)
  if not L13_2 then
    L13_2 = nil
    L14_2 = "state"
    return L13_2, L14_2
  end
  L13_2 = Dbg
  L14_2 = "escrow"
  L15_2 = "#%d %s: %s offline (%s)"
  L16_2 = A0_2
  L17_2 = L8_2
  L18_2 = L6_2
  L19_2 = L13_1
  L20_2 = L4_2
  L19_2, L20_2, L21_2 = L19_2(L20_2)
  L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L13_2 = A3_2.silent
  if not L13_2 then
    L13_2 = L14_1
    L14_2 = L6_2
    L15_2 = L4_2
    if L5_2 then
      L16_2 = "Item \195\160 tua espera"
      if L16_2 then
        goto lbl_196
      end
    end
    L16_2 = "Item devolvido"
    ::lbl_196::
    L17_2 = L13_1
    L18_2 = L4_2
    L17_2 = L17_2(L18_2)
    L18_2 = " vai para o teu invent\195\161rio quando entrares."
    L17_2 = L17_2 .. L18_2
    L13_2(L14_2, L15_2, L16_2, L17_2)
  end
  L13_2 = "pending"
  L14_2 = "offline"
  return L13_2, L14_2
end
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  if nil == A1_2 or "" == A1_2 then
    L3_2 = nil
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = L22_1
  L4_2 = A0_2
  L5_2 = "give"
  L6_2 = A1_2
  L7_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L23_1.giveTo = L24_1
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L22_1
  L3_2 = A0_2
  L4_2 = "return"
  L5_2 = nil
  L6_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
L23_1.returnToOwner = L24_1
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_item_escrow WHERE `source` = ? AND ref_id = ? AND status = ? AND target IS NULL AND `count` > 0 ORDER BY id ASC"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = "held"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L10_1
    L10_2 = L8_2
    L9_2(L10_2)
  end
  return L2_2
end
L23_1.heldRows = L24_1
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L10_1
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_item_escrow WHERE `source` = ? AND ref_id = ?"
  if A2_2 then
    L6_2 = " AND target IS NULL"
    if L6_2 then
      goto lbl_12
    end
  end
  L6_2 = ""
  ::lbl_12::
  L7_2 = " ORDER BY id DESC LIMIT 1"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2, L6_2)
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L23_1.lastRow = L24_1
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if not A2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L10_1
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_item_escrow WHERE `source` = ? AND ref_id = ? AND target = ? AND status = ? ORDER BY id ASC LIMIT 1"
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = tostring
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  L10_2 = "held"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2, L6_2)
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L23_1.unitFor = L24_1
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = ipairs
  L5_2 = ItemEscrow
  L5_2 = L5_2.heldRows
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L5_2(L6_2, L7_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = ItemEscrow
    L10_2 = L10_2.split
    L11_2 = L9_2.id
    L12_2 = 1
    L13_2 = {}
    L13_2.ref_id = A2_2
    L13_2.target = A3_2
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    if L10_2 then
      L11_2 = {}
      L11_2.id = L10_2
      L12_2 = L9_2.item
      L11_2.item = L12_2
      L11_2.count = 1
      return L11_2
    end
  end
  L4_2 = nil
  return L4_2
end
L23_1.reserve = L24_1
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE apex_phone_item_escrow SET ref_id = ?, target = NULL, updated = ? WHERE id = ? AND status = ? AND target = ?"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = A0_2
  L9_2 = "held"
  L10_2 = tostring
  L11_2 = A2_2
  L10_2, L11_2 = L10_2(L11_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = tonumber
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L4_2 = 1 == L4_2
  if L4_2 then
    L5_2 = Dbg
    L6_2 = "escrow"
    L7_2 = "restock #%d -> listing %s"
    L8_2 = A0_2
    L9_2 = tostring
    L10_2 = A1_2
    L9_2, L10_2, L11_2 = L9_2(L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  end
  return L4_2
end
L23_1.restock = L24_1
L23_1 = ItemEscrow
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = {}
  L3_2.count = 0
  L4_2 = A0_2 or L4_2
  if not A0_2 then
    L4_2 = {}
  end
  L4_2 = #L4_2
  L5_2 = 1
  L6_2 = -1
  for L7_2 = L4_2, L5_2, L6_2 do
    if A1_2 and A1_2 <= 0 then
      break
    end
    L8_2 = A0_2[L7_2]
    if A1_2 then
      L9_2 = math
      L9_2 = L9_2.min
      L10_2 = A1_2
      L11_2 = L8_2.count
      L9_2 = L9_2(L10_2, L11_2)
      if L9_2 then
        goto lbl_27
      end
    end
    L9_2 = L8_2.count
    ::lbl_27::
    L10_2 = L8_2.id
    if L9_2 > 0 then
      L11_2 = L8_2.count
      if L9_2 < L11_2 then
        L11_2 = ItemEscrow
        L11_2 = L11_2.split
        L12_2 = L8_2.id
        L13_2 = L9_2
        L11_2 = L11_2(L12_2, L13_2)
        L10_2 = L11_2
      end
    end
    if L10_2 and L9_2 > 0 then
      L11_2 = ItemEscrow
      L11_2 = L11_2.returnToOwner
      L12_2 = L10_2
      L13_2 = A2_2
      L11_2, L12_2 = L11_2(L12_2, L13_2)
      if L11_2 then
        L13_2 = L3_2.count
        L13_2 = L13_2 + L9_2
        L3_2.count = L13_2
        L13_2 = L3_2.name
        if not L13_2 then
          L13_2 = L8_2.item
        end
        L3_2.name = L13_2
        if "pending" == L11_2 then
          L13_2 = "pending"
          L3_2.reason = L12_2
          L3_2.status = L13_2
        else
          L13_2 = L3_2.status
          if not L13_2 then
            L3_2.status = "returned"
          end
        end
        if A1_2 then
          A1_2 = A1_2 - L9_2
        end
      end
    end
  end
  L4_2 = L3_2.count
  if 0 == L4_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = ItemEscrow
  L4_2 = L4_2.label
  L5_2 = L3_2.name
  L4_2 = L4_2(L5_2)
  L3_2.label = L4_2
  return L3_2
end
L23_1.returnRows = L24_1
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = A0_2.status
  if "pending_give" ~= L2_2 then
    L2_2 = A0_2.status
    if "pending_return" ~= L2_2 then
      L2_2 = nil
      return L2_2
    end
  end
  L2_2 = A0_2.status
  if "pending_give" == L2_2 then
    L3_2 = "given"
    if L3_2 then
      goto lbl_16
    end
  end
  L3_2 = "returned"
  ::lbl_16::
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE apex_phone_item_escrow SET status = ?, updated = ? WHERE id = ? AND status = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = Now
  L8_2 = L8_2()
  L9_2 = A0_2.id
  L10_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = tonumber
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  if 1 ~= L5_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L20_1
  L6_2 = A1_2
  L7_2 = A0_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L5_2 = Dbg
    L6_2 = "escrow"
    L7_2 = "#%d delivered on join/retry (%s -> %s, %s)"
    L8_2 = A0_2.id
    L9_2 = L2_2
    L10_2 = L3_2
    L11_2 = L13_1
    L12_2 = A0_2
    L11_2, L12_2 = L11_2(L12_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    L5_2 = true
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_item_escrow SET status = ?, updated = ? WHERE id = ? AND status = ?"
  L7_2 = {}
  L8_2 = L2_2
  L9_2 = Now
  L9_2 = L9_2()
  L10_2 = A0_2.id
  L11_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2(L6_2, L7_2)
  L5_2 = false
  return L5_2
end
L24_1 = ItemEscrow
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = A0_2 or L2_2
  if A0_2 then
    L2_2 = GetCid
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  if L2_2 then
    L3_2 = ItemEscrow
    L3_2 = L3_2.ready
    if L3_2 then
      L3_2 = L5_1
      L3_2 = L3_2[L2_2]
      if not L3_2 then
        goto lbl_33
      end
    end
  end
  L3_2 = 0
  L4_2 = 0
  do return L3_2, L4_2 end
  ::lbl_33::
  L3_2 = L5_1
  L3_2[L2_2] = true
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT * FROM apex_phone_item_escrow WHERE (target = ? AND status = ?) OR (owner = ? AND status = ?) ORDER BY id ASC LIMIT 100"
    L2_3 = {}
    L3_3 = L2_2
    L4_3 = "pending_give"
    L5_3 = L2_2
    L6_3 = "pending_return"
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L0_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = 0
    L2_3 = 0
    L3_3 = {}
    L4_3 = nil
    L5_3 = ipairs
    L6_3 = L0_3
    L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
    for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
      L11_3 = L10_1
      L12_3 = L10_3
      L11_3(L12_3)
      local jf43 = false
      L11_3 = L10_3.status
      if "pending_give" == L11_3 then
        L11_3 = L10_3.target
        L12_3 = L2_2
        if L11_3 == L12_3 then
          jf43 = true
        end
      end
      if not jf43 then
        L11_3 = L10_3.status
        if "pending_return" == L11_3 then
          L11_3 = L10_3.owner
          L12_3 = L2_2
          if L11_3 == L12_3 then
            jf43 = true
          end
        end
      end
      if jf43 then
        if true then
          L11_3 = L23_1
          L12_3 = L10_3
          L13_3 = A0_2
          L11_3 = L11_3(L12_3, L13_3)
          L13_3 = L10_3.source
          L12_3 = L1_1
          L12_3 = L12_3[L13_3]
          if not L12_3 then
            L12_3 = "marketplace"
          end
          if true == L11_3 then
            L1_3 = L1_3 + 1
            L13_3 = L3_3[L12_3]
            if not L13_3 then
              L13_3 = {}
              L13_3.n = 0
            end
            L3_3[L12_3] = L13_3
            L13_3 = L3_3[L12_3]
            L14_3 = L13_3.n
            L14_3 = L14_3 + 1
            L13_3.n = L14_3
            L14_3 = #L13_3
            if L14_3 < 3 then
              L14_3 = #L13_3
              L14_3 = L14_3 + 1
              L15_3 = L13_1
              L16_3 = L10_3
              L15_3 = L15_3(L16_3)
              L13_3[L14_3] = L15_3
            end
          elseif false == L11_3 then
            L2_3 = L2_3 + 1
            if not L4_3 then
              L4_3 = L12_3
            end
          end
        end
      end
    end
    L5_3 = L1_3
    L6_3 = L2_3
    L7_3 = L3_3
    L8_3 = L4_3
    return L5_3, L6_3, L7_3, L8_3
  end
  L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2)
  L8_2 = L5_1
  L8_2[L2_2] = nil
  if not L3_2 then
    L8_2 = print
    L9_2 = "^1[unique_phone]^0 escrow: delivery of pending items to %s: %s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = tostring
    L12_2 = L2_2
    L11_2 = L11_2(L12_2)
    L12_2 = tostring
    L13_2 = L4_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L12_2(L13_2)
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L8_2 = 0
    L9_2 = 0
    return L8_2, L9_2
  end
  L8_2 = pairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = table
    L14_2 = L14_2.concat
    L15_2 = L13_2
    L16_2 = ", "
    L14_2 = L14_2(L15_2, L16_2)
    L15_2 = NotifyPlayer
    L16_2 = A0_2
    L17_2 = L12_2
    L18_2 = "Itens entregues"
    L19_2 = L13_2.n
    L20_2 = #L13_2
    if L19_2 > L20_2 then
      L19_2 = "Recebeste %s e mais %s no invent\195\161rio."
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = L14_2
      L22_2 = L13_2.n
      L23_2 = #L13_2
      L22_2 = L22_2 - L23_2
      L19_2 = L19_2(L20_2, L21_2, L22_2)
      if L19_2 then
        goto lbl_87
      end
    end
    L19_2 = "Recebeste %s no invent\195\161rio."
    L20_2 = L19_2
    L19_2 = L19_2.format
    L21_2 = L14_2
    L19_2 = L19_2(L20_2, L21_2)
    ::lbl_87::
    L15_2(L16_2, L17_2, L18_2, L19_2)
  end
  if L5_2 > 0 then
    L8_2 = A1_2.login
    if L8_2 then
      L8_2 = NotifyPlayer
      L9_2 = A0_2
      L10_2 = L7_2 or L10_2
      if not L7_2 then
        L10_2 = "marketplace"
      end
      L11_2 = "Itens \195\160 espera"
      L12_2 = "%d entrega(s) \195\160 espera de espa\195\167o no invent\195\161rio."
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = L5_2
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L12_2(L13_2, L14_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    end
  end
  if L4_2 > 0 or L5_2 > 0 then
    L8_2 = Dbg
    L9_2 = "escrow"
    L10_2 = "pending of %s: %d delivered, %d left to deliver"
    L11_2 = L2_2
    L12_2 = L4_2
    L13_2 = L5_2
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  end
  L8_2 = L4_2
  L9_2 = L5_2
  return L8_2, L9_2
end
L24_1.deliverPending = L25_1
L24_1 = ItemEscrow
function L25_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "function" == L1_2 then
    L1_2 = L4_1
    L1_2 = #L1_2
    L2_2 = L1_2 + 1
    L1_2 = L4_1
    L1_2[L2_2] = A0_2
  end
end
L24_1.onSweep = L25_1
L24_1 = FW
L24_1 = L24_1.OnPlayerLoaded
function L25_1(A0_2)
  local L1_2, L2_2
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = Wait
    L1_3 = 8000
    L0_3(L1_3)
    L0_3 = GetPlayerName
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    if L0_3 then
      L0_3 = ItemEscrow
      L0_3 = L0_3.deliverPending
      L1_3 = A0_2
      L2_3 = {}
      L2_3.login = true
      L0_3(L1_3, L2_3)
    end
  end
  L1_2(L2_2)
end
L24_1(L25_1)
L24_1 = CreateThread
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  while true do
    L0_2 = ItemEscrow
    L0_2 = L0_2.ready
    if L0_2 then
      L0_2 = DBReady
      if L0_2 then
        break
      end
    end
    L0_2 = Wait
    L1_2 = 2000
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 30000
  L0_2(L1_2)
  L0_2 = 0
  while true do
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "SELECT DISTINCT target AS cid FROM apex_phone_item_escrow WHERE status = 'pending_give' UNION SELECT DISTINCT owner AS cid FROM apex_phone_item_escrow WHERE status = 'pending_return' LIMIT 500"
      L0_3 = L0_3(L1_3)
      if not L0_3 then
        L0_3 = {}
      end
      L1_3 = ipairs
      L2_3 = L0_3
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
      for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
        L7_3 = L6_3.cid
        if L7_3 then
          L7_3 = FW
          L7_3 = L7_3.GetPlayerByCid
          L8_3 = L6_3.cid
          L7_3 = L7_3(L8_3)
        end
        if L7_3 then
          L8_3 = L7_3.src
          if L8_3 then
            L8_3 = ItemEscrow
            L8_3 = L8_3.deliverPending
            L9_3 = L7_3.src
            L8_3(L9_3)
          end
        end
      end
    end
    L1_2, L2_2 = L1_2(L2_2)
    if not L1_2 then
      L3_2 = print
      L4_2 = "^1[unique_phone]^0 escrow: pending cycle: %s"
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = tostring
      L7_2 = L2_2
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L6_2(L7_2)
      L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    end
    L3_2 = L0_2 % 5
    if 0 == L3_2 then
      L3_2 = Now
      L3_2 = L3_2()
      L3_2 = L3_2 - 300000
      L4_2 = ipairs
      L5_2 = L4_1
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = pcall
        L11_2 = L9_2
        L12_2 = L3_2
        L10_2, L11_2 = L10_2(L11_2, L12_2)
        if not L10_2 then
          L12_2 = print
          L13_2 = "^1[unique_phone]^0 escrow: cleanup: %s"
          L14_2 = L13_2
          L13_2 = L13_2.format
          L15_2 = tostring
          L16_2 = L11_2
          L15_2, L16_2 = L15_2(L16_2)
          L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2, L15_2, L16_2)
          L12_2(L13_2, L14_2, L15_2, L16_2)
        end
      end
    end
    L0_2 = L0_2 + 1
    L3_2 = Wait
    L4_2 = 60000
    L3_2(L4_2)
  end
end
L24_1(L25_1)
L24_1 = RPC
function L25_1()
  local L0_2, L1_2, L2_2
  L0_2 = {}
  L1_2 = ItemEscrow
  L1_2 = L1_2.enabled
  L2_2 = "market"
  L1_2 = L1_2(L2_2)
  L0_2.market = L1_2
  L1_2 = ItemEscrow
  L1_2 = L1_2.enabled
  L2_2 = "onion"
  L1_2 = L1_2(L2_2)
  L0_2.onion = L1_2
  return L0_2
end
L24_1["escrow.config"] = L25_1
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = A0_2 or nil
  if A0_2 then
    L2_2 = A0_2.client
    if L2_2 then
      L2_2 = A0_2.client
      L2_2 = L2_2.image
    end
  end
  if L2_2 and "" ~= L2_2 then
    L4_2 = L2_2
    L3_2 = L2_2.match
    L5_2 = "^%w+://"
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      return L2_2
    end
    L3_2 = "nui://ox_inventory/web/images/"
    L4_2 = L2_2
    L3_2 = L3_2 .. L4_2
    return L3_2
  end
  L3_2 = "nui://ox_inventory/web/images/"
  L4_2 = tostring
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  L5_2 = ".png"
  L3_2 = L3_2 .. L4_2 .. L5_2
  return L3_2
end
L25_1 = RPC
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = GetResourceState
  L2_2 = "ox_inventory"
  L1_2 = L1_2(L2_2)
  if "started" ~= L1_2 then
    L1_2 = {}
    L1_2.error = "noinv"
    return L1_2
  end
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = exports
    L0_3 = L0_3.ox_inventory
    L1_3 = L0_3
    L0_3 = L0_3.GetInventoryItems
    L2_3 = A0_2
    return L0_3(L1_3, L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_23
    end
  end
  L3_2 = {}
  do return L3_2 end
  ::lbl_23::
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3
    L0_3 = exports
    L0_3 = L0_3.ox_inventory
    L1_3 = L0_3
    L0_3 = L0_3.Items
    return L0_3(L1_3)
  end
  L3_2, L4_2 = L3_2(L4_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      goto lbl_36
    end
  end
  L5_2 = {}
  L4_2 = L5_2
  ::lbl_36::
  L5_2 = {}
  L6_2 = pairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = L11_2.name
      if L12_2 then
        L12_2 = L11_2.name
        L12_2 = L5_2[L12_2]
        if L12_2 then
          L13_2 = L12_2.count
          L14_2 = tonumber
          L15_2 = L11_2.count
          L14_2 = L14_2(L15_2)
          if not L14_2 then
            L14_2 = 1
          end
          L13_2 = L13_2 + L14_2
          L12_2.count = L13_2
        else
          L13_2 = L11_2.name
          L13_2 = L4_2[L13_2]
          L14_2 = L11_2.name
          L15_2 = {}
          L16_2 = L11_2.name
          L15_2.name = L16_2
          if L13_2 then
            L16_2 = L13_2.label
            if L16_2 then
              goto lbl_81
            end
          end
          L16_2 = L11_2.label
          if not L16_2 then
            L16_2 = L11_2.name
          end
          ::lbl_81::
          L15_2.label = L16_2
          L16_2 = tonumber
          L17_2 = L11_2.count
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = 1
          end
          L15_2.count = L16_2
          L16_2 = L24_1
          L17_2 = L13_2
          L18_2 = L11_2.name
          L16_2 = L16_2(L17_2, L18_2)
          L15_2.image = L16_2
          L5_2[L14_2] = L15_2
        end
      end
    end
  end
  L6_2 = {}
  L7_2 = pairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L6_2[L13_2] = L12_2
  end
  L7_2 = table
  L7_2 = L7_2.sort
  L8_2 = L6_2
  function L9_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = tostring
    L3_3 = A0_3.label
    L2_3 = L2_3(L3_3)
    L3_3 = L2_3
    L2_3 = L2_3.lower
    L2_3 = L2_3(L3_3)
    L3_3 = tostring
    L4_3 = A1_3.label
    L3_3 = L3_3(L4_3)
    L4_3 = L3_3
    L3_3 = L3_3.lower
    L3_3 = L3_3(L4_3)
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L7_2(L8_2, L9_2)
  return L6_2
end
L25_1["inventory.items"] = L26_1
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = FW
  L3_2 = L3_2.GetPlayerByCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.AddMoney
    L5_2 = "bank"
    L6_2 = A1_2
    L7_2 = A2_2 or L7_2
    if not A2_2 then
      L7_2 = "Unique_Phone market"
    end
    return L4_2(L5_2, L6_2, L7_2)
  end
  L4_2 = FW
  L4_2 = L4_2.AddMoneyOffline
  L5_2 = A0_2
  L6_2 = "bank"
  L7_2 = A1_2
  return L4_2(L5_2, L6_2, L7_2)
end
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Marketplace
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Marketplace
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = math
  L1_2 = L1_2.min
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = tonumber
  L4_2 = L0_2.maxPrice
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 100000000
  end
  L2_2 = L2_2(L3_2)
  L3_2 = 2147483647
  return L1_2(L2_2, L3_2)
end
function L27_1(A0_2)
  local L1_2, L2_2, L3_2
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
  L2_2 = L2_2.floor
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L1_2 = L2_2
  if not (L1_2 <= 0) then
    L2_2 = L26_1
    L2_2 = L2_2()
    if not (L1_2 > L2_2) then
      goto lbl_32
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_32::
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = L1_2
  end
  return L2_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if nil == A0_2 or "" == A0_2 or false == A0_2 then
    L1_2 = 1
    return L1_2
  end
  L1_2 = L7_1
  L2_2 = A0_2
  L3_2 = 1
  L4_2 = 10000
  return L1_2(L2_2, L3_2, L4_2)
end
function L29_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = Config
  L1_2 = L1_2.PhotoMaxBytes
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 260000
  end
  return L0_2
end
function L30_1(A0_2)
  local L1_2, L2_2
  L1_2 = true == A0_2
  return L1_2
end
function L31_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil == A0_2 or false == A0_2 or "" == A0_2 then
    L1_2 = nil
    L2_2 = true
    return L1_2, L2_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = #L1_2
  L3_2 = L29_1
  L3_2 = L3_2()
  if L2_2 > L3_2 then
    L2_2 = nil
    L3_2 = false
    return L2_2, L3_2
  end
  L2_2 = L1_2
  L3_2 = true
  return L2_2, L3_2
end
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = FW
  L3_2 = L3_2.HasItem
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = pcall
  L3_2 = FW
  L3_2 = L3_2.HasItem
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = L3_2
  return L4_2(L5_2)
end
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if nil == A1_2 or "" == A1_2 then
    L2_2 = nil
    L3_2 = "noitem"
    return L2_2, L3_2
  end
  L2_2 = tostring
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = 64
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2
  L3_2 = L2_2.match
  L5_2 = "^[%w_%-%.]+$"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = nil
    L4_2 = "noitem"
    return L3_2, L4_2
  end
  L3_2 = L32_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if nil == L3_2 then
    L4_2 = nil
    L5_2 = "noinv"
    return L4_2, L5_2
  end
  if L3_2 <= 0 then
    L4_2 = nil
    L5_2 = "noitem"
    return L4_2, L5_2
  end
  return L2_2
end
L34_1 = ItemEscrow
L34_1 = L34_1.onSweep
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = [[
SELECT e.id, e.ref_id FROM apex_phone_item_escrow e
        LEFT JOIN apex_phone_market m ON m.id = e.ref_id
        WHERE e.`source` = 'market' AND e.status = 'held' AND e.target IS NULL AND e.updated < ?
          AND (m.id IS NULL OR m.sold <> 0)
        ORDER BY e.id LIMIT 200]]
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = ItemEscrow
    L8_2 = L8_2.tryLock
    L9_2 = "market:"
    L10_2 = L9_1
    L11_2 = L7_2.ref_id
    L10_2 = L10_2(L11_2)
    L9_2 = L9_2 .. L10_2
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = MySQL
      L0_3 = L0_3.single
      L0_3 = L0_3.await
      L1_3 = "SELECT id, sold, buyer FROM apex_phone_market WHERE id = ?"
      L2_3 = {}
      L3_3 = L7_2.ref_id
      L2_3[1] = L3_3
      L0_3 = L0_3(L1_3, L2_3)
      if not L0_3 then
        L1_3 = ItemEscrow
        L1_3 = L1_3.returnToOwner
        L2_3 = L7_2.id
        L1_3(L2_3)
      else
        L1_3 = L30_1
        L2_3 = L0_3.sold
        L1_3 = L1_3(L2_3)
        if L1_3 then
          L1_3 = L0_3.buyer
          if L1_3 then
            L1_3 = L0_3.buyer
            if "" ~= L1_3 then
              L1_3 = ItemEscrow
              L1_3 = L1_3.giveTo
              L2_3 = L7_2.id
              L3_3 = tostring
              L4_3 = L0_3.buyer
              L3_3, L4_3 = L3_3(L4_3)
              L1_3(L2_3, L3_3, L4_3)
          end
        end
        else
          L1_3 = L30_1
          L2_3 = L0_3.sold
          L1_3 = L1_3(L2_3)
          if L1_3 then
            L1_3 = ItemEscrow
            L1_3 = L1_3.returnToOwner
            L2_3 = L7_2.id
            L1_3(L2_3)
          end
        end
      end
    end
    L8_2(L9_2, L10_2)
  end
end
L34_1(L35_1)
L34_1 = ", (SELECT CAST(SUM(e.`count`) AS SIGNED) FROM apex_phone_item_escrow e WHERE e.`source` = 'market' AND e.ref_id = m.id AND e.status = 'held' AND e.target IS NULL AND e.`count` > 0) AS escrow_count"
L35_1 = ", EXISTS(SELECT 1 FROM apex_phone_item_escrow e2 WHERE e2.`source` = 'market' AND e2.ref_id = m.id) AS custody"
function L36_1(A0_2, A1_2)
  local L2_2
  L2_2 = A0_2.owner
  L2_2 = L2_2 == A1_2
  A0_2.mine = L2_2
  L2_2 = nil
  A0_2.buyer = nil
  A0_2.owner = L2_2
  return A0_2
end
L37_1 = RPC
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = "WHERE 1=1"
  L3_2 = {}
  L4_2 = L29_1
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2()
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
  L3_2[11] = L14_2
  L3_2[12] = L15_2
  L4_2 = A1_2.category
  if L4_2 then
    L4_2 = A1_2.category
    if "" ~= L4_2 then
      L4_2 = L2_2
      L5_2 = " AND category = ?"
      L4_2 = L4_2 .. L5_2
      L2_2 = L4_2
      L4_2 = #L3_2
      L4_2 = L4_2 + 1
      L5_2 = tostring
      L6_2 = A1_2.category
      L5_2 = L5_2(L6_2)
      L6_2 = L5_2
      L5_2 = L5_2.sub
      L7_2 = 1
      L8_2 = 30
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      L3_2[L4_2] = L5_2
    end
  end
  L4_2 = A1_2.q
  if L4_2 then
    L4_2 = A1_2.q
    if "" ~= L4_2 then
      L4_2 = L2_2
      L5_2 = " AND (LOWER(title) LIKE ? OR LOWER(description) LIKE ? OR seller_phone LIKE ?)"
      L4_2 = L4_2 .. L5_2
      L2_2 = L4_2
      L4_2 = "%"
      L5_2 = tostring
      L6_2 = A1_2.q
      L5_2 = L5_2(L6_2)
      L6_2 = L5_2
      L5_2 = L5_2.sub
      L7_2 = 1
      L8_2 = 60
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      L6_2 = L5_2
      L5_2 = L5_2.lower
      L5_2 = L5_2(L6_2)
      L6_2 = "%"
      L4_2 = L4_2 .. L5_2 .. L6_2
      L5_2 = #L3_2
      L5_2 = L5_2 + 1
      L3_2[L5_2] = L4_2
      L5_2 = #L3_2
      L5_2 = L5_2 + 1
      L3_2[L5_2] = L4_2
      L5_2 = #L3_2
      L5_2 = L5_2 + 1
      L3_2[L5_2] = L4_2
    end
  end
  L4_2 = "SELECT m.id, m.owner, m.seller_name, m.seller_phone, m.title, m.description, m.price, m.category, LEFT(m.image, ?) AS image, m.sold, m.buyer, m.created, m.kind, m.item_name"
  L5_2 = ItemEscrow
  L5_2 = L5_2.ready
  if L5_2 then
    L5_2 = L34_1
    L6_2 = L35_1
    L5_2 = L5_2 .. L6_2
    if L5_2 then
      goto lbl_73
    end
  end
  L5_2 = ""
  ::lbl_73::
  L6_2 = " FROM (SELECT id FROM apex_phone_market "
  L7_2 = L2_2
  L8_2 = " ORDER BY sold ASC, created DESC, id DESC LIMIT 100) k"
  L9_2 = " JOIN apex_phone_market m ON m.id = k.id ORDER BY m.sold ASC, m.created DESC, m.id DESC"
  L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = L4_2
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L36_1
    L14_2 = L0_1
    L15_2 = L12_2
    L14_2 = L14_2(L15_2)
    L15_2 = L6_2
    L13_2(L14_2, L15_2)
  end
  return L5_2
end
L37_1["market.list"] = L38_1
L37_1 = RPC
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT m.*"
  L4_2 = ItemEscrow
  L4_2 = L4_2.ready
  if L4_2 then
    L4_2 = L34_1
    L5_2 = L35_1
    L4_2 = L4_2 .. L5_2
    if L4_2 then
      goto lbl_18
    end
  end
  L4_2 = ""
  ::lbl_18::
  L5_2 = " FROM apex_phone_market m WHERE m.owner = ? ORDER BY m.created DESC LIMIT 50"
  L3_2 = L3_2 .. L4_2 .. L5_2
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L36_1
    L10_2 = L0_1
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    L11_2 = L1_2
    L9_2(L10_2, L11_2)
  end
  return L2_2
end
L37_1["market.mine"] = L38_1
L37_1 = RPC
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT m.*"
  L4_2 = ItemEscrow
  L4_2 = L4_2.ready
  if L4_2 then
    L4_2 = L34_1
    L5_2 = L35_1
    L4_2 = L4_2 .. L5_2
    if L4_2 then
      goto lbl_15
    end
  end
  L4_2 = ""
  ::lbl_15::
  L5_2 = " FROM apex_phone_market m WHERE m.id = ?"
  L3_2 = L3_2 .. L4_2 .. L5_2
  L4_2 = {}
  L5_2 = tonumber
  L6_2 = A1_2.id
  L5_2, L6_2 = L5_2(L6_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = L36_1
    L4_2 = L0_1
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    L5_2 = GetCid
    L6_2 = A0_2
    L5_2, L6_2 = L5_2(L6_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_37
    end
  end
  L3_2 = nil
  ::lbl_37::
  return L3_2
end
L37_1["market.get"] = L38_1
L37_1 = RPC
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A1_2.title
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 80
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L27_1
  L5_2 = A1_2.price
  L4_2 = L4_2(L5_2)
  if "" == L3_2 or not L4_2 then
    L5_2 = {}
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = L31_1
  L6_2 = A1_2.image
  L5_2, L6_2 = L5_2(L6_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.error = "toolarge"
    return L7_2
  end
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = A1_2.kind
  if "item" ~= L8_2 then
    L8_2 = A1_2.kind
    if "vehicle" ~= L8_2 then
      goto lbl_52
    end
  end
  L8_2 = A1_2.kind
  ::lbl_52::
  if not L8_2 then
    L8_2 = "other"
  end
  L9_2 = nil
  if "item" == L8_2 then
    L10_2 = nil
    L11_2 = L33_1
    L12_2 = A0_2
    L13_2 = A1_2.item_name
    L11_2, L12_2 = L11_2(L12_2, L13_2)
    L10_2 = L12_2
    L9_2 = L11_2
    if not L9_2 then
      L11_2 = {}
      L11_2.error = L10_2
      return L11_2
    end
  end
  L10_2 = nil
  L11_2 = nil
  L12_2 = nil
  if "item" == L8_2 then
    L13_2 = ItemEscrow
    L13_2 = L13_2.enabled
    L14_2 = "market"
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L13_2 = L28_1
      L14_2 = A1_2.item_count
      L13_2 = L13_2(L14_2)
      L12_2 = L13_2
      if not L12_2 then
        L13_2 = {}
        L13_2.error = "invalid"
        return L13_2
      end
      L13_2 = nil
      L14_2 = ItemEscrow
      L14_2 = L14_2.hold
      L15_2 = A0_2
      L16_2 = "market"
      L17_2 = 0
      L18_2 = L9_2
      L19_2 = L12_2
      L14_2, L15_2, L16_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
      L11_2 = L16_2
      L13_2 = L15_2
      L10_2 = L14_2
      if not L10_2 then
        L14_2 = {}
        L15_2 = L13_2 or L15_2
        if not L13_2 then
          L15_2 = "escrow"
        end
        L14_2.error = L15_2
        return L14_2
      end
    end
  end
  L13_2 = pcall
  L14_2 = MySQL
  L14_2 = L14_2.insert
  L14_2 = L14_2.await
  L15_2 = "INSERT INTO apex_phone_market (owner, seller_name, seller_phone, title, description, price, category, image, sold, buyer, created, kind, item_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NULL, ?, ?, ?)"
  L16_2 = {}
  L17_2 = L2_2.cid
  L18_2 = L2_2.firstname
  if not L18_2 then
    L18_2 = ""
  end
  L19_2 = " "
  L20_2 = L2_2.lastname
  if not L20_2 then
    L20_2 = ""
  end
  L18_2 = L18_2 .. L19_2 .. L20_2
  L19_2 = GetPlayerNumber
  L20_2 = A0_2
  L19_2 = L19_2(L20_2)
  L20_2 = L3_2
  L21_2 = tostring
  L22_2 = A1_2.description
  if not L22_2 then
    L22_2 = ""
  end
  L21_2 = L21_2(L22_2)
  L22_2 = L21_2
  L21_2 = L21_2.sub
  L23_2 = 1
  L24_2 = 1000
  L21_2 = L21_2(L22_2, L23_2, L24_2)
  L22_2 = L4_2
  L23_2 = tostring
  L24_2 = A1_2.category
  if not L24_2 then
    L24_2 = "Outros"
  end
  L23_2 = L23_2(L24_2)
  L24_2 = L23_2
  L23_2 = L23_2.sub
  L25_2 = 1
  L26_2 = 30
  L23_2 = L23_2(L24_2, L25_2, L26_2)
  L24_2 = L5_2
  if L10_2 then
    L25_2 = 1
    if L25_2 then
      goto lbl_159
    end
  end
  L25_2 = 0
  ::lbl_159::
  L26_2 = L7_2
  L27_2 = L8_2
  L28_2 = L9_2
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
  L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2)
  if L13_2 then
    L15_2 = tonumber
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    if L15_2 then
      goto lbl_172
    end
  end
  L15_2 = nil
  ::lbl_172::
  if not L15_2 then
    L16_2 = ipairs
    L17_2 = L11_2 or L17_2
    if not L11_2 then
      L17_2 = {}
    end
    L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
    for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
      L22_2 = ItemEscrow
      L22_2 = L22_2.returnToOwner
      L23_2 = L21_2
      L24_2 = {}
      L24_2.silent = true
      L22_2(L23_2, L24_2)
    end
    if not L13_2 then
      L16_2 = error
      L17_2 = L14_2
      L18_2 = 0
      L16_2(L17_2, L18_2)
    end
    L16_2 = {}
    L16_2.error = "internal"
    return L16_2
  end
  if L10_2 then
    L16_2 = ItemEscrow
    L16_2 = L16_2.link
    L17_2 = L11_2
    L18_2 = L15_2
    L16_2 = L16_2(L17_2, L18_2)
    if not L16_2 then
      L16_2 = print
      L17_2 = "^3[unique_phone]^0 market.create %d: escrow #%d was not fully linked; listing voided and item returned"
      L18_2 = L17_2
      L17_2 = L17_2.format
      L19_2 = L15_2
      L20_2 = L10_2
      L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L17_2(L18_2, L19_2, L20_2)
      L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
      L16_2 = MySQL
      L16_2 = L16_2.update
      L16_2 = L16_2.await
      L17_2 = "DELETE FROM apex_phone_market WHERE id = ? AND owner = ?"
      L18_2 = {}
      L19_2 = L15_2
      L20_2 = L2_2.cid
      L18_2[1] = L19_2
      L18_2[2] = L20_2
      L16_2(L17_2, L18_2)
      L16_2 = ipairs
      L17_2 = L11_2
      L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
      for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
        L22_2 = ItemEscrow
        L22_2 = L22_2.returnToOwner
        L23_2 = L21_2
        L24_2 = {}
        L24_2.silent = true
        L22_2(L23_2, L24_2)
      end
      L16_2 = {}
      L16_2.error = "escrow"
      return L16_2
    end
    L16_2 = MySQL
    L16_2 = L16_2.update
    L16_2 = L16_2.await
    L17_2 = "UPDATE apex_phone_market SET sold = 0 WHERE id = ? AND (buyer IS NULL OR buyer = '')"
    L18_2 = {}
    L19_2 = L15_2
    L18_2[1] = L19_2
    L16_2(L17_2, L18_2)
  end
  L16_2 = Dbg
  L17_2 = "market"
  L18_2 = "create %d kind=%s item=%s escrow=%s"
  L19_2 = L15_2
  L20_2 = L8_2
  L21_2 = tostring
  L22_2 = L9_2
  L21_2 = L21_2(L22_2)
  L22_2 = tostring
  L23_2 = L10_2
  L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L22_2(L23_2)
  L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  L16_2 = {}
  L16_2.id = L15_2
  L16_2.ok = true
  L16_2.created = L7_2
  L17_2 = nil ~= L10_2
  L16_2.escrow = L17_2
  L17_2 = L12_2 or L17_2
  if not L10_2 or not L12_2 then
    L17_2 = nil
  end
  L16_2.item_count = L17_2
  return L16_2
end
L37_1["market.create"] = L38_1
function L37_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_market WHERE id = ? AND owner = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A2_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "forbidden"
    return L4_2
  end
  L4_2 = L3_2.title
  L5_2 = A2_2.title
  if nil ~= L5_2 then
    L5_2 = tostring
    L6_2 = A2_2.title
    L5_2 = L5_2(L6_2)
    L6_2 = L5_2
    L5_2 = L5_2.sub
    L7_2 = 1
    L8_2 = 80
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2 = L5_2
    if "" == L4_2 then
      L5_2 = {}
      L5_2.error = "invalid"
      return L5_2
    end
  end
  L5_2 = L3_2.price
  L6_2 = A2_2.price
  if nil ~= L6_2 then
    L6_2 = L27_1
    L7_2 = A2_2.price
    L6_2 = L6_2(L7_2)
    L5_2 = L6_2
    if not L5_2 then
      L6_2 = {}
      L6_2.error = "invalid"
      return L6_2
    end
  end
  L6_2 = A2_2.description
  if nil ~= L6_2 then
    L6_2 = tostring
    L7_2 = A2_2.description
    L6_2 = L6_2(L7_2)
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = 1000
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_64
    end
  end
  L6_2 = L3_2.description
  ::lbl_64::
  L7_2 = A2_2.category
  if L7_2 then
    L7_2 = tostring
    L8_2 = A2_2.category
    L7_2 = L7_2(L8_2)
    L8_2 = L7_2
    L7_2 = L7_2.sub
    L9_2 = 1
    L10_2 = 30
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 then
      goto lbl_77
    end
  end
  L7_2 = L3_2.category
  ::lbl_77::
  L8_2 = L3_2.image
  L9_2 = A2_2.image
  if nil ~= L9_2 then
    L9_2 = nil
    L10_2 = L31_1
    L11_2 = A2_2.image
    L10_2, L11_2 = L10_2(L11_2)
    L9_2 = L11_2
    L8_2 = L10_2
    if not L9_2 then
      L10_2 = {}
      L10_2.error = "toolarge"
      return L10_2
    end
  end
  L9_2 = A2_2.sold
  if nil ~= L9_2 then
    L9_2 = A2_2.sold
    if L9_2 then
      L9_2 = 1
      if L9_2 then
        goto lbl_114
      end
    end
    L9_2 = 0
    if L9_2 then
      goto lbl_114
    end
  end
  L9_2 = L30_1
  L10_2 = L3_2.sold
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = 1
    if L9_2 then
      goto lbl_114
    end
  end
  L9_2 = 0
  ::lbl_114::
  L10_2 = L3_2.buyer
  if L10_2 then
    L10_2 = L3_2.buyer
    if "" ~= L10_2 then
      L10_2 = L30_1
      L11_2 = L3_2.sold
      L10_2 = L10_2(L11_2)
      if L10_2 and 1 ~= L9_2 then
        L10_2 = {}
        L10_2.ok = false
        L10_2.error = "sold"
        return L10_2
      end
    end
  end
  L10_2 = A2_2.kind
  if "item" ~= L10_2 then
    L10_2 = A2_2.kind
    if "vehicle" ~= L10_2 then
      L10_2 = A2_2.kind
      if "other" ~= L10_2 then
        goto lbl_144
      end
    end
  end
  L10_2 = A2_2.kind
  ::lbl_144::
  if not L10_2 then
    L10_2 = L3_2.kind
    if not L10_2 then
      L10_2 = "other"
    end
  end
  L11_2 = L3_2.item_name
  L12_2 = A2_2.item_name
  if nil ~= L12_2 then
    L12_2 = tostring
    L13_2 = A2_2.item_name
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = L3_2.item_name
    L13_2 = L13_2(L14_2)
  end
  L12_2 = L3_2.kind
  L12_2 = L3_2.item_name
  L12_2 = "item" == L10_2 and L12_2
  if "item" ~= L10_2 then
    L11_2 = nil
  elseif L12_2 then
    L13_2 = nil
    L14_2 = L33_1
    L15_2 = A0_2
    L16_2 = A2_2.item_name
    if nil ~= L16_2 then
      L16_2 = A2_2.item_name
      if L16_2 then
        goto lbl_186
      end
    end
    L16_2 = L3_2.item_name
    ::lbl_186::
    L14_2, L15_2 = L14_2(L15_2, L16_2)
    L13_2 = L15_2
    L11_2 = L14_2
    if not L11_2 then
      L14_2 = {}
      L14_2.error = L13_2
      return L14_2
    end
  end
  L13_2 = nil
  L14_2 = A2_2.item_count
  if nil ~= L14_2 then
    L14_2 = L28_1
    L15_2 = A2_2.item_count
    L14_2 = L14_2(L15_2)
    L13_2 = L14_2
    if not L13_2 then
      L14_2 = {}
      L14_2.error = "invalid"
      return L14_2
    end
  end
  L14_2 = L3_2.buyer
  if L14_2 then
    L14_2 = L3_2.buyer
    L14_2 = L30_1
    L15_2 = L3_2.sold
    L14_2 = "" ~= L14_2 and L14_2
  end
  L15_2 = not L14_2
  L16_2 = {}
  L17_2 = nil
  if L15_2 then
    L18_2 = ItemEscrow
    L18_2 = L18_2.waitReady
    L18_2 = L18_2()
    if not L18_2 then
      L18_2 = {}
      L18_2.error = "escrow"
      return L18_2
    end
    L18_2 = ItemEscrow
    L18_2 = L18_2.heldRows
    L19_2 = "market"
    L20_2 = L3_2.id
    L18_2 = L18_2(L19_2, L20_2)
    L16_2 = L18_2
    L18_2 = ItemEscrow
    L18_2 = L18_2.lastRow
    L19_2 = "market"
    L20_2 = L3_2.id
    L18_2 = L18_2(L19_2, L20_2)
    L17_2 = L18_2
  end
  L18_2 = 0
  L19_2 = true
  L20_2 = ipairs
  L21_2 = L16_2
  L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
  for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
    L26_2 = L25_2.count
    L18_2 = L18_2 + L26_2
    L26_2 = L25_2.item
    if L26_2 ~= L11_2 then
      L19_2 = false
    end
  end
  L20_2 = ItemEscrow
  L20_2 = L20_2.enabled
  L21_2 = "market"
  L20_2 = L20_2(L21_2)
  L21_2 = L30_1
  L22_2 = L3_2.sold
  L21_2 = L21_2(L22_2)
  L21_2 = L21_2 and 0 == L9_2
  L22_2 = nil
  L23_2 = 0
  L24_2 = 0
  L25_2 = false
  if L15_2 then
    if "item" == L10_2 and 0 == L9_2 then
      if L18_2 > 0 and L19_2 then
        L26_2 = L13_2 or L26_2
        if not L13_2 then
          L26_2 = L18_2
        end
        if L18_2 < L26_2 and L20_2 then
          L23_2 = L26_2 - L18_2
        elseif L18_2 > L26_2 then
          L24_2 = L18_2 - L26_2
        end
      elseif L18_2 > 0 then
        L25_2 = true
        L22_2 = L13_2 or L22_2
        if L20_2 and not L13_2 then
          L22_2 = 1
        end
      elseif L20_2 and (L12_2 or L21_2 and nil ~= L17_2) then
        L26_2 = nil
        if not L13_2 and L21_2 and nil ~= L17_2 and not L12_2 then
          L27_2 = MySQL
          L27_2 = L27_2.scalar
          L27_2 = L27_2.await
          L28_2 = "SELECT MAX(updated) FROM apex_phone_item_escrow WHERE `source` = 'market' AND ref_id = ? AND item = ? AND target IS NULL AND status IN ('returned', 'pending_return')"
          L29_2 = {}
          L30_2 = L3_2.id
          L31_2 = L11_2
          L29_2[1] = L30_2
          L29_2[2] = L31_2
          L27_2 = L27_2(L28_2, L29_2)
          L28_2 = tonumber
          L29_2 = L27_2
          L28_2 = L28_2(L29_2)
          if L28_2 then
            L28_2 = tonumber
            L29_2 = MySQL
            L29_2 = L29_2.scalar
            L29_2 = L29_2.await
            L30_2 = "SELECT CAST(SUM(`count`) AS SIGNED) FROM apex_phone_item_escrow WHERE `source` = 'market' AND ref_id = ? AND item = ? AND target IS NULL AND status IN ('returned', 'pending_return') AND updated >= ?"
            L31_2 = {}
            L32_2 = L3_2.id
            L33_2 = L11_2
            L34_2 = tonumber
            L35_2 = L27_2
            L34_2 = L34_2(L35_2)
            L34_2 = L34_2 - 1000
            L31_2[1] = L32_2
            L31_2[2] = L33_2
            L31_2[3] = L34_2
            L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2 = L29_2(L30_2, L31_2)
            L28_2 = L28_2(L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2)
            L26_2 = L28_2
          end
        end
        L22_2 = L13_2 or L22_2
        if not L13_2 then
          if L26_2 and L26_2 >= 1 then
            L27_2 = math
            L27_2 = L27_2.min
            L28_2 = math
            L28_2 = L28_2.tointeger
            L29_2 = L26_2
            L28_2 = L28_2(L29_2)
            if not L28_2 then
              L28_2 = 1
            end
            L29_2 = 10000
            L27_2 = L27_2(L28_2, L29_2)
            L22_2 = L27_2 or L22_2
          end
          if not L27_2 then
            L22_2 = 1
          end
        end
      end
    elseif L18_2 > 0 then
      L25_2 = true
    end
  end
  L26_2 = {}
  if L22_2 then
    L27_2 = ItemEscrow
    L27_2 = L27_2.hold
    L28_2 = A0_2
    L29_2 = "market"
    L30_2 = L3_2.id
    L31_2 = L11_2
    L32_2 = L22_2
    L27_2, L28_2, L29_2 = L27_2(L28_2, L29_2, L30_2, L31_2, L32_2)
    if not L27_2 then
      L30_2 = {}
      L31_2 = L28_2 or L31_2
      if not L28_2 then
        L31_2 = "escrow"
      end
      L30_2.error = L31_2
      return L30_2
    end
    L26_2 = L29_2
  elseif L23_2 > 0 then
    L27_2 = ItemEscrow
    L27_2 = L27_2.hold
    L28_2 = A0_2
    L29_2 = "market"
    L30_2 = L3_2.id
    L31_2 = L11_2
    L32_2 = L23_2
    L27_2, L28_2, L29_2 = L27_2(L28_2, L29_2, L30_2, L31_2, L32_2)
    if not L27_2 then
      L30_2 = {}
      L31_2 = L28_2 or L31_2
      if not L28_2 then
        L31_2 = "escrow"
      end
      L30_2.error = L31_2
      return L30_2
    end
    L26_2 = L29_2
  end
  L27_2 = pcall
  L28_2 = MySQL
  L28_2 = L28_2.update
  L28_2 = L28_2.await
  L29_2 = "UPDATE apex_phone_market SET title = ?, price = ?, description = ?, category = ?, image = ?, sold = IF(buyer IS NULL OR buyer = '', ?, sold), kind = ?, item_name = ? WHERE id = ? AND owner = ?"
  L30_2 = {}
  L31_2 = L4_2
  L32_2 = L5_2
  L33_2 = L6_2
  L34_2 = L7_2
  L35_2 = L8_2
  L36_2 = L9_2
  L37_2 = L10_2
  L38_2 = L11_2
  L39_2 = L3_2.id
  L40_2 = A1_2
  L30_2[1] = L31_2
  L30_2[2] = L32_2
  L30_2[3] = L33_2
  L30_2[4] = L34_2
  L30_2[5] = L35_2
  L30_2[6] = L36_2
  L30_2[7] = L37_2
  L30_2[8] = L38_2
  L30_2[9] = L39_2
  L30_2[10] = L40_2
  L27_2, L28_2 = L27_2(L28_2, L29_2, L30_2)
  if not L27_2 then
    L29_2 = ipairs
    L30_2 = L26_2
    L29_2, L30_2, L31_2, L32_2 = L29_2(L30_2)
    for L33_2, L34_2 in L29_2, L30_2, L31_2, L32_2 do
      L35_2 = ItemEscrow
      L35_2 = L35_2.returnToOwner
      L36_2 = L34_2
      L37_2 = {}
      L37_2.silent = true
      L35_2(L36_2, L37_2)
    end
    L29_2 = error
    L30_2 = L28_2
    L31_2 = 0
    L29_2(L30_2, L31_2)
  end
  L29_2 = {}
  L29_2.ok = true
  if L22_2 then
    L30_2 = true
    L29_2.item_count = L22_2
    L29_2.escrow = L30_2
  end
  if L25_2 then
    L30_2 = ItemEscrow
    L30_2 = L30_2.returnRows
    L31_2 = L16_2
    L32_2 = nil
    L33_2 = {}
    L33_2.silent = true
    L30_2 = L30_2(L31_2, L32_2, L33_2)
    L29_2.item = L30_2
  elseif L24_2 > 0 then
    L30_2 = ItemEscrow
    L30_2 = L30_2.returnRows
    L31_2 = L16_2
    L32_2 = L24_2
    L33_2 = {}
    L33_2.silent = true
    L30_2 = L30_2(L31_2, L32_2, L33_2)
    L29_2.item = L30_2
  end
  L30_2 = Dbg
  L31_2 = "market"
  L32_2 = "update %d sold=%d kind=%s new=%d (%s) +%d -%d returned=%s"
  L33_2 = L3_2.id
  L34_2 = L9_2
  L35_2 = L10_2
  L36_2 = #L26_2
  L37_2 = tostring
  L38_2 = L22_2
  L37_2 = L37_2(L38_2)
  L38_2 = L23_2
  L39_2 = L24_2
  L40_2 = tostring
  L41_2 = L25_2
  L40_2, L41_2 = L40_2(L41_2)
  L30_2(L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2)
  return L29_2
end
L38_1 = RPC
function L39_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = tonumber
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "forbidden"
    return L3_2
  end
  L3_2 = ItemEscrow
  L3_2 = L3_2.withLock
  L4_2 = "market:"
  L5_2 = L9_1
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L4_2 = L4_2 .. L5_2
  L5_2 = L37_1
  L6_2 = A0_2
  L7_2 = GetCid
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = A1_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L38_1["market.update"] = L39_1
L38_1 = RPC
function L39_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L2_2 or not L3_2 then
    L4_2 = {}
    L4_2.ok = true
    return L4_2
  end
  L4_2 = ItemEscrow
  L4_2 = L4_2.withLock
  L5_2 = "market:"
  L6_2 = L9_1
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3
    L0_3 = MySQL
    L0_3 = L0_3.single
    L0_3 = L0_3.await
    L1_3 = "SELECT id, sold, buyer FROM apex_phone_market WHERE id = ? AND owner = ?"
    L2_3 = {}
    L3_3 = L3_2
    L4_3 = L2_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L0_3 = L0_3(L1_3, L2_3)
    L1_3 = MySQL
    L1_3 = L1_3.update
    L1_3 = L1_3.await
    L2_3 = "DELETE FROM apex_phone_market WHERE id = ? AND owner = ?"
    L3_3 = {}
    L4_3 = L3_2
    L5_3 = L2_2
    L3_3[1] = L4_3
    L3_3[2] = L5_3
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = {}
    L2_3.ok = true
    L3_3 = tonumber
    L4_3 = L1_3
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = 0
    end
    if 1 == L3_3 then
      L3_3 = ItemEscrow
      L3_3 = L3_3.ready
      if L3_3 then
        L3_3 = ItemEscrow
        L3_3 = L3_3.heldRows
        L4_3 = "market"
        L5_3 = L3_2
        L3_3 = L3_3(L4_3, L5_3)
        if L0_3 then
          L4_3 = L30_1
          L5_3 = L0_3.sold
          L4_3 = L4_3(L5_3)
          if L4_3 then
            L4_3 = L0_3.buyer
            if L4_3 then
              L4_3 = L0_3.buyer
              if "" ~= L4_3 then
                L4_3 = ipairs
                L5_3 = L3_3
                L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
                for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
                  L10_3 = ItemEscrow
                  L10_3 = L10_3.giveTo
                  L11_3 = L9_3.id
                  L12_3 = tostring
                  L13_3 = L0_3.buyer
                  L12_3, L13_3 = L12_3(L13_3)
                  L10_3(L11_3, L12_3, L13_3)
                end
            end
          end
        end
        else
          L4_3 = ItemEscrow
          L4_3 = L4_3.returnRows
          L5_3 = L3_3
          L6_3 = nil
          L7_3 = {}
          L7_3.silent = true
          L4_3 = L4_3(L5_3, L6_3, L7_3)
          L2_3.item = L4_3
        end
      end
    end
    return L2_3
  end
  return L4_2(L5_2, L6_2)
end
L38_1["market.delete"] = L39_1
function L38_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_market WHERE id = ?"
  L6_2 = {}
  L7_2 = A3_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L30_1
    L6_2 = L4_2.sold
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      goto lbl_22
    end
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "sold"
  do return L5_2 end
  ::lbl_22::
  -- listings mirrored from the server's markets (owner = "system:...") are bought IN PERSON at the shop: there is no player
  -- to pay here, so the money would simply vanish
  if type(L4_2.owner) == "string" and L4_2.owner:sub(1, 7) == "system:" then
    return { ok = false, error = "invalid" }
  end
  L5_2 = L4_2.owner
  L6_2 = A2_2.cid
  if L5_2 == L6_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "self"
    return L5_2
  end
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = L4_2.price
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2(L6_2)
  if not L5_2 or L5_2 <= 0 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = A1_2.price
  if nil ~= L6_2 then
    L6_2 = tonumber
    L7_2 = A1_2.price
    L6_2 = L6_2(L7_2)
    if L6_2 ~= L5_2 then
      L6_2 = {}
      L6_2.ok = false
      L6_2.error = "changed"
      return L6_2
    end
  end
  L6_2 = A2_2.GetMoney
  L7_2 = "bank"
  L6_2 = L6_2(L7_2)
  if L5_2 > L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "funds"
    return L6_2
  end
  L6_2 = L4_2.kind
  if "item" == L6_2 then
    L6_2 = ItemEscrow
    L6_2 = L6_2.waitReady
    L6_2 = L6_2()
    if not L6_2 then
      L6_2 = {}
      L6_2.ok = false
      L6_2.error = "escrow"
      return L6_2
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_market SET sold = 1, buyer = ? WHERE id = ? AND sold = 0 AND owner <> ? AND price = ?"
  L8_2 = {}
  L9_2 = A2_2.cid
  L10_2 = L4_2.id
  L11_2 = A2_2.cid
  L12_2 = L5_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = tonumber
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  if 1 ~= L7_2 then
    L7_2 = MySQL
    L7_2 = L7_2.single
    L7_2 = L7_2.await
    L8_2 = "SELECT sold FROM apex_phone_market WHERE id = ?"
    L9_2 = {}
    L10_2 = L4_2.id
    L9_2[1] = L10_2
    L7_2 = L7_2(L8_2, L9_2)
    L8_2 = {}
    L8_2.ok = false
    if L7_2 then
      L9_2 = L30_1
      L10_2 = L7_2.sold
      L9_2 = L9_2(L10_2)
      if not L9_2 then
        goto lbl_127
      end
    end
    L9_2 = "sold"
    ::lbl_127::
    if not L9_2 then
      L9_2 = "changed"
    end
    L8_2.error = L9_2
    return L8_2
  end
  L7_2 = A2_2.RemoveMoney
  L8_2 = "bank"
  L9_2 = L5_2
  L10_2 = "market-"
  L11_2 = tostring
  L12_2 = L4_2.id
  L11_2 = L11_2(L12_2)
  L10_2 = L10_2 .. L11_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "UPDATE apex_phone_market SET sold = 0, buyer = NULL WHERE id = ? AND buyer = ? AND sold = 1"
    L9_2 = {}
    L10_2 = L4_2.id
    L11_2 = A2_2.cid
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2(L8_2, L9_2)
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "funds"
    return L7_2
  end
  L4_2.sold = 1
  L7_2 = A2_2.cid
  L4_2.buyer = L7_2
  L4_2.price = L5_2
  L7_2 = L25_1
  L8_2 = L4_2.owner
  L9_2 = L5_2
  L10_2 = "market-sale"
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L8_2 = print
    L9_2 = "^1[unique_phone]^0 market.buy %d: MONEY STUCK \226\128\148 charged %s to %s and the deposit to seller %s failed (character that no longer exists in the framework?). It stays in their history as an UNPAID sale; restore it by hand."
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L4_2.id
    L12_2 = FormatMoney
    L13_2 = L5_2
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = A2_2.cid
    L13_2 = L13_2(L14_2)
    L14_2 = tostring
    L15_2 = L4_2.owner
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L14_2(L15_2)
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  end
  L8_2 = nil
  L9_2 = ItemEscrow
  L9_2 = L9_2.ready
  if L9_2 then
    L9_2 = ItemEscrow
    L9_2 = L9_2.heldRows
    L10_2 = "market"
    L11_2 = L4_2.id
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      goto lbl_196
    end
  end
  L9_2 = {}
  ::lbl_196::
  L10_2 = ipairs
  L11_2 = L9_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = ItemEscrow
    L16_2 = L16_2.giveTo
    L17_2 = L15_2.id
    L18_2 = A2_2.cid
    L19_2 = {}
    L19_2.silent = true
    L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2)
    if not L16_2 then
      L18_2 = print
      L19_2 = "^3[unique_phone]^0 market.buy %d: could not deliver escrow #%d (%s); the periodic cleanup will try again"
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = L4_2.id
      L22_2 = L15_2.id
      L23_2 = tostring
      L24_2 = L17_2
      L23_2, L24_2 = L23_2(L24_2)
      L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2)
      L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      L18_2 = "pending"
      L17_2 = "retry"
      L16_2 = L18_2
    end
    if not L8_2 then
      L18_2 = {}
      L18_2.status = "given"
      L19_2 = L15_2.item
      L18_2.name = L19_2
      L19_2 = ItemEscrow
      L19_2 = L19_2.label
      L20_2 = L15_2.item
      L19_2 = L19_2(L20_2)
      L18_2.label = L19_2
      L18_2.count = 0
      L8_2 = L18_2
    end
    L18_2 = L8_2.count
    L19_2 = L15_2.count
    L18_2 = L18_2 + L19_2
    L8_2.count = L18_2
    if "pending" == L16_2 then
      L18_2 = L8_2.status
      if "pending" ~= L18_2 then
        L18_2 = "pending"
        L8_2.reason = L17_2
        L8_2.status = L18_2
      end
    end
  end
  L4_2.item_transfer = L8_2
  L10_2 = A2_2.firstname
  if not L10_2 then
    L10_2 = ""
  end
  L11_2 = " "
  L12_2 = A2_2.lastname
  if not L12_2 then
    L12_2 = ""
  end
  L10_2 = L10_2 .. L11_2 .. L12_2
  L11_2 = AddTransaction
  L12_2 = A2_2.cid
  L13_2 = "Marketplace: "
  L14_2 = L4_2.title
  L13_2 = L13_2 .. L14_2
  L14_2 = -L5_2
  L11_2(L12_2, L13_2, L14_2)
  if L7_2 then
    L11_2 = AddTransaction
    L12_2 = L4_2.owner
    L13_2 = "Venda: "
    L14_2 = L4_2.title
    L15_2 = " ("
    L16_2 = L10_2
    L17_2 = ")"
    L13_2 = L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2
    L14_2 = L5_2
    L11_2(L12_2, L13_2, L14_2)
    L11_2 = NotifyCitizen
    L12_2 = L4_2.owner
    L13_2 = "marketplace"
    L14_2 = "Vendeste \""
    L15_2 = L4_2.title
    L16_2 = "\""
    L14_2 = L14_2 .. L15_2 .. L16_2
    if L8_2 then
      L15_2 = "%s pagou %s \194\183 o item seguiu para o comprador"
      if L15_2 then
        goto lbl_296
      end
    end
    L15_2 = "%s pagou %s"
    ::lbl_296::
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = L10_2
    L18_2 = FormatMoney
    L19_2 = L5_2
    L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L18_2(L19_2)
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L16_2 = nil
    L17_2 = {}
    L17_2.throttle = false
    L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  else
    L11_2 = AddTransaction
    L12_2 = L4_2.owner
    L13_2 = "Venda N\195\131O paga: "
    L14_2 = L4_2.title
    L15_2 = " ("
    L16_2 = L10_2
    L17_2 = ")"
    L13_2 = L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2
    L14_2 = 0
    L11_2(L12_2, L13_2, L14_2)
    L11_2 = NotifyCitizen
    L12_2 = L4_2.owner
    L13_2 = "marketplace"
    L14_2 = "Venda sem pagamento"
    L15_2 = "\"%s\" foi vendido por %s mas o dep\195\179sito n\195\163o entrou na tua conta. Fala com a administra\195\167\195\163o."
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = L4_2.title
    L18_2 = FormatMoney
    L19_2 = L5_2
    L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L18_2(L19_2)
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L16_2 = nil
    L17_2 = {}
    L17_2.throttle = false
    L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  end
  L11_2 = TriggerEvent
  L12_2 = "apex_phone:marketSold"
  L13_2 = A0_2
  L14_2 = L4_2
  L11_2(L12_2, L13_2, L14_2)
  L11_2 = Dbg
  L12_2 = "market"
  L13_2 = "buy %d by %s: item=%s"
  L14_2 = L4_2.id
  L15_2 = A2_2.cid
  if L8_2 then
    L16_2 = L8_2.status
    if L16_2 then
      goto lbl_350
    end
  end
  L16_2 = "manual"
  ::lbl_350::
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
  L11_2 = {}
  L11_2.ok = true
  L12_2 = A2_2.GetMoney
  L13_2 = "bank"
  L12_2 = L12_2(L13_2)
  L11_2.bank = L12_2
  L11_2.item = L8_2
  return L11_2
end
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "sold"
    return L4_2
  end
  L4_2 = ItemEscrow
  L4_2 = L4_2.withLock
  L5_2 = "market:"
  L6_2 = L9_1
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L6_2 = L38_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = L2_2
  L10_2 = L3_2
  return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L39_1["market.buy"] = L40_1
