local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1
L0_1 = "recado"
L1_1 = 4102444800000
L2_1 = 600000
L3_1 = 120000
L4_1 = 3
L5_1 = 2000
L6_1 = 30
function L7_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Recado
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Recado
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L8_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = A1_2
  end
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L4_2 = A1_2
  end
  if A2_2 > L4_2 then
    L4_2 = A2_2
  elseif A3_2 < L4_2 then
    L4_2 = A3_2
  end
  return L4_2
end
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = L7_1
  L0_2 = L0_2()
  L1_2 = type
  L2_2 = Config
  L2_2 = L2_2.Media
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = Config
    L1_2 = L1_2.Media
    if L1_2 then
      goto lbl_15
    end
  end
  L1_2 = {}
  ::lbl_15::
  L2_2 = {}
  L3_2 = L8_1
  L4_2 = L0_2.pinsMax
  L5_2 = 3
  L6_2 = 1
  L7_2 = 20
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.pinsMax = L3_2
  L3_2 = L8_1
  L4_2 = L0_2.forwardMax
  L5_2 = 5
  L6_2 = 1
  L7_2 = 20
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.forwardMax = L3_2
  L3_2 = L8_1
  L4_2 = L0_2.multiImageMax
  L5_2 = 10
  L6_2 = 1
  L7_2 = 30
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.multiImageMax = L3_2
  L3_2 = L8_1
  L4_2 = L0_2.captionMax
  L5_2 = 1000
  L6_2 = 1
  L7_2 = 4000
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.captionMax = L3_2
  L3_2 = L8_1
  L4_2 = L0_2.textMax
  L5_2 = 4000
  L6_2 = 1
  L7_2 = 60000
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.textMax = L3_2
  L3_2 = L8_1
  L4_2 = L0_2.hdImageBytes
  L5_2 = 520000
  L6_2 = 1000
  L7_2 = 16000000
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.hdImageBytes = L3_2
  L3_2 = L8_1
  L4_2 = L1_2.maxImageBytes
  L5_2 = 260000
  L6_2 = 1000
  L7_2 = 16000000
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.maxImageBytes = L3_2
  L3_2 = L8_1
  L4_2 = type
  L5_2 = Config
  L5_2 = L5_2.Messages
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = Config
    L4_2 = L4_2.Messages
    L4_2 = L4_2.typingMs
    if L4_2 then
      goto lbl_79
    end
  end
  L4_2 = nil
  ::lbl_79::
  L5_2 = 3000
  L6_2 = 500
  L7_2 = 60000
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2.typingMs = L3_2
  return L2_2
end
function L10_1(A0_2)
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
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.rep
  L2_2 = "?"
  L3_2 = A0_2
  L4_2 = ", "
  return L1_2(L2_2, L3_2, L4_2)
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = tostring
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
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
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "^%s+"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "%s+$"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  return A0_2
end
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      L2_2 = ""
      return L2_2
    end
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = A1_2 + 8
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2
  L3_2 = L2_2.gsub
  L5_2 = "[%c]"
  function L6_2(A0_3)
    local L1_3
    L1_3 = A0_3 or L1_3
    if "\n" ~= A0_3 and "\t" ~= A0_3 or not A0_3 then
      L1_3 = ""
    end
    return L1_3
  end
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L3_2
  L3_2 = L13_1
  L4_2 = L12_1
  L5_2 = L2_2
  L6_2 = A1_2
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  return L3_2(L4_2, L5_2, L6_2)
end
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L14_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  L4_2 = L2_2
  L3_2 = L2_2.gsub
  L5_2 = "%s+"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L3_2
  return L2_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L2_2 = math
    L2_2 = L2_2.tointeger
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not L2_2 or L2_2 < 0 then
      L3_2 = nil
      return L3_2
    end
    L3_2 = tostring
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    A0_2 = L3_2
  else
    if "string" == L1_2 then
      L2_2 = #A0_2
      if not (L2_2 > 64) then
        goto lbl_28
      end
    end
    L2_2 = nil
    return L2_2
  end
  ::lbl_28::
  L2_2 = L13_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = #L2_2
  if not (L3_2 < 3) then
    L3_2 = #L2_2
    if not (L3_2 > 20) then
      L4_2 = L2_2
      L3_2 = L2_2.match
      L5_2 = "^[%d%+%-%.%(%) ]+$"
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        goto lbl_44
      end
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_44::
  L3_2 = select
  L4_2 = 2
  L6_2 = L2_2
  L5_2 = L2_2.gsub
  L7_2 = "%d"
  L8_2 = ""
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  if L3_2 < 3 then
    L3_2 = nil
    return L3_2
  end
  return L2_2
end
function L17_1(A0_2)
  local L1_2
  if true == A0_2 or 1 == A0_2 or "1" == A0_2 then
    L1_2 = 1
    if L1_2 then
      goto lbl_11
    end
  end
  L1_2 = 0
  ::lbl_11::
  return L1_2
end
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    return A0_2
  end
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
      goto lbl_31
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = nil
  ::lbl_31::
  return L3_2
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetPlayerNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if nil == L1_2 or "" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = tostring
  L3_2 = L1_2
  return L2_2(L3_2)
end
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A1_2 < A0_2 then
    L2_2 = A1_2
    A1_2 = A0_2
    A0_2 = L2_2
  end
  L2_2 = "n:"
  L3_2 = A0_2
  L4_2 = "|"
  L5_2 = A1_2
  L2_2 = L2_2 .. L3_2 .. L4_2 .. L5_2
  return L2_2
