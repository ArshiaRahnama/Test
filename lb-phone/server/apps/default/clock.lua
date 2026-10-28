local L0_1, L1_1, L2_1, L3_1
L0_1 = BaseCallback
L1_1 = "clock:getAlarms"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT id, hours, minutes, label, enabled FROM phone_clock_alarms WHERE phone_number = ?"
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  return L2_2(L3_2, L4_2)
end
L3_1 = {}
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "clock:createAlarm"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2
  L5_2 = MySQL
  L5_2 = L5_2.insert
  L5_2 = L5_2.await
  L6_2 = "INSERT INTO phone_clock_alarms (phone_number, hours, minutes, label) VALUES (@phoneNumber, @hours, @minutes, @label)"
  L7_2 = {}
  L7_2["@phoneNumber"] = A1_2
  L7_2["@hours"] = A3_2
  L7_2["@minutes"] = A4_2
  L7_2["@label"] = A2_2
  return L5_2(L6_2, L7_2)
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "clock:deleteAlarm"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_clock_alarms WHERE id = ? AND phone_number = ?"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  return L3_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "clock:toggleAlarm"
function L2_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE phone_clock_alarms SET enabled = ? WHERE id = ? AND phone_number = ?"
  L6_2 = {}
  L7_2 = true == A3_2
  L8_2 = A2_2
  L9_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2(L5_2, L6_2)
  return A3_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "clock:updateAlarm"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE phone_clock_alarms SET label = ?, hours = ?, minutes = ? WHERE id = ? AND phone_number = ?"
  L8_2 = {}
  L9_2 = A3_2
  L10_2 = A4_2
  L11_2 = A5_2
  L12_2 = A2_2
  L13_2 = A1_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L6_2 = L6_2(L7_2, L8_2)
  L6_2 = L6_2 > 0
  return L6_2
end
L0_1(L1_1, L2_1)
