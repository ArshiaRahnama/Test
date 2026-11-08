local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1, L87_1, L88_1, L89_1, L90_1, L91_1, L92_1, L93_1, L94_1, L95_1, L96_1, L97_1, L98_1, L99_1, L100_1, L101_1, L102_1, L103_1, L104_1, L105_1, L106_1, L107_1, L108_1, L109_1, L110_1, L111_1, L112_1, L113_1, L114_1, L115_1, L116_1, L117_1, L118_1, L119_1
PhoneOpen = false
L0_1 = {}
RegisteredApps = L0_1
L0_1 = Tr
if not L0_1 then
  function L0_1(A0_2)
    local L1_2
    return A0_2
  end
end
Tr = L0_1
L0_1 = TrF
if not L0_1 then
  function L0_1(A0_2, ...)
    local L1_2, L2_2, L3_2, L4_2
    L1_2 = pcall
    L2_2 = string
    L2_2 = L2_2.format
    L3_2 = A0_2
    L4_2 = ...
    L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
    L3_2 = L2_2 or L3_2
    if not L1_2 or not L2_2 then
      L3_2 = A0_2
    end
    return L3_2
  end
end
TrF = L0_1
L0_1 = SetPhoneLang
if not L0_1 then
  function L0_1()
    local L0_2, L1_2
    L0_2 = false
    return L0_2
  end
end
SetPhoneLang = L0_1
L0_1 = nil
L1_1 = nil
L2_1 = false
L3_1 = false
L4_1 = false
function L5_1()
  local L0_2, L1_2
  L0_2 = L3_1
  if not L0_2 then
    L0_2 = L4_1
  end
  return L0_2
end
L6_1 = false
L7_1 = false
function L8_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = Dbg
  if L1_2 then
    L1_2 = Dbg
    L2_2 = "client"
    L3_2 = A0_2
    L4_2 = ...
    L1_2(L2_2, L3_2, L4_2)
  end
end
CurrentDevice = nil
function L9_1(A0_2)
  local L1_2
  L1_2 = A0_2 or nil
  if A0_2 then
    L1_2 = Config
    L1_2 = L1_2.Devices
    if L1_2 then
      L1_2 = Config
      L1_2 = L1_2.Devices
      L1_2 = L1_2[A0_2]
    end
  end
  return L1_2
end
function L10_1()
  local L0_2, L1_2
  L0_2 = L9_1
  L1_2 = CurrentDevice
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L0_2.frame
    if L1_2 then
      goto lbl_14
    end
  end
  L1_2 = Config
  L1_2 = L1_2.Frame
  if not L1_2 then
    L1_2 = "orange"
  end
  ::lbl_14::
  return L1_2
end
DeviceFrame = L10_1
function L10_1()
  local L0_2, L1_2
  L0_2 = L9_1
  L1_2 = CurrentDevice
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L0_2.os
    if "android" == L1_2 then
      L1_2 = "android"
      if L1_2 then
        goto lbl_13
      end
    end
  end
  L1_2 = "ios"
  ::lbl_13::
  return L1_2
end
DeviceOS = L10_1
function L10_1()
  local L0_2, L1_2, L2_2
  L0_2 = L9_1
  L1_2 = CurrentDevice
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = type
    L2_2 = L0_2.model
    L1_2 = L1_2(L2_2)
    if "string" == L1_2 then
      L1_2 = L0_2.model
      if "" ~= L1_2 then
        L1_2 = L0_2.model
        if L1_2 then
          goto lbl_18
        end
      end
    end
  end
  L1_2 = false
  ::lbl_18::
  return L1_2
end
DeviceModel = L10_1
L10_1 = {}
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = joaat
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = IsModelInCdimage
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = IsModelValid
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      return L1_2
    end
  end
  L2_2 = L10_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = L10_1
    L2_2[A0_2] = true
    L2_2 = print
    L3_2 = "^3[unique_phone]^0 model %s is not available (stream/ + .ytyp?) \226\128\148 trying the next prop."
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = A0_2
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L2_2(L3_2, L4_2, L5_2)
  end
  L2_2 = nil
  return L2_2
end
function L12_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L9_1
  L1_2 = CurrentDevice
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L0_2.prop
    if L1_2 then
      L1_2 = L0_2.prop
      if "" ~= L1_2 then
        L1_2 = L11_1
        L2_2 = L0_2.prop
        L1_2 = L1_2(L2_2)
        if L1_2 then
          return L1_2
        end
      end
    end
  end
  L1_2 = Config
  L1_2 = L1_2.FrameProps
  if L1_2 then
    L1_2 = Config
    L1_2 = L1_2.FrameProps
    L2_2 = DeviceFrame
    L2_2 = L2_2()
    L1_2 = L1_2[L2_2]
  end
  if L1_2 then
    L2_2 = L11_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      return L2_2
    end
  end
  L2_2 = Config
  L2_2 = L2_2.PhoneProp
  return L2_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "vector3" ~= L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "table" ~= L2_2 then
      goto lbl_39
    end
  end
  L2_2 = tonumber
  L3_2 = A0_2.x
  if not L3_2 then
    L3_2 = A0_2[1]
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A1_2.x
  end
  L3_2 = tonumber
  L4_2 = A0_2.y
  if not L4_2 then
    L4_2 = A0_2[2]
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = A1_2.y
  end
  L4_2 = tonumber
  L5_2 = A0_2.z
  if not L5_2 then
    L5_2 = A0_2[3]
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = A1_2.z
  end
  do return L2_2, L3_2, L4_2 end
  ::lbl_39::
  L2_2 = A1_2.x
  L3_2 = A1_2.y
  L4_2 = A1_2.z
  return L2_2, L3_2, L4_2
end
L14_1 = {}
L14_1.x = 0.0
L14_1.y = 0.0
L14_1.z = 0.0
L15_1 = nil
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L15_1
  if L1_2 then
    L1_2 = L15_1.item
    if L1_2 == A0_2 then
      L1_2 = L15_1
      return L1_2
    end
  end
  L1_2 = GlobalState
  L1_2 = L1_2["apex_phone:propfit"]
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 and A0_2 then
    L2_2 = L1_2[A0_2]
    if L2_2 then
      goto lbl_22
    end
  end
  L2_2 = nil
  ::lbl_22::
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L2_2 or L3_2
  if "table" ~= L3_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L17_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L7_2 = L16_1
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L8_2 = A1_2
    L9_2 = A2_2
    L10_2 = A3_2
    L11_2 = A4_2
    L12_2 = A5_2
    L13_2 = A6_2
    return L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  end
  L8_2 = L13_1
  L9_2 = L7_2.pos
  L10_2 = {}
  L10_2.x = A1_2
  L10_2.y = A2_2
  L10_2.z = A3_2
  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2)
  L11_2 = L13_1
  L12_2 = L7_2.rot
  L13_2 = {}
  L13_2.x = A4_2
  L13_2.y = A5_2
  L13_2.z = A6_2
  L11_2, L12_2, L13_2 = L11_2(L12_2, L13_2)
  L14_2 = L8_2 + 0.0
  L15_2 = L9_2 + 0.0
  L16_2 = L10_2 + 0.0
  L17_2 = L11_2 + 0.0
  L18_2 = L12_2 + 0.0
  L19_2 = L13_2 + 0.0
  return L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
end
function L18_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.PropAttach
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.PropAttach
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = L9_1
  L2_2 = CurrentDevice
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = type
    L3_2 = L1_2.attach
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = L1_2.attach
      if L2_2 then
        goto lbl_28
      end
    end
  end
  L2_2 = {}
  ::lbl_28::
  L3_2 = tonumber
  L4_2 = L2_2.bone
  if not L4_2 then
    L4_2 = L0_2.bone
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 28422
  end
  L4_2 = L13_1
  L5_2 = L0_2.pos
  L6_2 = L14_1
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L7_2 = L13_1
  L8_2 = L2_2.pos
  L9_2 = {}
  L9_2.x = L4_2
  L9_2.y = L5_2
  L9_2.z = L6_2
  L7_2, L8_2, L9_2 = L7_2(L8_2, L9_2)
  L10_2 = L13_1
  L11_2 = L0_2.rot
  L12_2 = L14_1
  L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2)
  L13_2 = L13_1
  L14_2 = L2_2.rot
  L15_2 = {}
  L15_2.x = L10_2
  L15_2.y = L11_2
  L15_2.z = L12_2
  L13_2, L14_2, L15_2 = L13_2(L14_2, L15_2)
  L16_2 = L17_1
  L17_2 = CurrentDevice
  L18_2 = L7_2
  L19_2 = L8_2
  L20_2 = L9_2
  L21_2 = L13_2
  L22_2 = L14_2
  L23_2 = L15_2
  L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L15_2 = L21_2
  L14_2 = L20_2
  L13_2 = L19_2
  L9_2 = L18_2
  L8_2 = L17_2
  L7_2 = L16_2
  L16_2 = math
  L16_2 = L16_2.floor
  L17_2 = L3_2
  L16_2 = L16_2(L17_2)
  L17_2 = L7_2 + 0.0
  L18_2 = L8_2 + 0.0
  L19_2 = L9_2 + 0.0
  L20_2 = L13_2 + 0.0
  L21_2 = L14_2 + 0.0
  L22_2 = L15_2 + 0.0
  return L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = type
  L2_2 = A0_2.attach
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.attach
    if L1_2 then
      goto lbl_11
    end
  end
  L1_2 = {}
  ::lbl_11::
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = tonumber
  L4_2 = L1_2.bone
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 57005
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L13_1
  L4_2 = L1_2.pos
  L5_2 = L14_1
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  L6_2 = L13_1
  L7_2 = L1_2.rot
  L8_2 = L14_1
  L6_2, L7_2, L8_2 = L6_2(L7_2, L8_2)
  L9_2 = L17_1
  L10_2 = CurrentDevice
  L11_2 = L3_2
  L12_2 = L4_2
  L13_2 = L5_2
  L14_2 = L6_2
  L15_2 = L7_2
  L16_2 = L8_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L8_2 = L14_2
  L7_2 = L13_2
  L6_2 = L12_2
  L5_2 = L11_2
  L4_2 = L10_2
  L3_2 = L9_2
  L9_2 = L2_2
  L10_2 = L3_2 + 0.0
  L11_2 = L4_2 + 0.0
  L12_2 = L5_2 + 0.0
  L13_2 = L6_2 + 0.0
  L14_2 = L7_2 + 0.0
  L15_2 = L8_2 + 0.0
  return L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
end
function L20_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2 or nil
  if A0_2 then
    L1_2 = Config
    L1_2 = L1_2.Devices
    L1_2 = L1_2[A0_2]
    if L1_2 then
      L1_2 = FW
      L1_2 = L1_2.HasItem
      L2_2 = A0_2
      L1_2 = L1_2(L2_2)
      if not L1_2 then
        L1_2 = 0
      end
      L1_2 = L1_2 > 0
    end
  end
  return L1_2
end
L21_1 = nil
function L22_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = FW
  L0_2 = L0_2.FirstItemOf
  if L0_2 then
    L0_2 = FW
    L0_2 = L0_2.FirstItemOf
    L1_2 = Config
    L1_2 = L1_2.Devices
    if not L1_2 then
      L1_2 = {}
    end
    L0_2 = L0_2(L1_2)
    if L0_2 then
      goto lbl_17
    end
  end
  L0_2 = nil
  ::lbl_17::
  if L0_2 then
    L1_2 = L20_1
    L2_2 = L0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      return L0_2
    end
  end
  L1_2 = ipairs
  L2_2 = Config
  L2_2 = L2_2.DeviceOrder
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L20_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      return L6_2
    end
  end
  L1_2 = nil
  return L1_2
end
function L23_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.action = "push"
  L3_2.event = A0_2
  L3_2.data = A1_2
  L2_2(L3_2)
end
Push = L23_1
L23_1 = false
function L24_1()
  local L0_2, L1_2
  L0_2 = L23_1
  return L0_2
end
PhoneIsTyping = L24_1
function L24_1()
  local L0_2, L1_2
  L0_2 = Config
  L0_2 = L0_2.AllowWalking
  L0_2 = true == L0_2
  return L0_2
end
L25_1 = {}
L25_1.on = false
L25_1.keep = false
L25_1.cursor = false
function L26_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  if A0_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_7
      A0_2 = L3_2 or A0_2
    end
  end
  A0_2 = false
  ::lbl_7::
  if nil == A2_2 then
    L3_2 = Config
    L3_2 = L3_2.ShowCursor
    A2_2 = false ~= L3_2
  end
  if nil == A1_2 then
    L3_2 = L24_1
    L3_2 = L3_2()
    A1_2 = L3_2 or A1_2
    if L3_2 then
      L3_2 = L23_1
      A1_2 = not L3_2
    end
  end
  L3_2 = {}
  L3_2.on = A0_2
  if A0_2 and A1_2 then
    L4_2 = true
    if L4_2 then
      goto lbl_34
    end
  end
  L4_2 = false
  ::lbl_34::
  L3_2.keep = L4_2
  if A0_2 and A2_2 then
    L4_2 = true
    if L4_2 then
      goto lbl_43
    end
  end
  L4_2 = false
  ::lbl_43::
  L3_2.cursor = L4_2
  L25_1 = L3_2
  L3_2 = SetNuiFocus
  L4_2 = A0_2
  L5_2 = L25_1.cursor
  L3_2(L4_2, L5_2)
  L3_2 = SetNuiFocusKeepInput
  L4_2 = L25_1.keep
  L3_2(L4_2)
end
SetPhoneFocus = L26_1
function L26_1()
  local L0_2, L1_2
  L0_2 = IsNuiFocused
  L0_2 = L0_2()
  L1_2 = true == L0_2 or 1 == L0_2
  return L1_2
end
function L27_1()
  local L0_2, L1_2, L2_2
  L0_2 = PhoneOpen
  if L0_2 then
    L0_2 = L25_1.on
    if L0_2 then
      goto lbl_9
    end
  end
  L0_2 = false
  do return L0_2 end
  ::lbl_9::
  L0_2 = SetNuiFocus
  L1_2 = true
  L2_2 = L25_1.cursor
  L0_2(L1_2, L2_2)
  L0_2 = SetNuiFocusKeepInput
  L1_2 = L25_1.keep
  L0_2(L1_2)
  L0_2 = true
  return L0_2
end
ReapplyPhoneFocus = L27_1
L27_1 = false
function L28_1()
  local L0_2, L1_2
  L0_2 = L27_1
  if L0_2 then
    return
  end
  L0_2 = true
  L27_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3
    L0_3 = 0
    while true do
      L1_3 = PhoneOpen
      if not L1_3 then
        break
      end
      L1_3 = Wait
      L2_3 = 500
      L1_3(L2_3)
      L1_3 = PhoneOpen
      if L1_3 then
        L1_3 = L25_1.on
        if L1_3 then
          L1_3 = L26_1
          L1_3 = L1_3()
          if not L1_3 then
            L1_3 = OverlayIsOpen
            if L1_3 then
              L1_3 = OverlayIsOpen
              L1_3 = L1_3()
              if L1_3 then
                goto lbl_36
              end
            end
            L0_3 = L0_3 + 1
            if L0_3 >= 2 then
              L0_3 = 0
              L1_3 = L8_1
              L2_3 = "NUI focus was lost while the phone is open: restoring it"
              L1_3(L2_3)
              L1_3 = ReapplyPhoneFocus
              L1_3()
            end
        end
      end
      ::lbl_36::
      else
        L0_3 = 0
      end
    end
    L1_3 = false
    L27_1 = L1_3
  end
  L0_2(L1_2)
end
function L29_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = FW
  L0_2 = L0_2.GetPlayerData
  L0_2 = L0_2()
  L1_2 = {}
  L2_2 = L0_2.cid
  L1_2.citizenid = L2_2
  L2_2 = L0_2.firstname
  if not L2_2 then
    L2_2 = "Jogador"
  end
  L1_2.firstname = L2_2
  L2_2 = L0_2.lastname
  if not L2_2 then
    L2_2 = ""
  end
  L1_2.lastname = L2_2
  L2_2 = L0_2.phone
  L1_2.phone = L2_2
  L2_2 = L0_2.birthdate
  L1_2.birthdate = L2_2
  L2_2 = {}
  L3_2 = L0_2.job
  L3_2 = L3_2.name
  L2_2.name = L3_2
  L3_2 = L0_2.job
  L3_2 = L3_2.label
  L2_2.label = L3_2
  L3_2 = L0_2.job
  L3_2 = L3_2.grade
  L2_2.grade = L3_2
  L3_2 = L0_2.job
  L3_2 = L3_2.onduty
  L2_2.onduty = L3_2
  L1_2.job = L2_2
  L2_2 = {}
  L3_2 = L0_2.cash
  if not L3_2 then
    L3_2 = 0
  end
  L2_2.cash = L3_2
  L3_2 = L0_2.bank
  if not L3_2 then
    L3_2 = 0
  end
  L2_2.bank = L3_2
  L1_2.money = L2_2
  L2_2 = FW
  L2_2 = L2_2.name
  L1_2.framework = L2_2
  return L1_2
end
L30_1 = nil
L31_1 = 0
L32_1 = false
function L33_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L29_1
  L0_2 = L0_2()
  L1_2 = json
  L1_2 = L1_2.encode
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L30_1
  if L1_2 == L2_2 then
    return
  end
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L31_1
  L3_2 = L2_2 - L3_2
  L4_2 = 1000
  if L3_2 < L4_2 then
    L3_2 = L32_1
    if not L3_2 then
      L3_2 = true
      L32_1 = L3_2
      L3_2 = SetTimeout
      L4_2 = L31_1
      L4_2 = L2_2 - L4_2
      L5_2 = 1000
      L4_2 = L5_2 - L4_2
      function L5_2()
        local L0_3, L1_3
        L0_3 = false
        L32_1 = L0_3
        L0_3 = PushPlayer
        L0_3()
      end
      L3_2(L4_2, L5_2)
    end
    return
  end
  L30_1 = L1_2
  L31_1 = L2_2
  L3_2 = Push
  L4_2 = "player"
  L5_2 = L0_2
  L3_2(L4_2, L5_2)
end
PushPlayer = L33_1
L33_1 = 0
L34_1 = {}
L35_1 = 10000
function L36_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L33_1
  L3_2 = L3_2 + 1
  L33_1 = L3_2
  L3_2 = L33_1
  L4_2 = L34_1
  L4_2[L3_2] = A2_2
  L4_2 = TriggerServerEvent
  L5_2 = "apex_phone:server:rpc"
  L6_2 = L3_2
  L7_2 = A0_2
  L8_2 = A1_2 or L8_2
  if not A1_2 then
    L8_2 = {}
  end
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = SetTimeout
  L5_2 = L35_1
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = L3_2
    L0_3 = L34_1
    L0_3 = L0_3[L1_3]
    if L0_3 then
      L2_3 = L3_2
      L1_3 = L34_1
      L1_3[L2_3] = nil
      L1_3 = print
      L2_3 = "[unique_phone] rpc \"%s\" (#%d) no response from the server in %ds"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = tostring
      L5_3 = A0_2
      L4_3 = L4_3(L5_3)
      L5_3 = L3_2
      L6_3 = L35_1
      L6_3 = L6_3 // 1000
      L2_3, L3_3, L4_3, L5_3, L6_3 = L2_3(L3_3, L4_3, L5_3, L6_3)
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
      L1_3 = L0_3
      L2_3 = {}
      L2_3.error = "timeout"
      L1_3(L2_3)
    end
  end
  L4_2(L5_2, L6_2)