end
L21_1 = false
L22_1 = {}
L23_1 = {}
L24_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_messages` (`expires_at` BIGINT NULL, `view_once` TINYINT NOT NULL DEFAULT 0, `viewed_at` BIGINT NULL, `forwarded` TINYINT NOT NULL DEFAULT 0)"
L25_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_thread_meta` (`archived` TINYINT NOT NULL DEFAULT 0, `marked_unread` TINYINT NOT NULL DEFAULT 0, `locked` TINYINT NOT NULL DEFAULT 0, `disappearing` INT NULL)"
L26_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_conversations` (`disappearing` INT NULL)"
L23_1[1] = L24_1
L23_1[2] = L25_1
L23_1[3] = L26_1
L24_1 = {}
L25_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_stars` (`message_id` INT NOT NULL, `who` VARCHAR(40) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`message_id`, `who`), KEY `who_created` (`who`, `created`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L26_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_pins` (`thread` VARCHAR(90) NOT NULL, `message_id` INT NOT NULL, `pinned_by` VARCHAR(40) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`thread`, `message_id`), KEY `message` (`message_id`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L27_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_views` (`message_id` INT NOT NULL, `who` VARCHAR(40) NOT NULL, `viewed_at` BIGINT NOT NULL, PRIMARY KEY (`message_id`, `who`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L24_1[1] = L25_1
L24_1[2] = L26_1
L24_1[3] = L27_1
function L25_1()
  local L0_2, L1_2, L2_2, L3_2
  function L0_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L2_3 = pcall
    L3_3 = MySQL
    L3_3 = L3_3.scalar
    L3_3 = L3_3.await
    L4_3 = "SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?"
    L5_3 = {}
    L6_3 = A0_3
    L7_3 = A1_3
    L5_3[1] = L6_3
    L5_3[2] = L7_3
    L2_3, L3_3 = L2_3(L3_3, L4_3, L5_3)
    L4_3 = L2_3
    if L2_3 then
      L4_3 = tonumber
      L5_3 = L3_3
      L4_3 = L4_3(L5_3)
      if not L4_3 then
        L4_3 = 0
      end
      L4_3 = L4_3 > 0
    end
    return L4_3
  end
  L1_2 = L0_2
  L2_2 = "apex_phone_messages"
  L3_2 = "expires_at"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L1_2 = L0_2
    L2_2 = "apex_phone_messages"
    L3_2 = "view_once"
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      L1_2 = L0_2
      L2_2 = "apex_phone_messages"
      L3_2 = "forwarded"
      L1_2 = L1_2(L2_2, L3_2)
      if L1_2 then
        L1_2 = L0_2
        L2_2 = "apex_phone_thread_meta"
        L3_2 = "archived"
        L1_2 = L1_2(L2_2, L3_2)
        if L1_2 then
          L1_2 = L0_2
          L2_2 = "apex_phone_thread_meta"
          L3_2 = "locked"
          L1_2 = L1_2(L2_2, L3_2)
          if L1_2 then
            L1_2 = L0_2
            L2_2 = "apex_phone_conversations"
            L3_2 = "disappearing"
            L1_2 = L1_2(L2_2, L3_2)
          end
        end
      end
    end
  end
  return L1_2
end
L26_1 = CreateThread
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = DBReady
  if nil == L0_2 then
    L0_2 = Wait
    L1_2 = 3000
    L0_2(L1_2)
  else
    while true do
      L0_2 = DBReady
      if L0_2 then
        break
      end
      L0_2 = Wait
      L1_2 = 500
      L0_2(L1_2)
    end
  end
  L0_2 = ipairs
  L1_2 = L23_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = pcall
    L7_2 = MigrateTable
    L8_2 = L5_2
    L6_2, L7_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L8_2 = print
      L9_2 = "^1[unique_phone]^0 Recado: migration failed (%s)"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L12_2 = L7_2
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
      L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
  L0_2 = ipairs
  L1_2 = L24_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = pcall
    function L7_2()
      local L0_3, L1_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = L5_2
      L0_3(L1_3)
    end
    L6_2, L7_2 = L6_2(L7_2)
    if not L6_2 then
      L8_2 = print
      L9_2 = "^1[unique_phone]^0 Recado: could not create %s (%s)"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L13_2 = L5_2
      L12_2 = L5_2.match
      L14_2 = "`([%w_]+)`"
      L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      L12_2 = tostring
      L13_2 = L7_2
      L12_2, L13_2, L14_2 = L12_2(L13_2)
      L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    end
    L8_2 = pcall
    L9_2 = MigrateTable
    L10_2 = L5_2
    L8_2(L9_2, L10_2)
  end
  L0_2 = L25_1
  L0_2 = L0_2()
  if not L0_2 then
    L0_2 = print
    L1_2 = "^1[unique_phone]^0 Recado: columns missing in the database (expires_at/view_once/archived/locked/disappearing) \226\128\148 the Recado RPCs reply { error = \"db\" } until this is fixed"
    L0_2(L1_2)
    return
  end
  L0_2 = true
  L21_1 = L0_2
  L0_2 = pcall
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT payload FROM apex_phone_messages WHERE app = ? AND view_once = 1 AND deleted_all IS NULL ORDER BY id DESC LIMIT 5000"
  L3_2 = {}
  L4_2 = L0_1
  L3_2[1] = L4_2
  L0_2, L1_2 = L0_2(L1_2, L2_2, L3_2)
  if L0_2 then
    L2_2 = type
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = ipairs
      L3_2 = L1_2
      L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
      for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
        L8_2 = L10_1
        L9_2 = tostring
        L10_2 = L7_2.payload
        if not L10_2 then
          L10_2 = ""
        end
        L9_2 = L9_2(L10_2)
        L10_2 = L9_2
        L9_2 = L9_2.match
        L11_2 = "\"mediaId\"%s*:%s*\"?(%d+)"
        L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2)
        L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
        if L8_2 then
          L9_2 = L22_1
          L9_2[L8_2] = true
        end
      end
    end
  end
  L2_2 = pcall
  L3_2 = EnsureIndex
  L4_2 = "apex_phone_messages"
  L5_2 = "ax_expires"
  L6_2 = {}
  L7_2 = "expires_at"
  L6_2[1] = L7_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = pcall
  L3_2 = EnsureIndex
  L4_2 = "apex_phone_recado_stars"
  L5_2 = "ax_who_created"
  L6_2 = {}
  L7_2 = "who"
  L8_2 = "created"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = pcall
  L3_2 = EnsureIndex
  L4_2 = "apex_phone_recado_pins"
  L5_2 = "ax_message"
  L6_2 = {}
  L7_2 = "message_id"
  L6_2[1] = L7_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
L26_1(L27_1)
function L26_1()
  local L0_2, L1_2, L2_2
  L0_2 = L21_1
  if L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = L21_1
    if L1_2 then
      break
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 5000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 200
    L1_2(L2_2)
  end
  L1_2 = L21_1
  return L1_2
end
L27_1 = false
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L27_1
  if not L2_2 then
    L2_2 = type
    L3_2 = GetIdentity
    L2_2 = L2_2(L3_2)
    if "function" == L2_2 then
      goto lbl_10
    end
  end
  do return end
  ::lbl_10::
  L2_2 = true
  L27_1 = L2_2
  L2_2 = pcall
  L3_2 = GetIdentity
  L4_2 = A0_2
  L5_2 = L0_1
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = tostring
    L5_2 = L3_2 or L5_2
    if not L3_2 then
      L5_2 = ""
    end
    L4_2 = L4_2(L5_2)
    if L4_2 ~= A1_2 then
      L4_2 = print
      L5_2 = "^1[unique_phone]^0 Recado: server/messages.lua does not treat \"recado\" as a phone app (PHONE_APPS) \226\128\148 messages.send/get/read will reply \"noidentity\" until it is added"
      L4_2(L5_2)
    end
  end
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = RPC
  function L3_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = L7_1
    L2_3 = L2_3()
    L2_3 = L2_3.enabled
    if false == L2_3 then
      L2_3 = {}
      L2_3.error = "disabled"
      return L2_3
    end
    L2_3 = L26_1
    L2_3 = L2_3()
    if not L2_3 then
      L2_3 = {}
      L2_3.error = "db"
      return L2_3
    end
    L2_3 = A1_2
    L3_3 = A0_3
    L4_3 = type
    L5_3 = A1_3
    L4_3 = L4_3(L5_3)
    L4_3 = A1_3 or L4_3
    if "table" ~= L4_3 or not A1_3 then
      L4_3 = {}
    end
    return L2_3(L3_3, L4_3)
  end
  L2_2[A0_2] = L3_2
end
L30_1 = {}
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L30_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return L1_2
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT app FROM apex_phone_conversations WHERE id = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 or nil == L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L30_1
  L5_2 = tostring
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L4_2[A0_2] = L5_2
  L4_2 = L30_1
  L4_2 = L4_2[A0_2]
  return L4_2
end
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT role, joined, last_read_id FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 or not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = {}
  L5_2 = L3_2.role
  if "admin" == L5_2 then
    L5_2 = "admin"
    if L5_2 then
      goto lbl_27
    end
  end
  L5_2 = "member"
  ::lbl_27::
  L4_2.role = L5_2
  L5_2 = tonumber
  L6_2 = L3_2.joined
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.joined = L5_2
  L5_2 = L10_1
  L6_2 = L3_2.last_read_id
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.lastReadId = L5_2
  return L4_2
end
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    L2_2 = "target"
    return L1_2, L2_2
  end
  L1_2 = A0_2.conversation
  if nil ~= L1_2 then
    L1_2 = A0_2.conversation
    if false ~= L1_2 then
      L1_2 = A0_2.conversation
      if 0 ~= L1_2 then
        L1_2 = L10_1
        L2_2 = A0_2.conversation
        L1_2 = L1_2(L2_2)
        if not L1_2 then
          L2_2 = nil
          L3_2 = "target"
          return L2_2, L3_2
        end
        L2_2 = {}
        L2_2.conv = L1_2
        return L2_2
      end
    end
  end
  L1_2 = type
  L2_2 = A0_2.number
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = A0_2.number
    L2_2 = L1_2
    L1_2 = L1_2.match
    L3_2 = "^g:(%d+)$"
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      L2_2 = L10_1
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      if L2_2 then
        L3_2 = {}
        L3_2.conv = L2_2
        return L3_2
      end
      L3_2 = nil
      L4_2 = "target"
      return L3_2, L4_2
    end
  end
  L1_2 = L16_1
  L2_2 = A0_2.number
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    L3_2 = "target"
    return L2_2, L3_2
  end
  L2_2 = {}
  L2_2.number = L1_2
  return L2_2
end
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L19_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = "noidentity"
    return L3_2, L4_2
  end
  L3_2 = L33_1
  L4_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2)
  if not L3_2 then
    L5_2 = nil
    L6_2 = L4_2
    return L5_2, L6_2
  end
  L5_2 = L3_2.conv
  if L5_2 then
    L5_2 = L31_1
    L6_2 = L3_2.conv
    L5_2 = L5_2(L6_2)
    L6_2 = L0_1
    if L5_2 ~= L6_2 then
      L5_2 = nil
      L6_2 = "notfound"
      return L5_2, L6_2
    end
    L5_2 = L32_1
    L6_2 = L3_2.conv
    L7_2 = L2_2
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L6_2 = nil
      L7_2 = "notmember"
      return L6_2, L7_2
    end
    L6_2 = {}
    L6_2.me = L2_2
    L7_2 = L3_2.conv
    L6_2.conv = L7_2
    L7_2 = "g:"
    L8_2 = L3_2.conv
    L7_2 = L7_2 .. L8_2
    L6_2.other = L7_2
    L7_2 = "g:"
    L8_2 = L3_2.conv
    L7_2 = L7_2 .. L8_2
    L6_2.key = L7_2
    L7_2 = L5_2.joined
    L6_2.joined = L7_2
    L7_2 = L5_2.role
    L6_2.role = L7_2
    return L6_2
  end
  L5_2 = {}
  L5_2.me = L2_2
  L6_2 = L3_2.number
  L5_2.number = L6_2
  L6_2 = L3_2.number
  L5_2.other = L6_2
  L6_2 = L20_1
  L7_2 = L2_2
  L8_2 = L3_2.number
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.key = L6_2
  return L5_2
end
L35_1 = {}
L35_1.send_policy = true
L35_1.edit_policy = true
function L36_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L5_2 = type
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if "function" ~= L5_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = pcall
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 or false ~= L6_2 then
    L7_2 = true
    return L7_2
  end
  if "admin" ~= A3_2 then
    L7_2 = L35_1
    L7_2 = L7_2[A4_2]
    if L7_2 then
      goto lbl_27
    end
  end
  L7_2 = true
  do return L7_2 end
  ::lbl_27::
  L7_2 = pcall
  L8_2 = MySQL
  L8_2 = L8_2.scalar
  L8_2 = L8_2.await
  L9_2 = "SELECT "
  L10_2 = A4_2
  L11_2 = " FROM apex_phone_conversations WHERE id = ?"
  L9_2 = L9_2 .. L10_2 .. L11_2
  L10_2 = {}
  L11_2 = A1_2
  L10_2[1] = L11_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
  L9_2 = not L7_2 or "admins" ~= L8_2
  return L9_2
end
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT pinned, muted_until, archived, marked_unread, locked, disappearing, cleared_before FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = L0_1
  L8_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 or not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = {}
  L5_2 = tonumber
  L6_2 = L3_2.pinned
  L5_2 = L5_2(L6_2)
  L5_2 = 1 == L5_2
  L4_2.pinned = L5_2
  L5_2 = tonumber
  L6_2 = L3_2.muted_until
  L5_2 = L5_2(L6_2)
  L4_2.mutedUntil = L5_2
  L5_2 = tonumber
  L6_2 = L3_2.archived
  L5_2 = L5_2(L6_2)
  L5_2 = 1 == L5_2
  L4_2.archived = L5_2
  L5_2 = tonumber
  L6_2 = L3_2.marked_unread
  L5_2 = L5_2(L6_2)
  L5_2 = 1 == L5_2
  L4_2.markedUnread = L5_2
  L5_2 = tonumber
  L6_2 = L3_2.locked
  L5_2 = L5_2(L6_2)
  L5_2 = 1 == L5_2
  L4_2.locked = L5_2
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = L3_2.disappearing
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.disappearing = L5_2
  L5_2 = L10_1
  L6_2 = L3_2.cleared_before
  L5_2 = L5_2(L6_2)
  L4_2.clearedBefore = L5_2
  return L4_2
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = A0_2.conv
  if L1_2 then
    L1_2 = pcall
    L2_2 = MySQL
    L2_2 = L2_2.scalar
    L2_2 = L2_2.await
    L3_2 = "SELECT disappearing FROM apex_phone_conversations WHERE id = ?"
    L4_2 = {}
    L5_2 = A0_2.conv
    L4_2[1] = L5_2
    L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      L3_2 = math
      L3_2 = L3_2.tointeger
      L4_2 = tonumber
      L5_2 = L2_2
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = 0
      end
      L3_2 = L3_2(L4_2)
      if L3_2 then
        goto lbl_31
      end
      L3_2 = 0
      if L3_2 then
        goto lbl_31
      end
    end
    L3_2 = 0
    ::lbl_31::
    return L3_2
  end
  L1_2 = L37_1
  L2_2 = A0_2.me
  L3_2 = A0_2.number
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L1_2.disappearing
    if L2_2 then
      goto lbl_42
    end
  end
  L2_2 = 0
  ::lbl_42::
  return L2_2
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if nil == L1_2 then
    L2_2 = nil
    return L2_2
  end
  if 0 == L1_2 then
    L2_2 = 0
    return L2_2
  end
  L2_2 = type
  L3_2 = L7_1
  L3_2 = L3_2()
  L3_2 = L3_2.disappearing
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L7_1
    L2_2 = L2_2()
    L2_2 = L2_2.disappearing
    if L2_2 then
      goto lbl_33
    end
  end
  L2_2 = {}
  L3_2 = 86400
  L4_2 = 604800
  L5_2 = 7776000
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  ::lbl_33::
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.tointeger
    L10_2 = tonumber
    L11_2 = L8_2
    L10_2, L11_2 = L10_2(L11_2)
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 == L1_2 then
      return L1_2
    end
  end
  L3_2 = nil
  return L3_2
end
function L40_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil ~= A0_2 then
    L1_2 = type
    L2_2 = RecadoReadReceipts
    L1_2 = L1_2(L2_2)
    if "function" == L1_2 then
      goto lbl_10
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_10::
  L1_2 = pcall
  L2_2 = RecadoReadReceipts
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  L3_2 = L1_2 or L3_2
  L3_2 = L1_2 and false == L2_2
  return L3_2
end
function L41_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2 or A0_2
  if not L1_2 then
    A0_2 = 0
  end
  L1_2 = A0_2 % 86400
  if 0 == L1_2 then
    L1_2 = A0_2 // 86400
    if 1 == L1_2 then
      L2_2 = "24 horas"
      return L2_2
    end
    L2_2 = "%d dias"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = L1_2
    return L2_2(L3_2, L4_2)
  end
  L1_2 = A0_2 % 3600
  if 0 == L1_2 then
    L1_2 = "%d horas"
    L2_2 = L1_2
    L1_2 = L1_2.format
    L3_2 = A0_2 // 3600
    return L1_2(L2_2, L3_2)
  end
  L1_2 = "%d minutos"
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 1
  L5_2 = A0_2 // 60
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  return L1_2(L2_2, L3_2, L4_2, L5_2)
end
L42_1 = {}
function L43_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = type
  L3_2 = Accounts
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = Accounts
    L2_2 = L2_2[L1_2]
    if L2_2 then
      goto lbl_18
    end
  end
  L2_2 = nil
  ::lbl_18::
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L2_2.pin
    L3_2 = nil ~= L3_2
    return L3_2
  end
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT pin FROM apex_phone_accounts WHERE citizenid = ?"
  L6_2 = {}
  L7_2 = L1_2
  L6_2[1] = L7_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = nil ~= L4_2
  return L5_2
end
function L44_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L42_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L3_2 = L1_2.untilT
    if L2_2 <= L3_2 then
      L2_2 = L1_2.cid
      L3_2 = GetCid
      L4_2 = A0_2
      L3_2 = L3_2(L4_2)
      if L2_2 == L3_2 then
        L2_2 = true
        return L2_2
      end
    end
    L2_2 = L42_1
    L2_2[A0_2] = nil
  end
  L2_2 = L43_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = not L2_2
  return L2_2
end
RecadoIsUnlocked = L44_1
L45_1 = AddEventHandler
L46_1 = "apex_phone:phoneClosed"
function L47_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if A0_2 then
    L1_2 = L42_1
    L1_2[A0_2] = nil
  end
end
L45_1(L46_1, L47_1)
L45_1 = {}
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L10_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = L22_1
    L3_2 = L3_2[L2_2]
    if L3_2 then
      goto lbl_12
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_12::
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  if not A0_2 then
    L3_2 = true
    return L3_2
  end
  L3_2 = type
  L4_2 = MediaInfo
  L3_2 = L3_2(L4_2)
  if "function" == L3_2 then
    L3_2 = MediaInfo
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_31
    end
  end
  L3_2 = nil
  ::lbl_31::
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L3_2 and L4_2 then
    L5_2 = L3_2.owner
    if L5_2 == L4_2 then
      L5_2 = false
      return L5_2
    end
  end
  L5_2 = L45_1
  L5_2 = L5_2[A0_2]
  if L5_2 then
    L6_2 = L5_2[L2_2]
    if not L6_2 then
      L6_2 = 0
    end
    L7_2 = GetGameTimer
    L7_2 = L7_2()
    if L6_2 > L7_2 then
      L6_2 = false
      return L6_2
    end
  end
  L6_2 = true
  return L6_2
end
RecadoMediaDenied = L46_1
L46_1 = {}
L46_1.image = "\240\159\147\183 Foto"
L46_1.audio = "\240\159\142\164 Mensagem de voz"
L46_1.location = "\240\159\147\141 Localiza\195\167\195\163o"
L46_1.sticker = "\240\159\143\183\239\184\143 Autocolante"
L46_1.gif = "GIF"
L46_1.poll = "\240\159\147\138 Sondagem"
L46_1.event = "\240\159\147\133 Evento"
L46_1.document = "\240\159\147\132 Documento"
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if not A0_2 then
    L2_2 = ""
    return L2_2
  end
  L2_2 = A0_2.deleted_all
  if nil == L2_2 then
    L2_2 = A0_2.deleted
    if true ~= L2_2 then
      goto lbl_13
    end
  end
  L2_2 = "\240\159\154\171 Mensagem apagada"
  do return L2_2 end
  ::lbl_13::
  L2_2 = A0_2.type
  if not L2_2 then
    L2_2 = "text"
  end
  L3_2 = A1_2 or L3_2
  if not A1_2 then
    L3_2 = L18_1
    L4_2 = A0_2.payload
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = {}
    end
  end
  if "text" == L2_2 then
    L4_2 = L12_1
    L5_2 = tostring
    L6_2 = A0_2.content
    if not L6_2 then
      L6_2 = ""
    end
    L5_2 = L5_2(L6_2)
    L6_2 = L5_2
    L5_2 = L5_2.gsub
    L7_2 = "%s+"
    L8_2 = " "
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    L6_2 = 120
    return L4_2(L5_2, L6_2)
  end
  L4_2 = tonumber
  L5_2 = A0_2.view_once
  L4_2 = L4_2(L5_2)
  if 1 ~= L4_2 then
    L4_2 = A0_2.viewOnce
    if true ~= L4_2 then
      L4_2 = L3_2.viewOnce
    end
  end
  if true == L4_2 and ("image" == L2_2 or "audio" == L2_2) then
    if "image" == L2_2 then
      L4_2 = "\240\159\147\183 Foto"
      if L4_2 then
        goto lbl_63
      end
    end
    L4_2 = "\240\159\142\164 Mensagem de voz"
    ::lbl_63::
    L5_2 = " \194\183 ver uma vez"
    L4_2 = L4_2 .. L5_2
    return L4_2
  end
  if "contact" == L2_2 then
    L4_2 = "\240\159\145\164 "
    L5_2 = L12_1
    L6_2 = A0_2.content
    if "" ~= L6_2 then
      L6_2 = A0_2.content
      if L6_2 then
        goto lbl_80
      end
    end
    L6_2 = L3_2.name
    if not L6_2 then
      L6_2 = "Contacto"
    end
    ::lbl_80::
    L7_2 = 60
    L5_2 = L5_2(L6_2, L7_2)
    L4_2 = L4_2 .. L5_2
    return L4_2
  end
  if "document" == L2_2 then
    L4_2 = "\240\159\147\132 "
    L5_2 = L12_1
    L6_2 = L3_2.title
    if not L6_2 then
      L6_2 = A0_2.content
      if not L6_2 then
        L6_2 = "Documento"
      end
    end
    L7_2 = 80
    L5_2 = L5_2(L6_2, L7_2)
    L4_2 = L4_2 .. L5_2
    return L4_2
  end
  if "call" == L2_2 then
    L4_2 = L3_2.status
    if "missed" == L4_2 then
      L4_2 = L3_2.video
      if L4_2 then
        L4_2 = "\240\159\142\165 Videochamada perdida"
        if L4_2 then
          goto lbl_111
        end
      end
      L4_2 = "\240\159\147\158 Chamada perdida"
      ::lbl_111::
      return L4_2
    end
    L4_2 = L3_2.status
    if "scheduled" == L4_2 then
      L4_2 = "\240\159\151\147\239\184\143 Chamada agendada"
      return L4_2
    end
    L4_2 = L3_2.video
    if L4_2 then
      L4_2 = "\240\159\142\165 Videochamada"
      if L4_2 then
        goto lbl_124
      end
    end
    L4_2 = "\240\159\147\158 Chamada de voz"
    ::lbl_124::
    return L4_2
  end
  if "system" == L2_2 then
    L4_2 = L12_1
    L5_2 = A0_2.content
    if not L5_2 then
      L5_2 = ""
    end
    L6_2 = 120
    return L4_2(L5_2, L6_2)
  end
  L4_2 = L46_1
  L4_2 = L4_2[L2_2]
  if L4_2 then
    if "image" == L2_2 or "poll" == L2_2 or "event" == L2_2 then
      L5_2 = L13_1
      L6_2 = A0_2.content
      if not L6_2 then
        L6_2 = ""
      end
      L5_2 = L5_2(L6_2)
      if L5_2 then
        goto lbl_154
      end
    end
    L5_2 = ""
    ::lbl_154::
    if "" ~= L5_2 then
      L6_2 = L4_2
      L7_2 = " \194\183 "
      L8_2 = L12_1
      L9_2 = L5_2
      L10_2 = 80
      L8_2 = L8_2(L9_2, L10_2)
      L6_2 = L6_2 .. L7_2 .. L8_2
      return L6_2
    end
    return L4_2
  end
  L5_2 = L12_1
  L6_2 = A0_2.content
  if not L6_2 then
    L6_2 = ""
  end
  L7_2 = 120
  return L5_2(L6_2, L7_2)
end
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = {}
  L5_2 = "duration"
  L6_2 = "name"
  L7_2 = "title"
  L8_2 = "pack"
  L9_2 = "id"
  L10_2 = "video"
  L11_2 = "status"
  L12_2 = "action"
  L13_2 = "by"
  L14_2 = "seconds"
  L15_2 = "role"
  L16_2 = "admin"
  L17_2 = "ttl"
  L18_2 = "fwd"
  L19_2 = "pollId"
  L20_2 = "eventId"
  L21_2 = "callId"
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
  L4_2[16] = L20_2
  L4_2[17] = L21_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = A0_2[L8_2]
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "number" ~= L10_2 and "boolean" ~= L10_2 then
      if "string" ~= L10_2 then
        goto lbl_47
      end
      L11_2 = #L9_2
      if not (L11_2 <= 120) then
        goto lbl_47
      end
    end
    L2_2[L8_2] = L9_2
    ::lbl_47::
  end
  L3_2 = type
  L4_2 = A0_2.targets
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.targets
    L3_2 = #L3_2
    if L3_2 <= 40 then
      L3_2 = A0_2.targets
      L2_2.targets = L3_2
    end
  end
  if A1_2 then
    L2_2.viewOnce = true
  end
  L3_2 = next
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L2_2 or L3_2
  if not L3_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
L49_1 = {}
L49_1.text = true
L49_1.image = true
L49_1.audio = true
L49_1.location = true
L49_1.contact = true
L49_1.sticker = true
L49_1.gif = true
L49_1.document = true
L50_1 = {}
L50_1.poll = true
L50_1.event = true
L50_1.call = true
L51_1 = {}
L51_1.text = true
L51_1.image = true
L51_1.audio = true
L51_1.location = true
L51_1.contact = true
L51_1.sticker = true
L51_1.gif = true
L51_1.document = true
function L52_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = type
  L3_2 = L7_1
  L3_2 = L3_2()
  L3_2 = L3_2.stickers
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L7_1
    L2_2 = L2_2()
    L2_2 = L2_2.stickers
    if L2_2 then
      goto lbl_22
    end
  end
  L2_2 = {}
  L3_2 = "basicos"
  L4_2 = "cidade"
  L5_2 = "reacoes"
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  ::lbl_22::
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "string" == L7_2 then
      L0_2[L6_2] = true
    end
  end
  return L0_2
end
function L53_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L7_2 > 64 then
      break
    end
    L9_2 = L16_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L10_2 = L2_2[L9_2]
      if not L10_2 then
        L2_2[L9_2] = true
        L10_2 = #L1_2
        L10_2 = L10_2 + 1
        L1_2[L10_2] = L9_2
      end
    end
  end
  L3_2 = #L1_2
  L3_2 = L1_2 or L3_2
  if not (L3_2 > 0) or not L1_2 then
    L3_2 = nil
  end
  return L3_2
end
function L54_1(A0_2)
  local L1_2, L2_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = A0_2 * 100
  L2_2 = L2_2 + 0.5
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 / 100
  return L1_2
end
L55_1 = {}
L55_1.text = true
L55_1.image = true
L55_1.audio = true
L55_1.sticker = true
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L10_1
  L2_2 = A0_2.id
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = {}
  L2_2.id = L1_2
  L3_2 = L16_1
  L4_2 = A0_2.owner
  L3_2 = L3_2(L4_2)
  L2_2.owner = L3_2
  L4_2 = A0_2.kind
  L3_2 = L55_1
  L3_2 = L3_2[L4_2]
  if L3_2 then
    L3_2 = A0_2.kind
    L2_2.kind = L3_2
  end
  L3_2 = type
  L4_2 = A0_2.bg
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.bg
    L3_2 = #L3_2
    if L3_2 <= 16 then
      L3_2 = A0_2.bg
      L4_2 = L3_2
      L3_2 = L3_2.match
      L5_2 = "^%a+$"
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        L3_2 = A0_2.bg
        L2_2.bg = L3_2
      end
    end
  end
  L3_2 = L15_1
  L4_2 = A0_2.preview
  L5_2 = 90
  L3_2 = L3_2(L4_2, L5_2)
  if "" ~= L3_2 then
    L2_2.preview = L3_2
  end
  return L2_2
end
function L57_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L7_2 = type
  L8_2 = A3_2
  L7_2 = L7_2(L8_2)
  L7_2 = A3_2 or L7_2
  if "table" ~= L7_2 or not A3_2 then
    L7_2 = {}
  end
  L8_2 = type
  L9_2 = RecadoExtrasValidate
  L8_2 = L8_2(L9_2)
  if "function" == L8_2 then
    L8_2 = RecadoExtrasValidate
    if L8_2 then
      goto lbl_19
    end
  end
  L8_2 = nil
  ::lbl_19::
  L9_2 = L50_1
  L9_2 = L9_2[A1_2]
  if L9_2 then
    L9_2 = A5_2.trusted
    if not L9_2 then
      if ("poll" == A1_2 or "event" == A1_2) and L8_2 then
        L9_2 = pcall
        L10_2 = L8_2
        L11_2 = A0_2
        L12_2 = A1_2
        L13_2 = A3_2
        L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
        if L9_2 then
          L12_2 = type
          L13_2 = L10_2
          L12_2 = L12_2(L13_2)
          if "table" == L12_2 then
            goto lbl_52
          end
        end
        L12_2 = nil
        L13_2 = nil
        L14_2 = L11_2 or L14_2
        if not L9_2 or not L11_2 then
          L14_2 = "badtype"
        end
        do return L12_2, L13_2, L14_2 end
        ::lbl_52::
        L12_2 = L14_1
        L13_2 = A2_2
        L14_2 = A6_2.textMax
        L12_2 = L12_2(L13_2, L14_2)
        L13_2 = L10_2
        return L12_2, L13_2
      end
      L9_2 = nil
      L10_2 = nil
      L11_2 = "badtype"
      return L9_2, L10_2, L11_2
    end
    L9_2 = L14_1
    L10_2 = A2_2
    L11_2 = A6_2.textMax
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = type
    L11_2 = A3_2
    L10_2 = L10_2(L11_2)
    L10_2 = A3_2 or L10_2
    if "table" ~= L10_2 or not A3_2 then
      L10_2 = nil
    end
    return L9_2, L10_2
  end
  L9_2 = L49_1
  L9_2 = L9_2[A1_2]
  if not L9_2 then
    L9_2 = nil
    L10_2 = nil
    L11_2 = "badtype"
    return L9_2, L10_2, L11_2
  end
  if L8_2 and ("sticker" == A1_2 or "gif" == A1_2 or "document" == A1_2) then
    if "gif" == A1_2 then
      L9_2 = type
      L10_2 = L7_1
      L10_2 = L10_2()
      L10_2 = L10_2.gif
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = L7_1
        L9_2 = L9_2()
        L9_2 = L9_2.gif
        if L9_2 then
          goto lbl_105
        end
      end
      L9_2 = {}
      ::lbl_105::
      L10_2 = L9_2.provider
      if "tenor" ~= L10_2 then
        L10_2 = nil
        L11_2 = nil
        L12_2 = "nogif"
        return L10_2, L11_2, L12_2
      end
    end
    L9_2 = pcall
    L10_2 = L8_2
    L11_2 = A0_2
    L12_2 = A1_2
    L13_2 = A3_2
    L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
    if L9_2 then
      L12_2 = type
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        goto lbl_131
      end
    end
    L12_2 = nil
    L13_2 = nil
    L14_2 = L11_2 or L14_2
    if not L9_2 or not L11_2 then
      L14_2 = "badpayload"
    end
    do return L12_2, L13_2, L14_2 end
    ::lbl_131::
    if "document" == A1_2 then
      L12_2 = L12_1
      L13_2 = L10_2.title
      if not L13_2 then
        L13_2 = ""
      end
      L14_2 = 80
      L12_2 = L12_2(L13_2, L14_2)
      if L12_2 then
        goto lbl_143
      end
    end
    L12_2 = ""
    ::lbl_143::
    L13_2 = L10_2
    return L12_2, L13_2
  end
  if "text" == A1_2 then
    L9_2 = L14_1
    L10_2 = A2_2
    L11_2 = A6_2.textMax
    L9_2 = L9_2(L10_2, L11_2)
    if "" == L9_2 then
      L10_2 = nil
      L11_2 = nil
      L12_2 = "empty"
      return L10_2, L11_2, L12_2
    end
    L10_2 = {}
    L11_2 = L53_1
    L12_2 = L7_2.mentions
    L11_2 = L11_2(L12_2)
    L10_2.mentions = L11_2
    L11_2 = type
    L12_2 = L7_2.status
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L56_1
      L12_2 = L7_2.status
      L11_2 = L11_2(L12_2)
      L10_2.status = L11_2
    end
    L11_2 = L9_2
    L12_2 = next
    L13_2 = L10_2
    L12_2 = L12_2(L13_2)
    L12_2 = L10_2 or L12_2
    if not L12_2 or not L10_2 then
      L12_2 = nil
    end
    return L11_2, L12_2
  end
  if "image" == A1_2 then
    L9_2 = L10_1
    L10_2 = L7_2.mediaId
    if not L10_2 then
      L10_2 = A4_2.mediaId
    end
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L10_2 = nil
      L11_2 = nil
      L12_2 = "badmedia"
      return L10_2, L11_2, L12_2
    end
    L10_2 = type
    L11_2 = MediaInfo
    L10_2 = L10_2(L11_2)
    if "function" == L10_2 then
      L10_2 = MediaInfo
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if L10_2 then
        goto lbl_205
      end
    end
    L10_2 = nil
    ::lbl_205::
    if L10_2 then
      L11_2 = L10_2.complete
      if L11_2 then
        L11_2 = L10_2.kind
        if "image" == L11_2 then
          goto lbl_216
        end
      end
    end
    L11_2 = nil
    L12_2 = nil
    L13_2 = "badmedia"
    do return L11_2, L12_2, L13_2 end
    ::lbl_216::
    L11_2 = type
    L12_2 = MediaCanRead
    L11_2 = L11_2(L12_2)
    if "function" == L11_2 then
      L11_2 = MediaCanRead
      L12_2 = A0_2
      L13_2 = L9_2
      L11_2 = L11_2(L12_2, L13_2)
      if L11_2 then
        goto lbl_230
      end
    end
    L11_2 = nil
    L12_2 = nil
    L13_2 = "badmedia"
    do return L11_2, L12_2, L13_2 end
    ::lbl_230::
    L11_2 = A4_2.hd
    L11_2 = true == L11_2
    L12_2 = tonumber
    L13_2 = L10_2.size
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    if L11_2 then
      L13_2 = A6_2.hdImageBytes
      if L13_2 then
        goto lbl_250
      end
    end
    L13_2 = A6_2.maxImageBytes
    ::lbl_250::
    L13_2 = L13_2 + 64
    if L12_2 > L13_2 then
      L12_2 = nil
      L13_2 = nil
      L14_2 = "toolarge"
      return L12_2, L13_2, L14_2
    end
    L12_2 = {}
    L12_2.mediaId = L9_2
    if L11_2 then
      L12_2.hd = true
    end
    L13_2 = type
    L14_2 = L7_2.album
    L13_2 = L13_2(L14_2)
    if "string" == L13_2 then
      L13_2 = L7_2.album
      L14_2 = L13_2
      L13_2 = L13_2.match
      L15_2 = "^[%w%-]+$"
      L13_2 = L13_2(L14_2, L15_2)
      if L13_2 then
        L13_2 = L7_2.album
        L13_2 = #L13_2
        if L13_2 >= 4 then
          L13_2 = L7_2.album
          L13_2 = #L13_2
          if L13_2 <= 24 then
            L13_2 = L7_2.album
            L12_2.album = L13_2
            L13_2 = L8_1
            L14_2 = L7_2.albumIndex
            L15_2 = 1
            L16_2 = 1
            L17_2 = A6_2.multiImageMax
            L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
            L12_2.albumIndex = L13_2
            L13_2 = L8_1
            L14_2 = L7_2.albumCount
            L15_2 = 1
            L16_2 = 1
            L17_2 = A6_2.multiImageMax
            L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
            L12_2.albumCount = L13_2
          end
        end
      end
    end
    L13_2 = math
    L13_2 = L13_2.tointeger
    L14_2 = tonumber
    L15_2 = L7_2.w
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
    L14_2 = math
    L14_2 = L14_2.tointeger
    L15_2 = tonumber
    L16_2 = L7_2.h
    L15_2, L16_2, L17_2 = L15_2(L16_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2)
    if L13_2 and L14_2 and L13_2 > 0 and L14_2 > 0 then
      L15_2 = 8192
      if L13_2 <= L15_2 then
        L15_2 = 8192
        if L14_2 <= L15_2 then
          L15_2 = L13_2
          L12_2.h = L14_2
          L12_2.w = L15_2
        end
      end
    end
    L15_2 = L53_1
    L16_2 = L7_2.mentions
    L15_2 = L15_2(L16_2)
    L12_2.mentions = L15_2
    L15_2 = L14_1
    L16_2 = A2_2
    L17_2 = A6_2.captionMax
    L15_2 = L15_2(L16_2, L17_2)
    L16_2 = L12_2
    return L15_2, L16_2
  end
  if "audio" == A1_2 then
    L9_2 = L10_1
    L10_2 = L7_2.mediaId
    if not L10_2 then
      L10_2 = A4_2.mediaId
    end
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L10_2 = nil
      L11_2 = nil
      L12_2 = "badmedia"
      return L10_2, L11_2, L12_2
    end
    L10_2 = ""
    L11_2 = {}
    L11_2.mediaId = L9_2
    L12_2 = tonumber
    L13_2 = L7_2.duration
    L12_2 = L12_2(L13_2)
    L11_2.duration = L12_2
    L12_2 = type
    L13_2 = L7_2.waveform
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = L7_2.waveform
      if L12_2 then
        goto lbl_367
      end
    end
    L12_2 = nil
    ::lbl_367::
    L11_2.waveform = L12_2
    return L10_2, L11_2
  end
  if "location" == A1_2 then
    L9_2 = tonumber
    L10_2 = L7_2.x
    L9_2 = L9_2(L10_2)
    L10_2 = tonumber
    L11_2 = L7_2.y
    L10_2 = L10_2(L11_2)
    L11_2 = tonumber
    L12_2 = L7_2.z
    L11_2 = L11_2(L12_2)
    if L9_2 and L10_2 and L9_2 == L9_2 and L10_2 == L10_2 then
      L12_2 = math
      L12_2 = L12_2.abs
      L13_2 = L9_2
      L12_2 = L12_2(L13_2)
      L13_2 = 20000
      if not (L12_2 > L13_2) then
        L12_2 = math
        L12_2 = L12_2.abs
        L13_2 = L10_2
        L12_2 = L12_2(L13_2)
        L13_2 = 20000
        if not (L12_2 > L13_2) then
          goto lbl_405
        end
      end
    end
    L12_2 = nil
    L13_2 = nil
    L14_2 = "badpayload"
    do return L12_2, L13_2, L14_2 end
    ::lbl_405::
    L12_2 = {}
    L13_2 = L54_1
    L14_2 = L9_2
    L13_2 = L13_2(L14_2)
    L12_2.x = L13_2
    L13_2 = L54_1
    L14_2 = L10_2
    L13_2 = L13_2(L14_2)
    L12_2.y = L13_2
    if L11_2 and L11_2 == L11_2 then
      L13_2 = math
      L13_2 = L13_2.abs
      L14_2 = L11_2
      L13_2 = L13_2(L14_2)
      L14_2 = 5000
      if L13_2 < L14_2 then
        L13_2 = L54_1
        L14_2 = L11_2
        L13_2 = L13_2(L14_2)
        L12_2.z = L13_2
      end
    end
    L13_2 = L15_1
    L14_2 = L7_2.label
    L15_2 = 60
    L13_2 = L13_2(L14_2, L15_2)
    if "" ~= L13_2 then
      L12_2.label = L13_2
    end
    L14_2 = L13_2
    L15_2 = L12_2
    return L14_2, L15_2
  end
  if "contact" == A1_2 then
    L9_2 = L16_1
    L10_2 = L7_2.number
    L9_2 = L9_2(L10_2)
    L10_2 = L15_1
    L11_2 = L7_2.name
    L12_2 = 64
    L10_2 = L10_2(L11_2, L12_2)
    if not L9_2 or "" == L10_2 then
      L11_2 = nil
      L12_2 = nil
      L13_2 = "badpayload"
      return L11_2, L12_2, L13_2
    end
    L11_2 = L10_2
    L12_2 = {}
    L12_2.name = L10_2
    L12_2.number = L9_2
    return L11_2, L12_2
  end
  if "sticker" == A1_2 then
    L9_2 = type
    L10_2 = L7_2.pack
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L7_2.pack
      if L9_2 then
        goto lbl_473
      end
    end
    L9_2 = ""
    ::lbl_473::
    L10_2 = type
    L11_2 = L7_2.id
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L10_2 = L7_2.id
      L11_2 = L10_2
      L10_2 = L10_2.match
      L12_2 = "^[%w_%-]+$"
      L10_2 = L10_2(L11_2, L12_2)
      if L10_2 then
        goto lbl_485
      end
    end
    L10_2 = nil
    ::lbl_485::
    L11_2 = L52_1
    L11_2 = L11_2()
    L11_2 = L11_2[L9_2]
    if L11_2 and L10_2 then
      L11_2 = #L10_2
      if not (L11_2 > 24) then
        goto lbl_498
      end
    end
    L11_2 = nil
    L12_2 = nil
    L13_2 = "badpayload"
    do return L11_2, L12_2, L13_2 end
    ::lbl_498::
    L11_2 = ""
    L12_2 = {}
    L12_2.pack = L9_2
    L12_2.id = L10_2
    return L11_2, L12_2
  end
  if "gif" == A1_2 then
    L9_2 = type
    L10_2 = L7_1
    L10_2 = L10_2()
    L10_2 = L10_2.gif
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L7_1
      L9_2 = L9_2()
      L9_2 = L9_2.gif
      if L9_2 then
        goto lbl_520
      end
    end
    L9_2 = {}
    ::lbl_520::
    L10_2 = L9_2.provider
    if "tenor" ~= L10_2 then
      L10_2 = nil
      L11_2 = nil
      L12_2 = "nogif"
      return L10_2, L11_2, L12_2
    end
    L10_2 = type
    L11_2 = L7_2.url
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L10_2 = L7_2.url
      if L10_2 then
        goto lbl_535
      end
    end
    L10_2 = ""
    ::lbl_535::
    L11_2 = #L10_2
    L12_2 = 400
    if not (L11_2 > L12_2) then
      L12_2 = L10_2
      L11_2 = L10_2.match
      L13_2 = "^https://media%d*%.tenor%.com/[%w%-%._~/%%]+$"
      L11_2 = L11_2(L12_2, L13_2)
      if L11_2 then
        goto lbl_547
      end
    end
    L11_2 = nil
    L12_2 = nil
    L13_2 = "badpayload"
    do return L11_2, L12_2, L13_2 end
    ::lbl_547::
    L11_2 = ""
    L12_2 = {}
    L12_2.url = L10_2
    L13_2 = L8_1
    L14_2 = L7_2.w
    L15_2 = 0
    L16_2 = 0
    L17_2 = 4096
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
    L12_2.w = L13_2
    L13_2 = L8_1
    L14_2 = L7_2.h
    L15_2 = 0
    L16_2 = 0
    L17_2 = 4096
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
    L12_2.h = L13_2
    return L11_2, L12_2
  end
  if "document" == A1_2 then
    L9_2 = L15_1
    L10_2 = L7_2.title
    L11_2 = 80
    L9_2 = L9_2(L10_2, L11_2)
    if "" == L9_2 then
      L10_2 = nil
      L11_2 = nil
      L12_2 = "badpayload"
      return L10_2, L11_2, L12_2
    end
    L10_2 = L9_2
    L11_2 = {}
    L11_2.title = L9_2
    L12_2 = L14_1
    L13_2 = L7_2.body
    L14_2 = A6_2.textMax
    L12_2 = L12_2(L13_2, L14_2)
    L11_2.body = L12_2
    return L10_2, L11_2
  end
  L9_2 = nil
  L10_2 = nil
  L11_2 = "badtype"
  return L9_2, L10_2, L11_2
end
function L58_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L0_1
  A2_2.app = L3_2
  L3_2 = A1_2.conv
  if L3_2 then
    L3_2 = A1_2.conv
    A2_2.conversation = L3_2
    L3_2 = type
    L4_2 = GroupBroadcast
    L3_2 = L3_2(L4_2)
    if "function" == L3_2 then
      L3_2 = pcall
      L4_2 = GroupBroadcast
      L5_2 = A1_2.conv
      L6_2 = "messageUpdate"
      L7_2 = A2_2
      L8_2 = A1_2.me
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    end
    return
  end
  L3_2 = A1_2.number
  L4_2 = A1_2.me
  if L3_2 == L4_2 then
    return
  end
  L3_2 = GetSrcByNumber
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  if L3_2 and L3_2 ~= A0_2 then
    L4_2 = HasPhoneItem
    if not L4_2 then
      goto lbl_42
    end
    L4_2 = HasPhoneItem
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_42
    end
  end
  do return end
  ::lbl_42::
  L4_2 = GetCid
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = IsBlocked
    L6_2 = L4_2
    L7_2 = A1_2.me
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      return
    end
  end
  L5_2 = A1_2.me
  A2_2.number = L5_2
  L5_2 = Push
  L6_2 = L3_2
  L7_2 = "messageUpdate"
  L8_2 = A2_2
  L5_2(L6_2, L7_2, L8_2)
end
function L59_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO apex_phone_thread_meta (owner, app, other, disappearing, pinned) VALUES (?, ?, ?, ?, 0) ON DUPLICATE KEY UPDATE disappearing = VALUES(disappearing)"
  L5_2 = {}
  L6_2 = A0_2.me
  L7_2 = L0_1
  L8_2 = A0_2.number
  L9_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = A0_2.number
  L4_2 = A0_2.me
  if L3_2 ~= L4_2 then
    L3_2 = pcall
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "INSERT INTO apex_phone_thread_meta (owner, app, other, disappearing, pinned) VALUES (?, ?, ?, ?, 0) ON DUPLICATE KEY UPDATE disappearing = VALUES(disappearing)"
    L6_2 = {}
    L7_2 = A0_2.number
    L8_2 = L0_1
    L9_2 = A0_2.me
    L10_2 = A1_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L6_2[4] = L10_2
    L3_2(L4_2, L5_2, L6_2)
  end
  L3_2 = true
  return L3_2
end
L60_1 = {}
function L61_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = A1_2.conv
  if not L2_2 then
    L2_2 = A1_2.number
    L3_2 = A1_2.me
    if L2_2 ~= L3_2 then
      L3_2 = A1_2.key
      L2_2 = L60_1
      L2_2 = L2_2[L3_2]
      if not L2_2 then
        L2_2 = type
        L3_2 = RecadoDefaultDisappearing
        L2_2 = L2_2(L3_2)
        if "function" == L2_2 then
          goto lbl_20
        end
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_20::
  L3_2 = A1_2.key
  L2_2 = L60_1
  L2_2[L3_2] = true
  L2_2 = pcall
  L3_2 = RecadoDefaultDisappearing
  L4_2 = A1_2.me
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L4_2 = L39_1
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_35
      L3_2 = L4_2 or L3_2
    end
  end
  L3_2 = nil
  ::lbl_35::
  if not L3_2 or 0 == L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT disappearing FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
  L7_2 = {}
  L8_2 = A1_2.me
  L9_2 = L0_1
  L10_2 = A1_2.number
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 or nil ~= L5_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.scalar
  L7_2 = L7_2.await
  L8_2 = "SELECT 1 FROM apex_phone_messages WHERE app = ? AND conversation_id IS NULL AND ((sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)) LIMIT 1"
  L9_2 = {}
  L10_2 = L0_1
  L11_2 = A1_2.me
  L12_2 = A1_2.number
  L13_2 = A1_2.number
  L14_2 = A1_2.me
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 or nil ~= L7_2 then
    L8_2 = nil
    return L8_2
  end
  L8_2 = L59_1
  L9_2 = A1_2
  L10_2 = L3_2
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = nil
    return L8_2
  end
  L8_2 = RecadoSystemMessage
  if L8_2 then
    L8_2 = RecadoSystemMessage
    L9_2 = A0_2
    L10_2 = A1_2
    L11_2 = "disappearing"
    L12_2 = "Mensagens tempor\195\161rias ativadas: %s"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L41_1
    L15_2 = L3_2
    L14_2, L15_2 = L14_2(L15_2)
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    L13_2 = {}
    L13_2.seconds = L3_2
    L13_2.default = true
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  end
  return L3_2
end
function L62_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 or not A2_2 then
    L4_2 = {}
    A2_2 = L4_2
  end
  L4_2 = type
  L5_2 = A3_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 or not A3_2 then
    L4_2 = {}
    A3_2 = L4_2
  end
  if not A0_2 then
    L4_2 = nil
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = L34_1
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L6_2 = nil
    L7_2 = L5_2
    return L6_2, L7_2
  end
  L6_2 = L28_1
  L7_2 = A0_2
  L8_2 = L4_2.me
  L6_2(L7_2, L8_2)
  L6_2 = L9_1
  L6_2 = L6_2()
  L7_2 = type
  L8_2 = A2_2.type
  L7_2 = L7_2(L8_2)
  if "string" == L7_2 then
    L7_2 = A2_2.type
    L8_2 = L7_2
    L7_2 = L7_2.sub
    L9_2 = 1
    L10_2 = 16
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 then
      goto lbl_58
    end
  end
  L7_2 = "text"
  ::lbl_58::
  if "" == L7_2 then
    L7_2 = "text"
  end
  L9_2 = L7_2
  L8_2 = L7_2.match
  L10_2 = "^[%w_%-]+$"
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 or "system" == L7_2 then
    L8_2 = nil
    L9_2 = "badtype"
    return L8_2, L9_2
  end
  L8_2 = L4_2.conv
  if L8_2 then
    L8_2 = L36_1
    L9_2 = RecadoGroupCanSend
    L10_2 = L4_2.conv
    L11_2 = L4_2.me
    L12_2 = L4_2.role
    L13_2 = "send_policy"
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    if not L8_2 then
      L8_2 = nil
      L9_2 = "adminsonly"
      return L8_2, L9_2
    end
  end
  L8_2 = L4_2.number
  if L8_2 then
    L8_2 = L4_2.number
    L9_2 = L4_2.me
    if L8_2 ~= L9_2 then
      L8_2 = GetCid
      L9_2 = A0_2
      L8_2 = L8_2(L9_2)
      if L8_2 then
        L9_2 = IsBlocked
        L10_2 = L8_2
        L11_2 = L4_2.number
        L9_2 = L9_2(L10_2, L11_2)
        if L9_2 then
          L9_2 = nil
          L10_2 = "blocked"
          return L9_2, L10_2
        end
      end
    end
  end
  L8_2 = L57_1
  L9_2 = A0_2
  L10_2 = L7_2
  L11_2 = A2_2.content
  L12_2 = A2_2.payload
  L13_2 = A2_2
  L14_2 = A3_2
  L15_2 = L6_2
  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  if L10_2 then
    L11_2 = nil
    L12_2 = L10_2
    return L11_2, L12_2
  end
  L11_2 = A2_2.viewOnce
  L11_2 = true == L11_2 and ("image" == L7_2 or "audio" == L7_2)
  L12_2 = A2_2.forwarded
  L12_2 = true == L12_2
  L13_2 = nil
  L14_2 = A2_2.replyTo
  if nil ~= L14_2 then
    L14_2 = A2_2.replyTo
    if false ~= L14_2 then
      L14_2 = A2_2.replyTo
      if 0 ~= L14_2 then
        L14_2 = L10_1
        L15_2 = type
        L16_2 = A2_2.replyTo
        L15_2 = L15_2(L16_2)
        if "table" == L15_2 then
          L15_2 = A2_2.replyTo
          L15_2 = L15_2.id
          if L15_2 then
            goto lbl_156
          end
        end
        L15_2 = A2_2.replyTo
        ::lbl_156::
        L14_2 = L14_2(L15_2)
        L13_2 = L14_2
        if not L13_2 then
          L14_2 = nil
          L15_2 = "badreply"
          return L14_2, L15_2
        end
      end
    end
  end
  if L9_2 then
    L14_2 = L10_1
    L15_2 = L9_2.mediaId
    L14_2 = L14_2(L15_2)
    if L14_2 then
      goto lbl_171
    end
  end
  L14_2 = nil
  ::lbl_171::
  if L14_2 then
    L15_2 = L22_1
    L15_2 = L15_2[L14_2]
    if L15_2 then
      L15_2 = nil
      L16_2 = "badmedia"
      return L15_2, L16_2
    end
  end
  if L11_2 then
    if L14_2 then
      L15_2 = type
      L16_2 = MediaInfo
      L15_2 = L15_2(L16_2)
      if "function" == L15_2 then
        L15_2 = MediaInfo
        L16_2 = L14_2
        L15_2 = L15_2(L16_2)
        if L15_2 then
          goto lbl_195
        end
      end
    end
    L15_2 = nil
    ::lbl_195::
    L16_2 = GetCid
    L17_2 = A0_2
    L16_2 = L16_2(L17_2)
    if L15_2 and L16_2 then
      L17_2 = L15_2.owner
      if L17_2 == L16_2 then
        goto lbl_208
      end
    end
    L17_2 = nil
    L18_2 = "badmedia"
    do return L17_2, L18_2 end
    ::lbl_208::
    L17_2 = L22_1
    L17_2[L14_2] = true
  end
  function L15_2(A0_3)
    local L1_3, L2_3
    L1_3 = L11_2
    if L1_3 then
      L1_3 = L14_2
      if L1_3 then
        L2_3 = L14_2
        L1_3 = L22_1
        L1_3[L2_3] = nil
      end
    end
    L1_3 = nil
    L2_3 = A0_3
    return L1_3, L2_3
  end
  L16_2 = L61_1
  L17_2 = A0_2
  L18_2 = L4_2
  L16_2 = L16_2(L17_2, L18_2)
  if not L16_2 then
    L16_2 = L38_1
    L17_2 = L4_2
    L16_2 = L16_2(L17_2)
  end
  if L11_2 or L12_2 or L16_2 > 0 then
    if not L9_2 then
      L17_2 = {}
      L9_2 = L17_2
    end
    if L11_2 then
      L9_2.viewOnce = true
    end
    if L12_2 then
      L9_2.fwd = true
    end
    if L16_2 > 0 then
      L9_2.ttl = L16_2
    end
  end
  L17_2 = {}
  L18_2 = L0_1
  L17_2.app = L18_2
  L17_2.type = L7_2
  L17_2.content = L8_2
  L17_2.payload = L9_2
  L17_2.replyTo = L13_2
  L17_2.mediaId = L14_2
  L18_2 = MessagesRecadoKey
  L17_2._via = L18_2
  L18_2 = L4_2.conv
  if L18_2 then
    L18_2 = L4_2.conv
    L17_2.conversation = L18_2
  else
    L18_2 = L4_2.number
    L17_2.to = L18_2
  end
  L18_2 = RPC
  L18_2 = L18_2["messages.send"]
  L19_2 = type
  L20_2 = L18_2
  L19_2 = L19_2(L20_2)
  if "function" ~= L19_2 then
    L19_2 = L15_2
    L20_2 = "internal"
    return L19_2(L20_2)
  end
  L19_2 = pcall
  L20_2 = L18_2
  L21_2 = A0_2
  L22_2 = L17_2
  L19_2, L20_2 = L19_2(L20_2, L21_2, L22_2)
  if not L19_2 then
    L21_2 = print
    L22_2 = "^1[unique_phone]^0 Recado: messages.send crashed (%s)"
    L23_2 = L22_2
    L22_2 = L22_2.format
    L24_2 = tostring
    L25_2 = L20_2
    L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L24_2(L25_2)
    L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L22_2(L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2)
    L21_2(L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2)
    L21_2 = L15_2
    L22_2 = "internal"
    return L21_2(L22_2)
  end
  L21_2 = type
  L22_2 = L20_2
  L21_2 = L21_2(L22_2)
  if "table" ~= L21_2 then
    L21_2 = L15_2
    L22_2 = "internal"
    return L21_2(L22_2)
  end
  L21_2 = L20_2.error
  if L21_2 then
    L21_2 = L15_2
    L22_2 = tostring
    L23_2 = L20_2.error
    L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L22_2(L23_2)
    return L21_2(L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2)
  end
  L21_2 = L10_1
  L22_2 = L20_2.id
  L21_2 = L21_2(L22_2)
  if not L21_2 then
    L22_2 = L15_2
    L23_2 = "db"
    return L22_2(L23_2)
  end
  if "text" == L7_2 then
    L22_2 = tostring
    L23_2 = L20_2.content
    if not L23_2 then
      L23_2 = ""
    end
    L22_2 = L22_2(L23_2)
    L22_2 = #L22_2
    L23_2 = #L8_2
    if L22_2 < L23_2 then
      L22_2 = Dbg
      L23_2 = "recado"
      L24_2 = "message %s truncated by messages.send (%d \226\134\146 %d bytes): the limit needs raising for Recado"
      L25_2 = L21_2
      L26_2 = #L8_2
      L27_2 = tostring
      L28_2 = L20_2.content
      if not L28_2 then
        L28_2 = ""
      end
      L27_2 = L27_2(L28_2)
      L27_2 = #L27_2
      L22_2(L23_2, L24_2, L25_2, L26_2, L27_2)
    end
  end
  L22_2 = tonumber
  L23_2 = L20_2.created
  L22_2 = L22_2(L23_2)
  if not L22_2 then
    L22_2 = Now
    L22_2 = L22_2()
  end
  if L16_2 > 0 then
    L23_2 = L16_2 * 1000
    L23_2 = L22_2 + L23_2
    if L23_2 then
      goto lbl_357
    end
  end
  L23_2 = nil
  ::lbl_357::
  L24_2 = {}
  L25_2 = {}
  if L23_2 then
    L26_2 = #L24_2
    L26_2 = L26_2 + 1
    L24_2[L26_2] = "expires_at = ?"
    L26_2 = #L25_2
    L26_2 = L26_2 + 1
    L25_2[L26_2] = L23_2
  end
  if L11_2 then
    L26_2 = #L24_2
    L26_2 = L26_2 + 1
    L24_2[L26_2] = "view_once = 1"
  end
  if L12_2 then
    L26_2 = #L24_2
    L26_2 = L26_2 + 1
    L24_2[L26_2] = "forwarded = 1"
  end
  L26_2 = #L24_2
  if L26_2 > 0 then
    L26_2 = #L25_2
    L26_2 = L26_2 + 1
    L25_2[L26_2] = L21_2
    L26_2 = #L25_2
    L26_2 = L26_2 + 1
    L27_2 = L4_2.me
    L25_2[L26_2] = L27_2
    L26_2 = pcall
    L27_2 = MySQL
    L27_2 = L27_2.update
    L27_2 = L27_2.await
    L28_2 = "UPDATE apex_phone_messages SET "
    L29_2 = table
    L29_2 = L29_2.concat
    L30_2 = L24_2
    L31_2 = ", "
    L29_2 = L29_2(L30_2, L31_2)
    L30_2 = " WHERE id = ? AND sender = ?"
    L28_2 = L28_2 .. L29_2 .. L30_2
    L29_2 = L25_2
    L26_2(L27_2, L28_2, L29_2)
  end
  L26_2 = type
  L27_2 = L20_2.payload
  L26_2 = L26_2(L27_2)
  if "table" == L26_2 then
    L26_2 = L20_2.payload
    if L26_2 then
      goto lbl_418
    end
  end
  L26_2 = nil
  ::lbl_418::
  if L9_2 and L26_2 then
    local jf437 = false
    if L11_2 then
      L27_2 = L26_2.viewOnce
      if true ~= L27_2 then
        jf437 = true
      end
    end
    if not jf437 and L12_2 then
      L27_2 = L26_2.fwd
      if true ~= L27_2 then
        jf437 = true
      end
    end
    if not jf437 and L16_2 > 0 then
      L27_2 = L26_2.ttl
      if L27_2 ~= L16_2 then
        jf437 = true
      end
    end
    if jf437 then
      if true then
        if L11_2 then
          L26_2.viewOnce = true
        end
        if L12_2 then
          L26_2.fwd = true
        end
        if L16_2 > 0 then
          L26_2.ttl = L16_2
        end
        L27_2 = pcall
        L28_2 = json
        L28_2 = L28_2.encode
        L29_2 = L26_2
        L27_2, L28_2 = L27_2(L28_2, L29_2)
        if L27_2 then
          L29_2 = pcall
          L30_2 = MySQL
          L30_2 = L30_2.update
          L30_2 = L30_2.await
          L31_2 = "UPDATE apex_phone_messages SET payload = ? WHERE id = ? AND sender = ?"
          L32_2 = {}
          L33_2 = L28_2
          L34_2 = L21_2
          L35_2 = L4_2.me
          L32_2[1] = L33_2
          L32_2[2] = L34_2
          L32_2[3] = L35_2
          L29_2(L30_2, L31_2, L32_2)
        end
        L29_2 = L58_1
        L30_2 = A0_2
        L31_2 = L4_2
        L32_2 = {}
        L32_2.id = L21_2
        L33_2 = L11_2 or L33_2
        if not L11_2 then
          L33_2 = nil
        end
        L32_2.viewOnce = L33_2
        L33_2 = L12_2 or L33_2
        if not L12_2 then
          L33_2 = nil
        end
        L32_2.forwarded = L33_2
        L32_2.expiresAt = L23_2
        L29_2(L30_2, L31_2, L32_2)
      end
    end
  end
  L20_2.expiresAt = L23_2
  L27_2 = L11_2 or L27_2
  if not L11_2 then
    L27_2 = nil
  end
  L20_2.viewOnce = L27_2
  L27_2 = L12_2 or L27_2
  if not L12_2 then
    L27_2 = nil
  end
  L20_2.forwarded = L27_2
  L27_2 = false
  L20_2.pinned = false
  L20_2.starred = L27_2
  if L11_2 then
    L27_2 = {}
    L27_2.viewOnce = true
    if L26_2 then
      L28_2 = L26_2.duration
      if L28_2 then
        goto lbl_504
      end
    end
    L28_2 = nil
    ::lbl_504::
    L27_2.duration = L28_2
    L20_2.payload = L27_2
    L20_2.content = ""
    L20_2.viewed = false
  end
  return L20_2
end
RecadoSend = L62_1
function L62_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2
  L5_2 = A1_2
  L6_2 = type
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A1_2.me
    if L6_2 then
      goto lbl_22
    end
  end
  L6_2 = nil
  L7_2 = L34_1
  L8_2 = A0_2
  L9_2 = A1_2
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  L6_2 = L8_2
  L5_2 = L7_2
  if not L5_2 then
    L7_2 = nil
    L8_2 = L6_2
    return L7_2, L8_2
  end
  ::lbl_22::
  L6_2 = {}
  L7_2 = tostring
  L8_2 = A2_2 or L8_2
  if not A2_2 then
    L8_2 = "info"
  end
  L7_2 = L7_2(L8_2)
  L8_2 = L7_2
  L7_2 = L7_2.sub
  L9_2 = 1
  L10_2 = 24
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.action = L7_2
  L7_2 = L5_2.me
  L6_2.by = L7_2
  L7_2 = type
  L8_2 = A4_2
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = pairs
    L8_2 = A4_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L6_2[L11_2] = L12_2
    end
  end
  L7_2 = pcall
  L8_2 = json
  L8_2 = L8_2.encode
  L9_2 = L6_2
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  L9_2 = L12_1
  L10_2 = A3_2
  L11_2 = 255
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = Now
  L10_2 = L10_2()
  L11_2 = L5_2.conv
  if L11_2 then
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.insert
    L12_2 = L12_2.await
    L13_2 = "INSERT INTO apex_phone_messages (app, sender, receiver, type, content, payload, `read`, created, conversation_id) VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?)"
    L14_2 = {}
    L15_2 = L0_1
    L16_2 = L5_2.me
    L17_2 = "g:"
    L18_2 = L5_2.conv
    L17_2 = L17_2 .. L18_2
    L18_2 = "system"
    L19_2 = L9_2
    L20_2 = L8_2 or L20_2
    if not L7_2 or not L8_2 then
      L20_2 = nil
    end
    L21_2 = L10_2
    L22_2 = L5_2.conv
    L14_2[1] = L15_2
    L14_2[2] = L16_2
    L14_2[3] = L17_2
    L14_2[4] = L18_2
    L14_2[5] = L19_2
    L14_2[6] = L20_2
    L14_2[7] = L21_2
    L14_2[8] = L22_2
    L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
    if L11_2 then
      L13_2 = L10_1
      L14_2 = L12_2
      L13_2 = L13_2(L14_2)
      if L13_2 then
        goto lbl_94
        L12_2 = L13_2 or L12_2
      end
    end
    L12_2 = nil
    ::lbl_94::
    if not L12_2 then
      L13_2 = nil
      L14_2 = "db"
      return L13_2, L14_2
    end
    L13_2 = pcall
    L14_2 = MySQL
    L14_2 = L14_2.update
    L14_2 = L14_2.await
    L15_2 = "UPDATE apex_phone_conversations SET last_id = ? WHERE id = ? AND (last_id IS NULL OR last_id < ?)"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L5_2.conv
    L19_2 = L12_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L16_2[3] = L19_2
    L13_2(L14_2, L15_2, L16_2)
    L13_2 = pcall
    L14_2 = MySQL
    L14_2 = L14_2.update
    L14_2 = L14_2.await
    L15_2 = "UPDATE apex_phone_conversation_members SET last_read_id = ? WHERE conversation_id = ? AND member = ? AND (last_read_id IS NULL OR last_read_id < ?)"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L5_2.conv
    L19_2 = L5_2.me
    L20_2 = L12_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L16_2[3] = L19_2
    L16_2[4] = L20_2
    L13_2(L14_2, L15_2, L16_2)
    L13_2 = nil
    L14_2 = type
    L15_2 = GroupInfo
    L14_2 = L14_2(L15_2)
    if "function" == L14_2 then
      L14_2 = pcall
      L15_2 = GroupInfo
      L16_2 = L5_2.conv
      L14_2, L15_2 = L14_2(L15_2, L16_2)
      if L14_2 and L15_2 then
        L16_2 = L15_2.title
        if L16_2 then
          goto lbl_142
          L13_2 = L16_2 or L13_2
        end
      end
      L13_2 = nil
    end
    ::lbl_142::
    L14_2 = {}
    L14_2.id = L12_2
    L15_2 = L0_1
    L14_2.app = L15_2
    L15_2 = L5_2.me
    L14_2.sender = L15_2
    L15_2 = "g:"
    L16_2 = L5_2.conv
    L15_2 = L15_2 .. L16_2
    L14_2.receiver = L15_2
    L14_2.type = "system"
    L14_2.content = L9_2
    L14_2.payload = L6_2
    L14_2.read = false
    L14_2.created = L10_2
    L15_2 = L5_2.conv
    L14_2.conversation = L15_2
    L15_2 = {}
    L16_2 = L5_2.conv
    L15_2.id = L16_2
    L15_2.title = L13_2
    L14_2.group = L15_2
    L15_2 = type
    L16_2 = GroupBroadcast
    L15_2 = L15_2(L16_2)
    if "function" == L15_2 then
      L15_2 = pcall
      L16_2 = GroupBroadcast
      L17_2 = L5_2.conv
      L18_2 = "message"
      L19_2 = L14_2
      L20_2 = L5_2.me
      L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
    end
    return L14_2
  end
  L11_2 = L5_2.number
  L12_2 = L5_2.me
  if L11_2 ~= L12_2 then
    L11_2 = GetSrcByNumber
    L12_2 = L5_2.number
    L11_2 = L11_2(L12_2)
    if L11_2 then
      goto lbl_189
    end
  end
  L11_2 = nil
  ::lbl_189::
  if L11_2 then
    L12_2 = GetCid
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      goto lbl_207
    end
  end
  L12_2 = type
  L13_2 = GetCitizenIdByNumber
  L12_2 = L12_2(L13_2)
  if "function" == L12_2 then
    L12_2 = GetCitizenIdByNumber
    L13_2 = L5_2.number
    L12_2 = L12_2(L13_2)
    if L12_2 then
      goto lbl_207
    end
  end
  L12_2 = nil
  ::lbl_207::
  L13_2 = IsBlocked
  L14_2 = L12_2
  L15_2 = L5_2.me
  L13_2 = nil ~= L12_2 and L13_2
  L14_2 = HasPhoneItem
  L14_2 = HasPhoneItem
  L15_2 = L11_2
  L14_2 = nil ~= L11_2 and L11_2 ~= A0_2 and not L13_2 and L14_2
  L15_2 = pcall
  L16_2 = MySQL
  L16_2 = L16_2.insert
  L16_2 = L16_2.await
  L17_2 = "INSERT INTO apex_phone_messages (app, sender, receiver, type, content, payload, `read`, created, delivered_at, deleted_receiver) VALUES (?, ?, ?, ?, ?, ?, 1, ?, ?, ?)"
  L18_2 = {}
  L19_2 = L0_1
  L20_2 = L5_2.me
  L21_2 = L5_2.number
  L22_2 = "system"
  L23_2 = L9_2
  L24_2 = L8_2 or L24_2
  if not L7_2 or not L8_2 then
    L24_2 = nil
  end
  L25_2 = L10_2
  L26_2 = L10_2 or L26_2
  if not L14_2 or not L10_2 then
    L26_2 = nil
  end
  if L13_2 then
    L27_2 = 1
    if L27_2 then
      goto lbl_260
    end
  end
  L27_2 = 0
  ::lbl_260::
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L18_2[4] = L22_2
  L18_2[5] = L23_2
  L18_2[6] = L24_2
  L18_2[7] = L25_2
  L18_2[8] = L26_2
  L18_2[9] = L27_2
  L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
  if L15_2 then
    L17_2 = L10_1
    L18_2 = L16_2
    L17_2 = L17_2(L18_2)
    if L17_2 then
      goto lbl_270
      L16_2 = L17_2 or L16_2
    end
  end
  L16_2 = nil
  ::lbl_270::
  if not L16_2 then
    L17_2 = nil
    L18_2 = "db"
    return L17_2, L18_2
  end
  L17_2 = {}
  L17_2.id = L16_2
  L18_2 = L0_1
  L17_2.app = L18_2
  L18_2 = L5_2.me
  L17_2.sender = L18_2
  L18_2 = L5_2.number
  L17_2.receiver = L18_2
  L17_2.type = "system"
  L17_2.content = L9_2
  L17_2.payload = L6_2
  L17_2.read = true
  L17_2.created = L10_2
  if L14_2 then
    L18_2 = Push
    L19_2 = L11_2
    L20_2 = "message"
    L21_2 = L17_2
    L18_2(L19_2, L20_2, L21_2)
  end
  return L17_2
end
RecadoSystemMessage = L62_1
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L10_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = nil
    L5_2 = "notfound"
    return L3_2, L4_2, L5_2
  end
  L3_2 = L19_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = nil
    L5_2 = nil
    L6_2 = "noidentity"
    return L4_2, L5_2, L6_2
  end
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = [[
SELECT id, app, sender, receiver, type, content, payload, created, conversation_id, deleted_all, deleted_sender,
        deleted_receiver, expires_at, view_once, viewed_at, forwarded FROM apex_phone_messages WHERE id = ?]]
  L7_2 = {}
  L8_2 = L2_2
  L7_2[1] = L8_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 and L5_2 then
    L6_2 = L5_2.app
    L7_2 = L0_1
    if L6_2 == L7_2 then
      goto lbl_38
    end
  end
  L6_2 = nil
  L7_2 = nil
  L8_2 = "notfound"
  do return L6_2, L7_2, L8_2 end
  ::lbl_38::
  L5_2.id = L2_2
  L6_2 = tonumber
  L7_2 = L5_2.expires_at
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L7_2 = Now
    L7_2 = L7_2()
    if L6_2 <= L7_2 then
      L7_2 = nil
      L8_2 = nil
      L9_2 = "notfound"
      return L7_2, L8_2, L9_2
    end
  end
  L7_2 = L10_1
  L8_2 = L5_2.conversation_id
  L7_2 = L7_2(L8_2)
  L5_2.conv = L7_2
  L8_2 = nil
  if L7_2 then
    L9_2 = L32_1
    L10_2 = L7_2
    L11_2 = L3_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L10_2 = tonumber
      L11_2 = L5_2.created
      L10_2 = L10_2(L11_2)
      if not L10_2 then
        L10_2 = 0
      end
      L11_2 = L9_2.joined
      if not (L10_2 < L11_2) then
        goto lbl_76
      end
    end
    L10_2 = nil
    L11_2 = nil
    L12_2 = "notfound"
    do return L10_2, L11_2, L12_2 end
    ::lbl_76::
    L10_2 = L5_2.sender
    if L10_2 == L3_2 then
      L10_2 = tonumber
      L11_2 = L5_2.deleted_sender
      L10_2 = L10_2(L11_2)
      if 1 == L10_2 then
        L10_2 = nil
        L11_2 = nil
        L12_2 = "notfound"
        return L10_2, L11_2, L12_2
      end
    end
    L10_2 = "g:"
    L11_2 = L7_2
    L10_2 = L10_2 .. L11_2
    L11_2 = L9_2.role
    L12_2 = "g:"
    L13_2 = L7_2
    L12_2 = L12_2 .. L13_2
    L8_2 = L12_2
    L5_2.role = L11_2
    L5_2.key = L10_2
  else
    L9_2 = L5_2.sender
    if L9_2 ~= L3_2 then
      L9_2 = L5_2.receiver
      if L9_2 ~= L3_2 then
        L9_2 = nil
        L10_2 = nil
        L11_2 = "notfound"
        return L9_2, L10_2, L11_2
      end
    end
    L9_2 = L5_2.sender
    if L9_2 == L3_2 then
      L9_2 = L5_2.receiver
      if L9_2 ~= L3_2 then
        L9_2 = tonumber
        L10_2 = L5_2.deleted_sender
        L9_2 = L9_2(L10_2)
        if 1 == L9_2 then
          L9_2 = nil
          L10_2 = nil
          L11_2 = "notfound"
          return L9_2, L10_2, L11_2
        end
      end
    end
    L9_2 = L5_2.receiver
    if L9_2 == L3_2 then
      L9_2 = L5_2.sender
      if L9_2 ~= L3_2 then
        L9_2 = tonumber
        L10_2 = L5_2.deleted_receiver
        L9_2 = L9_2(L10_2)
        if 1 == L9_2 then
          L9_2 = nil
          L10_2 = nil
          L11_2 = "notfound"
          return L9_2, L10_2, L11_2
        end
      end
    end
    L9_2 = L5_2.sender
    if L9_2 == L3_2 then
      L9_2 = L5_2.receiver
      if L9_2 then
        goto lbl_142
        L8_2 = L9_2 or L8_2
      end
    end
    L8_2 = L5_2.sender
    ::lbl_142::
    L9_2 = L8_2
    L10_2 = L20_1
    L11_2 = L3_2
    L12_2 = L8_2
    L10_2 = L10_2(L11_2, L12_2)
    L5_2.key = L10_2
    L5_2.other = L9_2
  end
  L9_2 = L37_1
  L10_2 = L3_2
  L11_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2)
  if L9_2 then
    L10_2 = L9_2.clearedBefore
    if L10_2 then
      L10_2 = L9_2.clearedBefore
      if L2_2 <= L10_2 then
        L10_2 = nil
        L11_2 = nil
        L12_2 = "notfound"
        return L10_2, L11_2, L12_2
      end
    end
  end
  L5_2.meta = L9_2
  L10_2 = L5_2
  L11_2 = L3_2
  return L10_2, L11_2
