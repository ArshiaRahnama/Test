local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1
L0_1 = {}
L1_1 = 1
L2_1 = {}
function L3_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = Dbg
  if L1_2 then
    L1_2 = Dbg
    L2_2 = "calls"
    L3_2 = A0_2
    L4_2 = ...
    L1_2(L2_2, L3_2, L4_2)
  end
end
function L4_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = Voice
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = Voice
    L2_2 = L2_2[A0_2]
    L1_2 = L1_2(L2_2)
    if "function" == L1_2 then
      goto lbl_15
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_15::
  L1_2 = pcall
  L2_2 = Voice
  L2_2 = L2_2[A0_2]
  L3_2, L4_2, L5_2, L6_2, L7_2 = ...
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  if not L1_2 then
    L3_2 = L3_1
    L4_2 = "Voice.%s failed: %s"
    L5_2 = A0_2
    L6_2 = tostring
    L7_2 = L2_2
    L6_2, L7_2 = L6_2(L7_2)
    L3_2(L4_2, L5_2, L6_2, L7_2)
    L3_2 = nil
    return L3_2
  end
  return L2_2
end
function L5_1(A0_2)
  local L1_2, L2_2
  L1_2 = HasPhoneItem
  L1_2 = HasPhoneItem
  L2_2 = A0_2
  L1_2 = not L1_2 or L1_2
  return L1_2
end
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = IsBlocked
  L2_2 = L2_2(L3_2)
  if not ("function" == L2_2 and A0_2) or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  L3_2 = IsBlocked
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2 or L4_2
  if L2_2 then
    L4_2 = true == L3_2
  end
  return L4_2
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if not A0_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT name FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = L2_2.name
  end
  return L3_2
end
L8_1 = false
L9_1 = -60
function L10_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L8_1
  if not L0_2 then
    L0_2 = os
    L0_2 = L0_2.time
    L0_2 = L0_2()
    L1_2 = L9_1
    L0_2 = L0_2 - L1_2
    if not (L0_2 < 60) then
      goto lbl_13
    end
  end
  do return end
  ::lbl_13::
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L9_1 = L0_2
  L0_2 = MySQL
  L0_2 = L0_2.scalar
  L1_2 = "SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'apex_phone_calls' AND COLUMN_NAME = 'status'"
  L2_2 = {}
  function L3_2(A0_3)
    local L1_3, L2_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = 0
    end
    L1_3 = L1_3 > 0
    L8_1 = L1_3
  end
  L0_2(L1_2, L2_2, L3_2)
end
L11_1 = CreateThread
function L12_1()
  local L0_2, L1_2
  L0_2 = Wait
  L1_2 = 8000
  L0_2(L1_2)
  L0_2 = L10_1
  L0_2()
end
L11_1(L12_1)
function L11_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2, A7_2)
  local L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  if not A0_2 then
    return
  end
  L8_2 = L10_1
  L8_2()
  L8_2 = L8_1
  if L8_2 then
    L8_2 = MySQL
    L8_2 = L8_2.insert
    L9_2 = "INSERT INTO apex_phone_calls (owner, number, name, outgoing, answered, video, duration, created, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
    L10_2 = {}
    L11_2 = A0_2
    L12_2 = A1_2
    L13_2 = A2_2
    if A3_2 then
      L14_2 = 1
      if L14_2 then
        goto lbl_23
      end
    end
    L14_2 = 0
    ::lbl_23::
    if A4_2 then
      L15_2 = 1
      if L15_2 then
        goto lbl_29
      end
    end
    L15_2 = 0
    ::lbl_29::
    if A5_2 then
      L16_2 = 1
      if L16_2 then
        goto lbl_35
      end
    end
    L16_2 = 0
    ::lbl_35::
    L17_2 = A6_2 or L17_2
    if not A6_2 then
      L17_2 = 0
    end
    L18_2 = Now
    L18_2 = L18_2()
    L19_2 = A7_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L10_2[4] = L14_2
    L10_2[5] = L15_2
    L10_2[6] = L16_2
    L10_2[7] = L17_2
    L10_2[8] = L18_2
    L10_2[9] = L19_2
    L8_2(L9_2, L10_2)
  else
    L8_2 = MySQL
    L8_2 = L8_2.insert
    L9_2 = "INSERT INTO apex_phone_calls (owner, number, name, outgoing, answered, video, duration, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    L10_2 = {}
    L11_2 = A0_2
    L12_2 = A1_2
    L13_2 = A2_2
    if A3_2 then
      L14_2 = 1
      if L14_2 then
        goto lbl_58
      end
    end
    L14_2 = 0
    ::lbl_58::
    if A4_2 then
      L15_2 = 1
      if L15_2 then
        goto lbl_64
      end
    end
    L15_2 = 0
    ::lbl_64::
    if A5_2 then
      L16_2 = 1
      if L16_2 then
        goto lbl_70
      end
    end
    L16_2 = 0
    ::lbl_70::
    L17_2 = A6_2 or L17_2
    if not A6_2 then
      L17_2 = 0
    end
    L18_2 = Now
    L18_2, L19_2 = L18_2()
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L10_2[4] = L14_2
    L10_2[5] = L15_2
    L10_2[6] = L16_2
    L10_2[7] = L17_2
    L10_2[8] = L18_2
    L10_2[9] = L19_2
    L8_2(L9_2, L10_2)
  end
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2
  if not A0_2 then
    return
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L1_3 = L0_3
    L0_3 = L0_3.set
    L2_3 = "apex_inCall"
    L3_3 = A1_2
    L4_3 = true
    L0_3(L1_3, L2_3, L3_3, L4_3)
  end
  L2_2(L3_2)
