local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1
L0_1 = "radio"
L1_1 = "radio"
L2_1 = {}
L3_1 = {}
L4_1 = {}
L5_1 = {}
L6_1 = type
L7_1 = Config
L7_1 = L7_1.RateLimit
L6_1 = L6_1(L7_1)
if "table" == L6_1 then
  L6_1 = Config
  L6_1 = L6_1.RateLimit
  if L6_1 then
    goto lbl_23
  end
end
L6_1 = nil
::lbl_23::
if L6_1 then
  L7_1 = type
  L8_1 = L6_1.costs
  L7_1 = L7_1(L8_1)
  if "table" == L7_1 then
    L7_1 = L6_1.costs
    if L7_1 then
      goto lbl_35
    end
  end
  L7_1 = {}
  ::lbl_35::
  L6_1.costs = L7_1
  L7_1 = L6_1.costs
  L8_1 = L7_1["radio.join"]
  if nil == L8_1 then
    L7_1["radio.join"] = 3
  end
  L8_1 = L7_1["radio.leave"]
  if nil == L8_1 then
    L7_1["radio.leave"] = 1
  end
  L8_1 = L7_1["radio.prefs"]
  if nil == L8_1 then
    L7_1["radio.prefs"] = 2
  end
  L8_1 = L7_1["radio.state"]
  if nil == L8_1 then
    L7_1["radio.state"] = 1
  end
end
function L6_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = Dbg
  if L1_2 then
    L1_2 = Dbg
    L2_2 = "radio"
    L3_2 = A0_2
    L4_2 = ...
    L1_2(L2_2, L3_2, L4_2)
  end
end
L7_1 = {}
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L7_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    return
  end
  L2_2 = L7_1
  L2_2[A0_2] = true
  L2_2 = print
  L3_2 = "^3[unique_phone] radio: "
  L4_2 = A1_2
  L5_2 = "^7"
  L3_2 = L3_2 .. L4_2 .. L5_2
  L2_2(L3_2)
end
function L9_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Radio
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Radio
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L10_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if nil ~= A0_2 and A0_2 == A0_2 then
    L2_2 = math
    L2_2 = L2_2.huge
    if A0_2 ~= L2_2 then
      L2_2 = math
      L2_2 = L2_2.huge
      L2_2 = -L2_2
      if A0_2 ~= L2_2 then
        goto lbl_19
      end
    end
  end
  do return A1_2 end
  ::lbl_19::
  return A0_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = 0
  L2_2 = 3
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = 10
    L5_2 = L5_2 ^ L4_2
    L5_2 = A0_2 * L5_2
    L6_2 = math
    L6_2 = L6_2.abs
    L7_2 = math
    L7_2 = L7_2.floor
    L8_2 = L5_2 + 0.5
    L7_2 = L7_2(L8_2)
    L7_2 = L5_2 - L7_2
    L6_2 = L6_2(L7_2)
    L7_2 = 1.0E-6
    if L6_2 < L7_2 then
      return L4_2
    end
  end
  L1_2 = 3
  return L1_2
end
L12_1 = {}
L12_1.names = true
L12_1.numbers = true
L12_1.count = true
L12_1.none = true
L13_1 = {}
L13_1.ptt = true
L13_1.toggle = true
L13_1.open = true
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = type
  L3_2 = A0_2.playerModes
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = ipairs
    L3_2 = A0_2.playerModes
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L13_1
      L8_2 = L8_2[L7_2]
      if L8_2 then
        L8_2 = #L1_2
        L8_2 = L8_2 + 1
        L1_2[L8_2] = L7_2
      end
    end
  end
  L2_2 = #L1_2
  if 0 == L2_2 then
    L2_2 = {}
    L3_2 = "ptt"
    L4_2 = "toggle"
    L5_2 = "open"
    L2_2[1] = L3_2
    L2_2[2] = L4_2
    L2_2[3] = L5_2
    L1_2 = L2_2
  end
  return L1_2
end
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = L9_1
  L0_2 = L0_2()
  L1_2 = L10_1
  L2_2 = L0_2.minFreq
  L3_2 = 1.0
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L10_1
  L3_2 = L0_2.maxFreq
  L4_2 = 999.9
  L2_2 = L2_2(L3_2, L4_2)
  if L1_2 > L2_2 then
    L3_2 = L2_2
    L2_2 = L1_2
    L1_2 = L3_2
  end
  L3_2 = L10_1
  L4_2 = L0_2.step
  L5_2 = 0.1
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 <= 0 then
    L3_2 = 0.1
  end
  L4_2 = type
  L5_2 = L0_2.voice
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L0_2.voice
    if L4_2 then
      goto lbl_33
    end
  end
  L4_2 = {}
  ::lbl_33::
  L5_2 = type
  L6_2 = L0_2.requireItem
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = L0_2.requireItem
    if "" ~= L5_2 then
      L5_2 = L0_2.requireItem
      if L5_2 then
        goto lbl_45
      end
    end
  end
  L5_2 = nil
  ::lbl_45::
  L6_2 = {}
  L6_2.min = L1_2
  L6_2.max = L2_2
  L6_2.step = L3_2
  L7_2 = L11_1
  L8_2 = L3_2
  L7_2 = L7_2(L8_2)
  L6_2.dec = L7_2
  L8_2 = L0_2.showMembers
  L7_2 = L12_1
  L7_2 = L7_2[L8_2]
  if L7_2 then
    L7_2 = L0_2.showMembers
    if L7_2 then
      goto lbl_63
    end
  end
  L7_2 = "names"
  ::lbl_63::
  L6_2.mode = L7_2
  L7_2 = math
  L7_2 = L7_2.max
  L8_2 = 0
  L9_2 = math
  L9_2 = L9_2.floor
  L10_2 = L10_1
  L11_2 = L0_2.maxMembersPerChannel
  L12_2 = 32
  L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2)
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.maxMembers = L7_2
  L7_2 = L0_2.privateChannels
  L7_2 = false ~= L7_2
  L6_2.private = L7_2
  L7_2 = L0_2.allowCallsign
  L7_2 = false ~= L7_2
  L6_2.callsign = L7_2
  L7_2 = math
  L7_2 = L7_2.max
  L8_2 = 0
  L9_2 = math
  L9_2 = L9_2.min
  L10_2 = 50
  L11_2 = math
  L11_2 = L11_2.floor
  L12_2 = L10_1
  L13_2 = L0_2.maxPresets
  L14_2 = 12
  L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L9_2 = L9_2(L10_2, L11_2)
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.maxPresets = L7_2
  L6_2.item = L5_2
  L7_2 = type
  L8_2 = L0_2.requireItemLabel
  L7_2 = L7_2(L8_2)
  if "string" == L7_2 then
    L7_2 = L0_2.requireItemLabel
    if "" ~= L7_2 then
      L7_2 = L0_2.requireItemLabel
      if L7_2 then
        goto lbl_117
      end
    end
  end
  L7_2 = L5_2
  ::lbl_117::
  L6_2.itemLabel = L7_2
  L7_2 = L0_2.requireEarbuds
  L7_2 = true == L7_2
  L6_2.earbuds = L7_2
  L7_2 = math
  L7_2 = L7_2.max
  L8_2 = 0
  L9_2 = L10_1
  L10_2 = L0_2.maxTalkSeconds
  L11_2 = 60
  L9_2 = L9_2(L10_2, L11_2)
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.maxTalk = L7_2
  L7_2 = L0_2.notifyOnJoin
  L7_2 = false ~= L7_2
  L6_2.notifyJoin = L7_2
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = L10_1
  L9_2 = L4_2.channelBase
  L10_2 = 2000000
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2, L10_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2.base = L7_2
  L7_2 = L4_2.lockChannels
  L7_2 = false ~= L7_2
  L6_2.lock = L7_2
  L7_2 = type
  L8_2 = L4_2.saltychat
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = L4_2.saltychat
    if L7_2 then
      goto lbl_163
    end
  end
  L7_2 = {}
  ::lbl_163::
  L6_2.salty = L7_2
  L7_2 = math
  L7_2 = L7_2.max
  L8_2 = 0
  L9_2 = math
  L9_2 = L9_2.min
  L10_2 = 100
  L11_2 = math
  L11_2 = L11_2.floor
  L12_2 = L10_1
  L13_2 = L0_2.defaultVolume
  L14_2 = 60
  L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L9_2 = L9_2(L10_2, L11_2)
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.defVol = L7_2
  L8_2 = L0_2.talkMode
  L7_2 = L13_1
  L7_2 = L7_2[L8_2]
  if L7_2 then
    L7_2 = L0_2.talkMode
    if L7_2 then
      goto lbl_189
    end
  end
  L7_2 = "ptt"
  ::lbl_189::
  L6_2.talkMode = L7_2
  L7_2 = L0_2.allowPlayerMode
  L7_2 = true == L7_2
  L6_2.allowPlayer = L7_2
  L7_2 = L14_1
  L8_2 = L0_2
  L7_2 = L7_2(L8_2)
  L6_2.playerModes = L7_2
  return L6_2
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L13_1
  L2_2 = L2_2[A1_2]
  if not L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = A0_2.playerModes
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    if L7_2 == A1_2 then
      L8_2 = true
      return L8_2
    end
  end
  L2_2 = false
  return L2_2