end
L63_1 = nil
function L64_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = {}
  if A0_2 then
    L3_2 = #A1_2
    if 0 ~= L3_2 then
      goto lbl_9
    end
  end
  do return L2_2 end
  ::lbl_9::
  L3_2 = 1
  L4_2 = #A1_2
  L5_2 = 200
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = {}
    L8_2 = A0_2
    L7_2[1] = L8_2
    L8_2 = L6_2
    L9_2 = math
    L9_2 = L9_2.min
    L10_2 = #A1_2
    L11_2 = L6_2 + 199
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = 1
    for L11_2 = L8_2, L9_2, L10_2 do
      L12_2 = #L7_2
      L12_2 = L12_2 + 1
      L13_2 = A1_2[L11_2]
      L7_2[L12_2] = L13_2
    end
    L8_2 = pcall
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "SELECT number, name FROM apex_phone_contacts WHERE owner = ? AND number IN (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L11_1
    L13_2 = #L7_2
    L13_2 = L13_2 - 1
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L12_2(L13_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
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
          L16_2 = tostring
          L17_2 = L15_2.number
          L16_2 = L16_2(L17_2)
          L17_2 = L15_2.name
          L2_2[L16_2] = L17_2
        end
      end
    end
  end
  return L2_2
end
function L65_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = A1_2 or L4_2
  if not A1_2 then
    L4_2 = {}
  end
  L5_2 = tonumber
  L6_2 = L4_2.view_once
  L5_2 = L5_2(L6_2)
  L5_2 = 1 == L5_2
  L6_2 = type
  L7_2 = A0_2.payload
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A0_2.payload
    if L6_2 then
      goto lbl_30
    end
  end
  L6_2 = L18_1
  L7_2 = A0_2.payload
  L6_2 = L6_2(L7_2)
  ::lbl_30::
  L7_2 = {}
  L8_2 = L10_1
  L9_2 = A0_2.id
  L8_2 = L8_2(L9_2)
  L7_2.id = L8_2
  L8_2 = A0_2.type
  if not L8_2 then
    L8_2 = "text"
  end
  L7_2.type = L8_2
  L8_2 = A0_2.sender
  L7_2.sender = L8_2
  L8_2 = tonumber
  L9_2 = A0_2.created
  L8_2 = L8_2(L9_2)
  L7_2.created = L8_2
  L8_2 = A0_2.deleted
  L8_2 = true == L8_2 or L8_2
  L7_2.deleted = L8_2
  L8_2 = A0_2.editedAt
  L8_2 = nil ~= L8_2 or L8_2
  L7_2.edited = L8_2
  L8_2 = A0_2.status
  L7_2.status = L8_2
  L8_2 = L5_2 or L8_2
  if not L5_2 then
    L8_2 = nil
  end
  L7_2.viewOnce = L8_2
  L8_2 = tonumber
  L9_2 = L4_2.forwarded
  L8_2 = L8_2(L9_2)
  L8_2 = 1 == L8_2 or L8_2
  L7_2.forwarded = L8_2
  if A3_2 then
    L7_2.hidden = true
    L8_2 = ""
    L7_2.preview = ""
    L7_2.content = L8_2
    return L7_2
  end
  if L5_2 then
    L8_2 = ""
    if L8_2 then
      goto lbl_98
    end
  end
  L8_2 = L12_1
  L9_2 = A0_2.content
  if not L9_2 then
    L9_2 = ""
  end
  L10_2 = 400
  L8_2 = L8_2(L9_2, L10_2)
  ::lbl_98::
  L7_2.content = L8_2
  L8_2 = L48_1
  L9_2 = L6_2
  L10_2 = L5_2
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.payload = L8_2
  L8_2 = L47_1
  L9_2 = {}
  L10_2 = L7_2.type
  L9_2.type = L10_2
  L10_2 = A0_2.content
  L9_2.content = L10_2
  L10_2 = A0_2.deleted
  L9_2.deleted = L10_2
  L10_2 = L4_2.view_once
  L9_2.view_once = L10_2
  L10_2 = L6_2
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.preview = L8_2
  return L7_2
end
L66_1 = L29_1
L67_1 = "recado.threads"
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2
  L2_2 = L19_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noidentity"
    return L3_2
  end
  L3_2 = L28_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2(L4_2, L5_2)
  L3_2 = A1_2.filter
  if "unread" ~= L3_2 then
    L3_2 = A1_2.filter
    if "groups" ~= L3_2 then
      goto lbl_23
    end
  end
  L3_2 = A1_2.filter
  ::lbl_23::
  if not L3_2 then
    L3_2 = "all"
  end
  L4_2 = nil
  L5_2 = A1_2.archived
  if true == L5_2 then
    L4_2 = true
  else
    L5_2 = A1_2.archived
    if false == L5_2 then
      L4_2 = false
    end
  end
  L5_2 = type
  L6_2 = A1_2.q
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = L12_1
    L6_2 = L13_1
    L7_2 = A1_2.q
    L6_2 = L6_2(L7_2)
    L7_2 = 64
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = L5_2
    L5_2 = L5_2.lower
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_50
    end
  end
  L5_2 = ""
  ::lbl_50::
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = RPC
  L7_2 = L7_2["messages.threads"]
  L8_2 = type
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if "function" ~= L8_2 then
    L8_2 = {}
    L8_2.error = "internal"
    return L8_2
  end
  L8_2 = nil
  L9_2 = 1
  L10_2 = 2
  L11_2 = 1
  for L12_2 = L9_2, L10_2, L11_2 do
    L13_2 = pcall
    L14_2 = L7_2
    L15_2 = A0_2
    L16_2 = {}
    L17_2 = L0_1
    L16_2.app = L17_2
    L17_2 = MessagesRecadoKey
    L16_2._via = L17_2
    L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2)
    if not L13_2 then
      L15_2 = print
      L16_2 = "^1[unique_phone]^0 Recado: messages.threads crashed (%s)"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = tostring
      L19_2 = L14_2
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L18_2(L19_2)
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
      L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
      L15_2 = {}
      L15_2.error = "internal"
      return L15_2
    end
    L15_2 = type
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    L8_2 = L14_2 or L8_2
    if "table" ~= L15_2 or not L14_2 then
      L15_2 = {}
      L8_2 = L15_2
    end
    L15_2 = {}
    L16_2 = ipairs
    L17_2 = L8_2
    L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
    for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
      L22_2 = type
      L23_2 = L21_2.last
      L22_2 = L22_2(L23_2)
      L22_2 = L10_1
      L23_2 = L21_2.last
      L23_2 = L23_2.id
      L22_2 = "table" == L22_2 and L22_2
      if L22_2 then
        L23_2 = #L15_2
        L23_2 = L23_2 + 1
        L15_2[L23_2] = L22_2
      end
    end
    if 2 == L12_2 then
      break
    end
    L16_2 = #L15_2
    if 0 == L16_2 then
      break
    end
    L16_2 = pcall
    L17_2 = MySQL
    L17_2 = L17_2.scalar
    L17_2 = L17_2.await
    L18_2 = "SELECT COUNT(*) FROM apex_phone_messages WHERE expires_at IS NOT NULL AND expires_at <= ? AND id IN (%s)"
    L19_2 = L18_2
    L18_2 = L18_2.format
    L20_2 = L11_1
    L21_2 = #L15_2
    L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L20_2(L21_2)
    L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
    L19_2 = {}
    L20_2 = Now
    L20_2 = L20_2()
    L21_2 = table
    L21_2 = L21_2.unpack
    L22_2 = L15_2
    L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L21_2(L22_2)
    L19_2[1] = L20_2
    L19_2[2] = L21_2
    L19_2[3] = L22_2
    L19_2[4] = L23_2
    L19_2[5] = L24_2
    L19_2[6] = L25_2
    L19_2[7] = L26_2
    L19_2[8] = L27_2
    L19_2[9] = L28_2
    L19_2[10] = L29_2
    L19_2[11] = L30_2
    L19_2[12] = L31_2
    L19_2[13] = L32_2
    L19_2[14] = L33_2
    L19_2[15] = L34_2
    L19_2[16] = L35_2
    L19_2[17] = L36_2
    L19_2[18] = L37_2
    L19_2[19] = L38_2
    L19_2[20] = L39_2
    L19_2[21] = L40_2
    L19_2[22] = L41_2
    L19_2[23] = L42_2
    L19_2[24] = L43_2
    L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2)
    if not L16_2 then
      break
    end
    L18_2 = tonumber
    L19_2 = L17_2
    L18_2 = L18_2(L19_2)
    if not L18_2 then
      L18_2 = 0
    end
    if not (L18_2 > 0) then
      break
    end
    L18_2 = L63_1
    if not L18_2 then
      break
    end
    L18_2 = pcall
    L19_2 = L63_1
    L18_2(L19_2)
  end
  L9_2 = {}
  L10_2 = {}
  L11_2 = {}
  L12_2 = ipairs
  L13_2 = L8_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = type
    L19_2 = L17_2
    L18_2 = L18_2(L19_2)
    if "table" == L18_2 then
      L18_2 = L10_1
      L19_2 = L17_2.conversation
      L18_2 = L18_2(L19_2)
      if not L18_2 then
        L18_2 = type
        L19_2 = L17_2.group
        L18_2 = L18_2(L19_2)
        if "table" == L18_2 then
          L18_2 = L10_1
          L19_2 = L17_2.group
          L19_2 = L19_2.id
          L18_2 = L18_2(L19_2)
          if L18_2 then
            goto lbl_204
          end
        end
        L18_2 = nil
      end
      ::lbl_204::
      if L18_2 then
        L19_2 = #L10_2
        L19_2 = L19_2 + 1
        L10_2[L19_2] = L18_2
      else
        L19_2 = L17_2.number
        if L19_2 then
          L19_2 = #L9_2
          L19_2 = L19_2 + 1
          L20_2 = tostring
          L21_2 = L17_2.number
          L20_2 = L20_2(L21_2)
          L9_2[L19_2] = L20_2
        end
      end
      L19_2 = type
      L20_2 = L17_2.last
      L19_2 = L19_2(L20_2)
      L19_2 = L10_1
      L20_2 = L17_2.last
      L20_2 = L20_2.id
      L19_2 = "table" == L19_2 and L19_2
      if L19_2 then
        L20_2 = #L11_2
        L20_2 = L20_2 + 1
        L11_2[L20_2] = L19_2
      end
    end
  end
  L12_2 = {}
  L13_2 = pcall
  L14_2 = MySQL
  L14_2 = L14_2.query
  L14_2 = L14_2.await
  L15_2 = "SELECT other, archived, marked_unread, locked, disappearing FROM apex_phone_thread_meta WHERE owner = ? AND app = ? LIMIT 2000"
  L16_2 = {}
  L17_2 = L2_2
  L18_2 = L0_1
  L16_2[1] = L17_2
  L16_2[2] = L18_2
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
        L21_2 = tostring
        L22_2 = L20_2.other
        L21_2 = L21_2(L22_2)
        L12_2[L21_2] = L20_2
      end
    end
  end
  L15_2 = {}
  L16_2 = #L11_2
  if L16_2 > 0 then
    L16_2 = pcall
    L17_2 = MySQL
    L17_2 = L17_2.query
    L17_2 = L17_2.await
    L18_2 = "SELECT id, expires_at, view_once, viewed_at, forwarded FROM apex_phone_messages WHERE id IN (%s)"
    L19_2 = L18_2
    L18_2 = L18_2.format
    L20_2 = L11_1
    L21_2 = #L11_2
    L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L20_2(L21_2)
    L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
    L19_2 = L11_2
    L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2)
    if L16_2 then
      L18_2 = type
      L19_2 = L17_2
      L18_2 = L18_2(L19_2)
      if "table" == L18_2 then
        L18_2 = ipairs
        L19_2 = L17_2
        L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
        for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
          L24_2 = L10_1
          L25_2 = L23_2.id
          L24_2 = L24_2(L25_2)
          L15_2[L24_2] = L23_2
        end
      end
    end
  end
  L16_2 = {}
  L17_2 = #L10_2
  if L17_2 > 0 then
    L17_2 = pcall
    L18_2 = MySQL
    L18_2 = L18_2.query
    L18_2 = L18_2.await
    L19_2 = "SELECT id, disappearing FROM apex_phone_conversations WHERE id IN (%s)"
    L20_2 = L19_2
    L19_2 = L19_2.format
    L21_2 = L11_1
    L22_2 = #L10_2
    L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2 = L21_2(L22_2)
    L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2)
    L20_2 = L10_2
    L17_2, L18_2 = L17_2(L18_2, L19_2, L20_2)
    if L17_2 then
      L19_2 = type
      L20_2 = L18_2
      L19_2 = L19_2(L20_2)
      if "table" == L19_2 then
        L19_2 = ipairs
        L20_2 = L18_2
        L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
        for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
          L25_2 = L10_1
          L26_2 = L24_2.id
          L25_2 = L25_2(L26_2)
          L26_2 = math
          L26_2 = L26_2.tointeger
          L27_2 = tonumber
          L28_2 = L24_2.disappearing
          L27_2 = L27_2(L28_2)
          if not L27_2 then
            L27_2 = 0
          end
          L26_2 = L26_2(L27_2)
          if not L26_2 then
            L26_2 = 0
          end
          L16_2[L25_2] = L26_2
        end
      end
    end
  end
  L17_2 = L64_1
  L18_2 = L6_2
  L19_2 = L9_2
  L17_2 = L17_2(L18_2, L19_2)
  L18_2 = Now
  L18_2 = L18_2()
  L19_2 = 0
  L20_2 = L40_1
  L21_2 = L2_2
  L20_2 = L20_2(L21_2)
  L21_2 = {}
  L22_2 = ipairs
  L23_2 = L8_2
  L22_2, L23_2, L24_2, L25_2 = L22_2(L23_2)
  for L26_2, L27_2 in L22_2, L23_2, L24_2, L25_2 do
    L28_2 = type
    L29_2 = L27_2
    L28_2 = L28_2(L29_2)
    if "table" == L28_2 then
      L28_2 = L10_1
      L29_2 = L27_2.conversation
      L28_2 = L28_2(L29_2)
      if not L28_2 then
        L28_2 = type
        L29_2 = L27_2.group
        L28_2 = L28_2(L29_2)
        if "table" == L28_2 then
          L28_2 = L10_1
          L29_2 = L27_2.group
          L29_2 = L29_2.id
          L28_2 = L28_2(L29_2)
          if L28_2 then
            goto lbl_393
          end
        end
        L28_2 = nil
      end
      ::lbl_393::
      if L28_2 then
        L29_2 = "g:"
        L30_2 = L28_2
        L29_2 = L29_2 .. L30_2
        if L29_2 then
          goto lbl_406
        end
      end
      L29_2 = tostring
      L30_2 = L27_2.number
      if not L30_2 then
        L30_2 = ""
      end
      L29_2 = L29_2(L30_2)
      ::lbl_406::
      L30_2 = L12_2[L29_2]
      if not L30_2 then
        L30_2 = {}
      end
      L31_2 = tonumber
      L32_2 = L30_2.locked
      L31_2 = L31_2(L32_2)
      L31_2 = 1 == L31_2
      L32_2 = {}
      L33_2 = math
      L33_2 = L33_2.tointeger
      L34_2 = tonumber
      L35_2 = L27_2.unread
      L34_2 = L34_2(L35_2)
      if not L34_2 then
        L34_2 = 0
      end
      L33_2 = L33_2(L34_2)
      if not L33_2 then
        L33_2 = 0
      end
      L32_2.unread = L33_2
      L33_2 = tonumber
      L34_2 = L27_2.ts
      L33_2 = L33_2(L34_2)
      if not L33_2 then
        L33_2 = 0
      end
      L32_2.ts = L33_2
      L33_2 = L27_2.pinned
      L33_2 = true == L33_2
      L32_2.pinned = L33_2
      L33_2 = tonumber
      L34_2 = L27_2.mutedUntil
      L33_2 = L33_2(L34_2)
      if not L33_2 then
        L33_2 = 0
      end
      if L18_2 < L33_2 then
        L33_2 = tonumber
        L34_2 = L27_2.mutedUntil
        L33_2 = L33_2(L34_2)
        if L33_2 then
          goto lbl_460
        end
      end
      L33_2 = nil
      ::lbl_460::
      L32_2.mutedUntil = L33_2
      L33_2 = tonumber
      L34_2 = L30_2.archived
      L33_2 = L33_2(L34_2)
      L33_2 = 1 == L33_2
      L32_2.archived = L33_2
      L33_2 = tonumber
      L34_2 = L30_2.marked_unread
      L33_2 = L33_2(L34_2)
      L33_2 = 1 == L33_2
      L32_2.markedUnread = L33_2
      L32_2.locked = L31_2
      L33_2 = type
      L34_2 = L27_2.last
      L33_2 = L33_2(L34_2)
      if "table" == L33_2 then
        L33_2 = L27_2.last
        if L33_2 then
          goto lbl_487
        end
      end
      L33_2 = nil
      ::lbl_487::
      L34_2 = L65_1
      L35_2 = L33_2
      if L33_2 then
        L36_2 = L10_1
        L37_2 = L33_2.id
        L36_2 = L36_2(L37_2)
        L36_2 = L15_2[L36_2]
        if L36_2 then
          goto lbl_498
        end
      end
      L36_2 = nil
      ::lbl_498::
      L37_2 = L2_2
      L38_2 = L31_2
      L34_2 = L34_2(L35_2, L36_2, L37_2, L38_2)
      L32_2.last = L34_2
      L34_2 = L32_2.last
      if L34_2 and L33_2 then
        L34_2 = L33_2.sender
        if L34_2 == L2_2 then
          L34_2 = L33_2.deleted
          if not L34_2 then
            L34_2 = L33_2.type
            if "system" ~= L34_2 then
              L34_2 = L32_2.last
              L35_2 = L27_2.lastStatus
              if not L35_2 then
                L35_2 = L33_2.status
              end
              L34_2.status = L35_2
            end
          end
        end
      end
      if L28_2 then
        L34_2 = type
        L35_2 = L27_2.group
        L34_2 = L34_2(L35_2)
        if "table" == L34_2 then
          L34_2 = L27_2.group
          if L34_2 then
            goto lbl_534
          end
        end
        L34_2 = {}
        ::lbl_534::
        L32_2.conversation = L28_2
        L35_2 = {}
        L35_2.id = L28_2
        L36_2 = L34_2.title
        if not L36_2 then
          L36_2 = L27_2.name
        end
        L35_2.title = L36_2
        L36_2 = L10_1
        L37_2 = L34_2.avatar
        L36_2 = L36_2(L37_2)
        L35_2.avatar = L36_2
        L36_2 = L34_2.memberCount
        L35_2.memberCount = L36_2
        L36_2 = L34_2.role
        L35_2.role = L36_2
        L36_2 = L34_2.members
        L35_2.members = L36_2
        L32_2.group = L35_2
        L35_2 = L34_2.title
        if not L35_2 then
          L35_2 = L27_2.name
          if not L35_2 then
            L35_2 = "Grupo"
          end
        end
        L32_2.name = L35_2
        L35_2 = L10_1
        L36_2 = L34_2.avatar
        L35_2 = L35_2(L36_2)
        L32_2.avatar = L35_2
        L35_2 = L16_2[L28_2]
        if not L35_2 then
          L35_2 = 0
        end
        L32_2.disappearing = L35_2
      else
        L34_2 = tostring
        L35_2 = L27_2.number
        if not L35_2 then
          L35_2 = ""
        end
        L34_2 = L34_2(L35_2)
        L32_2.number = L34_2
        L35_2 = L17_2[L34_2]
        L35_2 = nil ~= L35_2
        L32_2.isContact = L35_2
        L35_2 = L17_2[L34_2]
        L32_2.name = L35_2
        L35_2 = math
        L35_2 = L35_2.tointeger
        L36_2 = tonumber
        L37_2 = L30_2.disappearing
        L36_2 = L36_2(L37_2)
        if not L36_2 then
          L36_2 = 0
        end
        L35_2 = L35_2(L36_2)
        if not L35_2 then
          L35_2 = 0
        end
        L32_2.disappearing = L35_2
        L35_2 = L27_2.online
        L35_2 = true == L35_2
        L36_2 = tonumber
        L37_2 = L27_2.lastSeen
        L36_2 = L36_2(L37_2)
        L32_2.lastSeen = L36_2
        L32_2.online = L35_2
        L35_2 = type
        L36_2 = RecadoCanSee
        L35_2 = L35_2(L36_2)
        if "function" == L35_2 then
          L35_2 = pcall
          L36_2 = RecadoCanSee
          L37_2 = L2_2
          L38_2 = L34_2
          L39_2 = "online"
          L35_2, L36_2 = L35_2(L36_2, L37_2, L38_2, L39_2)
          if L35_2 and false == L36_2 then
            L32_2.online = false
          end
          L37_2 = pcall
          L38_2 = RecadoCanSee
          L39_2 = L2_2
          L40_2 = L34_2
          L41_2 = "lastSeen"
          L37_2, L38_2 = L37_2(L38_2, L39_2, L40_2, L41_2)
          if L37_2 and false == L38_2 then
            L32_2.lastSeen = nil
          end
        end
        L35_2 = type
        L36_2 = RecadoProfile
        L35_2 = L35_2(L36_2)
        if "function" == L35_2 and L19_2 < 80 then
          L19_2 = L19_2 + 1
          L35_2 = pcall
          L36_2 = RecadoProfile
          L37_2 = L34_2
          L35_2, L36_2 = L35_2(L36_2, L37_2)
          if L35_2 then
            L37_2 = type
            L38_2 = L36_2
            L37_2 = L37_2(L38_2)
            if "table" == L37_2 then
              L37_2 = L32_2.name
              if not L37_2 then
                L37_2 = type
                L38_2 = L36_2.name
                L37_2 = L37_2(L38_2)
                if "string" == L37_2 then
                  L37_2 = L36_2.name
                  if "" ~= L37_2 then
                    L37_2 = L12_1
                    L38_2 = L36_2.name
                    L39_2 = 40
                    L37_2 = L37_2(L38_2, L39_2)
                    L32_2.profileName = L37_2
                  end
                end
              end
              L37_2 = L10_1
              L38_2 = L36_2.avatar
              if not L38_2 then
                L38_2 = L36_2.avatarMedia
                if not L38_2 then
                  L38_2 = L36_2.avatar_media
                end
              end
              L37_2 = L37_2(L38_2)
              if L37_2 then
                L38_2 = true
                L39_2 = type
                L40_2 = RecadoCanSee
                L39_2 = L39_2(L40_2)
                if "function" == L39_2 then
                  L39_2 = pcall
                  L40_2 = RecadoCanSee
                  L41_2 = L2_2
                  L42_2 = L34_2
                  L43_2 = "photo"
                  L39_2, L40_2 = L39_2(L40_2, L41_2, L42_2, L43_2)
                  L38_2 = not L39_2 or false ~= L40_2
                end
                if L38_2 then
                  L32_2.avatar = L37_2
                end
              end
            end
          end
        end
        L35_2 = L32_2.name
        if not L35_2 then
          L35_2 = L32_2.profileName
          if not L35_2 then
            L35_2 = L34_2
          end
        end
        L32_2.name = L35_2
      end
      L34_2 = L32_2.last
      if L34_2 then
        L34_2 = L32_2.last
        L34_2 = L34_2.status
        if "read" == L34_2 then
          if not L20_2 then
            if L28_2 then
              goto lbl_731
            end
            L34_2 = L40_1
            L35_2 = L32_2.number
            L34_2 = L34_2(L35_2)
            if not L34_2 then
              goto lbl_731
            end
          end
          L34_2 = L32_2.last
          L34_2.status = "delivered"
        end
      end
      ::lbl_731::
      L34_2 = true
      if nil ~= L4_2 then
        L35_2 = L32_2.archived
        if L35_2 ~= L4_2 then
          L34_2 = false
        end
      end
      if L34_2 and "unread" == L3_2 then
        L35_2 = L32_2.unread
        if not (L35_2 > 0) then
          L35_2 = L32_2.markedUnread
          if not L35_2 then
            L34_2 = false
          end
        end
      end
      if L34_2 and "groups" == L3_2 and not L28_2 then
        L34_2 = false
      end
      if L34_2 and "" ~= L5_2 then
        L35_2 = tostring
        L36_2 = L32_2.name
        if not L36_2 then
          L36_2 = ""
        end
        L35_2 = L35_2(L36_2)
        L36_2 = " "
        L37_2 = tostring
        L38_2 = L32_2.number
        if not L38_2 then
          L38_2 = ""
        end
        L37_2 = L37_2(L38_2)
        L35_2 = L35_2 .. L36_2 .. L37_2
        L36_2 = L35_2
        L35_2 = L35_2.lower
        L35_2 = L35_2(L36_2)
        L37_2 = L35_2
        L36_2 = L35_2.find
        L38_2 = L5_2
        L39_2 = 1
        L40_2 = true
        L36_2 = L36_2(L37_2, L38_2, L39_2, L40_2)
        if not L36_2 then
          L34_2 = false
        end
      end
      if L34_2 then
        L35_2 = #L21_2
        L35_2 = L35_2 + 1
        L21_2[L35_2] = L32_2
      end
    end
  end
  L22_2 = table
  L22_2 = L22_2.sort
  L23_2 = L21_2
  function L24_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.pinned
    L3_3 = A1_3.pinned
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.pinned
      return L2_3
    end
    L2_3 = A0_3.ts
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = A1_3.ts
    if not L3_3 then
      L3_3 = 0
    end
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L22_2(L23_2, L24_2)
  return L21_2
