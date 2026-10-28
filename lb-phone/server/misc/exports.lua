local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1
L0_1 = {}
L0_1.twitter = true
L0_1.instagram = true
L0_1.tiktok = true
L1_1 = {}
L1_1.birdy = "twitter"
L1_1.instapic = "instagram"
L1_1.trendy = "tiktok"
L2_1 = {}
L2_1.twitter = "Twitter"
L2_1.instagram = "Instagram"
L2_1.tiktok = "TikTok"
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = assert
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid app"
  L3_2(L4_2, L5_2)
  L4_2 = A0_2
  L3_2 = A0_2.lower
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = L0_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = tostring
    L4_2 = L1_1
    L4_2 = L4_2[A0_2]
    L3_2 = L3_2(L4_2)
    A0_2 = L3_2
  end
  L3_2 = assert
  L4_2 = L0_1
  L4_2 = L4_2[A0_2]
  L5_2 = "Invalid app"
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid username"
  L3_2(L4_2, L5_2)
  L3_2 = TriggerEvent
  L4_2 = "lb-phone:toggleVerified"
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = A2_2
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = MySQL
  L3_2 = L3_2.Sync
  L3_2 = L3_2.execute
  L4_2 = "UPDATE phone_%s_accounts SET verified=@verified WHERE username=@username"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = {}
  L5_2["@username"] = A1_2
  L5_2["@verified"] = A2_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  if L3_2 and A2_2 then
    L4_2 = L2_1
    L4_2 = L4_2[A0_2]
    if L4_2 then
      L4_2 = MySQL
      L4_2 = L4_2.query
      L4_2 = L4_2.await
      L5_2 = "SELECT phone_number FROM phone_logged_in_accounts WHERE app = ? AND username = ? AND `active` = 1"
      L6_2 = {}
      L7_2 = A0_2
      L8_2 = A1_2
      L6_2[1] = L7_2
      L6_2[2] = L8_2
      L4_2 = L4_2(L5_2, L6_2)
      L5_2 = 1
      L6_2 = #L4_2
      L7_2 = 1
      for L8_2 = L5_2, L6_2, L7_2 do
        L9_2 = L4_2[L8_2]
        L9_2 = L9_2.phone_number
        L10_2 = SendNotification
        L11_2 = L9_2
        L12_2 = {}
        L13_2 = L2_1
        L13_2 = L13_2[A0_2]
        L12_2.app = L13_2
        L13_2 = L
        L14_2 = "BACKEND.MISC.VERIFIED"
        L13_2 = L13_2(L14_2)
        L12_2.title = L13_2
        L10_2(L11_2, L12_2)
      end
    end
  end
  return L3_2
end
ToggleVerified = L3_1
L3_1 = exports
L4_1 = "ToggleVerified"
L5_1 = ToggleVerified
L3_1(L4_1, L5_1)
L3_1 = exports
L4_1 = "IsVerified"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = assert
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Invalid app"
  L2_2(L3_2, L4_2)
  L3_2 = A0_2
  L2_2 = A0_2.lower
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = L0_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = tostring
    L3_2 = L1_1
    L3_2 = L3_2[A0_2]
    L2_2 = L2_2(L3_2)
    A0_2 = L2_2
  end
  L2_2 = assert
  L3_2 = L0_1
  L3_2 = L3_2[A0_2]
  L4_2 = "Invalid app"
  L2_2(L3_2, L4_2)
  L2_2 = assert
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Invalid username"
  L2_2(L3_2, L4_2)
  L2_2 = MySQL
  L2_2 = L2_2.Sync
  L2_2 = L2_2.fetchScalar
  L3_2 = "SELECT verified FROM phone_%s_accounts WHERE username=@username"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = {}
  L4_2["@username"] = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = false
  end
  return L2_2
end
L3_1(L4_1, L5_1)
L3_1 = {}
L3_1.twitter = "username"
L3_1.instagram = "username"
L3_1.tiktok = "username"
L3_1.mail = "address"
L3_1.darkchat = "username"
function L4_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = assert
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid app"
  L3_2(L4_2, L5_2)
  L4_2 = A0_2
  L3_2 = A0_2.lower
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = tostring
    L4_2 = L1_1
    L4_2 = L4_2[A0_2]
    L3_2 = L3_2(L4_2)
    A0_2 = L3_2
  end
  L3_2 = assert
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  L5_2 = "Invalid app"
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid username"
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid password"
  L3_2(L4_2, L5_2)
  L3_2 = MySQL
  L3_2 = L3_2.Sync
  L3_2 = L3_2.execute
  L4_2 = "UPDATE phone_%s_accounts SET password=@password WHERE %s=@username"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = A0_2
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = {}
  L5_2["@username"] = A1_2
  L6_2 = GetPasswordHash
  L7_2 = A2_2
  L6_2 = L6_2(L7_2)
  L5_2["@password"] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L5_2 = "DELETE FROM phone_logged_in_accounts WHERE app = ? AND username = ?"
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = true
  return L4_2
end
ChangePassword = L4_1
L4_1 = exports
L5_1 = "ChangePassword"
L6_1 = ChangePassword
L4_1(L5_1, L6_1)
L4_1 = exports
L5_1 = "GetEquippedPhoneNumber"
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L1_2 = GetEquippedPhoneNumber
    L2_2 = A0_2
    return L1_2(L2_2)
  end
  L1_2 = GetSourceFromIdentifier
  if L1_2 then
    L1_2 = GetSourceFromIdentifier
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  if L1_2 then
    L2_2 = GetEquippedPhoneNumber
    L3_2 = L1_2
    return L2_2(L3_2)
  end
  L2_2 = Config
  L2_2 = L2_2.Item
  L2_2 = L2_2.Unique
  if L2_2 then
    L2_2 = "phone_last_phone"
    if L2_2 then
      goto lbl_31
    end
  end
  L2_2 = "phone_phones"
  ::lbl_31::
  L3_2 = "id"
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT phone_number FROM %s WHERE %s = ?"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = L2_2
  L8_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = {}
  L7_2 = A0_2
  L6_2[1] = L7_2
  return L4_2(L5_2, L6_2)
end
L4_1(L5_1, L6_1)