end
ServerRpc = L36_1
L36_1 = RegisterNetEvent
L37_1 = "apex_phone:client:rpcResult"
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L34_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    return
  end
  L3_2 = L34_1
  L3_2[A0_2] = nil
  if nil == A1_2 then
    L3_2 = L2_2
    L4_2 = false
    L3_2(L4_2)
  else
    L3_2 = L2_2
    L4_2 = A1_2
    L3_2(L4_2)
  end
end
L36_1(L37_1, L38_1)
L36_1 = LocalPlayer
L36_1 = L36_1.state
L36_1 = L36_1.apex_airpods
L36_1 = true == L36_1
function L37_1()
  local L0_2, L1_2
  L0_2 = L36_1
  return L0_2
end
function L38_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  if not L0_2 then
    L0_2 = L5_1
    L0_2 = L0_2()
    if L0_2 then
      L0_2 = L37_1
      L0_2 = L0_2()
      L0_2 = not L0_2
    end
  end
  return L0_2
end
L39_1 = nil
L40_1 = nil
L41_1 = 180.0
L42_1 = 180.0
L43_1 = 180.0
L44_1 = 0
L45_1 = 0
L46_1 = false
L47_1 = 850
function L48_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L9_1
  L1_2 = CurrentDevice
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = type
    L2_2 = L0_2.fold
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = L0_2.fold
      if L1_2 then
        goto lbl_15
      end
    end
  end
  L1_2 = nil
  ::lbl_15::
  if L1_2 then
    L2_2 = L11_1
    L3_2 = L1_2.base
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = L11_1
      L3_2 = L1_2.leaf
      L2_2 = L2_2(L3_2)
      if L2_2 then
        return L1_2
      end
    end
  end
  L2_2 = nil
  return L2_2
end
function L49_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L0_2 = L40_1
  if L0_2 then
    L1_2 = L0_1
    if L1_2 then
      L1_2 = L39_1
      if L1_2 then
        L1_2 = DoesEntityExist
        L2_2 = L0_1
        L1_2 = L1_2(L2_2)
        if L1_2 then
          L1_2 = DoesEntityExist
          L2_2 = L39_1
          L1_2 = L1_2(L2_2)
          if L1_2 then
            goto lbl_21
          end
        end
      end
    end
  end
  do return end
  ::lbl_21::
  L1_2 = L41_1
  L2_2 = tonumber
  L3_2 = L0_2.dir
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 1.0
  end
  L1_2 = L1_2 * L2_2
  L2_2 = L0_2.axis
  if not L2_2 then
    L2_2 = "z"
  end
  L3_2 = AttachEntityToEntity
  L4_2 = L39_1
  L5_2 = L0_1
  L6_2 = 0
  L7_2 = 0.0
  L8_2 = 0.0
  L9_2 = 0.0
  L10_2 = L1_2 or L10_2
  if "x" ~= L2_2 or not L1_2 then
    L10_2 = 0.0
  end
  L11_2 = L1_2 or L11_2
  if "y" ~= L2_2 or not L1_2 then
    L11_2 = 0.0
  end
  L12_2 = L1_2 or L12_2
  if "z" ~= L2_2 or not L1_2 then
    L12_2 = 0.0
  end
  L13_2 = false
  L14_2 = false
  L15_2 = false
  L16_2 = true
  L17_2 = 2
  L18_2 = true
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
end
function L50_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L45_1
  if L0_2 <= 0 then
    L0_2 = false
    return L0_2
  end
  L0_2 = math
  L0_2 = L0_2.min
  L1_2 = 1.0
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L44_1
  L2_2 = L2_2 - L3_2
  L3_2 = L45_1
  L2_2 = L2_2 / L3_2
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = L0_2 * L0_2
  L2_2 = 2.0 * L0_2
  L3_2 = 3.0
  L2_2 = L3_2 - L2_2
  L1_2 = L1_2 * L2_2
  L2_2 = L42_1
  L3_2 = L43_1
  L4_2 = L42_1
  L3_2 = L3_2 - L4_2
  L3_2 = L3_2 * L1_2
  L2_2 = L2_2 + L3_2
  L41_1 = L2_2
  L2_2 = L49_1
  L2_2()
  if L0_2 >= 1.0 then
    L2_2 = 0
    L45_1 = L2_2
    L2_2 = false
    return L2_2
  end
  L2_2 = true
  return L2_2
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 0.0
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 180.0
  L5_2 = tonumber
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0.0
  end
  L5_2 = L5_2 + 0.0
  L3_2 = L3_2(L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2)
  A0_2 = L1_2
  L1_2 = L39_1
  if not L1_2 then
    L41_1 = A0_2
    L1_2 = 0
    return L1_2
  end
  L1_2 = L41_1
  L2_2 = A0_2
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  L44_1 = L3_2
  L43_1 = L2_2
  L42_1 = L1_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = L47_1
  L3_2 = math
  L3_2 = L3_2.abs
  L4_2 = L41_1
  L4_2 = A0_2 - L4_2
  L3_2 = L3_2(L4_2)
  L2_2 = L2_2 * L3_2
  L2_2 = L2_2 / 180.0
  L1_2 = L1_2(L2_2)
  L45_1 = L1_2
  L1_2 = L45_1
  if L1_2 <= 0 then
    L41_1 = A0_2
    L1_2 = L49_1
    L1_2()
    L1_2 = 0
    return L1_2
  end
  L1_2 = L46_1
  if not L1_2 then
    L1_2 = true
    L46_1 = L1_2
    L1_2 = CreateThread
    function L2_2()
      local L0_3, L1_3
      while true do
        L0_3 = L50_1
        L0_3 = L0_3()
        if not L0_3 then
          break
        end
        L0_3 = Wait
        L1_3 = 0
        L0_3(L1_3)
      end
      L0_3 = false
      L46_1 = L0_3
    end
    L1_2(L2_2)
  end
  L1_2 = L45_1
  return L1_2
end
L52_1 = false
function L53_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  if L0_2 then
    L0_2 = L52_1
    if L0_2 then
      L0_2 = 0.0
      if L0_2 then
        goto lbl_11
      end
    end
    L0_2 = 180.0
    ::lbl_11::
    return L0_2
  end
  L0_2 = L5_1
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = tonumber
    L1_2 = L40_1
    if L1_2 then
      L1_2 = L40_1.callAngle
    end
    L0_2 = L0_2(L1_2)
    if not L0_2 then
      L0_2 = 0.0
    end
    return L0_2
  end
  L0_2 = 180.0
  return L0_2
end
L54_1 = nil
function L55_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2
  L1_2 = joaat
  L2_2 = A0_2.base
  L1_2 = L1_2(L2_2)
  L2_2 = joaat
  L3_2 = A0_2.leaf
  L2_2 = L2_2(L3_2)
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  L4_2 = RequestModel
  L5_2 = L1_2
  L4_2(L5_2)
  L4_2 = RequestModel
  L5_2 = L2_2
  L4_2(L5_2)
  while true do
    L4_2 = HasModelLoaded
    L5_2 = L1_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L4_2 = HasModelLoaded
      L5_2 = L2_2
      L4_2 = L4_2(L5_2)
      if L4_2 then
        break
      end
    end
    L4_2 = GetGameTimer
    L4_2 = L4_2()
    L4_2 = L4_2 - L3_2
    L5_2 = 5000
    if not (L4_2 < L5_2) then
      break
    end
    L4_2 = Wait
    L5_2 = 10
    L4_2(L5_2)
  end
  function L4_2()
    local L0_3, L1_3
    L0_3 = SetModelAsNoLongerNeeded
    L1_3 = L1_2
    L0_3(L1_3)
    L0_3 = SetModelAsNoLongerNeeded
    L1_3 = L2_2
    L0_3(L1_3)
  end
  L5_2 = HasModelLoaded
  L6_2 = L1_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L5_2 = HasModelLoaded
    L6_2 = L2_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_52
    end
  end
  L5_2 = L4_2
  L5_2()
  L5_2 = false
  L2_1 = L5_2
  do return end
  ::lbl_52::
  L5_2 = L48_1
  L5_2 = L5_2()
  if L5_2 ~= A0_2 then
    L5_2 = L4_2
    L5_2()
    L5_2 = false
    L2_1 = L5_2
    L5_2 = L0_1
    if not L5_2 then
      L5_2 = L38_1
      L5_2 = L5_2()
      if L5_2 then
        L5_2 = L54_1
        L5_2()
      end
    end
    return
  end
  L5_2 = L0_1
  if not L5_2 then
    L5_2 = L38_1
    L5_2 = L5_2()
    if L5_2 then
      goto lbl_82
    end
  end
  L5_2 = L4_2
  L5_2()
  L5_2 = false
  L2_1 = L5_2
  do return end
  ::lbl_82::
  L5_2 = PlayerPedId
  L5_2 = L5_2()
  L6_2 = GetEntityCoords
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L7_2 = CreateObject
  L8_2 = L1_2
  L9_2 = L6_2.x
  L10_2 = L6_2.y
  L11_2 = L6_2.z
  L11_2 = L11_2 + 0.2
  L12_2 = true
  L13_2 = true
  L14_2 = true
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L7_2 or 0 == L7_2 then
    L8_2 = L4_2
    L8_2()
    L8_2 = false
    L2_1 = L8_2
    return
  end
  L8_2 = CreateObject
  L9_2 = L2_2
  L10_2 = L6_2.x
  L11_2 = L6_2.y
  L12_2 = L6_2.z
  L12_2 = L12_2 + 0.2
  L13_2 = true
  L14_2 = true
  L15_2 = true
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  if not L8_2 or 0 == L8_2 then
    L9_2 = DeleteEntity
    L10_2 = L7_2
    L9_2(L10_2)
    L9_2 = L4_2
    L9_2()
    L9_2 = false
    L2_1 = L9_2
    return
  end
  L9_2 = SetEntityCollision
  L10_2 = L7_2
  L11_2 = false
  L12_2 = false
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = SetEntityCollision
  L10_2 = L8_2
  L11_2 = false
  L12_2 = false
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = SetEntityNoCollisionEntity
  L10_2 = L8_2
  L11_2 = L7_2
  L12_2 = false
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = L19_1
  L10_2 = A0_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L9_2(L10_2)
  L16_2 = AttachEntityToEntity
  L17_2 = L7_2
  L18_2 = L5_2
  L19_2 = GetPedBoneIndex
  L20_2 = L5_2
  L21_2 = L9_2
  L19_2 = L19_2(L20_2, L21_2)
  L20_2 = L10_2
  L21_2 = L11_2
  L22_2 = L12_2
  L23_2 = L13_2
  L24_2 = L14_2
  L25_2 = L15_2
  L26_2 = false
  L27_2 = false
  L28_2 = false
  L29_2 = true
  L30_2 = 2
  L31_2 = true
  L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2)
  L16_2 = L4_2
  L16_2()
  L16_2 = L7_2
  L17_2 = L8_2
  L18_2 = A0_2
  L19_2 = CurrentDevice
  L1_1 = L19_2
  L40_1 = L18_2
  L39_1 = L17_2
  L0_1 = L16_2
  L16_2 = 180.0
  L17_2 = 0
  L45_1 = L17_2
  L41_1 = L16_2
  L16_2 = L49_1
  L16_2()
  L16_2 = false
  L2_1 = L16_2
  L16_2 = L51_1
  L17_2 = L53_1
  L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2 = L17_2()
  L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2)
  L16_2 = NetworkGetEntityIsNetworked
  L17_2 = L7_2
  L16_2 = L16_2(L17_2)
  if L16_2 then
    L16_2 = TriggerServerEvent
    L17_2 = "apex_phone:server:propNet"
    L18_2 = ObjToNet
    L19_2 = L7_2
    L18_2 = L18_2(L19_2)
    L19_2 = NetworkGetEntityIsNetworked
    L20_2 = L8_2
    L19_2 = L19_2(L20_2)
    if L19_2 then
      L19_2 = ObjToNet
      L20_2 = L8_2
      L19_2 = L19_2(L20_2)
      if L19_2 then
        goto lbl_211
      end
    end
    L19_2 = nil
    ::lbl_211::
    L16_2(L17_2, L18_2, L19_2)
  end
end
function L56_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L0_2 = L0_1
  if not L0_2 then
    L0_2 = L2_1
    if not L0_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L0_2 = true
  L2_1 = L0_2
  L0_2 = L48_1
  L0_2 = L0_2()
  if L0_2 then
    L1_2 = L55_1
    L2_2 = L0_2
    return L1_2(L2_2)
  end
  L1_2 = L12_1
  L1_2 = L1_2()
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  while true do
    L3_2 = RequestModel
    L4_2 = L1_2
    L3_2(L4_2)
    while true do
      L3_2 = HasModelLoaded
      L4_2 = L1_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        break
      end
      L3_2 = GetGameTimer
      L3_2 = L3_2()
      L3_2 = L3_2 - L2_2
      L4_2 = 5000
      if not (L3_2 < L4_2) then
        break
      end
      L3_2 = Wait
      L4_2 = 10
      L3_2(L4_2)
    end
    L3_2 = HasModelLoaded
    L4_2 = L1_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = SetModelAsNoLongerNeeded
      L4_2 = L1_2
      L3_2(L4_2)
      L3_2 = false
      L2_1 = L3_2
      return
    end
    L3_2 = L12_1
    L3_2 = L3_2()
    if L3_2 == L1_2 then
      break
    end
    L4_2 = SetModelAsNoLongerNeeded
    L5_2 = L1_2
    L4_2(L5_2)
    L1_2 = L3_2
  end
  L3_2 = L0_1
  if not L3_2 then
    L3_2 = L38_1
    L3_2 = L3_2()
    if L3_2 then
      goto lbl_74
    end
  end
  L3_2 = SetModelAsNoLongerNeeded
  L4_2 = L1_2
  L3_2(L4_2)
  L3_2 = false
  L2_1 = L3_2
  do return end
  ::lbl_74::
  L3_2 = PlayerPedId
  L3_2 = L3_2()
  L4_2 = GetEntityCoords
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = CreateObject
  L6_2 = L1_2
  L7_2 = L4_2.x
  L8_2 = L4_2.y
  L9_2 = L4_2.z
  L9_2 = L9_2 + 0.2
  L10_2 = true
  L11_2 = true
  L12_2 = true
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  if not L5_2 or 0 == L5_2 then
    L6_2 = SetModelAsNoLongerNeeded
    L7_2 = L1_2
    L6_2(L7_2)
    L6_2 = false
    L2_1 = L6_2
    return
  end
  L6_2 = SetEntityCollision
  L7_2 = L5_2
  L8_2 = false
  L9_2 = false
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = L18_1
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2()
  L13_2 = AttachEntityToEntity
  L14_2 = L5_2
  L15_2 = L3_2
  L16_2 = GetPedBoneIndex
  L17_2 = L3_2
  L18_2 = L6_2
  L16_2 = L16_2(L17_2, L18_2)
  L17_2 = L7_2
  L18_2 = L8_2
  L19_2 = L9_2
  L20_2 = L10_2
  L21_2 = L11_2
  L22_2 = L12_2
  L23_2 = true
  L24_2 = true
  L25_2 = false
  L26_2 = true
  L27_2 = 1
  L28_2 = true
  L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  L13_2 = SetModelAsNoLongerNeeded
  L14_2 = L1_2
  L13_2(L14_2)
  L13_2 = L5_2
  L14_2 = CurrentDevice
  L1_1 = L14_2
  L0_1 = L13_2
  L13_2 = false
  L2_1 = L13_2
  L13_2 = NetworkGetEntityIsNetworked
  L14_2 = L5_2
  L13_2 = L13_2(L14_2)
  if L13_2 then
    L13_2 = TriggerServerEvent
    L14_2 = "apex_phone:server:propNet"
    L15_2 = ObjToNet
    L16_2 = L5_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L15_2(L16_2)
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  end
end
L54_1 = L56_1
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L0_1
  if L1_2 then
    L1_2 = DoesEntityExist
    L2_2 = L0_1
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = SetEntityVisible
      L2_2 = L0_1
      if A0_2 then
        L3_2 = true
        if L3_2 then
          goto lbl_17
        end
      end
      L3_2 = false
      ::lbl_17::
      L4_2 = false
      L1_2(L2_2, L3_2, L4_2)
    end
  end
  L1_2 = L39_1
  if L1_2 then
    L1_2 = DoesEntityExist
    L2_2 = L39_1
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = SetEntityVisible
      L2_2 = L39_1
      if A0_2 then
        L3_2 = true
        if L3_2 then
          goto lbl_35
        end
      end
      L3_2 = false
      ::lbl_35::
      L4_2 = false
      L1_2(L2_2, L3_2, L4_2)
    end
  end
end
SetPhonePropVisible = L56_1
L56_1 = RegisterNUICallback
L57_1 = "foldState"
function L58_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = "table" == L2_2
  L52_1 = L2_2
  L2_2 = L39_1
  if L2_2 then
    L2_2 = PhoneOpen
    if L2_2 then
      L2_2 = L51_1
      L3_2 = L53_1
      L3_2 = L3_2()
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L56_1(L57_1, L58_1)
function L56_1()
  local L0_2, L1_2, L2_2
  L0_2 = L39_1
  if L0_2 then
    L0_2 = DoesEntityExist
    L1_2 = L39_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = DeleteEntity
      L1_2 = L39_1
      L0_2(L1_2)
    end
    L0_2 = nil
    L39_1 = L0_2
  end
  L0_2 = nil
  L1_2 = 0
  L2_2 = 180.0
  L41_1 = L2_2
  L45_1 = L1_2
  L40_1 = L0_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = DeleteEntity
    L1_2 = L0_1
    L0_2(L1_2)
    L0_2 = nil
    L0_1 = L0_2
    L0_2 = TriggerServerEvent
    L1_2 = "apex_phone:server:propNet"
    L2_2 = nil
    L0_2(L1_2, L2_2)
  end
  L0_2 = nil
  L1_1 = L0_2
end
function L57_1()
  local L0_2, L1_2, L2_2
  L0_2 = RequestAnimDict
  L1_2 = "cellphone@"
  L0_2(L1_2)
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = HasAnimDictLoaded
    L2_2 = "cellphone@"
    L1_2 = L1_2(L2_2)
    if L1_2 then
      break
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 3000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 10
    L1_2(L2_2)
  end
  L1_2 = HasAnimDictLoaded
  L2_2 = "cellphone@"
  return L1_2(L2_2)
end
function L58_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = L57_1
  L1_2()
  L1_2 = TaskPlayAnim
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_text_in"
  L5_2 = 2.0
  L6_2 = 3.0
  L7_2 = -1
  L8_2 = 50
  L9_2 = 0
  L10_2 = false
  L11_2 = false
  L12_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
end
function L59_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = L57_1
  L0_2 = L0_2()
  if not L0_2 then
    return
  end
  L0_2 = L5_1
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = PhoneOpen
    if not L0_2 then
      goto lbl_14
    end
  end
  do return end
  ::lbl_14::
  L0_2 = L37_1
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = L8_1
    L1_2 = "ear pose skipped: AirBuds on"
    L0_2(L1_2)
    return
  end
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = StopAnimTask
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_text_in"
  L5_2 = 1.0
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = TaskPlayAnim
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_call_listen_base"
  L5_2 = 3.0
  L6_2 = 3.0
  L7_2 = -1
  L8_2 = 49
  L9_2 = 0
  L10_2 = false
  L11_2 = false
  L12_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