end
L66_1(L67_1, L68_1)
L66_1 = L29_1
L67_1 = "recado.get"
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2
  L2_2 = L34_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L37_1
  L5_2 = L2_2.me
  L6_2 = L2_2.other
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L4_2.locked
    if L5_2 then
      L5_2 = L44_1
      L6_2 = A0_2
      L5_2 = L5_2(L6_2)
      if not L5_2 then
        L5_2 = {}
        L5_2.error = "locked"
        return L5_2
      end
    end
  end
  L5_2 = L10_1
  L6_2 = A1_2.before
  L5_2 = L5_2(L6_2)
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = A1_2.limit
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2)
  if L6_2 then
    L7_2 = math
    L7_2 = L7_2.max
    L8_2 = 1
    L9_2 = math
    L9_2 = L9_2.min
    L10_2 = 50
    L11_2 = L6_2
    L9_2 = L9_2(L10_2, L11_2)
    L7_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      goto lbl_52
      L6_2 = L7_2 or L6_2
    end
  end
  L6_2 = 30
  ::lbl_52::
  L7_2 = RPC
  L7_2 = L7_2["messages.get"]
  L8_2 = type
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if "function" ~= L8_2 then
    L8_2 = {}
    L8_2.error = "internal"
    return L8_2
  end
  L8_2 = {}
  L9_2 = L0_1
  L8_2.app = L9_2
  L8_2.before = L5_2
  L8_2.limit = L6_2
  L9_2 = MessagesRecadoKey
  L8_2._via = L9_2
  L9_2 = L2_2.conv
  if L9_2 then
    L9_2 = L2_2.conv
    L8_2.conversation = L9_2
  else
    L9_2 = L2_2.number
    L8_2.number = L9_2
  end
  L9_2 = pcall
  L10_2 = L7_2
  L11_2 = A0_2
  L12_2 = L8_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  if not L9_2 then
    L11_2 = print
    L12_2 = "^1[unique_phone]^0 Recado: messages.get crashed (%s)"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = tostring
    L15_2 = L10_2
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L14_2(L15_2)
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2)
    L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2)
    L11_2 = {}
    L11_2.error = "internal"
    return L11_2
  end
  L11_2 = type
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  if "table" ~= L11_2 or not L10_2 then
    L11_2 = {}
    L10_2 = L11_2
  end
  if not L5_2 and L4_2 then
    L11_2 = L4_2.markedUnread
    if L11_2 then
      L11_2 = pcall
      L12_2 = MySQL
      L12_2 = L12_2.update
      L12_2 = L12_2.await
      L13_2 = "UPDATE apex_phone_thread_meta SET marked_unread = 0 WHERE owner = ? AND app = ? AND other = ?"
      L14_2 = {}
      L15_2 = L2_2.me
      L16_2 = L0_1
      L17_2 = L2_2.other
      L14_2[1] = L15_2
      L14_2[2] = L16_2
      L14_2[3] = L17_2
      L11_2(L12_2, L13_2, L14_2)
    end
  end
  L11_2 = #L10_2
  if 0 == L11_2 then
    return L10_2
  end
  L11_2 = {}
  L12_2 = ipairs
  L13_2 = L10_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = L10_1
    L19_2 = L17_2.id
    L18_2 = L18_2(L19_2)
    if L18_2 then
      L19_2 = #L11_2
      L19_2 = L19_2 + 1
      L11_2[L19_2] = L18_2
    end
  end
  L12_2 = #L11_2
  if 0 == L12_2 then
    return L10_2
  end
  L12_2 = {}
  L13_2 = {}
  L14_2 = {}
  L15_2 = {}
  L16_2 = pcall
  L17_2 = MySQL
  L17_2 = L17_2.query
  L17_2 = L17_2.await
  L18_2 = "SELECT id, expires_at, view_once, viewed_at, forwarded FROM apex_phone_messages WHERE id IN (%s)"
  L19_2 = L18_2
  L18_2 = L18_2.format
  L20_2 = L11_1
  L21_2 = #L11_2
  L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L20_2(L21_2)
  L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2)
  L19_2 = L11_2
  L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2)
  if L16_2 then
    L18_2 = type
    L19_2 = L17_2
    L18_2 = L18_2(L19_2)
    if "table" == L18_2 then
      L18_2 = ipairs
      L19_2 = L17_2
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L24_2 = L10_1
        L25_2 = L23_2.id
        L24_2 = L24_2(L25_2)
        L12_2[L24_2] = L23_2
      end
    end
  end
  L18_2 = pcall
  L19_2 = MySQL
  L19_2 = L19_2.query
  L19_2 = L19_2.await
  L20_2 = "SELECT message_id FROM apex_phone_recado_stars WHERE who = ? AND message_id IN (%s)"
  L21_2 = L20_2
  L20_2 = L20_2.format
  L22_2 = L11_1
  L23_2 = #L11_2
  L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L22_2(L23_2)
  L20_2 = L20_2(L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2)
  L21_2 = {}
  L22_2 = L2_2.me
  L23_2 = table
  L23_2 = L23_2.unpack
  L24_2 = L11_2
  L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L23_2(L24_2)
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L21_2[4] = L25_2
  L21_2[5] = L26_2
  L21_2[6] = L27_2
  L21_2[7] = L28_2
  L21_2[8] = L29_2
  L21_2[9] = L30_2
  L21_2[10] = L31_2
  L21_2[11] = L32_2
  L21_2[12] = L33_2
  L21_2[13] = L34_2
  L21_2[14] = L35_2
  L21_2[15] = L36_2
  L21_2[16] = L37_2
  L21_2[17] = L38_2
  L21_2[18] = L39_2
  L21_2[19] = L40_2
  L18_2, L19_2 = L18_2(L19_2, L20_2, L21_2)
  if L18_2 then
    L20_2 = type
    L21_2 = L19_2
    L20_2 = L20_2(L21_2)
    if "table" == L20_2 then
      L20_2 = ipairs
      L21_2 = L19_2
      L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
      for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
        L26_2 = L10_1
        L27_2 = L25_2.message_id
        L26_2 = L26_2(L27_2)
        L13_2[L26_2] = true
      end
    end
  end
  L20_2 = pcall
  L21_2 = MySQL
  L21_2 = L21_2.query
  L21_2 = L21_2.await
  L22_2 = "SELECT message_id FROM apex_phone_recado_pins WHERE thread = ? LIMIT 50"
  L23_2 = {}
  L24_2 = L2_2.key
  L23_2[1] = L24_2
  L20_2, L21_2 = L20_2(L21_2, L22_2, L23_2)
  if L20_2 then
    L22_2 = type
    L23_2 = L21_2
    L22_2 = L22_2(L23_2)
    if "table" == L22_2 then
      L22_2 = ipairs
      L23_2 = L21_2
      L22_2, L23_2, L24_2, L25_2 = L22_2(L23_2)
      for L26_2, L27_2 in L22_2, L23_2, L24_2, L25_2 do
        L28_2 = L10_1
        L29_2 = L27_2.message_id
        L28_2 = L28_2(L29_2)
        L14_2[L28_2] = true
      end
    end
  end
  L22_2 = pcall
  L23_2 = MySQL
  L23_2 = L23_2.query
  L23_2 = L23_2.await
  L24_2 = "SELECT message_id FROM apex_phone_recado_views WHERE who = ? AND message_id IN (%s)"
  L25_2 = L24_2
  L24_2 = L24_2.format
  L26_2 = L11_1
  L27_2 = #L11_2
  L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L26_2(L27_2)
  L24_2 = L24_2(L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2)
  L25_2 = {}
  L26_2 = L2_2.me
  L27_2 = table
  L27_2 = L27_2.unpack
  L28_2 = L11_2
  L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L27_2(L28_2)
  L25_2[1] = L26_2
  L25_2[2] = L27_2
  L25_2[3] = L28_2
  L25_2[4] = L29_2
  L25_2[5] = L30_2
  L25_2[6] = L31_2
  L25_2[7] = L32_2
  L25_2[8] = L33_2
  L25_2[9] = L34_2
  L25_2[10] = L35_2
  L25_2[11] = L36_2
  L25_2[12] = L37_2
  L25_2[13] = L38_2
  L25_2[14] = L39_2
  L25_2[15] = L40_2
  L22_2, L23_2 = L22_2(L23_2, L24_2, L25_2)
  if L22_2 then
    L24_2 = type
    L25_2 = L23_2
    L24_2 = L24_2(L25_2)
    if "table" == L24_2 then
      L24_2 = ipairs
      L25_2 = L23_2
      L24_2, L25_2, L26_2, L27_2 = L24_2(L25_2)
      for L28_2, L29_2 in L24_2, L25_2, L26_2, L27_2 do
        L30_2 = L10_1
        L31_2 = L29_2.message_id
        L30_2 = L30_2(L31_2)
        L15_2[L30_2] = true
      end
    end
  end
  L24_2 = {}
  L25_2 = L2_2.conv
  if L25_2 then
    L25_2 = {}
    L26_2 = ipairs
    L27_2 = L10_2
    L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
    for L30_2, L31_2 in L26_2, L27_2, L28_2, L29_2 do
      L32_2 = L10_1
      L33_2 = L31_2.id
      L32_2 = L32_2(L33_2)
      if L32_2 then
        L33_2 = L31_2.sender
        L34_2 = L2_2.me
        if L33_2 == L34_2 then
          L33_2 = L12_2[L32_2]
          if L33_2 then
            L33_2 = tonumber
            L34_2 = L12_2[L32_2]
            L34_2 = L34_2.view_once
            L33_2 = L33_2(L34_2)
            if 1 == L33_2 then
              L33_2 = #L25_2
              L33_2 = L33_2 + 1
              L25_2[L33_2] = L32_2
            end
          end
        end
      end
    end
    L26_2 = #L25_2
    if L26_2 > 0 then
      L26_2 = pcall
      L27_2 = MySQL
      L27_2 = L27_2.query
      L27_2 = L27_2.await
      L28_2 = "SELECT DISTINCT message_id FROM apex_phone_recado_views WHERE message_id IN (%s)"
      L29_2 = L28_2
      L28_2 = L28_2.format
      L30_2 = L11_1
      L31_2 = #L25_2
      L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2 = L30_2(L31_2)
      L28_2 = L28_2(L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2)
      L29_2 = L25_2
      L26_2, L27_2 = L26_2(L27_2, L28_2, L29_2)
      if L26_2 then
        L28_2 = type
        L29_2 = L27_2
        L28_2 = L28_2(L29_2)
        if "table" == L28_2 then
          L28_2 = ipairs
          L29_2 = L27_2
          L28_2, L29_2, L30_2, L31_2 = L28_2(L29_2)
          for L32_2, L33_2 in L28_2, L29_2, L30_2, L31_2 do
            L34_2 = L10_1
            L35_2 = L33_2.message_id
            L34_2 = L34_2(L35_2)
            L24_2[L34_2] = true
          end
        end
      end
    end
  end
  L25_2 = L40_1
  L26_2 = L2_2.me
  L25_2 = L25_2(L26_2)
  if not L25_2 then
    L25_2 = L2_2.number
    L25_2 = L2_2.number
    L26_2 = L2_2.me
    L25_2 = L40_1
    L26_2 = L2_2.number
    L25_2 = nil ~= L25_2 and L25_2
  end
  L26_2 = Now
  L26_2 = L26_2()
  L27_2 = {}
  L28_2 = ipairs
  L29_2 = L10_2
  L28_2, L29_2, L30_2, L31_2 = L28_2(L29_2)
  for L32_2, L33_2 in L28_2, L29_2, L30_2, L31_2 do
    L34_2 = L10_1
    L35_2 = L33_2.id
    L34_2 = L34_2(L35_2)
    if L34_2 then
      L35_2 = L12_2[L34_2]
      if L35_2 then
        goto lbl_397
      end
    end
    L35_2 = nil
    ::lbl_397::
    if L35_2 then
      L36_2 = tonumber
      L37_2 = L35_2.expires_at
      L36_2 = L36_2(L37_2)
      if L36_2 then
        goto lbl_405
      end
    end
    L36_2 = nil
    ::lbl_405::
    if not L36_2 or not (L26_2 >= L36_2) then
      L33_2.expiresAt = L36_2
      if L35_2 then
        L37_2 = tonumber
        L38_2 = L35_2.forwarded
        L37_2 = L37_2(L38_2)
      end
      L37_2 = 1 == L37_2 or L37_2
      L33_2.forwarded = L37_2
      L37_2 = L13_2[L34_2]
      L37_2 = true == L37_2
      L33_2.starred = L37_2
      L37_2 = L14_2[L34_2]
      L37_2 = true == L37_2
      L33_2.pinned = L37_2
      if L25_2 then
        L37_2 = L33_2.sender
        L38_2 = L2_2.me
        if L37_2 == L38_2 then
          L37_2 = L33_2.status
          if "read" == L37_2 then
            L37_2 = "delivered"
            L33_2.readAt = nil
            L33_2.status = L37_2
          end
        end
      end
      if L35_2 then
        L37_2 = tonumber
        L38_2 = L35_2.view_once
        L37_2 = L37_2(L38_2)
        if 1 == L37_2 then
          L37_2 = L33_2.deleted
          if not L37_2 then
            L37_2 = type
            L38_2 = L33_2.payload
            L37_2 = L37_2(L38_2)
            if "table" == L37_2 then
              L37_2 = L33_2.payload
              if L37_2 then
                goto lbl_466
              end
            end
            L37_2 = {}
            ::lbl_466::
            L33_2.viewOnce = true
            L38_2 = L33_2.sender
            L39_2 = L2_2.me
            if L38_2 == L39_2 then
              L38_2 = not L25_2
              L33_2.viewed = L38_2
            else
              L38_2 = L15_2[L34_2]
              L38_2 = true == L38_2
              L33_2.viewed = L38_2
            end
            L38_2 = {}
            L38_2.viewOnce = true
            L39_2 = L33_2.type
            if "audio" == L39_2 then
              L39_2 = tonumber
              L40_2 = L37_2.duration
              L39_2 = L39_2(L40_2)
              if L39_2 then
                goto lbl_501
              end
            end
            L39_2 = nil
            ::lbl_501::
            L38_2.duration = L39_2
            L39_2 = L37_2.ttl
            L38_2.ttl = L39_2
            L39_2 = L37_2.fwd
            L38_2.fwd = L39_2
            L33_2.payload = L38_2
            L33_2.content = ""
          end
        end
      end
      L37_2 = #L27_2
      L37_2 = L37_2 + 1
      L27_2[L37_2] = L33_2
    end
  end
  return L27_2
