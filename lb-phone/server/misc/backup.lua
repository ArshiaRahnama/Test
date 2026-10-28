local L0_1, L1_1, L2_1
L0_1 = BaseCallback
L1_1 = "backup:createBackup"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.update
  L2_2 = L2_2.await
  L3_2 = [[
        INSERT INTO phone_backups (id, phone_number) VALUES (@identifier, @phoneNumber)
        ON DUPLICATE KEY UPDATE phone_number = @phoneNumber
    ]]
  L4_2 = {}
  L5_2 = GetIdentifier
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L4_2["@identifier"] = L5_2
  L4_2["@phoneNumber"] = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  L2_2 = L2_2 > 0
  return L2_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "backup:applyBackup"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = GetIdentifier
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT 1 FROM phone_backups WHERE id = ? AND phone_number = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = A2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 or A1_2 == A2_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = {}
  L5_2["@number"] = A2_2
  L5_2["@phoneNumber"] = A1_2
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT settings, pin, face_id, phone_number FROM phone_phones WHERE phone_number = @number OR phone_number = @phoneNumber"
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L6_2[1]
  if L7_2 then
    L7_2 = L7_2.phone_number
  end
  if L7_2 == A1_2 then
    L7_2 = L6_2[1]
    if L7_2 then
      goto lbl_40
    end
  end
  L7_2 = L6_2[2]
  ::lbl_40::
  L8_2 = L6_2[1]
  if L8_2 then
    L8_2 = L8_2.phone_number
  end
  if L8_2 == A1_2 then
    L8_2 = L6_2[2]
    if L8_2 then
      goto lbl_50
    end
  end
  L8_2 = L6_2[1]
  ::lbl_50::
  if not L7_2 or not L8_2 then
    L9_2 = false
    return L9_2
  end
  L9_2 = json
  L9_2 = L9_2.decode
  L10_2 = L8_2.settings
  L9_2 = L9_2(L10_2)
  L7_2.settings = L9_2
  L9_2 = L7_2.settings
  L9_2 = L9_2.security
  L9_2 = L9_2.pinCode
  if L9_2 then
    L9_2 = L7_2.pin
    if not L9_2 then
      L9_2 = L7_2.settings
      L9_2 = L9_2.security
      L9_2.pinCode = false
    end
  end
  L9_2 = L7_2.settings
  L9_2 = L9_2.security
  L9_2 = L9_2.faceId
  if L9_2 then
    L9_2 = L7_2.face_id
    if not L9_2 then
      L9_2 = L7_2.settings
      L9_2 = L9_2.security
      L9_2.faceId = false
    end
  end
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = "UPDATE phone_phones SET settings = ? WHERE phone_number = ?"
  L11_2 = {}
  L12_2 = json
  L12_2 = L12_2.encode
  L13_2 = L7_2.settings
  L12_2 = L12_2(L13_2)
  L13_2 = A1_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L9_2(L10_2, L11_2)
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = [[
        INSERT IGNORE INTO phone_photos (phone_number, link, is_video, size, `timestamp`)
        SELECT @phoneNumber, link, is_video, size, `timestamp`
        FROM phone_photos
        WHERE phone_number = @number AND link NOT IN (SELECT link FROM phone_photos WHERE phone_number = @phoneNumber)
    ]]
  L11_2 = L5_2
  L9_2(L10_2, L11_2)
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = [[
        INSERT IGNORE INTO phone_phone_contacts (contact_phone_number, firstname, lastname, profile_image, favourite, phone_number)
        SELECT contact_phone_number, firstname, lastname, profile_image, favourite, @phoneNumber
        FROM phone_phone_contacts
        WHERE phone_number = @number AND contact_phone_number NOT IN (SELECT contact_phone_number FROM phone_phone_contacts WHERE phone_number = @phoneNumber)
    ]]
  L11_2 = L5_2
  L9_2(L10_2, L11_2)
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = [[
        INSERT IGNORE INTO phone_maps_locations (id, phone_number, `name`, x_pos, y_pos)
        SELECT id, @phoneNumber, `name`, x_pos, y_pos
        FROM phone_maps_locations
        WHERE phone_number = @number AND id NOT IN (SELECT id FROM phone_maps_locations WHERE phone_number = @phoneNumber)
    ]]
  L11_2 = L5_2
  L9_2(L10_2, L11_2)
  L9_2 = true
  return L9_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "backup:deleteBackup"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_backups WHERE id = ? AND phone_number = ?"
  L5_2 = {}
  L6_2 = GetIdentifier
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  return L3_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "backup:getBackups"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT phone_number AS `number` FROM phone_backups WHERE id = ?"
  L4_2 = {}
  L5_2 = GetIdentifier
  L6_2 = A0_2
  L5_2, L6_2 = L5_2(L6_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  return L2_2(L3_2, L4_2)
end
L0_1(L1_1, L2_1)
