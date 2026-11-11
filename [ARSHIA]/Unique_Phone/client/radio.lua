local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1
L0_1 = nil
L1_1 = {}
L2_1 = false
L3_1 = false
L4_1 = false
L5_1 = false
L6_1 = 0
L7_1 = 0
L8_1 = 0
L9_1 = nil
L10_1 = false
L11_1 = false
L12_1 = false
L13_1 = nil
L14_1 = nil
L15_1 = {}
L15_1.n = 0
L15_1.at = 0
L16_1 = 0
L17_1 = 300
function L18_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
function L19_1()
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
function L20_1()
  local L0_2, L1_2, L2_2
  L0_2 = L19_1
  L0_2 = L0_2()
  L0_2 = L0_2.voice
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L1_2 = L0_2 or L1_2
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
  end
  return L1_2
end
function L21_1(A0_2, ...)
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
function L22_1(A0_2, A1_2, ...)
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
    L5_2 = L21_1
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
L23_1 = {}
L23_1.ptt = true
L23_1.toggle = true
L23_1.open = true
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L23_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L19_1
  L1_2 = L1_2()
  L1_2 = L1_2.playerModes
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = next
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if nil ~= L2_2 then
      goto lbl_22
    end
  end
  L2_2 = true
  do return L2_2 end
  ::lbl_22::
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    if L7_2 == A0_2 then
      L8_2 = true
      return L8_2
    end
  end
  L2_2 = false
  return L2_2
end
function L25_1()
  local L0_2, L1_2, L2_2
  L0_2 = L19_1
  L0_2 = L0_2()
  L1_2 = L0_2.allowPlayerMode
  if true == L1_2 then
    L1_2 = L13_1
    if L1_2 then
      L1_2 = L24_1
      L2_2 = L13_1
      L1_2 = L1_2(L2_2)
      if L1_2 then
        L1_2 = L13_1
        return L1_2
      end
    end
  end
  L2_2 = L0_2.talkMode
  L1_2 = L23_1
  L1_2 = L1_2[L2_2]
  if L1_2 then
    L1_2 = L0_2.talkMode
    if L1_2 then
      goto lbl_25
    end
  end
  L1_2 = "ptt"
  ::lbl_25::
  return L1_2
end
function L26_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = Push
  L1_2 = "radio:mode"
  L2_2 = {}
  L3_2 = L25_1
  L3_2 = L3_2()
  L2_2.mode = L3_2
  L3_2 = L3_1
  L2_2.muted = L3_2
  L3_2 = L2_1
  L2_2.latched = L3_2
  L0_2(L1_2, L2_2)
end
L27_1 = false
L28_1 = AddEventHandler
L29_1 = "esx:onPlayerDeath"
function L30_1()
  local L0_2, L1_2
  L0_2 = true
  L27_1 = L0_2
end
L28_1(L29_1, L30_1)
L28_1 = AddEventHandler
L29_1 = "esx:onPlayerSpawn"
function L30_1()
  local L0_2, L1_2
  L0_2 = false
  L27_1 = L0_2
