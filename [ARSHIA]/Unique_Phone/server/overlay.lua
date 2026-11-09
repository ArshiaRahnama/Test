local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1
L0_1 = {}
OVRPC = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2 or A0_2
  if not L1_2 then
    A0_2 = 0
  end
  if 0 == A0_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = type
  L2_2 = Config
  L2_2 = L2_2.Admin
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = Config
    L1_2 = L1_2.Admin
    L1_2 = L1_2.ace
    if L1_2 then
      goto lbl_23
    end
  end
  L1_2 = "apex_phone.admin"
  ::lbl_23::
  L2_2 = IsPlayerAceAllowed
  L3_2 = A0_2
  L4_2 = L1_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = FW
  L2_2 = L2_2.IsAdmin
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = true == L2_2
  return L2_2
end
IsPhoneAdmin = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2 or A0_2
  if not L1_2 then
    A0_2 = 0
  end
  if 0 == A0_2 then
    L1_2 = "consola"
    return L1_2
  end
  L1_2 = pcall
  L2_2 = FW
  L2_2 = L2_2.GetName
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 and "" ~= L2_2 and L2_2 then
      goto lbl_35
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = GetPlayerName
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = "#"
    L4_2 = A0_2
    L3_2 = L3_2 .. L4_2
  end
  ::lbl_35::
  return L3_2
end
AdminName = L0_1
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2 or A0_2
  if not L1_2 then
    A0_2 = 0
  end
  if 0 == A0_2 then
    L1_2 = "console"
    return L1_2
  end
  L1_2 = ipairs
  L2_2 = GetPlayerIdentifiers
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L8_2 = L6_2
    L7_2 = L6_2.sub
    L9_2 = 1
    L10_2 = 8
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    if "license:" == L7_2 then
      return L6_2
    end
  end
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = "src:"
    L2_2 = A0_2
    L1_2 = L1_2 .. L2_2
  end
  return L1_2
end
L2_1 = {}
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L2_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = L2_2.t
    L3_2 = L1_2 - L3_2
    L4_2 = 1000
    if not (L3_2 > L4_2) then
      goto lbl_21
    end
  end
  L3_2 = L2_1
  L4_2 = {}
  L4_2.t = L1_2
  L4_2.n = 1
  L3_2[A0_2] = L4_2
  L3_2 = true
  do return L3_2 end
  ::lbl_21::
  L3_2 = L2_2.n
  L3_2 = L3_2 + 1
  L2_2.n = L3_2
  L3_2 = L2_2.n
  L3_2 = L3_2 <= 25
  return L3_2
end
L4_1 = RegisterNetEvent
L5_1 = "apex_phone:server:ov"
function L6_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = source
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "number" == L4_2 then
    L4_2 = type
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 then
      L4_2 = #A1_2
      if not (L4_2 > 64) then
        goto lbl_16
      end
    end
  end
  do return end
  ::lbl_16::
  L4_2 = nil
  L5_2 = OVRPC
  L5_2 = L5_2[A1_2]
  L6_2 = L3_1
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "ratelimit"
    L4_2 = L6_2
  elseif not L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "unknown"
    L4_2 = L6_2
  else
    L7_2 = A1_2
    L6_2 = A1_2.sub
    L8_2 = 1
    L9_2 = 6
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if "admin." == L6_2 then
      L6_2 = IsPhoneAdmin
      L7_2 = L3_2
      L6_2 = L6_2(L7_2)
      if not L6_2 then
        L6_2 = {}
        L6_2.ok = false
        L6_2.error = "forbidden"
        L4_2 = L6_2
    end
    else
      L6_2 = pcall
      L7_2 = L5_2
      L8_2 = L3_2
      L9_2 = type
      L10_2 = A2_2
      L9_2 = L9_2(L10_2)
      L9_2 = A2_2 or L9_2
      if "table" ~= L9_2 or not A2_2 then
        L9_2 = {}
      end
      L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
      if L6_2 then
        L8_2 = type
        L9_2 = L7_2
        L8_2 = L8_2(L9_2)
        if "table" == L8_2 then
          L4_2 = L7_2
      end
      else
        L8_2 = print
        L9_2 = "^1[unique_phone]^0 request %s from %d crashed: %s"
        L10_2 = L9_2
        L9_2 = L9_2.format
        L11_2 = A1_2
        L12_2 = L3_2
        L13_2 = tostring
        L14_2 = L7_2
        L13_2, L14_2 = L13_2(L14_2)
        L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
        L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
        L8_2 = {}
        L8_2.ok = false
        L8_2.error = "server"
        L4_2 = L8_2
      end
    end
  end
  L6_2 = TriggerClientEvent
  L7_2 = "apex_phone:client:ov"
  L8_2 = L3_2
  L9_2 = A0_2
  L10_2 = L4_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