end
L17_1 = {}
L18_1 = "pma-voice"
L19_1 = "saltychat"
L20_1 = "mumble-voip"
L17_1[1] = L18_1
L17_1[2] = L19_1
L17_1[3] = L20_1
L18_1 = {}
L18_1["pma-voice"] = true
L18_1.saltychat = true
L18_1["mumble-voip"] = true
function L19_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetResourceState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "started" == L1_2
  return L1_2
end
function L20_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L9_1
  L0_2 = L0_2()
  L0_2 = L0_2.voice
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = L0_2.provider
    if L1_2 then
      goto lbl_13
    end
  end
  L1_2 = L0_2
  ::lbl_13::
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 or "" == L1_2 then
    L1_2 = "auto"
  end
  if "none" == L1_2 then
    L2_2 = "none"
    return L2_2
  end
  L2_2 = "none"
  if "auto" ~= L1_2 then
    L3_2 = L18_1
    L3_2 = L3_2[L1_2]
    if L3_2 then
      L3_2 = L19_1
      L4_2 = L1_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        L2_2 = L1_2
    end
    else
      L3_2 = L18_1
      L3_2 = L3_2[L1_2]
      if not L3_2 then
        L3_2 = L8_1
        L4_2 = "bad"
        L5_2 = "Config.Radio.voice.provider = '%s' is not known"
        L6_2 = L5_2
        L5_2 = L5_2.format
        L7_2 = L1_2
        L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2, L7_2)
        L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
      else
        L3_2 = L8_1
        L4_2 = "off:"
        L5_2 = L1_2
        L4_2 = L4_2 .. L5_2
        L5_2 = "Config.Radio.voice.provider = '%s' but that resource is not running: radio disabled"
        L6_2 = L5_2
        L5_2 = L5_2.format
        L7_2 = L1_2
        L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2, L7_2)
        L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
      end
    end
  else
    L3_2 = Config
    L3_2 = L3_2.Voice
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 and "auto" ~= L3_2 and "" ~= L3_2 then
      L4_2 = L18_1
      L4_2 = L4_2[L3_2]
      if L4_2 then
        L4_2 = L19_1
        L5_2 = L3_2
        L4_2 = L4_2(L5_2)
        if L4_2 then
          L2_2 = L3_2
      end
    end
    else
      L4_2 = ipairs
      L5_2 = L17_1
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = L19_1
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        if L10_2 then
          L2_2 = L9_2
          break
        end
      end
    end
  end
  if "pma-voice" == L2_2 then
    L3_2 = GetConvarInt
    L4_2 = "voice_enableRadios"
    L5_2 = 1
    L3_2 = L3_2(L4_2, L5_2)
    if 1 ~= L3_2 then
      L3_2 = L8_1
      L4_2 = "pmaoff"
      L5_2 = "pma-voice has voice_enableRadios = 0: the phone radio stays disabled"
      L3_2(L4_2, L5_2)
      L3_2 = "none"
      return L3_2
    end
  end
  return L2_2
end
function L21_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = table
  L2_2 = L2_2.pack
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = ...
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = exports
    L1_3 = A0_2
    L0_3 = L0_3[L1_3]
    L1_3 = A1_2
    L1_3 = L0_3[L1_3]
    L2_3 = L0_3
    L3_3 = table
    L3_3 = L3_3.unpack
    L4_3 = L2_2
    L5_3 = 1
    L6_3 = L2_2.n
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
    return L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
  end
  L3_2, L4_2 = L3_2(L4_2)
  if not L3_2 then
    L5_2 = L6_1
    L6_2 = "%s %s failed: %s"
    L7_2 = A0_2
    L8_2 = A1_2
    L9_2 = tostring
    L10_2 = L4_2
    L9_2, L10_2 = L9_2(L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  end
  L5_2 = L3_2
  L6_2 = L4_2
  return L5_2, L6_2
end
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L10_1
  L3_2 = A0_2
  L4_2 = nil
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = A1_2.step
  L4_2 = L2_2 / L4_2
  L4_2 = L4_2 + 0.5
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2.step
  L2_2 = L3_2 * L4_2
  L3_2 = A1_2.dec
  L4_2 = 10
  L3_2 = L4_2 ^ L3_2
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = L2_2 * L3_2
  L5_2 = L5_2 + 0.5
  L4_2 = L4_2(L5_2)
  L2_2 = L4_2 / L3_2
  L5_2 = A1_2.min
  L5_2 = L5_2 - 1.0E-9
  if not (L2_2 < L5_2) then
    L5_2 = A1_2.max
    L5_2 = L5_2 + 1.0E-9
    if not (L2_2 > L5_2) then
      goto lbl_45
    end
  end
  L5_2 = nil
  do return L5_2 end
  ::lbl_45::
  L5_2 = L2_2
  L6_2 = L4_2
  L7_2 = "%."
  L8_2 = A1_2.dec
  L9_2 = "f"
  L7_2 = L7_2 .. L8_2 .. L9_2
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = L2_2
  L7_2, L8_2, L9_2 = L7_2(L8_2, L9_2)
  return L5_2, L6_2, L7_2, L8_2, L9_2
end
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = A0_2[A1_2]
  if nil ~= L2_2 then
    if false == L2_2 then
      L3_2 = nil
      return L3_2
    end
    L3_2 = math
    L3_2 = L3_2.floor
    L4_2 = L10_1
    L5_2 = L2_2
    L6_2 = 0
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2, L6_2)
    return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L8_2 == A1_2 then
      L9_2 = 0
      return L9_2
    end
  end
  L3_2 = nil
  return L3_2
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.job
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = {}
  ::lbl_12::
  L3_2 = FW
  L3_2 = L3_2.name
  if "standalone" == L3_2 and L1_2 then
    L3_2 = Config
    L3_2 = L3_2.Standalone
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = L3_2.getJob
      if L4_2 then
        goto lbl_29
      end
    end
    L4_2 = nil
    ::lbl_29::
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "function" == L5_2 then
      L5_2 = pcall
      L6_2 = L4_2
      L7_2 = A0_2
      L5_2, L6_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L7_2 = type
        L8_2 = L6_2
        L7_2 = L7_2(L8_2)
        if "table" == L7_2 then
          L7_2 = type
          L8_2 = L6_2.name
          L7_2 = L7_2(L8_2)
          if "string" == L7_2 then
            L7_2 = L6_2.name
            if "" ~= L7_2 then
              L7_2 = {}
              L8_2 = L6_2.name
              L7_2.name = L8_2
              L8_2 = tonumber
              L9_2 = L6_2.gradeLevel
              if not L9_2 then
                L9_2 = L6_2.level
              end
              L8_2 = L8_2(L9_2)
              if not L8_2 then
                L8_2 = 0
              end
              L7_2.gradeLevel = L8_2
              L8_2 = L6_2.onduty
              L8_2 = false ~= L8_2
              L7_2.onduty = L8_2
              L2_2 = L7_2
            end
          end
        end
      end
    end
  end
  return L2_2
end
function L25_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L9_1
  L1_2 = L1_2()
  L1_2 = L1_2.restricted
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L10_1
      L9_2 = L7_2.from
      L10_2 = nil
      L8_2 = L8_2(L9_2, L10_2)
      L9_2 = L10_1
      L10_2 = L7_2.to
      L11_2 = nil
      L9_2 = L9_2(L10_2, L11_2)
      if L8_2 and L9_2 then
        if L8_2 > L9_2 then
          L10_2 = L9_2
          L9_2 = L8_2
          L8_2 = L10_2
        end
        L10_2 = L8_2 - 1.0E-9
        if A0_2 >= L10_2 then
          L10_2 = L9_2 + 1.0E-9
          if A0_2 <= L10_2 then
            return L7_2
          end
        end
      end
    end
  end
  L2_2 = nil
  return L2_2
end
function L26_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = type
  L4_2 = A1_2.ace
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.ace
    if "" ~= L3_2 then
      L3_2 = IsPlayerAceAllowed
      L4_2 = A0_2
      L5_2 = A1_2.ace
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        L3_2 = true
        return L3_2
      end
    end
  end
  L3_2 = type
  L4_2 = A1_2.jobs
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = false
    return L3_2
  end
  if not A2_2 then
    L3_2 = L24_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    A2_2 = L3_2
  end
  L3_2 = A2_2.name
  L4_2 = A2_2.onduty
  L4_2 = false ~= L4_2
  L5_2 = L23_1
  L6_2 = A1_2.jobs
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  if nil == L5_2 then
    L6_2 = FW
    L6_2 = L6_2.name
    if "esx" == L6_2 then
      L6_2 = type
      L7_2 = L3_2
      L6_2 = L6_2(L7_2)
      if "string" == L6_2 then
        L6_2 = #L3_2
        if L6_2 > 3 then
          L7_2 = L3_2
          L6_2 = L3_2.sub
          L8_2 = 1
          L9_2 = 3
          L6_2 = L6_2(L7_2, L8_2, L9_2)
          if "off" == L6_2 then
            L6_2 = L23_1
            L7_2 = A1_2.jobs
            L9_2 = L3_2
            L8_2 = L3_2.sub
            L10_2 = 4
            L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2)
            L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
            L5_2 = L6_2
            L4_2 = false
          end
        end
      end
    end
  end
  if nil == L5_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = A1_2.onDuty
  if true == L6_2 and not L4_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = A2_2.gradeLevel
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L6_2 = L5_2 <= L6_2
  return L6_2
