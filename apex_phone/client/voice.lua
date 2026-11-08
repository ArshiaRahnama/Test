local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1
L0_1 = Voice
if not L0_1 then
  L0_1 = {}
end
Voice = L0_1
L0_1 = 50000
L1_1 = 4.0
L2_1 = 250
L3_1 = 3000
L4_1 = {}
L5_1 = "pma-voice"
L6_1 = "saltychat"
L7_1 = "mumble-voip"
L4_1[1] = L5_1
L4_1[2] = L6_1
L4_1[3] = L7_1
L5_1 = {}
L5_1["pma-voice"] = true
L5_1.saltychat = true
L5_1["mumble-voip"] = true
L5_1.none = true
L6_1 = nil
L7_1 = {}
L8_1 = false
function L9_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = Dbg
  if L1_2 then
    L1_2 = Dbg
    L2_2 = "voice"
    L3_2 = A0_2
    L4_2 = ...
    L1_2(L2_2, L3_2, L4_2)
  end
end
L10_1 = {}
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L10_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    return
  end
  L2_2 = L10_1
  L2_2[A0_2] = true
  L2_2 = print
  L3_2 = "^3[unique_phone] voice: "
  L4_2 = A1_2
  L5_2 = "^7"
  L3_2 = L3_2 .. L4_2 .. L5_2
  L2_2(L3_2)
end
function L12_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetResourceState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "started" == L1_2
  return L1_2
end
L13_1 = Voice
function L14_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = Config
  L0_2 = L0_2.UseVoice
  if false == L0_2 then
    L0_2 = "none"
    return L0_2
  end
  L0_2 = Config
  L0_2 = L0_2.Voice
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == L0_2 then
    L0_2 = "auto"
  end
  if "none" == L0_2 then
    L1_2 = "none"
    return L1_2
  end
  if "auto" ~= L0_2 then
    L1_2 = L5_1
    L1_2 = L1_2[L0_2]
    if not L1_2 then
      L1_2 = L11_1
      L2_2 = "bad:"
      L3_2 = L0_2
      L2_2 = L2_2 .. L3_2
      L3_2 = "Config.Voice = '%s' is not known; auto-detecting"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = L0_2
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2)
      L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
    else
      L1_2 = L12_1
      L2_2 = L0_2
      L1_2 = L1_2(L2_2)
      if L1_2 then
        return L0_2
      else
        L1_2 = L11_1
        L2_2 = "off:"
        L3_2 = L0_2
        L2_2 = L2_2 .. L3_2
        L3_2 = "Config.Voice = '%s' but that resource is not running: calls without audio"
        L4_2 = L3_2
        L3_2 = L3_2.format
        L5_2 = L0_2
        L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2)
        L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
        L1_2 = "none"
        return L1_2
      end
    end
  end
  L1_2 = ipairs
  L2_2 = L4_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L12_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      return L6_2
    end
  end
  L1_2 = "none"
  return L1_2
end
L13_1.provider = L14_1
L13_1 = Voice
function L14_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L0_1
    L2_2 = L2_2 + L1_2
    if L2_2 then
      goto lbl_15
    end
  end
  L2_2 = nil
  ::lbl_15::
  return L2_2
end
L13_1.channel = L14_1
L13_1 = Voice
function L14_1()
  local L0_2, L1_2
  L0_2 = L6_1
  if L0_2 then
    L0_2 = L6_1.callId
    if L0_2 then
      goto lbl_8
    end
  end
  L0_2 = nil
  ::lbl_8::
  return L0_2
