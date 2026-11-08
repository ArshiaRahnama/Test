local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1
L0_1 = "recado"
L1_1 = 80
L2_1 = 20000
L3_1 = 300
L4_1 = 100
L5_1 = 80
L6_1 = 500
L7_1 = 60
L8_1 = 3.16224E10
L9_1 = 15000
L10_1 = false
L11_1 = {}
L12_1 = {}
function L13_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = Dbg
  L1_2 = L1_2(L2_2)
  if "function" == L1_2 then
    L1_2 = pcall
    L2_2 = Dbg
    L3_2 = "recado"
    L4_2 = A0_2
    L5_2 = ...
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
end
function L14_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Now
  L0_2 = L0_2(L1_2)
  if "function" == L0_2 then
    L0_2 = Now
    L0_2 = L0_2()
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L0_2 = L0_2 * 1000
  ::lbl_15::
  return L0_2
end
function L15_1()
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
function L16_1(A0_2)
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
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.rep
  L2_2 = "?"
  L3_2 = A0_2
  L4_2 = ", "
  return L1_2(L2_2, L3_2, L4_2)
end
L18_1 = {}
L19_1 = "\226\128[\139-\143]"
L20_1 = "\226\128[\168-\174]"
L21_1 = "\226\129[\160-\175]"
L22_1 = "\239\187\191"
L23_1 = "\194\173"
L18_1[1] = L19_1
L18_1[2] = L20_1
L18_1[3] = L21_1
L18_1[4] = L22_1
L18_1[5] = L23_1
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = utf8
  L2_2 = L2_2.len
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  if A1_2 >= L2_2 then
    return A0_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.sub
  L5_2 = 1
  L6_2 = utf8
  L6_2 = L6_2.offset
  L7_2 = A0_2
  L8_2 = A1_2 + 1
  L6_2 = L6_2(L7_2, L8_2)
  L6_2 = L6_2 - 1
  return L3_2(L4_2, L5_2, L6_2)
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = ipairs
  L2_2 = L18_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L8_2 = A0_2
    L7_2 = A0_2.gsub
    L9_2 = L6_2
    L10_2 = ""
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    A0_2 = L7_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "\194\160"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
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
  L3_2 = #L2_2
  L4_2 = A1_2 * 4
  L4_2 = L4_2 + 64
  if L3_2 > L4_2 then
    L4_2 = L2_2
    L3_2 = L2_2.sub
    L5_2 = 1
    L6_2 = A1_2 * 4
    L6_2 = L6_2 + 64
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2 = L3_2
  end
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
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L20_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "%c"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "%s+"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L3_2
  L4_2 = L2_2
  L3_2 = L2_2.match
  L5_2 = "^%s*(.-)%s*$"
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L3_2
  if "" == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L19_1
  L4_2 = L2_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L3_2
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L4_2 = L2_2
  L3_2 = L2_2.match
  L5_2 = "^(.-)%s*$"
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L3_2
  L3_2 = L2_2 or L3_2
  if "" == L2_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = A0_2
  L3_2 = #L2_2
  L4_2 = A1_2 * 4
  L4_2 = L4_2 + 256
  if L3_2 > L4_2 then
    L4_2 = L2_2
    L3_2 = L2_2.sub
    L5_2 = 1
    L6_2 = A1_2 * 4
    L6_2 = L6_2 + 256
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2 = L3_2
  end
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
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L20_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "\r\n?"
  L6_2 = "\n"
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "\t"
  L6_2 = "    "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "[\000-\b\v-\031\127]"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L3_2
  L4_2 = L2_2
  L3_2 = L2_2.gsub
  L5_2 = [[



+]]
  L6_2 = [[



]]
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L3_2
  L4_2 = L2_2
  L3_2 = L2_2.match
  L5_2 = "^%s*(.-)%s*$"
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L3_2
  if "" == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L19_1
  L4_2 = L2_2
  L5_2 = A1_2
  return L3_2(L4_2, L5_2)
end
function L23_1(A0_2)
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
  L3_2 = A0_2
  L2_2 = A0_2.match
  L4_2 = "^%s*(.-)%s*$"
  L2_2 = L2_2(L3_2, L4_2)
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
function L24_1(A0_2)
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
L25_1 = {}
L26_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_recado_polls` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `message_id` INT NULL,
        `conversation_id` INT NULL,
        `creator` VARCHAR(40) NOT NULL,
        `peer` VARCHAR(40) NULL,
        `question` VARCHAR(300) NOT NULL,
        `options` TEXT NOT NULL,
        `multi` TINYINT NOT NULL DEFAULT 0,
        `show_voters` TINYINT NOT NULL DEFAULT 0,
        `created` BIGINT NOT NULL,
        KEY `rc_poll_message` (`message_id`)
    ) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
L27_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_recado_poll_votes` (
        `poll_id` INT NOT NULL,
        `voter` VARCHAR(40) NOT NULL,
        `option_idx` TINYINT NOT NULL,
        `created` BIGINT NOT NULL,
        PRIMARY KEY (`poll_id`, `voter`, `option_idx`)
    ) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
L28_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_recado_events` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `message_id` INT NULL,
        `conversation_id` INT NULL,
        `creator` VARCHAR(40) NOT NULL,
        `peer` VARCHAR(40) NULL,
        `title` VARCHAR(80) NOT NULL,
        `description` VARCHAR(500) NULL,
        `start` BIGINT NOT NULL,
        `loc_x` DOUBLE NULL,
        `loc_y` DOUBLE NULL,
        `loc_label` VARCHAR(60) NULL,
        `reminder` INT NOT NULL DEFAULT -1,
        `reminded` TINYINT NOT NULL DEFAULT 0,
        `cancelled` TINYINT NOT NULL DEFAULT 0,
        `created` BIGINT NOT NULL,
        KEY `rc_event_due` (`reminded`, `start`),
        KEY `rc_event_message` (`message_id`)
    ) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
L29_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_recado_rsvp` (
        `event_id` INT NOT NULL,
        `who` VARCHAR(40) NOT NULL,
        `answer` VARCHAR(5) NOT NULL,
        `updated` BIGINT NOT NULL,
        PRIMARY KEY (`event_id`, `who`)
    ) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
L25_1[1] = L26_1
L25_1[2] = L27_1
L25_1[3] = L28_1
L25_1[4] = L29_1
L26_1 = CreateThread
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
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
  L0_2 = true
  L1_2 = ipairs
  L2_2 = L25_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = pcall
    function L8_2()
      local L0_3, L1_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = L6_2
      L0_3(L1_3)
    end
    L7_2, L8_2 = L7_2(L8_2)
    if not L7_2 then
      L0_2 = false
      L9_2 = print
      L10_2 = "^1[unique_phone]^0 recado_extras: table not created (%s)"
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = tostring
      L13_2 = L8_2
      L12_2, L13_2 = L12_2(L13_2)
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2)
      L9_2(L10_2, L11_2, L12_2, L13_2)
    else
      L9_2 = type
      L10_2 = MigrateTable
      L9_2 = L9_2(L10_2)
      if "function" == L9_2 then
        L9_2 = pcall
        L10_2 = MigrateTable
        L11_2 = L6_2
        L9_2(L10_2, L11_2)
      end
    end
  end
  L1_2 = type
  L2_2 = EnsureIndex
  L1_2 = L1_2(L2_2)
  if "function" == L1_2 then
    L1_2 = pcall
    L2_2 = EnsureIndex
    L3_2 = "apex_phone_recado_polls"
    L4_2 = "rc_poll_message"
    L5_2 = {}
    L6_2 = "message_id"
    L5_2[1] = L6_2
    L1_2(L2_2, L3_2, L4_2, L5_2)
    L1_2 = pcall
    L2_2 = EnsureIndex
    L3_2 = "apex_phone_recado_events"
    L4_2 = "rc_event_due"
    L5_2 = {}
    L6_2 = "reminded"
    L7_2 = "start"
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L1_2(L2_2, L3_2, L4_2, L5_2)
    L1_2 = pcall
    L2_2 = EnsureIndex
    L3_2 = "apex_phone_recado_events"
    L4_2 = "rc_event_message"
    L5_2 = {}
    L6_2 = "message_id"
    L5_2[1] = L6_2
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
  L10_1 = L0_2
  if L0_2 then
    L1_2 = L13_1
    L2_2 = "extras: tables ready"
    L1_2(L2_2)
  end
end
L26_1(L27_1)
function L26_1()
  local L0_2, L1_2, L2_2
  L0_2 = L10_1
  if L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = L10_1
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
    L2_2 = 100
    L1_2(L2_2)
  end
  L1_2 = L10_1
  return L1_2