end
function L60_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = IsEntityPlayingAnim
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_call_listen_base"
  L5_2 = 3
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if not L1_2 then
    return
  end
  L1_2 = TaskPlayAnim
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_call_out"
  L5_2 = 2.0
  L6_2 = 3.0
  L7_2 = -1
  L8_2 = 50
  L9_2 = 0
  L10_2 = false
  L11_2 = false
  L12_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L1_2 = Wait
  L2_2 = 600
  L1_2(L2_2)
  L1_2 = StopAnimTask
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_call_out"
  L5_2 = 1.0
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = StopAnimTask
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_call_listen_base"
  L5_2 = 1.0
  L1_2(L2_2, L3_2, L4_2, L5_2)
end
L61_1 = false
function L62_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = false
  while true do
    L1_2 = PhoneOpen
    if not L1_2 then
      L1_2 = L5_1
      L1_2 = L1_2()
      if not L1_2 then
        break
      end
    end
    L1_2 = Wait
    L2_2 = 700
    L1_2(L2_2)
    L1_2 = PlayerPedId
    L1_2 = L1_2()
    L2_2 = FW
    L2_2 = L2_2.IsDead
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = PhoneOpen
      if L2_2 then
        L2_2 = Config
        L2_2 = L2_2.BlockWhenDead
        if false ~= L2_2 then
          L2_2 = L8_1
          L3_2 = "died with the phone open: closing"
          L2_2(L3_2)
          L2_2 = ClosePhone
          L2_2()
        end
      end
      L2_2 = PhoneOpen
      if not L2_2 then
        L2_2 = L0_1
        if L2_2 then
          L2_2 = L56_1
          L2_2()
        end
        if not L0_2 then
          L2_2 = StopAnimTask
          L3_2 = L1_2
          L4_2 = "cellphone@"
          L5_2 = "cellphone_call_listen_base"
          L6_2 = 1.0
          L2_2(L3_2, L4_2, L5_2, L6_2)
        end
      end
      L0_2 = true
    else
      L2_2 = PhoneOpen
      if not L2_2 then
        L2_2 = L5_1
        L2_2 = L2_2()
        if not L2_2 then
          goto lbl_197
        end
      end
      L2_2 = DoesEntityExist
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      if L2_2 then
        L2_2 = CameraActive
        if L2_2 then
          L2_2 = CameraActive
          L2_2 = L2_2()
          if L2_2 then
            goto lbl_197
          end
        end
        if L0_2 then
          L0_2 = false
          L2_2 = L0_1
          if not L2_2 then
            L2_2 = L38_1
            L2_2 = L2_2()
            if L2_2 then
              L2_2 = L54_1
              L2_2()
            end
          end
        end
        L2_2 = HasAnimDictLoaded
        L3_2 = "cellphone@"
        L2_2 = L2_2(L3_2)
        if L2_2 then
          L2_2 = PhoneOpen
          if L2_2 then
            L2_2 = L4_1
            if L2_2 then
              L2_2 = L37_1
              L2_2 = L2_2()
              if not L2_2 then
                L2_2 = IsEntityPlayingAnim
                L3_2 = L1_2
                L4_2 = "cellphone@"
                L5_2 = "cellphone_call_listen_base"
                L6_2 = 3
                L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
                if not L2_2 then
                  L2_2 = StopAnimTask
                  L3_2 = L1_2
                  L4_2 = "cellphone@"
                  L5_2 = "cellphone_text_in"
                  L6_2 = 1.0
                  L2_2(L3_2, L4_2, L5_2, L6_2)
                  L2_2 = TaskPlayAnim
                  L3_2 = L1_2
                  L4_2 = "cellphone@"
                  L5_2 = "cellphone_call_listen_base"
                  L6_2 = 8.0
                  L7_2 = 3.0
                  L8_2 = -1
                  L9_2 = 49
                  L10_2 = 0
                  L11_2 = false
                  L12_2 = false
                  L13_2 = false
                  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
                end
            end
          end
          else
            L2_2 = PhoneOpen
            if L2_2 then
              L2_2 = IsEntityPlayingAnim
              L3_2 = L1_2
              L4_2 = "cellphone@"
              L5_2 = "cellphone_call_listen_base"
              L6_2 = 3
              L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
              if L2_2 then
                L2_2 = StopAnimTask
                L3_2 = L1_2
                L4_2 = "cellphone@"
                L5_2 = "cellphone_call_listen_base"
                L6_2 = 1.0
                L2_2(L3_2, L4_2, L5_2, L6_2)
              end
              L2_2 = IsEntityPlayingAnim
              L3_2 = L1_2
              L4_2 = "cellphone@"
              L5_2 = "cellphone_text_in"
              L6_2 = 3
              L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
              if not L2_2 then
                L2_2 = TaskPlayAnim
                L3_2 = L1_2
                L4_2 = "cellphone@"
                L5_2 = "cellphone_text_in"
                L6_2 = 8.0
                L7_2 = 3.0
                L8_2 = -1
                L9_2 = 50
                L10_2 = 0
                L11_2 = false
                L12_2 = false
                L13_2 = false
                L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
                L2_2 = SetEntityAnimCurrentTime
                L3_2 = L1_2
                L4_2 = "cellphone@"
                L5_2 = "cellphone_text_in"
                L6_2 = 1.0
                L2_2(L3_2, L4_2, L5_2, L6_2)
              end
            else
              L2_2 = L5_1
              L2_2 = L2_2()
              if L2_2 then
                L2_2 = L37_1
                L2_2 = L2_2()
                if not L2_2 then
                  L2_2 = IsEntityPlayingAnim
                  L3_2 = L1_2
                  L4_2 = "cellphone@"
                  L5_2 = "cellphone_call_listen_base"
                  L6_2 = 3
                  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
                  if not L2_2 then
                    L2_2 = TaskPlayAnim
                    L3_2 = L1_2
                    L4_2 = "cellphone@"
                    L5_2 = "cellphone_call_listen_base"
                    L6_2 = 8.0
                    L7_2 = 3.0
                    L8_2 = -1
                    L9_2 = 49
                    L10_2 = 0
                    L11_2 = false
                    L12_2 = false
                    L13_2 = false
                    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
                  end
                end
              end
            end
          end
        end
      end
    end
    ::lbl_197::
  end
end
function L63_1()
  local L0_2, L1_2
  L0_2 = L61_1
  if L0_2 then
    return
  end
  L0_2 = true
  L61_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = pcall
    L1_3 = L62_1
    L0_3, L1_3 = L0_3(L1_3)
    L2_3 = false
    L61_1 = L2_3
    if not L0_3 then
      L2_3 = print
      L3_3 = "^1[unique_phone]^0 phone watchdog stopped: %s"
      L4_3 = L3_3
      L3_3 = L3_3.format
      L5_3 = tostring
      L6_3 = L1_3
      L5_3, L6_3 = L5_3(L6_3)
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
      L2_3(L3_3, L4_3, L5_3, L6_3)
    end
  end
  L0_2(L1_2)
end
function L64_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = StopAnimTask
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_text_in"
  L5_2 = 1.0
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = TaskPlayAnim
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_text_out"
  L5_2 = 2.0
  L6_2 = 3.0
  L7_2 = -1
  L8_2 = 50
  L9_2 = 0
  L10_2 = false
  L11_2 = false
  L12_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L1_2 = Wait
  L2_2 = 400
  L1_2(L2_2)
  L1_2 = StopAnimTask
  L2_2 = L0_2
  L3_2 = "cellphone@"
  L4_2 = "cellphone_text_out"
  L5_2 = 1.0
  L1_2(L2_2, L3_2, L4_2, L5_2)
end
L65_1 = {}
L66_1 = 1
L67_1 = 2
L68_1 = 3
L69_1 = 4
L70_1 = 5
L71_1 = 6
L65_1[1] = L66_1
L65_1[2] = L67_1
L65_1[3] = L68_1
L65_1[4] = L69_1
L65_1[5] = L70_1
L65_1[6] = L71_1
L66_1 = {}
L67_1 = 24
L68_1 = 25
L69_1 = 257
L70_1 = 263
L71_1 = 264
L72_1 = 140
L73_1 = 141
L74_1 = 142
L75_1 = 143
L76_1 = 68
L77_1 = 69
L78_1 = 70
L79_1 = 91
L80_1 = 92
L81_1 = 114
L82_1 = 331
L83_1 = 37
L84_1 = 12
L85_1 = 13
L86_1 = 14
L87_1 = 15
L88_1 = 16
L89_1 = 17
L90_1 = 99
L91_1 = 100
L92_1 = 261
L93_1 = 262
L94_1 = 157
L95_1 = 158
L96_1 = 159
L97_1 = 160
L98_1 = 161
L99_1 = 162
L100_1 = 163
L101_1 = 164
L102_1 = 165
L103_1 = 45
L104_1 = 47
L105_1 = 58
L106_1 = 199
L107_1 = 200
L108_1 = 322
L109_1 = 244
L110_1 = 245
L111_1 = 246
L112_1 = 18
L113_1 = 191
L114_1 = 201
L115_1 = 215
L116_1 = 23
L66_1[1] = L67_1
L66_1[2] = L68_1
L66_1[3] = L69_1
L66_1[4] = L70_1
L66_1[5] = L71_1
L66_1[6] = L72_1
L66_1[7] = L73_1
L66_1[8] = L74_1
L66_1[9] = L75_1
L66_1[10] = L76_1
L66_1[11] = L77_1
L66_1[12] = L78_1
L66_1[13] = L79_1
L66_1[14] = L80_1
L66_1[15] = L81_1
L66_1[16] = L82_1
L66_1[17] = L83_1
L66_1[18] = L84_1
L66_1[19] = L85_1
L66_1[20] = L86_1
L66_1[21] = L87_1
L66_1[22] = L88_1
L66_1[23] = L89_1
L66_1[24] = L90_1
L66_1[25] = L91_1
L66_1[26] = L92_1
L66_1[27] = L93_1
L66_1[28] = L94_1
L66_1[29] = L95_1
L66_1[30] = L96_1
L66_1[31] = L97_1
L66_1[32] = L98_1
L66_1[33] = L99_1
L66_1[34] = L100_1
L66_1[35] = L101_1
L66_1[36] = L102_1
L66_1[37] = L103_1
L66_1[38] = L104_1
L66_1[39] = L105_1
L66_1[40] = L106_1
L66_1[41] = L107_1
L66_1[42] = L108_1
L66_1[43] = L109_1
L66_1[44] = L110_1
L66_1[45] = L111_1
L66_1[46] = L112_1
L66_1[47] = L113_1
L66_1[48] = L114_1
L66_1[49] = L115_1
L66_1[50] = L116_1
L67_1 = 75
L68_1 = 38
L69_1 = 44
L70_1 = 46
L71_1 = 51
L72_1 = 52
L73_1 = 54
L74_1 = 0
L75_1 = 26
L66_1[51] = L67_1
L66_1[52] = L68_1
L66_1[53] = L69_1
L66_1[54] = L70_1
L66_1[55] = L71_1
L66_1[56] = L72_1
L66_1[57] = L73_1
L66_1[58] = L74_1
L66_1[59] = L75_1
L67_1 = {}
L68_1 = 199
L69_1 = 200
L70_1 = 322
L67_1[1] = L68_1
L67_1[2] = L69_1
L67_1[3] = L70_1
L68_1 = 400
L69_1 = 249
L70_1 = false
function L71_1()
  local L0_2, L1_2
  L0_2 = L70_1
  if not L0_2 then
    return
  end
  L0_2 = false
  L70_1 = L0_2
  L0_2 = CameraActive
  if L0_2 then
    L0_2 = CameraActive
    L0_2 = L0_2()
    if L0_2 then
      goto lbl_16
    end
  end
  L0_2 = ReapplyPhoneFocus
  L0_2()
  ::lbl_16::
end
function L72_1()
  local L0_2, L1_2
  L0_2 = IsNuiFocusKeepingInput
  if not L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = IsNuiFocusKeepingInput
  L0_2 = L0_2()
  L1_2 = true == L0_2 or 1 == L0_2
  return L1_2
end
L73_1 = false
L74_1 = 0
function L75_1()
  local L0_2, L1_2
  L0_2 = L73_1
  if L0_2 then
    return
  end
  L0_2 = true
  L73_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    while true do
      L0_3 = PhoneOpen
      if not L0_3 then
        L0_3 = GetGameTimer
        L0_3 = L0_3()
        L1_3 = L74_1
        if not (L0_3 < L1_3) then
          break
        end
      end
      L0_3 = PhoneOpen
      if L0_3 then
        L0_3 = CameraActive
        if L0_3 then
          L0_3 = CameraActive
          L0_3 = L0_3()
        end
        L1_3 = L24_1
        L1_3 = L1_3()
        L2_3 = L70_1
        if L2_3 then
          L2_3 = L23_1
          if not L2_3 and not L0_3 then
            L2_3 = L25_1.on
            if L2_3 then
              goto lbl_32
            end
          end
          L2_3 = L71_1
          L2_3()
        end
        ::lbl_32::
        L2_3 = L23_1
        if L2_3 then
          L2_3 = L72_1
          L2_3 = L2_3()
          if L2_3 then
            L2_3 = SetNuiFocusKeepInput
            L3_3 = false
            L2_3(L3_3)
          end
          L2_3 = DisableAllControlActions
          L3_3 = 0
          L2_3(L3_3)
        elseif not L1_3 then
          L2_3 = L70_1
          if L2_3 then
            L2_3 = DisableAllControlActions
            L3_3 = 0
            L2_3(L3_3)
            L2_3 = EnableControlAction
            L3_3 = 0
            L4_3 = L69_1
            L5_3 = true
            L2_3(L3_3, L4_3, L5_3)
            L2_3 = 1
            L3_3 = L65_1
            L3_3 = #L3_3
            L4_3 = 1
            for L5_3 = L2_3, L3_3, L4_3 do
              L6_3 = EnableControlAction
              L7_3 = 0
              L8_3 = L65_1
              L8_3 = L8_3[L5_3]
              L9_3 = true
              L6_3(L7_3, L8_3, L9_3)
            end
          end
        else
          L2_3 = Config
          L2_3 = L2_3.AllowWalking
          if true ~= L2_3 and not L0_3 then
            L2_3 = DisableAllControlActions
            L3_3 = 0
            L2_3(L3_3)
            L2_3 = EnableControlAction
            L3_3 = 0
            L4_3 = L69_1
            L5_3 = true
            L2_3(L3_3, L4_3, L5_3)
            L2_3 = L70_1
            if L2_3 then
              L2_3 = 1
              L3_3 = L65_1
              L3_3 = #L3_3
              L4_3 = 1
              for L5_3 = L2_3, L3_3, L4_3 do
                L6_3 = EnableControlAction
                L7_3 = 0
                L8_3 = L65_1
                L8_3 = L8_3[L5_3]
                L9_3 = true
                L6_3(L7_3, L8_3, L9_3)
              end
            end
          else
            if not L0_3 then
              L2_3 = L70_1
              if not L2_3 then
                L2_3 = 1
                L3_3 = L65_1
                L3_3 = #L3_3
                L4_3 = 1
                for L5_3 = L2_3, L3_3, L4_3 do
                  L6_3 = DisableControlAction
                  L7_3 = 0
                  L8_3 = L65_1
                  L8_3 = L8_3[L5_3]
                  L9_3 = true
                  L6_3(L7_3, L8_3, L9_3)
                end
              end
            end
            L2_3 = 1
            L3_3 = L66_1
            L3_3 = #L3_3
            L4_3 = 1
            for L5_3 = L2_3, L3_3, L4_3 do
              L6_3 = DisableControlAction
              L7_3 = 0
              L8_3 = L66_1
              L8_3 = L8_3[L5_3]
              L9_3 = true
              L6_3(L7_3, L8_3, L9_3)
            end
          end
        end
        L2_3 = L23_1
        if L2_3 or L1_3 then
          L2_3 = DisablePlayerFiring
          L3_3 = PlayerId
          L3_3 = L3_3()
          L4_3 = true
          L2_3(L3_3, L4_3)
        end
      else
        L0_3 = 1
        L1_3 = L67_1
        L1_3 = #L1_3
        L2_3 = 1
        for L3_3 = L0_3, L1_3, L2_3 do
          L4_3 = DisableControlAction
          L5_3 = 0
          L6_3 = L67_1
          L6_3 = L6_3[L3_3]
          L7_3 = true
          L4_3(L5_3, L6_3, L7_3)
        end
      end
      L0_3 = Wait
      L1_3 = 0
      L0_3(L1_3)
    end
    L0_3 = false
    L73_1 = L0_3
  end
  L0_2(L1_2)
end
L76_1 = type
L77_1 = Config
L77_1 = L77_1.LookKey
L76_1 = L76_1(L77_1)
if "string" == L76_1 then
  L76_1 = Config
  L76_1 = L76_1.LookKey
  if L76_1 then
    goto lbl_228
  end
end
L76_1 = "LMENU"
::lbl_228::
function L77_1()
  local L0_2, L1_2, L2_2
  L0_2 = L70_1
  if not L0_2 then
    L0_2 = PhoneOpen
    if L0_2 then
      L0_2 = L23_1
      if not L0_2 then
        L0_2 = L25_1.on
        if L0_2 then
          goto lbl_15
        end
      end
    end
  end
  L0_2 = false
  do return L0_2 end
  ::lbl_15::
  L0_2 = CameraActive
  if L0_2 then
    L0_2 = CameraActive
    L0_2 = L0_2()
  end
  if not L0_2 then
    L0_2 = OverlayIsOpen
    if L0_2 then
      L0_2 = OverlayIsOpen
      L0_2 = L0_2()
    end
  end
  if L0_2 then
    L0_2 = false
    return L0_2
  end
  L0_2 = true
  L70_1 = L0_2
  L0_2 = SetNuiFocus
  L1_2 = true
  L2_2 = false
  L0_2(L1_2, L2_2)
  L0_2 = SetNuiFocusKeepInput
  L1_2 = true
  L0_2(L1_2)
  L0_2 = true
  return L0_2
end
function L78_1()
  local L0_2, L1_2
  L0_2 = L76_1
  return L0_2
end
PhoneLookKey = L78_1
if "" ~= L76_1 then
  L78_1 = RegisterCommand
  L79_1 = "+apexphone_look"
  function L80_1()
    local L0_2, L1_2
    L0_2 = L77_1
    L0_2()
  end
  L81_1 = false
  L78_1(L79_1, L80_1, L81_1)
  L78_1 = RegisterCommand
  L79_1 = "-apexphone_look"
  function L80_1()
    local L0_2, L1_2
    L0_2 = L71_1
    L0_2()
  end
  L81_1 = false
  L78_1(L79_1, L80_1, L81_1)
  L78_1 = RegisterKeyMapping
  L79_1 = "+apexphone_look"
  L80_1 = Tr
  L81_1 = "Telem\195\179vel: olhar \195\160 volta (manter)"
  L80_1 = L80_1(L81_1)
  L81_1 = "keyboard"
  L82_1 = L76_1
  L78_1(L79_1, L80_1, L81_1, L82_1)
end
L78_1 = RegisterNUICallback
L79_1 = "look"
function L80_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
  L2_2 = L76_1
  if "" == L2_2 then
    return
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.on
    if true == L2_2 then
      L2_2 = L77_1
      L2_2()
  end
  else
    L2_2 = L71_1
    L2_2()
  end
