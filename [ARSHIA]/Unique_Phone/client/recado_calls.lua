local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1
L0_1 = 250
L1_1 = 4.0
L2_1 = nil
L3_1 = false
function L4_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = Dbg
  if L1_2 then
    L1_2 = Dbg
    L2_2 = "recado_calls"
    L3_2 = A0_2
    L4_2 = ...
    L1_2(L2_2, L3_2, L4_2)
  end
end
function L5_1(A0_2, ...)
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
    L4_2 = "[unique_phone] recado: Voice."
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
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = Push
  L2_2 = L2_2(L3_2)
  if "function" == L2_2 then
    L2_2 = Push
    L3_2 = A0_2
    L4_2 = A1_2
    L2_2(L3_2, L4_2)
  else
    L2_2 = SendNUIMessage
    L3_2 = {}
    L3_2.action = "push"
    L3_2.event = A0_2
    L3_2.data = A1_2
    L2_2(L3_2)
  end
end
function L7_1()
  local L0_2, L1_2
  L0_2 = GetPlayerServerId
  L1_2 = PlayerId
  L1_2 = L1_2()
  return L0_2(L1_2)
end
function L8_1()
  local L0_2, L1_2
  L0_2 = LocalPlayer
  L0_2 = L0_2.state
  L0_2 = L0_2.apex_inCall
  L1_2 = nil ~= L0_2 and false ~= L0_2
  return L1_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetPlayerFromServerId
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if -1 == L1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = GetPlayerPed
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L3_2 = DoesEntityExist
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = GetEntityCoords
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = GetEntityCoords
  L5_2 = PlayerPedId
  L5_2 = L5_2()
  L4_2 = L4_2(L5_2)
  L3_2 = L3_2 - L4_2
  L3_2 = #L3_2
  L4_2 = L1_1
  L3_2 = L3_2 <= L4_2
  return L3_2
end
function L10_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L5_1
  L1_2 = "provider"
  L0_2 = L0_2(L1_2)
  if "pma-voice" ~= L0_2 then
    L0_2 = -1.0
    return L0_2
  end
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = exports
    L0_3 = L0_3["pma-voice"]
    L1_3 = L0_3
    L0_3 = L0_3.getCallVolume
    return L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 then
    L2_2 = tonumber
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_19
      L1_2 = L2_2 or L1_2
    end
  end
  L1_2 = nil
  ::lbl_19::
  if L1_2 then
    L2_2 = L1_2 / 100
    if L2_2 then
      goto lbl_26
    end
  end
  L2_2 = -1.0
  ::lbl_26::
  return L2_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = MumbleSetVolumeOverrideByServerId
  L2_2 = A0_2
  L3_2 = L9_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L3_2 = -1.0
    if L3_2 then
      goto lbl_12
    end
  end
  L3_2 = 0.0
  ::lbl_12::
  L1_2(L2_2, L3_2)
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if A1_2 then
    L2_2 = MumbleSetVolumeOverrideByServerId
    L3_2 = A0_2
    L4_2 = -1.0
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L2_1
  if L2_2 then
    L2_2 = L2_1.participants
    L2_2 = L2_2[A0_2]
  end
  if L2_2 then
    L3_2 = L2_2.muted
    if L3_2 then
      L3_2 = L5_1
      L4_2 = "muteFrom"
      L5_2 = A0_2
      L6_2 = true
      L3_2(L4_2, L5_2, L6_2)
  end
  else
    L3_2 = MumbleSetVolumeOverrideByServerId
    L4_2 = A0_2
    L5_2 = L9_1
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      L5_2 = -1.0
      if L5_2 then
        goto lbl_36
      end
    end
    L5_2 = L10_1
    L5_2 = L5_2()
    ::lbl_36::
    L3_2(L4_2, L5_2)
  end
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L5_1
  L2_2 = "join"
  L3_2 = A0_2.voiceId
  L4_2 = {}
  L5_2 = A0_2.channel
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if not L1_2 then
    return
  end
  L2_2 = L7_1
  L2_2 = L2_2()
  L3_2 = pairs
  L4_2 = A0_2.participants
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L7_2 ~= L2_2 then
      L9_2 = L8_2.muted
      if L9_2 then
        L9_2 = L5_1
        L10_2 = "muteFrom"
        L11_2 = L7_2
        L12_2 = true
        L9_2(L10_2, L11_2, L12_2)
      end
    end
  end
  L3_2 = L4_1
  L4_2 = "group voice %s restored (the Phone app had dropped it)"
  L5_2 = A0_2.callId
  L3_2(L4_2, L5_2)
