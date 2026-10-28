local L0_1, L1_1, L2_1, L3_1, L4_1
L0_1 = Config
L0_1 = L0_1.DisabledNotifications
if not L0_1 then
  L0_1 = {}
end
function L1_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = table
  L3_2 = L3_2.contains
  L4_2 = L0_1
  L5_2 = A1_2.app
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    if A2_2 then
      L3_2 = A2_2
      L4_2 = false
      L3_2(L4_2)
    end
    L3_2 = debugprint
    L4_2 = "Notification are disabled for app"
    L5_2 = A1_2.app
    L3_2(L4_2, L5_2)
    return
  end
  L3_2 = table
  L3_2 = L3_2.clone
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  A1_2 = L3_2
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A1_2.app
    if L3_2 then
      goto lbl_45
    end
    L3_2 = type
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if "string" ~= L3_2 then
      goto lbl_45
    end
  end
  if A2_2 then
    L3_2 = A2_2
    L4_2 = false
    L3_2(L4_2)
  end
  L3_2 = debugprint
  L4_2 = "Invalid data or no app"
  L3_2(L4_2)
  do return end
  ::lbl_45::
  L3_2 = A1_2.content
  if L3_2 then
    L3_2 = A1_2.content
    L3_2 = #L3_2
    L4_2 = 500
    if L3_2 > L4_2 then
      if A2_2 then
        L3_2 = A2_2
        L4_2 = false
        L3_2(L4_2)
      end
      L3_2 = debugprint
      L4_2 = "Content too long"
      L3_2(L4_2)
      return
    end
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "number" == L3_2 then
    A1_2.source = A0_2
  end
  L3_2 = A1_2.app
  if L3_2 then
    L3_2 = A1_2.source
    if not L3_2 then
      L3_2 = type
      L4_2 = A0_2
      L3_2 = L3_2(L4_2)
      if "string" == L3_2 then
        L3_2 = GetSourceFromNumber
        L4_2 = A0_2
        L3_2 = L3_2(L4_2)
        if L3_2 then
          A1_2.source = L3_2
        end
      end
    end
  end
  L3_2 = A1_2.app
  if L3_2 then
    L3_2 = type
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      goto lbl_119
    end
  end
  if A2_2 then
    L3_2 = A2_2
    L4_2 = true
    L3_2(L4_2)
  end
  L3_2 = A1_2.source
  if L3_2 then
    L3_2 = TriggerClientEvent
    L4_2 = "phone:sendNotification"
    L5_2 = A1_2.source
    L6_2 = A1_2
    L3_2(L4_2, L5_2, L6_2)
    L3_2 = debugprint
    L4_2 = "Sending notification to source: "
    L5_2 = A1_2.source
    L4_2 = L4_2 .. L5_2
    L3_2(L4_2)
  else
    L3_2 = debugprint
    L4_2 = "Couldn't find source, no notification printing"
    L3_2(L4_2)
  end
  L3_2 = debugprint
  L4_2 = "No app or no phone number provided (not a string)"
  L3_2(L4_2)
  do return end
  ::lbl_119::
  L3_2 = Config
  L3_2 = L3_2.MaxNotifications
  if L3_2 then
    L3_2 = MySQL
    L3_2 = L3_2.scalar
    L3_2 = L3_2.await
    L4_2 = "SELECT id FROM phone_notifications WHERE phone_number = ? ORDER BY id DESC LIMIT ?, 1"
    L5_2 = {}
    L6_2 = A0_2
    L7_2 = Config
    L7_2 = L7_2.MaxNotifications
    L7_2 = L7_2 - 1
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L4_2 = debugprint
      L5_2 = "Max notifications reached, deleting all older notifications"
      L6_2 = A0_2
      L7_2 = L3_2
      L4_2(L5_2, L6_2, L7_2)
      L4_2 = MySQL
      L4_2 = L4_2.update
      L4_2 = L4_2.await
      L5_2 = "DELETE FROM phone_notifications WHERE phone_number = ? AND id <= ?"
      L6_2 = {}
      L7_2 = A0_2
      L8_2 = L3_2
      L6_2[1] = L7_2
      L6_2[2] = L8_2
      L4_2(L5_2, L6_2)
    end
  end
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = "INSERT IGNORE INTO phone_notifications (phone_number, app, title, content, thumbnail, avatar, show_avatar, custom_data) VALUES (@phoneNumber, @app, @title, @content, @thumbnail, @avatar, @showAvatar, @data)"
  L5_2 = {}
  L5_2["@phoneNumber"] = A0_2
  L6_2 = A1_2.app
  L5_2["@app"] = L6_2
  L6_2 = A1_2.title
  L5_2["@title"] = L6_2
  L6_2 = A1_2.content
  L5_2["@content"] = L6_2
  L6_2 = A1_2.thumbnail
  L5_2["@thumbnail"] = L6_2
  L6_2 = A1_2.avatar
  L5_2["@avatar"] = L6_2
  L6_2 = A1_2.showAvatar
  L5_2["@showAvatar"] = L6_2
  L6_2 = A1_2.customData
  if L6_2 then
    L6_2 = json
    L6_2 = L6_2.encode
    L7_2 = A1_2.customData
    L6_2 = L6_2(L7_2)
    if L6_2 then
      goto lbl_182
    end
  end
  L6_2 = nil
  ::lbl_182::
  L5_2["@data"] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  A1_2.id = L3_2
  L4_2 = A1_2.source
  if L4_2 then
    L4_2 = TriggerClientEvent
    L5_2 = "phone:sendNotification"
    L6_2 = A1_2.source
    L7_2 = A1_2
    L4_2(L5_2, L6_2, L7_2)
    L4_2 = debugprint
    L5_2 = "Sending notification to source: "
    L6_2 = A1_2.source
    L5_2 = L5_2 .. L6_2
    L4_2(L5_2)
  else
    L4_2 = debugprint
    L5_2 = "Couldn't find source, no notification printing"
    L4_2(L5_2)
  end
  if A2_2 then
    L4_2 = A2_2
    L5_2 = L3_2
    L4_2(L5_2)
  end