end
function L13_1(A0_2)
  local L1_2, L2_2
  L2_2 = A0_2.caller
  L1_2 = L2_1
  L1_2 = L1_2[L2_2]
  L2_2 = A0_2.id
  if L1_2 == L2_2 then
    L2_2 = A0_2.caller
    L1_2 = L2_1
    L1_2[L2_2] = nil
  end
  L2_2 = A0_2.callee
  L1_2 = L2_1
  L1_2 = L1_2[L2_2]
  L2_2 = A0_2.id
  if L1_2 == L2_2 then
    L2_2 = A0_2.callee
    L1_2 = L2_1
    L1_2[L2_2] = nil
  end
end
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A1_2 then
    L2_2 = "ended"
    L3_2 = "ended"
    L4_2 = "answered"
    L5_2 = "answered"
    return L2_2, L3_2, L4_2, L5_2
  end
  if "declined" == A0_2 then
    L2_2 = "declined"
    L3_2 = "ended"
    L4_2 = "declined"
    L5_2 = "declined"
    return L2_2, L3_2, L4_2, L5_2
  end
  if "busy" == A0_2 then
    L2_2 = "busy"
    L3_2 = "ended"
    L4_2 = "busy"
    L5_2 = "missed"
    return L2_2, L3_2, L4_2, L5_2
  end
  if "missed" == A0_2 then
    L2_2 = "missed"
    L3_2 = "missed"
    L4_2 = "missed"
    L5_2 = "missed"
    return L2_2, L3_2, L4_2, L5_2
  end
  L2_2 = "ended"
  L3_2 = "ended"
  L4_2 = "cancelled"
  L5_2 = "missed"
  return L2_2, L3_2, L4_2, L5_2