end
function L14_1()
  local L0_2, L1_2
  L0_2 = L3_1
  if L0_2 then
    return
  end
  L0_2 = true
  L3_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    while true do
      L0_3 = L2_1
      if not L0_3 then
        break
      end
      L0_3 = L2_1
      L1_3 = L0_3.phoneTook
      if not L1_3 then
        L1_3 = type
        L2_3 = Voice
        L1_3 = L1_3(L2_3)
        if "table" == L1_3 then
          L1_3 = type
          L2_3 = Voice
          L2_3 = L2_3.active
          L1_3 = L1_3(L2_3)
          if "function" == L1_3 then
            L1_3 = L5_1
            L2_3 = "active"
            L1_3 = L1_3(L2_3)
            if nil == L1_3 then
              L1_3 = L8_1
              L1_3 = L1_3()
              if not L1_3 then
                L1_3 = L13_1
                L2_3 = L0_3
                L1_3(L2_3)
              end
            end
          end
        end
      end
      L1_3 = {}
      L2_3 = {}
      L3_3 = L7_1
      L3_3 = L3_3()
      L4_3 = pairs
      L5_3 = L0_3.participants
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
      for L8_3 in L4_3, L5_3, L6_3, L7_3 do
        L9_3 = nil
        if L8_3 == L3_3 then
          L10_3 = NetworkIsPlayerTalking
          L11_3 = PlayerId
          L11_3, L12_3 = L11_3()
          L10_3 = L10_3(L11_3, L12_3)
          L9_3 = L10_3
        else
          L10_3 = GetPlayerFromServerId
          L11_3 = L8_3
          L10_3 = L10_3(L11_3)
          L11_3 = NetworkIsPlayerTalking
          L12_3 = L10_3
          L11_3 = L11_3(L12_3)
          L9_3 = -1 ~= L10_3 and L9_3
        end
        if L9_3 then
          L10_3 = #L1_3
          L10_3 = L10_3 + 1
          L1_3[L10_3] = L8_3
        end
      end
      L4_3 = table
      L4_3 = L4_3.sort
      L5_3 = L1_3
      L4_3(L5_3)
      L4_3 = ipairs
      L5_3 = L1_3
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
      for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
        L10_3 = tostring
        L11_3 = L9_3
        L10_3 = L10_3(L11_3)
        L2_3[L8_3] = L10_3
      end
      L4_3 = table
      L4_3 = L4_3.concat
      L5_3 = L2_3
      L6_3 = ","
      L4_3 = L4_3(L5_3, L6_3)
      L5_3 = L0_3.lastTalk
      if L4_3 ~= L5_3 then
        L0_3.lastTalk = L4_3
        L5_3 = L6_1
        L6_3 = "recadoCallTalking"
        L7_3 = {}
        L8_3 = L0_3.callId
        L7_3.callId = L8_3
        L7_3.talking = L1_3
        L5_3(L6_3, L7_3)
      end
      L5_3 = next
      L6_3 = L0_3.localMuted
      L5_3 = L5_3(L6_3)
      if nil ~= L5_3 then
        L5_3 = pairs
        L6_3 = L0_3.localMuted
        L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
        for L9_3 in L5_3, L6_3, L7_3, L8_3 do
          L10_3 = L11_1
          L11_3 = L9_3
          L10_3(L11_3)
        end
      end
      L5_3 = Wait
      L6_3 = L0_1
      L5_3(L6_3)
    end
    L0_3 = false
    L3_1 = L0_3
  end
  L0_2(L1_2)
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = L2_1
  if L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = type
      L2_2 = A0_2.participants
      L1_2 = L1_2(L2_2)
      if "table" == L1_2 then
        goto lbl_15
      end
    end
  end
  do return end
  ::lbl_15::
  L1_2 = L7_1
  L1_2 = L1_2()
  L2_2 = {}
  L3_2 = pairs
  L4_2 = A0_2.participants
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = math
      L9_2 = L9_2.tointeger
      L10_2 = tonumber
      L11_2 = L8_2.src
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
      L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
      if L9_2 then
        goto lbl_37
      end
    end
    L9_2 = nil
    ::lbl_37::
    if L9_2 then
      L10_2 = {}
      L11_2 = L8_2.muted
      L11_2 = true == L11_2
      L10_2.muted = L11_2
      L2_2[L9_2] = L10_2
    end
  end
  L3_2 = pairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L7_2 ~= L1_2 then
      L9_2 = L2_1.phoneTook
      if not L9_2 then
        L9_2 = L2_1.participants
        L9_2 = L9_2[L7_2]
        L10_2 = L8_2.muted
        if L9_2 then
          L11_2 = L9_2.muted
          if L11_2 then
            goto lbl_69
          end
        end
        L11_2 = false
        ::lbl_69::
        if L10_2 ~= L11_2 then
          L10_2 = L5_1
          L11_2 = "muteFrom"
          L12_2 = L7_2
          L13_2 = L8_2.muted
          L10_2(L11_2, L12_2, L13_2)
          L10_2 = L8_2.muted
          if not L10_2 then
            L10_2 = L2_1.localMuted
            L10_2 = L10_2[L7_2]
            if L10_2 then
              L10_2 = L11_1
              L11_2 = L7_2
              L10_2(L11_2)
            end
          end
        end
      end
    end
  end
  L3_2 = pairs
  L4_2 = L2_1.participants
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_2[L7_2]
    if not L9_2 then
      L9_2 = L8_2.muted
      if L9_2 then
        L9_2 = L5_1
        L10_2 = "muteFrom"
        L11_2 = L7_2
        L12_2 = false
        L9_2(L10_2, L11_2, L12_2)
      end
      L9_2 = L2_1.localMuted
      L9_2 = L9_2[L7_2]
      if L9_2 then
        L9_2 = L2_1.localMuted
        L9_2[L7_2] = nil
        L9_2 = L12_1
        L10_2 = L7_2
        L11_2 = true
        L9_2(L10_2, L11_2)
      end
    end
  end
  L2_1.participants = L2_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L2_1
  if not L1_2 then
    return
  end
  L2_2 = nil
  L2_1 = L2_2
  L2_2 = pairs
  L3_2 = L1_2.localMuted
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = MumbleSetVolumeOverrideByServerId
    L8_2 = L6_2
    L9_2 = -1.0
    L7_2(L8_2, L9_2)
  end
  L2_2 = L5_1
  L3_2 = "active"
  L2_2 = L2_2(L3_2)
  L3_2 = L1_2.voiceId
  if L2_2 == L3_2 then
    L2_2 = L5_1
    L3_2 = "leave"
    L2_2(L3_2)
  end
  L2_2 = PhoneCallProp
  if L2_2 then
    L2_2 = L1_2.phoneTook
    if not L2_2 then
      L2_2 = L8_1
      L2_2 = L2_2()
      if not L2_2 then
        L2_2 = PhoneCallProp
        L3_2 = false
        L2_2(L3_2)
      end
    end
  end
  L2_2 = L6_1
  L3_2 = "recadoCallTalking"
  L4_2 = {}
  L5_2 = L1_2.callId
  L4_2.callId = L5_2
  L5_2 = {}
  L4_2.talking = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = L4_1
  L3_2 = "left group call %s (%s)"
  L4_2 = L1_2.callId
  L5_2 = tostring
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2.callId
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.voiceId
  L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  if not L1_2 or not L2_2 then
    return
  end
  L3_2 = L2_1
  if L3_2 then
    L3_2 = L2_1.callId
    if L3_2 == L1_2 then
      L3_2 = L15_1
      L4_2 = A0_2.call
      L3_2(L4_2)
      return
    end
  end
  L3_2 = L2_1
  if L3_2 then
    L3_2 = L16_1
    L4_2 = "switch"
    L3_2(L4_2)
  end
  L3_2 = {}
  L3_2.callId = L1_2
  L3_2.voiceId = L2_2
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A0_2.channel
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.channel = L4_2
  L4_2 = {}
  L3_2.participants = L4_2
  L4_2 = {}
  L3_2.localMuted = L4_2
  L3_2.lastTalk = ""
  L2_1 = L3_2
  L3_2 = L5_1
  L4_2 = "join"
  L5_2 = L2_2
  L6_2 = {}
  L7_2 = L2_1.channel
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if false == L3_2 then
    L4_2 = L4_1
    L5_2 = "voice busy when joining group call %s"
    L6_2 = L1_2
    L4_2(L5_2, L6_2)
    L4_2 = L6_1
    L5_2 = "recadoCallVoice"
    L6_2 = {}
    L6_2.callId = L1_2
    L6_2.ok = false
    L4_2(L5_2, L6_2)
  end
  L4_2 = PhoneCallProp
  if L4_2 then
    L4_2 = PhoneCallProp
    L5_2 = true
    L4_2(L5_2)
  end
  L4_2 = L15_1
  L5_2 = A0_2.call
  L4_2(L5_2)
  L4_2 = L14_1
  L4_2()