end
L66_1(L67_1, L68_1)
L66_1 = L29_1
L67_1 = "recado.send"
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = RequireLine
  if L2_2 then
    L2_2 = RequireLine
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  if L2_2 then
    return L2_2
  end
  L3_2 = RecadoSend
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = {}
  L7_2 = A1_2.type
  L6_2.type = L7_2
  L7_2 = A1_2.content
  L6_2.content = L7_2
  L7_2 = A1_2.payload
  L6_2.payload = L7_2
  L7_2 = A1_2.replyTo
  L6_2.replyTo = L7_2
  L7_2 = A1_2.viewOnce
  L7_2 = true == L7_2
  L6_2.viewOnce = L7_2
  L7_2 = A1_2.hd
  L7_2 = true == L7_2
  L6_2.hd = L7_2
  L7_2 = A1_2.mediaId
  L6_2.mediaId = L7_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L5_2 = {}
    L5_2.error = L4_2
    return L5_2
  end
  return L3_2
end
L66_1(L67_1, L68_1)
L66_1 = L29_1
L67_1 = "recado.forward"
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2
  L2_2 = RequireLine
  if L2_2 then
    L2_2 = RequireLine
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  if L2_2 then
    return L2_2
  end
  L3_2 = L62_1
  L4_2 = A0_2
  L5_2 = A1_2.id
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L6_2 = {}
    L6_2.error = L5_2
    return L6_2
  end
  L6_2 = L3_2.deleted_all
  if nil ~= L6_2 then
    L6_2 = {}
    L6_2.error = "deleted"
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = L3_2.view_once
  L6_2 = L6_2(L7_2)
  if 1 == L6_2 then
    L6_2 = {}
    L6_2.error = "viewonce"
    return L6_2
  end
  L6_2 = L3_2.type
  if not L6_2 then
    L6_2 = "text"
  end
  L7_2 = L51_1
  L6_2 = L7_2[L6_2]
  if not L6_2 then
    L6_2 = {}
    L6_2.error = "unsupported"
    return L6_2
  end
  L6_2 = type
  L7_2 = A1_2.targets
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A1_2.targets
    if L6_2 then
      goto lbl_57
    end
  end
  L6_2 = nil
  ::lbl_57::
  if L6_2 then
    L7_2 = #L6_2
    if 0 ~= L7_2 then
      goto lbl_66
    end
  end
  L7_2 = {}
  L7_2.error = "target"
  do return L7_2 end
  ::lbl_66::
  L7_2 = L9_1
  L7_2 = L7_2()
  L8_2 = #L6_2
  L9_2 = L7_2.forwardMax
  if L8_2 > L9_2 then
    L8_2 = {}
    L8_2.error = "toomany"
    L9_2 = L7_2.forwardMax
    L8_2.max = L9_2
    return L8_2
  end
  L8_2 = L18_1
  L9_2 = L3_2.payload
  L8_2 = L8_2(L9_2)
  if L8_2 then
    L9_2 = nil
    L10_2 = nil
    L8_2.viewOnce = nil
    L8_2.fwd = L10_2
    L8_2.ttl = L9_2
  end
  L9_2 = {}
  L10_2 = 0
  L11_2 = {}
  L12_2 = ipairs
  L13_2 = L6_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = L33_1
    L19_2 = L17_2
    L18_2 = L18_2(L19_2)
    if L18_2 then
      L19_2 = L18_2.conv
      if L19_2 then
        L19_2 = "g:"
        L20_2 = L18_2.conv
        L19_2 = L19_2 .. L20_2
        if L19_2 then
          goto lbl_115
        end
      end
      L19_2 = "n:"
      L20_2 = L18_2.number
      L19_2 = L19_2 .. L20_2
      if L19_2 then
        goto lbl_115
      end
    end
    L19_2 = nil
    ::lbl_115::
    if not L18_2 then
      L20_2 = #L9_2
      L20_2 = L20_2 + 1
      L21_2 = {}
      L21_2.i = L16_2
      L21_2.error = "target"
      L9_2[L20_2] = L21_2
    else
      L20_2 = L11_2[L19_2]
      if L20_2 then
        L20_2 = #L9_2
        L20_2 = L20_2 + 1
        L21_2 = {}
        L21_2.i = L16_2
        L21_2.error = "duplicate"
        L9_2[L20_2] = L21_2
      else
        L11_2[L19_2] = true
        L20_2 = nil
        if L8_2 then
          L21_2 = {}
          L20_2 = L21_2
          L21_2 = pairs
          L22_2 = L8_2
          L21_2, L22_2, L23_2, L24_2 = L21_2(L22_2)
          for L25_2, L26_2 in L21_2, L22_2, L23_2, L24_2 do
            L20_2[L25_2] = L26_2
          end
        end
        L21_2 = RecadoSend
        L22_2 = A0_2
        L23_2 = L17_2
        L24_2 = {}
        L25_2 = L3_2.type
        L24_2.type = L25_2
        L25_2 = L3_2.content
        L24_2.content = L25_2
        L24_2.payload = L20_2
        L24_2.forwarded = true
        L21_2, L22_2 = L21_2(L22_2, L23_2, L24_2)
        L23_2 = #L9_2
        L23_2 = L23_2 + 1
        L24_2 = {}
        L24_2.i = L16_2
        if L21_2 then
          L25_2 = L21_2.id
          if L25_2 then
            goto lbl_177
          end
        end
        L25_2 = nil
        ::lbl_177::
        L24_2.id = L25_2
        L25_2 = L22_2 or L25_2
        if L21_2 or not L22_2 then
          L25_2 = nil
        end
        L24_2.error = L25_2
        L25_2 = L18_2.conv
        L24_2.conversation = L25_2
        L25_2 = L18_2.number
        L24_2.number = L25_2
        L9_2[L23_2] = L24_2
        if L21_2 then
          L10_2 = L10_2 + 1
        end
      end
    end
  end
  L12_2 = {}
  L13_2 = L10_2 > 0
  L12_2.ok = L13_2
  L12_2.sent = L10_2
  L12_2.results = L9_2
  return L12_2
