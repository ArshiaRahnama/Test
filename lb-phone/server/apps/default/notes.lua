local L0_1, L1_1, L2_1
L0_1 = BaseCallback
L1_1 = "notes:createNote"
function L2_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT INTO phone_notes (phone_number, title, content) VALUES (?, ?, ?)"
  L6_2 = {}
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  return L4_2(L5_2, L6_2)
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "notes:saveNote"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE phone_notes SET title = ?, content = ? WHERE id = ? AND phone_number = ?"
  L7_2 = {}
  L8_2 = A3_2
  L9_2 = A4_2
  L10_2 = A2_2
  L11_2 = A1_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  L5_2 = L5_2 > 0
  return L5_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "notes:removeNote"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_notes WHERE id = ? AND phone_number = ?"
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
L1_1 = "notes:getNotes"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT id, title, content, `timestamp` FROM phone_notes WHERE phone_number = ?"
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  return L2_2(L3_2, L4_2)
end
L0_1(L1_1, L2_1)