end
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = L9_1
  L0_2 = L0_2()
  L0_2 = L0_2.enabled
  if false == L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = GlobalState
  L0_2 = L0_2["apex_phone:settings"]
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = L0_2.disabledApps
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = ipairs
      L2_2 = L0_2.disabledApps
      L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
      for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
        L7_2 = L0_1
        if L6_2 == L7_2 then
          L7_2 = true
          return L7_2
        end
      end
    end
  end
  L1_2 = false
  return L1_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GlobalState
  L2_2 = "apex_phone:airpods:"
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L2_2 = L2_2 .. L3_2
  L1_2 = L1_2[L2_2]
  L1_2 = nil ~= L1_2
  return L1_2
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = tonumber
  L3_2 = FW
  L3_2 = L3_2.HasItem
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L2_2 = 0
  end
  L2_2 = L2_2 > 0
  return L2_2
end
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L3_2 = A0_2
  L2_2 = A0_2.gsub
  L4_2 = "[%c<>\"\\]"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "^%s+"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%s+$"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  A0_2 = L2_2
  if "" == A0_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = {}
  L3_2 = 0
  L5_2 = A0_2
  L4_2 = A0_2.gmatch
  L6_2 = "[\000-\127\194-\244][\128-\191]*"
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    L3_2 = L3_2 + 1
    if A1_2 < L3_2 then
      break
    end
    L2_2[L3_2] = L8_2
  end
  L4_2 = table
  L4_2 = L4_2.concat
  L5_2 = L2_2
  return L4_2(L5_2)
end
function L31_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = {}
  L3_2 = {}
  L2_2.presets = L3_2
  L3_2 = A1_2.defVol
  L2_2.vol = L3_2
  L2_2.cs = nil
  L2_2.last = nil
  L2_2.mode = nil
  L3_2 = {}
  L4_2 = type
  L5_2 = A0_2.presets
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = ipairs
    L5_2 = A0_2.presets
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = L2_2.presets
      L10_2 = #L10_2
      L11_2 = A1_2.maxPresets
      if L10_2 >= L11_2 then
        break
      end
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = L22_1
        L11_2 = L9_2.f
        L12_2 = A1_2
        L10_2, L11_2 = L10_2(L11_2, L12_2)
        if L10_2 then
          L12_2 = L3_2[L11_2]
          if not L12_2 then
            L3_2[L11_2] = true
            L12_2 = L2_2.presets
            L13_2 = L2_2.presets
            L13_2 = #L13_2
            L13_2 = L13_2 + 1
            L14_2 = {}
            L14_2.f = L10_2
            L15_2 = L30_1
            L16_2 = L9_2.n
            L17_2 = 20
            L15_2 = L15_2(L16_2, L17_2)
            L14_2.n = L15_2
            L12_2[L13_2] = L14_2
          end
        end
      end
    end
  end
  L4_2 = L10_1
  L5_2 = A0_2.vol
  L6_2 = nil
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = math
    L5_2 = L5_2.max
    L6_2 = 0
    L7_2 = math
    L7_2 = L7_2.min
    L8_2 = 100
    L9_2 = math
    L9_2 = L9_2.floor
    L10_2 = L4_2 + 0.5
    L9_2 = L9_2(L10_2)
    L7_2 = L7_2(L8_2, L9_2)
    L5_2 = L5_2(L6_2, L7_2)
    L2_2.vol = L5_2
  end
  L5_2 = L30_1
  L6_2 = A0_2.cs
  L7_2 = 16
  L5_2 = L5_2(L6_2, L7_2)
  L2_2.cs = L5_2
  L5_2 = L22_1
  L6_2 = A0_2.last
  L7_2 = A1_2
  L5_2 = L5_2(L6_2, L7_2)
  L2_2.last = L5_2
  L6_2 = A0_2.mode
  L5_2 = L13_1
  L5_2 = L5_2[L6_2]
  if L5_2 then
    L5_2 = A0_2.mode
    if L5_2 then
      goto lbl_108
    end
  end
  L5_2 = nil
  ::lbl_108::
  L2_2.mode = L5_2
  return L2_2
end
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L4_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = L4_1
    L1_2 = L1_2[A0_2]
    return L1_2
  end
  L1_2 = nil
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT v FROM apex_phone_userdata WHERE owner = ? AND k = ?"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = L1_1
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    return L0_3(L1_3, L2_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = L3_2[1]
      if L4_2 then
        L4_2 = type
        L5_2 = L3_2[1]
        L5_2 = L5_2.v
        L4_2 = L4_2(L5_2)
        if "string" == L4_2 then
          L4_2 = pcall
          L5_2 = json
          L5_2 = L5_2.decode
          L6_2 = L3_2[1]
          L6_2 = L6_2.v
          L4_2, L5_2 = L4_2(L5_2, L6_2)
          if L4_2 then
            L1_2 = L5_2
          end
        end
      end
    end
  end
  L4_2 = L4_1
  L5_2 = L31_1
  L6_2 = L1_2
  L7_2 = L15_1
  L7_2 = L7_2()
  L5_2 = L5_2(L6_2, L7_2)
  L4_2[A0_2] = L5_2
  L4_2 = L4_1
  L4_2 = L4_2[A0_2]
  return L4_2
end
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L4_1
  L2_2[A0_2] = A1_2
  L2_2 = json
  L2_2 = L2_2.encode
  L3_2 = {}
  L4_2 = A1_2.presets
  L3_2.presets = L4_2
  L4_2 = A1_2.vol
  L3_2.vol = L4_2
  L4_2 = A1_2.cs
  L3_2.cs = L4_2
  L4_2 = A1_2.last
  L3_2.last = L4_2
  L4_2 = A1_2.mode
  L3_2.mode = L4_2
  L2_2 = L2_2(L3_2)
  L3_2 = Now
  if L3_2 then
    L3_2 = Now
    L3_2 = L3_2()
    if L3_2 then
      goto lbl_30
    end
  end
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  L3_2 = L3_2 * 1000
  ::lbl_30::
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = MySQL
    L0_3 = L0_3.update
    L0_3 = L0_3.await
    L1_3 = "INSERT INTO apex_phone_userdata (owner, k, v, updated) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE v = VALUES(v), updated = VALUES(updated)"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = L1_1
    L5_3 = L2_2
    L6_3 = L3_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L0_3(L1_3, L2_3)
  end
  L4_2, L5_2 = L4_2(L5_2)
  if not L4_2 then
    L6_2 = print
    L7_2 = "^1[unique_phone]^0 radio: preferences not saved: %s"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = tostring
    L10_2 = L5_2
    L9_2, L10_2 = L9_2(L10_2)
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2)
    L6_2(L7_2, L8_2, L9_2, L10_2)
  end
  return L4_2
end
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if not A1_2 then
    L2_2 = L15_1
    L2_2 = L2_2()
    A1_2 = L2_2
  end
  L2_2 = A1_2.allowPlayer
  if L2_2 then
    L2_2 = GetCid
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    L3_2 = L2_2 or L3_2
    if L2_2 then
      L3_2 = L4_1
      L3_2 = L3_2[L2_2]
    end
    if L3_2 then
      L4_2 = L16_1
      L5_2 = A1_2
      L6_2 = L3_2.mode
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        L4_2 = L3_2.mode
        return L4_2
      end
    end
  end
  L2_2 = A1_2.talkMode
  return L2_2
end
function L35_1(A0_2, A1_2)
  local L2_2
  if "numbers" == A1_2 then
    L2_2 = A0_2.num
    return L2_2
  end
  L2_2 = A0_2.cs
  if not L2_2 then
    L2_2 = A0_2.name
  end
  return L2_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = A1_2.mode
  L3_2 = {}
  L4_2 = A0_2.key
  L3_2.key = L4_2
  L4_2 = A0_2.label
  L3_2.freq = L4_2
  L3_2.mode = L2_2
  if "none" == L2_2 then
    return L3_2
  end
  L4_2 = A0_2.n
  L3_2.count = L4_2
  if "count" == L2_2 then
    return L3_2
  end
  L4_2 = {}
  L5_2 = pairs
  L6_2 = A0_2.members
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L3_1
    L11_2 = L11_2[L9_2]
    if L11_2 then
      L12_2 = #L4_2
      L12_2 = L12_2 + 1
      L13_2 = {}
      L13_2.tag = L10_2
      L14_2 = L35_1
      L15_2 = L11_2
      L16_2 = L2_2
      L14_2 = L14_2(L15_2, L16_2)
      L13_2.label = L14_2
      L14_2 = L11_2.talk
      if not L14_2 then
        L14_2 = nil
      end
      L13_2.talk = L14_2
      L14_2 = L11_2.talk
      if L14_2 then
        L14_2 = L11_2.open
        if L14_2 then
          goto lbl_50
        end
      end
      L14_2 = nil
      ::lbl_50::
      L13_2.open = L14_2
      L4_2[L12_2] = L13_2
    end
  end
  L5_2 = table
  L5_2 = L5_2.sort
  L6_2 = L4_2
  function L7_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.tag
    L3_3 = A1_3.tag
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L5_2(L6_2, L7_2)
  L3_2.list = L4_2
  return L3_2