end
L66_1(L67_1, L68_1)
L66_1 = L29_1
L67_1 = "recado.thread.set"
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = L34_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L37_1
  L5_2 = L2_2.me
  L6_2 = L2_2.other
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.disappearing = 0
  end
  L5_2 = {}
  L5_2.ok = true
  L6_2 = nil
  L7_2 = A1_2.disappearing
  if nil ~= L7_2 then
    L7_2 = L39_1
    L8_2 = A1_2.disappearing
    L7_2 = L7_2(L8_2)
    L6_2 = L7_2
    if nil == L6_2 then
      L7_2 = {}
      L7_2.ok = false
      L7_2.error = "invalid"
      return L7_2
    end
    L7_2 = L2_2.conv
    if L7_2 then
      L7_2 = L36_1
      L8_2 = RecadoGroupCanEdit
      L9_2 = L2_2.conv
      L10_2 = L2_2.me
      L11_2 = L2_2.role
      L12_2 = "edit_policy"
      L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
      if not L7_2 then
        L7_2 = {}
        L7_2.ok = false
        L7_2.error = "adminsonly"
        return L7_2
      end
    else
      L7_2 = L2_2.number
      L8_2 = L2_2.me
      if L7_2 ~= L8_2 then
        L7_2 = GetCid
        L8_2 = A0_2
        L7_2 = L7_2(L8_2)
        if L7_2 then
          L8_2 = IsBlocked
          L9_2 = L7_2
          L10_2 = L2_2.number
          L8_2 = L8_2(L9_2, L10_2)
          if L8_2 then
            L8_2 = {}
            L8_2.ok = false
            L8_2.error = "blocked"
            return L8_2
          end
        end
      end
    end
  end
  L7_2 = A1_2.mutedUntil
  if nil ~= L7_2 then
    L7_2 = A1_2.mutedUntil
    if true ~= L7_2 then
      L7_2 = A1_2.mutedUntil
      if false ~= L7_2 then
        L7_2 = tonumber
        L8_2 = A1_2.mutedUntil
        L7_2 = L7_2(L8_2)
        if not L7_2 or L7_2 ~= L7_2 then
          L8_2 = {}
          L8_2.ok = false
          L8_2.error = "invalid"
          return L8_2
        end
      end
    end
  end
  L7_2 = L4_2.locked
  if L7_2 then
    L7_2 = 1
    if L7_2 then
      goto lbl_105
    end
  end
  L7_2 = 0
  ::lbl_105::
  L8_2 = A1_2.locked
  if nil ~= L8_2 then
    L8_2 = L17_1
    L9_2 = A1_2.locked
    L8_2 = L8_2(L9_2)
    if 0 == L8_2 then
      L9_2 = L4_2.locked
      if L9_2 then
        L9_2 = L44_1
        L10_2 = A0_2
        L9_2 = L9_2(L10_2)
        if not L9_2 then
          L9_2 = RPC
          L9_2 = L9_2["account.verifyPin"]
          L10_2 = type
          L11_2 = A1_2.pin
          L10_2 = L10_2(L11_2)
          if "string" ~= L10_2 then
            L10_2 = type
            L11_2 = A1_2.pin
            L10_2 = L10_2(L11_2)
            if "number" ~= L10_2 then
              goto lbl_142
            end
          end
          L10_2 = tostring
          L11_2 = A1_2.pin
          L10_2 = L10_2(L11_2)
          L11_2 = L10_2
          L10_2 = L10_2.sub
          L12_2 = 1
          L13_2 = 10
          L10_2 = L10_2(L11_2, L12_2, L13_2)
          ::lbl_142::
          if not L10_2 then
            L10_2 = nil
          end
          L11_2 = false
          L12_2 = nil
          if L10_2 then
            L13_2 = type
            L14_2 = L9_2
            L13_2 = L13_2(L14_2)
            if "function" == L13_2 then
              L13_2 = pcall
              L14_2 = L9_2
              L15_2 = A0_2
              L16_2 = {}
              L16_2.pin = L10_2
              L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2)
              L12_2 = L14_2
              L11_2 = L13_2
            end
          end
          if L11_2 then
            L13_2 = type
            L14_2 = L12_2
            L13_2 = L13_2(L14_2)
            if "table" == L13_2 then
              L13_2 = L12_2.ok
              if true == L13_2 then
                goto lbl_202
              end
            end
          end
          L13_2 = {}
          L13_2.ok = false
          if L11_2 then
            L14_2 = type
            L15_2 = L12_2
            L14_2 = L14_2(L15_2)
            if "table" == L14_2 then
              L14_2 = L12_2.lockedUntil
              if L14_2 then
                L14_2 = "pinlocked"
                if L14_2 then
                  goto lbl_188
                end
              end
            end
          end
          L14_2 = "locked"
          ::lbl_188::
          L13_2.error = L14_2
          if L11_2 then
            L14_2 = type
            L15_2 = L12_2
            L14_2 = L14_2(L15_2)
            if "table" == L14_2 then
              L14_2 = L12_2.wait
              if L14_2 then
                goto lbl_200
              end
            end
          end
          L14_2 = nil
          ::lbl_200::
          L13_2.wait = L14_2
          do return L13_2 end
          ::lbl_202::
          L13_2 = L42_1
          L14_2 = {}
          L15_2 = GetCid
          L16_2 = A0_2
          L15_2 = L15_2(L16_2)
          L14_2.cid = L15_2
          L15_2 = GetGameTimer
          L15_2 = L15_2()
          L16_2 = L2_1
          L15_2 = L15_2 + L16_2
          L14_2.untilT = L15_2
          L13_2[A0_2] = L14_2
        end
      end
    end
    L7_2 = L8_2
  end
  L8_2 = A1_2.pinned
  if nil == L8_2 then
    L8_2 = A1_2.mutedUntil
    if nil == L8_2 then
      goto lbl_371
    end
  end
  L8_2 = A1_2.pinned
  if true == L8_2 then
    L9_2 = L4_2.pinned
    if not L9_2 then
      L9_2 = pcall
      L10_2 = MySQL
      L10_2 = L10_2.scalar
      L10_2 = L10_2.await
      L11_2 = "SELECT COUNT(*) FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND pinned = 1 AND other <> ?"
      L12_2 = {}
      L13_2 = L2_2.me
      L14_2 = L0_1
      L15_2 = L2_2.other
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
        L12_2 = L4_1
        if L11_2 >= L12_2 then
          L11_2 = {}
          L11_2.ok = false
          L11_2.error = "pinlimit"
          L12_2 = L4_1
          L11_2.max = L12_2
          return L11_2
        end
      end
    end
  end
  L9_2 = {}
  L10_2 = L0_1
  L9_2.app = L10_2
  if nil ~= L8_2 then
    L10_2 = true == L8_2 or 1 == L8_2
    L9_2.pinned = L10_2
  end
  L10_2 = A1_2.mutedUntil
  if nil ~= L10_2 then
    L10_2 = A1_2.mutedUntil
    if true == L10_2 or -1 == L10_2 then
      L9_2.mutedUntil = true
    else
      if false ~= L10_2 then
        L11_2 = tonumber
        L12_2 = L10_2
        L11_2 = L11_2(L12_2)
        if 0 ~= L11_2 then
          goto lbl_291
        end
      end
      L9_2.mutedUntil = false
      goto lbl_312
      ::lbl_291::
      L11_2 = tonumber
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if not L11_2 or L11_2 ~= L11_2 then
        L12_2 = {}
        L12_2.ok = false
        L12_2.error = "invalid"
        return L12_2
      end
      L12_2 = math
      L12_2 = L12_2.floor
      L13_2 = math
      L13_2 = L13_2.min
      L14_2 = L11_2
      L15_2 = L1_1
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L13_2(L14_2, L15_2)
      L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      L9_2.mutedUntil = L12_2
    end
  end
  ::lbl_312::
  L10_2 = L2_2.conv
  if L10_2 then
    L10_2 = L2_2.conv
    L9_2.conversation = L10_2
  else
    L10_2 = L2_2.number
    L9_2.number = L10_2
  end
  L10_2 = RPC
  L10_2 = L10_2["thread.set"]
  L11_2 = type
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  if "function" ~= L11_2 then
    L11_2 = {}
    L11_2.ok = false
    L11_2.error = "internal"
    return L11_2
  end
  L11_2 = pcall
  L12_2 = L10_2
  L13_2 = A0_2
  L14_2 = L9_2
  L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
  if L11_2 then
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = L12_2.ok
      if false ~= L13_2 then
        goto lbl_363
      end
    end
  end
  L13_2 = {}
  L13_2.ok = false
  if L11_2 then
    L14_2 = type
    L15_2 = L12_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = L12_2.error
      if L14_2 then
        goto lbl_361
      end
    end
  end
  L14_2 = "internal"
  ::lbl_361::
  L13_2.error = L14_2
  do return L13_2 end
  ::lbl_363::
  L13_2 = L12_2.pinned
  L13_2 = true == L13_2
  L14_2 = L12_2.mutedUntil
  L5_2.mutedUntil = L14_2
  L5_2.pinned = L13_2
  ::lbl_371::
  L8_2 = L4_2.archived
  if L8_2 then
    L8_2 = 1
    if L8_2 then
      goto lbl_378
    end
  end
  L8_2 = 0
  ::lbl_378::
  L9_2 = L4_2.markedUnread
  if L9_2 then
    L9_2 = 1
    if L9_2 then
      goto lbl_385
    end
  end
  L9_2 = 0
  ::lbl_385::
  L10_2 = A1_2.archived
  if nil ~= L10_2 then
    L10_2 = L17_1
    L11_2 = A1_2.archived
    L10_2 = L10_2(L11_2)
    L8_2 = L10_2
  end
  L10_2 = A1_2.markedUnread
  if nil ~= L10_2 then
    L10_2 = L17_1
    L11_2 = A1_2.markedUnread
    L10_2 = L10_2(L11_2)
    L9_2 = L10_2
  end
  L10_2 = L4_2.archived
  if L10_2 then
    L10_2 = 1
    if L10_2 then
      goto lbl_406
    end
  end
  L10_2 = 0
  ::lbl_406::
  if L8_2 == L10_2 then
    L10_2 = L4_2.markedUnread
    if L10_2 then
      L10_2 = 1
      if L10_2 then
        goto lbl_415
      end
    end
    L10_2 = 0
    ::lbl_415::
    if L9_2 == L10_2 then
      L10_2 = L4_2.locked
      if L10_2 then
        L10_2 = 1
        if L10_2 then
          goto lbl_424
        end
      end
      L10_2 = 0
      ::lbl_424::
      if L7_2 == L10_2 then
        goto lbl_466
      end
    end
  end
  L10_2 = pcall
  L11_2 = MySQL
  L11_2 = L11_2.query
  L11_2 = L11_2.await
  L12_2 = [[
INSERT INTO apex_phone_thread_meta (owner, app, other, archived, marked_unread, locked, pinned) VALUES (?, ?, ?, ?, ?, ?, 0)
            ON DUPLICATE KEY UPDATE archived = VALUES(archived), marked_unread = VALUES(marked_unread), locked = VALUES(locked)]]
  L13_2 = {}
  L14_2 = L2_2.me
  L15_2 = L0_1
  L16_2 = L2_2.other
  L17_2 = L8_2
  L18_2 = L9_2
  L19_2 = L7_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L13_2[6] = L19_2
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  if not L10_2 then
    L11_2 = {}
    L11_2.ok = false
    L11_2.error = "db"
    return L11_2
  end
  if 1 == L8_2 then
    L11_2 = L4_2.archived
    if not L11_2 then
      L11_2 = pcall
      L12_2 = MySQL
      L12_2 = L12_2.update
      L12_2 = L12_2.await
      L13_2 = "UPDATE apex_phone_thread_meta SET pinned = 0 WHERE owner = ? AND app = ? AND other = ?"
      L14_2 = {}
      L15_2 = L2_2.me
      L16_2 = L0_1
      L17_2 = L2_2.other
      L14_2[1] = L15_2
      L14_2[2] = L16_2
      L14_2[3] = L17_2
      L11_2(L12_2, L13_2, L14_2)
      L5_2.pinned = false
    end
  end
  ::lbl_466::
  L10_2 = 1 == L8_2
  L11_2 = 1 == L9_2
  L12_2 = 1 == L7_2
  L5_2.locked = L12_2
  L5_2.markedUnread = L11_2
  L5_2.archived = L10_2
  if nil ~= L6_2 then
    L10_2 = L6_2
    L11_2 = L2_2.conv
    if L11_2 then
      L11_2 = L38_1
      L12_2 = L2_2
      L11_2 = L11_2(L12_2)
      if L11_2 == L10_2 then
        goto lbl_569
      end
      L12_2 = pcall
      L13_2 = MySQL
      L13_2 = L13_2.update
      L13_2 = L13_2.await
      L14_2 = "UPDATE apex_phone_conversations SET disappearing = ? WHERE id = ?"
      L15_2 = {}
      L16_2 = L10_2
      L17_2 = L2_2.conv
      L15_2[1] = L16_2
      L15_2[2] = L17_2
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      if not L12_2 then
        L13_2 = {}
        L13_2.ok = false
        L13_2.error = "db"
        return L13_2
      end
      L13_2 = RecadoSystemMessage
      L14_2 = A0_2
      L15_2 = L2_2
      L16_2 = "disappearing"
      if L10_2 > 0 then
        L17_2 = "Mensagens tempor\195\161rias ativadas: %s"
        L18_2 = L17_2
        L17_2 = L17_2.format
        L19_2 = L41_1
        L20_2 = L10_2
        L19_2, L20_2 = L19_2(L20_2)
        L17_2 = L17_2(L18_2, L19_2, L20_2)
        if L17_2 then
          goto lbl_525
        end
      end
      L17_2 = "Mensagens tempor\195\161rias desativadas"
      ::lbl_525::
      L18_2 = {}
      L18_2.seconds = L10_2
      L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
    else
      L11_2 = L4_2.disappearing
      if not L11_2 then
        L11_2 = 0
      end
      if L11_2 ~= L10_2 then
        L11_2 = L59_1
        L12_2 = L2_2
        L13_2 = L10_2
        L11_2 = L11_2(L12_2, L13_2)
        if not L11_2 then
          L11_2 = {}
          L11_2.ok = false
          L11_2.error = "db"
          return L11_2
        end
        L12_2 = L2_2.key
        L11_2 = L60_1
        L11_2[L12_2] = true
        L11_2 = RecadoSystemMessage
        L12_2 = A0_2
        L13_2 = L2_2
        L14_2 = "disappearing"
        if L10_2 > 0 then
          L15_2 = "Mensagens tempor\195\161rias ativadas: %s"
          L16_2 = L15_2
          L15_2 = L15_2.format
          L17_2 = L41_1
          L18_2 = L10_2
          L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
          L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
          if L15_2 then
            goto lbl_565
          end
        end
        L15_2 = "Mensagens tempor\195\161rias desativadas"
        ::lbl_565::
        L16_2 = {}
        L16_2.seconds = L10_2
        L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
      end
    end
    ::lbl_569::
    L5_2.disappearing = L10_2
  end
  return L5_2
end
L66_1(L67_1, L68_1)
L66_1 = L29_1
L67_1 = "recado.star"
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L62_1
  L3_2 = A0_2
  L4_2 = A1_2.id
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = L4_2
    return L5_2
  end
  L5_2 = L2_2.type
  if "system" ~= L5_2 then
    L5_2 = L2_2.deleted_all
    if nil == L5_2 then
      goto lbl_23
    end
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "unsupported"
  do return L5_2 end
  ::lbl_23::
  L5_2 = A1_2.on
  L5_2 = false ~= L5_2
  if L5_2 then
    L6_2 = pcall
    L7_2 = MySQL
    L7_2 = L7_2.scalar
    L7_2 = L7_2.await
    L8_2 = "SELECT COUNT(*) FROM apex_phone_recado_stars WHERE who = ?"
    L9_2 = {}
    L10_2 = L3_2
    L9_2[1] = L10_2
    L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      L8_2 = tonumber
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if not L8_2 then
        L8_2 = 0
      end
      L9_2 = L5_1
      if L8_2 >= L9_2 then
        L8_2 = {}
        L8_2.ok = false
        L8_2.error = "limit"
        L9_2 = L5_1
        L8_2.max = L9_2
        return L8_2
      end
    end
    L8_2 = pcall
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "INSERT INTO apex_phone_recado_stars (message_id, who, created) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE created = created"
    L11_2 = {}
    L12_2 = L2_2.id
    L13_2 = L3_2
    L14_2 = Now
    L14_2 = L14_2()
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L11_2[3] = L14_2
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if not L8_2 then
      L9_2 = {}
      L9_2.ok = false
      L9_2.error = "db"
      return L9_2
    end
  else
    L6_2 = pcall
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = "DELETE FROM apex_phone_recado_stars WHERE message_id = ? AND who = ?"
    L9_2 = {}
    L10_2 = L2_2.id
    L11_2 = L3_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L6_2(L7_2, L8_2, L9_2)
  end
  L6_2 = {}
  L6_2.ok = true
  L7_2 = L2_2.id
  L6_2.id = L7_2
  L6_2.starred = L5_2
  return L6_2
end
L66_1(L67_1, L68_1)
L66_1 = L29_1
L67_1 = "recado.starred"
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2
  L2_2 = L19_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noidentity"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A1_2.before
  L3_2 = L3_2(L4_2)
  L4_2 = [[
SELECT s.message_id, s.created AS starred_at, m.sender, m.receiver, m.type, m.content,
        CASE WHEN CHAR_LENGTH(m.payload) > 8192 THEN NULL ELSE m.payload END AS payload, m.created, m.conversation_id, m.deleted_all,
        m.deleted_sender, m.deleted_receiver, m.expires_at, m.view_once
        FROM apex_phone_recado_stars s JOIN apex_phone_messages m ON m.id = s.message_id
        WHERE s.who = ? AND m.app = ?]]
  if L3_2 then
    L5_2 = " AND s.created < ?"
    if L5_2 then
      goto lbl_20
    end
  end
  L5_2 = ""
  ::lbl_20::
  L6_2 = " ORDER BY s.created DESC LIMIT 40"
  L4_2 = L4_2 .. L5_2 .. L6_2
  L5_2 = {}
  L6_2 = L2_2
  L7_2 = L0_1
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  if L3_2 then
    L6_2 = #L5_2
    L6_2 = L6_2 + 1
    L5_2[L6_2] = L3_2
  end
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = L4_2
  L9_2 = L5_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
  if L6_2 then
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      goto lbl_50
    end
  end
  L8_2 = {}
  do return L8_2 end
  ::lbl_50::
  L8_2 = {}
  L9_2 = {}
  L10_2 = pcall
  L11_2 = MySQL
  L11_2 = L11_2.query
  L11_2 = L11_2.await
  L12_2 = [[
SELECT cm.conversation_id, cm.joined, c.title FROM apex_phone_conversation_members cm
        JOIN apex_phone_conversations c ON c.id = cm.conversation_id WHERE cm.member = ? AND cm.left_at IS NULL AND c.app = ? LIMIT 400]]
  L13_2 = {}
  L14_2 = L2_2
  L15_2 = L0_1
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2)
  if L10_2 then
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = ipairs
      L13_2 = L11_2
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
      for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
        L18_2 = L10_1
        L19_2 = L17_2.conversation_id
        L18_2 = L18_2(L19_2)
        if L18_2 then
          L19_2 = tonumber
          L20_2 = L17_2.joined
          L19_2 = L19_2(L20_2)
          if not L19_2 then
            L19_2 = 0
          end
          L8_2[L18_2] = L19_2
          L19_2 = L17_2.title
          L9_2[L18_2] = L19_2
        end
      end
    end
  end
  L12_2 = {}
  L13_2 = pcall
  L14_2 = MySQL
  L14_2 = L14_2.query
  L14_2 = L14_2.await
  L15_2 = "SELECT other, locked, cleared_before FROM apex_phone_thread_meta WHERE owner = ? AND app = ? LIMIT 2000"
  L16_2 = {}
  L17_2 = L2_2
  L18_2 = L0_1
  L16_2[1] = L17_2
  L16_2[2] = L18_2
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
        L21_2 = tostring
        L22_2 = L20_2.other
        L21_2 = L21_2(L22_2)
        L12_2[L21_2] = L20_2
      end
    end
  end
  L15_2 = nil
  L16_2 = Now
  L16_2 = L16_2()
  L17_2 = {}
  L18_2 = ipairs
  L19_2 = L7_2
  L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
  for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
    L24_2 = L10_1
    L25_2 = L23_2.conversation_id
    L24_2 = L24_2(L25_2)
    L25_2 = tonumber
    L26_2 = L23_2.expires_at
    L25_2 = L25_2(L26_2)
    L26_2 = L23_2.deleted_all
    L26_2 = nil == L26_2 and (not L25_2 or not (L16_2 >= L25_2))
    if L26_2 then
      if L24_2 then
        L27_2 = L8_2[L24_2]
        L26_2 = nil ~= L27_2
      else
        L27_2 = L23_2.sender
        if L27_2 == L2_2 then
          L27_2 = tonumber
          L28_2 = L23_2.deleted_sender
          L27_2 = L27_2(L28_2)
        end
        L26_2 = 1 ~= L27_2
      end
    end
    if L26_2 then
      if L24_2 then
        L27_2 = "g:"
        L28_2 = L24_2
        L27_2 = L27_2 .. L28_2
        if L27_2 then
          goto lbl_213
        end
      end
      L27_2 = L23_2.sender
      if L27_2 == L2_2 then
        L27_2 = tostring
        L28_2 = L23_2.receiver
        L27_2 = L27_2(L28_2)
        if L27_2 then
          goto lbl_213
        end
      end
      L27_2 = tostring
      L28_2 = L23_2.sender
      L27_2 = L27_2(L28_2)
      ::lbl_213::
      L27_2 = L12_2[L27_2]
      if L27_2 then
        L28_2 = L10_1
        L29_2 = L27_2.cleared_before
        L28_2 = L28_2(L29_2)
        L29_2 = L10_1
        L30_2 = L23_2.message_id
        L29_2 = L29_2(L30_2)
        if L28_2 and L29_2 and L28_2 >= L29_2 then
          L26_2 = false
        end
        if L26_2 then
          L30_2 = tonumber
          L31_2 = L27_2.locked
          L30_2 = L30_2(L31_2)
          if 1 == L30_2 then
            if nil == L15_2 then
              L30_2 = L44_1
              L31_2 = A0_2
              L30_2 = L30_2(L31_2)
              L15_2 = L30_2
            end
            L26_2 = L15_2
          end
        end
      end
    end
    if L26_2 then
      L27_2 = tonumber
      L28_2 = L23_2.view_once
      L27_2 = L27_2(L28_2)
      L27_2 = 1 == L27_2
      L28_2 = L18_1
      L29_2 = L23_2.payload
      L28_2 = L28_2(L29_2)
      L29_2 = {}
      L30_2 = L10_1
      L31_2 = L23_2.message_id
      L30_2 = L30_2(L31_2)
      L29_2.id = L30_2
      L30_2 = tonumber
      L31_2 = L23_2.starred_at
      L30_2 = L30_2(L31_2)
      L29_2.starredAt = L30_2
      L30_2 = L23_2.sender
      L29_2.sender = L30_2
      L30_2 = L23_2.type
      if not L30_2 then
        L30_2 = "text"
      end
      L29_2.type = L30_2
      if L27_2 then
        L30_2 = ""
        if L30_2 then
          goto lbl_284
        end
      end
      L30_2 = L12_1
      L31_2 = L23_2.content
      if not L31_2 then
        L31_2 = ""
      end
      L32_2 = 1000
      L30_2 = L30_2(L31_2, L32_2)
      ::lbl_284::
      L29_2.content = L30_2
      L30_2 = tonumber
      L31_2 = L23_2.created
      L30_2 = L30_2(L31_2)
      L29_2.created = L30_2
      L30_2 = L23_2.sender
      L30_2 = L30_2 == L2_2
      L29_2.mine = L30_2
      L30_2 = L48_1
      L31_2 = L28_2
      L32_2 = L27_2
      L30_2 = L30_2(L31_2, L32_2)
      L29_2.payload = L30_2
      L30_2 = L27_2 or L30_2
      if not L27_2 then
        L30_2 = nil
      end
      L29_2.viewOnce = L30_2
      L30_2 = L47_1
      L31_2 = L23_2
      L32_2 = L28_2
      L30_2 = L30_2(L31_2, L32_2)
      L29_2.preview = L30_2
      if L24_2 then
        L30_2 = L24_2
        L31_2 = L9_2[L24_2]
        L29_2.groupTitle = L31_2
        L29_2.conversation = L30_2
      else
        L30_2 = L23_2.sender
        if L30_2 == L2_2 then
          L30_2 = L23_2.receiver
          if L30_2 then
            goto lbl_323
          end
        end
        L30_2 = L23_2.sender
        ::lbl_323::
        L29_2.number = L30_2
      end
      L30_2 = #L17_2
      L30_2 = L30_2 + 1
      L17_2[L30_2] = L29_2
    end
  end
  return L17_2
end
L66_1(L67_1, L68_1)
function L66_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT message_id FROM apex_phone_recado_pins WHERE thread = ? ORDER BY created DESC LIMIT 20"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  L3_2 = {}
  if L1_2 then
    L4_2 = type
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = ipairs
      L5_2 = L2_2
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = L10_1
        L11_2 = L9_2.message_id
        L10_2 = L10_2(L11_2)
        if L10_2 then
          L11_2 = #L3_2
          L11_2 = L11_2 + 1
          L3_2[L11_2] = L10_2
        end
      end
    end
  end
  return L3_2
