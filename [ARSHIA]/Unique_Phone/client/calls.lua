local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1
L0_1 = nil
L1_1 = {}
L1_1.ended = true
L1_1.declined = true
L1_1.missed = true
L1_1.busy = true
function L2_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
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
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = ...
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L1_2 then
    L3_2 = print
    L4_2 = "[unique_phone] Voice."
    L5_2 = A0_2
    L6_2 = " failed: "
    L7_2 = tostring
    L8_2 = L2_2
    L7_2 = L7_2(L8_2)
    L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2
    L3_2(L4_2)
    L3_2 = nil
    return L3_2
  end
  return L2_2
end
function L3_1()
  local L0_2, L1_2
  L0_2 = L2_1
  L1_2 = "leave"
  L0_2(L1_2)
  L0_2 = L0_1
  if L0_2 then
    L0_2 = PhoneCallProp
    if L0_2 then
      L0_2 = PhoneCallProp
      L1_2 = false
      L0_2(L1_2)
    end
  end
  L0_2 = nil
  L0_1 = L0_2
end
L4_1 = false
function L5_1(A0_2)
  local L1_2, L2_2
  L1_2 = NetworkIsPlayerTalking
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = true == L1_2 or 1 == L1_2
  return L2_2
end
function L6_1(A0_2)
  local L1_2, L2_2
  L1_2 = L4_1
  if L1_2 then
    return
  end
  L1_2 = true
  L4_1 = L1_2
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = nil
    L1_3 = nil
    while true do
      L2_3 = L0_1
      if not L2_3 then
        break
      end
      L2_3 = L5_1
      L3_3 = PlayerId
      L3_3, L4_3, L5_3, L6_3 = L3_3()
      L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3)
      L3_3 = false
      L4_3 = A0_2
      if L4_3 then
        L4_3 = GetPlayerFromServerId
        L5_3 = A0_2
        L4_3 = L4_3(L5_3)
        if -1 ~= L4_3 then
          L5_3 = L5_1
          L6_3 = L4_3
          L5_3 = L5_3(L6_3)
          L3_3 = L5_3
        end
      end
      if L2_3 ~= L0_3 or L3_3 ~= L1_3 then
        L4_3 = L2_3
        L1_3 = L3_3
        L0_3 = L4_3
        L4_3 = Push
        L5_3 = "callTalk"
        L6_3 = {}
        L6_3.me = L2_3
        L6_3.peer = L3_3
        L4_3(L5_3, L6_3)
      end
      L4_3 = Wait
      L5_3 = 120
      L4_3(L5_3)
    end
    L2_3 = Push
    L3_3 = "callTalk"
    L4_3 = {}
    L4_3.me = false
    L4_3.peer = false
    L2_3(L3_3, L4_3)
    L2_3 = false
    L4_1 = L2_3
  end
  L1_2(L2_2)