end
function L37_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = pairs
  L5_2 = A0_2.members
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    if L8_2 ~= A3_2 then
      L9_2 = Push
      L10_2 = L8_2
      L11_2 = A1_2
      L12_2 = A2_2
      L9_2(L10_2, L11_2, L12_2)
    end
  end
end
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = A0_2.n
  if L2_2 <= 0 then
    return
  end
  L2_2 = L37_1
  L3_2 = A0_2
  L4_2 = "radio:members"
  L5_2 = L36_1
  L6_2 = A0_2
  L7_2 = A1_2 or L7_2
  if not A1_2 then
    L7_2 = L15_1
    L7_2 = L7_2()
  end
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
end
function L39_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = tostring
  L3_2 = A0_2.salty
  L3_2 = L3_2.prefix
  if not L3_2 then
    L3_2 = "apexphone_"
  end
  L2_2 = L2_2(L3_2)
  L3_2 = A1_2
  L2_2 = L2_2 .. L3_2
  return L2_2
end
function L40_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L5_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return
  end
  L1_2 = L21_1
  L2_2 = "pma-voice"
  L3_2 = "addChannelCheck"
  L4_2 = A0_2
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = A0_3
    end
    L2_3 = L3_1
    L1_3 = L2_3[L1_3]
    L2_3 = L1_3 or L2_3
    if L1_3 then
      L3_3 = L1_3.key
      L2_3 = L2_1
      L2_3 = L2_3[L3_3]
    end
    L3_3 = nil ~= L2_3
    return L3_3
  end
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if L1_2 then
    L2_2 = L5_1
    L2_2[A0_2] = true
  end
end
function L41_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if "pma-voice" == A2_2 then
    L4_2 = pcall
    function L5_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
      L0_3 = Player
      L1_3 = A0_2
      L0_3 = L0_3(L1_3)
      L0_3 = L0_3.state
      L1_3 = L0_3.disableRadio
      if nil == L1_3 then
        L2_3 = L0_3
        L1_3 = L0_3.set
        L3_3 = "disableRadio"
        L4_3 = 0
        L5_3 = true
        L1_3(L2_3, L3_3, L4_3, L5_3)
      end
    end
    L4_2(L5_2)
    L4_2 = A3_2.lock
    if L4_2 then
      L4_2 = L40_1
      L5_2 = A1_2.ch
      L4_2(L5_2)
    end
    L4_2 = L21_1
    L5_2 = "pma-voice"
    L6_2 = "setPlayerRadio"
    L7_2 = A0_2
    L8_2 = A1_2.ch
    L4_2(L5_2, L6_2, L7_2, L8_2)
  elseif "saltychat" == A2_2 then
    L4_2 = L21_1
    L5_2 = "saltychat"
    L6_2 = "SetPlayerRadioChannel"
    L7_2 = A0_2
    L8_2 = A1_2.salty
    L9_2 = true
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    L4_2 = A3_2.salty
    L4_2 = L4_2.speaker
    if true == L4_2 then
      L4_2 = L21_1
      L5_2 = "saltychat"
      L6_2 = "SetPlayerRadioSpeaker"
      L7_2 = A0_2
      L8_2 = true
      L4_2(L5_2, L6_2, L7_2, L8_2)
    end
  end
end
function L42_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if "pma-voice" == A2_2 then
    L3_2 = 0
    L4_2 = pcall
    function L5_2()
      local L0_3, L1_3, L2_3
      L0_3 = tonumber
      L1_3 = Player
      L2_3 = A0_2
      L1_3 = L1_3(L2_3)
      L1_3 = L1_3.state
      L1_3 = L1_3.radioChannel
      L0_3 = L0_3(L1_3)
      if not L0_3 then
        L0_3 = 0
      end
      L3_2 = L0_3
    end
    L4_2(L5_2)
    L4_2 = A1_2.ch
    if L3_2 == L4_2 then
      L4_2 = L21_1
      L5_2 = "pma-voice"
      L6_2 = "setPlayerRadio"
      L7_2 = A0_2
      L8_2 = 0
      L4_2(L5_2, L6_2, L7_2, L8_2)
    end
  elseif "saltychat" == A2_2 then
    L3_2 = L21_1
    L4_2 = "saltychat"
    L5_2 = "RemovePlayerRadioChannel"
    L6_2 = A0_2
    L7_2 = A1_2.salty
    L3_2(L4_2, L5_2, L6_2, L7_2)
  end
end
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L4_2 = L2_2.key
    L3_2 = L2_1
    L3_2 = L3_2[L4_2]
  end
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2 or L5_2
  if L4_2 then
    L5_2 = L4_1
    L5_2 = L5_2[L4_2]
  end
  L6_2 = {}
  L7_2 = L3_2.key
  L6_2.key = L7_2
  L7_2 = L3_2.freq
  L6_2.freq = L7_2
  L7_2 = L3_2.label
  L6_2.label = L7_2
  L7_2 = L3_2.ch
  L6_2.ch = L7_2
  L7_2 = L3_2.salty
  L6_2.salty = L7_2
  L7_2 = L3_2.provider
  L6_2.provider = L7_2
  L7_2 = L2_2.tag
  L6_2.tag = L7_2
  L7_2 = L3_2.pass
  L7_2 = nil ~= L7_2
  L6_2.locked = L7_2
  L7_2 = L3_2.zone
  if not L7_2 then
    L7_2 = false
  end
  L6_2.zone = L7_2
  L7_2 = A1_2.mode
  if "none" ~= L7_2 then
    L7_2 = L3_2.n
    if L7_2 then
      goto lbl_53
    end
  end
  L7_2 = nil
  ::lbl_53::
  L6_2.count = L7_2
  if L5_2 then
    L7_2 = L5_2.vol
    if L7_2 then
      goto lbl_60
    end
  end
  L7_2 = A1_2.defVol
  ::lbl_60::
  L6_2.vol = L7_2
  L7_2 = L34_1
  L8_2 = A0_2
  L9_2 = A1_2
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.mode = L7_2
  if L5_2 then
    L7_2 = L5_2.mode
    if L7_2 then
      goto lbl_72
    end
  end
  L7_2 = false
  ::lbl_72::
  L6_2.pmode = L7_2
  return L6_2
