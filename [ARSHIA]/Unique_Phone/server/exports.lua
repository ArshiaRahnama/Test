local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayerByCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    return A0_2
  end
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT citizenid FROM apex_phone_accounts WHERE citizenid = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    return A0_2
  end
  L2_2 = GetCitizenIdByNumber
  L3_2 = A0_2
  return L2_2(L3_2)
end
L1_1 = exports
L2_1 = "SendMail"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L0_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = type
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_13
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_13::
  L3_2 = nil
  L4_2 = A1_2.attachments
  if nil ~= L4_2 then
    L4_2 = CleanMailAttachments
    if not L4_2 then
      L4_2 = false
      return L4_2
    end
    L4_2 = nil
    L5_2 = nil
    L6_2 = CleanMailAttachments
    L7_2 = A1_2.attachments
    L8_2 = nil
    L9_2 = {}
    L9_2.system = true
    L6_2, L7_2, L8_2 = L6_2(L7_2, L8_2, L9_2)
    L5_2 = L8_2
    L4_2 = L7_2
    L3_2 = L6_2
    if L4_2 then
      L6_2 = print
      L7_2 = "^3[unique_phone]^0 SendMail: attachment %s invalid (%s) - email not sent"
      L8_2 = L7_2
      L7_2 = L7_2.format
      L9_2 = tostring
      L10_2 = L5_2
      L9_2 = L9_2(L10_2)
      L10_2 = tostring
      L11_2 = L4_2
      L10_2, L11_2 = L10_2(L11_2)
      L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
      L6_2 = false
      return L6_2
    end
  end
  L4_2 = SendMailInternal
  L5_2 = L2_2
  L6_2 = A1_2.sender
  L7_2 = A1_2.email
  L8_2 = A1_2.subject
  L9_2 = A1_2.body
  L10_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = nil ~= L4_2
  return L4_2
end
L1_1(L2_1, L3_1)
L1_1 = exports
L2_1 = "CreateBill"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L0_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = type
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_13
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_13::
  L3_2 = CreateBillInternal
  L4_2 = L2_2
  L5_2 = A1_2.senderName
  if not L5_2 then
    L5_2 = A1_2.sender
  end
  L6_2 = A1_2.amount
  L7_2 = A1_2.reason
  L8_2 = {}
  L9_2 = A1_2.sender
  L8_2.sender = L9_2
  L9_2 = A1_2.senderCid
  L8_2.senderCid = L9_2
  L9_2 = A1_2.society
  L8_2.society = L9_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L1_1(L2_1, L3_1)
L1_1 = {}
L1_1.banner = true
L1_1.silent = true
L1_1.island = true
L1_1.lock = true
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 and "number" ~= L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = 1
  L5_2 = 3
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = utf8
    L8_2 = L8_2.len
    L9_2 = L3_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      break
    end
    L9_2 = L3_2
    L8_2 = L3_2.sub
    L10_2 = 1
    L11_2 = -2
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L3_2 = L8_2
  end
  return L3_2
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.encode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = #L2_2
    L4_2 = 2000
    if not (L3_2 > L4_2) then
      goto lbl_21
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_21::
  L3_2 = json
  L3_2 = L3_2.decode
  L4_2 = L2_2
  return L3_2(L4_2)
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    L8_2 = L2_1
    L9_2 = L7_2.id
    L10_2 = 32
    L8_2 = "table" == L8_2 and L8_2
    L9_2 = type
    L10_2 = L7_2
    L9_2 = L9_2(L10_2)
    L9_2 = L2_1
    L10_2 = L7_2.label
    L11_2 = 32
    L9_2 = "table" == L9_2 and L9_2
    if L8_2 and "" ~= L8_2 and L9_2 and "" ~= L9_2 then
      L10_2 = #L1_2
      L10_2 = L10_2 + 1
      L11_2 = {}
      L11_2.id = L8_2
      L11_2.label = L9_2
      L1_2[L10_2] = L11_2
      L10_2 = #L1_2
      if L10_2 >= 3 then
        break
      end
    end
  end
  L2_2 = #L1_2
  L2_2 = L1_2 or L2_2
  if not (L2_2 > 0) or not L1_2 then
    L2_2 = nil
  end
  return L2_2