end
SendNotification = L1_1
L1_1 = exports
L2_1 = "SendNotification"
L3_1 = SendNotification
L1_1(L2_1, L3_1)
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = assert
  L3_2 = "all" == A0_2 or "online" == A0_2
  L4_2 = "Invalid notify"
  L2_2(L3_2, L4_2)
  L2_2 = assert
  L3_2 = type
  L4_2 = A1_2
  if L4_2 then
    L4_2 = L4_2.app
  end
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Invalid app"
  L2_2(L3_2, L4_2)
  L2_2 = assert
  L3_2 = type
  L4_2 = A1_2
  if L4_2 then
    L4_2 = L4_2.title
  end
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Invalid title"
  L2_2(L3_2, L4_2)
  L2_2 = table
  L2_2 = L2_2.contains
  L3_2 = L0_1
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = debugprint
    L3_2 = "NotifyEveryone: Notification are disabled for app"
    L4_2 = A1_2.app
    L2_2(L3_2, L4_2)
    return
  end
  if "all" == A0_2 then
    L2_2 = MySQL
    L2_2 = L2_2.insert
    L3_2 = [[
            INSERT INTO phone_notifications
                (phone_number, app, title, content, thumbnail, avatar, show_avatar)
            SELECT
                phone_number, @app, @title, @content, @thumbnail, @avatar, @showAvatar
            FROM
                phone_phones
            WHERE
                last_seen > DATE_SUB(NOW(), INTERVAL 7 DAY)
        ]]
    L4_2 = {}
    L5_2 = A1_2.app
    L4_2["@app"] = L5_2
    L5_2 = A1_2.title
    L4_2["@title"] = L5_2
    L5_2 = A1_2.content
    L4_2["@content"] = L5_2
    L5_2 = A1_2.thumbnail
    L4_2["@thumbnail"] = L5_2
    L5_2 = A1_2.avatar
    L4_2["@avatar"] = L5_2
    L5_2 = A1_2.showAvatar
    L4_2["@showAvatar"] = L5_2
    L2_2(L3_2, L4_2)
  end
  L2_2 = TriggerClientEvent
  L3_2 = "phone:sendNotification"
  L4_2 = -1
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
NotifyEveryone = L1_1
L1_1 = exports
L2_1 = "NotifyEveryone"
L3_1 = NotifyEveryone
L1_1(L2_1, L3_1)
function L1_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = table
  L4_2 = L4_2.contains
  L5_2 = L0_1
  L6_2 = A1_2.app
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L4_2 = debugprint
    L5_2 = "NotifyPhones: Notification are disabled for app"
    L6_2 = A1_2.app
    L4_2(L5_2, L6_2)
    return
  end
  if not A3_2 then
    L4_2 = {}
    A3_2 = L4_2
  end
  if not A2_2 then
    A2_2 = ""
  end
  L4_2 = A1_2.app
  A3_2["@app"] = L4_2
  L4_2 = A1_2.title
  A3_2["@title"] = L4_2
  L4_2 = A1_2.content
  A3_2["@content"] = L4_2
  L4_2 = A1_2.thumbnail
  A3_2["@thumbnail"] = L4_2
  L4_2 = A1_2.avatar
  A3_2["@avatar"] = L4_2
  L4_2 = A1_2.showAvatar
  A3_2["@showAvatar"] = L4_2
  L4_2 = [[
        INSERT INTO phone_notifications
            (phone_number, app, title, content, thumbnail, avatar, show_avatar)
        SELECT
            %sphone_number, @app, @title, @content, @thumbnail, @avatar, @showAvatar
        FROM
            %s
        RETURNING
            id, phone_number
    ]]
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = A2_2
  L7_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = MySQL
  L5_2 = L5_2.query
  L6_2 = L4_2
  L7_2 = A3_2
  function L8_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L1_3 = 1
    L2_3 = #A0_3
    L3_3 = 1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = A0_3[L4_3]
      L5_3 = L5_3.phone_number
      L6_3 = GetSourceFromNumber
      L7_3 = L5_3
      L6_3 = L6_3(L7_3)
      if L6_3 then
        L7_3 = A0_3[L4_3]
        L7_3 = L7_3.id
        A1_2.id = L7_3
        L7_3 = TriggerClientEvent
        L8_3 = "phone:sendNotification"
        L9_3 = L6_3
        L10_3 = A1_2
        L7_3(L8_3, L9_3, L10_3)
      end
    end
  end
  L5_2(L6_2, L7_2, L8_2)