end
L18_1 = RegisterNetEvent
L19_1 = "apex_phone:client:push"
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return
  end
  if "recadoCall" == A0_2 then
    L2_2 = A1_2.event
    if "joined" == L2_2 then
      L3_2 = L17_1
      L4_2 = A1_2
      L3_2(L4_2)
    elseif "state" == L2_2 then
      L3_2 = L2_1
      if L3_2 then
        L3_2 = math
        L3_2 = L3_2.tointeger
        L4_2 = tonumber
        L5_2 = A1_2.callId
        L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2)
        L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
        L4_2 = L2_1.callId
        if L3_2 == L4_2 then
          L3_2 = L15_1
          L4_2 = A1_2.call
          L3_2(L4_2)
        end
      end
    elseif "left" == L2_2 or "ended" == L2_2 then
      L3_2 = L2_1
      if L3_2 then
        L3_2 = math
        L3_2 = L3_2.tointeger
        L4_2 = tonumber
        L5_2 = A1_2.callId
        L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2)
        L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
        L4_2 = L2_1.callId
        if L3_2 == L4_2 then
          L3_2 = L16_1
          L4_2 = A1_2.reason
          if not L4_2 then
            L4_2 = L2_2
          end
          L3_2(L4_2)
        end
      end
    elseif "ring" == L2_2 then
      L3_2 = Config
      L3_2 = L3_2.AutoOpenOnCall
      if L3_2 then
        L3_2 = PhoneOpen
        if not L3_2 then
          L3_2 = OpenPhone
          if L3_2 then
            L3_2 = Citizen
            L3_2 = L3_2.CreateThreadNow
            if not L3_2 then
              L3_2 = CreateThread
            end
            L4_2 = L3_2
            function L5_2()
              local L0_3, L1_3, L2_3
              L0_3 = OpenPhone
              L1_3 = nil
              L2_3 = {}
              L2_3.silent = true
              L0_3(L1_3, L2_3)
            end
            L4_2(L5_2)
          end
        end
      end
    end
  elseif "callState" == A0_2 then
    L2_2 = A1_2.state
    if "active" == L2_2 then
      L2_2 = L2_1
      if L2_2 then
        L2_2 = math
        L2_2 = L2_2.tointeger
        L3_2 = tonumber
        L4_2 = A1_2.callId
        L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2)
        L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
        if L2_2 then
          L3_2 = L5_1
          L4_2 = "active"
          L3_2 = L3_2(L4_2)
          L4_2 = L2_1.voiceId
          if L3_2 == L4_2 then
            L3_2 = pairs
            L4_2 = L2_1.localMuted
            L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
            for L7_2 in L3_2, L4_2, L5_2, L6_2 do
              L8_2 = MumbleSetVolumeOverrideByServerId
              L9_2 = L7_2
              L10_2 = -1.0
              L8_2(L9_2, L10_2)
            end
            L3_2 = {}
            L2_1.localMuted = L3_2
            L2_1.phoneTook = true
            L3_2 = L5_1
            L4_2 = "leave"
            L3_2(L4_2)
            L3_2 = L5_1
            L4_2 = "join"
            L5_2 = L2_2
            L6_2 = {}
            L7_2 = math
            L7_2 = L7_2.tointeger
            L8_2 = tonumber
            L9_2 = A1_2.peer
            L8_2, L9_2, L10_2 = L8_2(L9_2)
            L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2)
            L6_2[1] = L7_2
            L6_2[2] = L8_2
            L6_2[3] = L9_2
            L6_2[4] = L10_2
            L7_2 = math
            L7_2 = L7_2.tointeger
            L8_2 = tonumber
            L9_2 = A1_2.channel
            L8_2, L9_2, L10_2 = L8_2(L9_2)
            L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2)
            L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
          end
        end
      end
    end
  end