end
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = A1_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = A2_2[L11_2]
    if nil ~= L12_2 then
      L13_2 = #L3_2
      L13_2 = L13_2 + 1
      L14_2 = "`"
      L15_2 = L11_2
      L16_2 = "`"
      L14_2 = L14_2 .. L15_2 .. L16_2
      L3_2[L13_2] = L14_2
      L13_2 = #L4_2
      L13_2 = L13_2 + 1
      L4_2[L13_2] = "?"
      L13_2 = #L5_2
      L13_2 = L13_2 + 1
      L5_2[L13_2] = L12_2
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.insert
  L6_2 = L6_2.await
  L7_2 = "INSERT INTO `%s` (%s) VALUES (%s)"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = A0_2
  L10_2 = table
  L10_2 = L10_2.concat
  L11_2 = L3_2
  L12_2 = ", "
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = table
  L11_2 = L11_2.concat
  L12_2 = L4_2
  L13_2 = ", "
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L11_2(L12_2, L13_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L8_2 = L5_2
  return L6_2(L7_2, L8_2)
end
L28_1 = {}
L28_1["recado.poll.create"] = 4
L28_1["recado.event.create"] = 4
L28_1["recado.doc.share"] = 3
L28_1["recado.gif.search"] = 3
L28_1["recado.poll.vote"] = 2
L28_1["recado.event.rsvp"] = 2
L28_1["recado.event.cancel"] = 2
L29_1 = Config
L29_1 = L29_1.RateLimit
L30_1 = type
L31_1 = L29_1
L30_1 = L30_1(L31_1)
if "table" == L30_1 then
  L30_1 = type
  L31_1 = L29_1.costs
  L30_1 = L30_1(L31_1)
  if "table" ~= L30_1 then
    L30_1 = {}
    L29_1.costs = L30_1
  end
  L30_1 = pairs
  L31_1 = L28_1
  L30_1, L31_1, L32_1, L33_1 = L30_1(L31_1)
  for L34_1, L35_1 in L30_1, L31_1, L32_1, L33_1 do
    L36_1 = L29_1.costs
    L36_1 = L36_1[L34_1]
    if nil == L36_1 then
      L36_1 = L29_1.costs
      L36_1[L34_1] = L35_1
    end
  end
end
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L24_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = "noidentity"
    return L3_2, L4_2
  end
  L3_2 = A1_2.conversation
  if nil == L3_2 then
    L4_2 = type
    L5_2 = A1_2.number
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 then
      L4_2 = A1_2.number
      L5_2 = L4_2
      L4_2 = L4_2.match
      L6_2 = "^g:(%d+)$"
      L4_2 = L4_2(L5_2, L6_2)
      L3_2 = L4_2
    end
  end
  if nil ~= L3_2 then
    L4_2 = L16_1
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L5_2 = nil
      L6_2 = "target"
      return L5_2, L6_2
    end
    L5_2 = type
    L6_2 = GroupInfo
    L5_2 = L5_2(L6_2)
    if "function" == L5_2 then
      L5_2 = GroupInfo
      L6_2 = L4_2
      L5_2 = L5_2(L6_2)
      if L5_2 then
        goto lbl_43
      end
    end
    L5_2 = nil
    ::lbl_43::
    if L5_2 then
      L6_2 = L5_2.app
      if not L6_2 then
        L6_2 = "sms"
      end
      L7_2 = L0_1
      if L6_2 == L7_2 then
        goto lbl_55
      end
    end
    L6_2 = nil
    L7_2 = "notfound"
    do return L6_2, L7_2 end
    ::lbl_55::
    L6_2 = type
    L7_2 = IsGroupMember
    L6_2 = L6_2(L7_2)
    if "function" == L6_2 then
      L6_2 = IsGroupMember
      L7_2 = L4_2
      L8_2 = L2_2
      L6_2 = L6_2(L7_2, L8_2)
      if L6_2 then
        goto lbl_69
      end
    end
    L6_2 = nil
    L7_2 = "notfound"
    do return L6_2, L7_2 end
    ::lbl_69::
    L6_2 = {}
    L6_2.me = L2_2
    L6_2.conversation = L4_2
    return L6_2
  end
  L4_2 = L23_1
  L5_2 = A1_2.number
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = "target"
    return L5_2, L6_2
  end
  if L4_2 == L2_2 then
    L5_2 = nil
    L6_2 = "target"
    return L5_2, L6_2
  end
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = type
    L7_2 = IsBlocked
    L6_2 = L6_2(L7_2)
    if "function" == L6_2 then
      L6_2 = IsBlocked
      L7_2 = L5_2
      L8_2 = L4_2
      L6_2 = L6_2(L7_2, L8_2)
      if L6_2 then
        L6_2 = nil
        L7_2 = "blocked"
        return L6_2, L7_2
      end
    end
  end
  L6_2 = {}
  L6_2.me = L2_2
  L6_2.number = L4_2
  return L6_2
end
function L29_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L5_2 = {}
  L5_2.app = "recado"
  L5_2.type = A2_2
  L5_2.content = A3_2
  L5_2.payload = A4_2
  L6_2 = A1_2.conversation
  if L6_2 then
    L6_2 = A1_2.conversation
    L5_2.conversation = L6_2
  else
    L6_2 = A1_2.number
    L5_2.number = L6_2
    L6_2 = A1_2.number
    L5_2.to = L6_2
  end
  L6_2 = nil
  L7_2 = nil
  L8_2 = nil
  L9_2 = type
  L10_2 = RecadoSend
  L9_2 = L9_2(L10_2)
  if "function" == L9_2 then
    L9_2 = A1_2.conversation
    if L9_2 then
      L9_2 = {}
      L10_2 = A1_2.conversation
      L9_2.conversation = L10_2
      if L9_2 then
        goto lbl_36
      end
    end
    L9_2 = {}
    L10_2 = A1_2.number
    L9_2.number = L10_2
    ::lbl_36::
    L10_2 = pcall
    L11_2 = RecadoSend
    L12_2 = A0_2
    L13_2 = L9_2
    L14_2 = {}
    L14_2.type = A2_2
    L14_2.content = A3_2
    L14_2.payload = A4_2
    L15_2 = {}
    L15_2.trusted = true
    L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    L8_2 = L12_2
    L7_2 = L11_2
    L6_2 = L10_2
    if L6_2 and nil == L7_2 then
      L10_2 = nil
      L11_2 = tostring
      L12_2 = L8_2 or L12_2
      if not L8_2 then
        L12_2 = "failed"
      end
      L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
      return L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
    end
  else
    L9_2 = type
    L10_2 = RPC
    L10_2 = L10_2["recado.send"]
    L9_2 = L9_2(L10_2)
    if "function" == L9_2 then
      L9_2 = pcall
      L10_2 = RPC
      L10_2 = L10_2["recado.send"]
      L11_2 = A0_2
      L12_2 = L5_2
      L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
      L7_2 = L10_2
      L6_2 = L9_2
    else
      L9_2 = type
      L10_2 = RPC
      L10_2 = L10_2["messages.send"]
      L9_2 = L9_2(L10_2)
      if "function" == L9_2 then
        L9_2 = pcall
        L10_2 = RPC
        L10_2 = L10_2["messages.send"]
        L11_2 = A0_2
        L12_2 = L5_2
        L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
        L7_2 = L10_2
        L6_2 = L9_2
      else
        L9_2 = nil
        L10_2 = "unavailable"
        return L9_2, L10_2
      end
    end
  end
  if not L6_2 then
    L9_2 = print
    L10_2 = "^1[unique_phone]^0 recado_extras: send failed (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = tostring
    L13_2 = L7_2
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L9_2 = nil
    L10_2 = "internal"
    return L9_2, L10_2
  end
  L9_2 = type
  L10_2 = L7_2
  L9_2 = L9_2(L10_2)
  if "table" ~= L9_2 then
    L9_2 = nil
    L10_2 = "db"
    return L9_2, L10_2
  end
  L9_2 = L7_2.error
  if L9_2 then
    L9_2 = nil
    L10_2 = tostring
    L11_2 = L7_2.error
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L10_2(L11_2)
    return L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  end
  L9_2 = L7_2.ok
  if false == L9_2 then
    L9_2 = nil
    L10_2 = "failed"
    return L9_2, L10_2
  end
  L9_2 = type
  L10_2 = L7_2.message
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = L7_2.message
    if L9_2 then
      goto lbl_141
    end
  end
  L9_2 = L7_2
  ::lbl_141::
  L10_2 = L16_1
  L11_2 = L9_2.id
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L11_2 = nil
    L12_2 = "db"
    return L11_2, L12_2
  end
  L11_2 = L9_2
  L12_2 = L10_2
  return L11_2, L12_2
end
L30_1 = 0
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L30_1
  if L1_2 >= L2_2 then
    L1_2 = pcall
    L2_2 = MySQL
    L2_2 = L2_2.single
    L2_2 = L2_2.await
    L3_2 = "SELECT sender, receiver, conversation_id, deleted_all, deleted_sender, deleted_receiver, created, expires_at FROM apex_phone_messages WHERE id = ?"
    L4_2 = {}
    L5_2 = A0_2
    L4_2[1] = L5_2
    L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      return L2_2
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_2 = L3_2 + 60000
    L30_1 = L3_2
  end
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT sender, receiver, conversation_id, deleted_all, deleted_sender, deleted_receiver, created FROM apex_phone_messages WHERE id = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  L3_2 = L2_2 or L3_2
  if not L1_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A0_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L16_1
  L3_2 = A1_2.message_id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L31_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.deleted_all
    if nil == L4_2 then
      goto lbl_22
    end
  end
  L4_2 = false
  do return L4_2 end
  ::lbl_22::
  L4_2 = tonumber
  L5_2 = L3_2.expires_at
  L4_2 = L4_2(L5_2)
  if L4_2 and L4_2 > 0 then
    L5_2 = L14_1
    L5_2 = L5_2()
    if L4_2 <= L5_2 then
      L5_2 = false
      return L5_2
    end
  end
  L5_2 = L16_1
  L6_2 = A1_2.conversation_id
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L16_1
    L7_2 = L3_2.conversation_id
    L6_2 = L6_2(L7_2)
    if L6_2 ~= L5_2 then
      L6_2 = false
      return L6_2
    end
    L6_2 = type
    L7_2 = IsGroupMember
    L6_2 = L6_2(L7_2)
    if "function" == L6_2 then
      L6_2 = IsGroupMember
      L7_2 = L5_2
      L8_2 = A0_2
      L6_2 = L6_2(L7_2, L8_2)
      if L6_2 then
        goto lbl_60
      end
    end
    L6_2 = false
    do return L6_2 end
    ::lbl_60::
    L6_2 = type
    L7_2 = GroupMembership
    L6_2 = L6_2(L7_2)
    if "function" == L6_2 then
      L6_2 = GroupMembership
      L7_2 = L5_2
      L8_2 = A0_2
      L6_2 = L6_2(L7_2, L8_2)
      if L6_2 then
        goto lbl_72
      end
    end
    L6_2 = nil
    ::lbl_72::
    if L6_2 then
      L7_2 = L6_2.joined
      if L7_2 then
        L7_2 = tonumber
        L8_2 = L3_2.created
        L7_2 = L7_2(L8_2)
        if not L7_2 then
          L7_2 = 0
        end
        L8_2 = L6_2.joined
        if L7_2 < L8_2 then
          L7_2 = false
          return L7_2
        end
      end
    end
    L7_2 = L3_2.sender
    if L7_2 == A0_2 then
      L7_2 = tonumber
      L8_2 = L3_2.deleted_sender
      L7_2 = L7_2(L8_2)
      if 1 == L7_2 then
        L7_2 = false
        return L7_2
      end
    end
    L7_2 = true
    return L7_2
  end
  L6_2 = L3_2.conversation_id
  if nil ~= L6_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = L3_2.sender
  if A0_2 == L6_2 then
    L6_2 = tonumber
    L7_2 = L3_2.deleted_sender
    L6_2 = L6_2(L7_2)
    L6_2 = 1 ~= L6_2
    return L6_2
  end
  L6_2 = L3_2.receiver
  if A0_2 == L6_2 then
    L6_2 = tonumber
    L7_2 = L3_2.deleted_receiver
    L6_2 = L6_2(L7_2)
    L6_2 = 1 ~= L6_2
    return L6_2
  end
  L6_2 = false
  return L6_2
end
function L33_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L4_2 = L16_1
  L5_2 = A0_2.conversation_id
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = type
    L6_2 = GroupBroadcast
    L5_2 = L5_2(L6_2)
    if "function" ~= L5_2 then
      return
    end
    L5_2 = {}
    L5_2[A1_2] = true
    L6_2 = L16_1
    L7_2 = A0_2.message_id
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L6_2 = L31_1
      L7_2 = L16_1
      L8_2 = A0_2.message_id
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L7_2(L8_2)
      L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    end
    if L6_2 then
      L7_2 = tonumber
      L8_2 = L6_2.created
      L7_2 = L7_2(L8_2)
      if L7_2 then
        goto lbl_33
      end
    end
    L7_2 = 0
    ::lbl_33::
    L8_2 = pcall
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "SELECT member FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL AND joined > ?"
    L11_2 = {}
    L12_2 = L4_2
    L13_2 = L7_2
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
          L17_2 = L15_2.member
          L16_2 = L16_2(L17_2)
          L5_2[L16_2] = true
        end
      end
    end
    L10_2 = pcall
    L11_2 = GroupBroadcast
    L12_2 = L4_2
    L13_2 = A2_2
    L14_2 = A3_2
    L15_2 = L5_2
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    return
  end
  L5_2 = A0_2.creator
  if A1_2 == L5_2 then
    L5_2 = A0_2.peer
    if L5_2 then
      goto lbl_77
    end
  end
  L5_2 = A0_2.creator
  ::lbl_77::
  if not L5_2 or L5_2 == A1_2 then
    return
  end
  L6_2 = GetSrcByNumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L7_2 = HasPhoneItem
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_93
    end
  end
  do return end
  ::lbl_93::
  L7_2 = L32_1
  L8_2 = L5_2
  L9_2 = A0_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    return
  end
  L7_2 = GetCid
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if L7_2 then
    L8_2 = type
    L9_2 = IsBlocked
    L8_2 = L8_2(L9_2)
    if "function" == L8_2 then
      L8_2 = IsBlocked
      L9_2 = L7_2
      L10_2 = A1_2
      L8_2 = L8_2(L9_2, L10_2)
      if L8_2 then
        return
      end
    end
  end
  L8_2 = Push
  L9_2 = L6_2
  L10_2 = A2_2
  L11_2 = A3_2
  L8_2(L9_2, L10_2, L11_2)
end
L34_1 = 4000
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = A0_2
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = 0
  while L2_2 do
    L4_2 = L16_1
    L5_2 = L2_2.message_id
    L4_2 = L4_2(L5_2)
    if nil ~= L4_2 then
      break
    end
    L4_2 = L34_1
    if not (L3_2 < L4_2) then
      break
    end
    L4_2 = L14_1
    L4_2 = L4_2()
    L5_2 = tonumber
    L6_2 = L2_2.created
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = 0
    end
    L4_2 = L4_2 - L5_2
    L5_2 = L9_1
    if not (L4_2 < L5_2) then
      break
    end
    L4_2 = Wait
    L5_2 = 150
    L4_2(L5_2)
    L3_2 = L3_2 + 150
    L4_2 = A0_2
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    L2_2 = L4_2
  end
  return L2_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = 0
  while true do
    L3_2 = L12_1
    L3_2 = L3_2[A0_2]
    if not L3_2 then
      break
    end
    L3_2 = 3000
    if L2_2 >= L3_2 then
      L3_2 = {}
      L3_2.error = "busy"
      return L3_2
    end
    L3_2 = Wait
    L4_2 = 50
    L3_2(L4_2)
    L2_2 = L2_2 + 50
  end
  L3_2 = L12_1
  L3_2[A0_2] = true
  L3_2 = pcall
  L4_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2)
  L5_2 = L12_1
  L5_2[A0_2] = nil
  if not L3_2 then
    L5_2 = error
    L6_2 = L4_2
    L7_2 = 0
    L5_2(L6_2, L7_2)
  end
  return L4_2