end
L78_1(L79_1, L80_1)
L78_1 = false
function L79_1()
  local L0_2, L1_2
  L0_2 = L78_1
  if L0_2 then
    return
  end
  L0_2 = true
  L78_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3
    while true do
      L0_3 = L7_1
      if not L0_3 then
        break
      end
      L0_3 = PlayerPedId
      L0_3 = L0_3()
      L1_3 = DoesEntityExist
      L2_3 = L0_3
      L1_3 = L1_3(L2_3)
      if L1_3 then
        L1_3 = IsEntityDead
        L2_3 = L0_3
        L1_3 = L1_3(L2_3)
        if not L1_3 then
          L1_3 = GetPedBoneCoords
          L2_3 = L0_3
          L3_3 = 31086
          L4_3 = 0.0
          L5_3 = 0.0
          L6_3 = 0.0
          L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
          L2_3 = L1_3.x
          if 0.0 == L2_3 then
            L2_3 = L1_3.y
            if 0.0 == L2_3 then
              L2_3 = GetEntityCoords
              L3_3 = L0_3
              L2_3 = L2_3(L3_3)
              L3_3 = vector3
              L4_3 = L2_3.x
              L5_3 = L2_3.y
              L6_3 = L2_3.z
              L6_3 = L6_3 + 0.7
              L3_3 = L3_3(L4_3, L5_3, L6_3)
              L1_3 = L3_3
            end
          end
          L2_3 = GetEntityForwardVector
          L3_3 = L0_3
          L2_3 = L2_3(L3_3)
          L3_3 = DrawSpotLightWithShadow
          L4_3 = L1_3.x
          L5_3 = L1_3.y
          L6_3 = L1_3.z
          L7_3 = L2_3.x
          L8_3 = L2_3.y
          L9_3 = L2_3.z
          L9_3 = L9_3 - 0.15
          L10_3 = 255
          L11_3 = 255
          L12_3 = 255
          L13_3 = 35.0
          L14_3 = 3.5
          L15_3 = 0.0
          L16_3 = 13.0
          L17_3 = 1.0
          L18_3 = 0
          L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3)
          L3_3 = GetPedBoneCoords
          L4_3 = L0_3
          L5_3 = 28422
          L6_3 = 0.0
          L7_3 = 0.0
          L8_3 = 0.0
          L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3)
          L4_3 = L3_3.x
          if 0.0 == L4_3 then
            L4_3 = L3_3.y
            if 0.0 == L4_3 then
              L4_3 = vector3
              L5_3 = L1_3.x
              L6_3 = L2_3.x
              L6_3 = L6_3 * 0.4
              L5_3 = L5_3 + L6_3
              L6_3 = L1_3.y
              L7_3 = L2_3.y
              L7_3 = L7_3 * 0.4
              L6_3 = L6_3 + L7_3
              L7_3 = L1_3.z
              L7_3 = L7_3 - 0.3
              L4_3 = L4_3(L5_3, L6_3, L7_3)
              L3_3 = L4_3
            end
          end
          L4_3 = DrawLightWithRange
          L5_3 = L3_3.x
          L6_3 = L3_3.y
          L7_3 = L3_3.z
          L8_3 = 255
          L9_3 = 255
          L10_3 = 255
          L11_3 = 2.5
          L12_3 = 0.9
          L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
        end
      end
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
    L0_3 = false
    L78_1 = L0_3
  end
  L0_2(L1_2)
end
function L80_1(A0_2)
  local L1_2
  if A0_2 then
    L1_2 = true
    if L1_2 then
      goto lbl_7
      A0_2 = L1_2 or A0_2
    end
  end
  A0_2 = false
  ::lbl_7::
  L1_2 = L7_1
  if A0_2 == L1_2 then
    L1_2 = L7_1
    return L1_2
  end
  L7_1 = A0_2
  L1_2 = L7_1
  if L1_2 then
    L1_2 = L79_1
    L1_2()
  end
  L1_2 = L7_1
  return L1_2
end
SetFlashlight = L80_1
function L80_1()
  local L0_2, L1_2
  L0_2 = L7_1
  return L0_2
end
IsFlashlightOn = L80_1
function L80_1()
  local L0_2, L1_2
  L0_2 = Config
  L0_2 = L0_2.RequireItem
  if not L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = L22_1
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = FW
  L0_2 = L0_2.HasItem
  L1_2 = Config
  L1_2 = L1_2.PhoneItem
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 0
  end
  L0_2 = L0_2 > 0
  return L0_2
end
function L81_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if A0_2 then
    L1_2 = TriggerEvent
    L2_2 = "apex_phone:client:opened"
    L3_2 = CurrentDevice
    L1_2(L2_2, L3_2)
  else
    L1_2 = TriggerEvent
    L2_2 = "apex_phone:client:closed"
    L1_2(L2_2)
  end
  L1_2 = TriggerServerEvent
  L2_2 = "apex_phone:server:phoneState"
  L3_2 = A0_2
  L4_2 = CurrentDevice
  L1_2(L2_2, L3_2, L4_2)
end
function L82_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = PhoneOpen
  if L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = OverlayIsOpen
  if L2_2 then
    L2_2 = OverlayIsOpen
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = OverlayReset
      if L2_2 then
        L2_2 = L26_1
        L2_2 = L2_2()
        if not L2_2 then
          L2_2 = print
          L3_2 = "[unique_phone] an overlay (shop/admin panel) was marked open without NUI focus: resetting it"
          L2_2(L3_2)
          L2_2 = OverlayReset
          L2_2()
      end
      else
        L2_2 = false
        return L2_2
      end
    end
  end
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  if A0_2 then
    L2_2 = L9_1
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      A0_2 = nil
    end
  end
  if not A0_2 then
    L2_2 = L22_1
    L2_2 = L2_2()
    A0_2 = L2_2
  end
  L2_2 = Config
  L2_2 = L2_2.BlockWhenDead
  if false ~= L2_2 then
    L2_2 = FW
    L2_2 = L2_2.IsDead
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = A1_2.silent
      if not L2_2 then
        L2_2 = FW
        L2_2 = L2_2.Notify
        L3_2 = "N\195\163o podes usar o telem\195\179vel agora."
        L4_2 = "error"
        L2_2(L3_2, L4_2)
      end
      L2_2 = false
      return L2_2
    end
  end
  L2_2 = L80_1
  L2_2 = L2_2()
  if not L2_2 then
    L3_2 = A1_2.force
    if not L3_2 then
      L3_2 = A1_2.silent
      if not L3_2 then
        L3_2 = FW
        L3_2 = L3_2.Notify
        L4_2 = "N\195\163o tens telem\195\179vel."
        L5_2 = "error"
        L3_2(L4_2, L5_2)
      end
      L3_2 = false
      return L3_2
    end
  end
  L3_2 = DeviceOwnerOpen
  if L3_2 then
    L3_2 = A1_2.devok
    if not L3_2 then
      L3_2 = DeviceOwnerOpen
      L4_2 = A0_2
      L5_2 = A1_2
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        L3_2 = true
        return L3_2
      end
    end
  end
  L3_2 = not L2_2
  L6_1 = L3_2
  CurrentDevice = A0_2
  if A0_2 then
    L21_1 = A0_2
  end
  PhoneOpen = true
  L3_2 = false
  L23_1 = L3_2
  L3_2 = SetPhoneFocus
  L4_2 = true
  L3_2(L4_2)
  L3_2 = SendNUIMessage
  L4_2 = {}
  L4_2.action = "open"
  L5_2 = Config
  L5_2 = L5_2.Scale
  L4_2.scale = L5_2
  L5_2 = Config
  L5_2 = L5_2.Offset
  L4_2.offset = L5_2
  L5_2 = DeviceFrame
  L5_2 = L5_2()
  L4_2.frame = L5_2
  L5_2 = DeviceOS
  L5_2 = L5_2()
  L4_2.os = L5_2
  L5_2 = DeviceModel
  L5_2 = L5_2()
  L4_2.model = L5_2
  L3_2(L4_2)
  L3_2 = PushPlayer
  L3_2()
  L3_2 = L81_1
  L4_2 = true
  L3_2(L4_2)
  L3_2 = L8_1
  L4_2 = "open: device=%s forced=%s"
  L5_2 = tostring
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L6_2 = tostring
  L7_2 = L6_1
  L6_2, L7_2 = L6_2(L7_2)
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = L75_1
  L3_2()
  L3_2 = L28_1
  L3_2()
  L3_2 = L63_1
  L3_2()
  L3_2 = false
  L52_1 = L3_2
  L3_2 = L0_1
  if L3_2 then
    L3_2 = L1_1
    L4_2 = CurrentDevice
    if L3_2 ~= L4_2 then
      L3_2 = L56_1
      L3_2()
    end
  end
  L3_2 = L54_1
  L3_2()
  L3_2 = L39_1
  if L3_2 then
    L3_2 = L51_1
    L4_2 = L53_1
    L4_2, L5_2, L6_2, L7_2 = L4_2()
    L3_2(L4_2, L5_2, L6_2, L7_2)
  end
  L3_2 = PhoneOpen
  if L3_2 then
    L3_2 = L58_1
    L3_2()
  end
  L3_2 = PhoneOpen
  return L3_2
end
OpenPhone = L82_1
function L82_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if false == A0_2 then
    A0_2 = nil
  else
    L2_2 = L9_1
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = false
      return L2_2
    end
  end
  L2_2 = DeviceOwnerSwitch
  if L2_2 and not A1_2 and A0_2 then
    L2_2 = DeviceOwnerSwitch
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = true
      return L2_2
    end
  end
  L2_2 = CurrentDevice
  if L2_2 == A0_2 then
    L2_2 = false
    return L2_2
  end
  CurrentDevice = A0_2
  if A0_2 then
    L21_1 = A0_2
  end
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.action = "frame"
  L4_2 = DeviceFrame
  L4_2 = L4_2()
  L3_2.frame = L4_2
  L4_2 = DeviceOS
  L4_2 = L4_2()
  L3_2.os = L4_2
  L4_2 = DeviceModel
  L4_2 = L4_2()
  L3_2.model = L4_2
  L2_2(L3_2)
  L2_2 = TriggerServerEvent
  L3_2 = "apex_phone:server:phoneState"
  L4_2 = PhoneOpen
  L4_2 = true == L4_2
  L5_2 = A0_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = L56_1
  L2_2()
  L2_2 = L54_1
  L2_2()
  L2_2 = true
  return L2_2
end
SwitchDevice = L82_1
function L82_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = PhoneOpen
  if not L0_2 then
    return
  end
  PhoneOpen = false
  L0_2 = false
  L6_1 = L0_2
  L0_2 = false
  L70_1 = L0_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L1_2 = L68_1
  L0_2 = L0_2 + L1_2
  L74_1 = L0_2
  L0_2 = SetPhoneFocus
  L1_2 = false
  L0_2(L1_2)
  L0_2 = SendNUIMessage
  L1_2 = {}
  L1_2.action = "close"
  L0_2(L1_2)
  L0_2 = L81_1
  L1_2 = false
  L0_2(L1_2)
  L0_2 = L8_1
  L1_2 = "close: device=%s call=%s airpods=%s"
  L2_2 = tostring
  L3_2 = CurrentDevice
  L2_2 = L2_2(L3_2)
  L3_2 = tostring
  L4_2 = L3_1
  L3_2 = L3_2(L4_2)
  L4_2 = tostring
  L5_2 = L37_1
  L5_2 = L5_2()
  L4_2, L5_2 = L4_2(L5_2)
  L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = FW
    L0_3 = L0_3.IsDead
    L0_3 = L0_3()
    if L0_3 then
      L0_3 = StopAnimTask
      L1_3 = PlayerPedId
      L1_3 = L1_3()
      L2_3 = "cellphone@"
      L3_3 = "cellphone_text_in"
      L4_3 = 1.0
      L0_3(L1_3, L2_3, L3_3, L4_3)
    else
      L0_3 = L5_1
      L0_3 = L0_3()
      if L0_3 then
        L0_3 = L37_1
        L0_3 = L0_3()
        if not L0_3 then
          L0_3 = L51_1
          L1_3 = L53_1
          L1_3, L2_3, L3_3, L4_3 = L1_3()
          L0_3(L1_3, L2_3, L3_3, L4_3)
          L0_3 = L59_1
          L0_3()
          return
      end
      else
        L0_3 = L3_1
        if L0_3 then
          L0_3 = L8_1
          L1_3 = "closing during a call with AirBuds: phone goes to the pocket"
          L0_3(L1_3)
        end
        L0_3 = L51_1
        L1_3 = 180.0
        L0_3 = L0_3(L1_3)
        L1_3 = L64_1
        L1_3()
        L1_3 = 400
        if L0_3 > L1_3 then
          L1_3 = Wait
          L2_3 = L0_3 - 400
          L1_3(L2_3)
        end
      end
    end
    L0_3 = L38_1
    L0_3 = L0_3()
    if not L0_3 then
      L0_3 = L56_1
      L0_3()
    end
  end
  L0_2(L1_2)
end
ClosePhone = L82_1
function L82_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  if L0_2 then
    L0_2 = ClosePhone
    L0_2()
  else
    L0_2 = OpenPhone
    L0_2()
  end
end
TogglePhone = L82_1
function L82_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  if A0_2 then
    L1_2 = true
    if L1_2 then
      goto lbl_7
      A0_2 = L1_2 or A0_2
    end
  end
  A0_2 = false
  ::lbl_7::
  L1_2 = L3_1
  if A0_2 == L1_2 then
    return
  end
  L3_1 = A0_2
  if not A0_2 then
    L1_2 = false
    L4_1 = L1_2
  end
  L1_2 = L8_1
  L2_2 = "call prop: %s (open=%s airpods=%s)"
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = tostring
  L5_2 = PhoneOpen
  L4_2 = L4_2(L5_2)
  L5_2 = tostring
  L6_2 = L37_1
  L6_2 = L6_2()
  L5_2, L6_2 = L5_2(L6_2)
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  if A0_2 then
    L1_2 = L63_1
    L1_2()
    L1_2 = PhoneOpen
    if L1_2 then
      return
    end
    L1_2 = CreateThread
    function L2_2()
      local L0_3, L1_3
      L0_3 = FW
      L0_3 = L0_3.IsDead
      L0_3 = L0_3()
      if L0_3 then
        return
      end
      L0_3 = L37_1
      L0_3 = L0_3()
      if L0_3 then
        L0_3 = L8_1
        L1_3 = "call with AirBuds and phone closed: no prop or pose"
        L0_3(L1_3)
        return
      end
      L0_3 = L54_1
      L0_3()
      L0_3 = L39_1
      if L0_3 then
        L0_3 = L51_1
        L1_3 = L53_1
        L1_3 = L1_3()
        L0_3(L1_3)
      end
      L0_3 = L3_1
      if L0_3 then
        L0_3 = PhoneOpen
        if not L0_3 then
          L0_3 = L59_1
          L0_3()
        end
      end
    end
    L1_2(L2_2)
  else
    L1_2 = PhoneOpen
    if not L1_2 then
      L1_2 = CreateThread
      function L2_2()
        local L0_3, L1_3
        L0_3 = L51_1
        L1_3 = 180.0
        L0_3(L1_3)
        L0_3 = L60_1
        L0_3()
        L0_3 = PhoneOpen
        if not L0_3 then
          L0_3 = L5_1
          L0_3 = L0_3()
          if not L0_3 then
            L0_3 = L56_1
            L0_3()
          end
        end
      end
      L1_2(L2_2)
    end
  end
end
PhoneCallProp = L82_1
L82_1 = RegisterNUICallback
L83_1 = "callPose"
function L84_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = A0_2.on
  L2_2 = true == L2_2
  L3_2 = L4_1
  if L2_2 == L3_2 then
    return
  end
  L4_1 = L2_2
  L3_2 = L8_1
  L4_2 = "call pose: %s (open=%s)"
  L5_2 = tostring
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L6_2 = tostring
  L7_2 = PhoneOpen
  L6_2, L7_2 = L6_2(L7_2)
  L3_2(L4_2, L5_2, L6_2, L7_2)
  if L2_2 then
    L3_2 = L63_1
    L3_2()
    L3_2 = CreateThread
    function L4_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
      L0_3 = FW
      L0_3 = L0_3.IsDead
      L0_3 = L0_3()
      if not L0_3 then
        L0_3 = L37_1
        L0_3 = L0_3()
        if not L0_3 then
          L0_3 = L57_1
          L0_3 = L0_3()
          if L0_3 then
            goto lbl_15
          end
        end
      end
      do return end
      ::lbl_15::
      L0_3 = PlayerPedId
      L0_3 = L0_3()
      L1_3 = PhoneOpen
      if L1_3 then
        L1_3 = CameraActive
        if L1_3 then
          L1_3 = CameraActive
          L1_3 = L1_3()
          if L1_3 then
            return
          end
        end
        L1_3 = TaskPlayAnim
        L2_3 = L0_3
        L3_3 = "cellphone@"
        L4_3 = "cellphone_text_to_call"
        L5_3 = 3.0
        L6_3 = 3.0
        L7_3 = -1
        L8_3 = 50
        L9_3 = 0
        L10_3 = false
        L11_3 = false
        L12_3 = false
        L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
        L1_3 = Wait
        L2_3 = 550
        L1_3(L2_3)
        L1_3 = L4_1
        if L1_3 then
          L1_3 = PhoneOpen
          if L1_3 then
            L1_3 = L37_1
            L1_3 = L1_3()
            if not L1_3 then
              L1_3 = StopAnimTask
              L2_3 = L0_3
              L3_3 = "cellphone@"
              L4_3 = "cellphone_text_to_call"
              L5_3 = 1.0
              L1_3(L2_3, L3_3, L4_3, L5_3)
              L1_3 = StopAnimTask
              L2_3 = L0_3
              L3_3 = "cellphone@"
              L4_3 = "cellphone_text_in"
              L5_3 = 1.0
              L1_3(L2_3, L3_3, L4_3, L5_3)
              L1_3 = TaskPlayAnim
              L2_3 = L0_3
              L3_3 = "cellphone@"
              L4_3 = "cellphone_call_listen_base"
              L5_3 = 8.0
              L6_3 = 3.0
              L7_3 = -1
              L8_3 = 49
              L9_3 = 0
              L10_3 = false
              L11_3 = false
              L12_3 = false
              L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
            end
          end
        end
      else
        L1_3 = L0_1
        if not L1_3 then
          L1_3 = L54_1
          L1_3()
        end
        L1_3 = L39_1
        if L1_3 then
          L1_3 = L51_1
          L2_3 = L53_1
          L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L2_3()
          L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
        end
        L1_3 = L59_1
        L1_3()
      end
    end
    L3_2(L4_2)
  else
    L3_2 = CreateThread
    function L4_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
      L0_3 = PlayerPedId
      L0_3 = L0_3()
      L1_3 = PhoneOpen
      if L1_3 then
        L1_3 = IsEntityPlayingAnim
        L2_3 = L0_3
        L3_3 = "cellphone@"
        L4_3 = "cellphone_call_listen_base"
        L5_3 = 3
        L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
        if L1_3 then
          L1_3 = TaskPlayAnim
          L2_3 = L0_3
          L3_3 = "cellphone@"
          L4_3 = "cellphone_call_to_text"
          L5_3 = 3.0
          L6_3 = 3.0
          L7_3 = -1
          L8_3 = 50
          L9_3 = 0
          L10_3 = false
          L11_3 = false
          L12_3 = false
          L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
          L1_3 = Wait
          L2_3 = 550
          L1_3(L2_3)
          L1_3 = StopAnimTask
          L2_3 = L0_3
          L3_3 = "cellphone@"
          L4_3 = "cellphone_call_to_text"
          L5_3 = 1.0
          L1_3(L2_3, L3_3, L4_3, L5_3)
          L1_3 = StopAnimTask
          L2_3 = L0_3
          L3_3 = "cellphone@"
          L4_3 = "cellphone_call_listen_base"
          L5_3 = 1.0
          L1_3(L2_3, L3_3, L4_3, L5_3)
          L1_3 = PhoneOpen
          if L1_3 then
            L1_3 = L4_1
            if not L1_3 then
              L1_3 = TaskPlayAnim
              L2_3 = L0_3
              L3_3 = "cellphone@"
              L4_3 = "cellphone_text_in"
              L5_3 = 8.0
              L6_3 = 3.0
              L7_3 = -1
              L8_3 = 50
              L9_3 = 0
              L10_3 = false
              L11_3 = false
              L12_3 = false
              L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
              L1_3 = SetEntityAnimCurrentTime
              L2_3 = L0_3
              L3_3 = "cellphone@"
              L4_3 = "cellphone_text_in"
              L5_3 = 1.0
              L1_3(L2_3, L3_3, L4_3, L5_3)
            end
          end
        end
      else
        L1_3 = L3_1
        if not L1_3 then
          L1_3 = L51_1
          L2_3 = 180.0
          L1_3(L2_3)
          L1_3 = L60_1
          L1_3()
          L1_3 = PhoneOpen
          if not L1_3 then
            L1_3 = L5_1
            L1_3 = L1_3()
            if not L1_3 then
              L1_3 = L56_1
              L1_3()
            end
          end
        end
      end
    end
    L3_2(L4_2)
  end
