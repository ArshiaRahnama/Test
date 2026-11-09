local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1
L0_1 = "scbak_"
L1_1 = {}
L1_1.notes = "[]"
L1_1.reminders = "[]"
L1_1.events = "[]"
L1_1.alarms = "[]"
L1_1.cities = "[\"Lisboa\",\"Los Santos\"]"
L1_1.places = "[]"
L1_1.arcade = "{}"
L2_1 = "{\"v\":4,\"songs\":{},\"seeded\":true,\"likes\":[],\"lib\":[],\"recents\":[],\"queue\":[],\"playlists\":[]}"
function L3_1(A0_2)
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
function L4_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  L7_2 = pairs
  L8_2 = A2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L4_2
    L13_2 = L13_2 + 1
    L14_2 = "`"
    L15_2 = L11_2
    L16_2 = "`"
    L14_2 = L14_2 .. L15_2 .. L16_2
    L4_2[L13_2] = L14_2
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L5_2[L13_2] = "?"
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L14_2 = type
    L15_2 = L12_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = json
      L14_2 = L14_2.encode
      L15_2 = L12_2
      L14_2 = L14_2(L15_2)
      if L14_2 then
        goto lbl_38
      end
    end
    L14_2 = L12_2
    ::lbl_38::
    L6_2[L13_2] = L14_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.insert
  L7_2 = L7_2.await
  L8_2 = "INSERT INTO `%s` (%s) VALUES (%s)"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = A1_2
  L11_2 = table
  L11_2 = L11_2.concat
  L12_2 = L4_2
  L13_2 = ","
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = table
  L12_2 = L12_2.concat
  L13_2 = L5_2
  L14_2 = ","
  L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L12_2(L13_2, L14_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L9_2 = L6_2
  L7_2(L8_2, L9_2)
  L7_2 = {}
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = A3_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = #L7_2
    L15_2 = L15_2 + 1
    L16_2 = "`%s` = ?"
    L17_2 = L16_2
    L16_2 = L16_2.format
    L18_2 = L14_2
    L16_2 = L16_2(L17_2, L18_2)
    L7_2[L15_2] = L16_2
    L15_2 = #L8_2
    L15_2 = L15_2 + 1
    L16_2 = A2_2[L14_2]
    L8_2[L15_2] = L16_2
  end
  L9_2 = A0_2.track
  L10_2 = A1_2
  L11_2 = table
  L11_2 = L11_2.concat
  L12_2 = L7_2
  L13_2 = " AND "
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = L8_2
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = A0_2.count
  L9_2 = L9_2 + 1
  A0_2.count = L9_2
end
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.scalar
  L2_2 = L2_2.await
  L3_2 = "SELECT 1 FROM apex_phone_userdata WHERE owner = ? AND k = ?"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = L0_1
  L7_2 = A1_2
  L6_2 = L6_2 .. L7_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  L2_2 = nil ~= L2_2
  return L2_2
end
function L6_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L5_1
  L4_2 = A0_2.cid
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    return
  end
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO apex_phone_userdata (owner, k, v, updated) VALUES (?, ?, ?, ?)"
  L5_2 = {}
  L6_2 = A0_2.cid
  L7_2 = L0_1
  L8_2 = A1_2
  L7_2 = L7_2 .. L8_2
  L8_2 = json
  L8_2 = L8_2.encode
  L9_2 = {}
  L10_2 = nil ~= A2_2
  L9_2.had = L10_2
  L9_2.v = A2_2
  L8_2 = L8_2(L9_2)
  L9_2 = A0_2.now
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L3_2(L4_2, L5_2)
end
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT v FROM apex_phone_userdata WHERE owner = ? AND k = ?"
  L5_2 = {}
  L6_2 = A0_2.cid
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L6_1
  L5_2 = A0_2
  L6_2 = "ud_"
  L7_2 = A1_2
  L6_2 = L6_2 .. L7_2
  if L3_2 then
    L7_2 = L3_2.v
    if L7_2 then
      goto lbl_22
    end
  end
  L7_2 = nil
  ::lbl_22::
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = json
  L4_2 = L4_2.encode
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if L3_2 then
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "UPDATE apex_phone_userdata SET v = ?, updated = ? WHERE owner = ? AND k = ?"
    L7_2 = {}
    L8_2 = L4_2
    L9_2 = A0_2.now
    L10_2 = A0_2.cid
    L11_2 = A1_2
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L7_2[4] = L11_2
    L5_2(L6_2, L7_2)
  else
    L5_2 = MySQL
    L5_2 = L5_2.insert
    L5_2 = L5_2.await
    L6_2 = "INSERT INTO apex_phone_userdata (owner, k, v, updated) VALUES (?, ?, ?, ?)"
    L7_2 = {}
    L8_2 = A0_2.cid
    L9_2 = A1_2
    L10_2 = L4_2
    L11_2 = A0_2.now
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L7_2[4] = L11_2
    L5_2(L6_2, L7_2)
  end
  L5_2 = A0_2.count
  L5_2 = L5_2 + 1
  A0_2.count = L5_2
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT settings FROM apex_phone_accounts WHERE citizenid = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = pcall
  L4_2 = json
  L4_2 = L4_2.decode
  L5_2 = L2_2.settings
  if not L5_2 then
    L5_2 = "{}"
  end
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 and L4_2 then
      goto lbl_34
    end
  end
  L5_2 = {}
  L4_2 = L5_2
  ::lbl_34::
  L5_2 = A1_2
  L6_2 = L4_2
  L5_2(L6_2)
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_accounts SET settings = ? WHERE citizenid = ?"
  L7_2 = {}
  L8_2 = json
  L8_2 = L8_2.encode
  L9_2 = L4_2
  L8_2 = L8_2(L9_2)
  L9_2 = A0_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2(L6_2, L7_2)
  L5_2 = Accounts
  if L5_2 then
    L5_2 = Accounts
    L5_2 = L5_2[A0_2]
    if L5_2 then
      L5_2 = Accounts
      L5_2 = L5_2[A0_2]
      L5_2.settings = L4_2
    end
  end
  L5_2 = true
  return L5_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = os
  L1_2 = L1_2.date
  L2_2 = "%Y-%m-%d"
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  L4_2 = A0_2 * 86400
  L3_2 = L3_2 + L4_2
  return L1_2(L2_2, L3_2)
end
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = os
  L3_2 = L3_2.date
  L4_2 = "*t"
  L5_2 = os
  L5_2 = L5_2.time
  L5_2 = L5_2()
  L6_2 = A0_2 * 86400
  L5_2 = L5_2 + L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = os
  L4_2 = L4_2.time
  L5_2 = {}
  L6_2 = L3_2.year
  L5_2.year = L6_2
  L6_2 = L3_2.month
  L5_2.month = L6_2
  L6_2 = L3_2.day
  L5_2.day = L6_2
  L5_2.hour = A1_2
  L5_2.min = A2_2
  L5_2.sec = 0
  L4_2 = L4_2(L5_2)
  L4_2 = L4_2 * 1000
  return L4_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L1_2 = A0_2.byKey
  L2_2 = {}
  L3_2 = {}
  L4_2 = 25
  L5_2 = "Bean Machine \194\183 Legion Square"
  L6_2 = -7
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L4_2 = {}
  L5_2 = 52
  L6_2 = "Burger Shot \194\183 Vespucci Blvd"
  L7_2 = -24
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = 95
  L7_2 = "Transfer from %s \194\183 Concert tickets"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = L1_2.luna
  L9_2 = L9_2.name
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = 60
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = {}
  L7_2 = 240
  L8_2 = "Fuel \194\183 Globe Oil, Mirror Park"
  L9_2 = -86
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = 540
  L9_2 = "Transfer to %s \194\183 Brake job"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L1_2.marcus
  L11_2 = L11_2.name
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = -420
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = 1200
  L10_2 = "24/7 Supermarket \194\183 Innocence Blvd"
  L11_2 = -42
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = 1560
  L11_2 = "Weekly paycheck"
  L12_2 = 2450
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = 1800
  L12_2 = "Transfer from %s \194\183 Photo shoot split"
  L13_2 = L12_2
  L12_2 = L12_2.format
  L14_2 = L1_2.mia
  L14_2 = L14_2.name
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = 150
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L11_2 = {}
  L12_2 = 2040
  L13_2 = "Taxi \194\183 Downtown Cab Co."
  L14_2 = -35
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L12_2 = {}
  L13_2 = 2820
  L14_2 = "Fleeca ATM withdrawal \194\183 Legion Square"
  L15_2 = -200
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L13_2 = {}
  L14_2 = 3300
  L15_2 = "Suburban \194\183 Rockford Hills"
  L16_2 = -189
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L14_2 = {}
  L15_2 = 4200
  L16_2 = "Transfer from %s \194\183 Race winnings"
  L17_2 = L16_2
  L16_2 = L16_2.format
  L18_2 = L1_2.tyler
  L18_2 = L18_2.name
  L16_2 = L16_2(L17_2, L18_2)
  L17_2 = 500
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L15_2 = {}
  L16_2 = 4560
  L17_2 = "Marketplace sale \194\183 Mountain bike"
  L18_2 = 350
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L16_2 = {}
  L17_2 = 5880
  L18_2 = "Pillbox Medical \194\183 Co-pay"
  L19_2 = -75
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L17_2 = {}
  L18_2 = 7200
  L19_2 = "Fuel \194\183 Ron, Sandy Shores"
  L20_2 = -64
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L18_2 = {}
  L19_2 = 7560
  L20_2 = "Rent \194\183 Del Perro Heights, Apt 7"
  L21_2 = -1200
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L19_2 = {}
  L20_2 = 9000
  L21_2 = "Transfer to %s \194\183 Bahama Mamas table"
  L22_2 = L21_2
  L21_2 = L21_2.format
  L23_2 = L1_2.luna
  L23_2 = L23_2.name
  L21_2 = L21_2(L22_2, L23_2)
  L22_2 = -80
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L20_2 = {}
  L21_2 = 10200
  L22_2 = "Interest \194\183 Fleeca savings"
  L23_2 = 12
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L21_2 = {}
  L22_2 = 11640
  L23_2 = "Weekly paycheck"
  L24_2 = 2450
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L22_2 = {}
  L23_2 = 12000
  L24_2 = "Burger Shot \194\183 Vespucci Blvd"
  L25_2 = -18
  L22_2[1] = L23_2
  L22_2[2] = L24_2
  L22_2[3] = L25_2
  L23_2 = {}
  L24_2 = 13800
  L25_2 = "Ponsonbys \194\183 Portola Dr"
  L26_2 = -310
  L23_2[1] = L24_2
  L23_2[2] = L25_2
  L23_2[3] = L26_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L2_2[8] = L10_2
  L2_2[9] = L11_2
  L2_2[10] = L12_2
  L2_2[11] = L13_2
  L2_2[12] = L14_2
  L2_2[13] = L15_2
  L2_2[14] = L16_2
  L2_2[15] = L17_2
  L2_2[16] = L18_2
  L2_2[17] = L19_2
  L2_2[18] = L20_2
  L2_2[19] = L21_2
  L2_2[20] = L22_2
  L2_2[21] = L23_2
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = A0_2.insert
    L10_2 = "apex_phone_transactions"
    L11_2 = {}
    L12_2 = A0_2.cid
    L11_2.owner = L12_2
    L12_2 = L8_2[2]
    L11_2.description = L12_2
    L12_2 = L8_2[3]
    L11_2.amount = L12_2
    L12_2 = A0_2.ago
    L13_2 = L8_2[1]
    L12_2 = L12_2(L13_2)
    L11_2.created = L12_2
    L9_2(L10_2, L11_2)
  end
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = 30
  L4_2 = "Los Santos Water & Power"
  L5_2 = "October utilities (estimate)"
  L6_2 = 142
  L7_2 = "pending"
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L3_2 = {}
  L4_2 = 125
  L5_2 = "LSPD"
  L6_2 = "Speeding: 92 mph in a 55 zone, Del Perro Fwy"
  L7_2 = 750
  L8_2 = "pending"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L4_2 = {}
  L5_2 = 1320
  L6_2 = "Pillbox Medical Center"
  L7_2 = "ER visit, X-ray and stitches"
  L8_2 = 1200
  L9_2 = "pending"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L5_2 = {}
  L6_2 = 4500
  L7_2 = "Benny's Original Motor Works"
  L8_2 = "Custom exhaust and ECU tune"
  L9_2 = 2350
  L10_2 = "paid"
  L11_2 = 4380
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L6_2 = {}
  L7_2 = 8400
  L8_2 = "Los Santos Water & Power"
  L9_2 = "September utilities"
  L10_2 = 186
  L11_2 = "paid"
  L12_2 = 8340
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L7_2 = {}
  L8_2 = 12600
  L9_2 = "LSPD"
  L10_2 = "Illegal parking on Vespucci Blvd"
  L11_2 = 150
  L12_2 = "paid"
  L13_2 = 12000
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L8_2 = {}
  L9_2 = 15600
  L10_2 = "Downtown Cab Co."
  L11_2 = "No-show fee"
  L12_2 = 25
  L13_2 = "refused"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L1_2[6] = L7_2
  L1_2[7] = L8_2
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = A0_2.insert
    L9_2 = "apex_phone_bills"
    L10_2 = {}
    L11_2 = A0_2.cid
    L10_2.owner = L11_2
    L11_2 = L7_2[2]
    L10_2.sender_name = L11_2
    L11_2 = L7_2[4]
    L10_2.amount = L11_2
    L11_2 = L7_2[3]
    L10_2.reason = L11_2
    L11_2 = L7_2[5]
    L10_2.status = L11_2
    L11_2 = A0_2.ago
    L12_2 = L7_2[1]
    L11_2 = L11_2(L12_2)
    L10_2.created = L11_2
    L11_2 = L7_2[6]
    if L11_2 then
      L11_2 = A0_2.ago
      L12_2 = L7_2[6]
      L11_2 = L11_2(L12_2)
      if L11_2 then
        goto lbl_94
      end
    end
    L11_2 = nil
    ::lbl_94::
    L10_2.paid_at = L11_2
    L8_2(L9_2, L10_2)
    L8_2 = L7_2[5]
    if "paid" == L8_2 then
      L8_2 = A0_2.insert
      L9_2 = "apex_phone_transactions"
      L10_2 = {}
      L11_2 = A0_2.cid
      L10_2.owner = L11_2
      L11_2 = "Bill: "
      L12_2 = L7_2[2]
      L11_2 = L11_2 .. L12_2
      L10_2.description = L11_2
      L11_2 = L7_2[4]
      L11_2 = -L11_2
      L10_2.amount = L11_2
      L11_2 = A0_2.ago
      L12_2 = L7_2[6]
      L11_2 = L11_2(L12_2)
      L10_2.created = L11_2
      L8_2(L9_2, L10_2)
    end
  end
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT bal FROM apex_phone_crypto WHERE citizenid = ?"
  L3_2 = {}
  L4_2 = A0_2.cid
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L6_1
  L3_2 = A0_2
  L4_2 = "crypto"
  if L1_2 then
    L5_2 = tostring
    L6_2 = L1_2.bal
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_21
    end
  end
  L5_2 = nil
  ::lbl_21::
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = 0.2475
  if L1_2 then
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "UPDATE apex_phone_crypto SET bal = ? WHERE citizenid = ?"
    L5_2 = {}
    L6_2 = L2_2
    L7_2 = A0_2.cid
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L3_2(L4_2, L5_2)
  else
    L3_2 = MySQL
    L3_2 = L3_2.insert
    L3_2 = L3_2.await
    L4_2 = "INSERT INTO apex_phone_crypto (citizenid, bal) VALUES (?, ?)"
    L5_2 = {}
    L6_2 = A0_2.cid
    L7_2 = L2_2
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L3_2(L4_2, L5_2)
  end
  L3_2 = A0_2.count
  L3_2 = L3_2 + 1
  A0_2.count = L3_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = 9000
  L6_2 = "Crypto purchase"
  L7_2 = 0.15
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = 7200
  L7_2 = "Received"
  L8_2 = 0.025
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = {}
  L7_2 = 5760
  L8_2 = "Onion: Burner phone, prepaid SIM"
  L9_2 = -0.018
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = 4200
  L9_2 = "Crypto purchase"
  L10_2 = 0.12
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = 3000
  L10_2 = "Sent to greyvault21"
  L11_2 = -0.03
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = 1800
  L11_2 = "Crypto sale"
  L12_2 = -0.04
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = 360
  L12_2 = "Onion: Police scanner (receive only)"
  L13_2 = -0.032
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L11_2 = {}
  L12_2 = 180
  L13_2 = "Received"
  L14_2 = 0.0975
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L12_2 = {}
  L13_2 = 40
  L14_2 = "Onion: Discreet ride, no questions"
  L15_2 = -0.025
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L3_2[6] = L9_2
  L3_2[7] = L10_2
  L3_2[8] = L11_2
  L3_2[9] = L12_2
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = A0_2.insert
    L11_2 = "apex_phone_crypto_hist"
    L12_2 = {}
    L13_2 = A0_2.cid
    L12_2.owner = L13_2
    L13_2 = L9_2[2]
    L12_2.label = L13_2
    L13_2 = L9_2[3]
    L12_2.amount = L13_2
    L13_2 = A0_2.ago
    L14_2 = L9_2[1]
    L13_2 = L13_2(L14_2)
    L12_2.created = L13_2
    L10_2(L11_2, L12_2)
  end
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L1_2 = A0_2.byKey
  L2_2 = {}
  L3_2 = {}
  L4_2 = "greyvault21"
  L5_2 = 197
  L6_2 = 41
  L7_2 = 63
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L2_2.kai = L3_2
  L3_2 = {}
  L4_2 = "silentmoth77"
  L5_2 = 79
  L6_2 = 18
  L7_2 = 22
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L2_2.tyler = L3_2
  L3_2 = {}
  L4_2 = "ironcrow34"
  L5_2 = 304
  L6_2 = 63
  L7_2 = 88
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L2_2.marcus = L3_2
  L3_2 = {}
  L4_2 = "paleecho12"
  L5_2 = 600
  L6_2 = 120
  L7_2 = 131
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L2_2.ryan = L3_2
  L3_2 = {}
  L4_2 = "blindfox48"
  L5_2 = 124
  L6_2 = 27
  L7_2 = 30
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L2_2.luna = L3_2
  L3_2 = {}
  L4_2 = "northwire55"
  L5_2 = 37
  L6_2 = 9
  L7_2 = 11
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L2_2.derek = L3_2
  L3_2 = pairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L4_1
    L10_2 = A0_2
    L11_2 = "apex_phone_onion_id"
    L12_2 = {}
    L13_2 = L1_2[L7_2]
    L13_2 = L13_2.cid
    L12_2.citizenid = L13_2
    L13_2 = L8_2[1]
    L12_2.handle = L13_2
    L13_2 = L8_2[2]
    L12_2.rep = L13_2
    L13_2 = L8_2[3]
    L12_2.votes = L13_2
    L13_2 = L8_2[4]
    L12_2.sales = L13_2
    L13_2 = A0_2.ago
    L14_2 = 86400
    L13_2 = L13_2(L14_2)
    L12_2.since = L13_2
    L13_2 = {}
    L14_2 = "citizenid"
    L13_2[1] = L14_2
    L9_2(L10_2, L11_2, L12_2, L13_2)
  end
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT 1 FROM apex_phone_onion_id WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = A0_2.cid
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = nil ~= L3_2
  L4_2 = RPC
  if L4_2 then
    L4_2 = RPC
    L4_2 = L4_2["onion.identity"]
    if L4_2 then
      L4_2 = RPC
      L4_2 = L4_2["onion.identity"]
      L5_2 = A0_2.src
      L4_2 = L4_2(L5_2)
      if L4_2 then
        goto lbl_111
      end
    end
  end
  L4_2 = nil
  ::lbl_111::
  if L4_2 then
    L5_2 = L4_2.handle
    if L5_2 then
      goto lbl_135
    end
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT handle FROM apex_phone_onion_id WHERE citizenid = ?"
  L7_2 = {}
  L8_2 = A0_2.cid
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = {}
  if L5_2 then
    L7_2 = L5_2.handle
    if L7_2 then
      goto lbl_133
    end
  end
  L7_2 = nil
  ::lbl_133::
  L6_2.handle = L7_2
  L4_2 = L6_2
  ::lbl_135::
  L5_2 = L4_2.handle
  if not L5_2 then
    L4_2.handle = "hollowsignal19"
    L5_2 = MySQL
    L5_2 = L5_2.insert
    L5_2 = L5_2.await
    L6_2 = "INSERT INTO apex_phone_onion_id (citizenid, handle, rep, votes, sales, since) VALUES (?, ?, 0, 0, 0, ?)"
    L7_2 = {}
    L8_2 = A0_2.cid
    L9_2 = L4_2.handle
    L10_2 = A0_2.now
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L5_2(L6_2, L7_2)
  end
  if not L3_2 then
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "UPDATE apex_phone_onion_id SET rep = ?, votes = ?, sales = ?, since = ? WHERE citizenid = ?"
    L7_2 = {}
    L8_2 = 33
    L9_2 = 7
    L10_2 = 9
    L11_2 = A0_2.ago
    L12_2 = 30240
    L11_2 = L11_2(L12_2)
    L12_2 = A0_2.cid
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L7_2[4] = L11_2
    L7_2[5] = L12_2
    L5_2(L6_2, L7_2)
    L5_2 = A0_2.track
    L6_2 = "apex_phone_onion_id"
    L7_2 = "`citizenid` = ?"
    L8_2 = {}
    L9_2 = A0_2.cid
    L8_2[1] = L9_2
    L5_2(L6_2, L7_2, L8_2)
    L5_2 = A0_2.count
    L5_2 = L5_2 + 1
    A0_2.count = L5_2
  end
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = "https://picsum.photos/id/%d/600/600"
    L2_3 = L1_3
    L1_3 = L1_3.format
    L3_3 = A0_3
    return L1_3(L2_3, L3_3)
  end
  L6_2 = {}
  L7_2 = {}
  L8_2 = "kai"
  L9_2 = "Burner phone, prepaid SIM"
  L10_2 = "Prepaid SIM included, never registered. Pickup or dead drop."
  L11_2 = 0.018
  L12_2 = 8
  L13_2 = "Eletr\195\179nica"
  L14_2 = L5_2
  L15_2 = 160
  L14_2 = L14_2(L15_2)
  L15_2 = 1800
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L7_2[7] = L14_2
  L7_2[8] = L15_2
  L8_2 = {}
  L9_2 = "tyler"
  L10_2 = "Police scanner (receive only)"
  L11_2 = "Tuned to the public bands. Listen only, no transmit."
  L12_2 = 0.032
  L13_2 = 5
  L14_2 = "Eletr\195\179nica"
  L15_2 = nil
  L16_2 = 3120
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L8_2[7] = L15_2
  L8_2[8] = L16_2
  L9_2 = {}
  L10_2 = "kai"
  L11_2 = "Encrypted laptop, wiped clean"
  L12_2 = "Fresh install, full disk encryption, no serials. Charger included."
  L13_2 = 0.065
  L14_2 = 2
  L15_2 = "Eletr\195\179nica"
  L16_2 = nil
  L17_2 = 480
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L9_2[8] = L17_2
  L10_2 = {}
  L11_2 = "marcus"
  L12_2 = "Blank plate kit"
  L13_2 = "Blank plates and a hand press. I do not ask, you do not tell."
  L14_2 = 0.041
  L15_2 = 2
  L16_2 = "Pe\195\167as"
  L17_2 = nil
  L18_2 = 4500
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L10_2[7] = L17_2
  L10_2[8] = L18_2
  L11_2 = {}
  L12_2 = "marcus"
  L13_2 = "Used turbo, pulled from a Banshee"
  L14_2 = "Spools clean, some wear. Fits most Bravado and Dewbauchee builds."
  L15_2 = 0.12
  L16_2 = 1
  L17_2 = "Pe\195\167as"
  L18_2 = nil
  L19_2 = 1200
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L11_2[8] = L19_2
  L12_2 = {}
  L13_2 = "ryan"
  L14_2 = "Discreet ride, no questions"
  L15_2 = "A to B anywhere in Los Santos County. Price per trip, tinted windows."
  L16_2 = 0.025
  L17_2 = 9
  L18_2 = "Servi\195\167os"
  L19_2 = nil
  L20_2 = 300
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L12_2[4] = L16_2
  L12_2[5] = L17_2
  L12_2[6] = L18_2
  L12_2[7] = L19_2
  L12_2[8] = L20_2
  L13_2 = {}
  L14_2 = "derek"
  L15_2 = "Paperwork that holds up"
  L16_2 = "IDs and permits that pass a quick look. Allow two days."
  L17_2 = 0.085
  L18_2 = 3
  L19_2 = "Documentos"
  L20_2 = nil
  L21_2 = 6000
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L13_2[6] = L19_2
  L13_2[7] = L20_2
  L13_2[8] = L21_2
  L14_2 = {}
  L15_2 = "luna"
  L16_2 = "Guest list spot, Vinewood party"
  L17_2 = "Rooftop party in Vinewood Hills this Saturday. One name per purchase."
  L18_2 = 0.015
  L19_2 = 4
  L20_2 = "Diversos"
  L21_2 = nil
  L22_2 = 180
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L14_2[5] = L19_2
  L14_2[6] = L20_2
  L14_2[7] = L21_2
  L14_2[8] = L22_2
  L15_2 = {}
  L16_2 = "luna"
  L17_2 = "Vintage film camera"
  L18_2 = "Works perfectly, two rolls included. Found it, not stolen."
  L19_2 = 0.022
  L20_2 = 1
  L21_2 = "Diversos"
  L22_2 = L5_2
  L23_2 = 250
  L22_2 = L22_2(L23_2)
  L23_2 = 2640
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L15_2[4] = L19_2
  L15_2[5] = L20_2
  L15_2[6] = L21_2
  L15_2[7] = L22_2
  L15_2[8] = L23_2
  L16_2 = {}
  L17_2 = "tyler"
  L18_2 = "Lockpick set, pro grade"
  L19_2 = "Twelve picks and tension tools in a leather roll."
  L20_2 = 0.009
  L21_2 = 0
  L22_2 = "Pe\195\167as"
  L23_2 = nil
  L24_2 = 7800
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L16_2[4] = L20_2
  L16_2[5] = L21_2
  L16_2[6] = L22_2
  L16_2[7] = L23_2
  L16_2[8] = L24_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L6_2[7] = L13_2
  L6_2[8] = L14_2
  L6_2[9] = L15_2
  L6_2[10] = L16_2
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2[1]
    L14_2 = L1_2[L14_2]
    L15_2 = A0_2.insert
    L16_2 = "apex_phone_onion"
    L17_2 = {}
    L18_2 = L14_2.cid
    L17_2.owner = L18_2
    L18_2 = L13_2[1]
    L18_2 = L2_2[L18_2]
    L18_2 = L18_2[1]
    L17_2.seller_handle = L18_2
    L18_2 = L13_2[2]
    L17_2.title = L18_2
    L18_2 = L13_2[3]
    L17_2.description = L18_2
    L18_2 = L13_2[4]
    L17_2.price = L18_2
    L18_2 = L13_2[5]
    L17_2.stock = L18_2
    L18_2 = L13_2[6]
    L17_2.category = L18_2
    L18_2 = L13_2[7]
    L17_2.image = L18_2
    L18_2 = A0_2.ago
    L19_2 = L13_2[8]
    L18_2 = L18_2(L19_2)
    L17_2.created = L18_2
    L17_2.kind = "other"
    L15_2 = L15_2(L16_2, L17_2)
    L7_2[L12_2] = L15_2
  end
  L8_2 = A0_2.insert
  L9_2 = "apex_phone_onion"
  L10_2 = {}
  L11_2 = A0_2.cid
  L10_2.owner = L11_2
  L11_2 = L4_2.handle
  L10_2.seller_handle = L11_2
  L10_2.title = "Signal jammer, short range"
  L10_2.description = "Pocket sized, about ten meters of quiet. Battery lasts an hour."
  L10_2.price = 0.048
  L10_2.stock = 2
  L10_2.category = "Eletr\195\179nica"
  L11_2 = A0_2.ago
  L12_2 = 1560
  L11_2 = L11_2(L12_2)
  L10_2.created = L11_2
  L10_2.kind = "other"
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = A0_2.insert
  L10_2 = "apex_phone_onion"
  L11_2 = {}
  L12_2 = A0_2.cid
  L11_2.owner = L12_2
  L12_2 = L4_2.handle
  L11_2.seller_handle = L12_2
  L11_2.title = "Night tour of the Maze Bank roof"
  L11_2.description = "Best view in the city. Service elevator, back by sunrise."
  L11_2.price = 0.03
  L11_2.stock = 3
  L11_2.category = "Servi\195\167os"
  L12_2 = A0_2.ago
  L13_2 = 4800
  L12_2 = L12_2(L13_2)
  L11_2.created = L12_2
  L11_2.kind = "other"
  L9_2 = L9_2(L10_2, L11_2)
  function L10_2(A0_3, A1_3, A2_3, A3_3, A4_3, A5_3, A6_3, A7_3, A8_3, A9_3)
    local L10_3, L11_3, L12_3, L13_3, L14_3
    L10_3 = A0_2.insert
    L11_3 = "apex_phone_onion_orders"
    L12_3 = {}
    L12_3.listing = A0_3
    L12_3.buyer = A1_3
    L12_3.buyer_handle = A2_3
    L12_3.seller = A3_3
    L12_3.seller_handle = A4_3
    L12_3.title = A5_3
    L12_3.price = A6_3
    L12_3.status = A7_3
    L12_3.rating = A8_3
    L13_3 = A0_2.ago
    L14_3 = A9_3
    L13_3 = L13_3(L14_3)
    L12_3.created = L13_3
    L10_3(L11_3, L12_3)
  end
  L11_2 = L10_2
  L12_2 = L7_2[1]
  L13_2 = A0_2.cid
  L14_2 = L4_2.handle
  L15_2 = L1_2.kai
  L15_2 = L15_2.cid
  L16_2 = "greyvault21"
  L17_2 = L6_2[1]
  L17_2 = L17_2[2]
  L18_2 = L6_2[1]
  L18_2 = L18_2[4]
  L19_2 = "concluido"
  L20_2 = 5
  L21_2 = 5760
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L11_2 = L10_2
  L12_2 = L7_2[2]
  L13_2 = A0_2.cid
  L14_2 = L4_2.handle
  L15_2 = L1_2.tyler
  L15_2 = L15_2.cid
  L16_2 = "silentmoth77"
  L17_2 = L6_2[2]
  L17_2 = L17_2[2]
  L18_2 = L6_2[2]
  L18_2 = L18_2[4]
  L19_2 = "enviado"
  L20_2 = nil
  L21_2 = 360
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L11_2 = L10_2
  L12_2 = L7_2[6]
  L13_2 = A0_2.cid
  L14_2 = L4_2.handle
  L15_2 = L1_2.ryan
  L15_2 = L15_2.cid
  L16_2 = "paleecho12"
  L17_2 = L6_2[6]
  L17_2 = L17_2[2]
  L18_2 = L6_2[6]
  L18_2 = L18_2[4]
  L19_2 = "pago"
  L20_2 = nil
  L21_2 = 40
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L11_2 = L10_2
  L12_2 = L7_2[4]
  L13_2 = A0_2.cid
  L14_2 = L4_2.handle
  L15_2 = L1_2.marcus
  L15_2 = L15_2.cid
  L16_2 = "ironcrow34"
  L17_2 = L6_2[4]
  L17_2 = L17_2[2]
  L18_2 = L6_2[4]
  L18_2 = L18_2[4]
  L19_2 = "cancelado"
  L20_2 = nil
  L21_2 = 3000
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L11_2 = L10_2
  L12_2 = L8_2
  L13_2 = L1_2.luna
  L13_2 = L13_2.cid
  L14_2 = "blindfox48"
  L15_2 = A0_2.cid
  L16_2 = L4_2.handle
  L17_2 = "Signal jammer, short range"
  L18_2 = 0.048
  L19_2 = "pago"
  L20_2 = nil
  L21_2 = 22
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L11_2 = L10_2
  L12_2 = L9_2
  L13_2 = L1_2.derek
  L13_2 = L13_2.cid
  L14_2 = "northwire55"
  L15_2 = A0_2.cid
  L16_2 = L4_2.handle
  L17_2 = "Night tour of the Maze Bank roof"
  L18_2 = 0.03
  L19_2 = "concluido"
  L20_2 = 4
  L21_2 = 4200
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = RPC
  if L1_2 then
    L1_2 = RPC
    L1_2 = L1_2["darkchat.identity"]
    if L1_2 then
      L1_2 = RPC
      L1_2 = L1_2["darkchat.identity"]
      L2_2 = A0_2.src
      L1_2 = L1_2(L2_2)
      if L1_2 then
        goto lbl_15
      end
    end
  end
  L1_2 = nil
  ::lbl_15::
  if L1_2 then
    L1_2 = L1_2.username
  end
  if not L1_2 then
    L2_2 = MySQL
    L2_2 = L2_2.single
    L2_2 = L2_2.await
    L3_2 = "SELECT username FROM apex_phone_darkchat_members WHERE citizenid = ? LIMIT 1"
    L4_2 = {}
    L5_2 = A0_2.cid
    L4_2[1] = L5_2
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L3_2 = L2_2.username
      if L3_2 then
        goto lbl_42
        L1_2 = L3_2 or L1_2
      end
    end
    L3_2 = "raven"
    L4_2 = math
    L4_2 = L4_2.random
    L5_2 = 100
    L6_2 = 999
    L4_2 = L4_2(L5_2, L6_2)
    L3_2 = L3_2 .. L4_2
    L1_2 = L3_2
  end
  ::lbl_42::
  L2_2 = {}
  L3_2 = {}
  L4_2 = {}
  L5_2 = "neon808"
  L6_2 = "anyone else hear the sirens out by the docks?"
  L7_2 = 180
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = "ghost217"
  L7_2 = "three cruisers and a chopper. something big at Elysian"
  L8_2 = 176
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = {}
  L7_2 = "ME"
  L8_2 = "saw it from the bridge, they closed half of Elysian Fields Fwy"
  L9_2 = 171
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = "zero646"
  L9_2 = "good night to stay home"
  L10_2 = 165
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = "ash275"
  L10_2 = "or a good night to be somewhere else entirely"
  L11_2 = 120
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = "raven512"
  L11_2 = "who has a working number for a tow in Sandy? asking for a friend"
  L12_2 = 64
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = "wolf904"
  L12_2 = "try the Ron station guy, he picks up at any hour"
  L13_2 = 61
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L11_2 = {}
  L12_2 = "ME"
  L13_2 = "can confirm, he got me out of a ditch last week"
  L14_2 = 58
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L12_2 = {}
  L13_2 = "neon808"
  L14_2 = "drinks at the pier tonight. you know which one"
  L15_2 = 14
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L3_2[6] = L9_2
  L3_2[7] = L10_2
  L3_2[8] = L11_2
  L3_2[9] = L12_2
  L2_2.geral = L3_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = "echo331"
  L6_2 = "Weazel is saying the Vinewood sign gets new lights this week"
  L7_2 = 300
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = "crow118"
  L7_2 = "they say that every year"
  L8_2 = 296
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = {}
  L7_2 = "ghost217"
  L8_2 = "roadwork on Del Perro Fwy all weekend, take Bay City Ave"
  L9_2 = 140
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = "ME"
  L9_2 = "thanks, the morning traffic was already brutal"
  L10_2 = 133
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = "zero646"
  L10_2 = "Bahama Mamas line was around the block last night"
  L11_2 = 70
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = "echo331"
  L11_2 = "that DJ is no joke"
  L12_2 = 66
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = "raven512"
  L12_2 = "Maze Bank lobby is crawling with security today, heads up"
  L13_2 = 9
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L3_2[6] = L9_2
  L3_2[7] = L10_2
  L2_2["los-santos"] = L3_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = "wolf904"
  L6_2 = "meet at the LSIA long-term lot, midnight"
  L7_2 = 420
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = "crow118"
  L7_2 = "bring cash, no crypto this time"
  L8_2 = 415
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = {}
  L7_2 = "ME"
  L8_2 = "is the Senora run still on for Saturday?"
  L9_2 = 230
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = "wolf904"
  L9_2 = "on. two laps, desert loop, winner takes the pot"
  L10_2 = 226
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = "ash275"
  L10_2 = "cops were parked at the Grapeseed turn last time"
  L11_2 = 222
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = "neon808"
  L11_2 = "new rule: no rammers. you know who you are"
  L12_2 = 47
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = "crow118"
  L12_2 = "lol"
  L13_2 = 45
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L3_2[6] = L9_2
  L3_2[7] = L10_2
  L2_2["street-racing"] = L3_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = "echo331"
  L6_2 = "looking for a clean laptop, no questions"
  L7_2 = 600
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = "zero646"
  L7_2 = "check the Onion, greyvault21 had one"
  L8_2 = 596
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = {}
  L7_2 = "raven512"
  L8_2 = "anyone selling tickets for Saturday at the Galaxy?"
  L9_2 = 190
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = "ME"
  L9_2 = "I might have two, will message you"
  L10_2 = 185
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = "ghost217"
  L10_2 = "trading a turbo for a set of wheels, DM"
  L11_2 = 33
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L2_2["night-market"] = L3_2
  L3_2 = {}
  L4_2 = "geral"
  L5_2 = "los-santos"
  L6_2 = "street-racing"
  L7_2 = "night-market"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = MySQL
    L10_2 = L10_2.scalar
    L10_2 = L10_2.await
    L11_2 = "SELECT 1 FROM apex_phone_darkchat_members WHERE citizenid = ? AND room = ?"
    L12_2 = {}
    L13_2 = A0_2.cid
    L14_2 = L9_2
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L10_2 = L10_2(L11_2, L12_2)
    L10_2 = nil ~= L10_2
    if not L10_2 then
      L11_2 = L4_1
      L12_2 = A0_2
      L13_2 = "apex_phone_darkchat_members"
      L14_2 = {}
      L15_2 = A0_2.cid
      L14_2.citizenid = L15_2
      L14_2.room = L9_2
      L14_2.username = L1_2
      L15_2 = {}
      L16_2 = "citizenid"
      L17_2 = "room"
      L15_2[1] = L16_2
      L15_2[2] = L17_2
      L11_2(L12_2, L13_2, L14_2, L15_2)
    end
    L11_2 = ipairs
    L12_2 = L2_2[L9_2]
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = A0_2.insert
      L18_2 = "apex_phone_darkchat"
      L19_2 = {}
      L19_2.room = L9_2
      L20_2 = L16_2[1]
      L20_2 = L1_2 or L20_2
      if "ME" ~= L20_2 or not L1_2 then
        L20_2 = L16_2[1]
      end
      L19_2.username = L20_2
      L20_2 = L16_2[2]
      L19_2.content = L20_2
      L19_2.ttl = 0
      L20_2 = A0_2.ago
      L21_2 = L16_2[3]
      L20_2 = L20_2(L21_2)
      L19_2.created = L20_2
      L17_2(L18_2, L19_2)
    end
  end
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2
  L1_2 = Config
  L1_2 = L1_2.Eats
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = L1_2.enabled
  if false == L2_2 then
    return
  end
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L1_2.restaurants
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.id
    L2_2[L10_2] = L9_2
    L10_2 = L9_2.id
    L11_2 = {}
    L3_2[L10_2] = L11_2
    L10_2 = ipairs
    L11_2 = L9_2.menu
    if not L11_2 then
      L11_2 = {}
    end
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = ipairs
      L17_2 = L15_2.items
      if not L17_2 then
        L17_2 = {}
      end
      L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
      for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
        L22_2 = L9_2.id
        L22_2 = L3_2[L22_2]
        L23_2 = L21_2.id
        L22_2[L23_2] = L21_2
      end
    end
  end
  function L4_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L3_3 = ipairs
    L4_3 = A0_3.options
    if not L4_3 then
      L4_3 = {}
    end
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = L8_3.id
      if L9_3 == A1_3 then
        L9_3 = ipairs
        L10_3 = L8_3.choices
        if not L10_3 then
          L10_3 = {}
        end
        L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
        for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
          L15_3 = L14_3.id
          if L15_3 == A2_3 then
            return L14_3
          end
        end
      end
    end
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = "pizzathis"
  L8_2 = 2820
  L9_2 = "delivered"
  L10_2 = 2
  L11_2 = 5
  L12_2 = "Danny Ortiz"
  L13_2 = {}
  L14_2 = {}
  L15_2 = "pz_marg"
  L16_2 = 1
  L17_2 = "Margherita"
  L18_2 = {}
  L19_2 = {}
  L20_2 = "size"
  L21_2 = "l"
  L22_2 = "Large (40 cm)"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L20_2 = {}
  L21_2 = "crust"
  L22_2 = "thin"
  L23_2 = "Thin crust"
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L15_2 = {}
  L16_2 = "pz_bread"
  L17_2 = 1
  L18_2 = "Garlic bread"
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L14_2 = "Extra napkins please"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L6_2[7] = L13_2
  L6_2[8] = L14_2
  L7_2 = {}
  L8_2 = "sakura"
  L9_2 = 5880
  L10_2 = "delivered"
  L11_2 = 5
  L12_2 = 4
  L13_2 = "ryan"
  L14_2 = {}
  L15_2 = {}
  L16_2 = "sk_c20"
  L17_2 = 1
  L18_2 = "20-piece combo"
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L16_2 = {}
  L17_2 = "sk_miso"
  L18_2 = 2
  L19_2 = "Miso soup"
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L15_2 = ""
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L7_2[7] = L14_2
  L7_2[8] = L15_2
  L8_2 = {}
  L9_2 = "burgershot"
  L10_2 = 1560
  L11_2 = "delivered"
  L12_2 = 1
  L13_2 = 5
  L14_2 = "Kelly Nguyen"
  L15_2 = {}
  L16_2 = {}
  L17_2 = "bs_bleeder"
  L18_2 = 2
  L19_2 = "Bleeder"
  L20_2 = {}
  L21_2 = {}
  L22_2 = "size"
  L23_2 = "menu"
  L24_2 = "Meal (fries + drink)"
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L20_2[1] = L21_2
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L16_2[4] = L20_2
  L17_2 = {}
  L18_2 = "bs_shake"
  L19_2 = 1
  L20_2 = "Milkshake"
  L21_2 = {}
  L22_2 = {}
  L23_2 = "flav"
  L24_2 = "cho"
  L25_2 = "Chocolate"
  L22_2[1] = L23_2
  L22_2[2] = L24_2
  L22_2[3] = L25_2
  L21_2[1] = L22_2
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L17_2[4] = L21_2
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L16_2 = "Ring the bell, the buzzer is broken"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L8_2[7] = L15_2
  L8_2[8] = L16_2
  L9_2 = {}
  L10_2 = "beanmachine"
  L11_2 = 8400
  L12_2 = "delivered"
  L13_2 = 0
  L14_2 = 4
  L15_2 = "Marco Diaz"
  L16_2 = {}
  L17_2 = {}
  L18_2 = "bm_latte"
  L19_2 = 2
  L20_2 = "Latte"
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L18_2 = {}
  L19_2 = "bm_cinnamon"
  L20_2 = 1
  L21_2 = "Cinnamon roll"
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L17_2 = ""
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L9_2[8] = L17_2
  L10_2 = {}
  L11_2 = "tacobomb"
  L12_2 = 10200
  L13_2 = "cancelled"
  L14_2 = 0
  L15_2 = nil
  L16_2 = nil
  L17_2 = {}
  L18_2 = {}
  L19_2 = "tb_burrito"
  L20_2 = 1
  L21_2 = "Bomb Burrito"
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L19_2 = {}
  L20_2 = "tb_nachos"
  L21_2 = 1
  L22_2 = "Supreme nachos"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L18_2 = ""
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L10_2[7] = L17_2
  L10_2[8] = L18_2
  L11_2 = {}
  L12_2 = "noodle"
  L13_2 = 13200
  L14_2 = "delivered"
  L15_2 = 3
  L16_2 = 5
  L17_2 = "ryan"
  L18_2 = {}
  L19_2 = {}
  L20_2 = "nx_ramen"
  L21_2 = 1
  L22_2 = "Pork ramen"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L20_2 = {}
  L21_2 = "nx_gyoza"
  L22_2 = 1
  L23_2 = "Gyoza (6)"
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L19_2 = ""
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L11_2[8] = L19_2
  L12_2 = {}
  L13_2 = "cluckin"
  L14_2 = 180
  L15_2 = "delivered"
  L16_2 = 2
  L17_2 = nil
  L18_2 = "Danny Ortiz"
  L19_2 = {}
  L20_2 = {}
  L21_2 = "cb_bucket"
  L22_2 = 1
  L23_2 = "Cluckin bucket (8 pcs)"
  L24_2 = {}
  L25_2 = {}
  L26_2 = "spice"
  L27_2 = "hot"
  L28_2 = "Spicy"
  L25_2[1] = L26_2
  L25_2[2] = L27_2
  L25_2[3] = L28_2
  L24_2[1] = L25_2
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L20_2[4] = L24_2
  L21_2 = {}
  L22_2 = "cb_fries"
  L23_2 = 1
  L24_2 = "Curly fries"
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L20_2 = "Leave it at the door"
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L12_2[4] = L16_2
  L12_2[5] = L17_2
  L12_2[6] = L18_2
  L12_2[7] = L19_2
  L12_2[8] = L20_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L5_2[7] = L12_2
  L6_2 = {}
  L6_2.label = "Home"
  L6_2.x = -1447.4
  L6_2.y = -537.7
  L7_2 = tonumber
  L8_2 = L1_2.serviceFee
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = L1_2.smallOrder
  L9_2 = 0
  L10_2 = ipairs
  L11_2 = L5_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2[1]
    L16_2 = L2_2[L16_2]
    if L16_2 then
      L17_2 = {}
      L18_2 = 0
      L19_2 = true
      L20_2 = ipairs
      L21_2 = L15_2[7]
      L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
      for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
        L26_2 = L16_2.id
        L26_2 = L3_2[L26_2]
        L27_2 = L25_2[1]
        L26_2 = L26_2[L27_2]
        if not L26_2 then
          L19_2 = false
          break
        end
        L27_2 = tonumber
        L28_2 = L26_2.price
        L27_2 = L27_2(L28_2)
        if not L27_2 then
          L27_2 = 0
        end
        L28_2 = {}
        L29_2 = ipairs
        L30_2 = L25_2[4]
        if not L30_2 then
          L30_2 = {}
        end
        L29_2, L30_2, L31_2, L32_2 = L29_2(L30_2)
        for L33_2, L34_2 in L29_2, L30_2, L31_2, L32_2 do
          L35_2 = L4_2
          L36_2 = L26_2
          L37_2 = L34_2[1]
          L38_2 = L34_2[2]
          L35_2 = L35_2(L36_2, L37_2, L38_2)
          if L35_2 then
            L36_2 = tonumber
            L37_2 = L35_2.price
            L36_2 = L36_2(L37_2)
            if not L36_2 then
              L36_2 = 0
            end
            L27_2 = L27_2 + L36_2
            L36_2 = #L28_2
            L36_2 = L36_2 + 1
            L37_2 = {}
            L38_2 = L34_2[1]
            L37_2.g = L38_2
            L38_2 = L35_2.id
            L37_2.id = L38_2
            L38_2 = L34_2[3]
            L37_2.name = L38_2
            L38_2 = tonumber
            L39_2 = L35_2.price
            L38_2 = L38_2(L39_2)
            if not L38_2 then
              L38_2 = 0
            end
            L37_2.price = L38_2
            L28_2[L36_2] = L37_2
          end
        end
        L29_2 = L3_1
        L30_2 = L27_2
        L29_2 = L29_2(L30_2)
        L27_2 = L29_2
        L29_2 = L25_2[2]
        L29_2 = L27_2 * L29_2
        L18_2 = L18_2 + L29_2
        L29_2 = #L17_2
        L29_2 = L29_2 + 1
        L30_2 = {}
        L31_2 = L26_2.id
        L30_2.id = L31_2
        L31_2 = L25_2[3]
        L30_2.name = L31_2
        L31_2 = L25_2[2]
        L30_2.qty = L31_2
        L30_2.unit = L27_2
        L31_2 = L3_1
        L32_2 = L25_2[2]
        L32_2 = L27_2 * L32_2
        L31_2 = L31_2(L32_2)
        L30_2.total = L31_2
        L30_2.opts = L28_2
        L30_2.note = ""
        L31_2 = L26_2.item
        L30_2.item = L31_2
        L17_2[L29_2] = L30_2
      end
      if L19_2 then
        L20_2 = L3_1
        L21_2 = L18_2
        L20_2 = L20_2(L21_2)
        L18_2 = L20_2
        L20_2 = tonumber
        L21_2 = L16_2.fee
        L20_2 = L20_2(L21_2)
        if not L20_2 then
          L20_2 = 0
        end
        if L8_2 then
          L21_2 = L8_2.under
          if L21_2 then
            L21_2 = L8_2.under
            if L18_2 < L21_2 then
              L21_2 = tonumber
              L22_2 = L8_2.fee
              L21_2 = L21_2(L22_2)
              if L21_2 then
                goto lbl_432
              end
              L21_2 = 0
              if L21_2 then
                goto lbl_432
              end
            end
          end
        end
        L21_2 = 0
        ::lbl_432::
        L22_2 = L3_1
        L23_2 = L18_2 + L20_2
        L23_2 = L23_2 + L21_2
        L23_2 = L23_2 + L7_2
        L24_2 = L15_2[4]
        L23_2 = L23_2 + L24_2
        L22_2 = L22_2(L23_2)
        L23_2 = A0_2.ago
        L24_2 = L15_2[2]
        L23_2 = L23_2(L24_2)
        L24_2 = nil
        L25_2 = L15_2[6]
        L26_2 = nil
        L27_2 = 1
        L28_2 = L15_2[6]
        if L28_2 then
          L28_2 = A0_2.byKey
          L29_2 = L15_2[6]
          L28_2 = L28_2[L29_2]
          if L28_2 then
            L28_2 = A0_2.byKey
            L29_2 = L15_2[6]
            L28_2 = L28_2[L29_2]
            L29_2 = L28_2.cid
            L30_2 = L28_2.name
            L31_2 = L28_2.phone
            L27_2 = 0
            L26_2 = L31_2
            L25_2 = L30_2
            L24_2 = L29_2
          end
        end
        L28_2 = L15_2[3]
        L28_2 = "delivered" == L28_2
        L29_2 = A0_2.insert
        L30_2 = "apex_phone_eats_orders"
        L31_2 = {}
        L32_2 = A0_2.cid
        L31_2.owner = L32_2
        L32_2 = A0_2.number
        L31_2.phone = L32_2
        L32_2 = A0_2.name
        L31_2.name = L32_2
        L32_2 = L16_2.id
        L31_2.restaurant = L32_2
        L31_2.items = L17_2
        L32_2 = L15_2[8]
        L31_2.note = L32_2
        L31_2.subtotal = L18_2
        L31_2.fee = L20_2
        L31_2.service = L7_2
        L31_2.smallfee = L21_2
        L31_2.discount = 0
        L32_2 = L15_2[4]
        L31_2.tip = L32_2
        L31_2.total = L22_2
        L31_2.pay = "card"
        L32_2 = L6_2.label
        L31_2.addr_label = L32_2
        L32_2 = L6_2.x
        L31_2.addr_x = L32_2
        L32_2 = L6_2.y
        L31_2.addr_y = L32_2
        L32_2 = L15_2[3]
        L31_2.status = L32_2
        L32_2 = L24_2 or L32_2
        if not L28_2 or not L24_2 then
          L32_2 = nil
        end
        L31_2.courier = L32_2
        L32_2 = L25_2 or L32_2
        if not L28_2 or not L25_2 then
          L32_2 = nil
        end
        L31_2.courier_name = L32_2
        L32_2 = L26_2 or L32_2
        if not L28_2 or not L26_2 then
          L32_2 = nil
        end
        L31_2.courier_phone = L32_2
        L32_2 = L27_2 or L32_2
        if not L28_2 or not L27_2 then
          L32_2 = 0
        end
        L31_2.courier_npc = L32_2
        L31_2.created = L23_2
        if L28_2 then
          L32_2 = L23_2 + 540000
          if L32_2 then
            goto lbl_537
          end
        end
        L32_2 = nil
        ::lbl_537::
        L31_2.ready_at = L32_2
        if L28_2 then
          L32_2 = L23_2 + 1620000
          if L32_2 then
            goto lbl_545
          end
        end
        L32_2 = nil
        ::lbl_545::
        L31_2.delivered = L32_2
        L32_2 = L15_2[5]
        L31_2.rating = L32_2
        L29_2(L30_2, L31_2)
        if L28_2 then
          L29_2 = A0_2.insert
          L30_2 = "apex_phone_transactions"
          L31_2 = {}
          L32_2 = A0_2.cid
          L31_2.owner = L32_2
          L32_2 = "Eats: "
          L33_2 = tostring
          L34_2 = L16_2.name
          L33_2 = L33_2(L34_2)
          L32_2 = L32_2 .. L33_2
          L31_2.description = L32_2
          L32_2 = math
          L32_2 = L32_2.floor
          L33_2 = L22_2
          L32_2 = L32_2(L33_2)
          L32_2 = -L32_2
          L31_2.amount = L32_2
          L31_2.created = L23_2
          L29_2(L30_2, L31_2)
        end
        L9_2 = L9_2 + 1
      end
    end
  end
  L10_2 = tonumber
  L11_2 = MySQL
  L11_2 = L11_2.scalar
  L11_2 = L11_2.await
  L12_2 = "SELECT COUNT(*) FROM apex_phone_eats_addresses WHERE owner = ?"
  L13_2 = {}
  L14_2 = A0_2.cid
  L13_2[1] = L14_2
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L11_2(L12_2, L13_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
  if not L10_2 then
    L10_2 = 0
  end
  L11_2 = {}
  L12_2 = {}
  L13_2 = "Home"
  L14_2 = "Del Perro Heights, apt 7. Buzz twice."
  L15_2 = -1447.4
  L16_2 = -537.7
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L12_2[4] = L16_2
  L13_2 = {}
  L14_2 = "Work"
  L15_2 = "Maze Bank Tower, front desk"
  L16_2 = -75.2
  L17_2 = -818.9
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L14_2 = {}
  L15_2 = "Gym"
  L16_2 = "Muscle Beach, by the bench press"
  L17_2 = -1201.9
  L18_2 = -1568.5
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L12_2 = ipairs
  L13_2 = L11_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = L10_2 + L16_2
    if L18_2 <= 12 then
      L18_2 = A0_2.insert
      L19_2 = "apex_phone_eats_addresses"
      L20_2 = {}
      L21_2 = A0_2.cid
      L20_2.owner = L21_2
      L21_2 = L17_2[1]
      L20_2.label = L21_2
      L21_2 = L17_2[2]
      L20_2.note = L21_2
      L21_2 = L17_2[3]
      L20_2.x = L21_2
      L21_2 = L17_2[4]
      L20_2.y = L21_2
      L21_2 = A0_2.ago
      L22_2 = 20
      L22_2 = L22_2 - L16_2
      L22_2 = 1440 * L22_2
      L21_2 = L21_2(L22_2)
      L20_2.created = L21_2
      L18_2(L19_2, L20_2)
    end
  end
  L12_2 = MySQL
  L12_2 = L12_2.scalar
  L12_2 = L12_2.await
  L13_2 = "SELECT 1 FROM apex_phone_eats_meta WHERE owner = ?"
  L14_2 = {}
  L15_2 = A0_2.cid
  L14_2[1] = L15_2
  L12_2 = L12_2(L13_2, L14_2)
  if nil == L12_2 then
    L12_2 = {}
    L13_2 = ipairs
    L14_2 = {}
    L15_2 = "burgershot"
    L16_2 = "sakura"
    L17_2 = "pizzathis"
    L14_2[1] = L15_2
    L14_2[2] = L16_2
    L14_2[3] = L17_2
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
    for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
      L19_2 = L2_2[L18_2]
      if L19_2 then
        L19_2 = #L12_2
        L19_2 = L19_2 + 1
        L12_2[L19_2] = L18_2
      end
    end
    L13_2 = L4_1
    L14_2 = A0_2
    L15_2 = "apex_phone_eats_meta"
    L16_2 = {}
    L17_2 = A0_2.cid
    L16_2.owner = L17_2
    L17_2 = json
    L17_2 = L17_2.encode
    L18_2 = L12_2
    L17_2 = L17_2(L18_2)
    L16_2.favorites = L17_2
    L16_2.promos = "{}"
    L16_2.pro_until = 0
    L17_2 = {}
    L18_2 = "owner"
    L17_2[1] = L18_2
    L13_2(L14_2, L15_2, L16_2, L17_2)
  end
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = A0_2.byKey
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = Config
  L4_2 = L4_2.Services
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.id
    L2_2[L9_2] = L8_2
  end
  function L3_2(A0_3)
    local L1_3, L2_3, L3_3
    L2_3 = A0_3.service
    L1_3 = L2_2
    L1_3 = L1_3[L2_3]
    if L1_3 then
      L1_3 = A0_2.insert
      L2_3 = "apex_phone_services"
      L3_3 = A0_3
      L1_3(L2_3, L3_3)
    end
  end
  function L4_2(A0_3, A1_3, A2_3)
    local L3_3
    L3_3 = {}
    L3_3.x = A0_3
    L3_3.y = A1_3
    L3_3.z = A2_3
    return L3_3
  end
  L5_2 = L3_2
  L6_2 = {}
  L7_2 = A0_2.cid
  L6_2.requester = L7_2
  L7_2 = A0_2.name
  L6_2.requester_name = L7_2
  L7_2 = A0_2.number
  L6_2.requester_phone = L7_2
  L6_2.service = "burgershot"
  L6_2.description = "Catering for 12 people on Saturday, mostly Bleeders and fries. Delivery to Del Perro Heights."
  L7_2 = L4_2
  L8_2 = -1447.4
  L9_2 = -537.7
  L10_2 = 34.7
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.coords = L7_2
  L6_2.status = "pending"
  L7_2 = A0_2.ago
  L8_2 = 35
  L7_2 = L7_2(L8_2)
  L6_2.created = L7_2
  L5_2(L6_2)
  L5_2 = L3_2
  L6_2 = {}
  L7_2 = A0_2.cid
  L6_2.requester = L7_2
  L7_2 = A0_2.name
  L6_2.requester_name = L7_2
  L7_2 = A0_2.number
  L6_2.requester_phone = L7_2
  L6_2.service = "realestate"
  L6_2.description = "Looking for a 2-bed in Rockford Hills, budget around 400k. Garage is a must."
  L6_2.status = "accepted"
  L7_2 = "Dynasty 8 \194\183 "
  L8_2 = L1_2.sofia
  L8_2 = L8_2.name
  L7_2 = L7_2 .. L8_2
  L6_2.accepted_by = L7_2
  L7_2 = L1_2.sofia
  L7_2 = L7_2.cid
  L6_2.accepted_cid = L7_2
  L7_2 = A0_2.ago
  L8_2 = 180
  L7_2 = L7_2(L8_2)
  L6_2.created = L7_2
  L5_2(L6_2)
  L5_2 = L3_2
  L6_2 = {}
  L7_2 = A0_2.cid
  L6_2.requester = L7_2
  L7_2 = A0_2.name
  L6_2.requester_name = L7_2
  L7_2 = A0_2.number
  L6_2.requester_phone = L7_2
  L6_2.service = "mechanic"
  L6_2.description = "Flat tire on the Great Ocean Hwy near Paleto, no spare."
  L7_2 = L4_2
  L8_2 = -158.3
  L9_2 = 6372.9
  L10_2 = 31.4
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.coords = L7_2
  L6_2.status = "done"
  L7_2 = "Benny's \194\183 "
  L8_2 = L1_2.marcus
  L8_2 = L8_2.name
  L7_2 = L7_2 .. L8_2
  L6_2.accepted_by = L7_2
  L7_2 = L1_2.marcus
  L7_2 = L7_2.cid
  L6_2.accepted_cid = L7_2
  L7_2 = A0_2.ago
  L8_2 = 2760
  L7_2 = L7_2(L8_2)
  L6_2.created = L7_2
  L5_2(L6_2)
  L5_2 = L3_2
  L6_2 = {}
  L7_2 = A0_2.cid
  L6_2.requester = L7_2
  L7_2 = A0_2.name
  L6_2.requester_name = L7_2
  L7_2 = A0_2.number
  L6_2.requester_phone = L7_2
  L6_2.service = "taxi"
  L6_2.description = "Pickup at Del Perro Pier, heading to LSIA terminal 1."
  L7_2 = L4_2
  L8_2 = -1850.1
  L9_2 = -1231.8
  L10_2 = 13.0
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.coords = L7_2
  L6_2.status = "done"
  L7_2 = "Downtown Cab Co. \194\183 "
  L8_2 = L1_2.ryan
  L8_2 = L8_2.name
  L7_2 = L7_2 .. L8_2
  L6_2.accepted_by = L7_2
  L7_2 = L1_2.ryan
  L7_2 = L7_2.cid
  L6_2.accepted_cid = L7_2
  L7_2 = A0_2.ago
  L8_2 = 7200
  L7_2 = L7_2(L8_2)
  L6_2.created = L7_2
  L5_2(L6_2)
  L5_2 = L3_2
  L6_2 = {}
  L7_2 = A0_2.cid
  L6_2.requester = L7_2
  L7_2 = A0_2.name
  L6_2.requester_name = L7_2
  L7_2 = A0_2.number
  L6_2.requester_phone = L7_2
  L6_2.service = "ems"
  L6_2.description = "Friend twisted an ankle at Muscle Beach, she can walk now."
  L7_2 = L4_2
  L8_2 = -1201.9
  L9_2 = -1568.5
  L10_2 = 4.6
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.coords = L7_2
  L6_2.status = "cancelled"
  L7_2 = A0_2.ago
  L8_2 = 9000
  L7_2 = L7_2(L8_2)
  L6_2.created = L7_2
  L5_2(L6_2)
  L5_2 = FW
  L5_2 = L5_2.GetPlayer
  L6_2 = A0_2.src
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2 or L6_2
  if L5_2 then
    L6_2 = L5_2.job
    if L6_2 then
      L6_2 = L5_2.job
      L6_2 = L6_2.name
    end
  end
  L7_2 = nil
  L8_2 = ipairs
  L9_2 = Config
  L9_2 = L9_2.Services
  if not L9_2 then
    L9_2 = {}
  end
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.job
    if L14_2 == L6_2 then
      L7_2 = L13_2
      break
    end
  end
  if not L7_2 then
    return
  end
  L8_2 = {}
  L9_2 = {}
  L10_2 = "Someone smashed my car window on Alta St, they ran toward the park."
  L11_2 = "Loud fight outside Bahama Mamas, two guys, one has a bat."
  L12_2 = "Suspicious van parked behind the Vespucci canals for two days."
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.police = L9_2
  L9_2 = {}
  L10_2 = "Cyclist down on Vinewood Blvd, conscious but bleeding."
  L11_2 = "My dad feels dizzy and has chest pain, Mirror Park."
  L12_2 = "Surfer hit his head at Vespucci Beach, lifeguard tower 3."
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.ems = L9_2
  L9_2 = {}
  L10_2 = "Car will not start outside the Bean Machine on Legion Square."
  L11_2 = "Overheating on the Senora Fwy, pulled over by the Ron sign."
  L12_2 = "Need a tow from the LSIA long-term lot, flat and dead battery."
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.mechanic = L9_2
  L9_2 = {}
  L10_2 = "Two people from Vinewood Bowl to Del Perro, now please."
  L11_2 = "Airport run, LSIA departures, three bags."
  L12_2 = "Pickup at Pillbox Medical, heading home to Mirror Park."
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.taxi = L9_2
  L9_2 = {}
  L10_2 = "Interested in the beach house in Chumash, can we see it this week?"
  L11_2 = "Looking for office space downtown, around 200 square meters."
  L12_2 = "Want to sell my apartment in Little Seoul, need a valuation."
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.realestate = L9_2
  L9_2 = {}
  L10_2 = "Order for pickup: 4 Bleeders, 2 large fries, 3 colas."
  L11_2 = "Birthday party for 8 kids on Sunday, can you cater?"
  L12_2 = "Do you deliver to the Vespucci police station? 6 meals."
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.burgershot = L9_2
  L9_2 = L7_2.id
  L9_2 = L8_2[L9_2]
  if not L9_2 then
    L9_2 = {}
    L10_2 = "Need help as soon as possible, I am at Legion Square."
    L11_2 = "Can someone call me back about a job?"
    L12_2 = "Urgent request near the Maze Bank."
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L9_2[3] = L12_2
  end
  L10_2 = {}
  L11_2 = L1_2.emma
  L12_2 = L1_2.leo
  L13_2 = L1_2.nina
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L11_2 = {}
  L12_2 = L4_2
  L13_2 = -158.2
  L14_2 = -930.1
  L15_2 = 29.2
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = L4_2
  L14_2 = -1388.0
  L15_2 = -586.6
  L16_2 = 30.2
  L13_2 = L13_2(L14_2, L15_2, L16_2)
  L14_2 = L4_2
  L15_2 = 1046.0
  L16_2 = -740.5
  L17_2 = 57.6
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L14_2(L15_2, L16_2, L17_2)
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L11_2[8] = L19_2
  L11_2[9] = L20_2
  L12_2 = 1
  L13_2 = 3
  L14_2 = 1
  for L15_2 = L12_2, L13_2, L14_2 do
    L16_2 = A0_2.insert
    L17_2 = "apex_phone_services"
    L18_2 = {}
    L19_2 = L10_2[L15_2]
    L19_2 = L19_2.cid
    L18_2.requester = L19_2
    L19_2 = L10_2[L15_2]
    L19_2 = L19_2.name
    L18_2.requester_name = L19_2
    L19_2 = L10_2[L15_2]
    L19_2 = L19_2.phone
    L18_2.requester_phone = L19_2
    L19_2 = L7_2.id
    L18_2.service = L19_2
    L19_2 = L9_2[L15_2]
    L18_2.description = L19_2
    L19_2 = L11_2[L15_2]
    L18_2.coords = L19_2
    L18_2.status = "pending"
    L19_2 = A0_2.ago
    L20_2 = L15_2 * 11
    L20_2 = 4 + L20_2
    L19_2 = L19_2(L20_2)
    L18_2.created = L19_2
    L16_2(L17_2, L18_2)
  end
end
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L1_2 = {}
  L2_2 = 12
  L3_2 = 48
  L4_2 = 95
  L5_2 = 180
  L6_2 = 310
  L7_2 = 420
  L8_2 = 600
  L9_2 = 840
  L10_2 = 1300
  L11_2 = 1500
  L12_2 = 1720
  L13_2 = 2600
  L14_2 = 2900
  L15_2 = 3400
  L16_2 = 4300
  L17_2 = 5100
  L18_2 = 6200
  L19_2 = 7000
  L20_2 = 8100
  L21_2 = 9300
  L22_2 = 11000
  L23_2 = 13500
  L24_2 = 17000
  L25_2 = 26000
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L1_2[6] = L7_2
  L1_2[7] = L8_2
  L1_2[8] = L9_2
  L1_2[9] = L10_2
  L1_2[10] = L11_2
  L1_2[11] = L12_2
  L1_2[12] = L13_2
  L1_2[13] = L14_2
  L1_2[14] = L15_2
  L1_2[15] = L16_2
  L1_2[16] = L17_2
  L1_2[17] = L18_2
  L1_2[18] = L19_2
  L1_2[19] = L20_2
  L1_2[20] = L21_2
  L1_2[21] = L22_2
  L1_2[22] = L23_2
  L1_2[23] = L24_2
  L1_2[24] = L25_2
  L2_2 = {}
  L2_2[2] = true
  L2_2[5] = true
  L2_2[9] = true
  L2_2[13] = true
  L2_2[18] = true
  L2_2[22] = true
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = 1080
    L10_2 = 1350
    L11_2 = L7_2 % 4
    if 0 == L11_2 then
      L11_2 = 1080
      L10_2 = 1920
      L9_2 = L11_2
    else
      L11_2 = L7_2 % 4
      if 2 == L11_2 then
        L11_2 = 1350
        L10_2 = 1080
        L9_2 = L11_2
      end
    end
    L11_2 = A0_2.insert
    L12_2 = "apex_phone_photos"
    L13_2 = {}
    L14_2 = A0_2.cid
    L13_2.owner = L14_2
    L14_2 = A0_2.img
    L15_2 = "apexlife"
    L16_2 = L7_2
    L15_2 = L15_2 .. L16_2
    L16_2 = L9_2
    L17_2 = L10_2
    L14_2 = L14_2(L15_2, L16_2, L17_2)
    L13_2.url = L14_2
    L14_2 = 1000 + L7_2
    L13_2.seed = L14_2
    L14_2 = L2_2[L7_2]
    if L14_2 then
      L14_2 = 1
      if L14_2 then
        goto lbl_81
      end
    end
    L14_2 = 0
    ::lbl_81::
    L13_2.favorite = L14_2
    L13_2.video = 0
    L14_2 = A0_2.ago
    L15_2 = L8_2
    L14_2 = L14_2(L15_2)
    L13_2.created = L14_2
    L11_2(L12_2, L13_2)
  end
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = A0_2.now
  L2_2 = L2_2 / 1000
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 * 1000
  L2_2 = {}
  L3_2 = {}
  L4_2 = "Grocery run"
  L5_2 = [[
Eggs, oat milk, sourdough, limes for Friday.
Coffee beans from Bean Machine (the dark roast).]]
  L6_2 = 35
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L4_2 = {}
  L5_2 = "Car stuff"
  L6_2 = [[
Oil change at 85k miles.
Ask Marcus about the brake squeal.
Tint is legal up to 35% in San Andreas.]]
  L7_2 = 300
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = "Weekend plan"
  L7_2 = [[
Sat 8am: Muscle Beach run with Chloe
Sat night: Luna at Bahama Mamas
Sun: brunch in Rockford Hills]]
  L8_2 = 1140
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = {}
  L7_2 = "Apartment hunt"
  L8_2 = [[
Sofia sent three listings:
1. Del Perro Heights, ocean view
2. Alta St, close to work
3. Vinewood Hills, needs work
Viewing Thursday at 6pm.]]
  L9_2 = 1800
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = "Gift ideas"
  L9_2 = [[
Mia: new camera strap
Jake: good coffee, obviously
Ava: spa day in Rockford Hills
Kai: anything with a battery]]
  L10_2 = 3120
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = "Gym split"
  L10_2 = "Mon push \194\183 Tue pull \194\183 Wed legs \194\183 Thu rest \194\183 Fri full body\nProtein after every session."
  L11_2 = 4800
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = "Studio wifi"
  L11_2 = [[
Network: VinewoodSound5G
Password is on the fridge, ask Luna.]]
  L12_2 = 8400
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2 * 1000
    L12_2 = L1_2 - L12_2
    L11_2.id = L12_2
    L12_2 = L9_2[1]
    L13_2 = "\n"
    L14_2 = L9_2[2]
    L12_2 = L12_2 .. L13_2 .. L14_2
    L11_2.text = L12_2
    L12_2 = A0_2.ago
    L13_2 = L9_2[3]
    L12_2 = L12_2(L13_2)
    L11_2.ts = L12_2
    L3_2[L10_2] = L11_2
  end
  L4_2 = L7_1
  L5_2 = A0_2
  L6_2 = "notes"
  L7_2 = L3_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = L10_1
  L5_2 = 0
  L6_2 = 18
  L7_2 = 30
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = A0_2.now
  L5_2 = L5_2 + 1800000
  L5_2 = L4_2 or L5_2
  if not (L4_2 > L5_2) or not L4_2 then
    L5_2 = L10_1
    L6_2 = 1
    L7_2 = 18
    L8_2 = 30
    L5_2 = L5_2(L6_2, L7_2, L8_2)
  end
  L6_2 = {}
  L7_2 = {}
  L8_2 = L1_2 - 101000
  L7_2.id = L8_2
  L7_2.text = "Pay the LSPD speeding ticket"
  L7_2.done = false
  L8_2 = A0_2.ago
  L9_2 = 120
  L8_2 = L8_2(L9_2)
  L7_2.ts = L8_2
  L8_2 = L10_1
  L9_2 = 1
  L10_2 = 10
  L11_2 = 0
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L7_2.due = L8_2
  L7_2.flag = true
  L7_2.notified = 0
  L8_2 = {}
  L9_2 = L1_2 - 102000
  L8_2.id = L9_2
  L8_2.text = "Pick up dry cleaning in Rockford Hills"
  L8_2.done = false
  L9_2 = A0_2.ago
  L10_2 = 300
  L9_2 = L9_2(L10_2)
  L8_2.ts = L9_2
  L8_2.due = L5_2
  L8_2.flag = false
  L8_2.notified = 0
  L9_2 = {}
  L10_2 = L1_2 - 103000
  L9_2.id = L10_2
  L9_2.text = "Call Pillbox about the ER bill"
  L9_2.done = false
  L10_2 = A0_2.ago
  L11_2 = 1320
  L10_2 = L10_2(L11_2)
  L9_2.ts = L10_2
  L9_2.due = 0
  L9_2.flag = false
  L9_2.notified = 0
  L10_2 = {}
  L11_2 = L1_2 - 104000
  L10_2.id = L11_2
  L10_2.text = "Renew registration at the DMV"
  L10_2.done = false
  L11_2 = A0_2.ago
  L12_2 = 2400
  L11_2 = L11_2(L12_2)
  L10_2.ts = L11_2
  L11_2 = L10_1
  L12_2 = 3
  L13_2 = 11
  L14_2 = 0
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L10_2.due = L11_2
  L10_2.flag = false
  L10_2.notified = 0
  L11_2 = {}
  L12_2 = L1_2 - 105000
  L11_2.id = L12_2
  L11_2.text = "Book a table at Bahama Mamas for Friday"
  L11_2.done = false
  L12_2 = A0_2.ago
  L13_2 = 360
  L12_2 = L12_2(L13_2)
  L11_2.ts = L12_2
  L11_2.due = 0
  L11_2.flag = true
  L11_2.notified = 0
  L12_2 = {}
  L13_2 = L1_2 - 106000
  L12_2.id = L13_2
  L12_2.text = "Return the floor jack to Marcus"
  L12_2.done = true
  L13_2 = A0_2.ago
  L14_2 = 4200
  L13_2 = L13_2(L14_2)
  L12_2.ts = L13_2
  L12_2.due = 0
  L12_2.flag = false
  L12_2.notified = 0
  L13_2 = {}
  L14_2 = L1_2 - 107000
  L13_2.id = L14_2
  L13_2.text = "Water the plants"
  L13_2.done = true
  L14_2 = A0_2.ago
  L15_2 = 1560
  L14_2 = L14_2(L15_2)
  L13_2.ts = L14_2
  L13_2.due = 0
  L13_2.flag = false
  L13_2.notified = 0
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L6_2[7] = L13_2
  L7_2 = L7_1
  L8_2 = A0_2
  L9_2 = "reminders"
  L10_2 = L6_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = {}
  L8_2 = "var(--blue)"
  L9_2 = "var(--red)"
  L10_2 = "var(--green)"
  L11_2 = "var(--orange)"
  L12_2 = "var(--purple)"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L8_2 = {}
  L9_2 = {}
  L10_2 = -3
  L11_2 = 21
  L12_2 = 0
  L13_2 = "Race night in Sandy Shores"
  L14_2 = 5
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L10_2 = {}
  L11_2 = -1
  L12_2 = 13
  L13_2 = 0
  L14_2 = "Team lunch at Burger Shot"
  L15_2 = 4
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L11_2 = {}
  L12_2 = 0
  L13_2 = 9
  L14_2 = 30
  L15_2 = "Coffee with Emma at Bean Machine"
  L16_2 = 4
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L12_2 = {}
  L13_2 = 0
  L14_2 = 19
  L15_2 = 0
  L16_2 = "Gym with Chloe"
  L17_2 = 3
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L12_2[4] = L16_2
  L12_2[5] = L17_2
  L13_2 = {}
  L14_2 = 1
  L15_2 = 11
  L16_2 = 0
  L17_2 = "Car service at Benny's"
  L18_2 = 4
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L14_2 = {}
  L15_2 = 1
  L16_2 = 15
  L17_2 = 0
  L18_2 = "Weazel News interview"
  L19_2 = 1
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L14_2[5] = L19_2
  L15_2 = {}
  L16_2 = 2
  L17_2 = 18
  L18_2 = 0
  L19_2 = "Apartment viewing in Del Perro"
  L20_2 = 3
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L15_2[4] = L19_2
  L15_2[5] = L20_2
  L16_2 = {}
  L17_2 = 4
  L18_2 = 22
  L19_2 = 0
  L20_2 = "Luna's set at Bahama Mamas"
  L21_2 = 5
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L16_2[4] = L20_2
  L16_2[5] = L21_2
  L17_2 = {}
  L18_2 = 6
  L19_2 = 10
  L20_2 = 30
  L21_2 = "Dentist at Pillbox Hill"
  L22_2 = 2
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L17_2[4] = L21_2
  L17_2[5] = L22_2
  L18_2 = {}
  L19_2 = 9
  L20_2 = 20
  L21_2 = 0
  L22_2 = "Kai's startup launch party"
  L23_2 = 1
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L18_2[4] = L22_2
  L18_2[5] = L23_2
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
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L8_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L10_1
    L17_2 = L15_2[1]
    L18_2 = L15_2[2]
    L19_2 = L15_2[3]
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L17_2 = #L9_2
    L17_2 = L17_2 + 1
    L18_2 = {}
    L19_2 = 200 + L14_2
    L19_2 = L19_2 * 1000
    L19_2 = L1_2 - L19_2
    L18_2.id = L19_2
    L19_2 = L9_1
    L20_2 = L15_2[1]
    L19_2 = L19_2(L20_2)
    L18_2.date = L19_2
    L19_2 = L15_2[4]
    L18_2.title = L19_2
    L19_2 = "%02d:%02d"
    L20_2 = L19_2
    L19_2 = L19_2.format
    L21_2 = L15_2[2]
    L22_2 = L15_2[3]
    L19_2 = L19_2(L20_2, L21_2, L22_2)
    L18_2.time = L19_2
    L19_2 = L15_2[5]
    L19_2 = L7_2[L19_2]
    L18_2.color = L19_2
    L19_2 = A0_2.now
    if L16_2 <= L19_2 then
      L19_2 = 1
      if L19_2 then
        goto lbl_357
      end
    end
    L19_2 = 0
    ::lbl_357::
    L18_2.notified = L19_2
    L9_2[L17_2] = L18_2
  end
  L10_2 = L7_1
  L11_2 = A0_2
  L12_2 = "events"
  L13_2 = L9_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = L7_1
  L11_2 = A0_2
  L12_2 = "alarms"
  L13_2 = {}
  L14_2 = {}
  L15_2 = L1_2 - 301000
  L14_2.id = L15_2
  L14_2.h = 6
  L14_2.m = 45
  L14_2.label = "Morning run"
  L14_2.on = true
  L15_2 = {}
  L16_2 = L1_2 - 302000
  L15_2.id = L16_2
  L15_2.h = 7
  L15_2.m = 30
  L15_2.label = "Work"
  L15_2.on = true
  L16_2 = {}
  L17_2 = L1_2 - 303000
  L16_2.id = L17_2
  L16_2.h = 9
  L16_2.m = 0
  L16_2.label = "Weekend sleep in"
  L16_2.on = false
  L17_2 = {}
  L18_2 = L1_2 - 304000
  L17_2.id = L18_2
  L17_2.h = 13
  L17_2.m = 0
  L17_2.label = "Lunch break"
  L17_2.on = false
  L18_2 = {}
  L19_2 = L1_2 - 305000
  L18_2.id = L19_2
  L18_2.h = 22
  L18_2.m = 30
  L18_2.label = "Wind down"
  L18_2.on = false
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = L7_1
  L11_2 = A0_2
  L12_2 = "cities"
  L13_2 = {}
  L14_2 = "Los Santos"
  L15_2 = "Nova Iorque"
  L16_2 = "Londres"
  L17_2 = "T\195\179quio"
  L18_2 = "Sydney"
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = {}
  L11_2 = {}
  L11_2.name = "Home"
  L11_2.x = -1447.4
  L11_2.y = -537.7
  L11_2.icon = "home"
  L11_2.color = "#30D158"
  L11_2.saved = true
  L12_2 = {}
  L12_2.name = "Work \194\183 Maze Bank Tower"
  L12_2.x = -75.2
  L12_2.y = -818.9
  L12_2.icon = "briefcase"
  L12_2.color = "#0A84FF"
  L12_2.saved = true
  L13_2 = {}
  L13_2.name = "Mia's studio"
  L13_2.x = -1067.0
  L13_2.y = -1080.0
  L13_2.icon = "sparkles"
  L13_2.color = "#BF5AF2"
  L13_2.saved = true
  L14_2 = {}
  L14_2.name = "Bean Machine, Vinewood"
  L14_2.x = -628.6
  L14_2.y = 239.3
  L14_2.icon = "pin"
  L14_2.color = "#FF9F0A"
  L14_2.saved = true
  L15_2 = {}
  L15_2.name = "Bahama Mamas"
  L15_2.x = -1388.0
  L15_2.y = -586.6
  L15_2.icon = "sparkles"
  L15_2.color = "#FF375F"
  L15_2.saved = true
  L16_2 = {}
  L16_2.name = "Muscle Beach gym"
  L16_2.x = -1201.9
  L16_2.y = -1568.5
  L16_2.icon = "sun"
  L16_2.color = "#FFD60A"
  L16_2.saved = true
  L17_2 = {}
  L17_2.name = "Mount Chiliad trailhead"
  L17_2.x = 501.8
  L17_2.y = 5604.3
  L17_2.icon = "nav"
  L17_2.color = "#00C7BE"
  L17_2.saved = true
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L10_2[7] = L17_2
  L11_2 = L7_1
  L12_2 = A0_2
  L13_2 = "places"
  L14_2 = L10_2
  L11_2(L12_2, L13_2, L14_2)
  L11_2 = MySQL
  L11_2 = L11_2.single
  L11_2 = L11_2.await
  L12_2 = "SELECT settings FROM apex_phone_accounts WHERE citizenid = ?"
  L13_2 = {}
  L14_2 = A0_2.cid
  L13_2[1] = L14_2
  L11_2 = L11_2(L12_2, L13_2)
  if L11_2 then
    L12_2 = pcall
    L13_2 = json
    L13_2 = L13_2.decode
    L14_2 = L11_2.settings
    if not L14_2 then
      L14_2 = "{}"
    end
    L12_2, L13_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      L14_2 = type
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      if "table" == L14_2 and L13_2 then
        goto lbl_526
      end
    end
    L14_2 = {}
    L13_2 = L14_2
    ::lbl_526::
    L14_2 = L6_1
    L15_2 = A0_2
    L16_2 = "places_acc"
    L17_2 = L13_2.places
    if nil ~= L17_2 then
      L17_2 = json
      L17_2 = L17_2.encode
      L18_2 = L13_2.places
      L17_2 = L17_2(L18_2)
      if L17_2 then
        goto lbl_539
      end
    end
    L17_2 = nil
    ::lbl_539::
    L14_2(L15_2, L16_2, L17_2)
    L14_2 = L8_1
    L15_2 = A0_2.cid
    function L16_2(A0_3)
      local L1_3
      L1_3 = L10_2
      A0_3.places = L1_3
    end
    L14_2(L15_2, L16_2)
  end
  L12_2 = L7_1
  L13_2 = A0_2
  L14_2 = "arcade"
  L15_2 = {}
  L15_2.snake = 64
  L15_2.g2048 = 9216
  L15_2.blocks = 18420
  L15_2.brick = 7350
  L15_2["mines:facil"] = 42
  L15_2["memory:8"] = 15
  L12_2(L13_2, L14_2, L15_2)
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = A0_2.byKey
  function L2_2(A0_3, A1_3, A2_3, A3_3)
    local L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L4_3 = L4_1
    L5_3 = A0_2
    L6_3 = "apex_phone_findmy"
    L7_3 = {}
    L7_3.owner = A0_3
    L7_3.target = A1_3
    L7_3.kind = A2_3
    L8_3 = A0_2.ago
    L9_3 = A3_3
    L8_3 = L8_3(L9_3)
    L7_3.created = L8_3
    L8_3 = {}
    L9_3 = "owner"
    L10_3 = "target"
    L11_3 = "kind"
    L8_3[1] = L9_3
    L8_3[2] = L10_3
    L8_3[3] = L11_3
    L4_3(L5_3, L6_3, L7_3, L8_3)
  end
  L3_2 = L2_2
  L4_2 = A0_2.cid
  L5_2 = L1_2.mia
  L5_2 = L5_2.cid
  L6_2 = "share"
  L7_2 = 12960
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = L2_2
  L4_2 = A0_2.cid
  L5_2 = L1_2.jake
  L5_2 = L5_2.cid
  L6_2 = "share"
  L7_2 = 10080
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = L2_2
  L4_2 = L1_2.mia
  L4_2 = L4_2.cid
  L5_2 = A0_2.cid
  L6_2 = "share"
  L7_2 = 12960
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = L2_2
  L4_2 = L1_2.jake
  L4_2 = L4_2.cid
  L5_2 = A0_2.cid
  L6_2 = "share"
  L7_2 = 8640
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = L2_2
  L4_2 = L1_2.chloe
  L4_2 = L4_2.cid
  L5_2 = A0_2.cid
  L6_2 = "share"
  L7_2 = 4320
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = L2_2
  L4_2 = L1_2.ryan
  L4_2 = L4_2.cid
  L5_2 = A0_2.cid
  L6_2 = "req"
  L7_2 = 18
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
function L21_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L1_2 = Config
  L1_2 = L1_2.Music
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = L1_2.Provider
  if nil ~= L2_2 and "" ~= L2_2 and "internal" ~= L2_2 then
    return
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L1_2.Library
  if not L6_2 then
    L6_2 = {}
  end
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = tostring
    L12_2 = L10_2.vid
    if not L12_2 then
      L12_2 = ""
    end
    L11_2 = L11_2(L12_2)
    if "" ~= L11_2 then
      L12_2 = "yt:"
      L13_2 = L11_2
      L12_2 = L12_2 .. L13_2
      L13_2 = {}
      L13_2.id = L12_2
      L13_2.vid = L11_2
      L14_2 = L10_2.t
      if not L14_2 then
        L14_2 = "Track "
        L15_2 = L9_2
        L14_2 = L14_2 .. L15_2
      end
      L13_2.t = L14_2
      L14_2 = L10_2.a
      if not L14_2 then
        L14_2 = ""
      end
      L13_2.a = L14_2
      L14_2 = L10_2.alb
      if not L14_2 then
        L14_2 = ""
      end
      L13_2.alb = L14_2
      L14_2 = tonumber
      L15_2 = L10_2.len
      L14_2 = L14_2(L15_2)
      if not L14_2 then
        L14_2 = 0
      end
      L13_2.len = L14_2
      L14_2 = "https://i.ytimg.com/vi/"
      L15_2 = L11_2
      L16_2 = "/mqdefault.jpg"
      L14_2 = L14_2 .. L15_2 .. L16_2
      L13_2.img = L14_2
      L3_2[L12_2] = L13_2
      L13_2 = #L4_2
      L13_2 = L13_2 + 1
      L4_2[L13_2] = L12_2
    end
  end
  L5_2 = #L4_2
  if 0 == L5_2 then
    return
  end
  function L5_2(...)
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = {}
    L1_3 = ipairs
    L2_3 = {}
    L3_3, L4_3, L5_3, L6_3, L7_3, L8_3 = ...
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L2_3[5] = L7_3
    L2_3[6] = L8_3
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = L4_2
      L7_3 = L7_3[L6_3]
      if L7_3 then
        L7_3 = #L0_3
        L7_3 = L7_3 + 1
        L8_3 = L4_2
        L8_3 = L8_3[L6_3]
        L0_3[L7_3] = L8_3
      end
    end
    return L0_3
  end
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = A0_2.now
  L7_2 = L7_2 / 1000
  L6_2 = L6_2(L7_2)
  L7_2 = {}
  L7_2.v = 4
  L7_2.songs = L3_2
  L7_2.seeded = true
  L8_2 = L5_2
  L9_2 = 4
  L10_2 = 6
  L11_2 = 2
  L12_2 = 5
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  L7_2.likes = L8_2
  L8_2 = L5_2
  L9_2 = 1
  L10_2 = 2
  L11_2 = 3
  L12_2 = 4
  L13_2 = 5
  L14_2 = 6
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2.lib = L8_2
  L8_2 = L5_2
  L9_2 = 6
  L10_2 = 4
  L11_2 = 5
  L12_2 = 2
  L13_2 = 1
  L14_2 = 3
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2.recents = L8_2
  L8_2 = {}
  L7_2.queue = L8_2
  L8_2 = {}
  L9_2 = {}
  L9_2.id = "pscdrive"
  L9_2.name = "Late Night Drive"
  L9_2.note = "Great Ocean Hwy, windows down"
  L9_2.art = 2
  L10_2 = L6_2 - 518400
  L9_2.made = L10_2
  L10_2 = L5_2
  L11_2 = 5
  L12_2 = 6
  L13_2 = 4
  L14_2 = 2
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L9_2.tracks = L10_2
  L10_2 = {}
  L10_2.id = "pscgym"
  L10_2.name = "Muscle Beach Mornings"
  L10_2.note = "No skipping leg day"
  L10_2.art = 4
  L11_2 = L6_2 - 259200
  L10_2.made = L11_2
  L11_2 = L5_2
  L12_2 = 6
  L13_2 = 3
  L14_2 = 2
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L10_2.tracks = L11_2
  L11_2 = {}
  L11_2.id = "pscfriday"
  L11_2.name = "Bahama Mamas Fridays"
  L11_2.note = "Pregame playlist"
  L11_2.art = 1
  L12_2 = L6_2 - 86400
  L11_2.made = L12_2
  L12_2 = L5_2
  L13_2 = 3
  L14_2 = 1
  L15_2 = 6
  L16_2 = 4
  L17_2 = 5
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L11_2.tracks = L12_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L7_2.playlists = L8_2
  L8_2 = MySQL
  L8_2 = L8_2.single
  L8_2 = L8_2.await
  L9_2 = "SELECT data FROM apex_phone_music WHERE citizenid = ?"
  L10_2 = {}
  L11_2 = A0_2.cid
  L10_2[1] = L11_2
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = L6_1
  L10_2 = A0_2
  L11_2 = "music"
  if L8_2 then
    L12_2 = L8_2.data
    if L12_2 then
      goto lbl_193
    end
  end
  L12_2 = nil
  ::lbl_193::
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = json
  L9_2 = L9_2.encode
  L10_2 = L7_2
  L9_2 = L9_2(L10_2)
  if L8_2 then
    L10_2 = MySQL
    L10_2 = L10_2.update
    L10_2 = L10_2.await
    L11_2 = "UPDATE apex_phone_music SET data = ?, updated = ? WHERE citizenid = ?"
    L12_2 = {}
    L13_2 = L9_2
    L14_2 = A0_2.now
    L15_2 = A0_2.cid
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L12_2[3] = L15_2
    L10_2(L11_2, L12_2)
  else
    L10_2 = MySQL
    L10_2 = L10_2.insert
    L10_2 = L10_2.await
    L11_2 = "INSERT INTO apex_phone_music (citizenid, data, updated) VALUES (?, ?, ?)"
    L12_2 = {}
    L13_2 = A0_2.cid
    L14_2 = L9_2
    L15_2 = A0_2.now
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L12_2[3] = L15_2
    L10_2(L11_2, L12_2)
  end
  L10_2 = A0_2.count
  L10_2 = L10_2 + 1
  A0_2.count = L10_2
end
function L22_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = {}
  L4_2 = "mia"
  L5_2 = 5
  L6_2 = "My whole portfolio lives here"
  L7_2 = "Filters are gorgeous and the stories editor is the best in the city. Golden hour posts get so much love."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "luna"
  L6_2 = 5
  L7_2 = "Obsessed"
  L8_2 = "Posting my Bahama Mamas sets every Friday. Close friends list is a lifesaver."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "chloe"
  L7_2 = 4
  L8_2 = "Great for fitness content"
  L9_2 = "Would love longer videos, but the reels look amazing."
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "nina"
  L8_2 = 5
  L9_2 = ""
  L10_2 = ""
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L7_2 = {}
  L8_2 = "sofia"
  L9_2 = 4
  L10_2 = ""
  L11_2 = ""
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L8_2 = {}
  L9_2 = "emma"
  L10_2 = 5
  L11_2 = "Latte art heaven"
  L12_2 = "My cafe page doubled its followers in a month."
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L9_2 = {}
  L10_2 = "kai"
  L11_2 = 4
  L12_2 = ""
  L13_2 = ""
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L1_2.instashot = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "nina"
  L5_2 = 5
  L6_2 = "Breaking news, first"
  L7_2 = "Fastest way to know what is happening in Los Santos. I break stories here before they air."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "derek"
  L6_2 = 4
  L7_2 = "Useful, a bit loud"
  L8_2 = "Great for news, the comment section can get spicy."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "jake"
  L7_2 = 4
  L8_2 = ""
  L9_2 = ""
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "kai"
  L8_2 = 5
  L9_2 = "Where the city talks"
  L10_2 = "Every startup announcement in Little Seoul starts here."
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L7_2 = {}
  L8_2 = "tyler"
  L9_2 = 3
  L10_2 = ""
  L11_2 = ""
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L8_2 = {}
  L9_2 = "leo"
  L10_2 = 4
  L11_2 = ""
  L12_2 = ""
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L1_2.twix = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "ava"
  L5_2 = 5
  L6_2 = "Reliable on night shifts"
  L7_2 = "Group chats with the Pillbox team never miss a beat. Voice notes are crystal clear."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "ryan"
  L6_2 = 5
  L7_2 = "Use it all day"
  L8_2 = "Customers send me their pickup pin and I am there. Simple and fast."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "jake"
  L7_2 = 5
  L8_2 = ""
  L9_2 = ""
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "marcus"
  L8_2 = 4
  L9_2 = "Solid"
  L10_2 = "Would like bigger photo previews, but it just works."
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L7_2 = {}
  L8_2 = "emma"
  L9_2 = 5
  L10_2 = ""
  L11_2 = ""
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L8_2 = {}
  L9_2 = "sofia"
  L10_2 = 5
  L11_2 = ""
  L12_2 = ""
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L9_2 = {}
  L10_2 = "mia"
  L11_2 = 4
  L12_2 = ""
  L13_2 = ""
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L10_2 = {}
  L11_2 = "leo"
  L12_2 = 5
  L13_2 = ""
  L14_2 = ""
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L2_2[8] = L10_2
  L1_2.recado = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "tyler"
  L5_2 = 4
  L6_2 = "Met someone at the pier"
  L7_2 = "Swiped right on a Saturday, coffee on Sunday. Not bad at all."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "luna"
  L6_2 = 3
  L7_2 = "Fun but chaotic"
  L8_2 = "Lots of matches, half of them just want guest list spots."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "emma"
  L7_2 = 5
  L8_2 = ""
  L9_2 = ""
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "chloe"
  L8_2 = 4
  L9_2 = "Cute profiles"
  L10_2 = "The prompt cards make starting a chat easy."
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L7_2 = {}
  L8_2 = "ryan"
  L9_2 = 4
  L10_2 = ""
  L11_2 = ""
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L1_2.match = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "marcus"
  L5_2 = 5
  L6_2 = "Sold three project cars"
  L7_2 = "Photos look great and buyers actually show up. Best place for parts in Los Santos."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "sofia"
  L6_2 = 4
  L7_2 = "Good for furniture"
  L8_2 = "Furnished a whole Del Perro apartment for staging. Wish it had more filters."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "kai"
  L7_2 = 4
  L8_2 = ""
  L9_2 = ""
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "leo"
  L8_2 = 5
  L9_2 = ""
  L10_2 = ""
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L7_2 = {}
  L8_2 = "derek"
  L9_2 = 4
  L10_2 = ""
  L11_2 = ""
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L8_2 = {}
  L9_2 = "tyler"
  L10_2 = 5
  L11_2 = "Rims for days"
  L12_2 = "Found a set of chrome rims in an hour."
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L1_2.marketplace = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "leo"
  L5_2 = 5
  L6_2 = "Biased, but true"
  L7_2 = "Burger Shot orders come in nonstop. Tracking the courier on the map is so smooth."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "ava"
  L6_2 = 5
  L7_2 = "Saves my night shifts"
  L8_2 = "Hot ramen to the Pillbox break room at 3am. Enough said."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "chloe"
  L7_2 = 4
  L8_2 = "Healthy options please"
  L9_2 = "Love the poke bowls, need more salad places."
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "ryan"
  L8_2 = 5
  L9_2 = ""
  L10_2 = ""
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L7_2 = {}
  L8_2 = "nina"
  L9_2 = 4
  L10_2 = ""
  L11_2 = ""
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L8_2 = {}
  L9_2 = "jake"
  L10_2 = 5
  L11_2 = "Coffee on patrol"
  L12_2 = "Bean Machine to Mission Row in 15 minutes."
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L9_2 = {}
  L10_2 = "mia"
  L11_2 = 4
  L12_2 = ""
  L13_2 = ""
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L10_2 = {}
  L11_2 = "kai"
  L12_2 = 5
  L13_2 = ""
  L14_2 = ""
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L2_2[8] = L10_2
  L1_2.eats = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "marcus"
  L5_2 = 5
  L6_2 = "Every customer should have this"
  L7_2 = "Shows engine and body health so I know what I am walking into."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "tyler"
  L6_2 = 5
  L7_2 = "Locate my car in one tap"
  L8_2 = "Never lose the Banshee at the LSIA lot again."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "sofia"
  L7_2 = 4
  L8_2 = ""
  L9_2 = ""
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "derek"
  L8_2 = 4
  L9_2 = ""
  L10_2 = ""
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L1_2.garage = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "ryan"
  L5_2 = 5
  L6_2 = "Fares come straight to my phone"
  L7_2 = "Accept, waypoint, done. Taxi work has never been easier."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "jake"
  L6_2 = 4
  L7_2 = "Good for dispatch"
  L8_2 = "Calls come with a location most of the time. Please always share your location, folks."
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "ava"
  L7_2 = 5
  L8_2 = ""
  L9_2 = ""
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L6_2 = {}
  L7_2 = "marcus"
  L8_2 = 4
  L9_2 = ""
  L10_2 = ""
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L1_2.services = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "kai"
  L5_2 = 4
  L6_2 = "Escrow works"
  L7_2 = "Payment is only released when you confirm, so nobody gets burned."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "tyler"
  L6_2 = 4
  L7_2 = ""
  L8_2 = ""
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "derek"
  L7_2 = 3
  L8_2 = "Use with care"
  L9_2 = "Read the seller reviews before buying anything."
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L1_2.onion = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "luna"
  L5_2 = 4
  L6_2 = "Keeps the city honest"
  L7_2 = "Best place to hear about road closures and parties first."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "tyler"
  L6_2 = 5
  L7_2 = ""
  L8_2 = ""
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "nina"
  L7_2 = 4
  L8_2 = "Great for tips"
  L9_2 = "A reporter never reveals sources."
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L1_2.darkchat = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "kai"
  L5_2 = 5
  L6_2 = "Clean wallet"
  L7_2 = "The chart is smooth and fees are clearly shown before you buy."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "derek"
  L6_2 = 3
  L7_2 = ""
  L8_2 = ""
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "tyler"
  L7_2 = 4
  L8_2 = "Bought the dip"
  L9_2 = "Sold the next day for a small win."
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L1_2.crypto = L2_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = "chloe"
  L5_2 = 5
  L6_2 = "Running buddy tracker"
  L7_2 = "I always know where my clients are on the beach."
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L4_2 = {}
  L5_2 = "mia"
  L6_2 = 4
  L7_2 = ""
  L8_2 = ""
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L5_2 = {}
  L6_2 = "jake"
  L7_2 = 5
  L8_2 = ""
  L9_2 = ""
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L1_2.findmy = L2_2
  L2_2 = A0_2.byKey
  L3_2 = 0
  L4_2 = pairs
  L5_2 = L1_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = ipairs
    L11_2 = L9_2
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L3_2 = L3_2 + 1
      L16_2 = L15_2[1]
      L16_2 = L2_2[L16_2]
      if L16_2 then
        L17_2 = L4_1
        L18_2 = A0_2
        L19_2 = "apex_phone_app_ratings"
        L20_2 = {}
        L21_2 = L16_2.cid
        L20_2.owner = L21_2
        L20_2.app = L8_2
        L21_2 = L15_2[2]
        L20_2.stars = L21_2
        L21_2 = L15_2[3]
        if "" ~= L21_2 then
          L21_2 = L15_2[3]
          if L21_2 then
            goto lbl_504
          end
        end
        L21_2 = nil
        ::lbl_504::
        L20_2.title = L21_2
        L21_2 = L15_2[4]
        if "" ~= L21_2 then
          L21_2 = L15_2[4]
          if L21_2 then
            goto lbl_512
          end
        end
        L21_2 = nil
        ::lbl_512::
        L20_2.text = L21_2
        L21_2 = L16_2.username
        L20_2.username = L21_2
        L21_2 = A0_2.ago
        L22_2 = L3_2 * 397
        L22_2 = L22_2 % 17280
        L22_2 = 30 + L22_2
        L21_2 = L21_2(L22_2)
        L20_2.created = L21_2
        L21_2 = {}
        L22_2 = "owner"
        L23_2 = "app"
        L21_2[1] = L22_2
        L21_2[2] = L23_2
        L17_2(L18_2, L19_2, L20_2, L21_2)
      end
    end
  end
end
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L1_2 = pcall
  L2_2 = FW
  L2_2 = L2_2.GetVehicles
  L3_2 = A0_2.cid
  L4_2 = true
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_15
    end
  end
  do return end
  ::lbl_15::
  L3_2 = {}
  L4_2 = "Daily driver"
  L5_2 = "Weekend toy"
  L6_2 = "Track day build"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L4_2 = 0
  L5_2 = ipairs
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L3_2
    if L4_2 >= L11_2 then
      break
    end
    L11_2 = L10_2.plate
    if L11_2 then
      L11_2 = tostring
      L12_2 = L10_2.plate
      L11_2 = L11_2(L12_2)
      if L11_2 then
        goto lbl_38
      end
    end
    L11_2 = nil
    ::lbl_38::
    if L11_2 and "" ~= L11_2 then
      L12_2 = #L11_2
      if L12_2 <= 16 then
        L12_2 = MySQL
        L12_2 = L12_2.scalar
        L12_2 = L12_2.await
        L13_2 = "SELECT 1 FROM apex_phone_garage_meta WHERE plate = ? AND owner = ?"
        L14_2 = {}
        L15_2 = L11_2
        L16_2 = A0_2.cid
        L14_2[1] = L15_2
        L14_2[2] = L16_2
        L12_2 = L12_2(L13_2, L14_2)
        if not L12_2 then
          L4_2 = L4_2 + 1
          L13_2 = L4_1
          L14_2 = A0_2
          L15_2 = "apex_phone_garage_meta"
          L16_2 = {}
          L16_2.plate = L11_2
          L17_2 = A0_2.cid
          L16_2.owner = L17_2
          L17_2 = L3_2[L4_2]
          L16_2.nickname = L17_2
          if 1 == L4_2 then
            L17_2 = 1
            if L17_2 then
              goto lbl_75
            end
          end
          L17_2 = 0
          ::lbl_75::
          L16_2.favorite = L17_2
          L17_2 = {}
          L18_2 = "plate"
          L19_2 = "owner"
          L17_2[1] = L18_2
          L17_2[2] = L19_2
          L13_2(L14_2, L15_2, L16_2, L17_2)
        end
      end
    end
  end
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = "wallet"
  L4_2 = L11_1
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L3_2 = {}
  L4_2 = "bills"
  L5_2 = L12_1
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L4_2 = {}
  L5_2 = "crypto"
  L6_2 = L13_1
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L5_2 = {}
  L6_2 = "onion"
  L7_2 = L14_1
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L6_2 = {}
  L7_2 = "darkchat"
  L8_2 = L15_1
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L7_2 = {}
  L8_2 = "eats"
  L9_2 = L16_1
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L8_2 = {}
  L9_2 = "services"
  L10_2 = L17_1
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L9_2 = {}
  L10_2 = "photos"
  L11_2 = L18_1
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = {}
  L11_2 = "userdata"
  L12_2 = L19_1
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L11_2 = {}
  L12_2 = "findmy"
  L13_2 = L20_1
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L12_2 = {}
  L13_2 = "music"
  L14_2 = L21_1
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L13_2 = {}
  L14_2 = "ratings"
  L15_2 = L22_1
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L14_2 = {}
  L15_2 = "garage"
  L16_2 = L23_1
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L1_2[6] = L7_2
  L1_2[7] = L8_2
  L1_2[8] = L9_2
  L1_2[9] = L10_2
  L1_2[10] = L11_2
  L1_2[11] = L12_2
  L1_2[12] = L13_2
  L1_2[13] = L14_2
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = pcall
    L9_2 = L7_2[2]
    L10_2 = A0_2
    L8_2, L9_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L10_2 = print
      L11_2 = "^1[Unique_Phone showcase]^0 life/%s: %s"
      L12_2 = L11_2
      L11_2 = L11_2.format
      L13_2 = L7_2[1]
      L14_2 = tostring
      L15_2 = L9_2
      L14_2, L15_2, L16_2 = L14_2(L15_2)
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
      L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    end
  end
  L2_2 = A0_2.count
  return L2_2
end
function L25_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT owner, k, v FROM apex_phone_userdata WHERE k LIKE 'scbak\\_%'"
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = pcall
    function L9_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
      L0_3 = tostring
      L1_3 = L7_2.k
      L0_3 = L0_3(L1_3)
      L1_3 = L0_3
      L0_3 = L0_3.sub
      L2_3 = L0_1
      L2_3 = #L2_3
      L2_3 = L2_3 + 1
      L0_3 = L0_3(L1_3, L2_3)
      L1_3 = pcall
      L2_3 = json
      L2_3 = L2_3.decode
      L3_3 = L7_2.v
      if not L3_3 then
        L3_3 = "{}"
      end
      L1_3, L2_3 = L1_3(L2_3, L3_3)
      if L1_3 then
        L3_3 = type
        L4_3 = L2_3
        L3_3 = L3_3(L4_3)
        if "table" == L3_3 and L2_3 then
          goto lbl_30
        end
      end
      L3_3 = {}
      L2_3 = L3_3
      ::lbl_30::
      L3_3 = L2_3.had
      if L3_3 then
        L3_3 = L2_3.v
        if L3_3 then
          goto lbl_37
        end
      end
      L3_3 = nil
      ::lbl_37::
      L5_3 = L0_3
      L4_3 = L0_3.match
      L6_3 = "^ud_(.+)$"
      L4_3 = L4_3(L5_3, L6_3)
      if L4_3 then
        L5_3 = L3_3 or L5_3
        if not L3_3 then
          L5_3 = L1_1
          L5_3 = L5_3[L4_3]
          if not L5_3 then
            L5_3 = "[]"
          end
        end
        L6_3 = MySQL
        L6_3 = L6_3.scalar
        L6_3 = L6_3.await
        L7_3 = "SELECT 1 FROM apex_phone_userdata WHERE owner = ? AND k = ?"
        L8_3 = {}
        L9_3 = L7_2.owner
        L10_3 = L4_3
        L8_3[1] = L9_3
        L8_3[2] = L10_3
        L6_3 = L6_3(L7_3, L8_3)
        if L6_3 then
          L6_3 = MySQL
          L6_3 = L6_3.update
          L6_3 = L6_3.await
          L7_3 = "UPDATE apex_phone_userdata SET v = ?, updated = ? WHERE owner = ? AND k = ?"
          L8_3 = {}
          L9_3 = L5_3
          L10_3 = A0_2.now
          L11_3 = L7_2.owner
          L12_3 = L4_3
          L8_3[1] = L9_3
          L8_3[2] = L10_3
          L8_3[3] = L11_3
          L8_3[4] = L12_3
          L6_3(L7_3, L8_3)
        else
          L6_3 = MySQL
          L6_3 = L6_3.insert
          L6_3 = L6_3.await
          L7_3 = "INSERT INTO apex_phone_userdata (owner, k, v, updated) VALUES (?, ?, ?, ?)"
          L8_3 = {}
          L9_3 = L7_2.owner
          L10_3 = L4_3
          L11_3 = L5_3
          L12_3 = A0_2.now
          L8_3[1] = L9_3
          L8_3[2] = L10_3
          L8_3[3] = L11_3
          L8_3[4] = L12_3
          L6_3(L7_3, L8_3)
        end
      elseif "music" == L0_3 then
        L5_3 = L3_3 or L5_3
        if not L3_3 then
          L5_3 = L2_1
        end
        L6_3 = MySQL
        L6_3 = L6_3.scalar
        L6_3 = L6_3.await
        L7_3 = "SELECT 1 FROM apex_phone_music WHERE citizenid = ?"
        L8_3 = {}
        L9_3 = L7_2.owner
        L8_3[1] = L9_3
        L6_3 = L6_3(L7_3, L8_3)
        if L6_3 then
          L6_3 = MySQL
          L6_3 = L6_3.update
          L6_3 = L6_3.await
          L7_3 = "UPDATE apex_phone_music SET data = ?, updated = ? WHERE citizenid = ?"
          L8_3 = {}
          L9_3 = L5_3
          L10_3 = A0_2.now
          L11_3 = L7_2.owner
          L8_3[1] = L9_3
          L8_3[2] = L10_3
          L8_3[3] = L11_3
          L6_3(L7_3, L8_3)
        else
          L6_3 = MySQL
          L6_3 = L6_3.insert
          L6_3 = L6_3.await
          L7_3 = "INSERT INTO apex_phone_music (citizenid, data, updated) VALUES (?, ?, ?)"
          L8_3 = {}
          L9_3 = L7_2.owner
          L10_3 = L5_3
          L11_3 = A0_2.now
          L8_3[1] = L9_3
          L8_3[2] = L10_3
          L8_3[3] = L11_3
          L6_3(L7_3, L8_3)
        end
      elseif "crypto" == L0_3 then
        if L3_3 then
          L5_3 = MySQL
          L5_3 = L5_3.update
          L5_3 = L5_3.await
          L6_3 = "UPDATE apex_phone_crypto SET bal = ? WHERE citizenid = ?"
          L7_3 = {}
          L8_3 = tonumber
          L9_3 = L3_3
          L8_3 = L8_3(L9_3)
          if not L8_3 then
            L8_3 = 0
          end
          L9_3 = L7_2.owner
          L7_3[1] = L8_3
          L7_3[2] = L9_3
          L5_3(L6_3, L7_3)
        else
          L5_3 = MySQL
          L5_3 = L5_3.update
          L5_3 = L5_3.await
          L6_3 = "DELETE FROM apex_phone_crypto WHERE citizenid = ?"
          L7_3 = {}
          L8_3 = L7_2.owner
          L7_3[1] = L8_3
          L5_3(L6_3, L7_3)
        end
      elseif "places_acc" == L0_3 then
        L5_3 = pcall
        L6_3 = json
        L6_3 = L6_3.decode
        L7_3 = L3_3 or L7_3
        if not L3_3 then
          L7_3 = "[]"
        end
        L5_3, L6_3 = L5_3(L6_3, L7_3)
        L7_3 = L8_1
        L8_3 = L7_2.owner
        function L9_3(A0_4)
          local L1_4, L2_4
          L1_4 = L5_3
          if L1_4 then
            L1_4 = type
            L2_4 = L6_3
            L1_4 = L1_4(L2_4)
            if "table" == L1_4 then
              L1_4 = L6_3
              if L1_4 then
                goto lbl_14
              end
            end
          end
          L1_4 = {}
          ::lbl_14::
          A0_4.places = L1_4
        end
        L7_3(L8_3, L9_3)
      end
    end
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L9_2 = print
      L10_2 = "^1[Unique_Phone showcase]^0 life clear: could not restore %s of %s"
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = tostring
      L13_2 = L7_2.k
      L12_2 = L12_2(L13_2)
      L13_2 = tostring
      L14_2 = L7_2.owner
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L13_2(L14_2)
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    end
    L9_2 = MySQL
    L9_2 = L9_2.update
    L9_2 = L9_2.await
    L10_2 = "DELETE FROM apex_phone_userdata WHERE owner = ? AND k = ?"
    L11_2 = {}
    L12_2 = L7_2.owner
    L13_2 = L7_2.k
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L9_2(L10_2, L11_2)
  end
  L2_2 = "SHOWCASE\\_%"
  L3_2 = {}
  L4_2 = "DELETE FROM apex_phone_crypto WHERE citizenid LIKE ?"
  L5_2 = "DELETE FROM apex_phone_crypto_hist WHERE owner LIKE ?"
  L6_2 = "DELETE FROM apex_phone_onion_orders WHERE (buyer LIKE ? OR seller LIKE ?)"
  L7_2 = "DELETE FROM apex_phone_onion WHERE owner LIKE ?"
  L8_2 = "DELETE FROM apex_phone_onion_id WHERE citizenid LIKE ?"
  L9_2 = "DELETE FROM apex_phone_findmy WHERE (owner LIKE ? OR target LIKE ?)"
  L10_2 = "DELETE FROM apex_phone_app_ratings WHERE owner LIKE ?"
  L11_2 = "DELETE FROM apex_phone_services WHERE requester LIKE ?"
  L12_2 = "DELETE FROM apex_phone_darkchat_members WHERE citizenid LIKE ?"
  L13_2 = "DELETE FROM apex_phone_transactions WHERE owner LIKE ?"
  L14_2 = "DELETE FROM apex_phone_bills WHERE (owner LIKE ? OR sender_cid LIKE ?)"
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
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L11_2 = L9_2
    L10_2 = L9_2.gsub
    L12_2 = "%?"
    L13_2 = ""
    L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2)
    L12_2 = {}
    L13_2 = 1
    L14_2 = L11_2
    L15_2 = 1
    for L16_2 = L13_2, L14_2, L15_2 do
      L12_2[L16_2] = L2_2
    end
    L13_2 = pcall
    L14_2 = MySQL
    L14_2 = L14_2.update
    L14_2 = L14_2.await
    L15_2 = L9_2
    L16_2 = L12_2
    L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2)
    if not L13_2 then
      L15_2 = print
      L16_2 = "^3[Unique_Phone showcase]^0 life clear: %s"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = tostring
      L19_2 = L14_2
      L18_2, L19_2 = L18_2(L19_2)
      L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2, L18_2, L19_2)
      L15_2(L16_2, L17_2, L18_2, L19_2)
    end
  end
end
L26_1 = Showcase
L26_1 = L26_1.register
L27_1 = "life"
L28_1 = 40
L29_1 = L24_1
L30_1 = L25_1
L26_1(L27_1, L28_1, L29_1, L30_1)