end
L28_1(L29_1, L30_1)
function L28_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  if 0 ~= L0_2 then
    L1_2 = L18_1
    L2_2 = IsEntityDead
    L3_2 = L0_2
    L2_2, L3_2, L4_2 = L2_2(L3_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if not L1_2 then
      L1_2 = L18_1
      L2_2 = IsPedDeadOrDying
      L3_2 = L0_2
      L4_2 = true
      L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      if not L1_2 then
        goto lbl_22
      end
    end
    L1_2 = true
    return L1_2
  end
  ::lbl_22::
  L1_2 = LocalPlayer
  L1_2 = L1_2.state
  L1_2 = L1_2.isDead
  if true == L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = L27_1
  if L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = FW
  if L1_2 then
    L1_2 = FW
    L1_2 = L1_2.name
    if "qb" ~= L1_2 then
      L1_2 = FW
      L1_2 = L1_2.name
      if "qbx" ~= L1_2 then
        goto lbl_63
      end
    end
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3, L2_3
      L0_3 = nil
      L1_3 = FW
      L1_3 = L1_3.name
      if "qbx" == L1_3 then
        L1_3 = exports
        L1_3 = L1_3.qbx_core
        L2_3 = L1_3
        L1_3 = L1_3.GetPlayerData
        L1_3 = L1_3(L2_3)
        L0_3 = L1_3
      end
      if not L0_3 then
        L1_3 = FW
        L1_3 = L1_3.GetCore
        L1_3 = L1_3()
        L0_3 = L1_3
        if L1_3 then
          L2_3 = L1_3.Functions
          L2_3 = L2_3.GetPlayerData
          L2_3 = L2_3()
          L0_3 = L2_3
        end
      end
      L1_3 = L0_3
      if L0_3 then
        L1_3 = L0_3.metadata
      end
      return L1_3
    end
    L1_2, L2_2 = L1_2(L2_2)
    if L1_2 then
      L3_2 = type
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        L3_2 = L2_2.isdead
        if not L3_2 then
          L3_2 = L2_2.inlaststand
          if not L3_2 then
            goto lbl_63
          end
        end
        L3_2 = true
        return L3_2
      end
    end
  end
  ::lbl_63::
  L1_2 = false
  return L1_2
end
function L29_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = type
  L1_2 = AirPodsWorn
  L0_2 = L0_2(L1_2)
  if "function" == L0_2 then
    L0_2 = pcall
    L1_2 = AirPodsWorn
    L0_2, L1_2 = L0_2(L1_2)
    L2_2 = L0_2 or L2_2
    L2_2 = L0_2 and true == L1_2
    return L2_2
  end
  L0_2 = GlobalState
  L1_2 = "apex_phone:airpods:"
  L2_2 = GetPlayerServerId
  L3_2 = PlayerId
  L3_2 = L3_2()
  L2_2 = L2_2(L3_2)
  L1_2 = L1_2 .. L2_2
  L0_2 = L0_2[L1_2]
  L0_2 = nil ~= L0_2
  return L0_2
end
function L30_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L19_1
  L0_2 = L0_2()
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  L2_2 = L0_2.disableWhenDead
  if false ~= L2_2 then
    L2_2 = L28_1
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = "dead"
      return L2_2
    end
  end
  L2_2 = L0_2.allowInVehicle
  if false == L2_2 then
    L2_2 = L18_1
    L3_2 = IsPedInAnyVehicle
    L4_2 = L1_2
    L5_2 = false
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      L2_2 = "vehicle"
      return L2_2
    end
  end
  L2_2 = L0_2.disableInWater
  if true == L2_2 then
    L2_2 = L18_1
    L3_2 = IsPedSwimming
    L4_2 = L1_2
    L3_2, L4_2, L5_2 = L3_2(L4_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if not L2_2 then
      L2_2 = L18_1
      L3_2 = IsPedSwimmingUnderWater
      L4_2 = L1_2
      L3_2, L4_2, L5_2 = L3_2(L4_2)
      L2_2 = L2_2(L3_2, L4_2, L5_2)
      if not L2_2 then
        goto lbl_46
      end
    end
    L2_2 = "water"
    return L2_2
  end
  ::lbl_46::
  L2_2 = L0_2.requireEarbuds
  if true == L2_2 then
    L2_2 = L29_1
    L2_2 = L2_2()
    if not L2_2 then
      L2_2 = "earbuds"
      return L2_2
    end
  end
  L2_2 = nil
  return L2_2
end
function L31_1()
  local L0_2, L1_2, L2_2
  L0_2 = L19_1
  L0_2 = L0_2()
  L0_2 = L0_2.animation
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L1_2 = L0_2 or L1_2
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
  end
  return L1_2
end
function L32_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L31_1
  L0_2 = L0_2()
  L1_2 = L0_2.enabled
  if false ~= L1_2 then
    L1_2 = L0_1
    if L1_2 then
      goto lbl_11
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_11::
  L1_2 = PhoneOpen
  if L1_2 then
    L1_2 = L0_2.whenPhoneOpen
    if true ~= L1_2 then
      L1_2 = false
      return L1_2
    end
  end
  L1_2 = L25_1
  L1_2 = L1_2()
  if "open" == L1_2 then
    L1_2 = L0_2.openMic
    if true ~= L1_2 then
      L1_2 = false
      return L1_2
    end
  end
  L1_2 = L0_1.provider
  if "pma-voice" == L1_2 then
    L1_2 = GetConvarInt
    L2_2 = "voice_enableRadioAnim"
    L3_2 = 0
    L1_2 = L1_2(L2_2, L3_2)
    if 1 == L1_2 then
      L1_2 = false
      return L1_2
    end
  end
  L1_2 = L0_2.inVehicle
  if false == L1_2 then
    L1_2 = L18_1
    L2_2 = IsPedInAnyVehicle
    L3_2 = PlayerPedId
    L3_2 = L3_2()
    L4_2 = false
    L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      L1_2 = false
      return L1_2
    end
  end
  L1_2 = true
  return L1_2
end
function L33_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L9_1
  L1_2 = nil
  L9_1 = L1_2
  if L0_2 then
    L1_2 = StopAnimTask
    L2_2 = PlayerPedId
    L2_2 = L2_2()
    L3_2 = L0_2.dict
    L4_2 = L0_2.clip
    L5_2 = -4.0
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
end
function L34_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L9_1
  if not L0_2 then
    L0_2 = L32_1
    L0_2 = L0_2()
    if L0_2 then
      goto lbl_9
    end
  end
  do return end
  ::lbl_9::
  L0_2 = L31_1
  L0_2 = L0_2()
  L1_2 = L0_2.dict
  if not L1_2 then
    L1_2 = "random@arrests"
  end
  L2_2 = L0_2.clip
  if not L2_2 then
    L2_2 = "generic_radio_chatter"
  end
  L3_2 = {}
  L3_2.dict = L1_2
  L3_2.clip = L2_2
  L9_1 = L3_2
  L4_2 = CreateThread
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = RequestAnimDict
    L1_3 = L1_2
    L0_3(L1_3)
    L0_3 = GetGameTimer
    L0_3 = L0_3()
    while true do
      L1_3 = L18_1
      L2_3 = HasAnimDictLoaded
      L3_3 = L1_2
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L2_3(L3_3)
      L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
      if L1_3 then
        break
      end
      L1_3 = GetGameTimer
      L1_3 = L1_3()
      L1_3 = L1_3 - L0_3
      L2_3 = 1000
      if not (L1_3 > L2_3) then
        L1_3 = L9_1
        L2_3 = L3_2
        if L1_3 == L2_3 then
          goto lbl_25
        end
      end
      do return end
      ::lbl_25::
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
    L1_3 = L5_1
    if L1_3 then
      L1_3 = L9_1
      L2_3 = L3_2
      if L1_3 == L2_3 then
        goto lbl_40
      end
    end
    L1_3 = RemoveAnimDict
    L2_3 = L1_2
    L1_3(L2_3)
    do return end
    ::lbl_40::
    L1_3 = TaskPlayAnim
    L2_3 = PlayerPedId
    L2_3 = L2_3()
    L3_3 = L1_2
    L4_3 = L2_2
    L5_3 = 8.0
    L6_3 = -8.0
    L7_3 = -1
    L8_3 = math
    L8_3 = L8_3.floor
    L9_3 = tonumber
    L10_3 = L0_2.flag
    L9_3 = L9_3(L10_3)
    if not L9_3 then
      L9_3 = 49
    end
    L8_3 = L8_3(L9_3)
    L9_3 = 0.0
    L10_3 = false
    L11_3 = false
    L12_3 = false
    L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    L1_3 = RemoveAnimDict
    L2_3 = L1_2
    L1_3(L2_3)
  end
  L4_2(L5_2)
end
function L35_1()
  local L0_2, L1_2, L2_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = tonumber
    L1_3 = LocalPlayer
    L1_3 = L1_3.state
    L1_3 = L1_3.radioChannel
    return L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 or nil == L1_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = L0_1
  L2_2 = nil ~= L2_2
  return L2_2
end
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L0_1
  if not L1_2 then
    return
  end
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 0
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 100
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 60
  end
  L5_2 = L5_2(L6_2)
  L3_2 = L3_2(L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2)
  A0_2 = L1_2
  L0_1.vol = A0_2
  L1_2 = L0_1.provider
  if "pma-voice" == L1_2 then
    L1_2 = L22_1
    L2_2 = "pma-voice"
    L3_2 = "setRadioVolume"
    L4_2 = A0_2
    L1_2(L2_2, L3_2, L4_2)
  else
    L1_2 = L0_1.provider
    if "saltychat" == L1_2 then
      L1_2 = L22_1
      L2_2 = "saltychat"
      L3_2 = "SetRadioVolume"
      L4_2 = A0_2 / 100.0
      L1_2(L2_2, L3_2, L4_2)
    else
      L1_2 = L0_1.provider
      if "mumble-voip" == L1_2 then
        L1_2 = L22_1
        L2_2 = "mumble-voip"
        L3_2 = "SetMumbleProperty"
        L4_2 = "radioVolume"
        L5_2 = A0_2 / 100.0
        L1_2(L2_2, L3_2, L4_2, L5_2)
      end
    end
  end
end
function L37_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L0_1
  if not L0_2 then
    return
  end
  L0_2 = L0_1.provider
  if "pma-voice" == L0_2 then
    L0_2 = L22_1
    L1_2 = "pma-voice"
    L2_2 = "setVoiceProperty"
    L3_2 = "radioEnabled"
    L4_2 = true
    L0_2(L1_2, L2_2, L3_2, L4_2)
  else
    L0_2 = L0_1.provider
    if "mumble-voip" == L0_2 then
      L0_2 = L22_1
      L1_2 = "mumble-voip"
      L2_2 = "SetRadioChannel"
      L3_2 = L0_1.ch
      L0_2(L1_2, L2_2, L3_2)
    end
  end
  L0_2 = L36_1
  L1_2 = L0_1.vol
  L0_2(L1_2)
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if A0_2 then
    L1_2 = A0_2.provider
    if "mumble-voip" == L1_2 then
      L1_2 = L22_1
      L2_2 = "mumble-voip"
      L3_2 = "SetRadioChannel"
      L4_2 = 0
      L1_2(L2_2, L3_2, L4_2)
    end
  end
end
function L39_1()
  local L0_2, L1_2
  L0_2 = L11_1
  if L0_2 then
    return
  end
  L0_2 = true
  L11_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = math
    L0_3 = L0_3.floor
    L1_3 = tonumber
    L2_3 = type
    L3_3 = L20_1
    L3_3 = L3_3()
    L3_3 = L3_3.mumble
    L2_3 = L2_3(L3_3)
    if "table" == L2_3 then
      L2_3 = L20_1
      L2_3 = L2_3()
      L2_3 = L2_3.mumble
      L2_3 = L2_3.radioControl
      if L2_3 then
        goto lbl_18
      end
    end
    L2_3 = 137
    ::lbl_18::
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = 137
    end
    L0_3 = L0_3(L1_3)
    while true do
      L1_3 = L4_1
      if not L1_3 then
        break
      end
      L1_3 = L0_1
      if not L1_3 then
        break
      end
      L1_3 = L0_1.provider
      if "mumble-voip" ~= L1_3 then
        break
      end
      L1_3 = SetControlNormal
      L2_3 = 0
      L3_3 = L0_3
      L4_3 = 1.0
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
    L1_3 = false
    L11_1 = L1_3
  end
  L0_2(L1_2)
end
function L40_1()
  local L0_2, L1_2, L2_2
  L0_2 = type
  L1_2 = L20_1
  L1_2 = L1_2()
  L1_2 = L1_2.saltychat
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L20_1
    L0_2 = L0_2()
    L0_2 = L0_2.saltychat
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = {}
  ::lbl_15::
  L1_2 = type
  L2_2 = L0_2.pttCommand
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L0_2.pttCommand
    if "" ~= L1_2 then
      L1_2 = L0_2.pttCommand
      if L1_2 then
        goto lbl_27
      end
    end
  end
  L1_2 = "primaryRadio"
  ::lbl_27::
  return L1_2
end
function L41_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L0_1
  if not L0_2 then
    return
  end
  L0_2 = L0_1.provider
  if "pma-voice" == L0_2 then
    L0_2 = L22_1
    L1_2 = "pma-voice"
    L2_2 = "setVoiceProperty"
    L3_2 = "radioEnabled"
    L4_2 = true
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = ExecuteCommand
    L1_2 = "+radiotalk"
    L0_2(L1_2)
  else
    L0_2 = L0_1.provider
    if "saltychat" == L0_2 then
      L0_2 = ExecuteCommand
      L1_2 = "+"
      L2_2 = L40_1
      L2_2 = L2_2()
      L1_2 = L1_2 .. L2_2
      L0_2(L1_2)
    else
      L0_2 = L0_1.provider
      if "mumble-voip" == L0_2 then
        L0_2 = L39_1
        L0_2()
      end
    end
  end
end
function L42_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    L1_2 = L0_1
    A0_2 = L1_2 or A0_2
    if L1_2 then
      A0_2 = L0_1.provider
    end
  end
  if "pma-voice" == A0_2 then
    L1_2 = ExecuteCommand
    L2_2 = "-radiotalk"
    L1_2(L2_2)
  elseif "saltychat" == A0_2 then
    L1_2 = ExecuteCommand
    L2_2 = "-"
    L3_2 = L40_1
    L3_2 = L3_2()
    L2_2 = L2_2 .. L3_2
    L1_2(L2_2)
  end
end
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if A0_2 then
    L2_2 = L0_1
    if nil ~= L2_2 then
      L2_2 = true
      if L2_2 then
        goto lbl_10
        A0_2 = L2_2 or A0_2
      end
    end
  end
  A0_2 = false
  ::lbl_10::
  L2_2 = L5_1
  if A0_2 == L2_2 then
    return
  end
  L5_1 = A0_2
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L6_1 = L2_2
  L2_2 = Push
  L3_2 = "radio:tx"
  L4_2 = {}
  L4_2.on = A0_2
  L2_2(L3_2, L4_2)
  if false ~= A1_2 then
    L2_2 = TriggerServerEvent
    L3_2 = "apex_phone:server:radioTalk"
    L4_2 = A0_2
    L2_2(L3_2, L4_2)
  end
  if A0_2 then
    L2_2 = L34_1
    L2_2()
  else
    L2_2 = L33_1
    L2_2()
  end
end
L44_1 = nil
function L45_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L4_1
  if not L0_2 then
    L0_2 = L0_1
    if L0_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L0_2 = true
  L4_1 = L0_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L7_1 = L0_2
  L0_2 = L41_1
  L0_2()
  L0_2 = L0_1.provider
  if "pma-voice" ~= L0_2 then
    L0_2 = L43_1
    L1_2 = true
    L0_2(L1_2)
    return
  end
  L0_2 = L7_1
  L1_2 = SetTimeout
  L2_2 = 400
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = L7_1
    L1_3 = L0_2
    if L0_3 == L1_3 then
      L0_3 = L4_1
      if L0_3 then
        L0_3 = L5_1
        if not L0_3 then
          L0_3 = L0_1
          if L0_3 then
            goto lbl_15
          end
        end
      end
    end
    do return end
    ::lbl_15::
    L0_3 = L2_1
    if L0_3 then
      L0_3 = L8_1
      if L0_3 > 0 then
        L0_3 = L8_1
        L0_3 = L0_3 - 1
        L8_1 = L0_3
        L0_3 = false
        L4_1 = L0_3
        L0_3 = L42_1
        L1_3 = "pma-voice"
        L0_3(L1_3)
        L0_3 = L45_1
        L0_3()
        return
      end
    end
    L0_3 = L12_1
    if not L0_3 then
      L0_3 = true
      L12_1 = L0_3
      L0_3 = LocalPlayer
      L0_3 = L0_3.state
      L1_3 = print
      L2_3 = "^3[unique_phone] radio: pma-voice refused +radiotalk (radioChannel=%s disableRadio=%s radioActive=%s voice_enableRadios=%s)^7"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = tostring
      L5_3 = L0_3.radioChannel
      L4_3 = L4_3(L5_3)
      L5_3 = tostring
      L6_3 = L0_3.disableRadio
      L5_3 = L5_3(L6_3)
      L6_3 = tostring
      L7_3 = L0_3.radioActive
      L6_3 = L6_3(L7_3)
      L7_3 = tostring
      L8_3 = GetConvarInt
      L9_3 = "voice_enableRadios"
      L10_3 = 1
      L8_3, L9_3, L10_3 = L8_3(L9_3, L10_3)
      L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3, L9_3, L10_3)
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    end
    L0_3 = L2_1
    if L0_3 then
      L0_3 = false
      L2_1 = L0_3
      L0_3 = L25_1
      L0_3 = L0_3()
      if "open" == L0_3 then
        L0_3 = true
        L3_1 = L0_3
      end
      L0_3 = L44_1
      L0_3()
      L0_3 = L26_1
      L0_3()
    end
    L0_3 = Push
    L1_3 = "radio:txfail"
    L2_3 = {}
    L0_3(L1_3, L2_3)
  end
  L1_2(L2_2, L3_2)
end
function L46_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L4_1
  if not L1_2 then
    return
  end
  L1_2 = false
  L4_1 = L1_2
  L1_2 = L42_1
  L2_2 = A0_2
  L1_2(L2_2)
  L1_2 = L0_1
  if L1_2 then
    L1_2 = L0_1.provider
    if "pma-voice" == L1_2 then
      goto lbl_20
    end
  end
  L1_2 = L43_1
  L2_2 = false
  L1_2(L2_2)
  goto lbl_24
  ::lbl_20::
  L1_2 = SetTimeout
  L2_2 = 300
  function L3_2()
    local L0_3, L1_3
    L0_3 = L5_1
    if L0_3 then
      L0_3 = L4_1
      if not L0_3 then
        L0_3 = L43_1
        L1_3 = false
        L0_3(L1_3)
      end
    end
  end
  L1_2(L2_2, L3_2)
  ::lbl_24::
end
L44_1 = L46_1
function L46_1()
  local L0_2, L1_2
  L0_2 = L0_1
  L0_2 = next
  L1_2 = L1_1
  L0_2 = L0_2(L1_2)
  L0_2 = nil ~= L0_2 and L0_2
  if L0_2 then
    L1_2 = L4_1
    if not L1_2 then
      L1_2 = L45_1
      L1_2()
  end
  elseif not L0_2 then
    L1_2 = L4_1
    if L1_2 then
      L1_2 = L44_1
      L1_2()
    end
  end
end
function L47_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L25_1
    L0_2 = L0_2()
    if "open" == L0_2 then
      L0_2 = L3_1
      if not L0_2 then
        goto lbl_12
      end
    end
  end
  do return end
  ::lbl_12::
  L0_2 = true
  L2_1 = L0_2
  L0_2 = 1
  L8_1 = L0_2
  L0_2 = L0_1.key
  L1_2 = SetTimeout
  L2_2 = L17_1
  function L3_2()
    local L0_3, L1_3
    L0_3 = L0_1
    if L0_3 then
      L0_3 = L0_1.key
      L1_3 = L0_2
      if L0_3 == L1_3 then
        L0_3 = L2_1
        if L0_3 then
          L0_3 = L4_1
          if not L0_3 then
            goto lbl_15
          end
        end
      end
    end
    do return end
    ::lbl_15::
    L0_3 = L30_1
    L0_3 = L0_3()
    if L0_3 then
      return
    end
    L0_3 = L46_1
    L0_3()
  end
  L1_2(L2_2, L3_2)
end
function L48_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L25_1
  L1_2 = L1_2()
  L2_2 = L14_1
  if L1_2 == L2_2 and not A0_2 then
    return
  end
  L2_2 = L14_1
  L14_1 = L1_2
  L3_2 = L0_1
  if L3_2 and nil ~= L2_2 and L2_2 ~= L1_2 then
    L3_2 = false
    L2_1 = L3_2
    L3_2 = false
    L3_1 = L3_2
    L3_2 = L4_1
    if L3_2 then
      L3_2 = next
      L4_2 = L1_1
      L3_2 = L3_2(L4_2)
      if nil == L3_2 then
        L3_2 = L44_1
        L3_2()
      end
    end
    if "open" == L1_2 then
      L3_2 = L47_1
      L3_2()
    end
    L3_2 = L9_1
    if L3_2 then
      L3_2 = L32_1
      L3_2 = L3_2()
      if not L3_2 then
        L3_2 = L33_1
        L3_2()
      end
    end
  end
  L3_2 = L26_1
  L3_2()
end
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L0_1
  if L1_2 then
    L1_2 = L1_1
    L1_2 = L1_2[A0_2]
    if not L1_2 then
      goto lbl_9
    end
  end
  do return end
  ::lbl_9::
  L1_2 = L48_1
  L2_2 = false
  L1_2(L2_2)
  L1_2 = L30_1
  L1_2 = L1_2()
  if L1_2 then
    L2_2 = Push
    L3_2 = "radio:blocked"
    L4_2 = {}
    L4_2.reason = L1_2
    L2_2(L3_2, L4_2)
    return
  end
  L2_2 = L1_1
  L2_2[A0_2] = true
  L2_2 = L46_1
  L2_2()
end
function L50_1(A0_2)
  local L1_2
  L1_2 = L1_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L1_2 = L1_1
  L1_2[A0_2] = nil
  L1_2 = L46_1
  L1_2()
end
function L51_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L0_1
  if not L0_2 then
    return
  end
  L0_2 = L48_1
  L1_2 = false
  L0_2(L1_2)
  L0_2 = L25_1
  L0_2 = L0_2()
  if "toggle" == L0_2 then
    L1_2 = L2_1
    if L1_2 then
      L1_2 = false
      L2_1 = L1_2
    else
      L1_2 = L30_1
      L1_2 = L1_2()
      if L1_2 then
        L2_2 = Push
        L3_2 = "radio:blocked"
        L4_2 = {}
        L4_2.reason = L1_2
        L2_2(L3_2, L4_2)
        return
      end
      L2_2 = true
      L2_1 = L2_2
      L2_2 = 0
      L8_1 = L2_2
    end
  elseif "open" == L0_2 then
    L1_2 = L2_1
    if L1_2 then
      L1_2 = false
      L2_1 = L1_2
      L1_2 = true
      L3_1 = L1_2
    else
      L1_2 = L30_1
      L1_2 = L1_2()
      if L1_2 then
        L2_2 = Push
        L3_2 = "radio:blocked"
        L4_2 = {}
        L4_2.reason = L1_2
        L2_2(L3_2, L4_2)
        return
      end
      L2_2 = false
      L3_1 = L2_2
      L2_2 = true
      L2_1 = L2_2
      L2_2 = 1
      L8_1 = L2_2
    end
  else
    return
  end
  L1_2 = L46_1
  L1_2()
  L1_2 = L26_1
  L1_2()
end
function L52_1(A0_2)
  local L1_2, L2_2
  L1_2 = {}
  L1_1 = L1_2
  L1_2 = false
  L2_1 = L1_2
  L1_2 = L4_1
  if L1_2 then
    L1_2 = false
    L4_1 = L1_2
    L1_2 = L42_1
    L2_2 = A0_2
    L1_2(L2_2)
  end
end
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L4_1
  if L2_2 then
    L2_2 = L2_1
    if L2_2 then
      L2_2 = L0_1
      if L2_2 then
        goto lbl_12
      end
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_12::
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L15_1.at
  L3_2 = L2_2 - L3_2
  L4_2 = 5000
  if L3_2 > L4_2 then
    L15_1.n = 0
  end
  L15_1.at = L2_2
  L3_2 = L15_1.n
  L3_2 = L3_2 + 1
  L15_1.n = L3_2
  L3_2 = L15_1.n
  if L3_2 > 3 then
    L3_2 = false
    L2_1 = L3_2
    L3_2 = L25_1
    L3_2 = L3_2()
    if "open" == L3_2 then
      L3_2 = true
      L3_1 = L3_2
    end
    L3_2 = false
    L4_1 = L3_2
    L3_2 = L43_1
    L4_2 = false
    L3_2(L4_2)
    L3_2 = L26_1
    L3_2()
    L3_2 = Push
    L4_2 = "radio:txfail"
    L5_2 = {}
    L3_2(L4_2, L5_2)
    L3_2 = true
    return L3_2
  end
  L3_2 = L0_1.provider
  L4_2 = L2_2
  L5_2 = SetTimeout
  L6_2 = 50
  function L7_2()
    local L0_3, L1_3, L2_3
    L0_3 = L4_1
    if L0_3 then
      L0_3 = L2_1
      if L0_3 then
        L0_3 = L0_1
        if L0_3 then
          L0_3 = L0_1.provider
          L1_3 = L3_2
          if L0_3 == L1_3 then
            goto lbl_15
          end
        end
      end
    end
    do return end
    ::lbl_15::
    L0_3 = ExecuteCommand
    L1_3 = A0_2
    L0_3(L1_3)
    L0_3 = A1_2
    if not L0_3 then
      return
    end
    L0_3 = SetTimeout
    L1_3 = 400
    function L2_3()
      local L0_4, L1_4, L2_4
      L0_4 = L4_1
      if L0_4 then
        L0_4 = L2_1
        if L0_4 then
          L0_4 = L16_1
          L1_4 = L4_2
          if L0_4 < L1_4 then
            L0_4 = false
            L2_1 = L0_4
            L0_4 = L25_1
            L0_4 = L0_4()
            if "open" == L0_4 then
              L0_4 = true
              L3_1 = L0_4
            end
            L0_4 = L44_1
            L0_4()
            L0_4 = L26_1
            L0_4()
            L0_4 = Push
            L1_4 = "radio:txfail"
            L2_4 = {}
            L0_4(L1_4, L2_4)
          end
        end
      end
    end
    L0_3(L1_3, L2_3)
  end
  L5_2(L6_2, L7_2)
  L5_2 = true
  return L5_2
end
L54_1 = AddEventHandler
L55_1 = "pma-voice:radioActive"
function L56_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L0_1
  if L1_2 then
    L1_2 = L0_1.provider
    if "pma-voice" == L1_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  if true == A0_2 then
    L1_2 = L35_1
    L1_2 = L1_2()
    if not L1_2 then
      return
    end
  end
  if true == A0_2 then
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L16_1 = L1_2
  end
  if true ~= A0_2 then
    L1_2 = L53_1
    L2_2 = "+radiotalk"
    L3_2 = true
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      return
    end
  end
  L1_2 = L43_1
  L2_2 = true == A0_2
  L1_2(L2_2)
end
L54_1(L55_1, L56_1)
L54_1 = AddEventHandler
L55_1 = "SaltyChat_RadioTrafficStateChanged"
function L56_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L0_1
  if L2_2 then
    L2_2 = L0_1.provider
    if "saltychat" == L2_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  if true == A1_2 then
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L16_1 = L2_2
  end
  if true ~= A1_2 then
    L2_2 = L4_1
    if L2_2 then
      L2_2 = L2_1
      if L2_2 then
        L2_2 = L53_1
        L3_2 = "+"
        L4_2 = L40_1
        L4_2 = L4_2()
        L3_2 = L3_2 .. L4_2
        L4_2 = false
        L2_2 = L2_2(L3_2, L4_2)
        if L2_2 then
          return
        end
      end
    end
  end
  L2_2 = L43_1
  L3_2 = true == A1_2
  L2_2(L3_2)
end
L54_1(L55_1, L56_1)
L54_1 = RegisterNetEvent
L55_1 = "mumble:SetVoiceData"
function L56_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  if "radioActive" == A1_2 then
    L3_2 = L0_1
    if L3_2 then
      L3_2 = L0_1.provider
      if "mumble-voip" == L3_2 then
        goto lbl_10
      end
    end
  end
  do return end
  ::lbl_10::
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = GetPlayerServerId
  L5_2 = PlayerId
  L5_2 = L5_2()
  L4_2 = L4_2(L5_2)
  if L3_2 ~= L4_2 then
    return
  end
  if true ~= A2_2 then
    L3_2 = L4_1
    if L3_2 then
      return
    end
  end
  L3_2 = L43_1
  L4_2 = true == A2_2
  L3_2(L4_2)
end
L54_1(L55_1, L56_1)
L54_1 = type
L55_1 = L19_1
L55_1 = L55_1()
L55_1 = L55_1.pttCommand
L54_1 = L54_1(L55_1)
if "string" == L54_1 then
  L54_1 = L19_1
  L54_1 = L54_1()
  L54_1 = L54_1.pttCommand
  L55_1 = L54_1
  L54_1 = L54_1.match
  L56_1 = "^[%w_]+$"
  L54_1 = L54_1(L55_1, L56_1)
  if L54_1 then
    L54_1 = L19_1
    L54_1 = L54_1()
    L54_1 = L54_1.pttCommand
    if L54_1 then
      goto lbl_106
    end
  end
end
L54_1 = "uniqueradio_ptt"
::lbl_106::
L55_1 = RegisterCommand
L56_1 = "+"
L57_1 = L54_1
L56_1 = L56_1 .. L57_1
function L57_1()
  local L0_2, L1_2
  L0_2 = L25_1
  L0_2 = L0_2()
  if "ptt" == L0_2 then
    L0_2 = L49_1
    L1_2 = "key"
    L0_2(L1_2)
  else
    L0_2 = L51_1
    L0_2()
  end
end
L58_1 = false
L55_1(L56_1, L57_1, L58_1)
L55_1 = RegisterCommand
L56_1 = "-"
L57_1 = L54_1
L56_1 = L56_1 .. L57_1
function L57_1()
  local L0_2, L1_2
  L0_2 = L1_1.key
  if L0_2 then
    L0_2 = L50_1
    L1_2 = "key"
    L0_2(L1_2)
  end
end
L58_1 = false
L55_1(L56_1, L57_1, L58_1)
L55_1 = L19_1
L55_1 = L55_1()
L55_1 = L55_1.pttKeyEnabled
if false ~= L55_1 then
  L55_1 = RegisterKeyMapping
  L56_1 = "+"
  L57_1 = L54_1
  L56_1 = L56_1 .. L57_1
  L57_1 = Tr
  L58_1 = "R\195\161dio do telem\195\179vel: falar (manter)"
  L57_1 = L57_1(L58_1)
  L58_1 = "keyboard"
  L59_1 = type
  L60_1 = L19_1
  L60_1 = L60_1()
  L60_1 = L60_1.pttKey
  L59_1 = L59_1(L60_1)
  if "string" == L59_1 then
    L59_1 = L19_1
    L59_1 = L59_1()
    L59_1 = L59_1.pttKey
    if L59_1 then
      goto lbl_146
    end
  end
  L59_1 = "CAPITAL"
  ::lbl_146::
  L55_1(L56_1, L57_1, L58_1, L59_1)
end
L55_1 = {}
L55_1.CAPITAL = "Caps Lock"
L55_1.LMENU = "Alt"
L55_1.RMENU = "Alt Gr"
L55_1.LSHIFT = "Shift"
L55_1.RSHIFT = "Shift"
L55_1.LCONTROL = "Ctrl"
L55_1.RCONTROL = "Ctrl"
L55_1.SPACE = "Espa\195\167o"
L55_1.TAB = "Tab"
L55_1.RETURN = "Enter"
function L56_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L19_1
  L0_2 = L0_2()
  L0_2 = L0_2.pttKeyEnabled
  if false == L0_2 then
    L0_2 = false
    return L0_2
  end
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = GetControlInstructionalButton
    L1_3 = 0
    L2_3 = joaat
    L3_3 = "+"
    L4_3 = L54_1
    L3_3 = L3_3 .. L4_3
    L2_3 = L2_3(L3_3)
    L2_3 = L2_3 | 2147483648
    L3_3 = true
    return L0_3(L1_3, L2_3, L3_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 then
    L2_2 = type
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if "string" == L2_2 then
      L3_2 = L1_2
      L2_2 = L1_2.sub
      L4_2 = 1
      L5_2 = 2
      L2_2 = L2_2(L3_2, L4_2, L5_2)
      if "t_" == L2_2 then
        L2_2 = #L1_2
        if L2_2 > 2 then
          L3_2 = L1_2
          L2_2 = L1_2.sub
          L4_2 = 3
          L2_2 = L2_2(L3_2, L4_2)
          L4_2 = L2_2
          L3_2 = L2_2.upper
          L3_2 = L3_2(L4_2)
          L4_2 = L55_1
          L3_2 = L4_2[L3_2]
          if not L3_2 then
            L3_2 = L2_2
          end
          return L3_2
        end
      end
    end
  end
  L2_2 = type
  L3_2 = L19_1
  L3_2 = L3_2()
  L3_2 = L3_2.pttKey
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = L19_1
    L2_2 = L2_2()
    L2_2 = L2_2.pttKey
    if L2_2 then
      goto lbl_51
    end
  end
  L2_2 = "CAPITAL"
  ::lbl_51::
  L4_2 = L2_2
  L3_2 = L2_2.upper
  L3_2 = L3_2(L4_2)
  L4_2 = L55_1
  L3_2 = L4_2[L3_2]
  if not L3_2 then
    L3_2 = L2_2
  end
  return L3_2
end
function L57_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L52_1
  L1_2()
  L1_2 = false
  L3_1 = L1_2
  L1_2 = L43_1
  L2_2 = false
  L1_2(L2_2)
  L1_2 = ServerRpc
  L2_2 = "radio.leave"
  L3_2 = {}
  L4_2 = A0_2 or L4_2
  if not A0_2 then
    L4_2 = "user"
  end
  L3_2.reason = L4_2
  function L4_2()
    local L0_3, L1_3
  end
  L1_2(L2_2, L3_2, L4_2)
end
function L58_1()
  local L0_2, L1_2
  L0_2 = L10_1
  if L0_2 then
    return
  end
  L0_2 = true
  L10_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    while true do
      L0_3 = L0_1
      if not L0_3 then
        break
      end
      L0_3 = L30_1
      L0_3 = L0_3()
      if L0_3 then
        L1_3 = L57_1
        L2_3 = L0_3
        L1_3(L2_3)
        break
      end
      L1_3 = L48_1
      L2_3 = false
      L1_3(L2_3)
      L1_3 = tonumber
      L2_3 = L19_1
      L2_3 = L2_3()
      L2_3 = L2_3.maxTalkSeconds
      L1_3 = L1_3(L2_3)
      if not L1_3 then
        L1_3 = 60
      end
      L2_3 = L5_1
      if L2_3 then
        L2_3 = L25_1
        L2_3 = L2_3()
        if "open" ~= L2_3 and L1_3 > 0 then
          L2_3 = GetGameTimer
          L2_3 = L2_3()
          L3_3 = L6_1
          L2_3 = L2_3 - L3_3
          L3_3 = L1_3 * 1000
          if L2_3 > L3_3 then
            L2_3 = L52_1
            L2_3()
            L2_3 = L43_1
            L3_3 = false
            L2_3(L3_3)
            L2_3 = L26_1
            L2_3()
          end
        end
      end
      L2_3 = L5_1
      if L2_3 then
        L2_3 = L9_1
        if L2_3 then
          L2_3 = L32_1
          L2_3 = L2_3()
          if not L2_3 then
            L2_3 = L33_1
            L2_3()
        end
        else
          L2_3 = L9_1
          if L2_3 then
            L2_3 = L18_1
            L3_3 = IsEntityPlayingAnim
            L4_3 = PlayerPedId
            L4_3 = L4_3()
            L5_3 = L9_1.dict
            L6_3 = L9_1.clip
            L7_3 = 3
            L3_3, L4_3, L5_3, L6_3, L7_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
            L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
            if not L2_3 then
              L2_3 = GetGameTimer
              L2_3 = L2_3()
              L3_3 = L6_1
              L2_3 = L2_3 - L3_3
              L3_3 = 1500
              if L2_3 > L3_3 then
                L2_3 = nil
                L9_1 = L2_3
                L2_3 = L34_1
                L2_3()
            end
          end
          else
            L2_3 = L9_1
            if not L2_3 then
              L2_3 = L32_1
              L2_3 = L2_3()
              if L2_3 then
                L2_3 = GetGameTimer
                L2_3 = L2_3()
                L3_3 = L6_1
                L2_3 = L2_3 - L3_3
                L3_3 = 1500
                if L2_3 > L3_3 then
                  L2_3 = L34_1
                  L2_3()
                end
              end
            end
          end
        end
      else
        L2_3 = L9_1
        if L2_3 then
          L2_3 = L33_1
          L2_3()
        end
      end
      L2_3 = Wait
      L3_3 = 1000
      L2_3(L3_3)
    end
    L0_3 = false
    L10_1 = L0_3
  end
  L0_2(L1_2)
end
L59_1 = {}
L59_1.dead = "O r\195\161dio desligou-se: est\195\161s inconsciente."
L59_1.vehicle = "O r\195\161dio n\195\163o funciona dentro de ve\195\173culos."
L59_1.water = "O r\195\161dio desligou-se dentro de \195\161gua."
L59_1.earbuds = "Tiraste os auriculares: o r\195\161dio desligou-se."
L59_1.item = "J\195\161 n\195\163o tens o r\195\161dio necess\195\161rio."
L59_1.nophone = "J\195\161 n\195\163o tens o telem\195\179vel: o r\195\161dio desligou-se."
L59_1.restricted = "J\195\161 n\195\163o tens acesso a esta frequ\195\170ncia."
L59_1.disabled = "O r\195\161dio foi desativado pelo servidor."
L59_1.novoice = "O sistema de voz deixou de estar dispon\195\173vel."
L59_1.closed = "Guardaste o telem\195\179vel: o r\195\161dio desligou-se."
L59_1.external = "Foste retirado da frequ\195\170ncia."
L60_1 = RegisterNetEvent
L61_1 = "apex_phone:client:push"
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if "radio:joined" == A0_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "table" ~= L2_2 then
      return
    end
    L2_2 = L0_1
    if L2_2 then
      L3_2 = L2_2.key
      L4_2 = A1_2.key
      if L3_2 ~= L4_2 then
        L3_2 = L52_1
        L3_2()
        L3_2 = L43_1
        L4_2 = false
        L5_2 = false
        L3_2(L4_2, L5_2)
        L3_2 = L2_2.provider
        L4_2 = A1_2.provider
        if L3_2 ~= L4_2 then
          L3_2 = L38_1
          L4_2 = L2_2
          L3_2(L4_2)
        end
    end
    elseif L2_2 then
      L3_2 = L4_1
      if L3_2 then
        L3_2 = L2_1
        if L3_2 then
          L3_2 = false
          L4_1 = L3_2
          L3_2 = false
          L2_1 = L3_2
          L3_2 = L42_1
          L4_2 = L2_2.provider
          L3_2(L4_2)
        end
      end
    end
    L3_2 = type
    L4_2 = A1_2.pmode
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L4_2 = A1_2.pmode
      L3_2 = L23_1
      L3_2 = L3_2[L4_2]
      if L3_2 then
        L3_2 = A1_2.pmode
        if L3_2 then
          goto lbl_59
        end
      end
      L3_2 = nil
      ::lbl_59::
      L13_1 = L3_2
    else
      L3_2 = A1_2.pmode
      if false == L3_2 then
        L3_2 = nil
        L13_1 = L3_2
      end
    end
    L3_2 = {}
    L4_2 = A1_2.key
    L3_2.key = L4_2
    L4_2 = A1_2.freq
    L3_2.freq = L4_2
    L4_2 = A1_2.label
    L3_2.label = L4_2
    L4_2 = tonumber
    L5_2 = A1_2.ch
    L4_2 = L4_2(L5_2)
    L3_2.ch = L4_2
    L4_2 = A1_2.salty
    L3_2.salty = L4_2
    L4_2 = A1_2.provider
    L3_2.provider = L4_2
    L4_2 = A1_2.tag
    L3_2.tag = L4_2
    L4_2 = tonumber
    L5_2 = A1_2.vol
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = tonumber
      L5_2 = L19_1
      L5_2 = L5_2()
      L5_2 = L5_2.defaultVolume
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = 60
      end
    end
    L3_2.vol = L4_2
    L0_1 = L3_2
    L3_2 = L37_1
    L3_2()
    L3_2 = L25_1
    L3_2 = L3_2()
    L14_1 = L3_2
    L3_2 = L14_1
    if "open" == L3_2 then
      L3_2 = L2_1
      if L3_2 then
        L3_2 = L4_1
        if not L3_2 then
          L3_2 = false
          L2_1 = L3_2
        end
      end
      L3_2 = L2_1
      if not L3_2 then
        L3_2 = L47_1
        L3_2()
      end
    else
      L3_2 = L14_1
      if "toggle" ~= L3_2 then
        L3_2 = false
        L3_1 = L3_2
      end
    end
    L3_2 = L26_1
    L3_2()
    L3_2 = L58_1
    L3_2()
  elseif "radio:left" == A0_2 then
    L2_2 = L0_1
    L3_2 = L4_1
    L4_2 = {}
    L1_1 = L4_2
    L4_2 = false
    L2_1 = L4_2
    L4_2 = false
    L3_1 = L4_2
    L4_2 = false
    L4_1 = L4_2
    if L2_2 then
      if not L3_2 then
        L4_2 = L5_1
        if not L4_2 then
          goto lbl_154
        end
      end
      L4_2 = L42_1
      L5_2 = L2_2.provider
      L4_2(L5_2)
    end
    ::lbl_154::
    L4_2 = nil
    L0_1 = L4_2
    L4_2 = L43_1
    L5_2 = false
    L6_2 = false
    L4_2(L5_2, L6_2)
    L4_2 = L33_1
    L4_2()
    L4_2 = L38_1
    L5_2 = L2_2
    L4_2(L5_2)
    L4_2 = L26_1
    L4_2()
    L4_2 = type
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = A1_2.reason
      if L4_2 then
        goto lbl_176
      end
    end
    L4_2 = nil
    ::lbl_176::
    if L4_2 then
      L5_2 = L59_1
      L5_2 = L5_2[L4_2]
      if L5_2 then
        L5_2 = PhoneOpen
        if not L5_2 then
          L5_2 = L19_1
          L5_2 = L5_2()
          L5_2 = L5_2.gameNotify
          if false ~= L5_2 then
            L5_2 = FW
            if L5_2 then
              L5_2 = FW
              L5_2 = L5_2.Notify
              if L5_2 then
                L5_2 = FW
                L5_2 = L5_2.Notify
                L6_2 = L59_1
                L6_2 = L6_2[L4_2]
                L7_2 = "error"
                L5_2(L6_2, L7_2)
              end
            end
          end
        end
      end
    end
  end
end
L60_1(L61_1, L62_1)
L60_1 = AddEventHandler
L61_1 = "apex_phone:client:closed"
function L62_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L19_1
    L0_2 = L0_2()
    L0_2 = L0_2.keepOnWhenPhoneClosed
    if false == L0_2 then
      L0_2 = L57_1
      L1_2 = "closed"
      L0_2(L1_2)
    end
  end
end
L60_1(L61_1, L62_1)
L60_1 = FW
if L60_1 then
  L60_1 = FW
  L60_1 = L60_1.OnPlayerUnload
  if L60_1 then
    L60_1 = FW
    L60_1 = L60_1.OnPlayerUnload
    function L61_1()
      local L0_2, L1_2, L2_2
      L0_2 = L52_1
      L0_2()
      L0_2 = false
      L3_1 = L0_2
      L0_2 = L43_1
      L1_2 = false
      L2_2 = false
      L0_2(L1_2, L2_2)
      L0_2 = L33_1
      L0_2()
    end
    L60_1(L61_1)
  end
end
L60_1 = AddEventHandler
L61_1 = "onResourceStop"
function L62_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = L4_1
  if not L1_2 then
    L1_2 = L5_1
    if not L1_2 then
      goto lbl_14
    end
  end
  L1_2 = L42_1
  L1_2()
  ::lbl_14::
  L1_2 = false
  L4_1 = L1_2
  L1_2 = false
  L2_1 = L1_2
  L1_2 = L33_1
  L1_2()
  L1_2 = L38_1
  L2_2 = L0_1
  L1_2(L2_2)
end
L60_1(L61_1, L62_1)
L60_1 = RegisterNUICallback
L61_1 = "radioPtt"
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = A0_2.tap
  if true == L2_2 then
    L2_2 = L25_1
    L2_2 = L2_2()
    if "ptt" == L2_2 then
      L2_2 = L26_1
      L2_2()
    else
      L2_2 = L51_1
      L2_2()
    end
  else
    L2_2 = A0_2.on
    if true == L2_2 then
      L2_2 = L25_1
      L2_2 = L2_2()
      if "ptt" == L2_2 then
        L2_2 = L49_1
        L3_2 = "ui"
        L2_2(L3_2)
      else
        L2_2 = L51_1
        L2_2()
      end
    else
      L2_2 = L50_1
      L3_2 = "ui"
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L4_2 = L5_1
  L3_2.tx = L4_2
  L4_2 = L25_1
  L4_2 = L4_2()
  L3_2.mode = L4_2
  L4_2 = L3_1
  L3_2.muted = L4_2
  L4_2 = L2_1
  L3_2.latched = L4_2
  L2_2(L3_2)
end
L60_1(L61_1, L62_1)
L60_1 = RegisterNUICallback
L61_1 = "radioMode"
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.mode
    if L2_2 then
      goto lbl_10
    end
  end
  L2_2 = nil
  ::lbl_10::
  L3_2 = L19_1
  L3_2 = L3_2()
  L3_2 = L3_2.allowPlayerMode
  if true == L3_2 then
    L3_2 = L24_1
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_31
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L4_2.error = "invalid"
  L5_2 = L25_1
  L5_2 = L5_2()
  L4_2.mode = L5_2
  L5_2 = L3_1
  L4_2.muted = L5_2
  L3_2(L4_2)
  do return end
  ::lbl_31::
  L13_1 = L2_2
  L3_2 = L48_1
  L4_2 = false
  L3_2(L4_2)
  L3_2 = A1_2
  L4_2 = {}
  L4_2.ok = true
  L5_2 = L25_1
  L5_2 = L5_2()
  L4_2.mode = L5_2
  L5_2 = L3_1
  L4_2.muted = L5_2
  L5_2 = L2_1
  L4_2.latched = L5_2
  L3_2(L4_2)
end
L60_1(L61_1, L62_1)
L60_1 = RegisterNUICallback
L61_1 = "radioJoin"
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = L30_1
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = A1_2
    L4_2 = {}
    L4_2.error = L2_2
    L3_2(L4_2)
    return
  end
  L3_2 = ServerRpc
  L4_2 = "radio.join"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A0_2.freq
  L6_2 = L6_2(L7_2)
  L5_2.freq = L6_2
  L6_2 = type
  L7_2 = A0_2.pass
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L6_2 = A0_2.pass
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = 16
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_42
    end
  end
  L6_2 = nil
  ::lbl_42::
  L5_2.pass = L6_2
  function L6_2(A0_3)
    local L1_3, L2_3
    L1_3 = A1_2
    L2_3 = A0_3 or L2_3
    if not A0_3 then
      L2_3 = {}
      L2_3.error = "timeout"
    end
    L1_3(L2_3)
  end
  L3_2(L4_2, L5_2, L6_2)
end
L60_1(L61_1, L62_1)
L60_1 = RegisterNUICallback
L61_1 = "radioLeave"
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L52_1
  L2_2()
  L2_2 = false
  L3_1 = L2_2
  L2_2 = L43_1
  L3_2 = false
  L2_2(L3_2)
  L2_2 = ServerRpc
  L3_2 = "radio.leave"
  L4_2 = {}
  L4_2.reason = "user"
  function L5_2(A0_3)
    local L1_3, L2_3
    L1_3 = A1_2
    L2_3 = A0_3 or L2_3
    if not A0_3 then
      L2_3 = {}
      L2_3.ok = true
    end
    L1_3(L2_3)
  end
  L2_2(L3_2, L4_2, L5_2)
end
L60_1(L61_1, L62_1)
L60_1 = RegisterNUICallback
L61_1 = "radioVolume"
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L36_1
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.v
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L60_1(L61_1, L62_1)
L60_1 = RegisterNUICallback
L61_1 = "radioEnv"
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.pmode
    if nil ~= L2_2 then
      L2_2 = L0_1
      if not L2_2 then
        L3_2 = A0_2.pmode
        L2_2 = L23_1
        L2_2 = L2_2[L3_2]
        if L2_2 then
          L2_2 = A0_2.pmode
          if L2_2 then
            goto lbl_21
          end
        end
        L2_2 = nil
        ::lbl_21::
        L13_1 = L2_2
      end
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L4_2 = L56_1
  L4_2 = L4_2()
  L3_2.key = L4_2
  L4_2 = L29_1
  L4_2 = L4_2()
  L3_2.worn = L4_2
  L4_2 = L30_1
  L4_2 = L4_2()
  if not L4_2 then
    L4_2 = false
  end
  L3_2.block = L4_2
  L4_2 = L5_1
  L3_2.tx = L4_2
  L4_2 = L0_1
  if L4_2 then
    L4_2 = L0_1.key
    if L4_2 then
      goto lbl_46
    end
  end
  L4_2 = false
  ::lbl_46::
  L3_2.joined = L4_2
  L4_2 = L25_1
  L4_2 = L4_2()
  L3_2.mode = L4_2
  L4_2 = L3_1
  L3_2.muted = L4_2
  L4_2 = L2_1
  L3_2.latched = L4_2
  L2_2(L3_2)
end
L60_1(L61_1, L62_1)
L60_1 = exports
L61_1 = "GetRadioFrequency"
function L62_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = L0_1.freq
    if L0_2 then
      goto lbl_8
    end
  end
  L0_2 = nil
  ::lbl_8::
  return L0_2
end
L60_1(L61_1, L62_1)
L60_1 = exports
L61_1 = "IsRadioTransmitting"
function L62_1()
  local L0_2, L1_2
  L0_2 = L5_1
  return L0_2
end
L60_1(L61_1, L62_1)
L60_1 = exports
L61_1 = "GetRadioTalkMode"
function L62_1()
  local L0_2, L1_2
  L0_2 = L25_1
  return L0_2()
end
L60_1(L61_1, L62_1)