end
function L37_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = type
  L1_2 = L15_1
  L1_2 = L1_2()
  L1_2 = L1_2.gif
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L15_1
    L0_2 = L0_2()
    L0_2 = L0_2.gif
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = {}
  ::lbl_15::
  L1_2 = type
  L2_2 = L0_2.provider
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L0_2.provider
    L2_2 = L1_2
    L1_2 = L1_2.lower
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_26
    end
  end
  L1_2 = "none"
  ::lbl_26::
  L2_2 = type
  L3_2 = L0_2.keyConvar
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = L0_2.keyConvar
    L3_2 = L2_2
    L2_2 = L2_2.match
    L4_2 = "^[%w_]+$"
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L2_2 = L0_2.keyConvar
      if L2_2 then
        goto lbl_41
      end
    end
  end
  L2_2 = "recado_gif_key"
  ::lbl_41::
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = L0_2.limit
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  if not L3_2 then
    L3_2 = 20
  end
  L4_2 = {}
  L4_2.provider = L1_2
  L4_2.keyConvar = L2_2
  L5_2 = math
  L5_2 = L5_2.max
  L6_2 = 1
  L7_2 = math
  L7_2 = L7_2.min
  L8_2 = 50
  L9_2 = L3_2
  L7_2 = L7_2(L8_2, L9_2)
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.limit = L5_2
  return L4_2
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = A0_2.provider
  if "tenor" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = GetConvar
  L2_2 = A0_2.keyConvar
  L3_2 = ""
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 or "" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  return L1_2
end
function L39_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = type
  L1_2 = L15_1
  L1_2 = L1_2()
  L1_2 = L1_2.polls
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L15_1
    L0_2 = L0_2()
    L0_2 = L0_2.polls
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = {}
  ::lbl_15::
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = L0_2.maxOptions
  L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  if not L1_2 then
    L1_2 = 12
  end
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 2
  L4_2 = math
  L4_2 = L4_2.min
  L5_2 = 20
  L6_2 = L1_2
  L4_2 = L4_2(L5_2, L6_2)
  return L2_2(L3_2, L4_2)
end
function L40_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = type
  L1_2 = L15_1
  L1_2 = L1_2()
  L1_2 = L1_2.events
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L15_1
    L0_2 = L0_2()
    L0_2 = L0_2.events
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = {}
  ::lbl_15::
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = type
  L4_2 = L0_2.reminders
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.reminders
    if L3_2 then
      goto lbl_33
    end
  end
  L3_2 = {}
  L4_2 = 0
  L5_2 = 15
  L6_2 = 60
  L7_2 = 1440
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  ::lbl_33::
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = math
    L8_2 = L8_2.tointeger
    L9_2 = tonumber
    L10_2 = L7_2
    L9_2, L10_2 = L9_2(L10_2)
    L8_2 = L8_2(L9_2, L10_2)
    if L8_2 and L8_2 >= 0 then
      L9_2 = 10080
      if L8_2 <= L9_2 then
        L9_2 = #L1_2
        L9_2 = L9_2 + 1
        L1_2[L9_2] = L8_2
      end
    end
  end
  return L1_2
end
L41_1 = RPC
function L42_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = L37_1
  L0_2 = L0_2()
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = type
  L4_2 = L15_1
  L4_2 = L4_2()
  L4_2 = L4_2.stickers
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L15_1
    L3_2 = L3_2()
    L3_2 = L3_2.stickers
    if L3_2 then
      goto lbl_20
    end
  end
  L3_2 = {}
  ::lbl_20::
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "string" == L8_2 then
      L8_2 = #L1_2
      L8_2 = L8_2 + 1
      L1_2[L8_2] = L7_2
    end
  end
  L2_2 = {}
  L3_2 = {}
  L4_2 = L38_1
  L5_2 = L0_2
  L4_2 = L4_2(L5_2)
  L4_2 = nil ~= L4_2
  L3_2.enabled = L4_2
  L4_2 = L0_2.provider
  L3_2.provider = L4_2
  L2_2.gif = L3_2
  L3_2 = {}
  L4_2 = L39_1
  L4_2 = L4_2()
  L3_2.maxOptions = L4_2
  L2_2.polls = L3_2
  L3_2 = {}
  L4_2 = L40_1
  L4_2 = L4_2()
  L3_2.reminders = L4_2
  L2_2.events = L3_2
  L2_2.stickers = L1_2
  L3_2 = {}
  L4_2 = L1_1
  L3_2.titleMax = L4_2
  L4_2 = L2_1
  L3_2.bodyMax = L4_2
  L2_2.doc = L3_2
  return L2_2
end
L41_1["recado.extras.config"] = L42_1
L41_1 = {}
L42_1 = {}
L43_1 = "ola"
L44_1 = "obrigado"
L45_1 = "ok"
L46_1 = "riso"
L47_1 = "triste"
L48_1 = "uau"
L49_1 = "amor"
L50_1 = "dormir"
L51_1 = "festa"
L52_1 = "pensar"
L53_1 = "zangado"
L54_1 = "fixe"
L42_1[1] = L43_1
L42_1[2] = L44_1
L42_1[3] = L45_1
L42_1[4] = L46_1
L42_1[5] = L47_1
L42_1[6] = L48_1
L42_1[7] = L49_1
L42_1[8] = L50_1
L42_1[9] = L51_1
L42_1[10] = L52_1
L42_1[11] = L53_1
L42_1[12] = L54_1
L41_1.basicos = L42_1
L42_1 = {}
L43_1 = "por_do_sol"
L44_1 = "palmeira"
L45_1 = "taxi"
L46_1 = "praia"
L47_1 = "skyline"
L48_1 = "sirene"
L49_1 = "hamburguer"
L50_1 = "cafe"
L51_1 = "dinheiro"
L52_1 = "roda_gigante"
L53_1 = "semaforo"
L54_1 = "los_santos"
L42_1[1] = L43_1
L42_1[2] = L44_1
L42_1[3] = L45_1
L42_1[4] = L46_1
L42_1[5] = L47_1
L42_1[6] = L48_1
L42_1[7] = L49_1
L42_1[8] = L50_1
L42_1[9] = L51_1
L42_1[10] = L52_1
L42_1[11] = L53_1
L42_1[12] = L54_1
L41_1.cidade = L42_1
L42_1 = {}
L43_1 = "boa"
L44_1 = "lol"
L45_1 = "nao"
L46_1 = "sim"
L47_1 = "ups"
L48_1 = "top"
L49_1 = "obrigado"
L50_1 = "ja_volto"
L51_1 = "fogo"
L52_1 = "mais_um"
L53_1 = "hein"
L54_1 = "coracao"
L42_1[1] = L43_1
L42_1[2] = L44_1
L42_1[3] = L45_1
L42_1[4] = L46_1
L42_1[5] = L47_1
L42_1[6] = L48_1
L42_1[7] = L49_1
L42_1[8] = L50_1
L42_1[9] = L51_1
L42_1[10] = L52_1
L42_1[11] = L53_1
L42_1[12] = L54_1
L41_1.reacoes = L42_1
L42_1 = {}
L43_1 = pairs
L44_1 = L41_1
L43_1, L44_1, L45_1, L46_1 = L43_1(L44_1)
for L47_1, L48_1 in L43_1, L44_1, L45_1, L46_1 do
  L49_1 = {}
  L42_1[L47_1] = L49_1
  L49_1 = ipairs
  L50_1 = L48_1
  L49_1, L50_1, L51_1, L52_1 = L49_1(L50_1)
  for L53_1, L54_1 in L49_1, L50_1, L51_1, L52_1 do
    L55_1 = L42_1[L47_1]
    L55_1[L54_1] = true
  end
end
function L43_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L15_1
  L1_2 = L1_2()
  L1_2 = L1_2.stickers
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = L42_1
    L2_2 = L2_2[A0_2]
    L2_2 = nil ~= L2_2
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    if L7_2 == A0_2 then
      L8_2 = L42_1
      L8_2 = L8_2[A0_2]
      L8_2 = nil ~= L8_2
      return L8_2
    end
  end
  L2_2 = false
  return L2_2
end
function L44_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = A0_2.pack
    L1_2 = L1_2(L2_2)
    if "string" == L1_2 then
      L1_2 = type
      L2_2 = A0_2.id
      L1_2 = L1_2(L2_2)
      if "string" == L1_2 then
        goto lbl_18
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_18::
  L1_2 = L43_1
  L2_2 = A0_2.pack
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = A0_2.pack
    L1_2 = L42_1
    L1_2 = L1_2[L2_2]
    L2_2 = A0_2.id
    L1_2 = L1_2[L2_2]
    if L1_2 then
      goto lbl_32
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_32::
  L1_2 = {}
  L2_2 = A0_2.pack
  L1_2.pack = L2_2
  L2_2 = A0_2.id
  L1_2.id = L2_2
  return L1_2
end
RecadoValidSticker = L44_1
function L44_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    L2_2 = 400
    if not (L1_2 > L2_2) then
      goto lbl_12
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_12::
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^https://([%w%-%.]+)(/[%w%-%._~/%%]+)$"
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 and L2_2 then
    L4_2 = L2_2
    L3_2 = L2_2.find
    L5_2 = ".."
    L6_2 = 1
    L7_2 = true
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
    if not L3_2 then
      goto lbl_28
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_28::
  L4_2 = L1_2
  L3_2 = L1_2.lower
  L3_2 = L3_2(L4_2)
  L1_2 = L3_2
  if "media.tenor.com" ~= L1_2 then
    L4_2 = L1_2
    L3_2 = L1_2.match
    L5_2 = "^[%w%-]+%.tenor%.com$"
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      L3_2 = nil
      return L3_2
    end
  end
  return A0_2
end
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L44_1
  L2_2 = A0_2.url
  L1_2 = L1_2(L2_2)
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.w
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A0_2.h
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if L1_2 and L2_2 and L3_2 and not (L2_2 < 1) and not (L3_2 < 1) then
    L4_2 = 4096
    if not (L2_2 > L4_2) then
      L4_2 = 4096
      if not (L3_2 > L4_2) then
        goto lbl_41
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_41::
  L4_2 = {}
  L4_2.url = L1_2
  L4_2.w = L2_2
  L4_2.h = L3_2
  L5_2 = L44_1
  L6_2 = A0_2.preview
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L4_2.preview = L5_2
  end
  return L4_2
end
RecadoValidGif = L45_1
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L21_1
  L2_2 = A0_2.title
  L3_2 = L1_1
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L22_1
  L3_2 = A0_2.body
  L4_2 = L2_1
  L2_2 = L2_2(L3_2, L4_2)
  if not L1_2 or not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L3_2.title = L1_2
  L3_2.body = L2_2
  return L3_2