end
L4_1(L5_1, L6_1)
L4_1 = AddEventHandler
L5_1 = "playerDropped"
function L6_1()
  local L0_2, L1_2
  L1_2 = source
  L0_2 = L2_1
  L0_2[L1_2] = nil
end
L4_1(L5_1, L6_1)
L4_1 = {}
L5_1 = {}
L4_1.data = L5_1
L4_1.ready = false
AdminStore = L4_1
L4_1 = {}
L5_1 = {}
L6_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_admin` (`k` VARCHAR(64) NOT NULL, `v` LONGTEXT NOT NULL, `updated` BIGINT NOT NULL, `by_name` VARCHAR(100) NULL, PRIMARY KEY (`k`))"
L7_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_admin_log` (`id` BIGINT NOT NULL AUTO_INCREMENT, `at` BIGINT NOT NULL, `admin` VARCHAR(100) NULL, `ident` VARCHAR(80) NULL, `action` VARCHAR(64) NOT NULL, `detail` VARCHAR(600) NULL, PRIMARY KEY (`id`), KEY `at` (`at`))"
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = ipairs
  L2_2 = L4_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = pcall
    L8_2 = L6_2
    L9_2 = AdminStore
    L9_2 = L9_2.data
    L9_2 = L9_2[A0_2]
    L7_2, L8_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L9_2 = print
      L10_2 = "^1[unique_phone]^0 AdminStore %s: %s"
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = A0_2
      L13_2 = tostring
      L14_2 = L8_2
      L13_2, L14_2 = L13_2(L14_2)
      L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
end
L9_1 = AdminStore
function L10_1(A0_2)
  local L1_2
  L1_2 = AdminStore
  L1_2 = L1_2.data
  L1_2 = L1_2[A0_2]
  return L1_2
end
L9_1.Get = L10_1
L9_1 = AdminStore
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 or "" == A0_2 then
    L3_2 = false
    return L3_2
  end
  if nil ~= A1_2 then
    L3_2 = type
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if "table" ~= L3_2 then
      L3_2 = false
      return L3_2
    end
  end
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = A1_2
    if nil == L0_3 then
      L0_3 = MySQL
      L0_3 = L0_3.update
      L0_3 = L0_3.await
      L1_3 = "DELETE FROM apex_phone_admin WHERE k = ?"
      L2_3 = {}
      L3_3 = A0_2
      L2_3[1] = L3_3
      L0_3(L1_3, L2_3)
    else
      L0_3 = MySQL
      L0_3 = L0_3.update
      L0_3 = L0_3.await
      L1_3 = "INSERT INTO apex_phone_admin (k, v, updated, by_name) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE v = VALUES(v), updated = VALUES(updated), by_name = VALUES(by_name)"
      L2_3 = {}
      L3_3 = A0_2
      L4_3 = json
      L4_3 = L4_3.encode
      L5_3 = A1_2
      L4_3 = L4_3(L5_3)
      L5_3 = os
      L5_3 = L5_3.time
      L5_3 = L5_3()
      L5_3 = L5_3 * 1000
      L6_3 = L0_1
      L7_3 = A2_2
      L6_3, L7_3 = L6_3(L7_3)
      L2_3[1] = L3_3
      L2_3[2] = L4_3
      L2_3[3] = L5_3
      L2_3[4] = L6_3
      L2_3[5] = L7_3
      L0_3(L1_3, L2_3)
    end
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = AdminStore
  L4_2 = L4_2.data
  L4_2[A0_2] = A1_2
  L4_2 = L8_1
  L5_2 = A0_2
  L4_2(L5_2)
  L4_2 = true
  return L4_2