end
function L44_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = L3_1
  L4_2[A0_2] = nil
  L5_2 = L3_2.key
  L4_2 = L2_1
  L4_2 = L4_2[L5_2]
  if not L4_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = L4_2.members
  L5_2[A0_2] = nil
  L5_2 = math
  L5_2 = L5_2.max
  L6_2 = 0
  L7_2 = L4_2.n
  L7_2 = L7_2 - 1
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.n = L5_2
  if not A2_2 then
    L5_2 = L42_1
    L6_2 = A0_2
    L7_2 = L4_2
    L8_2 = L4_2.provider
    L5_2(L6_2, L7_2, L8_2)
  end
  L5_2 = L15_1
  L5_2 = L5_2()
  L6_2 = L4_2.n
  if L6_2 <= 0 then
    L7_2 = L4_2.key
    L6_2 = L2_1
    L6_2[L7_2] = nil
  else
    L6_2 = L3_2.talk
    if L6_2 then
      L6_2 = L37_1
      L7_2 = L4_2
      L8_2 = "radio:talk"
      L9_2 = {}
      L10_2 = L4_2.key
      L9_2.key = L10_2
      L10_2 = L3_2.tag
      L9_2.tag = L10_2
      L9_2.on = false
      L6_2(L7_2, L8_2, L9_2)
    end
    L6_2 = L5_2.notifyJoin
    if L6_2 and "switch" ~= A1_2 then
      L6_2 = L37_1
      L7_2 = L4_2
      L8_2 = "radio:event"
      L9_2 = {}
      L10_2 = L4_2.key
      L9_2.key = L10_2
      L9_2.kind = "leave"
      L10_2 = L5_2.mode
      if "names" ~= L10_2 then
        L10_2 = L5_2.mode
        if "numbers" ~= L10_2 then
          goto lbl_81
        end
      end
      L10_2 = L35_1
      L11_2 = L3_2
      L12_2 = L5_2.mode
      L10_2 = L10_2(L11_2, L12_2)
      ::lbl_81::
      if not L10_2 then
        L10_2 = nil
      end
      L9_2.label = L10_2
      L6_2(L7_2, L8_2, L9_2)
    end
    L6_2 = L38_1
    L7_2 = L4_2
    L8_2 = L5_2
    L6_2(L7_2, L8_2)
  end
  if not A2_2 and "switch" ~= A1_2 then
    L6_2 = Push
    L7_2 = A0_2
    L8_2 = "radio:left"
    L9_2 = {}
    L10_2 = A1_2 or L10_2
    if not A1_2 then
      L10_2 = "user"
    end
    L9_2.reason = L10_2
    L10_2 = L4_2.label
    L9_2.freq = L10_2
    L6_2(L7_2, L8_2, L9_2)
  end
  L6_2 = L6_1
  L7_2 = "%s left %s (%s)"
  L8_2 = A0_2
  L9_2 = L4_2.label
  L10_2 = tostring
  L11_2 = A1_2
  L10_2, L11_2, L12_2 = L10_2(L11_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = true
  return L6_2
end
function L45_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if not A0_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L44_1
  L3_2 = A0_2
  L4_2 = A1_2 or L4_2
  if not A1_2 then
    L4_2 = "user"
  end
  L5_2 = false
  return L2_2(L3_2, L4_2, L5_2)
end
RadioLeave = L45_1
function L45_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 or not A2_2 then
    L3_2 = {}
    A2_2 = L3_2
  end
  if not A0_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L15_1
  L3_2 = L3_2()
  L4_2 = L27_1
  L4_2 = L4_2()
  if L4_2 then
    L4_2 = {}
    L4_2.error = "disabled"
    return L4_2
  end
  L4_2 = L20_1
  L4_2 = L4_2()
  if "none" == L4_2 then
    L5_2 = {}
    L5_2.error = "novoice"
    return L5_2
  end
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "noplayer"
    return L6_2
  end
  L6_2 = HasPhoneItem
  if L6_2 then
    L6_2 = HasPhoneItem
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "nophone"
      return L6_2
    end
  end
  L6_2 = L3_2.item
  if L6_2 then
    L6_2 = L29_1
    L7_2 = A0_2
    L8_2 = L3_2.item
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "item"
      L7_2 = L3_2.itemLabel
      L6_2.item = L7_2
      return L6_2
    end
  end
  L6_2 = L3_2.earbuds
  if L6_2 then
    L6_2 = L28_1
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "earbuds"
      return L6_2
    end
  end
  L6_2 = L22_1
  L7_2 = A1_2
  L8_2 = L3_2
  L6_2, L7_2, L8_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L9_2 = {}
    L9_2.error = "range"
    L10_2 = L3_2.min
    L9_2.min = L10_2
    L10_2 = L3_2.max
    L9_2.max = L10_2
    return L9_2
  end
  L9_2 = L25_1
  L10_2 = L6_2
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L10_2 = L26_1
    L11_2 = A0_2
    L12_2 = L9_2
    L10_2 = L10_2(L11_2, L12_2)
    if not L10_2 then
      L10_2 = {}
      L10_2.error = "restricted"
      L11_2 = type
      L12_2 = L9_2.label
      L11_2 = L11_2(L12_2)
      if "string" == L11_2 then
        L11_2 = L9_2.label
        if L11_2 then
          goto lbl_124
        end
      end
      L11_2 = false
      ::lbl_124::
      L10_2.zone = L11_2
      return L10_2
    end
  end
  L10_2 = L3_1
  L10_2 = L10_2[A0_2]
  L11_2 = L2_1
  L11_2 = L11_2[L7_2]
  if L10_2 then
    L12_2 = L10_2.key
    if L12_2 == L7_2 and L11_2 then
      L12_2 = {}
      L12_2.ok = true
      L13_2 = L43_1
      L14_2 = A0_2
      L15_2 = L3_2
      L13_2 = L13_2(L14_2, L15_2)
      L12_2.joined = L13_2
      L13_2 = L36_1
      L14_2 = L11_2
      L15_2 = L3_2
      L13_2 = L13_2(L14_2, L15_2)
      L12_2.members = L13_2
      return L12_2
    end
  end
  if L11_2 then
    L12_2 = L3_2.maxMembers
    if L12_2 > 0 then
      L12_2 = L11_2.n
      L13_2 = L3_2.maxMembers
      if L12_2 >= L13_2 then
        L12_2 = {}
        L12_2.error = "full"
        return L12_2
      end
    end
  end
  L12_2 = L3_2.private
  if L12_2 then
    L12_2 = type
    L13_2 = A2_2.pass
    L12_2 = L12_2(L13_2)
    if "string" == L12_2 then
      L12_2 = L30_1
      L13_2 = A2_2.pass
      L14_2 = 16
      L12_2 = L12_2(L13_2, L14_2)
      if L12_2 then
        goto lbl_179
      end
    end
  end
  L12_2 = nil
  ::lbl_179::
  if L11_2 then
    L13_2 = L11_2.pass
    if L13_2 then
      L13_2 = L11_2.pass
      if L13_2 ~= L12_2 then
        L13_2 = {}
        if L12_2 then
          L14_2 = "badpass"
          if L14_2 then
            goto lbl_195
          end
        end
        L14_2 = "locked"
        ::lbl_195::
        L13_2.error = L14_2
        return L13_2
      end
    end
  end
  if L10_2 then
    L13_2 = L44_1
    L14_2 = A0_2
    L15_2 = "switch"
    L16_2 = false
    L13_2(L14_2, L15_2, L16_2)
  end
  L13_2 = L2_1
  L11_2 = L13_2[L7_2]
  if not L11_2 then
    L13_2 = {}
    L13_2.key = L7_2
    L13_2.freq = L6_2
    L13_2.label = L8_2
    L14_2 = L3_2.base
    L14_2 = L14_2 + L7_2
    L13_2.ch = L14_2
    L14_2 = L39_1
    L15_2 = L3_2
    L16_2 = L8_2
    L14_2 = L14_2(L15_2, L16_2)
    L13_2.salty = L14_2
    L13_2.provider = L4_2
    L13_2.pass = L12_2
    if L9_2 then
      L14_2 = type
      L15_2 = L9_2.label
      L14_2 = L14_2(L15_2)
      if "string" == L14_2 then
        L14_2 = L9_2.label
        if L14_2 then
          goto lbl_238
        end
      end
      L14_2 = true
      if L14_2 then
        goto lbl_238
      end
    end
    L14_2 = nil
    ::lbl_238::
    L13_2.zone = L14_2
    L14_2 = {}
    L13_2.members = L14_2
    L13_2.n = 0
    L13_2.nextTag = 0
    L11_2 = L13_2
    L13_2 = L2_1
    L13_2[L7_2] = L11_2
  end
  L13_2 = L11_2.nextTag
  L13_2 = L13_2 + 1
  L11_2.nextTag = L13_2
  L13_2 = L32_1
  L14_2 = L5_2
  L13_2 = L13_2(L14_2)
  L14_2 = FW
  L14_2 = L14_2.GetName
  if L14_2 then
    L14_2 = FW
    L14_2 = L14_2.GetName
    L15_2 = A0_2
    L14_2 = L14_2(L15_2)
    if L14_2 then
      goto lbl_267
    end
  end
  L14_2 = GetPlayerName
  L15_2 = A0_2
  L14_2 = L14_2(L15_2)
  ::lbl_267::
  L15_2 = GetPlayerNumber
  if L15_2 then
    L15_2 = GetPlayerNumber
    L16_2 = A0_2
    L15_2 = L15_2(L16_2)
    if L15_2 then
      goto lbl_276
    end
  end
  L15_2 = nil
  ::lbl_276::
  L16_2 = L3_1
  L17_2 = {}
  L17_2.key = L7_2
  L18_2 = L11_2.nextTag
  L17_2.tag = L18_2
  L17_2.name = L14_2
  L17_2.num = L15_2
  L18_2 = L3_2.callsign
  if L18_2 and L13_2 then
    L18_2 = L13_2.cs
    if L18_2 then
      goto lbl_293
    end
  end
  L18_2 = nil
  ::lbl_293::
  L17_2.cs = L18_2
  L17_2.talk = false
  L17_2.talkAt = 0
  L18_2 = os
  L18_2 = L18_2.time
  L18_2 = L18_2()
  L17_2.at = L18_2
  L16_2[A0_2] = L17_2
  L16_2 = L11_2.members
  L17_2 = L11_2.nextTag
  L16_2[A0_2] = L17_2
  L16_2 = L11_2.n
  L16_2 = L16_2 + 1
  L11_2.n = L16_2
  if L13_2 then
    L13_2.last = L6_2
  end
  L16_2 = L41_1
  L17_2 = A0_2
  L18_2 = L11_2
  L19_2 = L4_2
  L20_2 = L3_2
  L16_2(L17_2, L18_2, L19_2, L20_2)
  L16_2 = L43_1
  L17_2 = A0_2
  L18_2 = L3_2
  L16_2 = L16_2(L17_2, L18_2)
  L17_2 = L36_1
  L18_2 = L11_2
  L19_2 = L3_2
  L17_2 = L17_2(L18_2, L19_2)
  L16_2.members = L17_2
  L18_2 = Push
  L19_2 = A0_2
  L20_2 = "radio:joined"
  L21_2 = L16_2
  L18_2(L19_2, L20_2, L21_2)
  L18_2 = L3_2.notifyJoin
  if L18_2 then
    L18_2 = L37_1
    L19_2 = L11_2
    L20_2 = "radio:event"
    L21_2 = {}
    L21_2.key = L7_2
    L21_2.kind = "join"
    L22_2 = L3_2.mode
    if "names" ~= L22_2 then
      L22_2 = L3_2.mode
      if "numbers" ~= L22_2 then
        goto lbl_354
      end
    end
    L22_2 = L35_1
    L23_2 = L3_1
    L23_2 = L23_2[A0_2]
    L24_2 = L3_2.mode
    L22_2 = L22_2(L23_2, L24_2)
    ::lbl_354::
    if not L22_2 then
      L22_2 = nil
    end
    L21_2.label = L22_2
    L22_2 = A0_2
    L18_2(L19_2, L20_2, L21_2, L22_2)
  end
  L18_2 = L37_1
  L19_2 = L11_2
  L20_2 = "radio:members"
  L21_2 = L17_2
  L22_2 = A0_2
  L18_2(L19_2, L20_2, L21_2, L22_2)
  L18_2 = L6_1
  L19_2 = "%s joined %s (channel %s, %s, %d members)"
  L20_2 = A0_2
  L21_2 = L8_2
  L22_2 = L11_2.ch
  L23_2 = L4_2
  L24_2 = L11_2.n
  L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  L18_2 = {}
  L18_2.ok = true
  L18_2.joined = L16_2
  L18_2.members = L17_2
  return L18_2
end
RadioJoin = L45_1
function L45_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L9_1
  L2_2 = L2_2()
  L2_2 = L2_2.restricted
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = {}
  L4_2 = nil
  L5_2 = ipairs
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L10_1
      L12_2 = L10_2.from
      L13_2 = nil
      L11_2 = L11_2(L12_2, L13_2)
      if L11_2 then
        L11_2 = L10_1
        L12_2 = L10_2.to
        L13_2 = nil
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          if not L4_2 then
            L11_2 = L24_1
            L12_2 = A0_2
            L11_2 = L11_2(L12_2)
            L4_2 = L11_2
          end
          L11_2 = #L3_2
          L11_2 = L11_2 + 1
          L12_2 = {}
          L13_2 = L10_1
          L14_2 = L10_2.from
          L15_2 = 0
          L13_2 = L13_2(L14_2, L15_2)
          L12_2.from = L13_2
          L13_2 = L10_1
          L14_2 = L10_2.to
          L15_2 = 0
          L13_2 = L13_2(L14_2, L15_2)
          L12_2.to = L13_2
          L13_2 = type
          L14_2 = L10_2.label
          L13_2 = L13_2(L14_2)
          if "string" == L13_2 then
            L13_2 = L10_2.label
            if L13_2 then
              goto lbl_66
            end
          end
          L13_2 = false
          ::lbl_66::
          L12_2.label = L13_2
          L13_2 = L26_1
          L14_2 = A0_2
          L15_2 = L10_2
          L16_2 = L4_2
          L13_2 = L13_2(L14_2, L15_2, L16_2)
          L12_2.allowed = L13_2
          L3_2[L11_2] = L12_2
        end
      end
    end
  end
  return L3_2
end
L46_1 = RPC
function L47_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = L15_1
  L1_2 = L1_2()
  L2_2 = L20_1
  L2_2 = L2_2()
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_1
  L4_2 = L4_2[A0_2]
  L5_2 = L4_2 or L5_2
  if L4_2 then
    L6_2 = L4_2.key
    L5_2 = L2_1
    L5_2 = L5_2[L6_2]
  end
  L6_2 = {}
  if L5_2 then
    L7_2 = pairs
    L8_2 = L5_2.members
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = L3_1
      L13_2 = L13_2[L11_2]
      if L13_2 then
        L14_2 = L13_2.talk
        if L14_2 then
          L14_2 = #L6_2
          L14_2 = L14_2 + 1
          L6_2[L14_2] = L12_2
        end
      end
    end
  end
  L7_2 = L9_1
  L7_2 = L7_2()
  L8_2 = {}
  L9_2 = L27_1
  L9_2 = L9_2()
  L9_2 = not L9_2
  L8_2.enabled = L9_2
  L9_2 = "none" ~= L2_2
  L8_2.supported = L9_2
  L8_2.provider = L2_2
  L9_2 = {}
  L10_2 = L1_2.min
  L9_2.min = L10_2
  L10_2 = L1_2.max
  L9_2.max = L10_2
  L10_2 = L1_2.step
  L9_2.step = L10_2
  L10_2 = L1_2.dec
  L9_2.dec = L10_2
  L10_2 = L1_2.mode
  L9_2.mode = L10_2
  L10_2 = L1_2.private
  L9_2.private = L10_2
  L10_2 = L1_2.callsign
  L9_2.callsign = L10_2
  L10_2 = L1_2.maxPresets
  L9_2.maxPresets = L10_2
  L10_2 = L1_2.maxMembers
  L9_2.maxMembers = L10_2
  L10_2 = L1_2.earbuds
  L9_2.earbuds = L10_2
  L10_2 = L1_2.itemLabel
  if not L10_2 then
    L10_2 = false
  end
  L9_2.item = L10_2
  L10_2 = L22_1
  L11_2 = L7_2.defaultFreq
  L12_2 = L1_2
  L10_2 = L10_2(L11_2, L12_2)
  if not L10_2 then
    L10_2 = L1_2.min
  end
  L9_2.defFreq = L10_2
  L10_2 = L1_2.defVol
  L9_2.defVol = L10_2
  L10_2 = L7_2.keepOnWhenPhoneClosed
  L10_2 = false ~= L10_2
  L9_2.keepOnClose = L10_2
  L10_2 = L7_2.disableWhenDead
  L10_2 = false ~= L10_2
  L9_2.dead = L10_2
  L10_2 = L7_2.allowInVehicle
  L10_2 = false ~= L10_2
  L9_2.vehicle = L10_2
  L10_2 = L7_2.disableInWater
  L10_2 = true == L10_2
  L9_2.water = L10_2
  L10_2 = L7_2.preinstalled
  L10_2 = false ~= L10_2
  L9_2.preinstalled = L10_2
  L10_2 = L1_2.talkMode
  L9_2.talkMode = L10_2
  L10_2 = L1_2.allowPlayer
  L9_2.playerMode = L10_2
  L10_2 = L1_2.playerModes
  L9_2.modes = L10_2
  L10_2 = L1_2.maxTalk
  L9_2.maxTalk = L10_2
  L10_2 = type
  L11_2 = L7_2.sounds
  L10_2 = L10_2(L11_2)
  if "table" == L10_2 then
    L10_2 = {}
    L11_2 = L7_2.sounds
    L11_2 = L11_2.enabled
    L11_2 = false ~= L11_2
    L10_2.on = L11_2
    L11_2 = L10_1
    L12_2 = L7_2.sounds
    L12_2 = L12_2.volume
    L13_2 = 0.6
    L11_2 = L11_2(L12_2, L13_2)
    L10_2.vol = L11_2
    L11_2 = L7_2.sounds
    L11_2 = L11_2.txChirp
    L11_2 = false ~= L11_2
    L10_2.tx = L11_2
    L11_2 = L7_2.sounds
    L11_2 = L11_2.rxSquelch
    L11_2 = false ~= L11_2
    L10_2.rx = L11_2
    if L10_2 then
      goto lbl_168
    end
  end
  L10_2 = {}
  L10_2.on = true
  L10_2.vol = 0.6
  L10_2.tx = true
  L10_2.rx = true
  ::lbl_168::
  L9_2.sounds = L10_2
  L8_2.cfg = L9_2
  L9_2 = L45_1
  L10_2 = A0_2
  L11_2 = L1_2
  L9_2 = L9_2(L10_2, L11_2)
  L8_2.zones = L9_2
  if L5_2 then
    L9_2 = L43_1
    L10_2 = A0_2
    L11_2 = L1_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      goto lbl_184
    end
  end
  L9_2 = false
  ::lbl_184::
  L8_2.joined = L9_2
  if L5_2 then
    L9_2 = L36_1
    L10_2 = L5_2
    L11_2 = L1_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      goto lbl_194
    end
  end
  L9_2 = false
  ::lbl_194::
  L8_2.members = L9_2
  L8_2.talkers = L6_2
  if L3_2 then
    L9_2 = L32_1
    L10_2 = L3_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_204
    end
  end
  L9_2 = false
  ::lbl_204::
  L8_2.prefs = L9_2
  L9_2 = L28_1
  L10_2 = A0_2
  L9_2 = L9_2(L10_2)
  L8_2.earbuds = L9_2
  L9_2 = L1_2.item
  L9_2 = L29_1
  L10_2 = A0_2
  L11_2 = L1_2.item
  L9_2 = nil == L9_2 or L9_2
  L8_2.hasItem = L9_2
  return L8_2
end
L46_1["radio.state"] = L47_1
L46_1 = RPC
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = {}
    L2_2.error = "invalid"
    return L2_2
  end
  L2_2 = RadioJoin
  L3_2 = A0_2
  L4_2 = A1_2.freq
  L5_2 = {}
  L6_2 = A1_2.pass
  L5_2.pass = L6_2
  return L2_2(L3_2, L4_2, L5_2)
end
L46_1["radio.join"] = L47_1
L46_1 = {}
L46_1.user = true
L46_1.dead = true
L46_1.vehicle = true
L46_1.water = true
L46_1.closed = true
L46_1.earbuds = true
L47_1 = RPC
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A1_2.reason
    if L2_2 then
      goto lbl_10
    end
  end
  L2_2 = nil
  ::lbl_10::
  L3_2 = L46_1
  L3_2 = L3_2[L2_2]
  if not L3_2 then
    L2_2 = "user"
  end
  L3_2 = RadioLeave
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2(L4_2, L5_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L47_1["radio.leave"] = L48_1
L47_1 = RPC
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = {}
    L2_2.error = "invalid"
    return L2_2
  end
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L15_1
  L3_2 = L3_2()
  L4_2 = L32_1
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L31_1
    L5_2 = nil
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
  end
  L5_2 = {}
  L6_2 = L4_2.presets
  L5_2.presets = L6_2
  L6_2 = L4_2.vol
  L5_2.vol = L6_2
  L6_2 = L4_2.cs
  L5_2.cs = L6_2
  L6_2 = L4_2.last
  L5_2.last = L6_2
  L6_2 = L4_2.mode
  L5_2.mode = L6_2
  L6_2 = A1_2.presets
  if nil ~= L6_2 then
    L6_2 = A1_2.presets
    L5_2.presets = L6_2
  end
  L6_2 = A1_2.vol
  if nil ~= L6_2 then
    L6_2 = A1_2.vol
    L5_2.vol = L6_2
  end
  L6_2 = A1_2.cs
  if nil ~= L6_2 then
    L6_2 = A1_2.cs
    L5_2.cs = L6_2
  end
  L6_2 = A1_2.last
  if nil ~= L6_2 then
    L6_2 = A1_2.last
    L5_2.last = L6_2
  end
  L6_2 = A1_2.mode
  if nil ~= L6_2 then
    L6_2 = A1_2.mode
    L5_2.mode = L6_2
  end
  L6_2 = L31_1
  L7_2 = L5_2
  L8_2 = L3_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L33_1
  L8_2 = L2_2
  L9_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = {}
    L7_2.error = "db"
    return L7_2
  end
  L7_2 = L3_1
  L7_2 = L7_2[A0_2]
  if L7_2 then
    L8_2 = A1_2.cs
    if nil ~= L8_2 then
      L8_2 = L3_2.callsign
      if L8_2 then
        L8_2 = L6_2.cs
        if L8_2 then
          goto lbl_95
        end
      end
      L8_2 = nil
      ::lbl_95::
      L7_2.cs = L8_2
      L9_2 = L7_2.key
      L8_2 = L2_1
      L8_2 = L8_2[L9_2]
      if L8_2 then
        L9_2 = L38_1
        L10_2 = L8_2
        L11_2 = L3_2
        L9_2(L10_2, L11_2)
      end
    end
  end
  L8_2 = {}
  L8_2.ok = true
  L8_2.prefs = L6_2
  return L8_2
end
L47_1["radio.prefs"] = L48_1
L47_1 = 120
function L48_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  A1_2.talk = A2_2
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  A1_2.talkAt = L3_2
  L3_2 = L15_1
  L3_2 = L3_2()
  if A2_2 then
    L4_2 = L34_1
    L5_2 = A0_2
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
  end
  L4_2 = "open" == L4_2 or L4_2
  A1_2.open = L4_2
  L5_2 = A1_2.key
  L4_2 = L2_1
  L4_2 = L4_2[L5_2]
  if not L4_2 then
    return
  end
  L5_2 = L37_1
  L6_2 = L4_2
  L7_2 = "radio:talk"
  L8_2 = {}
  L9_2 = L4_2.key
  L8_2.key = L9_2
  L9_2 = A1_2.tag
  L8_2.tag = L9_2
  L8_2.on = A2_2
  L9_2 = A1_2.open
  L8_2.open = L9_2
  L9_2 = L3_2.mode
  if "names" ~= L9_2 then
    L9_2 = L3_2.mode
    if "numbers" ~= L9_2 then
      goto lbl_50
    end
  end
  L9_2 = L35_1
  L10_2 = A1_2
  L11_2 = L3_2.mode
  L9_2 = L9_2(L10_2, L11_2)
  ::lbl_50::
  if not L9_2 then
    L9_2 = nil
  end
  L8_2.label = L9_2
  L5_2(L6_2, L7_2, L8_2)
end
L49_1 = RegisterNetEvent
L50_1 = "apex_phone:server:radioTalk"
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = source
  L2_2 = L3_1
  L2_2 = L2_2[L1_2]
  if not L2_2 then
    return
  end
  A0_2 = true == A0_2
  L2_2.want = A0_2
  L3_2 = L2_2.talk
  if L3_2 == A0_2 then
    return
  end
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  if A0_2 then
    L4_2 = L2_2.talkAt
    if not L4_2 then
      L4_2 = 0
    end
    L4_2 = L3_2 - L4_2
    L5_2 = L47_1
    if L4_2 < L5_2 then
      L4_2 = L2_2.deferred
      if not L4_2 then
        L2_2.deferred = true
        L4_2 = SetTimeout
        L5_2 = L47_1
        L6_2 = L2_2.talkAt
        if not L6_2 then
          L6_2 = 0
        end
        L6_2 = L3_2 - L6_2
        L5_2 = L5_2 - L6_2
        function L6_2()
          local L0_3, L1_3, L2_3, L3_3
          L2_2.deferred = false
          L1_3 = L1_2
          L0_3 = L3_1
          L0_3 = L0_3[L1_3]
          L1_3 = L2_2
          if L0_3 == L1_3 then
            L0_3 = L2_2.want
            if true == L0_3 then
              L0_3 = L2_2.talk
              if not L0_3 then
                goto lbl_15
              end
            end
          end
          do return end
          ::lbl_15::
          L0_3 = RateLimitAllow
          if L0_3 then
            L0_3 = RateLimitAllow
            L1_3 = L1_2
            L2_3 = "event.radioTalk"
            L0_3 = L0_3(L1_3, L2_3)
            if not L0_3 then
              return
            end
          end
          L0_3 = L48_1
          L1_3 = L1_2
          L2_3 = L2_2
          L3_3 = true
          L0_3(L1_3, L2_3, L3_3)
        end
        L4_2(L5_2, L6_2)
      end
      return
    end
  end
  if A0_2 then
    L4_2 = RateLimitAllow
    if L4_2 then
      L4_2 = RateLimitAllow
      L5_2 = L1_2
      L6_2 = "event.radioTalk"
      L4_2 = L4_2(L5_2, L6_2)
      if not L4_2 then
        return
      end
    end
  end
  L4_2 = L48_1
  L5_2 = L1_2
  L6_2 = L2_2
  L7_2 = A0_2
  L4_2(L5_2, L6_2, L7_2)
end
L49_1(L50_1, L51_1)
L49_1 = 5
function L50_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L3_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = L6_2
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = RadioLeave
    L9_2 = L7_2
    L10_2 = A0_2
    L8_2(L9_2, L10_2)
  end
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = next
  L2_2 = L3_1
  L1_2 = L1_2(L2_2)
  if nil == L1_2 then
    return
  end
  L1_2 = L27_1
  L1_2 = L1_2()
  if L1_2 then
    L1_2 = L50_1
    L2_2 = "disabled"
    return L1_2(L2_2)
  end
  L1_2 = L20_1
  L1_2 = L1_2()
  if "none" == L1_2 then
    L1_2 = L50_1
    L2_2 = "novoice"
    return L1_2(L2_2)
  end
  L1_2 = L15_1
  L1_2 = L1_2()
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = {}
  L4_2 = pairs
  L5_2 = L3_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    L9_2 = #L3_2
    L9_2 = L9_2 + 1
    L3_2[L9_2] = L8_2
  end
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L3_1
    L10_2 = L10_2[L9_2]
    if L10_2 then
      L11_2 = GetPlayerName
      L12_2 = L9_2
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = L44_1
        L12_2 = L9_2
        L13_2 = "dropped"
        L14_2 = true
        L11_2(L12_2, L13_2, L14_2)
      else
        L11_2 = L1_2.earbuds
        if L11_2 then
          L11_2 = L28_1
          L12_2 = L9_2
          L11_2 = L11_2(L12_2)
          if not L11_2 then
            L11_2 = RadioLeave
            L12_2 = L9_2
            L13_2 = "earbuds"
            L11_2(L12_2, L13_2)
        end
        else
          L11_2 = L49_1
          L11_2 = A0_2 % L11_2
          L12_2 = L49_1
          L12_2 = L9_2 % L12_2
          if L11_2 == L12_2 then
            L11_2 = HasPhoneItem
            if L11_2 then
              L11_2 = HasPhoneItem
              L12_2 = L9_2
              L11_2 = L11_2(L12_2)
              if not L11_2 then
                L11_2 = RadioLeave
                L12_2 = L9_2
                L13_2 = "nophone"
                L11_2(L12_2, L13_2)
            end
          end
          else
            L11_2 = L49_1
            L11_2 = A0_2 % L11_2
            L12_2 = L49_1
            L12_2 = L9_2 % L12_2
            if L11_2 == L12_2 then
              L11_2 = L1_2.item
              if L11_2 then
                L11_2 = L29_1
                L12_2 = L9_2
                L13_2 = L1_2.item
                L11_2 = L11_2(L12_2, L13_2)
                if not L11_2 then
                  L11_2 = RadioLeave
                  L12_2 = L9_2
                  L13_2 = "item"
                  L11_2(L12_2, L13_2)
              end
            end
            else
              L11_2 = L10_2.talk
              if L11_2 then
                L11_2 = L1_2.maxTalk
                if L11_2 > 0 then
                  L11_2 = L10_2.talkAt
                  if not L11_2 then
                    L11_2 = L2_2
                  end
                  L11_2 = L2_2 - L11_2
                  L12_2 = L1_2.maxTalk
                  L12_2 = L12_2 + 5
                  L12_2 = L12_2 * 1000
                  if L11_2 > L12_2 then
                    L11_2 = L34_1
                    L12_2 = L9_2
                    L13_2 = L1_2
                    L11_2 = L11_2(L12_2, L13_2)
                    if "open" ~= L11_2 then
                      L10_2.talk = false
                      L12_2 = L10_2.key
                      L11_2 = L2_1
                      L11_2 = L11_2[L12_2]
                      if L11_2 then
                        L12_2 = L37_1
                        L13_2 = L11_2
                        L14_2 = "radio:talk"
                        L15_2 = {}
                        L16_2 = L11_2.key
                        L15_2.key = L16_2
                        L16_2 = L10_2.tag
                        L15_2.tag = L16_2
                        L15_2.on = false
                        L12_2(L13_2, L14_2, L15_2)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
RadioSweep = L51_1
L51_1 = CreateThread
function L52_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = 0
  while true do
    L1_2 = Wait
    L2_2 = 1000
    L1_2(L2_2)
    L0_2 = L0_2 + 1
    L1_2 = pcall
    L2_2 = RadioSweep
    L3_2 = L0_2
    L1_2, L2_2 = L1_2(L2_2, L3_2)
    if not L1_2 then
      L3_2 = print
      L4_2 = "^1[unique_phone]^0 radio: watchdog failed: %s"
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = tostring
      L7_2 = L2_2
      L6_2, L7_2 = L6_2(L7_2)
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
      L3_2(L4_2, L5_2, L6_2, L7_2)
    end
  end
end
L51_1(L52_1)
L51_1 = FW
if L51_1 then
  L51_1 = FW
  L51_1 = L51_1.OnJobUpdate
  if L51_1 then
    L51_1 = FW
    L51_1 = L51_1.OnJobUpdate
    function L52_1(A0_2)
      local L1_2, L2_2, L3_2
      L1_2 = tonumber
      L2_2 = A0_2
      L1_2 = L1_2(L2_2)
      A0_2 = L1_2
      if A0_2 then
        L1_2 = L3_1
        L1_2 = L1_2[A0_2]
        if L1_2 then
          goto lbl_12
        end
      end
      do return end
      ::lbl_12::
      L1_2 = SetTimeout
      L2_2 = 500
      function L3_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
        L1_3 = A0_2
        L0_3 = L3_1
        L0_3 = L0_3[L1_3]
        L1_3 = L0_3 or L1_3
        if L0_3 then
          L2_3 = L0_3.key
          L1_3 = L2_1
          L1_3 = L1_3[L2_3]
        end
        if L1_3 then
          L2_3 = L1_3.zone
          if L2_3 then
            goto lbl_15
          end
        end
        do return end
        ::lbl_15::
        L2_3 = L25_1
        L3_3 = L1_3.freq
        L2_3 = L2_3(L3_3)
        if L2_3 then
          L3_3 = L26_1
          L4_3 = A0_2
          L5_3 = L2_3
          L3_3 = L3_3(L4_3, L5_3)
          if not L3_3 then
            L3_3 = RadioLeave
            L4_3 = A0_2
            L5_3 = "restricted"
            L3_3(L4_3, L5_3)
          end
        end
      end
      L1_2(L2_2, L3_2)
    end
    L51_1(L52_1)
  end
end
L51_1 = FW
if L51_1 then
  L51_1 = FW
  L51_1 = L51_1.OnPlayerDropped
  if L51_1 then
    L51_1 = FW
    L51_1 = L51_1.OnPlayerDropped
    function L52_1(A0_2)
      local L1_2, L2_2, L3_2
      L1_2 = tonumber
      L2_2 = A0_2
      L1_2 = L1_2(L2_2)
      A0_2 = L1_2
      if A0_2 then
        L1_2 = L3_1
        L1_2 = L1_2[A0_2]
        if L1_2 then
          goto lbl_12
        end
      end
      do return end
      ::lbl_12::
      L1_2 = SetTimeout
      L2_2 = 100
      function L3_2()
        local L0_3, L1_3, L2_3, L3_3
        L1_3 = A0_2
        L0_3 = L3_1
        L0_3 = L0_3[L1_3]
        if not L0_3 then
          return
        end
        L0_3 = GetPlayerName
        L1_3 = A0_2
        L0_3 = L0_3(L1_3)
        if L0_3 then
          L0_3 = RadioLeave
          L1_3 = A0_2
          L2_3 = "logout"
          L0_3(L1_3, L2_3)
        else
          L0_3 = L44_1
          L1_3 = A0_2
          L2_3 = "dropped"
          L3_3 = true
          L0_3(L1_3, L2_3, L3_3)
        end
      end
      L1_2(L2_2, L3_2)
    end
    L51_1(L52_1)
  end
end
L51_1 = AddEventHandler
L52_1 = "playerDropped"
function L53_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L44_1
    L2_2 = L0_2
    L3_2 = "dropped"
    L4_2 = true
    L1_2(L2_2, L3_2, L4_2)
  end
end
L51_1(L52_1, L53_1)
L51_1 = AddEventHandler
L52_1 = "onResourceStart"
function L53_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L18_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  if "pma-voice" == A0_2 then
    L1_2 = {}
    L5_1 = L1_2
  end
  L1_2 = SetTimeout
  L2_2 = 2500
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3
    L0_3 = next
    L1_3 = L3_1
    L0_3 = L0_3(L1_3)
    if nil == L0_3 then
      return
    end
    L0_3 = L20_1
    L0_3 = L0_3()
    L1_3 = L15_1
    L1_3 = L1_3()
    L2_3 = pairs
    L3_3 = L3_1
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L9_3 = L7_3.key
      L8_3 = L2_1
      L8_3 = L8_3[L9_3]
      if L8_3 then
        L8_3.provider = L0_3
        L9_3 = L41_1
        L10_3 = L6_3
        L11_3 = L8_3
        L12_3 = L0_3
        L13_3 = L1_3
        L9_3(L10_3, L11_3, L12_3, L13_3)
        L9_3 = L43_1
        L10_3 = L6_3
        L11_3 = L1_3
        L9_3 = L9_3(L10_3, L11_3)
        L10_3 = L36_1
        L11_3 = L8_3
        L12_3 = L1_3
        L10_3 = L10_3(L11_3, L12_3)
        L9_3.members = L10_3
        L10_3 = Push
        L11_3 = L6_3
        L12_3 = "radio:joined"
        L13_3 = L9_3
        L10_3(L11_3, L12_3, L13_3)
      end
    end
  end
  L1_2(L2_2, L3_2)
end
L51_1(L52_1, L53_1)
L51_1 = AddEventHandler
L52_1 = "onResourceStop"
function L53_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L3_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L8_2 = L6_2.key
    L7_2 = L2_1
    L7_2 = L7_2[L8_2]
    if L7_2 then
      L8_2 = GetPlayerName
      L9_2 = L5_2
      L8_2 = L8_2(L9_2)
      if L8_2 then
        L8_2 = L42_1
        L9_2 = L5_2
        L10_2 = L7_2
        L11_2 = L7_2.provider
        L8_2(L9_2, L10_2, L11_2)
      end
    end
  end
end
L51_1(L52_1, L53_1)
L51_1 = exports
L52_1 = "GetRadioChannel"
function L53_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = -1
  end
  L2_2 = L3_1
  L1_2 = L2_2[L1_2]
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L3_2 = L1_2.key
    L2_2 = L2_1
    L2_2 = L2_2[L3_2]
  end
  if L2_2 then
    L3_2 = L2_2.freq
    if L3_2 then
      goto lbl_20
    end
  end
  L3_2 = nil
  ::lbl_20::
  return L3_2
end
L51_1(L52_1, L53_1)
L51_1 = exports
L52_1 = "SetRadioChannel"
function L53_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  if not A0_2 then
    L3_2 = false
    L4_2 = "noplayer"
    return L3_2, L4_2
  end
  if not A1_2 or 0 == A1_2 or false == A1_2 then
    L3_2 = RadioLeave
    L4_2 = A0_2
    L5_2 = "external"
    L3_2 = L3_2(L4_2, L5_2)
    L4_2 = nil
    return L3_2, L4_2
  end
  L3_2 = RadioJoin
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = {}
  L6_2.pass = A2_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2.ok
  L4_2 = true == L4_2
  L5_2 = L3_2.error
  return L4_2, L5_2
end
L51_1(L52_1, L53_1)
L51_1 = exports
L52_1 = "GetChannelMembers"
function L53_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L15_1
  L1_2 = L1_2()
  L2_2 = L22_1
  L3_2 = A0_2
  L4_2 = L1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  L4_2 = L3_2 or L4_2
  if L3_2 then
    L4_2 = L2_1
    L4_2 = L4_2[L3_2]
  end
  L5_2 = {}
  if L4_2 then
    L6_2 = pairs
    L7_2 = L4_2.members
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2 in L6_2, L7_2, L8_2, L9_2 do
      L11_2 = #L5_2
      L11_2 = L11_2 + 1
      L5_2[L11_2] = L10_2
    end
  end
  L6_2 = table
  L6_2 = L6_2.sort
  L7_2 = L5_2
  L6_2(L7_2)
  return L5_2
end
L51_1(L52_1, L53_1)