end
RecadoValidDocument = L45_1
function L45_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L16_1
  if "poll" == A1_2 then
    L4_2 = A2_2.pollId
    if L4_2 then
      goto lbl_20
    end
  end
  if "event" == A1_2 then
    L4_2 = A2_2.eventId
    if L4_2 then
      goto lbl_20
    end
  end
  L4_2 = nil
  ::lbl_20::
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2 or L4_2
  if L3_2 then
    L4_2 = A1_2
    L5_2 = ":"
    L6_2 = L3_2
    L4_2 = L4_2 .. L5_2 .. L6_2
    L5_2 = L11_1
    L4_2 = L5_2[L4_2]
  end
  L5_2 = nil ~= L4_2
  return L5_2
end
RecadoExtrasPending = L45_1
function L45_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  if "sticker" == A1_2 then
    L3_2 = RecadoValidSticker
    L4_2 = A2_2
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    if nil == L3_2 then
      L5_2 = "badsticker"
      if L5_2 then
        goto lbl_13
      end
    end
    L5_2 = nil
    ::lbl_13::
    return L4_2, L5_2
  end
  if "gif" == A1_2 then
    L3_2 = RecadoValidGif
    L4_2 = A2_2
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    if nil == L3_2 then
      L5_2 = "badgif"
      if L5_2 then
        goto lbl_26
      end
    end
    L5_2 = nil
    ::lbl_26::
    return L4_2, L5_2
  end
  if "document" == A1_2 then
    L3_2 = RecadoValidDocument
    L4_2 = A2_2
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    if nil == L3_2 then
      L5_2 = "baddoc"
      if L5_2 then
        goto lbl_39
      end
    end
    L5_2 = nil
    ::lbl_39::
    return L4_2, L5_2
  end
  if "poll" == A1_2 or "event" == A1_2 then
    L3_2 = RecadoExtrasPending
    L4_2 = A0_2
    L5_2 = A1_2
    L6_2 = A2_2
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if not L3_2 then
      L3_2 = nil
      L4_2 = "badtype"
      return L3_2, L4_2
    end
    if "poll" == A1_2 then
      L3_2 = "pollId"
      if L3_2 then
        goto lbl_60
      end
    end
    L3_2 = "eventId"
    ::lbl_60::
    L4_2 = {}
    L5_2 = L16_1
    L6_2 = A2_2[L3_2]
    L5_2 = L5_2(L6_2)
    L4_2[L3_2] = L5_2
    L5_2 = nil
    return L4_2, L5_2
  end
  L3_2 = A2_2
  L4_2 = nil
  return L3_2, L4_2
end
RecadoExtrasValidate = L45_1
L45_1 = {}
L46_1 = "message_id"
L47_1 = "conversation_id"
L48_1 = "creator"
L49_1 = "peer"
L50_1 = "question"
L51_1 = "options"
L52_1 = "multi"
L53_1 = "show_voters"
L54_1 = "created"
L45_1[1] = L46_1
L45_1[2] = L47_1
L45_1[3] = L48_1
L45_1[4] = L49_1
L45_1[5] = L50_1
L45_1[6] = L51_1
L45_1[7] = L52_1
L45_1[8] = L53_1
L45_1[9] = L54_1
function L46_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT id, message_id, conversation_id, creator, peer, question, options, multi, show_voters, created FROM apex_phone_recado_polls WHERE id = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  L3_2 = L2_2 or L3_2
  if not L1_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L47_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2.options
  if not L3_2 then
    L3_2 = "[]"
  end
  L1_2, L2_2 = L1_2(L2_2, L3_2)
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
        L10_2 = type
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        if "string" == L10_2 then
          L10_2 = #L3_2
          L10_2 = L10_2 + 1
          L3_2[L10_2] = L9_2
        end
      end
    end
  end
  return L3_2
end
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = L16_1
  L3_2 = A0_2.id
  L2_2 = L2_2(L3_2)
  L3_2 = L47_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = A0_2.show_voters
  L4_2 = L4_2(L5_2)
  L4_2 = 1 == L4_2
  L5_2 = {}
  L6_2 = {}
  L7_2 = {}
  L8_2 = {}
  L9_2 = 1
  L10_2 = #L3_2
  L11_2 = 1
  for L12_2 = L9_2, L10_2, L11_2 do
    L5_2[L12_2] = 0
    L13_2 = {}
    L6_2[L12_2] = L13_2
  end
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.query
  L10_2 = L10_2.await
  L11_2 = "SELECT voter, option_idx FROM apex_phone_recado_poll_votes WHERE poll_id = ? ORDER BY created ASC LIMIT 6000"
  L12_2 = {}
  L13_2 = L2_2
  L12_2[1] = L13_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  L11_2 = 0
  L12_2 = 0
  L13_2 = ipairs
  L14_2 = L10_2 or L14_2
  if not L9_2 or not L10_2 then
    L14_2 = {}
  end
  L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
  for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
    L19_2 = math
    L19_2 = L19_2.tointeger
    L20_2 = tonumber
    L21_2 = L18_2.option_idx
    L20_2, L21_2, L22_2 = L20_2(L21_2)
    L19_2 = L19_2(L20_2, L21_2, L22_2)
    if L19_2 and L19_2 >= 0 then
      L20_2 = #L3_2
      if L19_2 < L20_2 then
        L20_2 = L19_2 + 1
        L21_2 = L19_2 + 1
        L21_2 = L5_2[L21_2]
        L21_2 = L21_2 + 1
        L5_2[L20_2] = L21_2
        L11_2 = L11_2 + 1
        L20_2 = tostring
        L21_2 = L18_2.voter
        L20_2 = L20_2(L21_2)
        L21_2 = L8_2[L20_2]
        if not L21_2 then
          L8_2[L20_2] = true
          L12_2 = L12_2 + 1
        end
        if L20_2 == A1_2 then
          L21_2 = #L7_2
          L21_2 = L21_2 + 1
          L7_2[L21_2] = L19_2
        end
        if L4_2 then
          L21_2 = L19_2 + 1
          L21_2 = L6_2[L21_2]
          L21_2 = #L21_2
          L22_2 = 256
          if L21_2 < L22_2 then
            L21_2 = L19_2 + 1
            L21_2 = L6_2[L21_2]
            L22_2 = L19_2 + 1
            L22_2 = L6_2[L22_2]
            L22_2 = #L22_2
            L22_2 = L22_2 + 1
            L21_2[L22_2] = L20_2
          end
        end
      end
    end
  end
  L13_2 = {}
  L14_2 = ipairs
  L15_2 = L3_2
  L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
  for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
    L20_2 = {}
    L20_2.text = L19_2
    L21_2 = L5_2[L18_2]
    L20_2.count = L21_2
    if L4_2 then
      L21_2 = L6_2[L18_2]
      L21_2 = #L21_2
      if L21_2 > 0 then
        L21_2 = L6_2[L18_2]
        L20_2.voters = L21_2
      end
    end
    L13_2[L18_2] = L20_2
  end
  L14_2 = {}
  L14_2.id = L2_2
  L15_2 = A0_2.question
  L14_2.question = L15_2
  L14_2.options = L13_2
  L14_2.counts = L5_2
  L15_2 = tonumber
  L16_2 = A0_2.multi
  L15_2 = L15_2(L16_2)
  L15_2 = 1 == L15_2
  L14_2.multi = L15_2
  L14_2.showVoters = L4_2
  L14_2.total = L12_2
  L14_2.votes = L11_2
  L15_2 = A0_2.creator
  L14_2.creator = L15_2
  L15_2 = tonumber
  L16_2 = A0_2.created
  L15_2 = L15_2(L16_2)
  L14_2.created = L15_2
  L15_2 = L16_1
  L16_2 = A0_2.conversation_id
  L15_2 = L15_2(L16_2)
  L14_2.conversation = L15_2
  L15_2 = L16_1
  L16_2 = A0_2.message_id
  L15_2 = L15_2(L16_2)
  L14_2.messageId = L15_2
  L15_2 = #L7_2
  if L15_2 > 0 then
    L14_2.mine = L7_2
  end
  return L14_2
end
L49_1 = RPC
function L50_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L26_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = L28_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L21_1
  L5_2 = A1_2.question
  L6_2 = L3_1
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "question"
    return L5_2
  end
  L5_2 = type
  L6_2 = A1_2.options
  L5_2 = L5_2(L6_2)
  if "table" ~= L5_2 then
    L5_2 = {}
    L5_2.error = "options"
    return L5_2
  end
  L5_2 = L39_1
  L5_2 = L5_2()
  L6_2 = {}
  L7_2 = {}
  L8_2 = 1
  L9_2 = math
  L9_2 = L9_2.min
  L10_2 = A1_2.options
  L10_2 = #L10_2
  L11_2 = 64
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = 1
  for L11_2 = L8_2, L9_2, L10_2 do
    L12_2 = L21_1
    L13_2 = A1_2.options
    L13_2 = L13_2[L11_2]
    L14_2 = L4_1
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      L14_2 = L12_2
      L13_2 = L12_2.lower
      L13_2 = L13_2(L14_2)
      L14_2 = L7_2[L13_2]
      if L14_2 then
        L14_2 = {}
        L14_2.error = "duplicate"
        return L14_2
      end
      L7_2[L13_2] = true
      L14_2 = #L6_2
      L14_2 = L14_2 + 1
      L6_2[L14_2] = L12_2
    end
  end
  L8_2 = #L6_2
  if L8_2 < 2 then
    L8_2 = {}
    L8_2.error = "options"
    return L8_2
  end
  L8_2 = #L6_2
  if L5_2 < L8_2 then
    L8_2 = {}
    L8_2.error = "toomany"
    L8_2.max = L5_2
    return L8_2
  end
  L8_2 = L27_1
  L9_2 = "apex_phone_recado_polls"
  L10_2 = L45_1
  L11_2 = {}
  L12_2 = L2_2.conversation
  L11_2.conversation_id = L12_2
  L12_2 = L2_2.me
  L11_2.creator = L12_2
  L12_2 = L2_2.number
  L11_2.peer = L12_2
  L11_2.question = L4_2
  L12_2 = json
  L12_2 = L12_2.encode
  L13_2 = L6_2
  L12_2 = L12_2(L13_2)
  L11_2.options = L12_2
  L12_2 = A1_2.multi
  if true == L12_2 then
    L12_2 = 1
    if L12_2 then
      goto lbl_114
    end
  end
  L12_2 = 0
  ::lbl_114::
  L11_2.multi = L12_2
  L12_2 = A1_2.showVoters
  if true == L12_2 then
    L12_2 = 1
    if L12_2 then
      goto lbl_122
    end
  end
  L12_2 = 0
  ::lbl_122::
  L11_2.show_voters = L12_2
  L12_2 = L14_1
  L12_2 = L12_2()
  L11_2.created = L12_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L9_2 = L16_1
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  L8_2 = L9_2
  if not L8_2 then
    L9_2 = {}
    L9_2.error = "db"
    return L9_2
  end
  L9_2 = "poll:"
  L10_2 = L8_2
  L9_2 = L9_2 .. L10_2
  L10_2 = L11_1
  L11_2 = {}
  L12_2 = tonumber
  L13_2 = A0_2
  L12_2 = L12_2(L13_2)
  L11_2.src = L12_2
  L12_2 = GetGameTimer
  L12_2 = L12_2()
  L11_2.t = L12_2
  L10_2[L9_2] = L11_2
  L10_2 = L29_1
  L11_2 = A0_2
  L12_2 = L2_2
  L13_2 = "poll"
  L14_2 = L4_2
  L15_2 = {}
  L15_2.pollId = L8_2
  L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L12_2 = L11_1
  L12_2[L9_2] = nil
  if not L10_2 then
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "DELETE FROM apex_phone_recado_polls WHERE id = ?"
    L14_2 = {}
    L15_2 = L8_2
    L14_2[1] = L15_2
    L12_2(L13_2, L14_2)
    L12_2 = {}
    L12_2.error = L11_2
    return L12_2
  end
  L12_2 = MySQL
  L12_2 = L12_2.update
  L12_2 = L12_2.await
  L13_2 = "UPDATE apex_phone_recado_polls SET message_id = ? WHERE id = ?"
  L14_2 = {}
  L15_2 = L11_2
  L16_2 = L8_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L12_2(L13_2, L14_2)
  L12_2 = L13_1
  L13_2 = "poll %d created by %s (%d options)"
  L14_2 = L8_2
  L15_2 = L2_2.me
  L16_2 = #L6_2
  L12_2(L13_2, L14_2, L15_2, L16_2)
  return L10_2