end
L67_1 = L29_1
L68_1 = "recado.pin"
function L69_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L62_1
  L3_2 = A0_2
  L4_2 = A1_2.id
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = L4_2
    return L5_2
  end
  L5_2 = L2_2.type
  if "system" ~= L5_2 then
    L5_2 = L2_2.deleted_all
    if nil == L5_2 then
      goto lbl_23
    end
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "unsupported"
  do return L5_2 end
  ::lbl_23::
  L5_2 = L2_2.conv
  if L5_2 then
    L5_2 = L36_1
    L6_2 = RecadoGroupCanSend
    L7_2 = L2_2.conv
    L8_2 = L3_2
    L9_2 = L2_2.role
    L10_2 = "send_policy"
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    if not L5_2 then
      L5_2 = {}
      L5_2.ok = false
      L5_2.error = "adminsonly"
      return L5_2
    end
  end
  L5_2 = A1_2.on
  L5_2 = false ~= L5_2
  if L5_2 then
    L6_2 = pcall
    L7_2 = MySQL
    L7_2 = L7_2.scalar
    L7_2 = L7_2.await
    L8_2 = "SELECT 1 FROM apex_phone_recado_pins WHERE thread = ? AND message_id = ?"
    L9_2 = {}
    L10_2 = L2_2.key
    L11_2 = L2_2.id
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
    if not L6_2 or not L7_2 then
      L8_2 = pcall
      L9_2 = MySQL
      L9_2 = L9_2.scalar
      L9_2 = L9_2.await
      L10_2 = "SELECT COUNT(*) FROM apex_phone_recado_pins WHERE thread = ?"
      L11_2 = {}
      L12_2 = L2_2.key
      L11_2[1] = L12_2
      L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
      L10_2 = L9_1
      L10_2 = L10_2()
      L10_2 = L10_2.pinsMax
      if L8_2 then
        L11_2 = tonumber
        L12_2 = L9_2
        L11_2 = L11_2(L12_2)
        if not L11_2 then
          L11_2 = 0
        end
        if L10_2 <= L11_2 then
          L11_2 = {}
          L11_2.ok = false
          L11_2.error = "pinlimit"
          L11_2.max = L10_2
          return L11_2
        end
      end
      L11_2 = pcall
      L12_2 = MySQL
      L12_2 = L12_2.query
      L12_2 = L12_2.await
      L13_2 = "INSERT INTO apex_phone_recado_pins (thread, message_id, pinned_by, created) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE created = created"
      L14_2 = {}
      L15_2 = L2_2.key
      L16_2 = L2_2.id
      L17_2 = L3_2
      L18_2 = Now
      L18_2 = L18_2()
      L14_2[1] = L15_2
      L14_2[2] = L16_2
      L14_2[3] = L17_2
      L14_2[4] = L18_2
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      if not L11_2 then
        L12_2 = {}
        L12_2.ok = false
        L12_2.error = "db"
        return L12_2
      end
    end
  else
    L6_2 = pcall
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = "DELETE FROM apex_phone_recado_pins WHERE thread = ? AND message_id = ?"
    L9_2 = {}
    L10_2 = L2_2.key
    L11_2 = L2_2.id
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L6_2(L7_2, L8_2, L9_2)
  end
  L6_2 = L66_1
  L7_2 = L2_2.key
  L6_2 = L6_2(L7_2)
  L7_2 = {}
  L8_2 = L0_1
  L7_2.app = L8_2
  L8_2 = L2_2.id
  L7_2.id = L8_2
  L7_2.on = L5_2
  L7_2.by = L3_2
  L8_2 = #L6_2
  L8_2 = L6_2 or L8_2
  if not (L8_2 > 0) or not L6_2 then
    L8_2 = nil
  end
  L7_2.pins = L8_2
  L8_2 = L2_2.conv
  if L8_2 then
    L8_2 = L2_2.conv
    L7_2.conversation = L8_2
    L8_2 = type
    L9_2 = GroupBroadcast
    L8_2 = L8_2(L9_2)
    if "function" == L8_2 then
      L8_2 = pcall
      L9_2 = GroupBroadcast
      L10_2 = L2_2.conv
      L11_2 = "recadoPins"
      L12_2 = L7_2
      L13_2 = L3_2
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    end
  else
    L8_2 = L2_2.other
    if L8_2 ~= L3_2 then
      L8_2 = GetSrcByNumber
      L9_2 = L2_2.other
      L8_2 = L8_2(L9_2)
      if L8_2 and L8_2 ~= A0_2 then
        L9_2 = HasPhoneItem
        if L9_2 then
          L9_2 = HasPhoneItem
          L10_2 = L8_2
          L9_2 = L9_2(L10_2)
          if not L9_2 then
            goto lbl_195
          end
        end
        L9_2 = GetCid
        L10_2 = L8_2
        L9_2 = L9_2(L10_2)
        if L9_2 then
          L10_2 = IsBlocked
          L11_2 = L9_2
          L12_2 = L3_2
          L10_2 = L10_2(L11_2, L12_2)
          if L10_2 then
            goto lbl_195
          end
        end
        L7_2.number = L3_2
        L10_2 = Push
        L11_2 = L8_2
        L12_2 = "recadoPins"
        L13_2 = L7_2
        L10_2(L11_2, L12_2, L13_2)
      end
    end
  end
  ::lbl_195::
  L8_2 = {}
  L8_2.ok = true
  L9_2 = L2_2.id
  L8_2.id = L9_2
  L8_2.pinned = L5_2
  L9_2 = #L6_2
  L9_2 = L6_2 or L9_2
  if not (L9_2 > 0) or not L6_2 then
    L9_2 = nil
  end
  L8_2.pins = L9_2
  return L8_2
end
L67_1(L68_1, L69_1)
L67_1 = L29_1
L68_1 = "recado.pins"
function L69_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L2_2 = L34_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L37_1
  L5_2 = L2_2.me
  L6_2 = L2_2.other
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L4_2.locked
    if L5_2 then
      L5_2 = L44_1
      L6_2 = A0_2
      L5_2 = L5_2(L6_2)
      if not L5_2 then
        L5_2 = {}
        L5_2.error = "locked"
        return L5_2
      end
    end
  end
  L5_2 = pcall
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = [[
SELECT p.message_id, p.pinned_by, p.created AS pinned_at, m.sender, m.receiver, m.type, m.content, m.created,
        m.deleted_all, m.deleted_sender, m.deleted_receiver, m.expires_at, m.view_once, m.conversation_id,
        CASE WHEN CHAR_LENGTH(m.payload) > 8192 THEN NULL ELSE m.payload END AS payload
        FROM apex_phone_recado_pins p JOIN apex_phone_messages m ON m.id = p.message_id WHERE p.thread = ? ORDER BY p.created DESC LIMIT 20]]
  L8_2 = {}
  L9_2 = L2_2.key
  L8_2[1] = L9_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      goto lbl_49
    end
  end
  L7_2 = {}
  do return L7_2 end
  ::lbl_49::
  L7_2 = Now
  L7_2 = L7_2()
  if L4_2 then
    L8_2 = L4_2.clearedBefore
    if L8_2 then
      goto lbl_57
    end
  end
  L8_2 = nil
  ::lbl_57::
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L6_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L10_1
    L17_2 = L15_2.message_id
    L16_2 = L16_2(L17_2)
    L17_2 = tonumber
    L18_2 = L15_2.expires_at
    L17_2 = L17_2(L18_2)
    L18_2 = L16_2
    if L16_2 then
      L18_2 = L15_2.deleted_all
      L18_2 = nil == L18_2 and (not L17_2 or not (L7_2 >= L17_2)) and (not L8_2 or not (L8_2 >= L16_2))
    end
    if L18_2 then
      L19_2 = L2_2.conv
      if L19_2 then
        L19_2 = tonumber
        L20_2 = L15_2.created
        L19_2 = L19_2(L20_2)
        if not L19_2 then
          L19_2 = 0
        end
        L20_2 = L2_2.joined
        if not L20_2 then
          L20_2 = 0
        end
        L18_2 = L19_2 >= L20_2
      end
    end
    if L18_2 then
      L19_2 = L2_2.conv
      if not L19_2 then
        L19_2 = L15_2.receiver
        L20_2 = L2_2.me
        if L19_2 == L20_2 then
          L19_2 = L15_2.sender
          L20_2 = L2_2.me
          if L19_2 ~= L20_2 then
            L19_2 = tonumber
            L20_2 = L15_2.deleted_receiver
            L19_2 = L19_2(L20_2)
            if 1 == L19_2 then
              L18_2 = false
            end
          end
        end
      end
    end
    if L18_2 then
      L19_2 = L15_2.sender
      L20_2 = L2_2.me
      if L19_2 == L20_2 then
        L19_2 = tonumber
        L20_2 = L15_2.deleted_sender
        L19_2 = L19_2(L20_2)
        if 1 == L19_2 then
          L19_2 = L2_2.conv
          if not L19_2 then
            L19_2 = L15_2.receiver
            L20_2 = L2_2.me
            if L19_2 == L20_2 then
              goto lbl_141
            end
          end
          L18_2 = false
        end
      end
    end
    ::lbl_141::
    if L18_2 then
      L19_2 = L18_1
      L20_2 = L15_2.payload
      L19_2 = L19_2(L20_2)
      L20_2 = tonumber
      L21_2 = L15_2.view_once
      L20_2 = L20_2(L21_2)
      L20_2 = 1 == L20_2
      L21_2 = #L9_2
      L21_2 = L21_2 + 1
      L22_2 = {}
      L22_2.id = L16_2
      L23_2 = L15_2.sender
      L22_2.sender = L23_2
      L23_2 = L15_2.type
      if not L23_2 then
        L23_2 = "text"
      end
      L22_2.type = L23_2
      L23_2 = tonumber
      L24_2 = L15_2.created
      L23_2 = L23_2(L24_2)
      L22_2.created = L23_2
      L23_2 = L15_2.pinned_by
      L22_2.pinnedBy = L23_2
      L23_2 = tonumber
      L24_2 = L15_2.pinned_at
      L23_2 = L23_2(L24_2)
      L22_2.pinnedAt = L23_2
      if not L20_2 then
        L23_2 = L15_2.type
        if "text" == L23_2 then
          goto lbl_184
        end
      end
      L23_2 = ""
      ::lbl_184::
      if not L23_2 then
        L23_2 = L12_1
        L24_2 = L15_2.content
        if not L24_2 then
          L24_2 = ""
        end
        L25_2 = 300
        L23_2 = L23_2(L24_2, L25_2)
      end
      L22_2.content = L23_2
      L23_2 = L47_1
      L24_2 = L15_2
      L25_2 = L19_2
      L23_2 = L23_2(L24_2, L25_2)
      L22_2.preview = L23_2
      L9_2[L21_2] = L22_2
    end
  end
  return L9_2
end
L67_1(L68_1, L69_1)
L67_1 = L29_1
L68_1 = "recado.viewOnce"
function L69_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L62_1
  L3_2 = A0_2
  L4_2 = A1_2.id
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L4_2
    return L5_2
  end
  L5_2 = tonumber
  L6_2 = L2_2.view_once
  L5_2 = L5_2(L6_2)
  if 1 == L5_2 then
    L5_2 = L2_2.type
    if "image" == L5_2 then
      goto lbl_26
    end
    L5_2 = L2_2.type
    if "audio" == L5_2 then
      goto lbl_26
    end
  end
  L5_2 = {}
  L5_2.error = "invalid"
  do return L5_2 end
  ::lbl_26::
  L5_2 = L2_2.deleted_all
  if nil ~= L5_2 then
    L5_2 = {}
    L5_2.error = "deleted"
    return L5_2
  end
  L5_2 = L2_2.sender
  if L5_2 == L3_2 then
    L5_2 = {}
    L5_2.error = "mine"
    return L5_2
  end
  L5_2 = Now
  L5_2 = L5_2()
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "INSERT IGNORE INTO apex_phone_recado_views (message_id, who, viewed_at) VALUES (?, ?, ?)"
  L9_2 = {}
  L10_2 = L2_2.id
  L11_2 = L3_2
  L12_2 = L5_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L8_2 = {}
    L8_2.error = "db"
    return L8_2
  end
  L8_2 = tonumber
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  if L8_2 < 1 then
    L8_2 = {}
    L8_2.error = "viewed"
    return L8_2
  end
  L8_2 = L18_1
  L9_2 = L2_2.payload
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = {}
  end
  L9_2 = L10_1
  L10_2 = L8_2.mediaId
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L10_2 = {}
    L10_2.error = "badmedia"
    return L10_2
  end
  L10_2 = L22_1
  L10_2[L9_2] = true
  L10_2 = L45_1
  L11_2 = L45_1
  L11_2 = L11_2[A0_2]
  if not L11_2 then
    L11_2 = {}
  end
  L10_2[A0_2] = L11_2
  L10_2 = L45_1
  L10_2 = L10_2[A0_2]
  L11_2 = GetGameTimer
  L11_2 = L11_2()
  L12_2 = L3_1
  L11_2 = L11_2 + L12_2
  L10_2[L9_2] = L11_2
  L10_2 = L2_2.conv
  if not L10_2 then
    L10_2 = pcall
    L11_2 = MySQL
    L11_2 = L11_2.update
    L11_2 = L11_2.await
    L12_2 = "UPDATE apex_phone_messages SET viewed_at = ? WHERE id = ? AND viewed_at IS NULL"
    L13_2 = {}
    L14_2 = L5_2
    L15_2 = L2_2.id
    L13_2[1] = L14_2
    L13_2[2] = L15_2
    L10_2(L11_2, L12_2, L13_2)
  end
  L10_2 = GetSrcByNumber
  L11_2 = L2_2.sender
  L10_2 = L10_2(L11_2)
  L11_2 = L40_1
  L12_2 = L3_2
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = L40_1
    L12_2 = L2_2.sender
    L11_2 = L11_2(L12_2)
  end
  if not L11_2 then
    L12_2 = GetCid
    L13_2 = A0_2
    L12_2 = L12_2(L13_2)
    if L10_2 then
      L13_2 = GetCid
      L14_2 = L10_2
      L13_2 = L13_2(L14_2)
      if L13_2 then
        goto lbl_144
      end
    end
    L13_2 = nil
    ::lbl_144::
    if nil ~= L12_2 then
      L14_2 = IsBlocked
      L15_2 = L12_2
      L16_2 = L2_2.sender
      L14_2 = L14_2(L15_2, L16_2)
      L11_2 = L14_2 or L11_2
    end
    L14_2 = IsBlocked
    L15_2 = L13_2
    L16_2 = L3_2
    L14_2 = L14_2(L15_2, L16_2)
    L11_2 = L14_2 or nil ~= L13_2 and L11_2
  end
  if L10_2 and L10_2 ~= A0_2 and not L11_2 then
    L12_2 = HasPhoneItem
    if L12_2 then
      L12_2 = HasPhoneItem
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      if not L12_2 then
        goto lbl_197
      end
    end
    L12_2 = {}
    L13_2 = L2_2.id
    L12_2.id = L13_2
    L13_2 = L0_1
    L12_2.app = L13_2
    L12_2.viewed = true
    L12_2.viewedAt = L5_2
    L12_2.viewedBy = L3_2
    L13_2 = L2_2.conv
    if L13_2 then
      L13_2 = L2_2.conv
      L12_2.conversation = L13_2
    else
      L12_2.number = L3_2
    end
    L13_2 = Push
    L14_2 = L10_2
    L15_2 = "messageUpdate"
    L16_2 = L12_2
    L13_2(L14_2, L15_2, L16_2)
  end
  ::lbl_197::
  L12_2 = {}
  L12_2.ok = true
  L13_2 = L2_2.id
  L12_2.id = L13_2
  L12_2.mediaId = L9_2
  L13_2 = L2_2.type
  L12_2.type = L13_2
  L12_2.viewedAt = L5_2
  L13_2 = L2_2.type
  if "audio" == L13_2 then
    L13_2 = tonumber
    L14_2 = L8_2.duration
    L13_2 = L13_2(L14_2)
    L12_2.duration = L13_2
    L13_2 = type
    L14_2 = L8_2.waveform
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = L8_2.waveform
      if L13_2 then
        goto lbl_222
      end
    end
    L13_2 = nil
    ::lbl_222::
    L12_2.waveform = L13_2
  else
    L13_2 = L12_1
    L14_2 = L2_2.content
    if not L14_2 then
      L14_2 = ""
    end
    L15_2 = 1000
    L13_2 = L13_2(L14_2, L15_2)
    L12_2.caption = L13_2
  end
  return L12_2
end
L67_1(L68_1, L69_1)
L67_1 = {}
L68_1 = L29_1
L69_1 = "recado.recording"
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L34_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = A1_2.on
  L4_2 = false ~= L4_2
  L5_2 = L67_1
  L5_2 = L5_2[A0_2]
  if not L5_2 then
    L6_2 = {}
    L5_2 = L6_2
    L6_2 = L67_1
    L6_2[A0_2] = L5_2
  end
  L6_2 = L2_2.key
  L6_2 = L5_2[L6_2]
  L7_2 = GetGameTimer
  L7_2 = L7_2()
  if L4_2 then
    if L6_2 then
      L8_2 = L6_2.on
      if L8_2 then
        L8_2 = L6_2.at
        L8_2 = L7_2 - L8_2
        L9_2 = L9_1
        L9_2 = L9_2()
        L9_2 = L9_2.typingMs
        if L8_2 < L9_2 then
          L8_2 = {}
          L8_2.ok = true
          return L8_2
        end
      end
    end
  else
    if L6_2 then
      L8_2 = L6_2.on
      if L8_2 then
        goto lbl_59
      end
    end
    L8_2 = {}
    L8_2.ok = true
    return L8_2
  end
  ::lbl_59::
  L8_2 = L2_2.key
  L9_2 = {}
  L9_2.at = L7_2
  L9_2.on = L4_2
  L5_2[L8_2] = L9_2
  L8_2 = L2_2.conv
  if L8_2 then
    L8_2 = type
    L9_2 = GroupBroadcast
    L8_2 = L8_2(L9_2)
    if "function" == L8_2 then
      L8_2 = pcall
      L9_2 = GroupBroadcast
      L10_2 = L2_2.conv
      L11_2 = "recording"
      L12_2 = {}
      L13_2 = L2_2.me
      L12_2.from = L13_2
      L13_2 = L0_1
      L12_2.app = L13_2
      L13_2 = L2_2.conv
      L12_2.conversation = L13_2
      L12_2.on = L4_2
      L13_2 = L2_2.me
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    end
    L8_2 = {}
    L8_2.ok = true
    return L8_2
  end
  L8_2 = L2_2.number
  L9_2 = L2_2.me
  if L8_2 == L9_2 then
    L8_2 = {}
    L8_2.ok = true
    return L8_2
  end
  L8_2 = GetSrcByNumber
  L9_2 = L2_2.number
  L8_2 = L8_2(L9_2)
  if L8_2 and L8_2 ~= A0_2 then
    L9_2 = HasPhoneItem
    if L9_2 then
      L9_2 = HasPhoneItem
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if not L9_2 then
        goto lbl_137
      end
    end
    L9_2 = GetCid
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L10_2 = IsBlocked
      L11_2 = L9_2
      L12_2 = L2_2.me
      L10_2 = L10_2(L11_2, L12_2)
      if L10_2 then
        goto lbl_137
      end
    end
    L10_2 = Push
    L11_2 = L8_2
    L12_2 = "recording"
    L13_2 = {}
    L14_2 = L2_2.me
    L13_2.from = L14_2
    L14_2 = L0_1
    L13_2.app = L14_2
    L13_2.on = L4_2
    L10_2(L11_2, L12_2, L13_2)
  end
  ::lbl_137::
  L9_2 = {}
  L9_2.ok = true
  return L9_2
end
L68_1(L69_1, L70_1)
L68_1 = L29_1
L69_1 = "recado.search"
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2
  L2_2 = L19_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noidentity"
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2.q
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = L12_1
    L4_2 = L13_1
    L5_2 = A1_2.q
    L4_2 = L4_2(L5_2)
    L5_2 = 64
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      goto lbl_24
    end
  end
  L3_2 = ""
  ::lbl_24::
  L4_2 = utf8
  L4_2 = L4_2.len
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  if L4_2 < 2 then
    L4_2 = {}
    L5_2 = {}
    L4_2.chats = L5_2
    L5_2 = {}
    L4_2.messages = L5_2
    return L4_2
  end
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = "%"
  L7_2 = L3_2
  L6_2 = L3_2.gsub
  L8_2 = "[!%%_]"
  L9_2 = "!%0"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = "%"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = {}
  L8_2 = pcall
  L9_2 = MySQL
  L9_2 = L9_2.query
  L9_2 = L9_2.await
  L10_2 = "SELECT other, locked, cleared_before FROM apex_phone_thread_meta WHERE owner = ? AND app = ? LIMIT 2000"
  L11_2 = {}
  L12_2 = L2_2
  L13_2 = L0_1
  L11_2[1] = L12_2
  L11_2[2] = L13_2
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
        L16_2 = tostring
        L17_2 = L15_2.other
        L16_2 = L16_2(L17_2)
        L7_2[L16_2] = L15_2
      end
    end
  end
  function L10_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L7_2
    L1_3 = L1_3[A0_3]
    L2_3 = nil ~= L1_3
    return L2_3
  end
  function L11_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L7_2
    L1_3 = L1_3[A0_3]
    if L1_3 then
      L2_3 = L10_1
      L3_3 = L1_3.cleared_before
      L2_3 = L2_3(L3_3)
      if L2_3 then
        goto lbl_11
      end
    end
    L2_3 = nil
    ::lbl_11::
    return L2_3
  end
  L12_2 = {}
  L13_2 = {}
  if L4_2 then
    L14_2 = pcall
    L15_2 = MySQL
    L15_2 = L15_2.query
    L15_2 = L15_2.await
    L16_2 = "SELECT name, number FROM apex_phone_contacts WHERE owner = ? AND (name LIKE ? ESCAPE '!' OR number LIKE ? ESCAPE '!') ORDER BY name ASC LIMIT 15"
    L17_2 = {}
    L18_2 = L4_2
    L19_2 = L5_2
    L20_2 = L5_2
    L17_2[1] = L18_2
    L17_2[2] = L19_2
    L17_2[3] = L20_2
    L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
    if L14_2 then
      L16_2 = type
      L17_2 = L15_2
      L16_2 = L16_2(L17_2)
      if "table" == L16_2 then
        L16_2 = ipairs
        L17_2 = L15_2
        L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
        for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
          L22_2 = tostring
          L23_2 = L21_2.number
          L22_2 = L22_2(L23_2)
          L23_2 = "n:"
          L24_2 = L22_2
          L23_2 = L23_2 .. L24_2
          L23_2 = L13_2[L23_2]
          if not L23_2 then
            L23_2 = L10_2
            L24_2 = L22_2
            L23_2 = L23_2(L24_2)
            if not L23_2 then
              L23_2 = "n:"
              L24_2 = L22_2
              L23_2 = L23_2 .. L24_2
              L13_2[L23_2] = true
              L23_2 = #L12_2
              L23_2 = L23_2 + 1
              L24_2 = {}
              L24_2.number = L22_2
              L25_2 = L21_2.name
              L24_2.name = L25_2
              L24_2.isContact = true
              L12_2[L23_2] = L24_2
            end
          end
        end
      end
    end
  end
  L14_2 = pcall
  L15_2 = MySQL
  L15_2 = L15_2.query
  L15_2 = L15_2.await
  L16_2 = [[
SELECT DISTINCT IF(sender = ?, receiver, sender) AS other FROM apex_phone_messages
        WHERE app = ? AND (sender = ? OR receiver = ?) AND conversation_id IS NULL AND NOT (receiver = ? AND deleted_receiver = 1)
        HAVING other LIKE ? ESCAPE '!' LIMIT 10]]
  L17_2 = {}
  L18_2 = L2_2
  L19_2 = L0_1
  L20_2 = L2_2
  L21_2 = L2_2
  L22_2 = L2_2
  L23_2 = L5_2
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L17_2[4] = L21_2
  L17_2[5] = L22_2
  L17_2[6] = L23_2
  L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
  if L14_2 then
    L16_2 = type
    L17_2 = L15_2
    L16_2 = L16_2(L17_2)
    if "table" == L16_2 then
      L16_2 = ipairs
      L17_2 = L15_2
      L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
      for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
        L22_2 = tostring
        L23_2 = L21_2.other
        if not L23_2 then
          L23_2 = ""
        end
        L22_2 = L22_2(L23_2)
        if "" ~= L22_2 then
          L24_2 = L22_2
          L23_2 = L22_2.lower
          L23_2 = L23_2(L24_2)
          L24_2 = L23_2
          L23_2 = L23_2.find
          L26_2 = L3_2
          L25_2 = L3_2.lower
          L25_2 = L25_2(L26_2)
          L26_2 = 1
          L27_2 = true
          L23_2 = L23_2(L24_2, L25_2, L26_2, L27_2)
          if L23_2 then
            L23_2 = "n:"
            L24_2 = L22_2
            L23_2 = L23_2 .. L24_2
            L23_2 = L13_2[L23_2]
            if not L23_2 then
              L23_2 = L10_2
              L24_2 = L22_2
              L23_2 = L23_2(L24_2)
              if not L23_2 then
                L23_2 = "n:"
                L24_2 = L22_2
                L23_2 = L23_2 .. L24_2
                L13_2[L23_2] = true
                L23_2 = #L12_2
                L23_2 = L23_2 + 1
                L24_2 = {}
                L24_2.number = L22_2
                L24_2.name = L22_2
                L12_2[L23_2] = L24_2
              end
            end
          end
        end
      end
    end
  end
  L16_2 = pcall
  L17_2 = MySQL
  L17_2 = L17_2.query
  L17_2 = L17_2.await
  L18_2 = [[
SELECT c.id, c.title, c.avatar FROM apex_phone_conversations c JOIN apex_phone_conversation_members cm ON cm.conversation_id = c.id
        WHERE cm.member = ? AND cm.left_at IS NULL AND c.app = ? AND c.title LIKE ? ESCAPE '!' LIMIT 10]]
  L19_2 = {}
  L20_2 = L2_2
  L21_2 = L0_1
  L22_2 = L5_2
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2)
  if L16_2 then
    L18_2 = type
    L19_2 = L17_2
    L18_2 = L18_2(L19_2)
    if "table" == L18_2 then
      L18_2 = ipairs
      L19_2 = L17_2
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L24_2 = L10_1
        L25_2 = L23_2.id
        L24_2 = L24_2(L25_2)
        if L24_2 then
          L25_2 = L10_2
          L26_2 = "g:"
          L27_2 = L24_2
          L26_2 = L26_2 .. L27_2
          L25_2 = L25_2(L26_2)
          if not L25_2 then
            L25_2 = #L12_2
            L25_2 = L25_2 + 1
            L26_2 = {}
            L26_2.conversation = L24_2
            L27_2 = L23_2.title
            L26_2.name = L27_2
            L27_2 = L10_1
            L28_2 = L23_2.avatar
            L27_2 = L27_2(L28_2)
            L26_2.avatar = L27_2
            L12_2[L25_2] = L26_2
          end
        end
      end
    end
  end
  L18_2 = "('text','image','document','location','contact','poll','event')"
  L19_2 = {}
  L20_2 = pcall
  L21_2 = MySQL
  L21_2 = L21_2.query
  L21_2 = L21_2.await
  L22_2 = [[
SELECT id, sender, receiver, type, content, created FROM apex_phone_messages
        WHERE app = ? AND (sender = ? OR receiver = ?) AND conversation_id IS NULL AND deleted_all IS NULL
          AND NOT (sender = ? AND receiver <> ? AND deleted_sender = 1) AND NOT (receiver = ? AND sender <> ? AND deleted_receiver = 1)
          AND view_once = 0 AND (expires_at IS NULL OR expires_at > ?) AND type IN ]]
  L23_2 = L18_2
  L24_2 = [[
 AND content LIKE ? ESCAPE '!'
        ORDER BY id DESC LIMIT 40]]
  L22_2 = L22_2 .. L23_2 .. L24_2
  L23_2 = {}
  L24_2 = L0_1
  L25_2 = L2_2
  L26_2 = L2_2
  L27_2 = L2_2
  L28_2 = L2_2
  L29_2 = L2_2
  L30_2 = L2_2
  L31_2 = L6_2
  L32_2 = L5_2
  L23_2[1] = L24_2
  L23_2[2] = L25_2
  L23_2[3] = L26_2
  L23_2[4] = L27_2
  L23_2[5] = L28_2
  L23_2[6] = L29_2
  L23_2[7] = L30_2
  L23_2[8] = L31_2
  L23_2[9] = L32_2
  L20_2, L21_2 = L20_2(L21_2, L22_2, L23_2)
  if L20_2 then
    L22_2 = type
    L23_2 = L21_2
    L22_2 = L22_2(L23_2)
    if "table" == L22_2 then
      L22_2 = ipairs
      L23_2 = L21_2
      L22_2, L23_2, L24_2, L25_2 = L22_2(L23_2)
      for L26_2, L27_2 in L22_2, L23_2, L24_2, L25_2 do
        L28_2 = L27_2.sender
        if L28_2 == L2_2 then
          L28_2 = L27_2.receiver
          if L28_2 then
            goto lbl_310
          end
        end
        L28_2 = L27_2.sender
        ::lbl_310::
        L29_2 = L10_1
        L30_2 = L27_2.id
        L29_2 = L29_2(L30_2)
        L30_2 = L11_2
        L31_2 = L28_2
        L30_2 = L30_2(L31_2)
        if L29_2 then
          L31_2 = L10_2
          L32_2 = L28_2
          L31_2 = L31_2(L32_2)
          if not L31_2 and (not L30_2 or not (L29_2 <= L30_2)) then
            L31_2 = #L19_2
            L31_2 = L31_2 + 1
            L32_2 = {}
            L32_2.id = L29_2
            L32_2.number = L28_2
            L33_2 = L27_2.sender
            L32_2.sender = L33_2
            L33_2 = L27_2.type
            L32_2.type = L33_2
            L33_2 = L12_1
            L34_2 = L27_2.content
            if not L34_2 then
              L34_2 = ""
            end
            L35_2 = 200
            L33_2 = L33_2(L34_2, L35_2)
            L32_2.content = L33_2
            L33_2 = tonumber
            L34_2 = L27_2.created
            L33_2 = L33_2(L34_2)
            L32_2.created = L33_2
            L19_2[L31_2] = L32_2
          end
        end
      end
    end
  end
  L22_2 = pcall
  L23_2 = MySQL
  L23_2 = L23_2.query
  L23_2 = L23_2.await
  L24_2 = [[
SELECT m.id, m.sender, m.type, m.content, m.created, m.conversation_id FROM apex_phone_conversation_members cm
        JOIN apex_phone_conversations c ON c.id = cm.conversation_id AND c.app = ?
        JOIN apex_phone_messages m ON m.conversation_id = cm.conversation_id AND m.created >= cm.joined
        WHERE cm.member = ? AND cm.left_at IS NULL AND m.deleted_all IS NULL AND NOT (m.sender = ? AND m.deleted_sender = 1)
          AND m.view_once = 0 AND (m.expires_at IS NULL OR m.expires_at > ?) AND m.type IN ]]
  L25_2 = L18_2
  L26_2 = [[
 AND m.content LIKE ? ESCAPE '!'
        ORDER BY m.id DESC LIMIT 40]]
  L24_2 = L24_2 .. L25_2 .. L26_2
  L25_2 = {}
  L26_2 = L0_1
  L27_2 = L2_2
  L28_2 = L2_2
  L29_2 = L6_2
  L30_2 = L5_2
  L25_2[1] = L26_2
  L25_2[2] = L27_2
  L25_2[3] = L28_2
  L25_2[4] = L29_2
  L25_2[5] = L30_2
  L22_2, L23_2 = L22_2(L23_2, L24_2, L25_2)
  if L22_2 then
    L24_2 = type
    L25_2 = L23_2
    L24_2 = L24_2(L25_2)
    if "table" == L24_2 then
      L24_2 = ipairs
      L25_2 = L23_2
      L24_2, L25_2, L26_2, L27_2 = L24_2(L25_2)
      for L28_2, L29_2 in L24_2, L25_2, L26_2, L27_2 do
        L30_2 = L10_1
        L31_2 = L29_2.conversation_id
        L30_2 = L30_2(L31_2)
        L31_2 = L10_1
        L32_2 = L29_2.id
        L31_2 = L31_2(L32_2)
        if L30_2 then
          L32_2 = L11_2
          L33_2 = "g:"
          L34_2 = L30_2
          L33_2 = L33_2 .. L34_2
          L32_2 = L32_2(L33_2)
          if L32_2 then
            goto lbl_398
          end
        end
        L32_2 = nil
        ::lbl_398::
        if L30_2 and L31_2 then
          L33_2 = L10_2
          L34_2 = "g:"
          L35_2 = L30_2
          L34_2 = L34_2 .. L35_2
          L33_2 = L33_2(L34_2)
          if not L33_2 and (not L32_2 or not (L31_2 <= L32_2)) then
            L33_2 = #L19_2
            L33_2 = L33_2 + 1
            L34_2 = {}
            L34_2.id = L31_2
            L34_2.conversation = L30_2
            L35_2 = L29_2.sender
            L34_2.sender = L35_2
            L35_2 = L29_2.type
            L34_2.type = L35_2
            L35_2 = L12_1
            L36_2 = L29_2.content
            if not L36_2 then
              L36_2 = ""
            end
            L37_2 = 200
            L35_2 = L35_2(L36_2, L37_2)
            L34_2.content = L35_2
            L35_2 = tonumber
            L36_2 = L29_2.created
            L35_2 = L35_2(L36_2)
            L34_2.created = L35_2
            L19_2[L33_2] = L34_2
          end
        end
      end
    end
  end
  L24_2 = table
  L24_2 = L24_2.sort
  L25_2 = L19_2
  function L26_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.id
    L3_3 = A1_3.id
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L24_2(L25_2, L26_2)
  L24_2 = {}
  L25_2 = 1
  L26_2 = math
  L26_2 = L26_2.min
  L27_2 = #L19_2
  L28_2 = L6_1
  L26_2 = L26_2(L27_2, L28_2)
  L27_2 = 1
  for L28_2 = L25_2, L26_2, L27_2 do
    L29_2 = L19_2[L28_2]
    L24_2[L28_2] = L29_2
  end
  L25_2 = {}
  L25_2.chats = L12_2
  L25_2.messages = L24_2
  return L25_2