end
L18_1(L19_1, L20_1)
L18_1 = RegisterNUICallback
L19_1 = "recadoCallLocalMute"
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.src
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = L2_1
  if L3_2 then
    L3_2 = math
    L3_2 = L3_2.tointeger
    L4_2 = tonumber
    L5_2 = A0_2.callId
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L4_2 = L2_1.callId
    if L3_2 == L4_2 and L2_2 then
      L3_2 = L7_1
      L3_2 = L3_2()
      if L2_2 ~= L3_2 then
        L3_2 = L2_1.participants
        L3_2 = L3_2[L2_2]
        if L3_2 then
          goto lbl_45
        end
      end
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L4_2.ok = false
  L3_2(L4_2)
  do return end
  ::lbl_45::
  L3_2 = A0_2.on
  if true == L3_2 then
    L3_2 = L2_1.localMuted
    L3_2[L2_2] = true
    L3_2 = L11_1
    L4_2 = L2_2
    L3_2(L4_2)
  else
    L3_2 = L2_1.localMuted
    L3_2 = L3_2[L2_2]
    if L3_2 then
      L3_2 = L2_1.localMuted
      L3_2[L2_2] = nil
      L3_2 = L12_1
      L4_2 = L2_2
      L5_2 = false
      L3_2(L4_2, L5_2)
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L4_2.ok = true
  L5_2 = L9_1
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L4_2.near = L5_2
  L3_2(L4_2)
end
L18_1(L19_1, L20_1)
L18_1 = AddEventHandler
L19_1 = "onResourceStop"
function L20_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = L16_1
  L2_2 = "stopped"
  L1_2(L2_2)
end
L18_1(L19_1, L20_1)