end
L49_1["recado.poll.create"] = L50_1
L49_1 = RPC
function L50_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L26_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = L16_1
  L3_2 = A1_2.pollId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = L35_1
  L4_2 = L46_1
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L24_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L3_2 then
    L5_2 = L32_1
    L6_2 = L4_2
    L7_2 = L3_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_37
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_37::
  L5_2 = L48_1
  L6_2 = L3_2
  L7_2 = L4_2
  return L5_2(L6_2, L7_2)
end
L49_1["recado.poll.get"] = L50_1
L49_1 = RPC
function L50_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L26_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = L16_1
  L3_2 = A1_2.pollId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = L24_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "noidentity"
    return L4_2
  end
  L4_2 = L35_1
  L5_2 = L46_1
  L6_2 = L2_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L32_1
    L6_2 = L3_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_43
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_43::
  L5_2 = L47_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  L5_2 = #L5_2
  L6_2 = {}
  L7_2 = {}
  L8_2 = A1_2.options
  if nil ~= L8_2 then
    L8_2 = type
    L9_2 = A1_2.options
    L8_2 = L8_2(L9_2)
    if "table" ~= L8_2 then
      L8_2 = {}
      L8_2.error = "options"
      return L8_2
    end
    L8_2 = 1
    L9_2 = math
    L9_2 = L9_2.min
    L10_2 = A1_2.options
    L10_2 = #L10_2
    L11_2 = 64
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = 1
    for L11_2 = L8_2, L9_2, L10_2 do
      L12_2 = math
      L12_2 = L12_2.tointeger
      L13_2 = tonumber
      L14_2 = A1_2.options
      L14_2 = L14_2[L11_2]
      L13_2, L14_2, L15_2 = L13_2(L14_2)
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      if not L12_2 or L12_2 < 0 or L5_2 <= L12_2 then
        L13_2 = {}
        L13_2.error = "options"
        return L13_2
      end
      L13_2 = L7_2[L12_2]
      if not L13_2 then
        L7_2[L12_2] = true
        L13_2 = #L6_2
        L13_2 = L13_2 + 1
        L6_2[L13_2] = L12_2
      end
    end
  end
  L8_2 = tonumber
  L9_2 = L4_2.multi
  L8_2 = L8_2(L9_2)
  if 1 ~= L8_2 then
    L8_2 = #L6_2
    if L8_2 > 1 then
      L8_2 = {}
      L8_2.error = "single"
      return L8_2
    end
  end
  L8_2 = L36_1
  L9_2 = "p"
  L10_2 = L2_2
  L11_2 = ":"
  L12_2 = L3_2
  L9_2 = L9_2 .. L10_2 .. L11_2 .. L12_2
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = L14_1
    L0_3 = L0_3()
    L1_3 = {}
    L2_3 = {}
    L2_3.query = "DELETE FROM apex_phone_recado_poll_votes WHERE poll_id = ? AND voter = ?"
    L3_3 = {}
    L4_3 = L2_2
    L5_3 = L3_2
    L3_3[1] = L4_3
    L3_3[2] = L5_3
    L2_3.values = L3_3
    L1_3[1] = L2_3
    L2_3 = L6_2
    L2_3 = #L2_3
    if L2_3 > 0 then
      L2_3 = {}
      L3_3 = {}
      L4_3 = ipairs
      L5_3 = L6_2
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
      for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
        L10_3 = #L2_3
        L10_3 = L10_3 + 1
        L2_3[L10_3] = "(?, ?, ?, ?)"
        L10_3 = #L3_3
        L10_3 = L10_3 + 1
        L11_3 = L2_2
        L3_3[L10_3] = L11_3
        L10_3 = #L3_3
        L10_3 = L10_3 + 1
        L11_3 = L3_2
        L3_3[L10_3] = L11_3
        L10_3 = #L3_3
        L10_3 = L10_3 + 1
        L3_3[L10_3] = L9_3
        L10_3 = #L3_3
        L10_3 = L10_3 + 1
        L3_3[L10_3] = L0_3
      end
      L4_3 = #L1_3
      L4_3 = L4_3 + 1
      L5_3 = {}
      L6_3 = "INSERT INTO apex_phone_recado_poll_votes (poll_id, voter, option_idx, created) VALUES "
      L7_3 = table
      L7_3 = L7_3.concat
      L8_3 = L2_3
      L9_3 = ", "
      L7_3 = L7_3(L8_3, L9_3)
      L6_3 = L6_3 .. L7_3
      L5_3.query = L6_3
      L5_3.values = L3_3
      L1_3[L4_3] = L5_3
    end
    L2_3 = false
    L3_3 = false
    L4_3 = MySQL
    L4_3 = L4_3.transaction
    if L4_3 then
      L4_3 = MySQL
      L4_3 = L4_3.transaction
      L4_3 = L4_3.await
      if L4_3 then
        L4_3 = pcall
        L5_3 = MySQL
        L5_3 = L5_3.transaction
        L5_3 = L5_3.await
        L6_3 = L1_3
        L4_3, L5_3 = L4_3(L5_3, L6_3)
        L3_3 = L5_3
        L2_3 = L4_3
      end
    end
    if not L2_3 or not L3_3 then
      L4_3 = ipairs
      L5_3 = L1_3
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
      for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
        L10_3 = MySQL
        L10_3 = L10_3.query
        L10_3 = L10_3.await
        L11_3 = L9_3.query
        L12_3 = L9_3.values
        L10_3(L11_3, L12_3)
      end
    end
    L4_3 = true
    return L4_3
  end
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = type
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = L8_2.error
    if L9_2 then
      return L8_2
    end
  end
  L9_2 = L48_1
  L10_2 = L4_2
  L11_2 = L3_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = L33_1
  L11_2 = L4_2
  L12_2 = L3_2
  L13_2 = "recadoPoll"
  L14_2 = {}
  L14_2.pollId = L2_2
  L15_2 = L9_2.counts
  L14_2.counts = L15_2
  L15_2 = L9_2.total
  L14_2.total = L15_2
  L15_2 = L9_2.votes
  L14_2.votes = L15_2
  L10_2(L11_2, L12_2, L13_2, L14_2)
  return L9_2
end
L49_1["recado.poll.vote"] = L50_1
L49_1 = {}
L50_1 = "message_id"
L51_1 = "conversation_id"
L52_1 = "creator"
L53_1 = "peer"
L54_1 = "title"
L55_1 = "description"
L56_1 = "start"
L57_1 = "loc_x"
L58_1 = "loc_y"
L59_1 = "loc_label"
L60_1 = "reminder"
L61_1 = "reminded"
L62_1 = "created"
L49_1[1] = L50_1
L49_1[2] = L51_1
L49_1[3] = L52_1
L49_1[4] = L53_1
L49_1[5] = L54_1
L49_1[6] = L55_1
L49_1[7] = L56_1
L49_1[8] = L57_1
L49_1[9] = L58_1
L49_1[10] = L59_1
L49_1[11] = L60_1
L49_1[12] = L61_1
L49_1[13] = L62_1
L50_1 = {}
L50_1.yes = true
L50_1.maybe = true
L50_1.no = true
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT id, message_id, conversation_id, creator, peer, title, description, start, loc_x, loc_y, loc_label, reminder, reminded, cancelled, created FROM apex_phone_recado_events WHERE id = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  L3_2 = L2_2 or L3_2
  if not L1_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L52_1(A0_2)
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
        L2_2 = -10000
        if not (L1_2 < L2_2) then
          L2_2 = 10000
          if not (L1_2 > L2_2) then
            goto lbl_25
          end
        end
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_25::
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L1_2 * 100
  L3_2 = L3_2 + 0.5
  L2_2 = L2_2(L3_2)
  L2_2 = L2_2 / 100
  return L2_2
