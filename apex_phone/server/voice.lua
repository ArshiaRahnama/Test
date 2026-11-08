local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1
L0_1 = Voice
if not L0_1 then
  L0_1 = {}
end
Voice = L0_1
L0_1 = 50000
L1_1 = Voice
L1_1.CHANNEL_BASE = L0_1
L1_1 = {}
L2_1 = "pma-voice"
L3_1 = "saltychat"
L4_1 = "mumble-voip"
L1_1[1] = L2_1
L1_1[2] = L3_1
L1_1[3] = L4_1
L2_1 = {}
L2_1["pma-voice"] = true
L2_1.saltychat = true
L2_1["mumble-voip"] = true
L2_1.none = true
function L3_1(A0_2, ...)
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
L4_1 = {}
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L4_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    return
  end
  L2_2 = L4_1
  L2_2[A0_2] = true
  L2_2 = print
  L3_2 = "^3[unique_phone] voz: "
  L4_2 = A1_2
  L5_2 = "^7"
  L3_2 = L3_2 .. L4_2 .. L5_2
  L2_2(L3_2)
end
function L6_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetResourceState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "started" == L1_2
  return L1_2
end
L7_1 = Voice
function L8_1()
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
    L1_2 = L2_1
    L1_2 = L1_2[L0_2]
    if not L1_2 then
      L1_2 = L5_1
      L2_2 = "bad:"
      L3_2 = L0_2
      L2_2 = L2_2 .. L3_2
      L3_2 = "Config.Voice = '%s' is not known; detecting automatically"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = L0_2
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2)
      L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
    else
      L1_2 = L6_1
      L2_2 = L0_2
      L1_2 = L1_2(L2_2)
      if L1_2 then
        return L0_2
      else
        L1_2 = L5_1
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
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      return L6_2
    end
  end
  L1_2 = "none"
  return L1_2
end
L7_1.provider = L8_1
L7_1 = Voice
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 or L1_2 < 1 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L0_1
  L2_2 = L2_2 + L1_2
  return L2_2
end
L7_1.channel = L8_1
L7_1 = {}
L8_1 = Voice
function L9_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = -1
  end
  L2_2 = L7_1
  L1_2 = L2_2[L1_2]
  return L1_2
end
L8_1.session = L9_1
function L8_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = table
  L1_2 = L1_2.pack
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = ...
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = exports
    L0_3 = L0_3.saltychat
    L1_3 = A0_2
    L1_3 = L0_3[L1_3]
    L2_3 = L0_3
    L3_3 = table
    L3_3 = L3_3.unpack
    L4_3 = L1_2
    L5_3 = 1
    L6_3 = L1_2.n
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
    return L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L3_1
    L5_2 = "saltychat %s failed: %s"
    L6_2 = A0_2
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
  return L2_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    return L1_2
  end
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.tointeger
    L10_2 = tonumber
    L11_2 = L8_2
    L10_2, L11_2 = L10_2(L11_2)
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 and L9_2 > 0 then
      L10_2 = L2_2[L9_2]
      if not L10_2 then
        L2_2[L9_2] = true
        L10_2 = #L1_2
        L10_2 = L10_2 + 1
        L1_2[L10_2] = L9_2
      end
    end
  end
  return L1_2
end
L10_1 = Voice
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L3_2 = Voice
  L3_2 = L3_2.channel
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L7_1
  L4_2 = L4_2[L2_2]
  if L4_2 then
    L4_2 = L7_1
    L4_2 = L4_2[L2_2]
    return L4_2
  end
  L4_2 = Voice
  L4_2 = L4_2.provider
  L4_2 = L4_2()
  L5_2 = L9_1
  L6_2 = A1_2
  L5_2 = L5_2(L6_2)
  L6_2 = {}
  L6_2.provider = L4_2
  L6_2.channel = L3_2
  L6_2.peers = L5_2
  if "saltychat" == L4_2 then
    L7_2 = #L5_2
    if L7_2 >= 2 then
      L7_2 = true
      L8_2 = 2
      L9_2 = #L5_2
      L10_2 = 1
      for L11_2 = L8_2, L9_2, L10_2 do
        L12_2 = L8_1
        L13_2 = "EstablishCall"
        L14_2 = L5_2[1]
        L15_2 = L5_2[L11_2]
        L12_2 = L12_2(L13_2, L14_2, L15_2)
        L7_2 = L12_2 or L7_2
        if L12_2 then
        end
      end
      if not L7_2 then
        L7_2 = true
        L8_2 = 2
        L9_2 = #L5_2
        L10_2 = 1
        for L11_2 = L8_2, L9_2, L10_2 do
          L12_2 = L8_1
          L13_2 = "EstablishCall"
          L14_2 = tostring
          L15_2 = L5_2[1]
          L14_2 = L14_2(L15_2)
          L15_2 = tostring
          L16_2 = L5_2[L11_2]
          L15_2, L16_2 = L15_2(L16_2)
          L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
          L7_2 = L12_2 or L7_2
          if L12_2 then
          end
        end
        L8_2 = L7_2 or L8_2
        if not L7_2 then
          L8_2 = nil
        end
        L6_2.str = L8_2
      end
      if not L7_2 then
        L8_2 = L8_1
        L9_2 = "AddPlayersToCall"
        L10_2 = "apex_phone:"
        L11_2 = L2_2
        L10_2 = L10_2 .. L11_2
        L11_2 = L5_2
        L8_2 = L8_2(L9_2, L10_2, L11_2)
        if not L8_2 then
          L8_2 = nil
        end
        L6_2.group = L8_2
        L8_2 = L6_2.group
        if not L8_2 then
          L8_2 = L5_1
          L9_2 = "salty"
          L10_2 = "saltychat: neither EstablishCall nor AddPlayersToCall responded (different version?). Calls without audio."
          L8_2(L9_2, L10_2)
        end
      end
    end
  end
  L7_2 = L7_1
  L7_2[L2_2] = L6_2
  L7_2 = L3_1
  L8_2 = "join %s via %s channel %s peers %s"
  L9_2 = L2_2
  L10_2 = L4_2
  L11_2 = L3_2
  L12_2 = #L5_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  return L6_2