end
L5_1 = exports
L6_1 = "SendNotification"
function L7_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L5_2 = nil
  L6_2 = type
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L5_2 = A1_2
  else
    L6_2 = {}
    L6_2.app = A1_2
    L6_2.title = A2_2
    L6_2.msg = A3_2
    L6_2.data = A4_2
    L5_2 = L6_2
  end
  L6_2 = L2_1
  L7_2 = L5_2.app
  L8_2 = 32
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = "settings"
  end
  L7_2 = L2_1
  L8_2 = L5_2.title
  L9_2 = 80
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = ""
  end
  L8_2 = L2_1
  L9_2 = L5_2.msg
  if not L9_2 then
    L9_2 = L5_2.message
  end
  L10_2 = 255
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = ""
  end
  L9_2 = L3_1
  L10_2 = L5_2.data
  L9_2 = L9_2(L10_2)
  L10_2 = tonumber
  L11_2 = L5_2.duration
  L10_2 = L10_2(L11_2)
  L11_2 = {}
  L12_2 = L2_1
  L13_2 = L5_2.icon
  L14_2 = 255
  L12_2 = L12_2(L13_2, L14_2)
  L11_2.icon = L12_2
  L12_2 = L2_1
  L13_2 = L5_2.image
  L14_2 = 255
  L12_2 = L12_2(L13_2, L14_2)
  L11_2.image = L12_2
  L12_2 = L2_1
  L13_2 = L5_2.description
  L14_2 = 255
  L12_2 = L12_2(L13_2, L14_2)
  L11_2.description = L12_2
  if L10_2 then
    L12_2 = math
    L12_2 = L12_2.floor
    L13_2 = math
    L13_2 = L13_2.max
    L14_2 = 500
    L15_2 = math
    L15_2 = L15_2.min
    L16_2 = 60000
    L17_2 = L10_2
    L15_2 = L15_2(L16_2, L17_2)
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L13_2(L14_2, L15_2)
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    if L12_2 then
      goto lbl_80
    end
  end
  L12_2 = nil
  ::lbl_80::
  L11_2.duration = L12_2
  L12_2 = L4_1
  L13_2 = L5_2.actions
  L12_2 = L12_2(L13_2)
  L11_2.actions = L12_2
  L13_2 = L5_2.type
  L12_2 = L1_1
  L12_2 = L12_2[L13_2]
  if L12_2 then
    L12_2 = L5_2.type
    if L12_2 then
      goto lbl_94
    end
  end
  L12_2 = nil
  ::lbl_94::
  L11_2.type = L12_2
  L12_2 = L5_2.persist
  if false == L12_2 then
    L11_2.persist = false
  end
  L12_2 = type
  L13_2 = A0_2
  L12_2 = L12_2(L13_2)
  if "number" == L12_2 then
    L12_2 = GetPlayerName
    L13_2 = A0_2
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = false
      return L12_2
    end
    L12_2 = NotifyPlayer
    L13_2 = A0_2
    L14_2 = L6_2
    L15_2 = L7_2
    L16_2 = L8_2
    L17_2 = L9_2
    L18_2 = L11_2
    L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L12_2 = true
    return L12_2
  end
  L12_2 = L0_1
  L13_2 = A0_2
  L12_2 = L12_2(L13_2)
  if L12_2 then
    L13_2 = NotifyCitizen
    L14_2 = L12_2
    L15_2 = L6_2
    L16_2 = L7_2
    L17_2 = L8_2
    L18_2 = L9_2
    L19_2 = L11_2
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L13_2 = true
    return L13_2
  end
  L13_2 = tonumber
  L14_2 = A0_2
  L13_2 = L13_2(L14_2)
  if L13_2 then
    L14_2 = GetPlayerName
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    if L14_2 then
      L14_2 = NotifyPlayer
      L15_2 = L13_2
      L16_2 = L6_2
      L17_2 = L7_2
      L18_2 = L8_2
      L19_2 = L9_2
      L20_2 = L11_2
      L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      L14_2 = true
      return L14_2
    end
  end
  L14_2 = false
  return L14_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "OpenApp"
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if A0_2 then
    L2_2 = GetPlayerName
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = type
      L3_2 = A1_2
      L2_2 = L2_2(L3_2)
      if "string" == L2_2 then
        L3_2 = A1_2
        L2_2 = A1_2.match
        L4_2 = "^[%w_%.%-]+$"
        L2_2 = L2_2(L3_2, L4_2)
        if L2_2 then
          L2_2 = #A1_2
          if not (L2_2 > 32) then
            goto lbl_27
          end
        end
      end
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_27::
  L2_2 = TriggerClientEvent
  L3_2 = "apex_phone:client:openApp"
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = true
  return L2_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "ClosePhone"
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if A0_2 then
    L1_2 = GetPlayerName
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_14
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_14::
  L1_2 = TriggerClientEvent
  L2_2 = "apex_phone:client:close"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
  L1_2 = true
  return L1_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "IsPhoneOpen"