end
L68_1(L69_1, L70_1)
L68_1 = L29_1
L69_1 = "recado.unlock"
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A1_2.pin
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A1_2.pin
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      goto lbl_20
    end
  end
  L2_2 = tostring
  L3_2 = A1_2.pin
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = 10
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  ::lbl_20::
  if not L2_2 then
    L2_2 = ""
  end
  L3_2 = RPC
  L3_2 = L3_2["account.verifyPin"]
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "function" ~= L4_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "unsupported"
    return L4_2
  end
  L4_2 = pcall
  L5_2 = L3_2
  L6_2 = A0_2
  L7_2 = {}
  L7_2.pin = L2_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_52
    end
  end
  L6_2 = {}
  L6_2.ok = false
  L6_2.error = "internal"
  do return L6_2 end
  ::lbl_52::
  L6_2 = L5_2.ok
  if true == L6_2 then
    L6_2 = L42_1
    L7_2 = {}
    L8_2 = GetCid
    L9_2 = A0_2
    L8_2 = L8_2(L9_2)
    L7_2.cid = L8_2
    L8_2 = GetGameTimer
    L8_2 = L8_2()
    L9_2 = L2_1
    L8_2 = L8_2 + L9_2
    L7_2.untilT = L8_2
    L6_2[A0_2] = L7_2
  end
  L6_2 = {}
  L7_2 = L5_2.ok
  L7_2 = true == L7_2
  L6_2.ok = L7_2
  L7_2 = L5_2.attempts
  L6_2.attempts = L7_2
  L7_2 = L5_2.lockedUntil
  L6_2.lockedUntil = L7_2
  L7_2 = L5_2.wait
  L6_2.wait = L7_2
  L7_2 = L5_2.ok
  if true ~= L7_2 then
    L7_2 = L5_2.lockedUntil
    if L7_2 then
      L7_2 = "pinlocked"
      if L7_2 then
        goto lbl_96
      end
    end
    L7_2 = "badpin"
    if L7_2 then
      goto lbl_96
    end
  end
  L7_2 = nil
  ::lbl_96::
  L6_2.error = L7_2
  return L6_2
end
L68_1(L69_1, L70_1)
function L68_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L0_2 = 0
  L1_2 = 1
  L2_2 = 20
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = pcall
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = "SELECT id, conversation_id FROM apex_phone_messages WHERE expires_at IS NOT NULL AND expires_at <= ? LIMIT 500"
    L8_2 = {}
    L9_2 = Now
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L9_2()
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
    L8_2[13] = L21_2
    L8_2[14] = L22_2
    L8_2[15] = L23_2
    L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
    if not L5_2 then
      break
    end
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" ~= L7_2 then
      break
    end
    L7_2 = #L6_2
    if 0 == L7_2 then
      break
    end
    L7_2 = {}
    L8_2 = {}
    L9_2 = {}
    L10_2 = ipairs
    L11_2 = L6_2
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = L10_1
      L17_2 = L15_2.id
      L16_2 = L16_2(L17_2)
      if L16_2 then
        L17_2 = #L7_2
        L17_2 = L17_2 + 1
        L7_2[L17_2] = L16_2
      end
      L17_2 = L10_1
      L18_2 = L15_2.conversation_id
      L17_2 = L17_2(L18_2)
      if L17_2 then
        L18_2 = L9_2[L17_2]
        if not L18_2 then
          L9_2[L17_2] = true
          L18_2 = #L8_2
          L18_2 = L18_2 + 1
          L8_2[L18_2] = L17_2
        end
      end
    end
    L10_2 = #L7_2
    if 0 == L10_2 then
      break
    end
    L10_2 = L11_1
    L11_2 = #L7_2
    L10_2 = L10_2(L11_2)
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "DELETE FROM apex_phone_message_reactions WHERE message_id IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_2
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = L7_2
    L11_2(L12_2, L13_2, L14_2)
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "DELETE FROM apex_phone_recado_stars WHERE message_id IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_2
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = L7_2
    L11_2(L12_2, L13_2, L14_2)
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "DELETE FROM apex_phone_recado_pins WHERE message_id IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_2
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = L7_2
    L11_2(L12_2, L13_2, L14_2)
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "DELETE FROM apex_phone_recado_views WHERE message_id IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_2
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = L7_2
    L11_2(L12_2, L13_2, L14_2)
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "DELETE FROM apex_phone_messages WHERE id IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_2
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = L7_2
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    if not L11_2 then
      break
    end
    L12_2 = ipairs
    L13_2 = L8_2
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
    for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
      L18_2 = pcall
      L19_2 = MySQL
      L19_2 = L19_2.update
      L19_2 = L19_2.await
      L20_2 = "UPDATE apex_phone_conversations SET last_id = (SELECT MAX(id) FROM apex_phone_messages WHERE conversation_id = ?) WHERE id = ?"
      L21_2 = {}
      L22_2 = L17_2
      L23_2 = L17_2
      L21_2[1] = L22_2
      L21_2[2] = L23_2
      L18_2(L19_2, L20_2, L21_2)
    end
    L12_2 = #L7_2
    L0_2 = L0_2 + L12_2
    L12_2 = #L6_2
    L13_2 = 500
    if L12_2 < L13_2 then
      break
    end
    L12_2 = Wait
    L13_2 = 50
    L12_2(L13_2)
  end
  if L0_2 > 0 then
    L1_2 = Dbg
    L2_2 = "recado"
    L3_2 = "cleanup: %d temporary message(s) deleted"
    L4_2 = L0_2
    L1_2(L2_2, L3_2, L4_2)
  end
  return L0_2
end
L63_1 = L68_1
L68_1 = CreateThread
function L69_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  while true do
    L0_2 = L21_1
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 20000
  L0_2(L1_2)
  while true do
    L0_2 = pcall
    L1_2 = L63_1
    L0_2, L1_2 = L0_2(L1_2)
    if not L0_2 then
      L2_2 = print
      L3_2 = "^3[unique_phone]^0 Recado: temporary message cleanup failed (%s)"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = tostring
      L6_2 = L1_2
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L5_2(L6_2)
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    end
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L3_2 = pairs
    L4_2 = L45_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = pairs
      L10_2 = L8_2
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
        if L14_2 <= L2_2 then
          L8_2[L13_2] = nil
        end
      end
      L9_2 = next
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if nil == L9_2 then
        L9_2 = L45_1
        L9_2[L7_2] = nil
      end
    end
    L3_2 = pairs
    L4_2 = L42_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L8_2.untilT
      if L2_2 > L9_2 then
        L9_2 = L42_1
        L9_2[L7_2] = nil
      end
    end
    L3_2 = Wait
    L4_2 = 60000
    L3_2(L4_2)
  end
end
L68_1(L69_1)
function L68_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = type
  L2_2 = Accounts
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = Accounts
    L1_2 = L1_2[A0_2]
    if L1_2 then
      goto lbl_11
    end
  end
  L1_2 = nil
  ::lbl_11::
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L1_2.settings
    if L2_2 then
      goto lbl_20
    end
  end
  L2_2 = nil
  ::lbl_20::
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = pcall
    L4_2 = MySQL
    L4_2 = L4_2.scalar
    L4_2 = L4_2.await
    L5_2 = "SELECT settings FROM apex_phone_accounts WHERE citizenid = ?"
    L6_2 = {}
    L7_2 = A0_2
    L6_2[1] = L7_2
    L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      L5_2 = type
      L6_2 = L4_2
      L5_2 = L5_2(L6_2)
      if "string" == L5_2 and "" ~= L4_2 then
        L6_2 = L4_2
        L5_2 = L4_2.find
        L7_2 = "\"recado\""
        L8_2 = 1
        L9_2 = true
        L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
        if L5_2 then
          goto lbl_53
        end
      end
    end
    L5_2 = false
    do return L5_2 end
    ::lbl_53::
    L5_2 = L18_1
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L2_2 = L5_2
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L2_2.installed
    if L3_2 then
      goto lbl_66
    end
  end
  L3_2 = nil
  ::lbl_66::
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = pairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L0_1
    if L9_2 == L10_2 then
      L10_2 = true
      return L10_2
    end
  end
  L4_2 = false
  return L4_2
end
function L69_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L19_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L1_2 or not L2_2 then
    return
  end
  L3_2 = L68_1
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    return
  end
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT last_seen FROM apex_phone_accounts WHERE citizenid = ?"
  L6_2 = {}
  L7_2 = L1_2
  L6_2[1] = L7_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 or not L4_2 then
    return
  end
  L5_2 = Now
  L5_2 = L5_2()
  L6_2 = math
  L6_2 = L6_2.max
  L7_2 = tonumber
  L8_2 = L4_2.last_seen
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = L5_2 - 1209600000
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = {}
  L8_2 = pcall
  L9_2 = MySQL
  L9_2 = L9_2.query
  L9_2 = L9_2.await
  L10_2 = "SELECT other, muted_until, archived, locked FROM apex_phone_thread_meta WHERE owner = ? AND app = ? LIMIT 2000"
  L11_2 = {}
  L12_2 = L2_2
  L13_2 = L0_1
  L11_2[1] = L12_2
  L11_2[2] = L13_2
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
        L16_2 = tostring
        L17_2 = L15_2.other
        L16_2 = L16_2(L17_2)
        L7_2[L16_2] = L15_2
      end
    end
  end
  function L10_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L7_2
    L1_3 = L1_3[A0_3]
    L2_3 = nil ~= L1_3
    return L2_3
  end
  function L11_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L7_2
    L1_3 = L1_3[A0_3]
    L2_3 = nil ~= L1_3
    return L2_3
  end
  L12_2 = 0
  L13_2 = 0
  L14_2 = false
  L15_2 = false
  L16_2 = nil
  L17_2 = pcall
  L18_2 = MySQL
  L18_2 = L18_2.query
  L18_2 = L18_2.await
  L19_2 = [[
SELECT sender, COUNT(*) AS n, MAX(created) AS last FROM apex_phone_messages
        WHERE app = ? AND receiver = ? AND `read` = 0 AND deleted_receiver = 0 AND conversation_id IS NULL AND type <> 'system'
          AND (expires_at IS NULL OR expires_at > ?) GROUP BY sender LIMIT 200]]
  L20_2 = {}
  L21_2 = L0_1
  L22_2 = L2_2
  L23_2 = L5_2
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L17_2, L18_2 = L17_2(L18_2, L19_2, L20_2)
  if L17_2 then
    L19_2 = type
    L20_2 = L18_2
    L19_2 = L19_2(L20_2)
    if "table" == L19_2 then
      L19_2 = ipairs
      L20_2 = L18_2
      L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
      for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
        L25_2 = tostring
        L26_2 = L24_2.sender
        L25_2 = L25_2(L26_2)
        if L25_2 ~= L2_2 then
          L26_2 = L10_2
          L27_2 = L25_2
          L26_2 = L26_2(L27_2)
          if not L26_2 then
            L26_2 = math
            L26_2 = L26_2.tointeger
            L27_2 = tonumber
            L28_2 = L24_2.n
            L27_2 = L27_2(L28_2)
            if not L27_2 then
              L27_2 = 0
            end
            L26_2 = L26_2(L27_2)
            if not L26_2 then
              L26_2 = 0
            end
            L12_2 = L12_2 + L26_2
            L13_2 = L13_2 + 1
            L26_2 = {}
            L26_2.number = L25_2
            L16_2 = L26_2
            L26_2 = tonumber
            L27_2 = L24_2.last
            L26_2 = L26_2(L27_2)
            if not L26_2 then
              L26_2 = 0
            end
            if L6_2 < L26_2 then
              L14_2 = true
            end
            L26_2 = L11_2
            L27_2 = L25_2
            L26_2 = L26_2(L27_2)
            if L26_2 then
              L15_2 = true
            end
          end
        end
      end
    end
  end
  L19_2 = type
  L20_2 = GroupListFor
  L19_2 = L19_2(L20_2)
  if "function" == L19_2 then
    L19_2 = pcall
    L20_2 = GroupListFor
    L21_2 = L2_2
    L22_2 = L0_1
    L19_2, L20_2 = L19_2(L20_2, L21_2, L22_2)
    L21_2 = ipairs
    if L19_2 then
      L22_2 = type
      L23_2 = L20_2
      L22_2 = L22_2(L23_2)
      if "table" == L22_2 and L20_2 then
        goto lbl_177
        L22_2 = L20_2 or L22_2
      end
    end
    L22_2 = {}
    ::lbl_177::
    L21_2, L22_2, L23_2, L24_2 = L21_2(L22_2)
    for L25_2, L26_2 in L21_2, L22_2, L23_2, L24_2 do
      L27_2 = L10_1
      L28_2 = L26_2.id
      L27_2 = L27_2(L28_2)
      L28_2 = math
      L28_2 = L28_2.tointeger
      L29_2 = tonumber
      L30_2 = L26_2.unread
      L29_2 = L29_2(L30_2)
      if not L29_2 then
        L29_2 = 0
      end
      L28_2 = L28_2(L29_2)
      if not L28_2 then
        L28_2 = 0
      end
      L29_2 = L10_1
      L30_2 = L26_2.clearedBefore
      L29_2 = L29_2(L30_2)
      L30_2 = L10_1
      L31_2 = L26_2.lastId
      L30_2 = L30_2(L31_2)
      if L27_2 and L28_2 > 0 then
        L31_2 = L10_2
        L32_2 = "g:"
        L33_2 = L27_2
        L32_2 = L32_2 .. L33_2
        L31_2 = L31_2(L32_2)
        if not L31_2 then
          L31_2 = tonumber
          L32_2 = L26_2.mutedUntil
          L31_2 = L31_2(L32_2)
          if not L31_2 then
            L31_2 = 0
          end
          if L5_2 >= L31_2 and (not (L29_2 and L30_2) or not (L29_2 >= L30_2)) then
            L12_2 = L12_2 + L28_2
            L13_2 = L13_2 + 1
            L31_2 = {}
            L31_2.conversation = L27_2
            L32_2 = L26_2.title
            L31_2.title = L32_2
            L16_2 = L31_2
            L31_2 = tonumber
            L32_2 = L26_2.ts
            L31_2 = L31_2(L32_2)
            if not L31_2 then
              L31_2 = 0
            end
            if L6_2 < L31_2 then
              L14_2 = true
            end
            L31_2 = L11_2
            L32_2 = "g:"
            L33_2 = L27_2
            L32_2 = L32_2 .. L33_2
            L31_2 = L31_2(L32_2)
            if L31_2 then
              L15_2 = true
            end
          end
        end
      end
    end
  end
  if 0 == L12_2 or not L14_2 then
    return
  end
  L19_2 = nil
  L20_2 = nil
  L21_2 = nil
  if 1 == L12_2 then
    L22_2 = "1 mensagem por ler"
    if L22_2 then
      goto lbl_270
    end
  end
  L22_2 = "%d mensagens por ler"
  L23_2 = L22_2
  L22_2 = L22_2.format
  L24_2 = L12_2
  L22_2 = L22_2(L23_2, L24_2)
  ::lbl_270::
  if 1 == L13_2 and not L15_2 then
    L23_2 = L16_2.conversation
    if L23_2 then
      L23_2 = L12_1
      L24_2 = L16_2.title
      if not L24_2 then
        L24_2 = "Grupo"
      end
      L25_2 = 80
      L23_2 = L23_2(L24_2, L25_2)
      L24_2 = {}
      L25_2 = L16_2.conversation
      L24_2.conversation = L25_2
      L21_2 = L24_2
      L19_2 = L23_2
    else
      L23_2 = pcall
      L24_2 = MySQL
      L24_2 = L24_2.scalar
      L24_2 = L24_2.await
      L25_2 = "SELECT name FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
      L26_2 = {}
      L27_2 = L1_2
      L28_2 = L16_2.number
      L26_2[1] = L27_2
      L26_2[2] = L28_2
      L23_2, L24_2 = L23_2(L24_2, L25_2, L26_2)
      L25_2 = L24_2 or L25_2
      if not L23_2 or not L24_2 then
        L25_2 = L16_2.number
      end
      L26_2 = {}
      L27_2 = L16_2.number
      L26_2.number = L27_2
      L21_2 = L26_2
      L19_2 = L25_2
    end
    L20_2 = L22_2
  else
    L19_2 = "Zapp"
    if L13_2 > 1 then
      L23_2 = "%s em %d conversas"
      L24_2 = L23_2
      L23_2 = L23_2.format
      L25_2 = L22_2
      L26_2 = L13_2
      L23_2 = L23_2(L24_2, L25_2, L26_2)
      if L23_2 then
        goto lbl_326
        L20_2 = L23_2 or L20_2
      end
    end
    L20_2 = L22_2
    ::lbl_326::
    L23_2 = {}
    L23_2.summary = true
    L21_2 = L23_2
  end
  L21_2.sys = "m"
  L23_2 = NotifyPlayer
  L24_2 = A0_2
  L25_2 = L0_1
  L26_2 = L19_2
  L27_2 = L20_2
  L28_2 = L21_2
  L23_2(L24_2, L25_2, L26_2, L27_2, L28_2)
end
L70_1 = FW
L70_1 = L70_1.OnPlayerLoaded
function L71_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    return
  end
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = 0
    while true do
      L1_3 = L21_1
      if not (not L1_3 and L0_3 < 90) then
        break
      end
      L1_3 = Wait
      L2_3 = 1000
      L1_3(L2_3)
      L0_3 = L0_3 + 1
    end
    L1_3 = L21_1
    if not L1_3 then
      return
    end
    L1_3 = Wait
    L2_3 = 9000
    L1_3(L2_3)
    L1_3 = GetPlayerName
    L2_3 = A0_2
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      return
    end
    L1_3 = pcall
    L2_3 = L69_1
    L3_3 = A0_2
    L1_3, L2_3 = L1_3(L2_3, L3_3)
    if not L1_3 then
      L3_3 = print
      L4_3 = "^3[unique_phone]^0 Recado: join summary failed (%s)"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = tostring
      L7_3 = L2_3
      L6_3, L7_3 = L6_3(L7_3)
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3, L6_3, L7_3)
      L3_3(L4_3, L5_3, L6_3, L7_3)
    end
  end
  L1_2(L2_2)
end
L70_1(L71_1)
L70_1 = FW
L70_1 = L70_1.OnPlayerDropped
function L71_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    return
  end
  L1_2 = L67_1
  L2_2 = L45_1
  L3_2 = L42_1
  L4_2 = nil
  L5_2 = nil
  L3_2[A0_2] = nil
  L2_2[A0_2] = L5_2
  L1_2[A0_2] = L4_2
end
L70_1(L71_1)
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if nil == A1_2 or "" == A1_2 then
    return
  end
  L2_2 = tostring
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  A1_2 = L2_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_recado_stars WHERE who = ?"
  L5_2 = {}
  L6_2 = A1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_recado_views WHERE who = ?"
  L5_2 = {}
  L6_2 = A1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_recado_pins WHERE pinned_by = ?"
  L5_2 = {}
  L6_2 = A1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pairs
  L3_2 = L60_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L6_2
    L7_2 = L6_2.find
    L9_2 = A1_2
    L10_2 = 1
    L11_2 = true
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
    if L7_2 then
      L7_2 = L60_1
      L7_2[L6_2] = nil
    end
  end
end
RecadoCoreForget = L70_1