end
L10_1.join = L11_1
L10_1 = Voice
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L2_2 = L7_1
    L2_2 = L2_2[L1_2]
  end
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L7_1
  L3_2[L1_2] = nil
  L3_2 = L2_2.provider
  if "saltychat" == L3_2 then
    L3_2 = L2_2.group
    if L3_2 then
      L3_2 = L8_1
      L4_2 = "RemovePlayersFromCall"
      L5_2 = "apex_phone:"
      L6_2 = L1_2
      L5_2 = L5_2 .. L6_2
      L6_2 = L2_2.peers
      L3_2(L4_2, L5_2, L6_2)
    else
      L3_2 = 2
      L4_2 = L2_2.peers
      L4_2 = #L4_2
      L5_2 = 1
      for L6_2 = L3_2, L4_2, L5_2 do
        L7_2 = L2_2.str
        if L7_2 then
          L7_2 = L8_1
          L8_2 = "EndCall"
          L9_2 = tostring
          L10_2 = L2_2.peers
          L10_2 = L10_2[1]
          L9_2 = L9_2(L10_2)
          L10_2 = tostring
          L11_2 = L2_2.peers
          L11_2 = L11_2[L6_2]
          L10_2, L11_2 = L10_2(L11_2)
          L7_2(L8_2, L9_2, L10_2, L11_2)
        else
          L7_2 = L8_1
          L8_2 = "EndCall"
          L9_2 = L2_2.peers
          L9_2 = L9_2[1]
          L10_2 = L2_2.peers
          L10_2 = L10_2[L6_2]
          L7_2(L8_2, L9_2, L10_2)
        end
      end
    end
  end
  L3_2 = L3_1
  L4_2 = "leave %s (%s)"
  L5_2 = L1_2
  L6_2 = L2_2.provider
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = true
  return L3_2
end
L10_1.leave = L11_1
L10_1 = Voice
function L11_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L4_2 = type
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if "boolean" == L4_2 then
    L4_2 = math
    L4_2 = L4_2.tointeger
    L5_2 = tonumber
    L6_2 = A0_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L5_2(L6_2)
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
    L5_2 = A1_2
    if not L4_2 then
      L6_2 = false
      return L6_2
    end
    L6_2 = pairs
    L7_2 = L7_1
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = ipairs
      L13_2 = L11_2.peers
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
      for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
        if L17_2 == L4_2 then
          L18_2 = Voice
          L18_2 = L18_2.muteFrom
          L19_2 = L10_2
          L20_2 = L4_2
          L21_2 = L5_2
          L22_2 = L11_2.peers
          L18_2, L19_2, L20_2, L21_2, L22_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
          return L18_2, L19_2, L20_2, L21_2, L22_2
        end
      end
    end
    L6_2 = false
    return L6_2
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = A1_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  A1_2 = L5_2
  if not L4_2 or not A1_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L7_1
  L5_2 = L5_2[L4_2]
  if L5_2 then
    L6_2 = L5_2.provider
    if L6_2 then
      goto lbl_72
    end
  end
  L6_2 = Voice
  L6_2 = L6_2.provider
  L6_2 = L6_2()
  ::lbl_72::
  L7_2 = ipairs
  L8_2 = L9_1
  L9_2 = A3_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    if L12_2 ~= A1_2 then
      L13_2 = Push
      L14_2 = L12_2
      L15_2 = "callMute"
      L16_2 = {}
      L16_2.src = A1_2
      if A2_2 then
        L17_2 = true
        if L17_2 then
          goto lbl_92
        end
      end
      L17_2 = false
      ::lbl_92::
      L16_2.on = L17_2
      L16_2.callId = L4_2
      L13_2(L14_2, L15_2, L16_2)
    end
  end
  L7_2 = "pma-voice" == L6_2 or "mumble-voip" == L6_2
  return L7_2
end
L10_1.muteFrom = L11_1
