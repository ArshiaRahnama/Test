local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1
function L0_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.WorldSounds
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.WorldSounds
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L1_1()
  local L0_2, L1_2
  L0_2 = L0_1
  L0_2 = L0_2()
  L0_2 = L0_2.enabled
  L0_2 = false ~= L0_2
  return L0_2
end
function L2_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = Dbg
  if L1_2 then
    L1_2 = Dbg
    L2_2 = "sounds"
    L3_2 = A0_2
    L4_2 = ...
    L1_2(L2_2, L3_2, L4_2)
  end
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = GetPlayerPed
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    if not L0_3 or 0 == L0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = GetEntityCoords
    L2_3 = L0_3
    return L1_3(L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if not L1_2 or not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = L2_2.x
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = L2_2.y
  L4_2 = L4_2(L5_2)
  L5_2 = tonumber
  L6_2 = L2_2.z
  L5_2 = L5_2(L6_2)
  if not (L3_2 and L4_2 and L5_2) or 0 == L3_2 and 0 == L4_2 and 0 == L5_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = {}
  L6_2.x = L3_2
  L6_2.y = L4_2
  L6_2.z = L5_2
  return L6_2
end
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = A0_2.x
  L3_2 = A1_2.x
  L2_2 = L2_2 - L3_2
  L3_2 = A0_2.y
  L4_2 = A1_2.y
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.z
  L5_2 = A1_2.z
  L4_2 = L4_2 - L5_2
  L5_2 = math
  L5_2 = L5_2.sqrt
  L6_2 = L2_2 * L2_2
  L7_2 = L3_2 * L3_2
  L6_2 = L6_2 + L7_2
  L7_2 = L4_2 * L4_2
  L6_2 = L6_2 + L7_2
  return L5_2(L6_2)
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = pcall
  L2_2 = GetPlayerRoutingBucket
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = tonumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_13
    end
  end
  L3_2 = 0
  ::lbl_13::
  return L3_2
end
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L3_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L4_2 = nil
    return L3_2, L4_2
  end
  L3_2 = L5_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = GetPlayers
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L6_2()
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = tonumber
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 and L11_2 ~= A0_2 then
      L12_2 = L5_1
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if L12_2 == L3_2 then
        L12_2 = L3_1
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        if L12_2 then
          L13_2 = L4_1
          L14_2 = L12_2
          L15_2 = L2_2
          L13_2 = L13_2(L14_2, L15_2)
          if A1_2 >= L13_2 then
            L13_2 = #L4_2
            L13_2 = L13_2 + 1
            L4_2[L13_2] = L11_2
          end
        end
      end
    end
  end
  L5_2 = L4_2
  L6_2 = L2_2
  return L5_2, L6_2
end
L7_1 = {}
L8_1 = RegisterNetEvent
L9_1 = "apex_phone:server:worldSound"
function L10_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L5_2 = source
  L6_2 = L1_1
  L6_2 = L6_2()
  if not L6_2 then
    return
  end
  L6_2 = RateLimitAllow
  L7_2 = L5_2
  L8_2 = "event.worldSound"
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    return
  end
  if "ring" == A0_2 then
    L6_2 = "ring"
    if L6_2 then
      goto lbl_20
      A0_2 = L6_2 or A0_2
    end
  end
  A0_2 = "notify"
  ::lbl_20::
  if "ring" == A0_2 then
    L6_2 = L0_1
    L6_2 = L6_2()
    L6_2 = L6_2.ring
    if false == L6_2 then
      return
    end
  end
  if "notify" == A0_2 then
    L6_2 = L0_1
    L6_2 = L6_2()
    L6_2 = L6_2.notify
    if false == L6_2 then
      return
    end
  end
  L6_2 = type
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L7_2 = A1_2
    L6_2 = A1_2.sub
    L8_2 = 1
    L9_2 = 32
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_48
      A1_2 = L6_2 or A1_2
    end
  end
  A1_2 = ""
  ::lbl_48::
  A2_2 = false ~= A2_2
  L6_2 = tonumber
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  A3_2 = L6_2 or A3_2
  if not L6_2 then
    A3_2 = 1.0
  end
  if A3_2 < 0 then
    A3_2 = 0.0
  elseif A3_2 > 1 then
    A3_2 = 1.0
  end
  if "android" == A4_2 then
    L6_2 = "android"
    if L6_2 then
      goto lbl_71
      A4_2 = L6_2 or A4_2
    end
  end
  A4_2 = "ios"
  ::lbl_71::
  if "ring" == A0_2 then
    L6_2 = L7_1
    L7_2 = A2_2 or L7_2
    if not A2_2 then
      L7_2 = nil
    end
    L6_2[L5_2] = L7_2
  end
  L6_2 = tonumber
  L7_2 = L0_1
  L7_2 = L7_2()
  L7_2 = L7_2.range
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 12.0
  end
  L6_2 = L6_2 + 8.0
  L7_2 = L6_1
  L8_2 = L5_2
  L9_2 = L6_2
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  if not L8_2 then
    return
  end
  L9_2 = ipairs
  L10_2 = L7_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = TriggerClientEvent
    L16_2 = "apex_phone:client:worldSound"
    L17_2 = L14_2
    L18_2 = L5_2
    L19_2 = A0_2
    L20_2 = A1_2
    L21_2 = A2_2
    L22_2 = A3_2
    L23_2 = L8_2
    L24_2 = A4_2
    L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  end
  L9_2 = L2_1
  L10_2 = "%s %s %s from %s \226\134\146 %d player(s)"
  L11_2 = A0_2
  L12_2 = A1_2
  if A2_2 then
    L13_2 = "on"
    if L13_2 then
      goto lbl_123
    end
  end
  L13_2 = "off"
  ::lbl_123::
  L14_2 = L5_2
  L15_2 = #L7_2
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
end
L8_1(L9_1, L10_1)
L8_1 = {}
L9_1 = false
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = GetPlayerName
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = Push
    L3_2 = A0_2
    L4_2 = "speakerLeave"
    L5_2 = {}
    L5_2.callId = A1_2
    L2_2(L3_2, L4_2, L5_2)
  end
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L8_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L2_2 = L8_1
  L2_2[A0_2] = nil
  L2_2 = pairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = L10_1
    L8_2 = L6_2
    L9_2 = A0_2
    L7_2(L8_2, L9_2)
  end
end
function L12_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    return
  end
  L1_2 = L11_1
  L2_2 = A0_2.id
  L1_2(L2_2)
end
SpeakerCallEnded = L12_1
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = pairs
  L2_2 = L8_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2[A0_2]
    if L7_2 then
      return L5_2
    end
  end
  L1_2 = nil
  return L1_2
end
function L13_1()
  local L0_2, L1_2
  L0_2 = L9_1
  if L0_2 then
    return
  end
  L0_2 = true
  L9_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3
    while true do
      L0_3 = Wait
      L1_3 = 1000
      L0_3(L1_3)
      L0_3 = L1_1
      L0_3 = L0_3()
      if not L0_3 then
        break
      end
      L0_3 = L0_1
      L0_3 = L0_3()
      L0_3 = L0_3.speaker
      if false == L0_3 then
        break
      end
      L0_3 = CallsWithSpeaker
      if L0_3 then
        L0_3 = CallsWithSpeaker
        L0_3 = L0_3()
        if L0_3 then
          goto lbl_22
        end
      end
      L0_3 = {}
      ::lbl_22::
      L1_3 = #L0_3
      if 0 == L1_3 then
        break
      end
      L1_3 = tonumber
      L2_3 = L0_1
      L2_3 = L2_3()
      L2_3 = L2_3.speakerRange
      L1_3 = L1_3(L2_3)
      if not L1_3 then
        L1_3 = 3.5
      end
      L2_3 = {}
      L3_3 = ipairs
      L4_3 = L0_3
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
      for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
        L9_3 = L8_3.id
        L2_3[L9_3] = true
        L9_3 = L8_3.channel
        L10_3 = {}
        if L9_3 then
          L11_3 = pairs
          L12_3 = L8_3.speaker
          if not L12_3 then
            L12_3 = {}
          end
          L11_3, L12_3, L13_3, L14_3 = L11_3(L12_3)
          for L15_3 in L11_3, L12_3, L13_3, L14_3 do
            L16_3 = GetPlayerName
            L17_3 = L15_3
            L16_3 = L16_3(L17_3)
            if L16_3 then
              L16_3 = ipairs
              L17_3 = L6_1
              L18_3 = L15_3
              L19_3 = L1_3
              L17_3 = L17_3(L18_3, L19_3)
              L16_3, L17_3, L18_3, L19_3 = L16_3(L17_3)
              for L20_3, L21_3 in L16_3, L17_3, L18_3, L19_3 do
                L22_3 = L8_3.caller
                if L21_3 ~= L22_3 then
                  L22_3 = L8_3.callee
                  if L21_3 ~= L22_3 then
                    L22_3 = PlayerInCall
                    if L22_3 then
                      L22_3 = PlayerInCall
                      L23_3 = L21_3
                      L22_3 = L22_3(L23_3)
                      if L22_3 then
                        goto lbl_89
                      end
                    end
                    L22_3 = L12_1
                    L23_3 = L21_3
                    L22_3 = L22_3(L23_3)
                    if L22_3 then
                      L23_3 = L8_3.id
                      if L22_3 ~= L23_3 then
                        goto lbl_89
                      end
                    end
                    L10_3[L21_3] = true
                  end
                end
                ::lbl_89::
              end
            end
          end
        end
        L12_3 = L8_3.id
        L11_3 = L8_1
        L11_3 = L11_3[L12_3]
        if not L11_3 then
          L11_3 = {}
        end
        L12_3 = pairs
        L13_3 = L10_3
        L12_3, L13_3, L14_3, L15_3 = L12_3(L13_3)
        for L16_3 in L12_3, L13_3, L14_3, L15_3 do
          L17_3 = L11_3[L16_3]
          if not L17_3 then
            L11_3[L16_3] = true
            L17_3 = Push
            L18_3 = L16_3
            L19_3 = "speakerJoin"
            L20_3 = {}
            L21_3 = L8_3.id
            L20_3.callId = L21_3
            L20_3.channel = L9_3
            L17_3(L18_3, L19_3, L20_3)
            L17_3 = L2_1
            L18_3 = "speaker: %s joins call %s (channel %s)"
            L19_3 = L16_3
            L20_3 = L8_3.id
            L21_3 = tostring
            L22_3 = L9_3
            L21_3, L22_3, L23_3 = L21_3(L22_3)
            L17_3(L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
          end
        end
        L12_3 = pairs
        L13_3 = L11_3
        L12_3, L13_3, L14_3, L15_3 = L12_3(L13_3)
        for L16_3 in L12_3, L13_3, L14_3, L15_3 do
          L17_3 = L10_3[L16_3]
          if not L17_3 then
            L11_3[L16_3] = nil
            L17_3 = L10_1
            L18_3 = L16_3
            L19_3 = L8_3.id
            L17_3(L18_3, L19_3)
            L17_3 = L2_1
            L18_3 = "speaker: %s leaves call %s"
            L19_3 = L16_3
            L20_3 = L8_3.id
            L17_3(L18_3, L19_3, L20_3)
          end
        end
        L13_3 = L8_3.id
        L12_3 = L8_1
        L14_3 = next
        L15_3 = L11_3
        L14_3 = L14_3(L15_3)
        L14_3 = L11_3 or L14_3
        if nil == L14_3 or not L11_3 then
          L14_3 = nil
        end
        L12_3[L13_3] = L14_3
      end
      L3_3 = pairs
      L4_3 = L8_1
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
      for L7_3 in L3_3, L4_3, L5_3, L6_3 do
        L8_3 = L2_3[L7_3]
        if not L8_3 then
          L8_3 = L11_1
          L9_3 = L7_3
          L8_3(L9_3)
        end
      end
    end
    L0_3 = pairs
    L1_3 = L8_1
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
    for L4_3 in L0_3, L1_3, L2_3, L3_3 do
      L5_3 = L11_1
      L6_3 = L4_3
      L5_3(L6_3)
    end
    L0_3 = false
    L9_1 = L0_3
  end
  L0_2(L1_2)
end
L14_1 = RegisterNetEvent
L15_1 = "apex_phone:server:speaker"
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = source
  L3_2 = RateLimitAllow
  L4_2 = L2_2
  L5_2 = "event.speaker"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    return
  end
  L3_2 = CallSpeaker
  if not L3_2 then
    return
  end
  L3_2 = CallSpeaker
  L4_2 = L2_2
  L5_2 = A0_2
  L6_2 = true == A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    return
  end
  L4_2 = L1_1
  L4_2 = L4_2()
  if L4_2 then
    L4_2 = L0_1
    L4_2 = L4_2()
    L4_2 = L4_2.speaker
    if false ~= L4_2 then
      goto lbl_34
    end
  end
  do return end
  ::lbl_34::
  if true == A1_2 then
    L4_2 = L13_1
    L4_2()
  else
    L4_2 = next
    L5_2 = L3_2.speaker
    if not L5_2 then
      L5_2 = {}
    end
    L4_2 = L4_2(L5_2)
    if nil == L4_2 then
      L4_2 = L11_1
      L5_2 = L3_2.id
      L4_2(L5_2)
    end
  end
end
L14_1(L15_1, L16_1)
L14_1 = AddEventHandler
L15_1 = "playerDropped"
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    return
  end
  L1_2 = L7_1
  L1_2 = L1_2[L0_2]
  if L1_2 then
    L1_2 = L7_1
    L1_2[L0_2] = nil
    L1_2 = ipairs
    L2_2 = L6_1
    L3_2 = L0_2
    L4_2 = tonumber
    L5_2 = L0_1
    L5_2 = L5_2()
    L5_2 = L5_2.range
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = 12.0
    end
    L4_2 = L4_2 + 8.0
    L2_2 = L2_2(L3_2, L4_2)
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = TriggerClientEvent
      L8_2 = "apex_phone:client:worldSoundStop"
      L9_2 = L6_2
      L10_2 = L0_2
      L7_2(L8_2, L9_2, L10_2)
    end
  end
  L1_2 = pairs
  L2_2 = L8_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2[L0_2]
    if L7_2 then
      L6_2[L0_2] = nil
      L7_2 = next
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      if nil == L7_2 then
        L7_2 = L8_1
        L7_2[L5_2] = nil
      end
    end
  end
end
L14_1(L15_1, L16_1)
L14_1 = RegisterCommand
L15_1 = "phonesounds"
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  if 0 ~= A0_2 then
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3
      L0_3 = FW
      L0_3 = L0_3.IsAdmin
      L1_3 = A0_2
      return L0_3(L1_3)
    end
    L1_2, L2_2 = L1_2(L2_2)
    if not L1_2 or not L2_2 then
      return
    end
  end
  L1_2 = L0_1
  L1_2 = L1_2()
  L2_2 = print
  L3_2 = "^2[unique_phone]^0 world sounds: %s | range %s m | volume %s | ring %s | notify %s | speakerphone %s (%s m)"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L1_1
  L5_2 = L5_2()
  if L5_2 then
    L5_2 = "ON"
    if L5_2 then
      goto lbl_24
    end
  end
  L5_2 = "OFF"
  ::lbl_24::
  L6_2 = tostring
  L7_2 = L1_2.range
  if not L7_2 then
    L7_2 = 12
  end
  L6_2 = L6_2(L7_2)
  L7_2 = tostring
  L8_2 = L1_2.volume
  if not L8_2 then
    L8_2 = 0.7
  end
  L7_2 = L7_2(L8_2)
  L8_2 = tostring
  L9_2 = L1_2.ring
  L9_2 = false ~= L9_2
  L8_2 = L8_2(L9_2)
  L9_2 = tostring
  L10_2 = L1_2.notify
  L10_2 = false ~= L10_2
  L9_2 = L9_2(L10_2)
  L10_2 = tostring
  L11_2 = L1_2.speaker
  L11_2 = false ~= L11_2
  L10_2 = L10_2(L11_2)
  L11_2 = tostring
  L12_2 = L1_2.speakerRange
  if not L12_2 then
    L12_2 = 3.5
  end
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L11_2(L12_2)
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L2_2 = 0
  L3_2 = pairs
  L4_2 = L8_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = pairs
    L10_2 = L8_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2 in L9_2, L10_2, L11_2, L12_2 do
      L2_2 = L2_2 + 1
      L14_2 = print
      L15_2 = "  player %s is listening to call %s"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L13_2
      L18_2 = L7_2
      L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2, L17_2, L18_2)
      L14_2(L15_2, L16_2, L17_2, L18_2)
    end
  end
  if 0 == L2_2 then
    L3_2 = print
    L4_2 = "  nobody is listening to a speakerphone right now"
    L3_2(L4_2)
  end
  L3_2 = 0
  L4_2 = pairs
  L5_2 = L7_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    L3_2 = L3_2 + 1
  end
  L4_2 = print
  L5_2 = "  phones ringing right now: %d"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = L3_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L5_2(L6_2, L7_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
end
L17_1 = false
L14_1(L15_1, L16_1, L17_1)