end
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L3_2 = L0_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L4_2 = L3_2.state
    if "ended" ~= L4_2 then
      goto lbl_9
    end
  end
  do return end
  ::lbl_9::
  L4_2 = L3_2.state
  L4_2 = "active" == L4_2
  L3_2.state = "ended"
  L5_2 = L0_1
  L5_2[A0_2] = nil
  L5_2 = L13_1
  L6_2 = L3_2
  L5_2(L6_2)
  if L4_2 then
    L5_2 = os
    L5_2 = L5_2.time
    L5_2 = L5_2()
    L6_2 = L3_2.answeredAt
    if not L6_2 then
      L6_2 = os
      L6_2 = L6_2.time
      L6_2 = L6_2()
    end
    L5_2 = L5_2 - L6_2
    if L5_2 then
      goto lbl_36
    end
  end
  L5_2 = 0
  ::lbl_36::
  L6_2 = L14_1
  L7_2 = A1_2
  L8_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2)
  L10_2 = L4_1
  L11_2 = "leave"
  L12_2 = A0_2
  L10_2(L11_2, L12_2)
  L10_2 = SpeakerCallEnded
  if L10_2 then
    L10_2 = pcall
    L11_2 = SpeakerCallEnded
    L12_2 = L3_2
    L10_2(L11_2, L12_2)
  end
  L10_2 = Push
  L11_2 = L3_2.caller
  L12_2 = "callState"
  L13_2 = {}
  L13_2.callId = A0_2
  L13_2.state = L6_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = Push
  L11_2 = L3_2.callee
  L12_2 = "callState"
  L13_2 = {}
  L13_2.callId = A0_2
  L13_2.state = L7_2
  L10_2(L11_2, L12_2, L13_2)
  if L4_2 then
    L10_2 = L12_1
    L11_2 = L3_2.caller
    L12_2 = false
    L10_2(L11_2, L12_2)
    L10_2 = L12_1
    L11_2 = L3_2.callee
    L12_2 = false
    L10_2(L11_2, L12_2)
  end
  L10_2 = L11_1
  L11_2 = L3_2.callerCid
  L12_2 = L3_2.calleeNum
  L13_2 = L3_2.calleeName
  L14_2 = true
  L15_2 = L4_2
  L16_2 = L3_2.video
  L17_2 = L5_2
  L18_2 = L8_2
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L10_2 = L11_1
  L11_2 = L3_2.calleeCid
  L12_2 = L3_2.callerNum
  L13_2 = L3_2.callerName
  L14_2 = false
  L15_2 = L4_2
  L16_2 = L3_2.video
  L17_2 = L5_2
  L18_2 = L9_2
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  if not L4_2 and "missed" == L9_2 and not A2_2 then
    L10_2 = L3_2.rang
    if L10_2 then
      L10_2 = L3_2.callerName
      if not L10_2 then
        L10_2 = L3_2.callerNum
      end
      L11_2 = {}
      L12_2 = L3_2.callerNum
      L11_2.number = L12_2
      L12_2 = SimLineTagCid
      if L12_2 then
        L12_2 = L3_2.calleeCid
        if L12_2 then
          L12_2 = SimLineTagCid
          L13_2 = L3_2.calleeCid
          L14_2 = L3_2.calleeNum
          L12_2 = L12_2(L13_2, L14_2)
          L11_2.line = L12_2
        end
      end
      L12_2 = L3_2.calleeCid
      if L12_2 then
        L12_2 = NotifyCitizen
        L13_2 = L3_2.calleeCid
        L14_2 = "phone"
        L15_2 = L10_2
        L16_2 = "Chamada n\195\163o atendida"
        L17_2 = L11_2
        L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
      else
        L12_2 = NotifyPlayer
        L13_2 = L3_2.callee
        L14_2 = "phone"
        L15_2 = L10_2
        L16_2 = "Chamada n\195\163o atendida"
        L17_2 = L11_2
        L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
      end
    end
  end
  L10_2 = L3_1
  L11_2 = "end %s reason=%s answered=%s dur=%s"
  L12_2 = A0_2
  L13_2 = tostring
  L14_2 = A1_2
  L13_2 = L13_2(L14_2)
  L14_2 = tostring
  L15_2 = L4_2
  L14_2 = L14_2(L15_2)
  L15_2 = L5_2
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = L3_2.rang
  if L10_2 then
    L10_2 = TriggerEvent
    L11_2 = "apex_phone:callEnded"
    L12_2 = A0_2
    L13_2 = A1_2
    L10_2(L11_2, L12_2, L13_2)
  end
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L2_2 = L0_1
    L2_2 = L2_2[L1_2]
  end
  if L2_2 then
    L3_2 = L2_2.state
    if "ended" ~= L3_2 then
      L3_2 = L2_2.state
      if "ringing" == L3_2 then
        L3_2 = os
        L3_2 = L3_2.time
        L3_2 = L3_2()
        L4_2 = L2_2.started
        if not L4_2 then
          L4_2 = os
          L4_2 = L4_2.time
          L4_2 = L4_2()
        end
        L3_2 = L3_2 - L4_2
        L4_2 = tonumber
        L5_2 = Config
        L5_2 = L5_2.CallTimeout
        L4_2 = L4_2(L5_2)
        if not L4_2 then
          L4_2 = 30
        end
        L4_2 = L4_2 + 20
        if L3_2 > L4_2 then
          L3_2 = L3_1
          L4_2 = "call %s: still ringing after the timeout: ending it"
          L5_2 = L1_2
          L3_2(L4_2, L5_2)
          L3_2 = L15_1
          L4_2 = L1_2
          L5_2 = "missed"
          L3_2(L4_2, L5_2)
          L3_2 = false
          return L3_2
        end
      end
      L3_2 = L2_2.state
      if "active" == L3_2 then
        L3_2 = GetPlayerName
        L4_2 = L2_2.caller
        L3_2 = L3_2(L4_2)
        if L3_2 then
          L3_2 = GetPlayerName
          L4_2 = L2_2.callee
          L3_2 = L3_2(L4_2)
          if L3_2 then
            goto lbl_70
          end
        end
        L3_2 = L3_1
        L4_2 = "call %s: a participant is gone: ending it"
        L5_2 = L1_2
        L3_2(L4_2, L5_2)
        L3_2 = L15_1
        L4_2 = L1_2
        L5_2 = "ended"
        L3_2(L4_2, L5_2)
        L3_2 = false
        return L3_2
      end
      ::lbl_70::
      L3_2 = true
      return L3_2
    end
  end
  L3_2 = L2_1
  L3_2[A0_2] = nil
  L3_2 = false
  return L3_2
end
L17_1 = RPC
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L2_2 = L0_1
    L2_2 = L2_2[L1_2]
  end
  if L2_2 then
    L3_2 = L2_2.state
    if "active" == L3_2 then
      goto lbl_16
    end
  end
  L3_2 = {}
  L3_2.none = true
  do return L3_2 end
  ::lbl_16::
  L3_2 = L4_1
  L4_2 = "session"
  L5_2 = L1_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L3_2.channel
    if L4_2 then
      goto lbl_32
    end
  end
  L4_2 = L4_1
  L5_2 = "channel"
  L6_2 = L1_2
  L4_2 = L4_2(L5_2, L6_2)
  ::lbl_32::
  L5_2 = {}
  L5_2.callId = L1_2
  L6_2 = L2_2.caller
  if L6_2 == A0_2 then
    L6_2 = L2_2.callee
    if L6_2 then
      goto lbl_42
    end
  end
  L6_2 = L2_2.caller
  ::lbl_42::
  L5_2.peer = L6_2
  L5_2.channel = L4_2
  L6_2 = L2_2.video
  L6_2 = true == L6_2
  L5_2.video = L6_2
  return L5_2
