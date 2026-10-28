local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1
L0_1 = {}
L1_1 = {}
L1_1.Twitter = true
L1_1.Instagram = true
L1_1.Mail = true
L1_1.TikTok = true
L1_1.DarkChat = true
L2_1 = {}
L2_1.instapic = "Instagram"
L2_1.birdy = "Twitter"
L2_1.trendy = "TikTok"
L2_1.darkchat = "DarkChat"
L2_1.mail = "Mail"
L3_1 = pairs
L4_1 = L1_1
L3_1, L4_1, L5_1, L6_1 = L3_1(L4_1)
for L7_1, L8_1 in L3_1, L4_1, L5_1, L6_1 do
  L9_1 = {}
  L0_1[L7_1] = L9_1
end
L3_1 = BaseCallback
L4_1 = "accountSwitcher:switchAccount"
function L5_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L1_1
  L4_2 = L4_2[A2_2]
  if not L4_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT TRUE FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ? AND username = ?"
  L6_2 = {}
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = print
    L6_2 = "Possible abuse? %s (%i) tried to switch to an account they aren't logged into."
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = GetPlayerName
    L9_2 = A0_2
    L8_2 = L8_2(L9_2)
    L9_2 = A0_2
    L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    L5_2 = false
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE phone_logged_in_accounts SET `active` = (username = ?) WHERE phone_number = ? AND app = ?"
  L7_2 = {}
  L8_2 = A3_2
  L9_2 = A1_2
  L10_2 = A2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2 = L5_2(L6_2, L7_2)
  L5_2 = L5_2 > 0
  if L5_2 then
    L6_2 = L0_1
    L6_2 = L6_2[A2_2]
    L6_2[A1_2] = A3_2
    L6_2 = TriggerEvent
    L7_2 = "phone:loggedInToAccount"
    L8_2 = A2_2
    L9_2 = A1_2
    L10_2 = A3_2
    L6_2(L7_2, L8_2, L9_2, L10_2)
  end
  return L5_2
end
L3_1(L4_1, L5_1)
L3_1 = BaseCallback
L4_1 = "accountSwitcher:getAccounts"
function L5_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L1_1
  L3_2 = L3_2[A2_2]
  if not L3_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT username FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ?"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  return L3_2(L4_2, L5_2)
end
L3_1(L4_1, L5_1)
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = assert
  L4_2 = L1_1
  L4_2 = L4_2[A1_2]
  L5_2 = "Invalid app: "
  L6_2 = A1_2
  L5_2 = L5_2 .. L6_2
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid phone number. Expected string."
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid username. Expected string."
  L3_2(L4_2, L5_2)
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE phone_logged_in_accounts SET `active` = 0 WHERE phone_number = ? AND app = ? AND username != ?"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO phone_logged_in_accounts (phone_number, app, username, active) VALUES (?, ?, ?, 1) ON DUPLICATE KEY UPDATE active = 1"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  if L3_2 then
    L4_2 = L0_1
    L4_2 = L4_2[A1_2]
    L4_2[A0_2] = A2_2
    L4_2 = TriggerEvent
    L5_2 = "phone:loggedInToAccount"
    L6_2 = A1_2
    L7_2 = A0_2
    L8_2 = A2_2
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
  return L3_2
end
AddLoggedInAccount = L3_1
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = assert
  L4_2 = L1_1
  L4_2 = L4_2[A1_2]
  L5_2 = "Invalid app: "
  L6_2 = A1_2
  L5_2 = L5_2 .. L6_2
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid phone number. Expected string."
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid username. Expected string."
  L3_2(L4_2, L5_2)
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ? AND username = ?"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  if L3_2 then
    L4_2 = L0_1
    L4_2 = L4_2[A1_2]
    L4_2 = L4_2[A0_2]
    if L4_2 == A2_2 then
      L4_2 = L0_1
      L4_2 = L4_2[A1_2]
      L4_2[A0_2] = nil
    end
    L4_2 = TriggerEvent
    L5_2 = "phone:loggedOutFromAccount"
    L6_2 = A1_2
    L7_2 = A2_2
    L8_2 = A0_2
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
  return L3_2