end
L9_1.Set = L10_1
L9_1 = AdminStore
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L4_1
  L3_2 = L4_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = {}
  end
  L2_2[A0_2] = L3_2
  L2_2 = L4_1
  L2_2 = L2_2[A0_2]
  L3_2 = L4_1
  L3_2 = L3_2[A0_2]
  L3_2 = #L3_2
  L3_2 = L3_2 + 1
  L2_2[L3_2] = A1_2
  L2_2 = AdminStore
  L2_2 = L2_2.ready
  if L2_2 then
    L2_2 = pcall
    L3_2 = A1_2
    L4_2 = AdminStore
    L4_2 = L4_2.data
    L4_2 = L4_2[A0_2]
    L2_2(L3_2, L4_2)
  end
end
L9_1.OnChange = L10_1
L9_1 = AdminStore
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = AdminStore
  L1_2 = L1_2.ready
  if L1_2 then
    L1_2 = pcall
    L2_2 = A0_2
    L1_2(L2_2)
  else
    L1_2 = L5_1
    L1_2 = #L1_2
    L2_2 = L1_2 + 1
    L1_2 = L5_1
    L1_2[L2_2] = A0_2
  end
end
L9_1.OnReady = L10_1
L9_1 = AdminStore
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = A2_2
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = json
    L4_2 = L4_2.encode
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
  end
  if L3_2 then
    L4_2 = tostring
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L5_2 = L4_2
    L4_2 = L4_2.sub
    L6_2 = 1
    L7_2 = 600
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_24
      L3_2 = L4_2 or L3_2
    end
  end
  L3_2 = nil
  ::lbl_24::
  L4_2 = L0_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = L1_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L6_2 = CreateThread
  function L7_2()
    local L0_3, L1_3
    L0_3 = pcall
    function L1_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4
      L0_4 = MySQL
      L0_4 = L0_4.insert
      L0_4 = L0_4.await
      L1_4 = "INSERT INTO apex_phone_admin_log (at, admin, ident, action, detail) VALUES (?, ?, ?, ?, ?)"
      L2_4 = {}
      L3_4 = os
      L3_4 = L3_4.time
      L3_4 = L3_4()
      L3_4 = L3_4 * 1000
      L4_4 = L4_2
      L5_4 = L5_2
      L6_4 = tostring
      L7_4 = A1_2
      L6_4 = L6_4(L7_4)
      L7_4 = L6_4
      L6_4 = L6_4.sub
      L8_4 = 1
      L9_4 = 64
      L6_4 = L6_4(L7_4, L8_4, L9_4)
      L7_4 = L3_2
      L2_4[1] = L3_4
      L2_4[2] = L4_4
      L2_4[3] = L5_4
      L2_4[4] = L6_4
      L2_4[5] = L7_4
      L0_4(L1_4, L2_4)
    end
    L0_3(L1_3)
  end
  L6_2(L7_2)
  L6_2 = AdminStore
  L6_2 = L6_2.data
  L6_2 = L6_2.webhooks
  L7_2 = type
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = type
    L8_2 = L6_2.admin
    L7_2 = L7_2(L8_2)
    if "string" == L7_2 then
      L7_2 = L6_2.admin
      if "" ~= L7_2 then
        L7_2 = PostWebhook
        L8_2 = L6_2.admin
        L9_2 = {}
        L10_2 = {}
        L11_2 = WebhookEmbed
        L12_2 = {}
        L13_2 = "Painel admin \194\183 "
        L14_2 = tostring
        L15_2 = A1_2
        L14_2 = L14_2(L15_2)
        L13_2 = L13_2 .. L14_2
        L12_2.title = L13_2
        L12_2.description = L3_2
        L12_2.color = "#1F5EFF"
        L12_2.footer = L4_2
        L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
        L10_2[1] = L11_2
        L10_2[2] = L12_2
        L10_2[3] = L13_2
        L10_2[4] = L14_2
        L10_2[5] = L15_2
        L9_2.embeds = L10_2
        L7_2(L8_2, L9_2)
      end
    end
  end