function L7_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetPhoneState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = nil ~= L1_2
  return L2_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetDeviceOS"
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetPhoneState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.open
    if L2_2 then
      goto lbl_11
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_11::
  L2_2 = L1_2.device
  if L2_2 then
    L2_2 = Config
    L2_2 = L2_2.Devices
    if L2_2 then
      L2_2 = Config
      L2_2 = L2_2.Devices
      L3_2 = L1_2.device
      L2_2 = L2_2[L3_2]
    end
  end
  if L2_2 then
    L3_2 = L2_2.os
    if "android" == L3_2 then
      L3_2 = "android"
      if L3_2 then
        goto lbl_31
      end
    end
  end
  L3_2 = "ios"
  ::lbl_31::
  return L3_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "SendMessage"
function L7_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L5_2 = SendMessageInternal
  L6_2 = "sms"
  L7_2 = tostring
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = tostring
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L9_2 = A3_2 or L9_2
  if not A3_2 then
    L9_2 = "text"
  end
  L10_2 = A2_2
  L11_2 = A4_2
  L12_2 = nil
  return L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "AddPhoto"
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L0_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = nil
  L4_2 = true
  L5_2 = nil
  L6_2 = CleanPhotoUrl
  if L6_2 then
    L6_2 = CleanPhotoUrl
    L7_2 = A1_2
    L6_2, L7_2, L8_2 = L6_2(L7_2)
    L5_2 = L8_2
    L4_2 = L7_2
    L3_2 = L6_2
  else
    L3_2 = A1_2
  end
  if not L4_2 then
    L6_2 = print
    L7_2 = "^3[unique_phone]^0 AddPhoto: url rejected (%s) - nothing was added to the gallery of %s"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = tostring
    L10_2 = L5_2 or L10_2
    if not L5_2 then
      L10_2 = "badimage"
    end
    L9_2 = L9_2(L10_2)
    L10_2 = tostring
    L11_2 = L2_2
    L10_2, L11_2 = L10_2(L11_2)
    L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
    L6_2 = nil
    return L6_2
  end
  L6_2 = AddPhoto
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = nil
  L10_2 = false
  L11_2 = nil
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = FW
  L7_2 = L7_2.GetPlayerByCid
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  if L7_2 then
    L8_2 = Push
    L9_2 = L7_2.src
    L10_2 = "photo"
    L11_2 = L6_2
    L8_2(L9_2, L10_2, L11_2)
  end
  return L6_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetFramework"
function L7_1()
  local L0_2, L1_2
  L0_2 = FW
  L0_2 = L0_2.name
  return L0_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetPlayerInfo"