end
RemoveLoggedInAccount = L3_1
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = assert
  L4_2 = L1_1
  L4_2 = L4_2[A1_2]
  L5_2 = "Invalid app: "
  L6_2 = A1_2
  L5_2 = L5_2 .. L6_2
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid phone number. Expected string."
  L3_2(L4_2, L5_2)
  L3_2 = L0_1
  L3_2 = L3_2[A1_2]
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = L0_1
    L3_2 = L3_2[A1_2]
    L3_2 = L3_2[A0_2]
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT username FROM phone_logged_in_accounts WHERE phone_number = ? AND app = ? AND active = 1"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 and not A2_2 then
    L4_2 = debugprint
    L5_2 = "AccountSwitcher: Setting cache for "
    L6_2 = A0_2
    L7_2 = ", logged in as "
    L8_2 = L3_2
    L9_2 = " on "
    L10_2 = A1_2
    L5_2 = L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2 .. L10_2
    L4_2(L5_2)
    L4_2 = L0_1
    L4_2 = L4_2[A1_2]
    L4_2[A0_2] = L3_2
  end
  L4_2 = L3_2 or L4_2
  if not L3_2 then
    L4_2 = false
  end
  return L4_2
end
GetLoggedInAccount = L3_1
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = assert
  L3_2 = L1_1
  L3_2 = L3_2[A0_2]
  L4_2 = "Invalid app: "
  L5_2 = A0_2
  L4_2 = L4_2 .. L5_2
  L2_2(L3_2, L4_2)
  L2_2 = assert
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Invalid username. Expected string."
  L2_2(L3_2, L4_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT phone_number FROM phone_logged_in_accounts WHERE app = ? AND username = ?"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = {}
  L4_2 = 1
  L5_2 = #L2_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = #L3_2
    L8_2 = L8_2 + 1
    L9_2 = L2_2[L7_2]
    L9_2 = L9_2.phone_number
    L3_2[L8_2] = L9_2
  end
  return L3_2
end
GetLoggedInNumbers = L3_1
function L3_1(A0_2)
  local L1_2
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = {}
  end
  return L1_2
end
GetActiveAccounts = L3_1
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = assert
  L4_2 = L1_1
  L4_2 = L4_2[A0_2]
  L5_2 = "Invalid app: "
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  L3_2(L4_2, L5_2)
  L3_2 = assert
  L4_2 = type
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  L4_2 = "string" == L4_2
  L5_2 = "Invalid username. Expected string."
  L3_2(L4_2, L5_2)
  L3_2 = pairs
  L4_2 = L0_1
  L4_2 = L4_2[A0_2]
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L8_2 == A1_2 and L7_2 ~= A2_2 then
      L9_2 = L0_1
      L9_2 = L9_2[A0_2]
      L9_2[L7_2] = nil
    end
  end
end
ClearActiveAccountsCache = L3_1
L3_1 = exports
L4_1 = "GetSocialMediaUsername"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = assert
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Invalid phone number. Expected string."
  L2_2(L3_2, L4_2)
  L2_2 = assert
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Invalid app. Expected string."
  L2_2(L3_2, L4_2)
  L2_2 = assert
  L3_2 = L2_1
  L3_2 = L3_2[A1_2]
  L4_2 = "Invalid app: "
  L5_2 = A1_2
  L4_2 = L4_2 .. L5_2
  L2_2(L3_2, L4_2)
  L2_2 = GetLoggedInAccount
  L3_2 = A0_2
  L4_2 = L2_1
  L4_2 = L4_2[A1_2]
  L5_2 = true
  return L2_2(L3_2, L4_2, L5_2)
end
L3_1(L4_1, L5_1)
L3_1 = AddEventHandler
L4_1 = "playerDropped"
function L5_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = GetEquippedPhoneNumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2[L0_2]
    if L7_2 then
      L6_2[L0_2] = nil
      L7_2 = debugprint
      L8_2 = "AccountSwitcher: Player dropped, logging out "
      L9_2 = L0_2
      L10_2 = " from "
      L11_2 = L5_2
      L8_2 = L8_2 .. L9_2 .. L10_2 .. L11_2
      L7_2(L8_2)
    end
  end
end
L3_1(L4_1, L5_1)
