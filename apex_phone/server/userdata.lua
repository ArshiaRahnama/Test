local L0_1, L1_1, L2_1, L3_1, L4_1
L0_1 = {}
L0_1.notes = true
L0_1.reminders = true
L0_1.events = true
L0_1.alarms = true
L0_1.cities = true
L0_1.places = true
L0_1.arcade = true
L0_1.arcadeOpt = true
L0_1.usage = true
function L1_1()
  local L0_2, L1_2, L2_2
  L0_2 = tonumber
  L1_2 = Config
  L1_2 = L1_2.UserDataMaxBytes
  L0_2 = L0_2(L1_2)
  if not L0_2 or L0_2 <= 0 then
    L1_2 = 300000
    return L1_2
  end
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = L0_2
  return L1_2(L2_2)
end
L2_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_userdata` (`owner` VARCHAR(64) NOT NULL, `k` VARCHAR(32) NOT NULL, `v` LONGTEXT NULL, `updated` BIGINT NOT NULL, PRIMARY KEY (`owner`,`k`))"
L3_1 = CreateThread
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L2_1
    L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 apex_phone_userdata: %s"
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
    L4_2 = L2_1
    L2_2(L3_2, L4_2)
  end
end
L3_1(L4_1)
L3_1 = RPC
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
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
  L3_2 = "SELECT k, v FROM apex_phone_userdata WHERE owner = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L11_2 = L9_2.k
    L10_2 = L0_1
    L10_2 = L10_2[L11_2]
    if L10_2 then
      L10_2 = type
      L11_2 = L9_2.v
      L10_2 = L10_2(L11_2)
      if "string" == L10_2 then
        L10_2 = L9_2.k
        L11_2 = L9_2.v
        L3_2[L10_2] = L11_2
      end
    end
  end
  L4_2 = {}
  L4_2.items = L3_2
  L5_2 = L1_1
  L5_2 = L5_2()
  L4_2.max = L5_2
  return L4_2
end
L3_1["userdata.get"] = L4_1
L3_1 = RPC
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2.k
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.k
    if L3_2 then
      goto lbl_19
    end
  end
  L3_2 = nil
  ::lbl_19::
  if L3_2 then
    L4_2 = L0_1
    L4_2 = L4_2[L3_2]
    if L4_2 then
      goto lbl_29
    end
  end
  L4_2 = {}
  L4_2.error = "key"
  do return L4_2 end
  ::lbl_29::
  L4_2 = A1_2.v
  if nil == L4_2 or false == L4_2 then
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "DELETE FROM apex_phone_userdata WHERE owner = ? AND k = ?"
    L7_2 = {}
    L8_2 = L2_2
    L9_2 = L3_2
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L5_2(L6_2, L7_2)
    L5_2 = {}
    L5_2.ok = true
    return L5_2
  end
  L5_2 = type
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if "string" ~= L5_2 then
    L5_2 = {}
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = #L4_2
  L6_2 = L1_1
  L6_2 = L6_2()
  if L5_2 > L6_2 then
    L5_2 = {}
    L5_2.error = "toolarge"
    L6_2 = L1_1
    L6_2 = L6_2()
    L5_2.max = L6_2
    return L5_2
  end
  L5_2 = pcall
  L6_2 = json
  L6_2 = L6_2.decode
  L7_2 = L4_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "INSERT INTO apex_phone_userdata (owner, k, v, updated) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE v = VALUES(v), updated = VALUES(updated)"
  L8_2 = {}
  L9_2 = L2_2
  L10_2 = L3_2
  L11_2 = L4_2
  L12_2 = Now
  L12_2 = L12_2()
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L6_2(L7_2, L8_2)
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L3_1["userdata.set"] = L4_1