end
L82_1(L83_1, L84_1)
L82_1 = AddStateBagChangeHandler
L83_1 = "apex_airpods"
L84_1 = nil
function L85_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = "player:%d"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = GetPlayerServerId
  L6_2 = PlayerId
  L6_2 = L6_2()
  L5_2, L6_2 = L5_2(L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if A0_2 ~= L3_2 then
    return
  end
  L3_2 = true == A2_2
  L4_2 = L36_1
  if L3_2 == L4_2 then
    return
  end
  L36_1 = L3_2
  L4_2 = L3_1
  if L4_2 then
    L4_2 = PhoneOpen
    if not L4_2 then
      goto lbl_27
    end
  end
  do return end
  ::lbl_27::
  L4_2 = L8_1
  L5_2 = "airpods %s mid-call with the phone closed"
  if L3_2 then
    L6_2 = "on"
    if L6_2 then
      goto lbl_35
    end
  end
  L6_2 = "off"
  ::lbl_35::
  L4_2(L5_2, L6_2)
  L4_2 = CreateThread
  function L5_2()
    local L0_3, L1_3
    L0_3 = FW
    L0_3 = L0_3.IsDead
    L0_3 = L0_3()
    if L0_3 then
      return
    end
    L0_3 = L3_2
    if L0_3 then
      L0_3 = L51_1
      L1_3 = 180.0
      L0_3(L1_3)
      L0_3 = L60_1
      L0_3()
      L0_3 = L38_1
      L0_3 = L0_3()
      if not L0_3 then
        L0_3 = L56_1
        L0_3()
      end
    else
      L0_3 = L54_1
      L0_3()
      L0_3 = L3_1
      if L0_3 then
        L0_3 = PhoneOpen
        if not L0_3 then
          L0_3 = L59_1
          L0_3()
        end
      end
    end
  end
  L4_2(L5_2)
end
L82_1(L83_1, L84_1, L85_1)
L82_1 = type
L83_1 = Config
L83_1 = L83_1.KeyCommand
L82_1 = L82_1(L83_1)
if "string" == L82_1 then
  L82_1 = Config
  L82_1 = L82_1.KeyCommand
  if "" ~= L82_1 then
    L82_1 = Config
    L82_1 = L82_1.KeyCommand
    if L82_1 then
      goto lbl_297
    end
  end
end
L82_1 = "apexphone_open"
::lbl_297::
L83_1 = type
L84_1 = Config
L84_1 = L84_1.Command
L83_1 = L83_1(L84_1)
if "string" == L83_1 then
  L83_1 = Config
  L83_1 = L83_1.Command
  if "" ~= L83_1 then
    L83_1 = Config
    L83_1 = L83_1.Command
    if L83_1 then
      goto lbl_312
    end
  end
end
L83_1 = nil
::lbl_312::
L84_1 = {}
L85_1 = "phone"
L86_1 = "apexphone"
L87_1 = "apex_vera"
L84_1[1] = L85_1
L84_1[2] = L86_1
L84_1[3] = L87_1
L85_1 = ipairs
L86_1 = L84_1
L85_1, L86_1, L87_1, L88_1 = L85_1(L86_1)
for L89_1, L90_1 in L85_1, L86_1, L87_1, L88_1 do
  if L90_1 ~= L82_1 and L90_1 ~= L83_1 then
    L91_1 = RegisterCommand
    L92_1 = L90_1
    function L93_1()
      local L0_2, L1_2
    end
    L94_1 = false
    L91_1(L92_1, L93_1, L94_1)
  end
end
L85_1 = RegisterCommand
L86_1 = L82_1
function L87_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  if L0_2 then
    L0_2 = L23_1
    if L0_2 then
      return
    end
  end
  L0_2 = TogglePhone
  L0_2()
end
L88_1 = false
L85_1(L86_1, L87_1, L88_1)
L85_1 = RegisterKeyMapping
L86_1 = L82_1
L87_1 = Tr
L88_1 = "Abrir telem\195\179vel"
L87_1 = L87_1(L88_1)
L88_1 = "keyboard"
L89_1 = Config
L89_1 = L89_1.OpenKey
if not L89_1 then
  L89_1 = "F1"
end
L85_1(L86_1, L87_1, L88_1, L89_1)
if L83_1 and L83_1 ~= L82_1 then
  L85_1 = RegisterCommand
  L86_1 = L83_1
  function L87_1()
    local L0_2, L1_2
    L0_2 = TogglePhone
    L0_2()
  end
  L88_1 = false
  L85_1(L86_1, L87_1, L88_1)
end
L85_1 = CreateThread
function L86_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = Wait
  L1_2 = 3000
  L0_2(L1_2)
  L0_2 = print
  L1_2 = "^5[unique_phone]^7 "
  L2_2 = TrF
  L3_2 = "abrir: tecla %s (comando %s) \194\183 comando de chat: %s \194\183 Vera: %s"
  L4_2 = tostring
  L5_2 = Config
  L5_2 = L5_2.OpenKey
  if not L5_2 then
    L5_2 = "F1"
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L82_1
  L6_2 = L83_1
  if L6_2 then
    L6_2 = "/"
    L7_2 = L83_1
    L6_2 = L6_2 .. L7_2
    if L6_2 then
      goto lbl_27
    end
  end
  L6_2 = Tr
  L7_2 = "nenhum"
  L6_2 = L6_2(L7_2)
  ::lbl_27::
  L7_2 = Config
  L7_2 = L7_2.VeraKey
  if L7_2 then
    L7_2 = Config
    L7_2 = L7_2.VeraKey
    if "" ~= L7_2 then
      L7_2 = TrF
      L8_2 = "tecla %s"
      L9_2 = Config
      L9_2 = L9_2.VeraKey
      L7_2 = L7_2(L8_2, L9_2)
      if L7_2 then
        goto lbl_45
      end
    end
  end
  L7_2 = Tr
  L8_2 = "sem tecla"
  L7_2 = L7_2(L8_2)
  ::lbl_45::
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L1_2 = L1_2 .. L2_2
  L0_2(L1_2)
end
L85_1(L86_1)
function L85_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = Config
    L2_2 = L2_2.Devices
    L2_2 = L2_2[A0_2]
    if L2_2 then
      goto lbl_12
    end
  end
  do return end
  ::lbl_12::
  L2_2 = L8_1
  L3_2 = "use device: %s"
  L4_2 = A0_2
  L2_2(L3_2, L4_2)
  L2_2 = DeviceOwnerUse
  if L2_2 then
    L2_2 = DeviceOwnerUse
    L3_2 = A0_2
    L4_2 = A1_2
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      return
    end
  end
  L2_2 = PhoneOpen
  if not L2_2 then
    L2_2 = OpenPhone
    L3_2 = A0_2
    L2_2(L3_2)
    return
  end
  L2_2 = CurrentDevice
  if L2_2 == A0_2 then
    L2_2 = ClosePhone
    L2_2()
    return
  end
  L2_2 = SwitchDevice
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.Notify
    L3_2 = Config
    L3_2 = L3_2.Devices
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2.label
    L4_2 = "success"
    L2_2(L3_2, L4_2)
  end
end
UseDevice = L85_1
L85_1 = exports
L86_1 = "useDevice"
function L87_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.name
    if L2_2 then
      goto lbl_13
    end
    L2_2 = A0_2.item
    if L2_2 then
      goto lbl_13
    end
  end
  L2_2 = A0_2
  ::lbl_13::
  L3_2 = UseDevice
  L4_2 = L2_2
  L5_2 = type
  L6_2 = A1_2
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = A1_2.slot
    if L5_2 then
      goto lbl_24
    end
  end
  L5_2 = nil
  ::lbl_24::
  L3_2(L4_2, L5_2)
end
L85_1(L86_1, L87_1)
L85_1 = RegisterNetEvent
L86_1 = "apex_phone:client:useDevice"
function L87_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = UseDevice
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L85_1(L86_1, L87_1)
L85_1 = RegisterNetEvent
L86_1 = "apex_phone:client:forceOpen"
function L87_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.sub
    L3_2 = 1
    L4_2 = 64
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      goto lbl_13
      A0_2 = L1_2 or A0_2
    end
  end
  A0_2 = nil
  ::lbl_13::
  if "" == A0_2 then
    A0_2 = nil
  end
  L1_2 = PhoneOpen
  L2_2 = OpenPhone
  L3_2 = nil
  L4_2 = {}
  L4_2.force = true
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    return
  end
  if A0_2 then
    L2_2 = SetTimeout
    if L1_2 then
      L3_2 = 0
      if L3_2 then
        goto lbl_35
      end
    end
    L3_2 = 350
    ::lbl_35::
    function L4_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = PhoneOpen
      if L0_3 then
        L0_3 = Push
        L1_3 = "openApp"
        L2_3 = {}
        L3_3 = A0_2
        L2_3.id = L3_3
        L0_3(L1_3, L2_3)
      end
    end
    L2_2(L3_2, L4_2)
  end
end
L85_1(L86_1, L87_1)
function L85_1()
  local L0_2, L1_2, L2_2
  L0_2 = PhoneOpen
  if not L0_2 then
    L0_2 = OpenPhone
    L0_2 = L0_2()
    if not L0_2 then
      return
    end
  end
  L0_2 = SetTimeout
  L1_2 = 450
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = PhoneOpen
    if L0_3 then
      L0_3 = Push
      L1_3 = "vera"
      L2_3 = {}
      L0_3(L1_3, L2_3)
    end
  end
  L0_2(L1_2, L2_2)
end
L86_1 = RegisterNUICallback
L87_1 = "veraWake"
function L88_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
  L2_2 = PhoneOpen
  if not L2_2 then
    L2_2 = L85_1
    L2_2()
  end
end
L86_1(L87_1, L88_1)
L86_1 = type
L87_1 = Config
L87_1 = L87_1.VeraKey
L86_1 = L86_1(L87_1)
if "string" == L86_1 then
  L86_1 = Config
  L86_1 = L86_1.VeraKey
  if "" ~= L86_1 then
    L86_1 = RegisterCommand
    L87_1 = "apexphone_vera"
    function L88_1()
      local L0_2, L1_2
      L0_2 = L85_1
      L0_2()
    end
    L89_1 = false
    L86_1(L87_1, L88_1, L89_1)
    L86_1 = RegisterKeyMapping
    L87_1 = "apexphone_vera"
    L88_1 = Tr
    L89_1 = "Assistente Vera"
    L88_1 = L88_1(L89_1)
    L89_1 = "keyboard"
    L90_1 = Config
    L90_1 = L90_1.VeraKey
    L86_1(L87_1, L88_1, L89_1, L90_1)
  end
end
L86_1 = RegisterNetEvent
L87_1 = "apex_phone:client:reset"
function L88_1()
  local L0_2, L1_2, L2_2
  L0_2 = PhoneOpen
  if L0_2 then
    L0_2 = ClosePhone
    L0_2()
  end
  L0_2 = SetFlashlight
  L1_2 = false
  L0_2(L1_2)
  L0_2 = Push
  L1_2 = "reset"
  L2_2 = {}
  L0_2(L1_2, L2_2)
end
L86_1(L87_1, L88_1)
L86_1 = false
function L87_1()
  local L0_2, L1_2, L2_2
  L0_2 = L86_1
  if not L0_2 then
    L0_2 = PhoneOpen
    if L0_2 then
      L0_2 = Config
      L0_2 = L0_2.RequireItem
      if L0_2 then
        L0_2 = L6_1
        if not L0_2 then
          goto lbl_15
        end
      end
    end
  end
  do return end
  ::lbl_15::
  L0_2 = true
  L86_1 = L0_2
  L0_2 = SetTimeout
  L1_2 = 250
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = false
    L86_1 = L0_3
    L0_3 = PhoneOpen
    if L0_3 then
      L0_3 = Config
      L0_3 = L0_3.RequireItem
      if L0_3 then
        L0_3 = L6_1
        if not L0_3 then
          goto lbl_14
        end
      end
    end
    do return end
    ::lbl_14::
    L0_3 = CurrentDevice
    if L0_3 then
      L0_3 = FW
      L0_3 = L0_3.HasItem
      L1_3 = CurrentDevice
      L0_3 = L0_3(L1_3)
      if not L0_3 then
        L0_3 = 0
      end
      if L0_3 <= 0 then
        L0_3 = L22_1
        L0_3 = L0_3()
        if L0_3 then
          L1_3 = SwitchDevice
          L2_3 = L0_3
          L1_3(L2_3)
          return
        end
        L1_3 = FW
        L1_3 = L1_3.HasItem
        L2_3 = Config
        L2_3 = L2_3.PhoneItem
        L1_3 = L1_3(L2_3)
        if not L1_3 then
          L1_3 = 0
        end
        if L1_3 > 0 then
          L1_3 = SwitchDevice
          L2_3 = false
          L1_3(L2_3)
          return
        end
      end
    end
    L0_3 = L80_1
    L0_3 = L0_3()
    if L0_3 then
      return
    end
    L0_3 = L8_1
    L1_3 = "lost the phone item: closing"
    L0_3(L1_3)
    L0_3 = ClosePhone
    L0_3()
    L0_3 = FW
    L0_3 = L0_3.Notify
    L1_3 = "Ficaste sem telem\195\179vel."
    L2_3 = "error"
    L0_3(L1_3, L2_3)
  end
  L0_2(L1_2, L2_2)
end
function L88_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
L89_1 = AddEventHandler
L90_1 = "ox_inventory:itemCount"
function L91_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = PhoneOpen
  if L2_2 then
    L2_2 = L88_1
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = tonumber
      L3_2 = A1_2
      L2_2 = L2_2(L3_2)
      if not L2_2 then
        L2_2 = 0
      end
      if L2_2 <= 0 then
        L2_2 = L87_1
        L2_2()
      end
    end
  end
end
L89_1(L90_1, L91_1)
function L89_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Messages
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Messages
    if L0_2 then
      goto lbl_12
    end
  end
  L0_2 = nil
  ::lbl_12::
  if not L0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = L0_2.pageSize
  L1_2.pageSize = L2_2
  L2_2 = L0_2.editWindowMin
  L1_2.editWindowMin = L2_2
  L2_2 = L0_2.deleteForAllMin
  L1_2.deleteForAllMin = L2_2
  L2_2 = L0_2.typingMs
  L1_2.typingMs = L2_2
  L2_2 = type
  L3_2 = L0_2.reactions
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L0_2.reactions
    if L2_2 then
      goto lbl_35
    end
  end
  L2_2 = nil
  ::lbl_35::
  L1_2.reactions = L2_2
  L2_2 = L0_2.maxGroupMembers
  L1_2.maxGroupMembers = L2_2
  return L1_2
end
function L90_1()
  local L0_2, L1_2, L2_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Media
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Media
    if L0_2 then
      goto lbl_12
    end
  end
  L0_2 = nil
  ::lbl_12::
  if not L0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = L0_2.maxImageBytes
  L1_2.maxImageBytes = L2_2
  L2_2 = L0_2.maxAudioSec
  L1_2.maxAudioSec = L2_2
  L2_2 = L0_2.maxAudioBytes
  L1_2.maxAudioBytes = L2_2
  L2_2 = L0_2.chunkBytes
  L1_2.chunkBytes = L2_2
  return L1_2
end
function L91_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Recado
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Recado
    if L0_2 then
      goto lbl_12
    end
  end
  L0_2 = nil
  ::lbl_12::
  if not L0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = type
  L2_2 = L0_2.gif
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = L0_2.gif
    if L1_2 then
      goto lbl_26
    end
  end
  L1_2 = {}
  ::lbl_26::
  L2_2 = {}
  L3_2 = L0_2.enabled
  L3_2 = false ~= L3_2
  L2_2.enabled = L3_2
  L3_2 = L0_2.pinsMax
  L2_2.pinsMax = L3_2
  L3_2 = L0_2.forwardMax
  L2_2.forwardMax = L3_2
  L3_2 = L0_2.multiImageMax
  L2_2.multiImageMax = L3_2
  L3_2 = L0_2.captionMax
  L2_2.captionMax = L3_2
  L3_2 = L0_2.textMax
  L2_2.textMax = L3_2
  L3_2 = L0_2.hdImageBytes
  L2_2.hdImageBytes = L3_2
  L3_2 = type
  L4_2 = L0_2.disappearing
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.disappearing
    if L3_2 then
      goto lbl_55
    end
  end
  L3_2 = nil
  ::lbl_55::
  L2_2.disappearing = L3_2
  L3_2 = L0_2.statusHours
  L2_2.statusHours = L3_2
  L3_2 = L0_2.statusMaxPerDay
  L2_2.statusMaxPerDay = L3_2
  L3_2 = type
  L4_2 = L0_2.polls
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.polls
    if L3_2 then
      goto lbl_69
    end
  end
  L3_2 = nil
  ::lbl_69::
  L2_2.polls = L3_2
  L3_2 = type
  L4_2 = L0_2.events
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.events
    if L3_2 then
      goto lbl_79
    end
  end
  L3_2 = nil
  ::lbl_79::
  L2_2.events = L3_2
  L3_2 = {}
  L4_2 = tostring
  L5_2 = L1_2.provider
  if not L5_2 then
    L5_2 = "none"
  end
  L4_2 = L4_2(L5_2)
  L3_2.provider = L4_2
  L4_2 = L1_2.limit
  L3_2.limit = L4_2
  L2_2.gif = L3_2
  L3_2 = type
  L4_2 = L0_2.channels
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.channels
    if L3_2 then
      goto lbl_101
    end
  end
  L3_2 = nil
  ::lbl_101::
  L2_2.channels = L3_2
  L3_2 = type
  L4_2 = L0_2.communities
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.communities
    if L3_2 then
      goto lbl_111
    end
  end
  L3_2 = nil
  ::lbl_111::
  L2_2.communities = L3_2
  L3_2 = type
  L4_2 = L0_2.calls
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.calls
    if L3_2 then
      goto lbl_121
    end
  end
  L3_2 = nil
  ::lbl_121::
  L2_2.calls = L3_2
  L3_2 = type
  L4_2 = L0_2.stickers
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L0_2.stickers
    if L3_2 then
      goto lbl_131
    end
  end
  L3_2 = nil
  ::lbl_131::
  L2_2.stickers = L3_2
  return L2_2
end
L92_1 = RegisterNUICallback
L93_1 = "ready"
function L94_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = AdminSettingsApply
  if L2_2 then
    L2_2 = pcall
    L3_2 = AdminSettingsApply
    L2_2(L3_2)
  end
  L2_2 = PhoneDefault
  if L2_2 then
    L2_2 = PhoneDefault
    L3_2 = "DefaultLanguage"
    L4_2 = nil
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      goto lbl_18
    end
  end
  L2_2 = Config
  L2_2 = L2_2.DefaultLanguage
  ::lbl_18::
  L3_2 = PhoneDefault
  if L3_2 then
    L3_2 = PhoneDefault
    L4_2 = "DefaultTheme"
    L5_2 = nil
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      goto lbl_29
    end
  end
  L3_2 = Config
  L3_2 = L3_2.DefaultTheme
  ::lbl_29::
  L4_2 = A1_2
  L5_2 = {}
  L5_2.inFiveM = true
  L6_2 = Config
  L6_2 = L6_2.DefaultPin
  L5_2.defaultPin = L6_2
  L6_2 = DeviceFrame
  L6_2 = L6_2()
  L5_2.frame = L6_2
  L6_2 = DeviceOS
  L6_2 = L6_2()
  L5_2.os = L6_2
  L6_2 = DeviceModel
  L6_2 = L6_2()
  L5_2.model = L6_2
  L6_2 = Config
  L6_2 = L6_2.Scale
  L5_2.scale = L6_2
  L6_2 = Config
  L6_2 = L6_2.Offset
  L5_2.offset = L6_2
  L6_2 = Config
  L6_2 = L6_2.PeekSeconds
  if not L6_2 then
    L6_2 = 3
  end
  L5_2.peekSeconds = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.Android
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = Config
    L6_2 = L6_2.Android
    if L6_2 then
      goto lbl_68
    end
  end
  L6_2 = nil
  ::lbl_68::
  L5_2.android = L6_2
  L6_2 = Config
  L6_2 = L6_2.Map
  L5_2.map = L6_2
  L6_2 = Config
  L6_2 = L6_2.POI
  L5_2.poi = L6_2
  L6_2 = Config
  L6_2 = L6_2.Garages
  L5_2.garages = L6_2
  L6_2 = L29_1
  L6_2 = L6_2()
  L5_2.player = L6_2
  L6_2 = Config
  L6_2 = L6_2.Wallpapers
  if not L6_2 then
    L6_2 = {}
  end
  L5_2.wallpapers = L6_2
  L6_2 = FW
  L6_2 = L6_2.name
  L5_2.framework = L6_2
  L6_2 = L7_1
  L5_2.flashlight = L6_2
  L6_2 = Config
  L6_2 = L6_2.FaceId
  L5_2.faceid = L6_2
  L6_2 = Config
  L6_2 = L6_2.Camera
  L5_2.camera = L6_2
  L6_2 = L2_2 or L6_2
  if not L2_2 then
    L6_2 = "en"
  end
  L5_2.defaultLang = L6_2
  L6_2 = L3_2 or L6_2
  if not L3_2 then
    L6_2 = "light"
  end
  L5_2.defaultTheme = L6_2
  L6_2 = PhoneExtraLanguages
  if L6_2 then
    L6_2 = PhoneExtraLanguages
    L6_2 = L6_2()
    if L6_2 then
      goto lbl_115
    end
  end
  L6_2 = nil
  ::lbl_115::
  L5_2.languages = L6_2
  L6_2 = Config
  L6_2 = L6_2.VeraKey
  if not L6_2 then
    L6_2 = ""
  end
  L5_2.veraKey = L6_2
  L6_2 = Config
  L6_2 = L6_2.Debug
  L6_2 = true == L6_2
  L5_2.debug = L6_2
  L6_2 = GetSafeZoneSize
  L6_2 = L6_2()
  L5_2.safeZone = L6_2
  L6_2 = {}
  L7_2 = Config
  L7_2 = L7_2.PinLock
  if false == L7_2 then
    L7_2 = 0
    if L7_2 then
      goto lbl_158
    end
  end
  L7_2 = tonumber
  L8_2 = type
  L9_2 = Config
  L9_2 = L9_2.PinLock
  L8_2 = L8_2(L9_2)
  L8_2 = Config
  L8_2 = L8_2.PinLock
  L8_2 = "table" == L8_2 and L8_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 5
  end
  ::lbl_158::
  L6_2.attempts = L7_2
  L5_2.pinLock = L6_2
  L6_2 = Config
  L6_2 = L6_2.AllowWalking
  L6_2 = true == L6_2
  L5_2.allowWalking = L6_2
  L6_2 = Config
  L6_2 = L6_2.ShowCursor
  L6_2 = false ~= L6_2
  L5_2.showCursor = L6_2
  L6_2 = PhoneLookKey
  if L6_2 then
    L6_2 = PhoneLookKey
    L6_2 = L6_2()
    if L6_2 then
      goto lbl_182
    end
  end
  L6_2 = ""
  ::lbl_182::
  L5_2.lookKey = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.WorldSounds
  L6_2 = L6_2(L7_2)
  L6_2 = "table" == L6_2
  L5_2.worldSounds = L6_2
  L6_2 = {}
  L7_2 = type
  L8_2 = Config
  L8_2 = L8_2.AirPods
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = Config
    L7_2 = L7_2.AirPods
    L7_2 = L7_2.name
    if L7_2 then
      goto lbl_211
    end
  end
  L7_2 = "AirBuds"
  ::lbl_211::
  L6_2.name = L7_2
  L7_2 = type
  L8_2 = Config
  L8_2 = L8_2.AirPods
  L7_2 = L7_2(L8_2)
  L7_2 = "table" ~= L7_2
  L6_2.pauseWithoutAirpods = L7_2
  L5_2.airpods = L6_2
  L6_2 = L89_1
  L6_2 = L6_2()
  L5_2.messages = L6_2
  L6_2 = L90_1
  L6_2 = L6_2()
  L5_2.media = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.Mail
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = {}
    L7_2 = Config
    L7_2 = L7_2.Mail
    L7_2 = L7_2.maxAttachments
    L6_2.maxAttachments = L7_2
    L7_2 = Config
    L7_2 = L7_2.Mail
    L7_2 = L7_2.draftsMax
    L6_2.draftsMax = L7_2
    if L6_2 then
      goto lbl_252
    end
  end
  L6_2 = nil
  ::lbl_252::
  L5_2.mail = L6_2
  L6_2 = L91_1
  L6_2 = L6_2()
  L5_2.recado = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.NumberPrefix
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L6_2 = Config
    L6_2 = L6_2.NumberPrefix
    if L6_2 then
      goto lbl_267
    end
  end
  L6_2 = ""
  ::lbl_267::
  L5_2.numberPrefix = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.Currency
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = Config
    L6_2 = L6_2.Currency
    if L6_2 then
      goto lbl_279
    end
  end
  L6_2 = nil
  ::lbl_279::
  L5_2.currency = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.WallpaperLinks
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = Config
    L6_2 = L6_2.WallpaperLinks
    if L6_2 then
      goto lbl_291
    end
  end
  L6_2 = nil
  ::lbl_291::
  L5_2.wallpaperLinks = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.PhotoLinks
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = Config
    L6_2 = L6_2.PhotoLinks
    if L6_2 then
      goto lbl_313
    end
  end
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.WallpaperLinks
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = Config
    L6_2 = L6_2.WallpaperLinks
    if L6_2 then
      goto lbl_313
    end
  end
  L6_2 = nil
  ::lbl_313::
  L5_2.photoLinks = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.Browser
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = {}
    L7_2 = Config
    L7_2 = L7_2.Browser
    L7_2 = L7_2.enabled
    L7_2 = false ~= L7_2
    L6_2.enabled = L7_2
    L7_2 = Config
    L7_2 = L7_2.Browser
    L7_2 = L7_2.allow
    L6_2.allow = L7_2
    L7_2 = Config
    L7_2 = L7_2.Browser
    L7_2 = L7_2.search
    L6_2.search = L7_2
    L7_2 = Config
    L7_2 = L7_2.Browser
    L7_2 = L7_2.sites
    L6_2.sites = L7_2
    if L6_2 then
      goto lbl_345
    end
  end
  L6_2 = nil
  ::lbl_345::
  L5_2.safari = L6_2
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.AI
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = {}
    L7_2 = Config
    L7_2 = L7_2.AI
    L7_2 = L7_2.enabled
    L7_2 = false ~= L7_2
    L6_2.enabled = L7_2
    L7_2 = Config
    L7_2 = L7_2.AI
    L7_2 = L7_2.name
    L6_2.name = L7_2
    L7_2 = type
    L8_2 = Config
    L8_2 = L8_2.AI
    L8_2 = L8_2.voice
    L7_2 = L7_2(L8_2)
    L7_2 = "table" ~= L7_2
    L6_2.wake = L7_2
    L7_2 = type
    L8_2 = Config
    L8_2 = L8_2.AI
    L8_2 = L8_2.voice
    L7_2 = L7_2(L8_2)
    L7_2 = "table" == L7_2
    L6_2.wakeClosed = L7_2
    if L6_2 then
      goto lbl_401
    end
  end
  L6_2 = nil
  ::lbl_401::
  L5_2.ai = L6_2
  L4_2(L5_2)
  L4_2 = SetTimeout
  L5_2 = 600
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = pairs
    L1_3 = RegisteredApps
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
    for L4_3, L5_3 in L0_3, L1_3, L2_3, L3_3 do
      L6_3 = Push
      L7_3 = "registerApp"
      L8_3 = L5_3
      L6_3(L7_3, L8_3)
    end
    L0_3 = Push
    L1_3 = "gameTime"
    L2_3 = {}
    L3_3 = GetClockHours
    L3_3 = L3_3()
    L2_3.hour = L3_3
    L0_3(L1_3, L2_3)
    L0_3 = PushWeather
    if L0_3 then
      L0_3 = PushWeather
      L1_3 = true
      L0_3(L1_3)
    end
  end
  L4_2(L5_2, L6_2)
end
L92_1(L93_1, L94_1)
L92_1 = RegisterNUICallback
L93_1 = "close"
function L94_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = ClosePhone
  L2_2()
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L92_1(L93_1, L94_1)
L92_1 = RegisterNUICallback
L93_1 = "typing"
function L94_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = "table" == L2_2
  L3_2 = L23_1
  if L2_2 ~= L3_2 then
    L23_1 = L2_2
    L3_2 = PhoneOpen
    if L3_2 then
      L3_2 = L24_1
      L3_2 = L3_2()
      if L3_2 then
        L3_2 = CameraActive
        if L3_2 then
          L3_2 = CameraActive
          L3_2 = L3_2()
          if L3_2 then
            goto lbl_32
          end
        end
        L3_2 = SetPhoneFocus
        L4_2 = true
        L3_2(L4_2)
      end
    end
  end
  ::lbl_32::
  L3_2 = A1_2
  L4_2 = "ok"
  L3_2(L4_2)
end
L92_1(L93_1, L94_1)
L92_1 = RegisterNUICallback
L93_1 = "rpc"
function L94_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = ServerRpc
  L3_2 = A0_2.name
  L4_2 = A0_2.data
  function L5_2(A0_3)
    local L1_3, L2_3
    if nil == A0_3 then
      L1_3 = A1_2
      L2_3 = false
      L1_3(L2_3)
    else
      L1_3 = A1_2
      L2_3 = A0_3
      L1_3(L2_3)
    end
  end
  L2_2(L3_2, L4_2, L5_2)
end
L92_1(L93_1, L94_1)
L92_1 = RegisterNUICallback
L93_1 = "notify"
function L94_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = FW
  L2_2 = L2_2.Notify
  L3_2 = A0_2.message
  if not L3_2 then
    L3_2 = ""
  end
  L4_2 = A0_2.type
  if not L4_2 then
    L4_2 = "primary"
  end
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L92_1(L93_1, L94_1)
L92_1 = 0
function L93_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = PhoneLangInfo
  if L1_2 then
    L1_2 = PhoneLangInfo
    L1_2 = L1_2()
    if L1_2 then
      goto lbl_10
    end
  end
  L1_2 = {}
  ::lbl_10::
  L2_2 = print
  L3_2 = "[unique_phone] language: in-game texts = %s (from %s) | saved on this client = %s | config.lua DefaultLanguage = %s | effective default (admin panel wins) = %s | the phone last said = %s%s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = tostring
  L6_2 = L1_2.lang
  L5_2 = L5_2(L6_2)
  L6_2 = tostring
  L7_2 = L1_2.source
  L6_2 = L6_2(L7_2)
  L7_2 = tostring
  L8_2 = L1_2.saved
  L7_2 = L7_2(L8_2)
  L8_2 = tostring
  L9_2 = L1_2.fileDefault
  L8_2 = L8_2(L9_2)
  L9_2 = tostring
  L10_2 = L1_2.effectiveDefault
  L9_2 = L9_2(L10_2)
  L10_2 = tostring
  L11_2 = L1_2.reported
  L10_2 = L10_2(L11_2)
  if A0_2 then
    L11_2 = ""
    if L11_2 then
      goto lbl_37
    end
  end
  L11_2 = " (the phone did not answer: is it open? reopen it and run /phonelang again)"
  ::lbl_37::
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
end
L94_1 = RegisterNUICallback
L95_1 = "lang"
function L96_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = SetPhoneLang
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.code
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  L2_2(L3_2)
  L2_2 = L92_1
  if L2_2 > 0 then
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L3_2 = L92_1
    L2_2 = L2_2 - L3_2
    L3_2 = 3000
    if L2_2 < L3_2 then
      L2_2 = 0
      L92_1 = L2_2
      L2_2 = L93_1
      L3_2 = true
      L2_2(L3_2)
    end
  end
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L94_1(L95_1, L96_1)
L94_1 = RegisterCommand
L95_1 = "phonelang"
function L96_1()
  local L0_2, L1_2, L2_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L92_1 = L0_2
  L0_2 = Push
  L1_2 = "lang:report"
  L0_2(L1_2)
  L0_2 = SetTimeout
  L1_2 = 1500
  function L2_2()
    local L0_3, L1_3
    L0_3 = L92_1
    if L0_3 > 0 then
      L0_3 = 0
      L92_1 = L0_3
      L0_3 = L93_1
      L1_3 = false
      L0_3(L1_3)
    end
  end
  L0_2(L1_2, L2_2)
end
L97_1 = false
L94_1(L95_1, L96_1, L97_1)
L94_1 = RegisterNUICallback
L95_1 = "flashlight"
function L96_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = SetFlashlight
  L3_2 = A0_2 or L3_2
  if A0_2 then
    L3_2 = A0_2.on
  end
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L4_2 = L7_1
  L3_2.on = L4_2
  L2_2(L3_2)
end
L94_1(L95_1, L96_1)
function L94_1()
  local L0_2, L1_2, L2_2
  L0_2 = GetVehiclePedIsIn
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  L2_2 = false
  L0_2 = L0_2(L1_2, L2_2)
  if 0 ~= L0_2 then
    L1_2 = NetworkGetEntityIsNetworked
    L2_2 = L0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_16
    end
  end
  L1_2 = nil
  L2_2 = L0_2
  do return L1_2, L2_2 end
  ::lbl_16::
  L1_2 = NetworkGetNetworkIdFromEntity
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L0_2
  return L1_2, L2_2
end
L95_1 = {}
L96_1 = 0
L97_1 = RegisterNetEvent
L98_1 = "apex_carplay:rpcResult"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A0_2
    L2_2 = A0_2.sub
    L4_2 = 1
    L5_2 = 3
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if "ph:" == L2_2 then
      goto lbl_13
    end
  end
  do return end
  ::lbl_13::
  L2_2 = L95_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    return
  end
  L3_2 = L95_1
  L3_2[A0_2] = nil
  if nil == A1_2 then
    L3_2 = {}
    L3_2.error = "empty"
    A1_2 = L3_2
  end
  L3_2 = L2_2.cb
  L4_2 = A1_2
  L3_2(L4_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "carplayRpc"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = GetResourceState
  L3_2 = "apex_carplay"
  L2_2 = L2_2(L3_2)
  if "started" ~= L2_2 then
    L2_2 = A1_2
    L3_2 = {}
    L3_2.error = "nocarplay"
    L2_2(L3_2)
    return
  end
  L2_2 = L96_1
  L2_2 = L2_2 + 1
  L96_1 = L2_2
  L2_2 = "ph:%d"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = L96_1
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L95_1
  L4_2 = {}
  L4_2.cb = A1_2
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L4_2.t = L5_2
  L3_2[L2_2] = L4_2
  L3_2 = type
  L4_2 = A0_2.args
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.args
    if L3_2 then
      goto lbl_43
    end
  end
  L3_2 = {}
  ::lbl_43::
  L4_2 = tonumber
  L5_2 = A0_2.n
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = #L3_2
  end
  L5_2 = TriggerServerEvent
  L6_2 = "apex_carplay:rpc"
  L7_2 = tostring
  L8_2 = A0_2.name
  if not L8_2 then
    L8_2 = ""
  end
  L7_2 = L7_2(L8_2)
  L8_2 = L2_2
  L9_2 = table
  L9_2 = L9_2.unpack
  L10_2 = L3_2
  L11_2 = 1
  L12_2 = L4_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2)
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2 = SetTimeout
  L6_2 = 15000
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = L2_2
    L0_3 = L95_1
    L0_3 = L0_3[L1_3]
    if L0_3 then
      L2_3 = L2_2
      L1_3 = L95_1
      L1_3[L2_3] = nil
      L1_3 = print
      L2_3 = "^3[unique_phone] music: %s no response from apex_carplay in 15 s^7"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = tostring
      L5_3 = A0_2.name
      L4_3, L5_3 = L4_3(L5_3)
      L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3, L4_3, L5_3)
      L1_3(L2_3, L3_3, L4_3, L5_3)
      L1_3 = L0_3.cb
      L2_3 = {}
      L2_3.error = "timeout"
      L1_3(L2_3)
    end
  end
  L5_2(L6_2, L7_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "musicCarState"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L94_1
  L2_2 = L2_2()
  L3_2 = A1_2
  L4_2 = {}
  L5_2 = GetResourceState
  L6_2 = "apex_carplay"
  L5_2 = L5_2(L6_2)
  L5_2 = "started" == L5_2
  L4_2.carplay = L5_2
  L5_2 = nil ~= L2_2
  L4_2.inCar = L5_2
  L3_2(L4_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "musicCar"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = GetResourceState
  L3_2 = "apex_carplay"
  L2_2 = L2_2(L3_2)
  if "started" ~= L2_2 then
    L2_2 = A1_2
    L3_2 = {}
    L3_2.ok = false
    L3_2.err = "nocarplay"
    L2_2(L3_2)
    return
  end
  L2_2 = L94_1
  L2_2, L3_2 = L2_2()
  if not L2_2 then
    L4_2 = A1_2
    L5_2 = {}
    L5_2.ok = false
    if 0 == L3_2 then
      L6_2 = "nocar"
      if L6_2 then
        goto lbl_32
      end
    end
    L6_2 = "nonet"
    ::lbl_32::
    L5_2.err = L6_2
    L4_2(L5_2)
    return
  end
  L4_2 = SetVehRadioStation
  L5_2 = L3_2
  L6_2 = "OFF"
  L4_2(L5_2, L6_2)
  L4_2 = TriggerServerEvent
  L5_2 = "apex_carplay:mx:play"
  L6_2 = L2_2
  L7_2 = tostring
  L8_2 = A0_2.src
  if not L8_2 then
    L8_2 = ""
  end
  L7_2 = L7_2(L8_2)
  L8_2 = tostring
  L9_2 = A0_2.title
  if not L9_2 then
    L9_2 = ""
  end
  L8_2 = L8_2(L9_2)
  L9_2 = tostring
  L10_2 = A0_2.artist
  if not L10_2 then
    L10_2 = ""
  end
  L9_2 = L9_2(L10_2)
  L10_2 = A0_2.img
  if L10_2 then
    L10_2 = tostring
    L11_2 = A0_2.img
    L10_2 = L10_2(L11_2)
    if L10_2 then
      goto lbl_69
    end
  end
  L10_2 = nil
  ::lbl_69::
  L11_2 = tonumber
  L12_2 = A0_2.len
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = 0
  end
  L12_2 = tonumber
  L13_2 = A0_2.vol
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 60
  end
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = A1_2
  L5_2 = {}
  L5_2.ok = true
  L5_2.netId = L2_2
  L4_2(L5_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "musicCarStop"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L94_1
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = TriggerServerEvent
    L4_2 = "apex_carplay:mx:stop"
    L5_2 = L2_2
    L3_2(L4_2, L5_2)
  end
  L3_2 = A1_2
  L4_2 = "ok"
  L3_2(L4_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "musicCarSeek"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L94_1
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = TriggerServerEvent
    L4_2 = "apex_carplay:mx:seek"
    L5_2 = L2_2
    L6_2 = tonumber
    L7_2 = A0_2 or L7_2
    if A0_2 then
      L7_2 = A0_2.pos
    end
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 0
    end
    L7_2 = not A0_2
    L3_2(L4_2, L5_2, L6_2, L7_2)
  end
  L3_2 = A1_2
  L4_2 = "ok"
  L3_2(L4_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "musicCarVol"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L94_1
  L2_2 = L2_2()
  if L2_2 then
    L3_2 = TriggerServerEvent
    L4_2 = "apex_carplay:mx:vol"
    L5_2 = L2_2
    L6_2 = tonumber
    L7_2 = A0_2 or L7_2
    if A0_2 then
      L7_2 = A0_2.vol
    end
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 60
    end
    L3_2(L4_2, L5_2, L6_2)
  end
  L3_2 = A1_2
  L4_2 = "ok"
  L3_2(L4_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "jsError"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = print
  L3_2 = "^1[unique_phone] JS: %s^7"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = tostring
  if A0_2 then
    L6_2 = A0_2.msg
    if L6_2 then
      goto lbl_11
    end
  end
  L6_2 = "?"
  ::lbl_11::
  L5_2, L6_2 = L5_2(L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "playAnim"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "openExternal"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "homeToggle"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerEvent
  L3_2 = "apex_phone:client:homeToggle"
  L4_2 = A0_2
  L2_2(L3_2, L4_2)
  L2_2 = TriggerServerEvent
  L3_2 = "apex_phone:server:homeToggle"
  L4_2 = A0_2
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "homeAccess"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerServerEvent
  L3_2 = "apex_phone:server:homeAccess"
  L4_2 = A0_2
  L2_2(L3_2, L4_2)
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L97_1(L98_1, L99_1)
L97_1 = RegisterNUICallback
L98_1 = "houseKey"
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = GetResourceState
  L3_2 = "qb-houses"
  L2_2 = L2_2(L3_2)
  if "started" ~= L2_2 then
    L2_2 = A1_2
    L3_2 = {}
    L3_2.error = "off"
    L2_2(L3_2)
    return
  end
  L2_2 = type
  L3_2 = A0_2.house
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = A0_2.house
    L3_2 = L2_2
    L2_2 = L2_2.sub
    L4_2 = 1
    L5_2 = 64
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      goto lbl_35
    end
  end
  L2_2 = nil
  ::lbl_35::
  if not L2_2 then
    L3_2 = A1_2
    L4_2 = {}
    L4_2.error = "invalid"
    L3_2(L4_2)
    return
  end
  L3_2 = A0_2.action
  if "give" == L3_2 then
    L3_2 = tonumber
    L4_2 = A0_2.target
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L4_2 = A1_2
      L5_2 = {}
      L5_2.error = "invalid"
      L4_2(L5_2)
      return
    end
    L4_2 = TriggerServerEvent
    L5_2 = "qb-houses:server:giveHouseKey"
    L6_2 = L3_2
    L7_2 = L2_2
    L4_2(L5_2, L6_2, L7_2)
  else
    L3_2 = A0_2.action
    if "remove" == L3_2 then
      L3_2 = TriggerServerEvent
      L4_2 = "qb-houses:server:removeHouseKey"
      L5_2 = L2_2
      L6_2 = {}
      L7_2 = tostring
      L8_2 = A0_2.cid
      if not L8_2 then
        L8_2 = ""
      end
      L7_2 = L7_2(L8_2)
      L6_2.citizenid = L7_2
      L7_2 = tostring
      L8_2 = A0_2.firstname
      if not L8_2 then
        L8_2 = ""
      end
      L7_2 = L7_2(L8_2)
      L6_2.firstname = L7_2
      L7_2 = tostring
      L8_2 = A0_2.lastname
      if not L8_2 then
        L8_2 = ""
      end
      L7_2 = L7_2(L8_2)
      L6_2.lastname = L7_2
      L3_2(L4_2, L5_2, L6_2)
    else
      L3_2 = A1_2
      L4_2 = {}
      L4_2.error = "invalid"
      L3_2(L4_2)
      return
    end
  end
  L3_2 = A1_2
  L4_2 = "ok"
  L3_2(L4_2)
end
L97_1(L98_1, L99_1)
L97_1 = {}
L98_1 = "EXTRASUNNY"
L99_1 = "CLEAR"
L100_1 = "NEUTRAL"
L101_1 = "SMOG"
L102_1 = "FOGGY"
L103_1 = "OVERCAST"
L104_1 = "CLOUDS"
L105_1 = "CLEARING"
L106_1 = "RAIN"
L107_1 = "THUNDER"
L108_1 = "SNOW"
L109_1 = "BLIZZARD"
L110_1 = "SNOWLIGHT"
L111_1 = "XMAS"
L112_1 = "HALLOWEEN"
L97_1[1] = L98_1
L97_1[2] = L99_1
L97_1[3] = L100_1
L97_1[4] = L101_1
L97_1[5] = L102_1
L97_1[6] = L103_1
L97_1[7] = L104_1
L97_1[8] = L105_1
L97_1[9] = L106_1
L97_1[10] = L107_1
L97_1[11] = L108_1
L97_1[12] = L109_1
L97_1[13] = L110_1
L97_1[14] = L111_1
L97_1[15] = L112_1
L98_1 = {}
L99_1 = ipairs
L100_1 = L97_1
L99_1, L100_1, L101_1, L102_1 = L99_1(L100_1)
for L103_1, L104_1 in L99_1, L100_1, L101_1, L102_1 do
  L105_1 = GetHashKey
  L106_1 = L104_1
  L105_1 = L105_1(L106_1)
  L98_1[L105_1] = L104_1
  L106_1 = L105_1 & 4294967295
  L98_1[L106_1] = L104_1
end
L99_1 = nil
L100_1 = false
function L101_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = pcall
  L1_2 = GetWeatherTypeTransition
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  if not L0_2 then
    L4_2 = L99_1
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = 0.5
  L4_2 = L2_2 or L4_2
  if not (L4_2 >= L5_2) or not L2_2 then
    L4_2 = L1_2
  end
  L5_2 = L98_1
  L5_2 = L5_2[L4_2]
  if not L5_2 then
    L5_2 = L98_1
    L5_2 = L5_2[L1_2]
    if not L5_2 then
      L5_2 = L99_1
    end
  end
  return L5_2
end
function L102_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L101_1
  L1_2 = L1_2()
  if not L1_2 then
    return
  end
  if not A0_2 then
    L2_2 = L99_1
    if L1_2 == L2_2 then
      goto lbl_23
    end
  end
  L99_1 = L1_2
  L2_2 = Push
  L3_2 = "weather"
  L4_2 = {}
  L4_2.w = L1_2
  L5_2 = L100_1
  L4_2.blackout = L5_2
  L5_2 = GetClockHours
  L5_2 = L5_2()
  L4_2.hour = L5_2
  L2_2(L3_2, L4_2)
  ::lbl_23::
end
PushWeather = L102_1
L103_1 = RegisterNetEvent
L104_1 = "qb-weathersync:client:SyncWeather"
function L105_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 and "" ~= A0_2 then
    L3_2 = A0_2
    L2_2 = A0_2.upper
    L2_2 = L2_2(L3_2)
    L99_1 = L2_2
  end
  L2_2 = true == A1_2
  L100_1 = L2_2
  L2_2 = L99_1
  if L2_2 then
    L2_2 = Push
    L3_2 = "weather"
    L4_2 = {}
    L5_2 = L99_1
    L4_2.w = L5_2
    L5_2 = L100_1
    L4_2.blackout = L5_2
    L5_2 = GetClockHours
    L5_2 = L5_2()
    L4_2.hour = L5_2
    L2_2(L3_2, L4_2)
  end
end
L103_1(L104_1, L105_1)
L103_1 = RegisterNetEvent
L104_1 = "apex_phone:client:push"
function L105_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if "incomingCall" == A0_2 then
    L2_2 = Config
    L2_2 = L2_2.AutoOpenOnCall
    if L2_2 then
      L2_2 = PhoneOpen
      if not L2_2 then
        L2_2 = Citizen
        L2_2 = L2_2.CreateThreadNow
        if not L2_2 then
          L2_2 = CreateThread
        end
        L3_2 = L2_2
        function L4_2()
          local L0_3, L1_3, L2_3
          L0_3 = OpenPhone
          L1_3 = nil
          L2_3 = {}
          L2_3.silent = true
          L0_3(L1_3, L2_3)
        end
        L3_2(L4_2)
      end
    end
  end
  if "session" == A0_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = FW
      L2_2 = L2_2.SetSession
      if L2_2 then
        L2_2 = FW
        L2_2 = L2_2.SetSession
        L3_2 = A1_2.citizenid
        L2_2(L3_2)
      end
    end
  end
  L2_2 = Push
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L103_1(L104_1, L105_1)
L103_1 = FW
L103_1 = L103_1.OnPlayerLoaded
function L104_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = Wait
  L1_2 = 1500
  L0_2(L1_2)
  L0_2 = FW
  L0_2 = L0_2.GetPlayerData
  L0_2 = L0_2()
  L0_2 = L0_2.cid
  if L0_2 then
    L1_2 = Push
    L2_2 = "session"
    L3_2 = {}
    L3_2.citizenid = L0_2
    L1_2(L2_2, L3_2)
  end
  L1_2 = PushPlayer
  L1_2()
end
L103_1(L104_1)
L103_1 = FW
L103_1 = L103_1.OnMoneyChange
function L104_1()
  local L0_2, L1_2
  L0_2 = PushPlayer
  L0_2()
end
L103_1(L104_1)
L103_1 = FW
L103_1 = L103_1.OnJobUpdate
function L104_1()
  local L0_2, L1_2
  L0_2 = PushPlayer
  L0_2()
end
L103_1(L104_1)
L103_1 = FW
L103_1 = L103_1.OnDataChange
function L104_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  if not L0_2 then
    return
  end
  L0_2 = PushPlayer
  L0_2()
  L0_2 = L87_1
  L0_2()
end
L103_1(L104_1)
L103_1 = FW
L103_1 = L103_1.OnPlayerUnload
function L104_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  if L0_2 then
    L0_2 = ClosePhone
    L0_2()
  end
  L0_2 = PhoneCallProp
  L1_2 = false
  L0_2(L1_2)
  L0_2 = SetFlashlight
  L1_2 = false
  L0_2(L1_2)
  L0_2 = L56_1
  L0_2()
end
L103_1(L104_1)
function L103_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = ServerRpc
  L2_2 = "airpods.wear"
  L3_2 = {}
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = A0_2 or L4_2
  if "string" ~= L4_2 or not A0_2 then
    L4_2 = Config
    L4_2 = L4_2.EarbudsItem
  end
  L3_2.item = L4_2
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    if not A0_3 then
      return
    end
    L1_3 = A0_3.error
    if L1_3 then
      L1_3 = A0_3.error
      if "noitem" == L1_3 then
        L1_3 = FW
        L1_3 = L1_3.Notify
        L2_3 = "N\195\163o tens esses auriculares."
        L3_3 = "error"
        L1_3(L2_3, L3_3)
      end
      return
    end
    L1_3 = A0_3.worn
    if L1_3 then
      L1_3 = FW
      L1_3 = L1_3.Notify
      L2_3 = "%s colocados"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = A0_3.name
      if not L4_3 then
        L4_3 = "AirBuds"
      end
      L2_3 = L2_3(L3_3, L4_3)
      L3_3 = "success"
      L1_3(L2_3, L3_3)
      L1_3 = PhoneOpen
      if not L1_3 then
        L1_3 = OpenPhone
        L2_3 = nil
        L3_3 = {}
        L3_3.silent = true
        L1_3(L2_3, L3_3)
      end
      L1_3 = SetTimeout
      L2_3 = PhoneOpen
      if L2_3 then
        L2_3 = 300
        if L2_3 then
          goto lbl_47
        end
      end
      L2_3 = 0
      ::lbl_47::
      function L3_3()
        local L0_4, L1_4, L2_4
        L0_4 = Push
        L1_4 = "earbuds"
        L2_4 = A0_3
        L0_4(L1_4, L2_4)
      end
      L1_3(L2_3, L3_3)
    else
      L1_3 = FW
      L1_3 = L1_3.Notify
      L2_3 = "%s guardados"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = A0_3.name
      if not L4_3 then
        L4_3 = "AirBuds"
      end
      L2_3 = L2_3(L3_3, L4_3)
      L3_3 = "primary"
      L1_3(L2_3, L3_3)
      L1_3 = Push
      L2_3 = "earbuds"
      L3_3 = A0_3
      L1_3(L2_3, L3_3)
    end
  end
  L1_2(L2_2, L3_2, L4_2)
end
L104_1 = RegisterNetEvent
L105_1 = "apex_phone:client:earbuds"
function L106_1(A0_2)
  local L1_2, L2_2
  L1_2 = L103_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L104_1(L105_1, L106_1)
L104_1 = exports
L105_1 = "useEarbuds"
function L106_1()
  local L0_2, L1_2
  L0_2 = L103_1
  L1_2 = Config
  L1_2 = L1_2.EarbudsItem
  L0_2(L1_2)
end
L104_1(L105_1, L106_1)
L104_1 = exports
L105_1 = "useSlateBuds"
function L106_1()
  local L0_2, L1_2, L2_2
  L0_2 = L103_1
  L1_2 = type
  L2_2 = Config
  L2_2 = L2_2.SlateBuds
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = Config
    L1_2 = L1_2.SlateBuds
    L1_2 = L1_2.item
    if L1_2 then
      goto lbl_14
    end
  end
  L1_2 = "slate_buds"
  ::lbl_14::
  L0_2(L1_2)
end
L104_1(L105_1, L106_1)
L104_1 = CreateThread
function L105_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = nil
  while true do
    L1_2 = Wait
    L2_2 = 30000
    L1_2(L2_2)
    L1_2 = GetClockHours
    L1_2 = L1_2()
    if L1_2 ~= L0_2 then
      L0_2 = L1_2
      L2_2 = Push
      L3_2 = "gameTime"
      L4_2 = {}
      L4_2.hour = L1_2
      L2_2(L3_2, L4_2)
    end
    L2_2 = PushWeather
    if L2_2 then
      L2_2 = PushWeather
      L3_2 = false
      L2_2(L3_2)
    end
  end
end
L104_1(L105_1)
function L104_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = OverlayReset
  if L2_2 then
    L2_2 = OverlayReset
    L2_2 = L2_2()
    if L2_2 > 0 then
      L3_2 = #L1_2
      L3_2 = L3_2 + 1
      L4_2 = "%d overlay(s) closed"
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = L2_2
      L4_2 = L4_2(L5_2, L6_2)
      L1_2[L3_2] = L4_2
    end
  end
  L2_2 = PhoneOpen
  if L2_2 then
    L2_2 = ClosePhone
    L2_2()
    L2_2 = #L1_2
    L2_2 = L2_2 + 1
    L1_2[L2_2] = "phone closed"
  end
  L2_2 = false
  L23_1 = L2_2
  L2_2 = false
  L70_1 = L2_2
  L2_2 = CameraReset
  if L2_2 then
    L2_2 = CameraReset
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = #L1_2
      L2_2 = L2_2 + 1
      L1_2[L2_2] = "camera released"
    end
  end
  L2_2 = CallsReset
  if L2_2 then
    L2_2 = CallsReset
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = #L1_2
      L2_2 = L2_2 + 1
      L1_2[L2_2] = "call voice released"
    end
  end
  L2_2 = DeviceOwnerReset
  if L2_2 then
    L2_2 = DeviceOwnerReset
    L2_2 = L2_2()
    if L2_2 then
      L2_2 = #L1_2
      L2_2 = L2_2 + 1
      L1_2[L2_2] = "pending device request cleared"
    end
  end
  L2_2 = L26_1
  L2_2 = L2_2()
  if L2_2 then
    L2_2 = #L1_2
    L2_2 = L2_2 + 1
    L1_2[L2_2] = "NUI focus released"
  end
  L2_2 = {}
  L2_2.on = false
  L2_2.keep = false
  L2_2.cursor = false
  L25_1 = L2_2
  L2_2 = SetNuiFocus
  L3_2 = false
  L4_2 = false
  L2_2(L3_2, L4_2)
  L2_2 = SetNuiFocusKeepInput
  L3_2 = false
  L2_2(L3_2)
  L2_2 = SendNUIMessage
  L3_2 = {}
  L3_2.action = "close"
  L2_2(L3_2)
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = StopAnimTask
  L4_2 = L2_2
  L5_2 = "cellphone@"
  L6_2 = "cellphone_text_in"
  L7_2 = 1.0
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = StopAnimTask
  L4_2 = L2_2
  L5_2 = "cellphone@"
  L6_2 = "cellphone_call_listen_base"
  L7_2 = 1.0
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = false
  L4_2 = false
  L4_1 = L4_2
  L3_1 = L3_2
  L3_2 = L56_1
  L3_2()
  L3_2 = L8_1
  L4_2 = "reset (%s): %s"
  L5_2 = tostring
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L6_2 = #L1_2
  if L6_2 > 0 then
    L6_2 = table
    L6_2 = L6_2.concat
    L7_2 = L1_2
    L8_2 = ", "
    L6_2 = L6_2(L7_2, L8_2)
    if L6_2 then
      goto lbl_126
    end
  end
  L6_2 = "nothing was stuck"
  ::lbl_126::
  L3_2(L4_2, L5_2, L6_2)
  return L1_2
end
ResetPhoneState = L104_1
L104_1 = RegisterCommand
L105_1 = "phonefix"
function L106_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = ResetPhoneState
  L1_2 = "command"
  L0_2 = L0_2(L1_2)
  L1_2 = print
  L2_2 = "^5[unique_phone]^7 /phonefix: "
  L3_2 = #L0_2
  if L3_2 > 0 then
    L3_2 = table
    L3_2 = L3_2.concat
    L4_2 = L0_2
    L5_2 = ", "
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      goto lbl_17
    end
  end
  L3_2 = "nothing was stuck; the phone state was reset anyway"
  ::lbl_17::
  L2_2 = L2_2 .. L3_2
  L1_2(L2_2)
  L1_2 = FW
  L1_2 = L1_2.Notify
  L2_2 = "Telem\195\179vel reposto."
  L3_2 = "success"
  L1_2(L2_2, L3_2)
end
L107_1 = false
L104_1(L105_1, L106_1, L107_1)
L104_1 = TriggerEvent
L105_1 = "chat:addSuggestion"
L106_1 = "/phonefix"
L107_1 = Tr
L108_1 = "Repor o telem\195\179vel (fechado, foco, chamada) quando ficar preso"
L107_1, L108_1, L109_1, L110_1, L111_1, L112_1, L113_1, L114_1, L115_1, L116_1, L117_1, L118_1, L119_1 = L107_1(L108_1)
L104_1(L105_1, L106_1, L107_1, L108_1, L109_1, L110_1, L111_1, L112_1, L113_1, L114_1, L115_1, L116_1, L117_1, L118_1, L119_1)
L104_1 = AddEventHandler
L105_1 = "onResourceStop"
function L106_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = SetPhoneFocus
  L2_2 = false
  L1_2(L2_2)
  L1_2 = false
  L7_1 = L1_2
  L1_2 = PhoneOpen
  if not L1_2 then
    L1_2 = L5_1
    L1_2 = L1_2()
    if not L1_2 then
      goto lbl_32
    end
  end
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  L2_2 = StopAnimTask
  L3_2 = L1_2
  L4_2 = "cellphone@"
  L5_2 = "cellphone_text_in"
  L6_2 = 1.0
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = StopAnimTask
  L3_2 = L1_2
  L4_2 = "cellphone@"
  L5_2 = "cellphone_call_listen_base"
  L6_2 = 1.0
  L2_2(L3_2, L4_2, L5_2, L6_2)
  ::lbl_32::
  L1_2 = false
  L2_2 = false
  L4_1 = L2_2
  L3_1 = L1_2
  L1_2 = L56_1
  L1_2()
end
L104_1(L105_1, L106_1)
L104_1 = nil
L105_1 = "front"
L106_1 = {}
L107_1 = {}
L108_1 = 0.1
L109_1 = 0.95
L110_1 = 0.62
L111_1 = 34.0
L107_1[1] = L108_1
L107_1[2] = L109_1
L107_1[3] = L110_1
L107_1[4] = L111_1
L106_1.front = L107_1
L107_1 = {}
L108_1 = 0.85
L109_1 = 0.3
L110_1 = 0.58
L111_1 = 34.0
L107_1[1] = L108_1
L107_1[2] = L109_1
L107_1[3] = L110_1
L107_1[4] = L111_1
L106_1.side = L107_1
L107_1 = {}
L108_1 = 0.15
L109_1 = 0.45
L110_1 = 1.25
L111_1 = 38.0
L107_1[1] = L108_1
L107_1[2] = L109_1
L107_1[3] = L110_1
L107_1[4] = L111_1
L106_1.top = L107_1
function L107_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = DoesEntityExist
    L1_2 = L0_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = GetEntityCoords
      L1_2 = L0_1
      return L0_2(L1_2)
    end
  end
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetPedBoneCoords
  L2_2 = L0_2
  L3_2 = 57005
  L4_2 = 0.0
  L5_2 = 0.0
  L6_2 = 0.0
  return L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
end
function L108_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = L104_1
  if not L0_2 then
    return
  end
  L1_2 = L105_1
  L0_2 = L106_1
  L0_2 = L0_2[L1_2]
  if not L0_2 then
    L0_2 = L106_1.front
  end
  L1_2 = GetOffsetFromEntityInWorldCoords
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = L0_2[1]
  L4_2 = L0_2[2]
  L5_2 = L0_2[3]
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L2_2 = SetCamCoord
  L3_2 = L104_1
  L4_2 = L1_2.x
  L5_2 = L1_2.y
  L6_2 = L1_2.z
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = SetCamFov
  L3_2 = L104_1
  L4_2 = L0_2[4]
  L2_2(L3_2, L4_2)
  L2_2 = L107_1
  L2_2 = L2_2()
  L3_2 = PointCamAtCoord
  L4_2 = L104_1
  L5_2 = L2_2.x
  L6_2 = L2_2.y
  L7_2 = L2_2.z
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
function L109_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L104_1
  if not L0_2 then
    return
  end
  L0_2 = RenderScriptCams
  L1_2 = false
  L2_2 = true
  L3_2 = 250
  L4_2 = true
  L5_2 = false
  L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  L0_2 = DestroyCam
  L1_2 = L104_1
  L2_2 = false
  L0_2(L1_2, L2_2)
  L0_2 = nil
  L104_1 = L0_2
end
function L110_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L104_1
  if L0_2 then
    L0_2 = L108_1
    L0_2()
    return
  end
  L0_2 = CreateCam
  L1_2 = "DEFAULT_SCRIPTED_CAMERA"
  L2_2 = true
  L0_2 = L0_2(L1_2, L2_2)
  L104_1 = L0_2
  L0_2 = L108_1
  L0_2()
  L0_2 = RenderScriptCams
  L1_2 = true
  L2_2 = true
  L3_2 = 300
  L4_2 = true
  L5_2 = false
  L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3
    while true do
      L0_3 = L104_1
      if not L0_3 then
        break
      end
      L0_3 = L108_1
      L0_3()
      L0_3 = Wait
      L1_3 = 0
      L0_3(L1_3)
    end
  end
  L0_2(L1_2)
end
function L111_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = L15_1
  L1_2 = nil
  L15_1 = L1_2
  L1_2 = GlobalState
  L1_2 = L1_2["apex_phone:propfit"]
  L2_2 = nil
  L3_2 = nil
  L4_2 = nil
  L5_2 = nil
  L6_2 = nil
  L7_2 = nil
  L8_2 = L48_1
  L8_2 = L8_2()
  if L8_2 then
    L9_2 = type
    L10_2 = L8_2.attach
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.attach
      if L9_2 then
        goto lbl_21
      end
    end
    L9_2 = {}
    ::lbl_21::
    L10_2 = L13_1
    L11_2 = L9_2.pos
    L12_2 = L14_1
    L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2)
    L4_2 = L12_2
    L3_2 = L11_2
    L2_2 = L10_2
    L10_2 = L13_1
    L11_2 = L9_2.rot
    L12_2 = L14_1
    L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2)
    L7_2 = L12_2
    L6_2 = L11_2
    L5_2 = L10_2
  else
    L9_2 = type
    L10_2 = Config
    L10_2 = L10_2.PropAttach
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = Config
      L9_2 = L9_2.PropAttach
      if L9_2 then
        goto lbl_48
      end
    end
    L9_2 = {}
    ::lbl_48::
    L10_2 = L9_1
    L11_2 = CurrentDevice
    L10_2 = L10_2(L11_2)
    if L10_2 then
      L11_2 = type
      L12_2 = L10_2.attach
      L11_2 = L11_2(L12_2)
      if "table" == L11_2 then
        L11_2 = L10_2.attach
        if L11_2 then
          goto lbl_63
        end
      end
    end
    L11_2 = {}
    ::lbl_63::
    L12_2 = L13_1
    L13_2 = L9_2.pos
    L14_2 = L14_1
    L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
    L15_2 = L13_1
    L16_2 = L11_2.pos
    L17_2 = {}
    L17_2.x = L12_2
    L17_2.y = L13_2
    L17_2.z = L14_2
    L15_2, L16_2, L17_2 = L15_2(L16_2, L17_2)
    L4_2 = L17_2
    L3_2 = L16_2
    L2_2 = L15_2
    L15_2 = L13_1
    L16_2 = L9_2.rot
    L17_2 = L14_1
    L15_2, L16_2, L17_2 = L15_2(L16_2, L17_2)
    L18_2 = L13_1
    L19_2 = L11_2.rot
    L20_2 = {}
    L20_2.x = L15_2
    L20_2.y = L16_2
    L20_2.z = L17_2
    L18_2, L19_2, L20_2 = L18_2(L19_2, L20_2)
    L7_2 = L20_2
    L6_2 = L19_2
    L5_2 = L18_2
  end
  L15_1 = L0_2
  L9_2 = {}
  L10_2 = L2_2 + 0.0
  L11_2 = L3_2 + 0.0
  L12_2 = L4_2 + 0.0
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = L5_2 + 0.0
  L12_2 = L6_2 + 0.0
  L13_2 = L7_2 + 0.0
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  return L9_2, L10_2
end
function L112_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = L111_1
  L0_2, L1_2 = L0_2()
  L2_2 = L17_1
  L3_2 = CurrentDevice
  L4_2 = L0_2[1]
  L5_2 = L0_2[2]
  L6_2 = L0_2[3]
  L7_2 = L1_2[1]
  L8_2 = L1_2[2]
  L9_2 = L1_2[3]
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L8_2 = {}
  L9_2 = L2_2
  L10_2 = L3_2
  L11_2 = L4_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = L5_2
  L11_2 = L6_2
  L12_2 = L7_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  return L8_2, L9_2
end
function L113_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = DoesEntityExist
    L1_2 = L0_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      goto lbl_10
    end
  end
  do return end
  ::lbl_10::
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = L40_1
  if L1_2 then
    L1_2 = L19_1
    L2_2 = L40_1
    L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L1_2(L2_2)
    L8_2 = AttachEntityToEntity
    L9_2 = L0_1
    L10_2 = L0_2
    L11_2 = GetPedBoneIndex
    L12_2 = L0_2
    L13_2 = L1_2
    L11_2 = L11_2(L12_2, L13_2)
    L12_2 = L2_2
    L13_2 = L3_2
    L14_2 = L4_2
    L15_2 = L5_2
    L16_2 = L6_2
    L17_2 = L7_2
    L18_2 = false
    L19_2 = false
    L20_2 = false
    L21_2 = true
    L22_2 = 2
    L23_2 = true
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L8_2 = L49_1
    L8_2()
  else
    L1_2 = L18_1
    L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L1_2()
    L8_2 = AttachEntityToEntity
    L9_2 = L0_1
    L10_2 = L0_2
    L11_2 = GetPedBoneIndex
    L12_2 = L0_2
    L13_2 = L1_2
    L11_2 = L11_2(L12_2, L13_2)
    L12_2 = L2_2
    L13_2 = L3_2
    L14_2 = L4_2
    L15_2 = L5_2
    L16_2 = L6_2
    L17_2 = L7_2
    L18_2 = true
    L19_2 = true
    L20_2 = false
    L21_2 = true
    L22_2 = 1
    L23_2 = true
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  end
end
function L114_1()
  local L0_2, L1_2, L2_2
  L0_2 = nil
  L15_1 = L0_2
  L0_2 = L109_1
  L0_2()
  L0_2 = L113_1
  L0_2()
  L0_2 = Push
  L1_2 = "posEditor"
  L2_2 = {}
  L2_2.open = false
  L0_2(L1_2, L2_2)
end
L115_1 = RegisterNetEvent
L116_1 = "apex_phone:client:posEditor"
function L117_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = CurrentDevice
  if not L0_2 then
    L0_2 = PhoneOpen
    if not L0_2 then
      L0_2 = FW
      L0_2 = L0_2.Notify
      L1_2 = "Abre o telem\195\179vel que queres ajustar primeiro."
      L2_2 = "error"
      L0_2(L1_2, L2_2)
      return
    end
  end
  L0_2 = PhoneOpen
  if not L0_2 then
    L0_2 = OpenPhone
    L1_2 = CurrentDevice
    L0_2(L1_2)
    L0_2 = Wait
    L1_2 = 900
    L0_2(L1_2)
  end
  L0_2 = PhoneOpen
  if not L0_2 then
    return
  end
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = L0_1
    if L1_2 then
      break
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 4000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 50
    L1_2(L2_2)
  end
  L1_2 = L112_1
  L1_2, L2_2 = L1_2()
  L3_2 = L111_1
  L3_2, L4_2 = L3_2()
  L5_2 = L9_1
  L6_2 = CurrentDevice
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = {}
  L7_2 = CurrentDevice
  L6_2.item = L7_2
  L6_2.pos = L1_2
  L6_2.rot = L2_2
  L15_1 = L6_2
  L6_2 = CreateThread
  function L7_2()
    local L0_3, L1_3
    while true do
      L0_3 = L15_1
      if not L0_3 then
        break
      end
      L0_3 = Wait
      L1_3 = 500
      L0_3(L1_3)
      L0_3 = L15_1
      if L0_3 then
        L0_3 = PhoneOpen
        if not L0_3 then
          L0_3 = L114_1
          L0_3()
        end
      end
    end
  end
  L6_2(L7_2)
  L6_2 = Push
  L7_2 = "posEditor"
  L8_2 = {}
  L8_2.open = true
  L9_2 = CurrentDevice
  if not L9_2 then
    L9_2 = ""
  end
  L8_2.item = L9_2
  L9_2 = L5_2.label
  if not L9_2 then
    L9_2 = CurrentDevice
    if not L9_2 then
      L9_2 = "Telem\195\179vel"
    end
  end
  L8_2.label = L9_2
  L9_2 = L40_1
  L9_2 = nil ~= L9_2
  L8_2.fold = L9_2
  L8_2.pos = L1_2
  L8_2.rot = L2_2
  L8_2.cfgPos = L3_2
  L8_2.cfgRot = L4_2
  L9_2 = L41_1
  L8_2.angle = L9_2
  L6_2(L7_2, L8_2)
end
L115_1(L116_1, L117_1)
function L115_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2 or A0_2
  if not L3_2 then
    A0_2 = 0.0
  end
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = A1_2
  L5_2 = math
  L5_2 = L5_2.min
  L6_2 = A2_2
  L7_2 = A0_2 + 0.0
  L5_2 = L5_2(L6_2, L7_2)
  return L3_2(L4_2, L5_2)
end
L116_1 = RegisterNUICallback
L117_1 = "posEdit"
function L118_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L15_1
  if L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = type
      L3_2 = A0_2.pos
      L2_2 = L2_2(L3_2)
      if "table" == L2_2 then
        L2_2 = type
        L3_2 = A0_2.rot
        L2_2 = L2_2(L3_2)
        if "table" == L2_2 then
          L2_2 = {}
          L3_2 = L115_1
          L4_2 = A0_2.pos
          L4_2 = L4_2[1]
          L5_2 = -0.5
          L6_2 = 0.5
          L3_2 = L3_2(L4_2, L5_2, L6_2)
          L4_2 = L115_1
          L5_2 = A0_2.pos
          L5_2 = L5_2[2]
          L6_2 = -0.5
          L7_2 = 0.5
          L4_2 = L4_2(L5_2, L6_2, L7_2)
          L5_2 = L115_1
          L6_2 = A0_2.pos
          L6_2 = L6_2[3]
          L7_2 = -0.5
          L8_2 = 0.5
          L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
          L2_2[1] = L3_2
          L2_2[2] = L4_2
          L2_2[3] = L5_2
          L2_2[4] = L6_2
          L2_2[5] = L7_2
          L2_2[6] = L8_2
          L15_1.pos = L2_2
          L2_2 = {}
          L3_2 = L115_1
          L4_2 = A0_2.rot
          L4_2 = L4_2[1]
          L5_2 = -360
          L6_2 = 360
          L3_2 = L3_2(L4_2, L5_2, L6_2)
          L4_2 = L115_1
          L5_2 = A0_2.rot
          L5_2 = L5_2[2]
          L6_2 = -360
          L7_2 = 360
          L4_2 = L4_2(L5_2, L6_2, L7_2)
          L5_2 = L115_1
          L6_2 = A0_2.rot
          L6_2 = L6_2[3]
          L7_2 = -360
          L8_2 = 360
          L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
          L2_2[1] = L3_2
          L2_2[2] = L4_2
          L2_2[3] = L5_2
          L2_2[4] = L6_2
          L2_2[5] = L7_2
          L2_2[6] = L8_2
          L15_1.rot = L2_2
          L2_2 = L113_1
          L2_2()
        end
      end
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L116_1(L117_1, L118_1)
L116_1 = RegisterNUICallback
L117_1 = "posFold"
function L118_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L15_1
  if L2_2 then
    L2_2 = L39_1
    if L2_2 then
      L2_2 = type
      L3_2 = A0_2
      L2_2 = L2_2(L3_2)
      if "table" == L2_2 then
        L2_2 = L51_1
        L3_2 = A0_2.open
        if L3_2 then
          L3_2 = 0.0
          if L3_2 then
            goto lbl_20
          end
        end
        L3_2 = 180.0
        ::lbl_20::
        L2_2(L3_2)
      end
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L116_1(L117_1, L118_1)
L116_1 = RegisterNUICallback
L117_1 = "posCam"
function L118_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L15_1
  if L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = A0_2.view
      if L2_2 then
        L3_2 = A0_2.view
        L2_2 = L106_1
        L2_2 = L2_2[L3_2]
        if L2_2 then
          L2_2 = A0_2.view
          L105_1 = L2_2
        end
      end
      L2_2 = A0_2.on
      if false == L2_2 then
        L2_2 = L109_1
        L2_2()
      else
        L2_2 = L110_1
        L2_2()
      end
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L116_1(L117_1, L118_1)
L116_1 = RegisterNUICallback
L117_1 = "posSave"
function L118_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L15_1
  if L2_2 then
    L2_2 = TriggerServerEvent
    L3_2 = "apex_phone:server:propFit"
    L4_2 = L15_1.item
    L5_2 = L15_1.pos
    L6_2 = L15_1.rot
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L116_1(L117_1, L118_1)
L116_1 = RegisterNUICallback
L117_1 = "posReset"
function L118_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L15_1
  if L2_2 then
    L2_2 = TriggerServerEvent
    L3_2 = "apex_phone:server:propFit"
    L4_2 = L15_1.item
    L5_2 = nil
    L6_2 = nil
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L116_1(L117_1, L118_1)
L116_1 = RegisterNUICallback
L117_1 = "posClose"
function L118_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L114_1
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L116_1(L117_1, L118_1)
L116_1 = AddStateBagChangeHandler
L117_1 = "apex_phone:propfit"
L118_1 = "global"
function L119_1()
  local L0_2, L1_2, L2_2
  L0_2 = SetTimeout
  L1_2 = 0
  function L2_2()
    local L0_3, L1_3
    L0_3 = L0_1
    if L0_3 then
      L0_3 = L15_1
      if not L0_3 then
        L0_3 = L113_1
        L0_3()
      end
    end
  end
  L0_2(L1_2, L2_2)
end
L116_1(L117_1, L118_1, L119_1)