end
L13_1.active = L14_1
function L13_1(A0_2)
  local L1_2
  L1_2 = "pma-voice" == A0_2 or "mumble-voip" == A0_2
  return L1_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = exports
    L0_3 = L0_3["pma-voice"]
    L1_3 = A0_2
    L1_3 = L0_3[L1_3]
    L2_3 = L0_3
    return L1_3(L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = tonumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_12
    end
  end
  L3_2 = nil
  ::lbl_12::
  return L3_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L6_1
  if L1_2 then
    L1_2 = L6_1.provider
    if "pma-voice" == L1_2 then
      goto lbl_9
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_9::
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = exports
    L0_3 = L0_3["pma-voice"]
    L1_3 = L0_3
    L0_3 = L0_3.isPlayerMuted
    L2_3 = A0_2
    return L0_3(L1_3, L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  L3_2 = L1_2 or L3_2
  L3_2 = L1_2 and true == L2_2
  return L3_2
end
function L16_1()
  local L0_2, L1_2
  L0_2 = L6_1
  if L0_2 then
    L0_2 = L6_1.provider
    L0_2 = L14_1
    L1_2 = "getCallVolume"
    L0_2 = "pma-voice" == L0_2 and L0_2
  end
  if L0_2 then
    L1_2 = L0_2 / 100
    if L1_2 then
      goto lbl_20
    end
  end
  L1_2 = -1.0
  ::lbl_20::
  return L1_2
end
function L17_1()
  local L0_2, L1_2
  L0_2 = L14_1
  L1_2 = "getRadioVolume"
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L0_2 / 100
    if L1_2 then
      goto lbl_11
    end
  end
  L1_2 = -1.0
  ::lbl_11::
  return L1_2
end
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L0_3 = L0_3.proximity
    L1_3 = type
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = tonumber
      L2_3 = L0_3.distance
      L1_3 = L1_3(L2_3)
      if L1_3 then
        goto lbl_17
      end
    end
    L1_3 = nil
    ::lbl_17::
    return L1_3
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 and L2_2 and L2_2 > 0 then
    L3_2 = GetConvar
    L4_2 = "voice_useNativeAudio"
    L5_2 = "false"
    L3_2 = L3_2(L4_2, L5_2)
    if "true" == L3_2 then
      L3_2 = 3.0
      if L3_2 then
        goto lbl_20
      end
    end
    L3_2 = 1.0
    ::lbl_20::
    L4_2 = math
    L4_2 = L4_2.min
    L5_2 = L1_1
    L6_2 = L2_2 * L3_2
    return L4_2(L5_2, L6_2)
  end
  L3_2 = L1_1
  return L3_2
end
function L19_1(A0_2)
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
  L4_2 = L18_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L3_2 = L3_2 <= L4_2
  return L3_2
end
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L6_1
  if L2_2 then
    L2_2 = L6_1.provider
    if "pma-voice" == L2_2 then
      goto lbl_9
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_9::
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = tonumber
    L1_3 = LocalPlayer
    L1_3 = L1_3.state
    L1_3 = L1_3.radioChannel
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L0_3 = 0
    end
    if L0_3 <= 0 then
      L1_3 = false
      return L1_3
    end
    L1_3 = Player
    L2_3 = A0_2
    L1_3 = L1_3(L2_3)
    L1_3 = L1_3.state
    L2_3 = A1_2
    if nil == L2_3 then
      L2_3 = L1_3.radioActive
    end
    L3_3 = true == L2_3
    return L3_3
  end
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L2_2 and true == L3_2
  return L4_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L15_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = 0.0
    return L2_2
  end
  L2_2 = L19_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = -1.0
    return L2_2
  end
  L2_2 = L20_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = L17_1
    return L2_2()
  end
  L2_2 = 0.0
  return L2_2
end
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MumbleSetVolumeOverrideByServerId
  L3_2 = A0_2
  L4_2 = L21_1
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L15_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = MumbleSetVolumeOverrideByServerId
    L3_2 = A0_2
    L4_2 = 0.0
    L2_2(L3_2, L4_2)
    return
  end
  if not A1_2 then
    L2_2 = L20_1
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = MumbleSetVolumeOverrideByServerId
      L3_2 = A0_2
      L4_2 = L17_1
      L4_2, L5_2 = L4_2()
      L2_2(L3_2, L4_2, L5_2)
      return
    end
  end
  L2_2 = MumbleSetVolumeOverrideByServerId
  L3_2 = A0_2
  if not A1_2 then
    L4_2 = L19_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      goto lbl_36
    end
  end
  L4_2 = -1.0
  ::lbl_36::
  if not L4_2 then
    L4_2 = L16_1
    L4_2 = L4_2()
  end
  L2_2(L3_2, L4_2)
end
function L24_1()
  local L0_2, L1_2
  L0_2 = L8_1
  if L0_2 then
    return
  end
  L0_2 = true
  L8_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    while true do
      L0_3 = L6_1
      if not L0_3 then
        break
      end
      L0_3 = next
      L1_3 = L7_1
      L0_3 = L0_3(L1_3)
      if nil == L0_3 then
        break
      end
      L0_3 = pairs
      L1_3 = L7_1
      L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
      for L4_3 in L0_3, L1_3, L2_3, L3_3 do
        L5_3 = L22_1
        L6_3 = L4_3
        L5_3(L6_3)
      end
      L0_3 = Wait
      L1_3 = L2_1
      L0_3(L1_3)
    end
    L0_3 = false
    L8_1 = L0_3
  end
  L0_2(L1_2)
end
L25_1 = AddStateBagChangeHandler
L26_1 = "radioActive"
L27_1 = nil
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L6_1
  if L3_2 then
    L3_2 = next
    L4_2 = L7_1
    L3_2 = L3_2(L4_2)
    if nil ~= L3_2 then
      L3_2 = L13_1
      L4_2 = L6_1.provider
      L3_2 = L3_2(L4_2)
      if L3_2 then
        goto lbl_15
      end
    end
  end
  do return end
  ::lbl_15::
  L3_2 = tonumber
  L4_2 = tostring
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.match
  L6_2 = "^player:(%d+)$"
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 then
    L4_2 = L7_1
    L4_2 = L4_2[L3_2]
    if L4_2 then
      goto lbl_30
    end
  end
  do return end
  ::lbl_30::
  L4_2 = L22_1
  L5_2 = L3_2
  L6_2 = true == A2_2
  L4_2(L5_2, L6_2)
end
L25_1(L26_1, L27_1, L28_1)
L25_1 = 0
function L26_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L25_1
  L1_2 = L1_2 + 1
  L25_1 = L1_2
  L1_2 = L25_1
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = 1
    L1_3 = 3
    L2_3 = 1
    for L3_3 = L0_3, L1_3, L2_3 do
      L4_3 = Wait
      if 1 == L3_3 then
        L5_3 = 2500
        if L5_3 then
          goto lbl_12
        end
      end
      L5_3 = 3000
      ::lbl_12::
      L4_3(L5_3)
      L4_3 = L6_1
      L5_3 = A0_2
      if L4_3 == L5_3 then
        L4_3 = L25_1
        L5_3 = L1_2
        if L4_3 == L5_3 then
          goto lbl_22
        end
      end
      do return end
      ::lbl_22::
      L4_3 = tonumber
      L5_3 = LocalPlayer
      L5_3 = L5_3.state
      L5_3 = L5_3.callChannel
      L4_3 = L4_3(L5_3)
      if not L4_3 then
        L4_3 = 0
      end
      L5_3 = A0_2.channel
      if L4_3 == L5_3 then
        return
      end
      if 3 == L3_3 then
        L5_3 = print
        L6_3 = "^3[unique_phone] voice: call %s: pma-voice never confirmed channel %s (callChannel = %s). Check `voice_enableCalls` (must be 1) and that pma-voice is up to date; type /phonevoice for details.^7"
        L7_3 = L6_3
        L6_3 = L6_3.format
        L8_3 = tostring
        L9_3 = A0_2.callId
        L8_3 = L8_3(L9_3)
        L9_3 = tostring
        L10_3 = A0_2.channel
        L9_3 = L9_3(L10_3)
        L10_3 = tostring
        L11_3 = L4_3
        L10_3, L11_3 = L10_3(L11_3)
        L6_3, L7_3, L8_3, L9_3, L10_3, L11_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3)
        L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
        return
      end
      L5_3 = L9_1
      L6_3 = "call %s: callChannel is %s, expected %s: addPlayerToCall again (%d)"
      L7_3 = A0_2.callId
      L8_3 = L4_3
      L9_3 = A0_2.channel
      L10_3 = L3_3
      L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
      L5_3 = pcall
      function L6_3()
        local L0_4, L1_4, L2_4
        L0_4 = exports
        L0_4 = L0_4["pma-voice"]
        L1_4 = L0_4
        L0_4 = L0_4.addPlayerToCall
        L2_4 = A0_2.channel
        L0_4(L1_4, L2_4)
      end
      L5_3, L6_3 = L5_3(L6_3)
      if not L5_3 then
        L7_3 = L9_1
        L8_3 = "pma-voice addPlayerToCall failed: %s"
        L9_3 = tostring
        L10_3 = L6_3
        L9_3, L10_3, L11_3 = L9_3(L10_3)
        L7_3(L8_3, L9_3, L10_3, L11_3)
      end
    end
  end
  L2_2(L3_2)
end
verifyJoin = L26_1
L26_1 = nil
L27_1 = Voice
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L1_2 or L1_2 <= 0 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L6_1
  if L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L26_1
  if L2_2 == L1_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = L26_1
  if L2_2 then
    L2_2 = Voice
    L2_2 = L2_2.unlisten
    L2_2()
  end
  L2_2 = Voice
  L2_2 = L2_2.provider
  L2_2 = L2_2()
  if "pma-voice" == L2_2 then
    L3_2 = pcall
    function L4_2()
      local L0_3, L1_3, L2_3
      L0_3 = exports
      L0_3 = L0_3["pma-voice"]
      L1_3 = L0_3
      L0_3 = L0_3.addPlayerToCall
      L2_3 = L1_2
      L0_3(L1_3, L2_3)
    end
    L3_2, L4_2 = L3_2(L4_2)
    if not L3_2 then
      L5_2 = L9_1
      L6_2 = "speaker: pma-voice addPlayerToCall failed: %s"
      L7_2 = tostring
      L8_2 = L4_2
      L7_2, L8_2 = L7_2(L8_2)
      L5_2(L6_2, L7_2, L8_2)
      L5_2 = false
      return L5_2
    end
  elseif "mumble-voip" == L2_2 then
    L3_2 = pcall
    function L4_2()
      local L0_3, L1_3, L2_3
      L0_3 = exports
      L0_3 = L0_3["mumble-voip"]
      L1_3 = L0_3
      L0_3 = L0_3.SetCallChannel
      L2_3 = L1_2
      L0_3(L1_3, L2_3)
    end
    L3_2, L4_2 = L3_2(L4_2)
    if not L3_2 then
      L5_2 = L9_1
      L6_2 = "speaker: mumble-voip SetCallChannel failed: %s"
      L7_2 = tostring
      L8_2 = L4_2
      L7_2, L8_2 = L7_2(L8_2)
      L5_2(L6_2, L7_2, L8_2)
      L5_2 = false
      return L5_2
    end
  else
    L3_2 = false
    return L3_2
  end
  L26_1 = L1_2
  L3_2 = L9_1
  L4_2 = "speaker: listening to channel %s"
  L5_2 = L1_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L27_1.listen = L28_1
L27_1 = Voice
function L28_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = L26_1
  if not L0_2 then
    L0_2 = false
    return L0_2
  end
  L0_2 = L26_1
  L1_2 = nil
  L26_1 = L1_2
  L1_2 = Voice
  L1_2 = L1_2.provider
  L1_2 = L1_2()
  if "pma-voice" == L1_2 then
    L2_2 = tonumber
    L3_2 = LocalPlayer
    L3_2 = L3_2.state
    L3_2 = L3_2.callChannel
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0
    end
    if 0 == L2_2 or L2_2 == L0_2 then
      L3_2 = pcall
      function L4_2()
        local L0_3, L1_3
        L0_3 = exports
        L0_3 = L0_3["pma-voice"]
        L1_3 = L0_3
        L0_3 = L0_3.removePlayerFromCall
        L0_3(L1_3)
      end
      L3_2, L4_2 = L3_2(L4_2)
      if not L3_2 then
        L5_2 = L9_1
        L6_2 = "speaker: pma-voice removePlayerFromCall failed: %s"
        L7_2 = tostring
        L8_2 = L4_2
        L7_2, L8_2 = L7_2(L8_2)
        L5_2(L6_2, L7_2, L8_2)
      end
    end
  elseif "mumble-voip" == L1_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3, L2_3
      L0_3 = exports
      L0_3 = L0_3["mumble-voip"]
      L1_3 = L0_3
      L0_3 = L0_3.SetCallChannel
      L2_3 = 0
      L0_3(L1_3, L2_3)
    end
    L2_2(L3_2)
  end
  L2_2 = L9_1
  L3_2 = "speaker: left channel %s"
  L4_2 = L0_2
  L2_2(L3_2, L4_2)
  L2_2 = true
  return L2_2
end
L27_1.unlisten = L28_1
L27_1 = Voice
function L28_1()
  local L0_2, L1_2
  L0_2 = L26_1
  return L0_2
end
L27_1.listening = L28_1
L27_1 = Voice
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = L6_1
  if L4_2 then
    L4_2 = L6_1.callId
    L4_2 = L4_2 == L3_2
    return L4_2
  end
  L4_2 = L26_1
  if L4_2 then
    L4_2 = Voice
    L4_2 = L4_2.unlisten
    L4_2()
  end
  L4_2 = Voice
  L4_2 = L4_2.provider
  L4_2 = L4_2()
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = A2_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  if not L5_2 then
    L5_2 = L0_1
    L5_2 = L5_2 + L3_2
  end
  L6_2 = {}
  L6_2.callId = L3_2
  L6_2.channel = L5_2
  L6_2.provider = L4_2
  L7_2 = {}
  L6_2.peers = L7_2
  L6_2.prev = 0
  L7_2 = type
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = ipairs
    L8_2 = A1_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = math
      L13_2 = L13_2.tointeger
      L14_2 = tonumber
      L15_2 = L12_2
      L14_2, L15_2 = L14_2(L15_2)
      L13_2 = L13_2(L14_2, L15_2)
      if L13_2 then
        L14_2 = L6_2.peers
        L14_2[L13_2] = true
      end
    end
  end
  if "pma-voice" == L4_2 then
    L7_2 = tonumber
    L8_2 = LocalPlayer
    L8_2 = L8_2.state
    L8_2 = L8_2.callChannel
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      L7_2 = 0
    end
    L6_2.prev = L7_2
    L7_2 = GetGameTimer
    L7_2 = L7_2()
    L6_2.at = L7_2
    L7_2 = pcall
    function L8_2()
      local L0_3, L1_3, L2_3
      L0_3 = exports
      L0_3 = L0_3["pma-voice"]
      L1_3 = L0_3
      L0_3 = L0_3.addPlayerToCall
      L2_3 = L5_2
      L0_3(L1_3, L2_3)
    end
    L7_2, L8_2 = L7_2(L8_2)
    if not L7_2 then
      L9_2 = L9_1
      L10_2 = "pma-voice addPlayerToCall failed: %s"
      L11_2 = tostring
      L12_2 = L8_2
      L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    end
    L9_2 = verifyJoin
    L10_2 = L6_2
    L9_2(L10_2)
  elseif "mumble-voip" == L4_2 then
    L7_2 = pcall
    function L8_2()
      local L0_3, L1_3, L2_3
      L0_3 = exports
      L0_3 = L0_3["mumble-voip"]
      L1_3 = L0_3
      L0_3 = L0_3.SetCallChannel
      L2_3 = L5_2
      L0_3(L1_3, L2_3)
    end
    L7_2, L8_2 = L7_2(L8_2)
    if not L7_2 then
      L9_2 = L9_1
      L10_2 = "mumble-voip SetCallChannel failed: %s"
      L11_2 = tostring
      L12_2 = L8_2
      L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    end
  end
  L6_1 = L6_2
  L7_2 = L9_1
  L8_2 = "join %s via %s channel %s"
  L9_2 = L3_2
  L10_2 = L4_2
  L11_2 = L5_2
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = true
  return L7_2
end
L27_1.join = L28_1
L27_1 = Voice
function L28_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = pairs
    L1_3 = L7_1
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
    for L4_3 in L0_3, L1_3, L2_3, L3_3 do
      L5_3 = L6_1
      if L5_3 then
        L5_3 = L13_1
        L6_3 = L6_1.provider
        L5_3 = L5_3(L6_3)
        if L5_3 then
          L5_3 = L23_1
          L6_3 = L4_3
          L7_3 = true
          L5_3(L6_3, L7_3)
      end
      else
        L5_3 = MumbleSetVolumeOverrideByServerId
        L6_3 = L4_3
        L7_3 = -1.0
        L5_3(L6_3, L7_3)
      end
    end
  end
  L0_2, L1_2 = L0_2(L1_2)
  L2_2 = {}
  L7_1 = L2_2
  if not L0_2 then
    L2_2 = L9_1
    L3_2 = "restoring the muted volumes failed: %s"
    L4_2 = tostring
    L5_2 = L1_2
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  end
  L2_2 = L6_1
  L3_2 = nil
  L6_1 = L3_2
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L2_2.provider
  if "pma-voice" == L3_2 then
    L3_2 = tonumber
    L4_2 = LocalPlayer
    L4_2 = L4_2.state
    L4_2 = L4_2.callChannel
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = 0
    end
    L4_2 = L2_2.prev
    L4_2 = L3_2 == L4_2
    if 0 ~= L3_2 then
      L5_2 = L2_2.channel
      if L3_2 ~= L5_2 and not L4_2 then
        L5_2 = L9_1
        L6_2 = "channel %s is no longer the one of call %s (%s): leaving it as is"
        L7_2 = L3_2
        L8_2 = L2_2.callId
        L9_2 = L2_2.channel
        L5_2(L6_2, L7_2, L8_2, L9_2)
    end
    else
      L5_2 = pcall
      function L6_2()
        local L0_3, L1_3
        L0_3 = exports
        L0_3 = L0_3["pma-voice"]
        L1_3 = L0_3
        L0_3 = L0_3.removePlayerFromCall
        L0_3(L1_3)
      end
      L5_2, L6_2 = L5_2(L6_2)
      if not L5_2 then
        L7_2 = L9_1
        L8_2 = "pma-voice removePlayerFromCall failed: %s"
        L9_2 = tostring
        L10_2 = L6_2
        L9_2, L10_2 = L9_2(L10_2)
        L7_2(L8_2, L9_2, L10_2)
      end
    end
  else
    L3_2 = L2_2.provider
    if "mumble-voip" == L3_2 then
      L3_2 = pcall
      function L4_2()
        local L0_3, L1_3, L2_3
        L0_3 = exports
        L0_3 = L0_3["mumble-voip"]
        L1_3 = L0_3
        L0_3 = L0_3.SetCallChannel
        L2_3 = 0
        L0_3(L1_3, L2_3)
      end
      L3_2, L4_2 = L3_2(L4_2)
      if not L3_2 then
        L5_2 = L9_1
        L6_2 = "mumble-voip SetCallChannel(0) failed: %s"
        L7_2 = tostring
        L8_2 = L4_2
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
      end
    end
  end
  L3_2 = L9_1
  L4_2 = "leave %s (%s)"
  L5_2 = L2_2.callId
  L6_2 = L2_2.provider
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = true
  return L3_2
end
L27_1.leave = L28_1
L27_1 = RegisterCommand
L28_1 = "phonevoice"
function L29_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = Voice
  L0_2 = L0_2.provider
  L0_2 = L0_2()
  L1_2 = {}
  L2_2 = "Config.UseVoice = %s \194\183 Config.Voice = %s \194\183 provider in use = %s"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = tostring
  L5_2 = Config
  L5_2 = L5_2.UseVoice
  L4_2 = L4_2(L5_2)
  L5_2 = tostring
  L6_2 = Config
  L6_2 = L6_2.Voice
  L5_2 = L5_2(L6_2)
  L6_2 = L0_2
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = "resources: pma-voice=%s \194\183 saltychat=%s \194\183 mumble-voip=%s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = GetResourceState
  L6_2 = "pma-voice"
  L5_2 = L5_2(L6_2)
  L6_2 = GetResourceState
  L7_2 = "saltychat"
  L6_2 = L6_2(L7_2)
  L7_2 = GetResourceState
  L8_2 = "mumble-voip"
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = "phone open = %s \194\183 keep input (voice while open) = %s \194\183 AllowWalking = %s"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = tostring
  L7_2 = PhoneOpen
  L6_2 = L6_2(L7_2)
  L7_2 = tostring
  L8_2 = Config
  L8_2 = L8_2.KeepVoice
  L8_2 = false ~= L8_2
  L7_2 = L7_2(L8_2)
  L8_2 = tostring
  L9_2 = Config
  L9_2 = L9_2.AllowWalking
  L9_2 = true == L9_2
  L8_2, L9_2, L10_2 = L8_2(L9_2)
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L1_2[6] = L7_2
  L1_2[7] = L8_2
  L1_2[8] = L9_2
  L1_2[9] = L10_2
  L2_2 = L6_1
  if L2_2 then
    L2_2 = #L1_2
    L2_2 = L2_2 + 1
    L3_2 = "active call %s via %s on channel %s (peers: %s)"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L6_1.callId
    L5_2 = L5_2(L6_2)
    L6_2 = tostring
    L7_2 = L6_1.provider
    L6_2 = L6_2(L7_2)
    L7_2 = tostring
    L8_2 = L6_1.channel
    L7_2 = L7_2(L8_2)
    function L8_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
      L0_3 = {}
      L1_3 = pairs
      L2_3 = L6_1.peers
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
      for L5_3 in L1_3, L2_3, L3_3, L4_3 do
        L6_3 = #L0_3
        L6_3 = L6_3 + 1
        L7_3 = tostring
        L8_3 = L5_3
        L7_3 = L7_3(L8_3)
        L0_3[L6_3] = L7_3
      end
      L1_3 = table
      L1_3 = L1_3.concat
      L2_3 = L0_3
      L3_3 = ", "
      return L1_3(L2_3, L3_3)
    end
    L8_2, L9_2, L10_2 = L8_2()
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    L1_2[L2_2] = L3_2
  else
    L2_2 = #L1_2
    L2_2 = L2_2 + 1
    L1_2[L2_2] = "no active call on this client"
  end
  L2_2 = L26_1
  if L2_2 then
    L2_2 = #L1_2
    L2_2 = L2_2 + 1
    L3_2 = "listening to the speakerphone of a nearby call on channel %s (Config.WorldSounds.speaker)"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L26_1
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    L1_2[L2_2] = L3_2
  end
  if "pma-voice" == L0_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3
      L0_3 = LocalPlayer
      L0_3 = L0_3.state
      L0_3 = L0_3.callChannel
      return L0_3
    end
    L2_2, L3_2 = L2_2(L3_2)
    L4_2 = #L1_2
    L4_2 = L4_2 + 1
    L5_2 = "pma-voice state bag callChannel = %s \194\183 voice_enableCalls = %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    if L2_2 then
      L7_2 = tostring
      L8_2 = L3_2
      L7_2 = L7_2(L8_2)
      if L7_2 then
        goto lbl_114
      end
    end
    L7_2 = "?"
    ::lbl_114::
    L8_2 = GetConvar
    L9_2 = "voice_enableCalls"
    L10_2 = "1"
    L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2)
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
    L1_2[L4_2] = L5_2
    L4_2 = GetConvar
    L5_2 = "voice_enableCalls"
    L6_2 = "1"
    L4_2 = L4_2(L5_2, L6_2)
    if "1" ~= L4_2 then
      L4_2 = #L1_2
      L4_2 = L4_2 + 1
      L1_2[L4_2] = "^1voice_enableCalls is OFF in server.cfg: pma-voice ignores every call channel. Set `setr voice_enableCalls 1`.^7"
    end
  elseif "none" == L0_2 then
    L2_2 = #L1_2
    L2_2 = L2_2 + 1
    L1_2[L2_2] = "^3no voice system detected: calls have no audio. Start pma-voice (or saltychat / mumble-voip) BEFORE apex_phone.^7"
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = print
    L9_2 = "^5[unique_phone] voice:^7 "
    L10_2 = L7_2
    L9_2 = L9_2 .. L10_2
    L8_2(L9_2)
  end
  L2_2 = FW
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.Notify
    if L2_2 then
      L2_2 = FW
      L2_2 = L2_2.Notify
      L3_2 = "Voice: %s"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = L0_2
      L3_2 = L3_2(L4_2, L5_2)
      if "none" == L0_2 then
        L4_2 = "error"
        if L4_2 then
          goto lbl_168
        end
      end
      L4_2 = "success"
      ::lbl_168::
      L2_2(L3_2, L4_2)
    end
  end
end
L30_1 = false
L27_1(L28_1, L29_1, L30_1)
L27_1 = Voice
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L3_2 = L6_1
    if L3_2 then
      goto lbl_14
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_14::
  L3_2 = next
  L4_2 = L6_1.peers
  L3_2 = L3_2(L4_2)
  if nil ~= L3_2 then
    L3_2 = L6_1.peers
    L3_2 = L3_2[L2_2]
    if not L3_2 then
      L3_2 = false
      return L3_2
    end
  end
  L3_2 = L13_1
  L4_2 = L6_1.provider
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = false
    return L3_2
  end
  if A1_2 then
    L3_2 = L7_1
    L3_2[L2_2] = true
    L3_2 = L22_1
    L4_2 = L2_2
    L3_2(L4_2)
    L3_2 = L24_1
    L3_2()
  else
    L3_2 = L7_1
    L3_2 = L3_2[L2_2]
    if L3_2 then
      L3_2 = L7_1
      L3_2[L2_2] = nil
      L3_2 = L23_1
      L4_2 = L2_2
      L5_2 = false
      L3_2(L4_2, L5_2)
    end
  end
  L3_2 = true
  return L3_2
end
L27_1.muteFrom = L28_1