function L7_1(A0_2)
  local L1_2, L2_2
  L1_2 = BuildPlayer
  L2_2 = A0_2
  return L1_2(L2_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetJobPlayers"
function L7_1(A0_2)
  local L1_2, L2_2
  L1_2 = FW
  L1_2 = L1_2.GetJobPlayers
  L2_2 = A0_2
  return L1_2(L2_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetNumber"
function L7_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetNumberByCitizenId
  L2_2 = A0_2
  return L1_2(L2_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetCitizenId"
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetCitizenIdByNumber
  L2_2 = tostring
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetSourceByNumber"
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetSrcByNumber
  L2_2 = tostring
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "SetNumber"
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = nil
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "number" == L4_2 then
    L4_2 = GetCid
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
  else
    L4_2 = L0_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
  end
  if not L3_2 then
    L4_2 = false
    L5_2 = "noaccount"
    return L4_2, L5_2
  end
  L4_2 = type
  L5_2 = ChangePhoneNumber
  L4_2 = L4_2(L5_2)
  if "function" ~= L4_2 then
    L4_2 = false
    L5_2 = "db"
    return L4_2, L5_2
  end
  L4_2 = ChangePhoneNumber
  L5_2 = L3_2
  L6_2 = A1_2
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = GetInvokingResource
    L7_2 = L7_2()
    if not L7_2 then
      L7_2 = "export"
    end
  end
  return L4_2(L5_2, L6_2, L7_2)
end
L5_1(L6_1, L7_1)
L5_1 = {}
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 and "number" ~= L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = #L2_2
  if 0 ~= L3_2 then
    L3_2 = #L2_2
    if not (L3_2 > 64) then
      L4_2 = L2_2
      L3_2 = L2_2.find
      L5_2 = "[^%w_%.%:%-]"
      L3_2 = L3_2(L4_2, L5_2)
      if not L3_2 then
        goto lbl_26
      end
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_26::
  return L2_2
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.encode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = #L2_2
    L4_2 = 8000
    if not (L3_2 > L4_2) then
      goto lbl_14
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_14::
  L3_2 = json
  L3_2 = L3_2.decode
  L4_2 = L2_2
  return L3_2(L4_2)
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2.job
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = A0_2.job
    if L1_2 then
      goto lbl_10
    end
  end
  L1_2 = nil
  ::lbl_10::
  if not L1_2 then
    L2_2 = -1
    return L2_2
  end
  L2_2 = FW
  L2_2 = L2_2.GetJobPlayers
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.GetJobPlayers
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_25
    end
  end
  L2_2 = nil
  ::lbl_25::
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L2_2 or L3_2
  if "table" ~= L3_2 or not L2_2 then
    L3_2 = {}
  end
  return L3_2
end
L9_1 = exports
L10_1 = "RegisterApp"
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.id
    if L1_2 then
      L1_2 = A0_2.url
      if L1_2 then
        goto lbl_14
      end
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_14::
  L1_2 = L6_1
  L2_2 = A0_2.id
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = print
    L3_2 = "^3[unique_phone]^0 RegisterApp: id \"%s\" invalid - only letters, numbers, _ - . : (up to 64). App not registered."
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = A0_2.id
    L5_2 = L5_2(L6_2)
    L6_2 = L5_2
    L5_2 = L5_2.sub
    L7_2 = 1
    L8_2 = 60
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L5_2(L6_2, L7_2, L8_2)
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L2_2 = false
    return L2_2
  end
  L2_2 = L7_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 RegisterApp: definition of \"%s\" is not serializable (or exceeds 8 KB). App not registered."
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = L1_2
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L3_2 = false
    return L3_2
  end
  L2_2.id = L1_2
  L3_2 = ServerApps
  L3_2[L1_2] = L2_2
  L3_2 = L5_1
  L4_2 = GetInvokingResource
  L4_2 = L4_2()
  if not L4_2 then
    L4_2 = GetCurrentResourceName
    L4_2 = L4_2()
  end
  L3_2[L1_2] = L4_2
  L3_2 = L8_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if -1 == L3_2 then
    L4_2 = TriggerClientEvent
    L5_2 = "apex_phone:client:push"
    L6_2 = -1
    L7_2 = "registerApp"
    L8_2 = L2_2
    L4_2(L5_2, L6_2, L7_2, L8_2)
  else
    L4_2 = ipairs
    L5_2 = L3_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = TriggerClientEvent
      L11_2 = "apex_phone:client:push"
      L12_2 = L9_2
      L13_2 = "registerApp"
      L14_2 = L2_2
      L10_2(L11_2, L12_2, L13_2, L14_2)
    end
  end
  L4_2 = true
  return L4_2
end
L9_1(L10_1, L11_1)
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L6_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = ServerApps
    L2_2 = L2_2[L1_2]
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_12::
  L2_2 = ServerApps
  L2_2[L1_2] = nil
  L2_2 = L5_1
  L2_2[L1_2] = nil
  L2_2 = TriggerClientEvent
  L3_2 = "apex_phone:client:push"
  L4_2 = -1
  L5_2 = "unregisterApp"
  L6_2 = {}
  L6_2.id = L1_2
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = true
  return L2_2
end
L10_1 = exports
L11_1 = "UnregisterApp"
L12_1 = L9_1
L10_1(L11_1, L12_1)
L10_1 = AddEventHandler
L11_1 = "onResourceStop"
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L5_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    if L6_2 == A0_2 then
      L7_2 = L9_1
      L8_2 = L5_2
      L7_2(L8_2)
    end
  end
end
L10_1(L11_1, L12_1)
function L10_1()
  local L0_2, L1_2
  L0_2 = source
  if nil ~= L0_2 then
    L0_2 = tonumber
    L1_2 = source
    L0_2 = L0_2(L1_2)
    if L0_2 then
      goto lbl_10
    end
  end
  L0_2 = nil
  ::lbl_10::
  L1_2 = nil ~= L0_2 and L0_2 > 0
  return L1_2
end
L11_1 = AddEventHandler
L12_1 = "apex_phone:server:sendMail"
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L10_1
  L2_2 = L2_2()
  if L2_2 then
    return
  end
  L2_2 = exports
  L2_2 = L2_2.Unique_Phone
  L3_2 = L2_2
  L2_2 = L2_2.SendMail
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
L11_1(L12_1, L13_1)
L11_1 = AddEventHandler
L12_1 = "apex_phone:server:createBill"
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L10_1
  L2_2 = L2_2()
  if L2_2 then
    return
  end
  L2_2 = exports
  L2_2 = L2_2.Unique_Phone
  L3_2 = L2_2
  L2_2 = L2_2.CreateBill
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
L11_1(L12_1, L13_1)
L11_1 = AddEventHandler
L12_1 = "apex_phone:server:fine"
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L10_1
  L3_2 = L3_2()
  if L3_2 then
    return
  end
  L3_2 = CreateBillInternal
  L4_2 = A0_2
  L5_2 = "LSPD"
  L6_2 = A1_2
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = "Multa"
  end
  L8_2 = {}
  L8_2.society = "police"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L11_1(L12_1, L13_1)