end
L17_1["calls.sync"] = L18_1
function L17_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = tonumber
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = -1
  end
  L4_2 = L0_1
  L3_2 = L4_2[L3_2]
  if L3_2 then
    L4_2 = L3_2.state
    if "active" == L4_2 then
      L4_2 = L3_2.caller
      if L4_2 == A0_2 then
        goto lbl_22
      end
      L4_2 = L3_2.callee
      if L4_2 == A0_2 then
        goto lbl_22
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_22::
  L4_2 = L3_2.speaker
  if not L4_2 then
    L4_2 = {}
  end
  L3_2.speaker = L4_2
  L4_2 = L3_2.speaker
  if A2_2 then
    L5_2 = true
    if L5_2 then
      goto lbl_35
    end
  end
  L5_2 = nil
  ::lbl_35::
  L4_2[A0_2] = L5_2
  L4_2 = L3_1
  L5_2 = "speaker %s on call %s: %s"
  L6_2 = A0_2
  L7_2 = L3_2.id
  L8_2 = tostring
  L9_2 = A2_2
  L8_2, L9_2 = L8_2(L9_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  return L3_2
end
CallSpeaker = L17_1
function L17_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.state
    if "active" == L7_2 then
      L7_2 = type
      L8_2 = L6_2.speaker
      L7_2 = L7_2(L8_2)
      if "table" == L7_2 then
        L7_2 = next
        L8_2 = L6_2.speaker
        L7_2 = L7_2(L8_2)
        if nil ~= L7_2 then
          L7_2 = L4_1
          L8_2 = "session"
          L9_2 = L5_2
          L7_2 = L7_2(L8_2, L9_2)
          L8_2 = type
          L9_2 = L7_2
          L8_2 = L8_2(L9_2)
          if "table" == L8_2 then
            L8_2 = L7_2.channel
            if L8_2 then
              goto lbl_36
            end
          end
          L8_2 = L4_1
          L9_2 = "channel"
          L10_2 = L5_2
          L8_2 = L8_2(L9_2, L10_2)
          ::lbl_36::
          L9_2 = #L0_2
          L9_2 = L9_2 + 1
          L10_2 = {}
          L10_2.id = L5_2
          L11_2 = L6_2.caller
          L10_2.caller = L11_2
          L11_2 = L6_2.callee
          L10_2.callee = L11_2
          L11_2 = L6_2.speaker
          L10_2.speaker = L11_2
          L10_2.channel = L8_2
          L0_2[L9_2] = L10_2
        end
      end
    end
  end
  return L0_2
end
CallsWithSpeaker = L17_1
function L17_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L2_2 = L0_1
    L2_2 = L2_2[L1_2]
  end
  L3_2 = nil ~= L2_2
  return L3_2
end
PlayerInCall = L17_1
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L2_1
  L2_2 = L2_2[A0_2]
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = L0_1
    L3_2 = L3_2[L2_2]
  end
  if L3_2 then
    L4_2 = L3_2.state
    if "ended" ~= L4_2 then
      goto lbl_14
    end
  end
  L4_2 = false
  do return L4_2 end
  ::lbl_14::
  L4_2 = A1_2
  if not L4_2 then
    L5_2 = L3_2.state
    if "active" == L5_2 then
      L4_2 = "ended"
    else
      L5_2 = L3_2.caller
      if L5_2 == A0_2 then
        L4_2 = "cancelled"
      else
        L4_2 = "declined"
      end
    end
  end
  L5_2 = L15_1
  L6_2 = L2_2
  L7_2 = L4_2
  L5_2(L6_2, L7_2)
  L5_2 = true
  return L5_2
end
EndCallsOf = L17_1
L17_1 = {}
function L18_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L7_2 = tostring
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = ">"
  L9_2 = tostring
  L10_2 = A1_2 or L10_2
  if not A1_2 then
    L10_2 = A3_2
  end
  L9_2 = L9_2(L10_2)
  L7_2 = L7_2 .. L8_2 .. L9_2
  L8_2 = os
  L8_2 = L8_2.time
  L8_2 = L8_2()
  L9_2 = L17_1
  L9_2 = L9_2[L7_2]
  if L9_2 then
    L9_2 = L17_1
    L9_2 = L9_2[L7_2]
    L9_2 = L8_2 - L9_2
    if L9_2 < 60 then
      return
    end
  end
  L9_2 = pairs
  L10_2 = L17_1
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L8_2 - L14_2
    if L15_2 >= 60 then
      L15_2 = L17_1
      L15_2[L13_2] = nil
    end
  end
  L9_2 = L17_1
  L9_2[L7_2] = L8_2
  L9_2 = L11_1
  L10_2 = A0_2
  L11_2 = A3_2
  L12_2 = L7_1
  L13_2 = A0_2
  L14_2 = A3_2
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = true
  L14_2 = false
  L15_2 = A4_2
  L16_2 = 0
  L17_2 = A5_2
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  if A1_2 then
    L9_2 = L7_1
    L10_2 = A1_2
    L11_2 = A2_2
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = L11_1
    L11_2 = A1_2
    L12_2 = A2_2
    L13_2 = L9_2
    L14_2 = false
    L15_2 = false
    L16_2 = A4_2
    L17_2 = 0
    L18_2 = "missed"
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    if A6_2 then
      L10_2 = NotifyCitizen
      L11_2 = A1_2
      L12_2 = "phone"
      L13_2 = L9_2 or L13_2
      if not L9_2 then
        L13_2 = A2_2
      end
      L14_2 = "Chamada n\195\163o atendida"
      L15_2 = {}
      L15_2.number = A2_2
      L16_2 = SimLineTagCid
      if L16_2 then
        L16_2 = SimLineTagCid
        L17_2 = A1_2
        L18_2 = A3_2
        L16_2 = L16_2(L17_2, L18_2)
        if L16_2 then
          goto lbl_91
        end
      end
      L16_2 = nil
      ::lbl_91::
      L15_2.line = L16_2
      L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    end
  end
end
L19_1 = RPC
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = RequireLine
  if L2_2 then
    L2_2 = RequireLine
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  if L2_2 then
    return L2_2
  end
  L3_2 = GetPlayerNumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.status = "offline"
    return L4_2
  end
  L4_2 = type
  L5_2 = A1_2.number
  L4_2 = L4_2(L5_2)
  if "string" ~= L4_2 then
    L4_2 = type
    L5_2 = A1_2.number
    L4_2 = L4_2(L5_2)
    if "number" ~= L4_2 then
      L4_2 = {}
      L4_2.status = "offline"
      return L4_2
    end
  end
  L4_2 = tostring
  L5_2 = A1_2.number
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.sub
  L6_2 = 1
  L7_2 = 20
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = A1_2.video
  if L5_2 then
    L5_2 = true
    if L5_2 then
      goto lbl_47
    end
  end
  L5_2 = false
  ::lbl_47::
  if "" == L4_2 then
    L6_2 = {}
    L6_2.status = "offline"
    return L6_2
  end
  L6_2 = CanonNumber
  if L6_2 then
    L6_2 = CanonNumber
    L7_2 = L4_2
    L6_2 = L6_2(L7_2)
    L4_2 = L6_2
  end
  if L4_2 == L3_2 then
    L6_2 = {}
    L6_2.status = "self"
    return L6_2
  end
  L6_2 = L5_1
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.status = "nophone"
    return L6_2
  end
  L6_2 = L16_1
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L6_2 = {}
    L6_2.status = "busy"
    return L6_2
  end
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = GetSrcByNumber
  L8_2 = L4_2
  L7_2 = L7_2(L8_2)
  if L7_2 then
    L8_2 = GetCid
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      goto lbl_100
    end
  end
  L8_2 = GetCitizenIdByNumber
  L9_2 = L4_2
  L8_2 = L8_2(L9_2)
  ::lbl_100::
  if L8_2 and L8_2 ~= L6_2 then
    L9_2 = L6_1
    L10_2 = L8_2
    L11_2 = L3_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L9_2 = L18_1
      L10_2 = L6_2
      L11_2 = nil
      L12_2 = L3_2
      L13_2 = L4_2
      L14_2 = L5_2
      L15_2 = "unavailable"
      L16_2 = false
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      L9_2 = L3_1
      L10_2 = "%s \226\134\146 %s: blocked by the recipient"
      L11_2 = A0_2
      L12_2 = L4_2
      L9_2(L10_2, L11_2, L12_2)
      L9_2 = {}
      L9_2.status = "unavailable"
      return L9_2
    end
  end
  if L7_2 then
    L9_2 = L5_1
    L10_2 = L7_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_167
    end
  end
  if L8_2 and L8_2 ~= L6_2 then
    L9_2 = L18_1
    L10_2 = L6_2
    L11_2 = L8_2
    L12_2 = L3_2
    L13_2 = L4_2
    L14_2 = L5_2
    L15_2 = "offline"
    L16_2 = not L7_2
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  else
    L9_2 = L18_1
    L10_2 = L6_2
    L11_2 = nil
    L12_2 = L3_2
    L13_2 = L4_2
    L14_2 = L5_2
    L15_2 = "offline"
    L16_2 = false
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  end
  L9_2 = L3_1
  L10_2 = "%s \226\134\146 %s: offline"
  L11_2 = A0_2
  L12_2 = L4_2
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = {}
  L9_2.status = "offline"
  do return L9_2 end
  ::lbl_167::
  if L7_2 == A0_2 then
    L9_2 = {}
    L9_2.status = "self"
    return L9_2
  end
  L9_2 = L16_1
  L10_2 = A0_2
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = {}
    L9_2.status = "busy"
    return L9_2
  end
  L9_2 = L16_1
  L10_2 = L7_2
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = L18_1
    L10_2 = L6_2
    L11_2 = GetCid
    L12_2 = L7_2
    L11_2 = L11_2(L12_2)
    L12_2 = L3_2
    L13_2 = L4_2
    L14_2 = L5_2
    L15_2 = "busy"
    L16_2 = true
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L9_2 = L3_1
    L10_2 = "%s \226\134\146 %s: busy"
    L11_2 = A0_2
    L12_2 = L4_2
    L9_2(L10_2, L11_2, L12_2)
    L9_2 = {}
    L9_2.status = "busy"
    return L9_2
  end
  L9_2 = L16_1
  L10_2 = A0_2
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = L16_1
    L10_2 = L7_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      goto lbl_221
    end
  end
  L9_2 = {}
  L9_2.status = "busy"
  do return L9_2 end
  ::lbl_221::
  L9_2 = L1_1
  L10_2 = L1_1
  L10_2 = L10_2 + 1
  L1_1 = L10_2
  L10_2 = {}
  L10_2.id = L9_2
  L10_2.caller = A0_2
  L10_2.callee = L7_2
  L10_2.callerCid = L6_2
  L10_2.calleeCid = nil
  L10_2.callerNum = L3_2
  L10_2.calleeNum = L4_2
  L10_2.state = "ringing"
  L10_2.video = L5_2
  L11_2 = os
  L11_2 = L11_2.time
  L11_2 = L11_2()
  L10_2.started = L11_2
  L11_2 = {}
  L10_2.muted = L11_2
  L11_2 = L0_1
  L11_2[L9_2] = L10_2
  L11_2 = L2_1
  L11_2[A0_2] = L9_2
  L11_2 = L2_1
  L11_2[L7_2] = L9_2
  L11_2 = GetCid
  L12_2 = L7_2
  L11_2 = L11_2(L12_2)
  L10_2.calleeCid = L11_2
  L11_2 = L7_1
  L12_2 = L10_2.calleeCid
  L13_2 = L3_2
  L11_2 = L11_2(L12_2, L13_2)
  L10_2.callerName = L11_2
  L11_2 = L7_1
  L12_2 = L6_2
  L13_2 = L4_2
  L11_2 = L11_2(L12_2, L13_2)
  L10_2.calleeName = L11_2
  L11_2 = L0_1
  L11_2 = L11_2[L9_2]
  if L11_2 == L10_2 then
    L11_2 = L10_2.state
    if "ringing" == L11_2 then
      goto lbl_276
    end
  end
  L11_2 = {}
  L11_2.callId = L9_2
  L11_2.status = "ended"
  do return L11_2 end
  ::lbl_276::
  L10_2.rang = true
  L11_2 = Push
  L12_2 = L7_2
  L13_2 = "incomingCall"
  L14_2 = {}
  L14_2.callId = L9_2
  L14_2.number = L3_2
  L15_2 = L10_2.callerName
  L14_2.name = L15_2
  L15_2 = L10_2.video
  L14_2.video = L15_2
  L15_2 = SimLineTag
  if L15_2 then
    L15_2 = SimLineTag
    L16_2 = L7_2
    L17_2 = L4_2
    L15_2 = L15_2(L16_2, L17_2)
    if L15_2 then
      goto lbl_298
    end
  end
  L15_2 = nil
  ::lbl_298::
  L14_2.line = L15_2
  L11_2(L12_2, L13_2, L14_2)
  L11_2 = SetTimeout
  L12_2 = Config
  L12_2 = L12_2.CallTimeout
  if not L12_2 then
    L12_2 = 30
  end
  L12_2 = L12_2 * 1000
  function L13_2()
    local L0_3, L1_3, L2_3
    L1_3 = L9_2
    L0_3 = L0_1
    L0_3 = L0_3[L1_3]
    L1_3 = L10_2
    if L0_3 == L1_3 then
      L0_3 = L10_2.state
      if "ringing" == L0_3 then
        L0_3 = L15_1
        L1_3 = L9_2
        L2_3 = "missed"
        L0_3(L1_3, L2_3)
      end
    end
  end
  L11_2(L12_2, L13_2)
  L11_2 = L3_1
  L12_2 = "start %s: %s (%s) \226\134\146 %s (%s) video=%s"
  L13_2 = L9_2
  L14_2 = A0_2
  L15_2 = L3_2
  L16_2 = L7_2
  L17_2 = L4_2
  L18_2 = tostring
  L19_2 = L10_2.video
  L18_2, L19_2 = L18_2(L19_2)
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L11_2 = TriggerEvent
  L12_2 = "apex_phone:callStarted"
  L13_2 = L9_2
  L14_2 = A0_2
  L15_2 = L7_2
  L11_2(L12_2, L13_2, L14_2, L15_2)
  L11_2 = {}
  L11_2.callId = L9_2
  L11_2.status = "ringing"
  L12_2 = L10_2.calleeName
  L11_2.name = L12_2
  return L11_2
end
L19_1["calls.start"] = L20_1
L19_1 = RPC
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = tonumber
  L3_2 = A1_2.callId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L0_1
  L2_2 = L3_2[L2_2]
  if L2_2 then
    L3_2 = L2_2.callee
    if L3_2 == A0_2 then
      L3_2 = L2_2.state
      if "ringing" == L3_2 then
        goto lbl_21
      end
    end
  end
  L3_2 = {}
  L3_2.ok = false
  do return L3_2 end
  ::lbl_21::
  L2_2.state = "active"
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  L2_2.answeredAt = L3_2
  L3_2 = L4_1
  L4_2 = "join"
  L5_2 = L2_2.id
  L6_2 = {}
  L7_2 = L2_2.caller
  L8_2 = L2_2.callee
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L3_2.channel
    if L4_2 then
      goto lbl_44
    end
  end
  L4_2 = nil
  ::lbl_44::
  L5_2 = Push
  L6_2 = L2_2.caller
  L7_2 = "callState"
  L8_2 = {}
  L9_2 = L2_2.id
  L8_2.callId = L9_2
  L8_2.state = "active"
  L9_2 = L2_2.callee
  L8_2.peer = L9_2
  L8_2.channel = L4_2
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = Push
  L6_2 = L2_2.callee
  L7_2 = "callState"
  L8_2 = {}
  L9_2 = L2_2.id
  L8_2.callId = L9_2
  L8_2.state = "active"
  L9_2 = L2_2.caller
  L8_2.peer = L9_2
  L8_2.channel = L4_2
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = L12_1
  L6_2 = L2_2.caller
  L7_2 = L2_2.id
  L5_2(L6_2, L7_2)
  L5_2 = L12_1
  L6_2 = L2_2.callee
  L7_2 = L2_2.id
  L5_2(L6_2, L7_2)
  L5_2 = pairs
  L6_2 = L2_2.muted
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    if L10_2 then
      L11_2 = L2_2.caller
      if L9_2 == L11_2 then
        L11_2 = L2_2.callee
        if L11_2 then
          goto lbl_89
        end
      end
      L11_2 = L2_2.caller
      ::lbl_89::
      L12_2 = L4_1
      L13_2 = "muteFrom"
      L14_2 = L2_2.id
      L15_2 = L9_2
      L16_2 = true
      L17_2 = {}
      L18_2 = L11_2
      L17_2[1] = L18_2
      L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
      if nil == L12_2 then
        L12_2 = Push
        L13_2 = L11_2
        L14_2 = "callMute"
        L15_2 = {}
        L15_2.src = L9_2
        L15_2.on = true
        L16_2 = L2_2.id
        L15_2.callId = L16_2
        L12_2(L13_2, L14_2, L15_2)
      end
    end
  end
  L5_2 = L3_1
  L6_2 = "answered %s"
  L7_2 = L2_2.id
  L5_2(L6_2, L7_2)
  L5_2 = TriggerEvent
  L6_2 = "apex_phone:callAnswered"
  L7_2 = L2_2.id
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L19_1["calls.accept"] = L20_1
L19_1 = RPC
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = tonumber
  L3_2 = A1_2.callId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L0_1
  L2_2 = L3_2[L2_2]
  if L2_2 then
    L3_2 = L2_2.caller
    if L3_2 == A0_2 then
      goto lbl_21
    end
    L3_2 = L2_2.callee
    if L3_2 == A0_2 then
      goto lbl_21
    end
  end
  L3_2 = {}
  L3_2.ok = false
  do return L3_2 end
  ::lbl_21::
  L3_2 = nil
  L4_2 = L2_2.state
  if "active" == L4_2 then
    L3_2 = "ended"
  else
    L4_2 = L2_2.callee
    if L4_2 == A0_2 then
      L4_2 = A1_2.busy
      if L4_2 then
        L4_2 = "busy"
        L3_2 = L4_2 or L3_2
      end
      if not L4_2 then
        L3_2 = "declined"
      end
    else
      L3_2 = "cancelled"
    end
  end
  L4_2 = L15_1
  L5_2 = L2_2.id
  L6_2 = L3_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L19_1["calls.decline"] = L20_1
L19_1 = RPC
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = tonumber
  L3_2 = A1_2.callId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L0_1
  L2_2 = L3_2[L2_2]
  if L2_2 then
    L3_2 = L2_2.caller
    if L3_2 == A0_2 then
      goto lbl_21
    end
    L3_2 = L2_2.callee
    if L3_2 == A0_2 then
      goto lbl_21
    end
  end
  L3_2 = {}
  L3_2.ok = false
  do return L3_2 end
  ::lbl_21::
  L3_2 = "ended"
  L4_2 = L2_2.state
  if "ringing" == L4_2 then
    L4_2 = L2_2.caller
    if L4_2 == A0_2 then
      L4_2 = "cancelled"
      if L4_2 then
        goto lbl_32
        L3_2 = L4_2 or L3_2
      end
    end
    L3_2 = "declined"
  end
  ::lbl_32::
  L4_2 = L15_1
  L5_2 = L2_2.id
  L6_2 = L3_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L19_1["calls.end"] = L20_1
L19_1 = RPC
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = tonumber
  L3_2 = A1_2.callId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L0_1
  L2_2 = L3_2[L2_2]
  if L2_2 then
    L3_2 = L2_2.state
    if "ended" ~= L3_2 then
      L3_2 = L2_2.caller
      if L3_2 == A0_2 then
        goto lbl_24
      end
      L3_2 = L2_2.callee
      if L3_2 == A0_2 then
        goto lbl_24
      end
    end
  end
  L3_2 = {}
  L3_2.ok = false
  do return L3_2 end
  ::lbl_24::
  L3_2 = A1_2.on
  if L3_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_31
    end
  end
  L3_2 = false
  ::lbl_31::
  L4_2 = L2_2.muted
  L5_2 = L3_2 or L5_2
  if not L3_2 then
    L5_2 = nil
  end
  L4_2[A0_2] = L5_2
  L4_2 = L2_2.state
  if "active" == L4_2 then
    L4_2 = L2_2.caller
    if L4_2 == A0_2 then
      L4_2 = L2_2.callee
      if L4_2 then
        goto lbl_46
      end
    end
    L4_2 = L2_2.caller
    ::lbl_46::
    L5_2 = L4_1
    L6_2 = "muteFrom"
    L7_2 = L2_2.id
    L8_2 = A0_2
    L9_2 = L3_2
    L10_2 = {}
    L11_2 = L4_2
    L10_2[1] = L11_2
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    if nil == L5_2 then
      L5_2 = Push
      L6_2 = L4_2
      L7_2 = "callMute"
      L8_2 = {}
      L8_2.src = A0_2
      L8_2.on = L3_2
      L9_2 = L2_2.id
      L8_2.callId = L9_2
      L5_2(L6_2, L7_2, L8_2)
    end
  end
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L19_1["calls.mute"] = L20_1
L19_1 = {}
L19_1.answered = true
L19_1.missed = true
L19_1.declined = true
L19_1.busy = true
L19_1.cancelled = true
L19_1.offline = true
L19_1.unavailable = true
L20_1 = RPC
function L21_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_calls WHERE owner = ? ORDER BY created DESC, id DESC LIMIT 100"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.outgoing
    L9_2 = 1 == L9_2
    L8_2.outgoing = L9_2
    L9_2 = L8_2.answered
    L9_2 = 1 == L9_2
    L8_2.answered = L9_2
    L9_2 = L8_2.video
    L9_2 = 1 == L9_2
    L8_2.video = L9_2
    L10_2 = L8_2.status
    L9_2 = L19_1
    L9_2 = L9_2[L10_2]
    if not L9_2 then
      L9_2 = L8_2.answered
      if L9_2 then
        L8_2.status = "answered"
      else
        L9_2 = L8_2.outgoing
        if not L9_2 then
          L8_2.status = "missed"
        else
          L8_2.status = nil
        end
      end
    end
  end
  return L2_2
end
L20_1["calls.history"] = L21_1
L20_1 = RPC
function L21_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "DELETE FROM apex_phone_calls WHERE owner = ?"
  L3_2 = {}
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L1_2(L2_2, L3_2)
  L1_2 = {}
  L1_2.ok = true
  return L1_2
end
L20_1["calls.clear"] = L21_1
L20_1 = 20000
L21_1 = 120
L22_1 = {}
L23_1 = RegisterNetEvent
L24_1 = "apex_phone:server:fcFrame"
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = source
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = -1
  end
  L5_2 = L0_1
  L4_2 = L5_2[L4_2]
  if L4_2 then
    L5_2 = L4_2.state
    if "active" == L5_2 then
      L5_2 = L4_2.video
      if L5_2 then
        goto lbl_19
      end
    end
  end
  do return end
  ::lbl_19::
  L5_2 = L4_2.caller
  if L5_2 ~= L3_2 then
    L5_2 = L4_2.callee
    if L5_2 ~= L3_2 then
      return
    end
  end
  L5_2 = L4_2.caller
  if L5_2 == L3_2 then
    L5_2 = L4_2.callee
    if L5_2 then
      goto lbl_33
    end
  end
  L5_2 = L4_2.caller
  ::lbl_33::
  if false == A2_2 or nil == A2_2 then
    L6_2 = TriggerClientEvent
    L7_2 = "apex_phone:client:fcFrame"
    L8_2 = L5_2
    L9_2 = L4_2.id
    L10_2 = 0
    L11_2 = false
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
    return
  end
  L6_2 = type
  L7_2 = A2_2
  L6_2 = L6_2(L7_2)
  if "string" ~= L6_2 then
    return
  end
  L6_2 = #A2_2
  if not (L6_2 < 64) then
    L7_2 = L20_1
    if not (L6_2 > L7_2) then
      L8_2 = A2_2
      L7_2 = A2_2.find
      L9_2 = "[^%w%+/=]"
      L7_2 = L7_2(L8_2, L9_2)
      if not L7_2 then
        goto lbl_63
      end
    end
  end
  do return end
  ::lbl_63::
  L7_2 = GetGameTimer
  L7_2 = L7_2()
  L8_2 = L22_1
  L8_2 = L8_2[L3_2]
  if not L8_2 then
    L8_2 = 0
  end
  L8_2 = L7_2 - L8_2
  L9_2 = L21_1
  if L8_2 < L9_2 then
    return
  end
  L8_2 = L22_1
  L8_2[L3_2] = L7_2
  L8_2 = TriggerClientEvent
  L9_2 = "apex_phone:client:fcFrame"
  L10_2 = L5_2
  L11_2 = L4_2.id
  L12_2 = tonumber
  L13_2 = A1_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 0
  end
  L13_2 = A2_2
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
end
L23_1(L24_1, L25_1)
L23_1 = AddEventHandler
L24_1 = "playerDropped"
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = source
  L1_2 = L22_1
  L1_2[L0_2] = nil
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.caller
    if L7_2 ~= L0_2 then
      L7_2 = L6_2.callee
      if L7_2 ~= L0_2 then
        goto lbl_29
      end
    end
    L7_2 = "ended"
    L8_2 = L6_2.state
    if "ringing" == L8_2 then
      L8_2 = L6_2.caller
      if L8_2 == L0_2 then
        L8_2 = "cancelled"
        if L8_2 then
          goto lbl_25
          L7_2 = L8_2 or L7_2
        end
      end
      L7_2 = "missed"
    end
    ::lbl_25::
    L8_2 = L15_1
    L9_2 = L5_2
    L10_2 = L7_2
    L8_2(L9_2, L10_2)
    ::lbl_29::
  end
  L1_2 = L2_1
  L1_2[L0_2] = nil
end
L23_1(L24_1, L25_1)
L23_1 = AddEventHandler
L24_1 = "onResourceStop"
function L25_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = L15_1
    L7_2 = L5_2
    L8_2 = "stopped"
    L9_2 = true
    L6_2(L7_2, L8_2, L9_2)
  end
end
L23_1(L24_1, L25_1)
