local L0_1, L1_1, L2_1, L3_1
L0_1 = BaseCallback
L1_1 = "maps:getSavedLocations"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT id, `name`, x_pos, y_pos FROM phone_maps_locations WHERE phone_number = ? ORDER BY `name` ASC"
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = 1
  L4_2 = #L2_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = L2_2[L6_2]
    L8_2 = {}
    L9_2 = L7_2.id
    L8_2.id = L9_2
    L9_2 = L7_2.name
    L8_2.name = L9_2
    L9_2 = {}
    L10_2 = L7_2.y_pos
    L11_2 = L7_2.x_pos
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L8_2.position = L9_2
    L2_2[L6_2] = L8_2
  end
  return L2_2
end
L3_1 = {}
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "maps:addLocation"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L5_2 = MySQL
  L5_2 = L5_2.insert
  L5_2 = L5_2.await
  L6_2 = "INSERT INTO phone_maps_locations (phone_number, `name`, x_pos, y_pos) VALUES (?, ?, ?, ?)"
  L7_2 = {}
  L8_2 = A1_2
  L9_2 = A2_2
  L10_2 = A3_2
  L11_2 = A4_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  return L5_2(L6_2, L7_2)
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "maps:renameLocation"
function L2_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE phone_maps_locations SET `name` = ? WHERE id = ? AND phone_number = ?"
  L6_2 = {}
  L7_2 = A3_2
  L8_2 = A2_2
  L9_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2 > 0
  return L4_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "maps:removeLocation"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_maps_locations WHERE id = ? AND phone_number = ?"
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
