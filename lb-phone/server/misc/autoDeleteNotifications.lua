local L0_1, L1_1, L2_1, L3_1, L4_1
L0_1 = Config
L0_1 = L0_1.AutoDeleteNotifications
if not L0_1 then
  return
end
L0_1 = type
L1_1 = Config
L1_1 = L1_1.AutoDeleteNotifications
L0_1 = L0_1(L1_1)
if "number" ~= L0_1 then
  L0_1 = Config
  L0_1.AutoDeleteNotifications = 168
end
while true do
  L0_1 = DatabaseCheckerFinished
  if L0_1 then
    break
  end
  L0_1 = Wait
  L1_1 = 500
  L0_1(L1_1)
end
while true do
  L0_1 = debugprint
  L1_1 = "Deleting all old notifications.."
  L0_1(L1_1)
  L0_1 = os
  L0_1 = L0_1.nanotime
  L0_1 = L0_1()
  L1_1 = MySQL
  L1_1 = L1_1.update
  L2_1 = "DELETE FROM phone_notifications WHERE `timestamp` < DATE_SUB(NOW(), INTERVAL ? HOUR)"
  L3_1 = {}
  L4_1 = Config
  L4_1 = L4_1.AutoDeleteNotifications
  L3_1[1] = L4_1
  function L4_1(A0_2)
    local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
    L1_2 = os
    L1_2 = L1_2.nanotime
    L1_2 = L1_2()
    L2_2 = L0_1
    L1_2 = L1_2 - L2_2
    L1_2 = L1_2 / 1000000.0
    L2_2 = debugprint
    L3_2 = "Deleted "
    L4_2 = A0_2
    L5_2 = " notification"
    if 1 == A0_2 then
      L6_2 = ""
      if L6_2 then
        goto lbl_19
      end
    end
    L6_2 = "s"
    ::lbl_19::
    L7_2 = " in "
    L8_2 = L1_2
    L9_2 = " ms"
    L3_2 = L3_2 .. L4_2 .. L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2
    L2_2(L3_2)
  end
  L1_1(L2_1, L3_1, L4_1)
  L1_1 = Wait
  L2_1 = 3600000
  L1_1(L2_1)
end
