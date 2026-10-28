local L0_1, L1_1, L2_1, L3_1
L0_1 = RegisterLegacyCallback
L1_1 = "security:getIdentifier"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A1_2
  L3_2 = GetIdentifier
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  L2_2(L3_2, L4_2)
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "security:setPin"
function L2_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = #A2_2
    if 4 == L4_2 then
      goto lbl_14
    end
  end
  L4_2 = debugprint
  L5_2 = "Failed to set pin: invalid type or length"
  L4_2(L5_2)
  L4_2 = false
  do return L4_2 end
  ::lbl_14::
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE phone_phones SET pin = ? WHERE phone_number = ? AND (pin = ? OR pin IS NULL)"
  L6_2 = {}
  L7_2 = A2_2
  L8_2 = A1_2
  L9_2 = A3_2 or L9_2
  if not A3_2 then
    L9_2 = ""
  end
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2 > 0
  L5_2 = debugprint
  L6_2 = "phone:security:setPin"
  L7_2 = GetPlayerName
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = L4_2
  L9_2 = A1_2
  L10_2 = A2_2
  L11_2 = A3_2
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  return L4_2
end
L3_1 = false
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "security:removePin"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = #A2_2
    if 4 == L3_2 then
      goto lbl_14
    end
  end
  L3_2 = debugprint
  L4_2 = "Failed to remove pin: invalid type or length"
  L3_2(L4_2)
  L3_2 = false
  do return L3_2 end
  ::lbl_14::
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE phone_phones SET pin = NULL, face_id = NULL WHERE phone_number = ? AND (pin = ? OR pin IS NULL)"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  return L3_2
end
L3_1 = false
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "security:verifyPin"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = #A2_2
    if 4 == L3_2 then
      goto lbl_14
    end
  end
  L3_2 = debugprint
  L4_2 = "Failed to verify pin: invalid type or length"
  L3_2(L4_2)
  L3_2 = false
  do return L3_2 end
  ::lbl_14::
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT pin FROM phone_phones WHERE phone_number = ?"
  L5_2 = {}
  L6_2 = A1_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = nil == L3_2 or L3_2 == A2_2
  L5_2 = debugprint
  L6_2 = "phone:security:verifyPin"
  L7_2 = GetPlayerName
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = L4_2
  L9_2 = L3_2
  L10_2 = A2_2
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  return L4_2
end
L3_1 = false
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "security:enableFaceUnlock"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = #A2_2
    if 4 == L3_2 then
      goto lbl_14
    end
  end
  L3_2 = debugprint
  L4_2 = "Failed to enable face unlock: invalid type or length"
  L3_2(L4_2)
  L3_2 = false
  do return L3_2 end
  ::lbl_14::
  L3_2 = GetIdentifier
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE phone_phones SET face_id = ? WHERE phone_number = ? AND pin = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = A1_2
  L9_2 = A2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2 > 0
  return L4_2
end
L3_1 = false
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "security:disableFaceUnlock"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = #A2_2
    if 4 == L3_2 then
      goto lbl_14
    end
  end
  L3_2 = debugprint
  L4_2 = "Failed to disable face unlock: invalid type or length"
  L3_2(L4_2)
  L3_2 = false
  do return L3_2 end
  ::lbl_14::
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE phone_phones SET face_id = NULL WHERE phone_number = ? AND (pin = ? OR pin IS NULL)"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  return L3_2(L4_2, L5_2)
end
L3_1 = false
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "security:verifyFace"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetIdentifier
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT face_id FROM phone_phones WHERE phone_number = ?"
  L5_2 = {}
  L6_2 = A1_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = debugprint
  L5_2 = "phone:security:verifyFace"
  L6_2 = GetPlayerName
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = L3_2
  L8_2 = L2_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = L3_2 == L2_2
  return L4_2
end
L3_1 = false
L0_1(L1_1, L2_1, L3_1)
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = assert
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = "string" == L2_2
  L3_2 = "Invalid argument #1 to ResetSecurity, expected string, got "
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L3_2 = L3_2 .. L4_2
  L1_2(L2_2, L3_2)
  L1_2 = MySQL
  L1_2 = L1_2.update
  L1_2 = L1_2.await
  L2_2 = "UPDATE phone_phones SET pin = NULL, face_id = NULL WHERE phone_number = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2(L2_2, L3_2)
  L1_2 = GetSourceFromNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = TriggerClientEvent
    L3_2 = "phone:security:reset"
    L4_2 = L1_2
    L5_2 = A0_2
    L2_2(L3_2, L4_2, L5_2)
  end
end
ResetSecurity = L0_1
L0_1 = exports
L1_1 = "GetPin"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = assert
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = "string" == L2_2
  L3_2 = "Invalid argument #1 to GetPin, expected string, got "
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L3_2 = L3_2 .. L4_2
  L1_2(L2_2, L3_2)
  L1_2 = MySQL
  L1_2 = L1_2.scalar
  L1_2 = L1_2.await
  L2_2 = "SELECT pin FROM phone_phones WHERE phone_number = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  return L1_2(L2_2, L3_2)
end
L0_1(L1_1, L2_1)
L0_1 = exports
L1_1 = "ResetSecurity"
L2_1 = ResetSecurity
L0_1(L1_1, L2_1)