end
L9_1.Log = L10_1
L9_1 = CreateThread
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L6_1
    L0_3(L1_3)
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L7_1
    L0_3(L1_3)
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT k, v FROM apex_phone_admin"
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = ipairs
    L2_3 = L0_3
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = pcall
      L8_3 = json
      L8_3 = L8_3.decode
      L9_3 = L6_3.v
      L7_3, L8_3 = L7_3(L8_3, L9_3)
      if L7_3 then
        L9_3 = type
        L10_3 = L8_3
        L9_3 = L9_3(L10_3)
        if "table" == L9_3 then
          L9_3 = AdminStore
          L9_3 = L9_3.data
          L10_3 = L6_3.k
          L9_3[L10_3] = L8_3
        end
      end
    end
    L1_3 = math
    L1_3 = L1_3.max
    L2_3 = 100
    L3_3 = math
    L3_3 = L3_3.floor
    L4_3 = tonumber
    L5_3 = type
    L6_3 = Config
    L6_3 = L6_3.Admin
    L5_3 = L5_3(L6_3)
    L5_3 = Config
    L5_3 = L5_3.Admin
    L5_3 = "table" == L5_3 and L5_3
    L4_3 = L4_3(L5_3)
    if not L4_3 then
      L4_3 = 2000
    end
    L3_3 = L3_3(L4_3)
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = MySQL
    L2_3 = L2_3.update
    L2_3 = L2_3.await
    L3_3 = "DELETE FROM apex_phone_admin_log WHERE id < (SELECT m FROM (SELECT COALESCE(MAX(id), 0) - ? AS m FROM apex_phone_admin_log) t)"
    L4_3 = {}
    L5_3 = L1_3
    L4_3[1] = L5_3
    L2_3(L3_3, L4_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 admin panel: %s"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
  L2_2 = AdminStore
  L2_2.ready = true
  L2_2 = pairs
  L3_2 = L4_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = L8_1
    L8_2 = L6_2
    L7_2(L8_2)
  end
  L2_2 = ipairs
  L3_2 = L5_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = pcall
    L9_2 = L7_2
    L8_2(L9_2)
  end
  L2_2 = {}
  L5_1 = L2_2
end
L9_1(L10_1)
L9_1 = {}
L10_1 = {}
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L1_2 = math
    L1_2 = L1_2.floor
    L2_2 = A0_2
    return L1_2(L2_2)
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.match
    L3_2 = "^#?(%x%x%x%x%x%x)$"
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      L2_2 = tonumber
      L3_2 = L1_2
      L4_2 = 16
      return L2_2(L3_2, L4_2)
    end
  end
  L1_2 = 2055935
  return L1_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not A0_2 then
    L1_2 = {}
    A0_2 = L1_2
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = type
  L4_2 = A0_2.fields
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.fields
    if L3_2 then
      goto lbl_24
    end
  end
  L3_2 = {}
  ::lbl_24::
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    if L6_2 > 20 then
      break
    end
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2.name
      if L8_2 then
        L8_2 = L7_2.value
        if L8_2 then
          L8_2 = tostring
          L9_2 = L7_2.value
          L8_2 = L8_2(L9_2)
          if "" ~= L8_2 then
            L8_2 = #L1_2
            L8_2 = L8_2 + 1
            L9_2 = {}
            L10_2 = tostring
            L11_2 = L7_2.name
            L10_2 = L10_2(L11_2)
            L11_2 = L10_2
            L10_2 = L10_2.sub
            L12_2 = 1
            L13_2 = 250
            L10_2 = L10_2(L11_2, L12_2, L13_2)
            L9_2.name = L10_2
            L10_2 = tostring
            L11_2 = L7_2.value
            L10_2 = L10_2(L11_2)
            L11_2 = L10_2
            L10_2 = L10_2.sub
            L12_2 = 1
            L13_2 = 1000
            L10_2 = L10_2(L11_2, L12_2, L13_2)
            L9_2.value = L10_2
            L10_2 = L7_2.inline
            L10_2 = true == L10_2
            L9_2.inline = L10_2
            L1_2[L8_2] = L9_2
          end
        end
      end
    end
  end
  L2_2 = {}
  L3_2 = A0_2.title
  if L3_2 then
    L3_2 = tostring
    L4_2 = A0_2.title
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 250
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_90
    end
  end
  L3_2 = nil
  ::lbl_90::
  L2_2.title = L3_2
  L3_2 = A0_2.description
  if L3_2 then
    L3_2 = tostring
    L4_2 = A0_2.description
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 3800
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_104
    end
  end
  L3_2 = nil
  ::lbl_104::
  L2_2.description = L3_2
  L3_2 = type
  L4_2 = A0_2.url
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.url
    if L3_2 then
      goto lbl_114
    end
  end
  L3_2 = nil
  ::lbl_114::
  L2_2.url = L3_2
  L3_2 = L11_1
  L4_2 = A0_2.color
  L3_2 = L3_2(L4_2)
  L2_2.color = L3_2
  L3_2 = #L1_2
  L3_2 = L1_2 or L3_2
  if not (L3_2 > 0) or not L1_2 then
    L3_2 = nil
  end
  L2_2.fields = L3_2
  L3_2 = A0_2.footer
  if L3_2 then
    L3_2 = {}
    L4_2 = tostring
    L5_2 = A0_2.footer
    L4_2 = L4_2(L5_2)
    L5_2 = L4_2
    L4_2 = L4_2.sub
    L6_2 = 1
    L7_2 = 200
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2.text = L4_2
    if L3_2 then
      goto lbl_142
    end
  end
  L3_2 = nil
  ::lbl_142::
  L2_2.footer = L3_2
  L3_2 = os
  L3_2 = L3_2.date
  L4_2 = "!%Y-%m-%dT%H:%M:%SZ"
  L3_2 = L3_2(L4_2)
  L2_2.timestamp = L3_2
  return L2_2
end
WebhookEmbed = L12_1
function L12_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
ValidWebhookUrl = L12_1
function L12_1(A0_2)
  local L1_2, L2_2
  L1_2 = L10_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return
  end
  L1_2 = L10_1
  L1_2[A0_2] = true
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    while true do
      L1_3 = A0_2
      L0_3 = L9_1
      L0_3 = L0_3[L1_3]
      if not L0_3 then
        break
      end
      L1_3 = A0_2
      L0_3 = L9_1
      L0_3 = L0_3[L1_3]
      L0_3 = #L0_3
      if not (L0_3 > 0) then
        break
      end
      L0_3 = table
      L0_3 = L0_3.remove
      L2_3 = A0_2
      L1_3 = L9_1
      L1_3 = L1_3[L2_3]
      L2_3 = 1
      L0_3 = L0_3(L1_3, L2_3)
      L1_3 = PerformHttpRequest
      L2_3 = A0_2
      function L3_3(A0_4)
        local L1_4, L2_4, L3_4, L4_4
        if A0_4 then
          L1_4 = 400
          if A0_4 >= L1_4 and 429 ~= A0_4 then
            L1_4 = print
            L2_4 = "^3[unique_phone]^0 webhook responded %d"
            L3_4 = L2_4
            L2_4 = L2_4.format
            L4_4 = A0_4
            L2_4, L3_4, L4_4 = L2_4(L3_4, L4_4)
            L1_4(L2_4, L3_4, L4_4)
          end
        end
      end
      L4_3 = "POST"
      L5_3 = L0_3
      L6_3 = {}
      L6_3["Content-Type"] = "application/json"
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
      L1_3 = Wait
      L2_3 = 450
      L1_3(L2_3)
    end
    L1_3 = A0_2
    L0_3 = L9_1
    L0_3[L1_3] = nil
    L1_3 = A0_2
    L0_3 = L10_1
    L0_3[L1_3] = nil
  end
  L1_2(L2_2)
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = ValidWebhookUrl
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      goto lbl_13
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_13::
  L2_2 = A1_2.username
  if nil == L2_2 then
    A1_2.username = "Apex Phone"
  end
  L2_2 = L9_1
  L3_2 = L9_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = {}
  end
  L2_2[A0_2] = L3_2
  L2_2 = L9_1
  L2_2 = L2_2[A0_2]
  L2_2 = #L2_2
  if L2_2 >= 30 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L9_1
  L2_2 = L2_2[A0_2]
  L3_2 = L9_1
  L3_2 = L3_2[A0_2]
  L3_2 = #L3_2
  L3_2 = L3_2 + 1
  L4_2 = json
  L4_2 = L4_2.encode
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  L2_2[L3_2] = L4_2
  L2_2 = L12_1
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = true
  return L2_2
end
PostWebhook = L13_1
L13_1 = "phonenotify"
L14_1 = RegisterCommand
L15_1 = L13_1
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  if 0 ~= A0_2 then
    L3_2 = IsPhoneAdmin
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      return
    end
  end
  L3_2 = tostring
  L4_2 = A2_2 or L4_2
  if not A2_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "^%s*/?"
  L6_2 = L13_1
  L7_2 = "%s*"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L5_2 = L3_2
  L4_2 = L3_2.match
  L6_2 = "^(%S+)%s+(%S+)%s+(.+)$"
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L7_2 = nil
  L8_2 = nil
  if L6_2 then
    L10_2 = L6_2
    L9_2 = L6_2.match
    L11_2 = "^(.-)%s*|%s*(.*)$"
    L9_2, L10_2 = L9_2(L10_2, L11_2)
    L8_2 = L10_2
    L7_2 = L9_2
    if not L7_2 then
      L9_2 = L6_2
      L8_2 = ""
      L7_2 = L9_2
    end
  else
    L9_2 = "me"
    L10_2 = "mail"
    L11_2 = "Apex Mobile"
    L8_2 = "Welcome! Your account is active."
    L7_2 = L11_2
    L5_2 = L10_2
    L4_2 = L9_2
    L10_2 = L3_2
    L9_2 = L3_2.match
    L11_2 = "^%S+$"
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L4_2 = L3_2
    end
  end
  L9_2 = tostring
  L10_2 = L5_2
  L9_2 = L9_2(L10_2)
  L10_2 = L9_2
  L9_2 = L9_2.lower
  L9_2 = L9_2(L10_2)
  L10_2 = L9_2
  L9_2 = L9_2.gsub
  L11_2 = "[^%w_%.%-]"
  L12_2 = ""
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L5_2 = L9_2
  L9_2 = tostring
  L10_2 = L7_2 or L10_2
  if not L7_2 then
    L10_2 = ""
  end
  L9_2 = L9_2(L10_2)
  L10_2 = L9_2
  L9_2 = L9_2.sub
  L11_2 = 1
  L12_2 = 120
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L7_2 = L9_2
  L9_2 = tostring
  L10_2 = L8_2 or L10_2
  if not L8_2 then
    L10_2 = ""
  end
  L9_2 = L9_2(L10_2)
  L10_2 = L9_2
  L9_2 = L9_2.sub
  L11_2 = 1
  L12_2 = 400
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L8_2 = L9_2
  if "" == L7_2 then
    L7_2 = "Apex Mobile"
  end
  L9_2 = {}
  if "all" == L4_2 then
    L10_2 = ipairs
    L11_2 = GetPlayers
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L11_2()
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = #L9_2
      L16_2 = L16_2 + 1
      L17_2 = tonumber
      L18_2 = L15_2
      L17_2 = L17_2(L18_2)
      L9_2[L16_2] = L17_2
    end
  elseif "me" == L4_2 or nil == L4_2 then
    if 0 == A0_2 then
      L10_2 = print
      L11_2 = "[unique_phone] /"
      L12_2 = L13_1
      L13_2 = " from the console: provide the player id (or all)"
      L11_2 = L11_2 .. L12_2 .. L13_2
      L10_2(L11_2)
      return
    end
    L9_2[1] = A0_2
  else
    L10_2 = tonumber
    L11_2 = L4_2
    L10_2 = L10_2(L11_2)
    if L10_2 then
      L11_2 = GetPlayerName
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if L11_2 then
        goto lbl_147
      end
    end
    if 0 == A0_2 then
      L11_2 = print
      L12_2 = "[unique_phone] player "
      L13_2 = tostring
      L14_2 = L4_2
      L13_2 = L13_2(L14_2)
      L14_2 = " is not connected"
      L12_2 = L12_2 .. L13_2 .. L14_2
      L11_2(L12_2)
    else
      L11_2 = FW
      L11_2 = L11_2.Notify
      L12_2 = A0_2
      L13_2 = "Esse jogador n\195\163o est\195\161 ligado."
      L14_2 = "error"
      L11_2(L12_2, L13_2, L14_2)
    end
    do return end
    ::lbl_147::
    L9_2[1] = L10_2
  end
  L10_2 = ipairs
  L11_2 = L9_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = NotifyPlayer
    L17_2 = L15_2
    L18_2 = L5_2
    L19_2 = L7_2
    L20_2 = L8_2
    L16_2(L17_2, L18_2, L19_2, L20_2)
  end
  L10_2 = "notification \"%s\" (%s) sent to %d player(s)"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = L7_2
  L13_2 = L5_2
  L14_2 = #L9_2
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  if 0 == A0_2 then
    L11_2 = print
    L12_2 = "[unique_phone] "
    L13_2 = L10_2
    L12_2 = L12_2 .. L13_2
    L11_2(L12_2)
  else
    L11_2 = print
    L12_2 = "[unique_phone] %s: %s"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = AdminName
    L15_2 = A0_2
    L14_2 = L14_2(L15_2)
    L15_2 = L10_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2, L14_2, L15_2)
    L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  end
end
L17_1 = false
L14_1(L15_1, L16_1, L17_1)
L14_1 = CreateThread
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = Wait
  L1_2 = 2000
  L0_2(L1_2)
  L0_2 = TriggerClientEvent
  L1_2 = "chat:addSuggestion"
  L2_2 = -1
  L3_2 = "/"
  L4_2 = L13_1
  L3_2 = L3_2 .. L4_2
  L4_2 = "For\195\167ar uma notifica\195\167\195\163o no telem\195\179vel (admin)"
  L5_2 = {}
  L6_2 = {}
  L6_2.name = "quem"
  L6_2.help = "me, id do jogador ou all"
  L7_2 = {}
  L7_2.name = "app"
  L7_2.help = "mail, messages, recado, eats, instashot..."
  L8_2 = {}
  L8_2.name = "texto"
  L8_2.help = "T\195\173tulo | Mensagem"
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
end
L14_1(L15_1)