end
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_1 = A0_2
  L3_2 = L2_1
  L4_2 = "join"
  L5_2 = A0_2
  L6_2 = {}
  L7_2 = tonumber
  L8_2 = A1_2
  L7_2, L8_2 = L7_2(L8_2)
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L7_2 = tonumber
  L8_2 = A2_2
  L7_2, L8_2 = L7_2(L8_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = PhoneCallProp
  if L3_2 then
    L3_2 = PhoneCallProp
    L4_2 = true
    L3_2(L4_2)
  end
  L3_2 = L6_1
  L4_2 = tonumber
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
function L8_1()
  local L0_2, L1_2, L2_2
  L0_2 = LocalPlayer
  L0_2 = L0_2.state
  L0_2 = L0_2.apex_inCall
  if nil == L0_2 or false == L0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tonumber
  L2_2 = L0_2
  return L1_2(L2_2)
end
L9_1 = false
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = ServerRpc
  L2_2 = "calls.sync"
  L3_2 = {}
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = A0_3.callId
      if L1_3 then
        goto lbl_26
      end
    end
    L1_3 = L0_1
    if L1_3 then
      L1_3 = print
      L2_3 = "[unique_phone] call %s: the server has no active call for this player (%s): leaving the voice channel"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = tostring
      L5_3 = L0_1
      L4_3 = L4_3(L5_3)
      L5_3 = tostring
      L6_3 = A0_2
      L5_3, L6_3, L7_3 = L5_3(L6_3)
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
      L1_3 = L3_1
      L1_3()
    end
    do return end
    ::lbl_26::
    L1_3 = tonumber
    L2_3 = A0_3.callId
    L1_3 = L1_3(L2_3)
    L2_3 = L0_1
    if L2_3 == L1_3 then
      return
    end
    L2_3 = L0_1
    if L2_3 then
      L2_3 = L3_1
      L2_3()
    end
    L2_3 = print
    L3_3 = "[unique_phone] call %s: re-joined from the server state (%s)"
    L4_3 = L3_3
    L3_3 = L3_3.format
    L5_3 = tostring
    L6_3 = L1_3
    L5_3 = L5_3(L6_3)
    L6_3 = tostring
    L7_3 = A0_2
    L6_3, L7_3 = L6_3(L7_3)
    L3_3, L4_3, L5_3, L6_3, L7_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
    L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
    L2_3 = L7_1
    L3_3 = L1_3
    L4_3 = A0_3.peer
    L5_3 = A0_3.channel
    L2_3(L3_3, L4_3, L5_3)
  end
  L1_2(L2_2, L3_2, L4_2)
end
function L11_1()
  local L0_2, L1_2
  L0_2 = L9_1
  if L0_2 then
    return
  end
  L0_2 = true
  L9_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = 0
    while true do
      L1_3 = L0_1
      if not L1_3 then
        L1_3 = L8_1
        L1_3 = L1_3()
        if not L1_3 then
          break
        end
      end
      L1_3 = Wait
      L2_3 = 2000
      L1_3(L2_3)
      L1_3 = L8_1
      L1_3 = L1_3()
      L2_3 = L0_1
      if L1_3 == L2_3 then
        L0_3 = 0
      else
        L0_3 = L0_3 + 1
        if L0_3 >= 2 then
          L0_3 = 0
          L2_3 = L0_1
          if L2_3 and not L1_3 then
            L2_3 = print
            L3_3 = "[unique_phone] call %s: the server says this player is not in a call: leaving the voice channel"
            L4_3 = L3_3
            L3_3 = L3_3.format
            L5_3 = tostring
            L6_3 = L0_1
            L5_3, L6_3 = L5_3(L6_3)
            L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
            L2_3(L3_3, L4_3, L5_3, L6_3)
            L2_3 = L3_1
            L2_3()
          else
            L2_3 = L10_1
            L3_3 = L0_1
            if L3_3 then
              L3_3 = "another call is active on the server"
              if L3_3 then
                goto lbl_48
              end
            end
            L3_3 = "the 'active' push never arrived"
            ::lbl_48::
            L2_3(L3_3)
          end
        end
      end
    end
    L1_3 = false
    L9_1 = L1_3
  end
  L0_2(L1_2)
end
L12_1 = AddStateBagChangeHandler
L13_1 = "apex_inCall"
L14_1 = nil
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = "player:%d"
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = GetPlayerServerId
  L4_2 = PlayerId
  L4_2 = L4_2()
  L3_2, L4_2 = L3_2(L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = SetTimeout
  L2_2 = 0
  L3_2 = L11_1
  L1_2(L2_2, L3_2)
end
L12_1(L13_1, L14_1, L15_1)
function L12_1()
  local L0_2, L1_2, L2_2
  L0_2 = L0_1
  L0_2 = nil ~= L0_2
  L1_2 = L3_1
  L1_2()
  L1_2 = L2_1
  L2_2 = "unlisten"
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L0_2 = true
  end
  return L0_2
end
CallsReset = L12_1
L12_1 = RegisterNetEvent
L13_1 = "apex_phone:client:push"
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return
  end
  if "callState" == A0_2 then
    L2_2 = tonumber
    L3_2 = A1_2.callId
    L2_2 = L2_2(L3_2)
    L3_2 = A1_2.state
    if "active" == L3_2 then
      if not L2_2 then
        return
      end
      L3_2 = L0_1
      if L3_2 == L2_2 then
        return
      end
      L3_2 = L0_1
      if L3_2 then
        L3_2 = print
        L4_2 = "[unique_phone] call %s became active while call %s was still marked active here: switching"
        L5_2 = L4_2
        L4_2 = L4_2.format
        L6_2 = tostring
        L7_2 = L2_2
        L6_2 = L6_2(L7_2)
        L7_2 = tostring
        L8_2 = L0_1
        L7_2, L8_2 = L7_2(L8_2)
        L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
        L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
        L3_2 = L3_1
        L3_2()
      end
      L3_2 = L7_1
      L4_2 = L2_2
      L5_2 = A1_2.peer
      L6_2 = A1_2.channel
      L3_2(L4_2, L5_2, L6_2)
      L3_2 = L11_1
      L3_2()
    else
      L4_2 = A1_2.state
      L3_2 = L1_1
      L3_2 = L3_2[L4_2]
      if not L3_2 then
        goto lbl_109
      end
      L3_2 = L0_1
      if L3_2 then
        if not L2_2 then
          goto lbl_60
        end
        L3_2 = L0_1
        if L2_2 == L3_2 then
          goto lbl_60
        end
      end
      do return end
      ::lbl_60::
      L3_2 = L3_1
      L3_2()
    end
  elseif "callMute" == A0_2 then
    L2_2 = tonumber
    L3_2 = A1_2.callId
    L2_2 = L2_2(L3_2)
    L3_2 = L0_1
    if L3_2 then
      if not L2_2 then
        goto lbl_77
      end
      L3_2 = L0_1
      if L2_2 == L3_2 then
        goto lbl_77
      end
    end
    do return end
    ::lbl_77::
    L3_2 = L2_1
    L4_2 = "muteFrom"
    L5_2 = tonumber
    L6_2 = A1_2.src
    L5_2 = L5_2(L6_2)
    L6_2 = A1_2.on
    if L6_2 then
      L6_2 = true
      if L6_2 then
        goto lbl_89
      end
    end
    L6_2 = false
    ::lbl_89::
    L3_2(L4_2, L5_2, L6_2)
  elseif "speakerJoin" == A0_2 then
    L2_2 = L0_1
    if L2_2 then
      return
    end
    L2_2 = L2_1
    L3_2 = "listen"
    L4_2 = tonumber
    L5_2 = A1_2.channel
    L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  elseif "speakerLeave" == A0_2 then
    L2_2 = L2_1
    L3_2 = "unlisten"
    L2_2(L3_2)
  end
  ::lbl_109::
end
L12_1(L13_1, L14_1)
L12_1 = RegisterNUICallback
L13_1 = "callAction"
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = tonumber
  L3_2 = A0_2.callId
  L2_2 = L2_2(L3_2)
  L3_2 = A0_2.action
  if "end" == L3_2 then
    L3_2 = L0_1
    if L3_2 then
      if L2_2 then
        L3_2 = L0_1
      end
      if L2_2 == L3_2 then
        L3_2 = L3_1
        L3_2()
      end
    end
  else
    L3_2 = A0_2.action
    if "mute" == L3_2 then
    else
      L3_2 = A0_2.action
      if "speaker" == L3_2 then
        L3_2 = L0_1
        if L3_2 then
          if L2_2 then
            L3_2 = L0_1
            if L2_2 ~= L3_2 then
              goto lbl_52
            end
          end
          L3_2 = TriggerServerEvent
          L4_2 = "apex_phone:server:speaker"
          L5_2 = L0_1
          L6_2 = A0_2.on
          L6_2 = true == L6_2
          L3_2(L4_2, L5_2, L6_2)
        end
      end
    end
  end
  ::lbl_52::
  L3_2 = A1_2
  L4_2 = "ok"
  L3_2(L4_2)
end
L12_1(L13_1, L14_1)
L12_1 = 20000
L13_1 = 150
L14_1 = 64000
L15_1 = 128000
L16_1 = 0
L17_1 = L15_1
L18_1 = 0
L19_1 = RegisterNUICallback
L20_1 = "fcFrame"
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return
  end
  L2_2 = tonumber
  L3_2 = A0_2.callId
  L2_2 = L2_2(L3_2)
  L3_2 = L0_1
  if L3_2 then
    L3_2 = L0_1
    if L2_2 == L3_2 then
      goto lbl_20
    end
  end
  do return end
  ::lbl_20::
  L3_2 = A0_2.off
  if L3_2 then
    L3_2 = TriggerServerEvent
    L4_2 = "apex_phone:server:fcFrame"
    L5_2 = L2_2
    L6_2 = 0
    L7_2 = false
    L3_2(L4_2, L5_2, L6_2, L7_2)
    return
  end
  L3_2 = A0_2.img
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = #L3_2
    if not (L4_2 < 64) then
      L4_2 = #L3_2
      L5_2 = L12_1
      if not (L4_2 > L5_2) then
        goto lbl_44
      end
    end
  end
  do return end
  ::lbl_44::
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L5_2 = L16_1
  L5_2 = L4_2 - L5_2
  L6_2 = L13_1
  if L5_2 < L6_2 then
    return
  end
  L5_2 = math
  L5_2 = L5_2.min
  L6_2 = L15_1
  L7_2 = L17_1
  L8_2 = L18_1
  L8_2 = L4_2 - L8_2
  L9_2 = L14_1
  L8_2 = L8_2 * L9_2
  L8_2 = L8_2 / 1000
  L7_2 = L7_2 + L8_2
  L5_2 = L5_2(L6_2, L7_2)
  L17_1 = L5_2
  L18_1 = L4_2
  L5_2 = L17_1
  L6_2 = #L3_2
  if L5_2 < L6_2 then
    return
  end
  L5_2 = L17_1
  L6_2 = #L3_2
  L5_2 = L5_2 - L6_2
  L17_1 = L5_2
  L16_1 = L4_2
  L5_2 = TriggerServerEvent
  L6_2 = "apex_phone:server:fcFrame"
  L7_2 = L2_2
  L8_2 = tonumber
  L9_2 = A0_2.seq
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  L9_2 = L3_2
  L5_2(L6_2, L7_2, L8_2, L9_2)
end
L19_1(L20_1, L21_1)
L19_1 = RegisterNetEvent
L20_1 = "apex_phone:client:fcFrame"
function L21_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L0_1
  if L4_2 then
    L4_2 = L0_1
    if L3_2 == L4_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 and "" ~= A2_2 then
    L4_2 = Push
    L5_2 = "fcFrame"
    L6_2 = {}
    L6_2.callId = L3_2
    L7_2 = tonumber
    L8_2 = A1_2
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      L7_2 = 0
    end
    L6_2.seq = L7_2
    L6_2.img = A2_2
    L4_2(L5_2, L6_2)
  else
    L4_2 = Push
    L5_2 = "fcFrame"
    L6_2 = {}
    L6_2.callId = L3_2
    L6_2.off = true
    L4_2(L5_2, L6_2)
  end
end
L19_1(L20_1, L21_1)
L19_1 = AddEventHandler
L20_1 = "onResourceStop"
function L21_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = L3_1
  L1_2()
  L1_2 = L2_1
  L2_2 = "unlisten"
  L1_2(L2_2)
end
L19_1(L20_1, L21_1)