end
NotifyPhones = L1_1
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = assert
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L3_2 = "number" == L3_2
  L4_2 = "Invalid source"
  L2_2(L3_2, L4_2)
  L2_2 = assert
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L3_2 = "table" == L3_2
  L4_2 = "Invalid data"
  L2_2(L3_2, L4_2)
  L2_2 = SendNotification
  L3_2 = A0_2
  L4_2 = {}
  L5_2 = A1_2.title
  if not L5_2 then
    L5_2 = "Emergency Alert"
  end
  L4_2.title = L5_2
  L5_2 = A1_2.content
  if not L5_2 then
    L5_2 = "This is a test emergency alert."
  end
  L4_2.content = L5_2
  L5_2 = "./assets/img/icons/"
  L6_2 = A1_2.icon
  if not L6_2 then
    L6_2 = "warning"
  end
  L7_2 = ".png"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L4_2.icon = L5_2
  L2_2(L3_2, L4_2)
end
EmergencyNotification = L1_1
L1_1 = exports
L2_1 = "SendAmberAlert"
L3_1 = EmergencyNotification
L1_1(L2_1, L3_1)
L1_1 = exports
L2_1 = "EmergencyNotification"
L3_1 = EmergencyNotification
L1_1(L2_1, L3_1)
L1_1 = BaseCallback
L2_1 = "getNotifications"
function L3_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT id, app, title, content, thumbnail, avatar, show_avatar AS showAvatar, custom_data, `timestamp` FROM phone_notifications WHERE phone_number=?"
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  return L2_2(L3_2, L4_2)
end
L4_1 = {}
L1_1(L2_1, L3_1, L4_1)
L1_1 = BaseCallback
L2_1 = "deleteNotification"
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_notifications WHERE id=? AND phone_number=?"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  return L3_2
end
L1_1(L2_1, L3_1)
L1_1 = BaseCallback
L2_1 = "clearNotifications"
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_notifications WHERE phone_number=? AND app=?"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L1_1(L2_1, L3_1)