end
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = L16_1
  L3_2 = A0_2.id
  L2_2 = L2_2(L3_2)
  L3_2 = {}
  L3_2.yes = 0
  L3_2.maybe = 0
  L3_2.no = 0
  L4_2 = {}
  L5_2 = {}
  L4_2.yes = L5_2
  L5_2 = {}
  L4_2.maybe = L5_2
  L5_2 = {}
  L4_2.no = L5_2
  L5_2 = nil
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT who, answer FROM apex_phone_recado_rsvp WHERE event_id = ? ORDER BY updated ASC LIMIT 1000"
  L9_2 = {}
  L10_2 = L2_2
  L9_2[1] = L10_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
  L8_2 = L16_1
  L9_2 = A0_2.conversation_id
  L8_2 = L8_2(L9_2)
  L9_2 = nil
  if L8_2 then
    L10_2 = type
    L11_2 = GroupMembers
    L10_2 = L10_2(L11_2)
    if "function" == L10_2 then
      L10_2 = {}
      L9_2 = L10_2
      L10_2 = pcall
      L11_2 = GroupMembers
      L12_2 = L8_2
      L10_2, L11_2 = L10_2(L11_2, L12_2)
      L12_2 = ipairs
      if L10_2 then
        L13_2 = type
        L14_2 = L11_2
        L13_2 = L13_2(L14_2)
        if "table" == L13_2 and L11_2 then
          goto lbl_61
          L13_2 = L11_2 or L13_2
        end
      end
      L13_2 = {}
      ::lbl_61::
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
      for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
        L18_2 = tostring
        L19_2 = L17_2
        L18_2 = L18_2(L19_2)
        L9_2[L18_2] = true
      end
    end
  end
  L10_2 = ipairs
  L11_2 = L7_2 or L11_2
  if not L6_2 or not L7_2 then
    L11_2 = {}
  end
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.answer
    L17_2 = tostring
    L18_2 = L15_2.who
    L17_2 = L17_2(L18_2)
    L18_2 = L50_1
    L18_2 = L18_2[L16_2]
    if L18_2 then
      if L9_2 then
        L18_2 = L9_2[L17_2]
        if not L18_2 then
          goto lbl_109
        end
      end
      L18_2 = L3_2[L16_2]
      L18_2 = L18_2 + 1
      L3_2[L16_2] = L18_2
      L18_2 = L4_2[L16_2]
      L18_2 = #L18_2
      if L18_2 < 128 then
        L18_2 = L4_2[L16_2]
        L19_2 = L4_2[L16_2]
        L19_2 = #L19_2
        L19_2 = L19_2 + 1
        L18_2[L19_2] = L17_2
      end
      if L17_2 == A1_2 then
        L5_2 = L16_2
      end
    end
    ::lbl_109::
  end
  L10_2 = {}
  L10_2.id = L2_2
  L11_2 = A0_2.title
  L10_2.title = L11_2
  L11_2 = tonumber
  L12_2 = A0_2.start
  L11_2 = L11_2(L12_2)
  L10_2.start = L11_2
  L11_2 = tonumber
  L12_2 = A0_2.created
  L11_2 = L11_2(L12_2)
  L10_2.created = L11_2
  L11_2 = A0_2.creator
  L10_2.creator = L11_2
  L11_2 = math
  L11_2 = L11_2.tointeger
  L12_2 = tonumber
  L13_2 = A0_2.reminder
  L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L12_2(L13_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  if not L11_2 then
    L11_2 = -1
  end
  L10_2.reminder = L11_2
  L11_2 = tonumber
  L12_2 = A0_2.cancelled
  L11_2 = L11_2(L12_2)
  L11_2 = 1 == L11_2
  L10_2.cancelled = L11_2
  L10_2.conversation = L8_2
  L11_2 = L16_1
  L12_2 = A0_2.message_id
  L11_2 = L11_2(L12_2)
  L10_2.messageId = L11_2
  L10_2.counts = L3_2
  L10_2.mine = L5_2
  L11_2 = type
  L12_2 = A0_2.description
  L11_2 = L11_2(L12_2)
  if "string" == L11_2 then
    L11_2 = A0_2.description
    if "" ~= L11_2 then
      L11_2 = A0_2.description
      L10_2.description = L11_2
    end
  end
  L11_2 = tonumber
  L12_2 = A0_2.loc_x
  L11_2 = L11_2(L12_2)
  L12_2 = tonumber
  L13_2 = A0_2.loc_y
  L12_2 = L12_2(L13_2)
  if not L11_2 or not L12_2 then
    L13_2 = type
    L14_2 = A0_2.loc_label
    L13_2 = L13_2(L14_2)
    if "string" ~= L13_2 then
      goto lbl_187
    end
    L13_2 = A0_2.loc_label
    if "" == L13_2 then
      goto lbl_187
    end
  end
  L13_2 = {}
  L13_2.x = L11_2
  L13_2.y = L12_2
  L14_2 = A0_2.loc_label
  L13_2.label = L14_2
  L10_2.location = L13_2
  ::lbl_187::
  L13_2 = L4_2.yes
  L13_2 = #L13_2
  if L13_2 > 0 then
    L13_2 = L4_2.yes
    L10_2.going = L13_2
  end
  L13_2 = L4_2.maybe
  L13_2 = #L13_2
  if L13_2 > 0 then
    L13_2 = L4_2.maybe
    L10_2.maybe = L13_2
  end
  L13_2 = L4_2.no
  L13_2 = #L13_2
  if L13_2 > 0 then
    L13_2 = L4_2.no
    L10_2.notGoing = L13_2
  end
  return L10_2
end
L54_1 = RPC
function L55_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = L26_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = L28_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L21_1
  L5_2 = A1_2.title
  L6_2 = L5_1
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "title"
    return L5_2
  end
  L5_2 = nil
  L6_2 = A1_2.description
  if nil ~= L6_2 then
    L6_2 = A1_2.description
    if "" ~= L6_2 then
      L6_2 = L22_1
      L7_2 = A1_2.description
      L8_2 = L6_1
      L6_2 = L6_2(L7_2, L8_2)
      L5_2 = L6_2
    end
  end
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = A1_2.start
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L7_2 = L14_1
  L7_2 = L7_2()
  if L6_2 then
    L8_2 = L7_2 - 60000
    if not (L6_2 < L8_2) then
      L8_2 = L8_1
      L8_2 = L7_2 + L8_2
      if not (L6_2 > L8_2) then
        goto lbl_64
      end
    end
  end
  L8_2 = {}
  L8_2.error = "start"
  do return L8_2 end
  ::lbl_64::
  L8_2 = nil
  L9_2 = nil
  L10_2 = nil
  L11_2 = type
  L12_2 = A1_2.location
  L11_2 = L11_2(L12_2)
  if "table" == L11_2 then
    L11_2 = L21_1
    L12_2 = A1_2.location
    L12_2 = L12_2.label
    L13_2 = L7_1
    L11_2 = L11_2(L12_2, L13_2)
    L10_2 = L11_2
    L11_2 = A1_2.location
    L11_2 = L11_2.here
    if true == L11_2 then
      L11_2 = GetPlayerPed
      L12_2 = A0_2
      L11_2 = L11_2(L12_2)
      if L11_2 and 0 ~= L11_2 then
        L12_2 = GetEntityCoords
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        if L12_2 then
          L13_2 = L52_1
          L14_2 = L12_2.x
          L13_2 = L13_2(L14_2)
          L14_2 = L52_1
          L15_2 = L12_2.y
          L14_2 = L14_2(L15_2)
          L9_2 = L14_2
          L8_2 = L13_2
        end
      end
      if not L8_2 then
        L12_2 = {}
        L12_2.error = "location"
        return L12_2
      end
      if not L10_2 then
        L10_2 = "Localiza\195\167\195\163o partilhada"
      end
    else
      L11_2 = A1_2.location
      L11_2 = L11_2.x
      if nil == L11_2 then
        L11_2 = A1_2.location
        L11_2 = L11_2.y
      end
      if nil ~= L11_2 then
        L11_2 = L52_1
        L12_2 = A1_2.location
        L12_2 = L12_2.x
        L11_2 = L11_2(L12_2)
        L12_2 = L52_1
        L13_2 = A1_2.location
        L13_2 = L13_2.y
        L12_2 = L12_2(L13_2)
        L9_2 = L12_2
        L8_2 = L11_2
        if not L8_2 or not L9_2 then
          L11_2 = {}
          L11_2.error = "location"
          return L11_2
        end
      end
    end
  else
    L11_2 = A1_2.location
    if nil ~= L11_2 then
      L11_2 = A1_2.location
      if false ~= L11_2 then
        L11_2 = {}
        L11_2.error = "location"
        return L11_2
      end
    end
  end
  L11_2 = -1
  L12_2 = A1_2.reminder
  if nil ~= L12_2 then
    L12_2 = A1_2.reminder
    if false ~= L12_2 then
      L12_2 = tonumber
      L13_2 = A1_2.reminder
      L12_2 = L12_2(L13_2)
      if -1 ~= L12_2 then
        L12_2 = math
        L12_2 = L12_2.tointeger
        L13_2 = tonumber
        L14_2 = A1_2.reminder
        L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L13_2(L14_2)
        L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L13_2 = false
        L14_2 = ipairs
        L15_2 = L40_1
        L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2()
        L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
          if L19_2 == L12_2 then
            L13_2 = true
            break
          end
        end
        if not L13_2 then
          L14_2 = {}
          L14_2.error = "reminder"
          return L14_2
        end
        L11_2 = L12_2
      end
    end
  end
  if not (L11_2 < 0) then
    L12_2 = L11_2 * 60000
    L12_2 = L6_2 - L12_2
    L13_2 = L7_2 + 30000
    if not (L12_2 <= L13_2) then
      goto lbl_198
    end
  end
  L12_2 = 1
  ::lbl_198::
  if not L12_2 then
    L12_2 = 0
  end
  L13_2 = L16_1
  L14_2 = L27_1
  L15_2 = "apex_phone_recado_events"
  L16_2 = L49_1
  L17_2 = {}
  L18_2 = L2_2.conversation
  L17_2.conversation_id = L18_2
  L18_2 = L2_2.me
  L17_2.creator = L18_2
  L18_2 = L2_2.number
  L17_2.peer = L18_2
  L17_2.title = L4_2
  L17_2.description = L5_2
  L17_2.start = L6_2
  L17_2.loc_x = L8_2
  L17_2.loc_y = L9_2
  L17_2.loc_label = L10_2
  L17_2.reminder = L11_2
  L17_2.reminded = L12_2
  L17_2.created = L7_2
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L14_2(L15_2, L16_2, L17_2)
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  if not L13_2 then
    L14_2 = {}
    L14_2.error = "db"
    return L14_2
  end
  L14_2 = "event:"
  L15_2 = L13_2
  L14_2 = L14_2 .. L15_2
  L15_2 = L11_1
  L16_2 = {}
  L17_2 = tonumber
  L18_2 = A0_2
  L17_2 = L17_2(L18_2)
  L16_2.src = L17_2
  L17_2 = GetGameTimer
  L17_2 = L17_2()
  L16_2.t = L17_2
  L15_2[L14_2] = L16_2
  L15_2 = L29_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "event"
  L19_2 = L4_2
  L20_2 = {}
  L20_2.eventId = L13_2
  L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L17_2 = L11_1
  L17_2[L14_2] = nil
  if not L15_2 then
    L17_2 = MySQL
    L17_2 = L17_2.query
    L17_2 = L17_2.await
    L18_2 = "DELETE FROM apex_phone_recado_events WHERE id = ?"
    L19_2 = {}
    L20_2 = L13_2
    L19_2[1] = L20_2
    L17_2(L18_2, L19_2)
    L17_2 = {}
    L17_2.error = L16_2
    return L17_2
  end
  L17_2 = MySQL
  L17_2 = L17_2.update
  L17_2 = L17_2.await
  L18_2 = "UPDATE apex_phone_recado_events SET message_id = ? WHERE id = ?"
  L19_2 = {}
  L20_2 = L16_2
  L21_2 = L13_2
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L17_2(L18_2, L19_2)
  L17_2 = MySQL
  L17_2 = L17_2.insert
  L17_2 = L17_2.await
  L18_2 = "INSERT INTO apex_phone_recado_rsvp (event_id, who, answer, updated) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE answer = VALUES(answer), updated = VALUES(updated)"
  L19_2 = {}
  L20_2 = L13_2
  L21_2 = L2_2.me
  L22_2 = "yes"
  L23_2 = L7_2
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L19_2[4] = L23_2
  L17_2(L18_2, L19_2)
  L17_2 = L13_1
  L18_2 = "event %d created by %s (start %s, reminder %s)"
  L19_2 = L13_2
  L20_2 = L2_2.me
  L21_2 = L6_2
  L22_2 = L11_2
  L17_2(L18_2, L19_2, L20_2, L21_2, L22_2)
  return L15_2
end
L54_1["recado.event.create"] = L55_1
L54_1 = RPC
function L55_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L26_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = L16_1
  L3_2 = A1_2.eventId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = L35_1
  L4_2 = L51_1
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L24_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L3_2 then
    L5_2 = L32_1
    L6_2 = L4_2
    L7_2 = L3_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_37
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_37::
  L5_2 = L53_1
  L6_2 = L3_2
  L7_2 = L4_2
  return L5_2(L6_2, L7_2)
end
L54_1["recado.event.get"] = L55_1
L54_1 = RPC
function L55_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L26_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = L16_1
  L3_2 = A1_2.eventId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = L24_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "noidentity"
    return L4_2
  end
  L4_2 = L35_1
  L5_2 = L51_1
  L6_2 = L2_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L32_1
    L6_2 = L3_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_43
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_43::
  L5_2 = tonumber
  L6_2 = L4_2.cancelled
  L5_2 = L5_2(L6_2)
  if 1 == L5_2 then
    L5_2 = {}
    L5_2.error = "cancelled"
    return L5_2
  end
  L5_2 = tonumber
  L6_2 = L4_2.start
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L6_2 = L14_1
  L6_2 = L6_2()
  L6_2 = L6_2 - 10800000
  if L5_2 < L6_2 then
    L5_2 = {}
    L5_2.error = "past"
    return L5_2
  end
  L5_2 = A1_2.answer
  if "" == L5_2 or false == L5_2 then
    L5_2 = nil
  end
  if nil ~= L5_2 then
    L6_2 = L50_1
    L6_2 = L6_2[L5_2]
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "answer"
      return L6_2
    end
  end
  L6_2 = L36_1
  L7_2 = "e"
  L8_2 = L2_2
  L9_2 = ":"
  L10_2 = L3_2
  L7_2 = L7_2 .. L8_2 .. L9_2 .. L10_2
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = L5_2
    if L0_3 then
      L0_3 = MySQL
      L0_3 = L0_3.insert
      L0_3 = L0_3.await
      L1_3 = "INSERT INTO apex_phone_recado_rsvp (event_id, who, answer, updated) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE answer = VALUES(answer), updated = VALUES(updated)"
      L2_3 = {}
      L3_3 = L2_2
      L4_3 = L3_2
      L5_3 = L5_2
      L6_3 = L14_1
      L6_3 = L6_3()
      L2_3[1] = L3_3
      L2_3[2] = L4_3
      L2_3[3] = L5_3
      L2_3[4] = L6_3
      L0_3(L1_3, L2_3)
    else
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "DELETE FROM apex_phone_recado_rsvp WHERE event_id = ? AND who = ?"
      L2_3 = {}
      L3_3 = L2_2
      L4_3 = L3_2
      L2_3[1] = L3_3
      L2_3[2] = L4_3
      L0_3(L1_3, L2_3)
    end
    L0_3 = true
    return L0_3
  end
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = type
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = L6_2.error
    if L7_2 then
      return L6_2
    end
  end
  L7_2 = L53_1
  L8_2 = L4_2
  L9_2 = L3_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = L33_1
  L9_2 = L4_2
  L10_2 = L3_2
  L11_2 = "recadoEvent"
  L12_2 = {}
  L12_2.eventId = L2_2
  L13_2 = L7_2.counts
  L12_2.counts = L13_2
  L12_2.cancelled = false
  L8_2(L9_2, L10_2, L11_2, L12_2)
  return L7_2
end
L54_1["recado.event.rsvp"] = L55_1
L54_1 = RPC
function L55_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L26_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = L16_1
  L3_2 = A1_2.eventId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = L24_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L35_1
  L5_2 = L51_1
  L6_2 = L2_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L32_1
    L6_2 = L3_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_37
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_37::
  L5_2 = L4_2.creator
  if L5_2 ~= L3_2 then
    L5_2 = {}
    L5_2.error = "notcreator"
    return L5_2
  end
  L5_2 = tonumber
  L6_2 = L4_2.cancelled
  L5_2 = L5_2(L6_2)
  if 1 ~= L5_2 then
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "UPDATE apex_phone_recado_events SET cancelled = 1, reminded = 1 WHERE id = ?"
    L7_2 = {}
    L8_2 = L2_2
    L7_2[1] = L8_2
    L5_2(L6_2, L7_2)
    L4_2.cancelled = 1
  end
  L5_2 = L53_1
  L6_2 = L4_2
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L33_1
  L7_2 = L4_2
  L8_2 = L3_2
  L9_2 = "recadoEvent"
  L10_2 = {}
  L10_2.eventId = L2_2
  L11_2 = L5_2.counts
  L10_2.counts = L11_2
  L10_2.cancelled = true
  L6_2(L7_2, L8_2, L9_2, L10_2)
  return L5_2
end
L54_1["recado.event.cancel"] = L55_1
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = A0_2 / 60000
  L2_2 = L2_2 + 0.5
  L1_2 = L1_2(L2_2)
  if L1_2 <= 1 then
    L2_2 = "Est\195\161 a come\195\167ar agora"
    return L2_2
  end
  if L1_2 < 60 then
    L2_2 = "Come\195\167a daqui a %d min"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = L1_2
    return L2_2(L3_2, L4_2)
  end
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L1_2 / 60
  L3_2 = L3_2 + 0.5
  L2_2 = L2_2(L3_2)
  if L2_2 < 24 then
    L3_2 = "Come\195\167a daqui a %d h"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = L2_2
    return L3_2(L4_2, L5_2)
  end
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = L2_2 / 24
  L4_2 = L4_2 + 0.5
  L3_2 = L3_2(L4_2)
  if L3_2 <= 1 then
    L4_2 = "Come\195\167a amanh\195\163"
    if L4_2 then
      goto lbl_49
    end
  end
  L4_2 = "Come\195\167a daqui a %d dias"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  ::lbl_49::
  return L4_2
end
function L55_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L0_2 = L14_1
  L0_2 = L0_2()
  L1_2 = 0
  L2_2 = ipairs
  L3_2 = L40_1
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L3_2()
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    if L1_2 < L7_2 then
      L1_2 = L7_2
    end
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = [[
SELECT id, message_id, conversation_id, creator, peer, title, start, reminder, loc_label
        FROM apex_phone_recado_events WHERE reminded = 0 AND start >= ? AND start <= ? AND cancelled = 0
        AND start - reminder * 60000 <= ? ORDER BY start ASC LIMIT 50]]
  L4_2 = {}
  L5_2 = L0_2 - 3600000
  L6_2 = L1_2 * 60000
  L6_2 = L0_2 + L6_2
  L6_2 = L6_2 + 60000
  L7_2 = L0_2
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
    L9_2 = MySQL
    L9_2 = L9_2.update
    L9_2 = L9_2.await
    L10_2 = "UPDATE apex_phone_recado_events SET reminded = 1 WHERE id = ? AND reminded = 0"
    L11_2 = {}
    L12_2 = L8_2.id
    L11_2[1] = L12_2
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = tonumber
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    if 1 == L10_2 then
      L10_2 = L16_1
      L11_2 = L8_2.message_id
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L10_2 = L16_1
        L11_2 = L8_2.conversation_id
        L10_2 = L10_2(L11_2)
        L11_2 = MySQL
        L11_2 = L11_2.query
        L11_2 = L11_2.await
        L12_2 = "SELECT who FROM apex_phone_recado_rsvp WHERE event_id = ? AND answer IN ('yes', 'maybe') LIMIT 256"
        L13_2 = {}
        L14_2 = L8_2.id
        L13_2[1] = L14_2
        L11_2 = L11_2(L12_2, L13_2)
        if not L11_2 then
          L11_2 = {}
        end
        L12_2 = L54_1
        L13_2 = tonumber
        L14_2 = L8_2.start
        L13_2 = L13_2(L14_2)
        if not L13_2 then
          L13_2 = L0_2
        end
        L13_2 = L13_2 - L0_2
        L12_2 = L12_2(L13_2)
        L13_2 = type
        L14_2 = L8_2.loc_label
        L13_2 = L13_2(L14_2)
        if "string" == L13_2 then
          L13_2 = L8_2.loc_label
          if "" ~= L13_2 then
            L13_2 = L12_2
            L14_2 = " \194\183 "
            L15_2 = L8_2.loc_label
            L13_2 = L13_2 .. L14_2 .. L15_2
            L12_2 = L13_2
          end
        end
        L13_2 = ipairs
        L14_2 = L11_2
        L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
        for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
          L19_2 = tostring
          L20_2 = L18_2.who
          L19_2 = L19_2(L20_2)
          L20_2 = L32_1
          L21_2 = L19_2
          L22_2 = L8_2
          L20_2 = L20_2(L21_2, L22_2)
          if L20_2 then
            L20_2 = GetCitizenIdByNumber
            L21_2 = L19_2
            L20_2 = L20_2(L21_2)
            if L20_2 then
              L21_2 = {}
              L22_2 = L16_1
              L23_2 = L8_2.id
              L22_2 = L22_2(L23_2)
              L21_2.eventId = L22_2
              if L10_2 then
                L21_2.conversation = L10_2
              else
                L22_2 = L8_2.creator
                if L19_2 == L22_2 then
                  L22_2 = L8_2.peer
                  if L22_2 then
                    goto lbl_136
                  end
                end
                L22_2 = L8_2.creator
                ::lbl_136::
                L21_2.number = L22_2
              end
              L22_2 = NotifyCitizen
              L23_2 = L20_2
              L24_2 = "recado"
              L25_2 = "\240\159\147\133 "
              L26_2 = tostring
              L27_2 = L8_2.title
              L26_2 = L26_2(L27_2)
              L25_2 = L25_2 .. L26_2
              L26_2 = L12_2
              L27_2 = L21_2
              L28_2 = {}
              L28_2.type = "banner"
              L22_2(L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
            end
          end
        end
        L13_2 = L13_1
        L14_2 = "event %s reminder sent to %d person(s)"
        L15_2 = L8_2.id
        L16_2 = #L11_2
        L13_2(L14_2, L15_2, L16_2)
      end
    end
  end
end
L56_1 = CreateThread
function L57_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  while true do
    L0_2 = L10_1
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
  while true do
    L0_2 = Wait
    L1_2 = 30000
    L0_2(L1_2)
    L0_2 = pcall
    L1_2 = L55_1
    L0_2, L1_2 = L0_2(L1_2)
    if not L0_2 then
      L2_2 = print
      L3_2 = "^3[unique_phone]^0 recado_extras: reminders (%s)"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = tostring
      L6_2 = L1_2
      L5_2, L6_2 = L5_2(L6_2)
      L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
      L2_2(L3_2, L4_2, L5_2, L6_2)
    end
  end
end
L56_1(L57_1)
function L56_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = L14_1
  L3_2 = L3_2()
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = [[
SELECT p.id FROM `%s` p LEFT JOIN apex_phone_messages m ON m.id = p.message_id
        WHERE (p.message_id IS NULL AND p.created < ?) OR (p.message_id IS NOT NULL AND m.id IS NULL) LIMIT 500]]
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = A0_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = {}
  L8_2 = L3_2 - 600000
  L7_2[1] = L8_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = #L5_2
      if 0 ~= L6_2 then
        goto lbl_29
      end
    end
  end
  L6_2 = 0
  do return L6_2 end
  ::lbl_29::
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L14_2 = L16_1
    L15_2 = L12_2.id
    L14_2 = L14_2(L15_2)
    L6_2[L13_2] = L14_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "DELETE FROM `%s` WHERE `%s` IN (%s)"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = A1_2
  L11_2 = A2_2
  L12_2 = L17_1
  L13_2 = #L6_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L9_2 = L6_2
  L7_2(L8_2, L9_2)
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "DELETE FROM `%s` WHERE id IN (%s)"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = A0_2
  L11_2 = L17_1
  L12_2 = #L6_2
  L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L9_2 = L6_2
  L7_2(L8_2, L9_2)
  L7_2 = #L6_2
  return L7_2
end
L57_1 = CreateThread
function L58_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  while true do
    L0_2 = L10_1
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 60000
  L0_2(L1_2)
  while true do
    L0_2 = pcall
    function L1_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
      L0_3 = L56_1
      L1_3 = "apex_phone_recado_polls"
      L2_3 = "apex_phone_recado_poll_votes"
      L3_3 = "poll_id"
      L0_3 = L0_3(L1_3, L2_3, L3_3)
      L1_3 = L56_1
      L2_3 = "apex_phone_recado_events"
      L3_3 = "apex_phone_recado_rsvp"
      L4_3 = "event_id"
      L1_3 = L1_3(L2_3, L3_3, L4_3)
      L2_3 = MySQL
      L2_3 = L2_3.update
      L2_3 = L2_3.await
      L3_3 = "UPDATE apex_phone_recado_events SET reminded = 1 WHERE reminded = 0 AND start < ?"
      L4_3 = {}
      L5_3 = L14_1
      L5_3 = L5_3()
      L5_3 = L5_3 - 3600000
      L4_3[1] = L5_3
      L2_3(L3_3, L4_3)
      L2_3 = L0_3 + L1_3
      if L2_3 > 0 then
        L2_3 = L13_1
        L3_3 = "cleanup: %d poll(s), %d event(s)"
        L4_3 = L0_3
        L5_3 = L1_3
        L2_3(L3_3, L4_3, L5_3)
      end
    end
    L0_2, L1_2 = L0_2(L1_2)
    if not L0_2 then
      L2_2 = print
      L3_2 = "^3[unique_phone]^0 recado_extras: cleanup (%s)"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = tostring
      L6_2 = L1_2
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2)
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
      L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    end
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L3_2 = pairs
    L4_2 = L11_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L8_2.t
      L9_2 = L2_2 - L9_2
      L10_2 = L9_1
      L10_2 = L10_2 * 4
      if L9_2 > L10_2 then
        L9_2 = L11_1
        L9_2[L7_2] = nil
      end
    end
    L3_2 = Wait
    L4_2 = 600000
    L3_2(L4_2)
  end
end
L57_1(L58_1)
L57_1 = {}
L58_1 = 0
L59_1 = 0
function L60_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "[^%w%-%._~]"
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = "%%%02X"
    L2_3 = L1_3
    L1_3 = L1_3.format
    L4_3 = A0_3
    L3_3 = A0_3.byte
    L3_3, L4_3 = L3_3(L4_3)
    return L1_3(L2_3, L3_3, L4_3)
  end
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L61_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = promise
  L2_2 = L2_2.new
  L2_2 = L2_2()
  L3_2 = false
  L4_2 = PerformHttpRequest
  L5_2 = A0_2
  function L6_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3
    L2_3 = L3_2
    if L2_3 then
      return
    end
    L2_3 = true
    L3_2 = L2_3
    L2_3 = L2_2
    L3_3 = L2_3
    L2_3 = L2_3.resolve
    L4_3 = {}
    L5_3 = tonumber
    L6_3 = A0_3
    L5_3 = L5_3(L6_3)
    if not L5_3 then
      L5_3 = 0
    end
    L4_3.status = L5_3
    L4_3.body = A1_3
    L2_3(L3_3, L4_3)
  end
  L7_2 = "GET"
  L8_2 = ""
  L9_2 = {}
  L9_2.Accept = "application/json"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = SetTimeout
  L5_2 = A1_2 or L5_2
  if not A1_2 then
    L5_2 = 8000
  end
  function L6_2()
    local L0_3, L1_3, L2_3
    L0_3 = L3_2
    if L0_3 then
      return
    end
    L0_3 = true
    L3_2 = L0_3
    L0_3 = L2_2
    L1_3 = L0_3
    L0_3 = L0_3.resolve
    L2_3 = {}
    L2_3.status = 0
    L0_3(L1_3, L2_3)
  end
  L4_2(L5_2, L6_2)
  L4_2 = Citizen
  L4_2 = L4_2.Await
  L5_2 = L2_2
  return L4_2(L5_2)
end
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = pcall
  L3_2 = json
  L3_2 = L3_2.decode
  L4_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = type
      L5_2 = L3_2.results
      L4_2 = L4_2(L5_2)
      if "table" == L4_2 then
        goto lbl_20
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_20::
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2.results
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = type
      L12_2 = L10_2.media_formats
      L11_2 = L11_2(L12_2)
      if "table" == L11_2 then
        L11_2 = L10_2.media_formats
        if L11_2 then
          goto lbl_40
        end
      end
    end
    L11_2 = nil
    ::lbl_40::
    L12_2 = L11_2 or L12_2
    if L11_2 then
      L12_2 = L11_2.gif
      if not L12_2 then
        L12_2 = L11_2.mediumgif
      end
    end
    L13_2 = L11_2 or L13_2
    if L11_2 then
      L13_2 = L11_2.tinygif
      if not L13_2 then
        L13_2 = L11_2.nanogif
        if not L13_2 then
          L13_2 = L12_2
        end
      end
    end
    L14_2 = type
    L15_2 = L12_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = type
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      if "table" == L14_2 then
        L14_2 = type
        L15_2 = L12_2.dims
        L14_2 = L14_2(L15_2)
        if "table" == L14_2 then
          L14_2 = L12_2.dims
          if L14_2 then
            goto lbl_75
          end
        end
        L14_2 = {}
        ::lbl_75::
        L15_2 = RecadoValidGif
        L16_2 = {}
        L17_2 = L12_2.url
        L16_2.url = L17_2
        L17_2 = L13_2.url
        L16_2.preview = L17_2
        L17_2 = L14_2[1]
        L16_2.w = L17_2
        L17_2 = L14_2[2]
        L16_2.h = L17_2
        L15_2 = L15_2(L16_2)
        if L15_2 then
          L16_2 = L15_2.preview
          if L16_2 then
            L16_2 = #L4_2
            L16_2 = L16_2 + 1
            L4_2[L16_2] = L15_2
          end
        end
      end
    end
    L14_2 = #L4_2
    if A1_2 <= L14_2 then
      break
    end
  end
  return L4_2
end
L63_1 = RPC
function L64_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L37_1
  L2_2 = L2_2()
  L3_2 = L38_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "nogif"
    return L4_2
  end
  L4_2 = L21_1
  L5_2 = A1_2.q
  L6_2 = 60
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = ""
  end
  L6_2 = L4_2
  L5_2 = L4_2.lower
  L5_2 = L5_2(L6_2)
  L6_2 = L57_1
  L6_2 = L6_2[L5_2]
  if L6_2 then
    L7_2 = os
    L7_2 = L7_2.time
    L7_2 = L7_2()
    L8_2 = L6_2.t
    L7_2 = L7_2 - L8_2
    L8_2 = 300
    if L7_2 < L8_2 then
      L7_2 = {}
      L8_2 = L6_2.items
      L7_2.items = L8_2
      L8_2 = L2_2.provider
      L7_2.provider = L8_2
      return L7_2
    end
  end
  L7_2 = L59_1
  if L7_2 >= 4 then
    L7_2 = {}
    L7_2.error = "busy"
    return L7_2
  end
  L7_2 = L59_1
  L7_2 = L7_2 + 1
  L59_1 = L7_2
  L7_2 = "https://tenor.googleapis.com/v2/%s?key=%s&client_key=apex_phone&limit=%d&media_filter=gif,tinygif&contentfilter=medium&locale=pt_PT%s"
  L8_2 = L7_2
  L7_2 = L7_2.format
  if "" == L4_2 then
    L9_2 = "featured"
    if L9_2 then
      goto lbl_60
    end
  end
  L9_2 = "search"
  ::lbl_60::
  L10_2 = L60_1
  L11_2 = L3_2
  L10_2 = L10_2(L11_2)
  L11_2 = L2_2.limit
  if "" ~= L4_2 then
    L12_2 = "&q="
    L13_2 = L60_1
    L14_2 = L4_2
    L13_2 = L13_2(L14_2)
    L12_2 = L12_2 .. L13_2
    if L12_2 then
      goto lbl_74
    end
  end
  L12_2 = ""
  ::lbl_74::
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L8_2 = pcall
  L9_2 = L61_1
  L10_2 = L7_2
  L11_2 = 8000
  L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
  L10_2 = L59_1
  L10_2 = L10_2 - 1
  L59_1 = L10_2
  if L8_2 then
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L9_2.status
      if 200 == L10_2 then
        L10_2 = type
        L11_2 = L9_2.body
        L10_2 = L10_2(L11_2)
        if "string" == L10_2 then
          L10_2 = L9_2.body
          L10_2 = #L10_2
          L11_2 = 3000000
          if not (L10_2 > L11_2) then
            goto lbl_124
          end
        end
      end
    end
  end
  L10_2 = L13_1
  L11_2 = "gif: provider replied %s"
  if L8_2 then
    L12_2 = type
    L13_2 = L9_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = tostring
      L13_2 = L9_2.status
      L12_2 = L12_2(L13_2)
      if L12_2 then
        goto lbl_119
      end
    end
  end
  L12_2 = "error"
  ::lbl_119::
  L10_2(L11_2, L12_2)
  L10_2 = {}
  L10_2.error = "gifdown"
  do return L10_2 end
  ::lbl_124::
  L10_2 = L62_1
  L11_2 = L9_2.body
  L12_2 = L2_2.limit
  L10_2 = L10_2(L11_2, L12_2)
  if not L10_2 then
    L11_2 = {}
    L11_2.error = "gifdown"
    return L11_2
  end
  L11_2 = L57_1
  L11_2 = L11_2[L5_2]
  if not L11_2 then
    L11_2 = L58_1
    L11_2 = L11_2 + 1
    L58_1 = L11_2
  end
  L11_2 = L57_1
  L12_2 = {}
  L13_2 = os
  L13_2 = L13_2.time
  L13_2 = L13_2()
  L12_2.t = L13_2
  L12_2.items = L10_2
  L11_2[L5_2] = L12_2
  L11_2 = L58_1
  L12_2 = 200
  if L11_2 > L12_2 then
    L11_2 = {}
    L12_2 = L57_1
    L12_2 = L12_2[L5_2]
    L11_2[L5_2] = L12_2
    L12_2 = 1
    L58_1 = L12_2
    L57_1 = L11_2
  end
  L11_2 = {}
  L11_2.items = L10_2
  L12_2 = L2_2.provider
  L11_2.provider = L12_2
  return L11_2
end
L63_1["recado.gif.search"] = L64_1
L63_1 = RPC
function L64_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L28_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L21_1
  L5_2 = A1_2.title
  L6_2 = L1_1
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "title"
    return L5_2
  end
  L5_2 = type
  L6_2 = A1_2.body
  L5_2 = L5_2(L6_2)
  if "string" ~= L5_2 then
    L5_2 = {}
    L5_2.error = "body"
    return L5_2
  end
  L5_2 = utf8
  L5_2 = L5_2.len
  L6_2 = A1_2.body
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L5_2 = utf8
    L5_2 = L5_2.len
    L6_2 = A1_2.body
    L5_2 = L5_2(L6_2)
    L6_2 = L2_1
    if L5_2 > L6_2 then
      L5_2 = {}
      L5_2.error = "toolarge"
      L6_2 = L2_1
      L5_2.max = L6_2
      return L5_2
    end
  end
  L5_2 = L22_1
  L6_2 = A1_2.body
  L7_2 = L2_1
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "body"
    return L6_2
  end
  L6_2 = L29_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = "document"
  L10_2 = L4_2
  L11_2 = {}
  L11_2.title = L4_2
  L11_2.body = L5_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  if not L6_2 then
    L8_2 = {}
    L8_2.error = L7_2
    return L8_2
  end
  return L6_2
end
L63_1["recado.doc.share"] = L64_1
L63_1 = ipairs
L64_1 = {}
L65_1 = "recado.extras.config"
L66_1 = "recado.poll.create"
L67_1 = "recado.poll.vote"
L68_1 = "recado.poll.get"
L69_1 = "recado.event.create"
L70_1 = "recado.event.rsvp"
L71_1 = "recado.event.get"
L72_1 = "recado.event.cancel"
L73_1 = "recado.gif.search"
L74_1 = "recado.doc.share"
L64_1[1] = L65_1
L64_1[2] = L66_1
L64_1[3] = L67_1
L64_1[4] = L68_1
L64_1[5] = L69_1
L64_1[6] = L70_1
L64_1[7] = L71_1
L64_1[8] = L72_1
L64_1[9] = L73_1
L64_1[10] = L74_1
L63_1, L64_1, L65_1, L66_1 = L63_1(L64_1)
for L67_1, L68_1 in L63_1, L64_1, L65_1, L66_1 do
  L69_1 = RPC
  L69_1 = L69_1[L68_1]
  L70_1 = type
  L71_1 = L69_1
  L70_1 = L70_1(L71_1)
  if "function" == L70_1 then
    L70_1 = RPC
    function L71_1(A0_2, A1_2)
      local L2_2, L3_2, L4_2, L5_2
      L2_2 = L15_1
      L2_2 = L2_2()
      L2_2 = L2_2.enabled
      if false == L2_2 then
        L2_2 = {}
        L2_2.error = "disabled"
        return L2_2
      end
      L2_2 = L69_1
      L3_2 = A0_2
      L4_2 = type
      L5_2 = A1_2
      L4_2 = L4_2(L5_2)
      L4_2 = A1_2 or L4_2
      if "table" ~= L4_2 or not A1_2 then
        L4_2 = {}
      end
      return L2_2(L3_2, L4_2)
    end
    L70_1[L68_1] = L71_1
  end
end
