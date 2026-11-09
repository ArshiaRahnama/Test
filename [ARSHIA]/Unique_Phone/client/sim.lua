local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1
function L0_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
L1_1 = {}
L1_1.on = false
L1_1.seq = 0
L1_1.prop = nil
L1_1.model = nil
L1_1.cam = nil
L1_1.dict = nil
L1_1.clip = nil
L2_1 = {}
L1_1.hidden = L2_1
L1_1.beat = 0
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Sim
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = type
    L1_2 = Config
    L1_2 = L1_2.Sim
    L1_2 = L1_2.scan
    L0_2 = L0_2(L1_2)
    if "table" == L0_2 then
      L0_2 = Config
      L0_2 = L0_2.Sim
      L0_2 = L0_2.scan
      if L0_2 then
        goto lbl_21
      end
    end
  end
  L0_2 = {}
  ::lbl_21::
  L1_2 = type
  L2_2 = L0_2.anim
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = L0_2.anim
    if L1_2 then
      goto lbl_31
    end
  end
  L1_2 = {}
  ::lbl_31::
  function L2_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = type
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if "vector3" ~= L2_3 then
      L2_3 = type
      L3_3 = A0_3
      L2_3 = L2_3(L3_3)
      if "table" ~= L2_3 then
        goto lbl_30
      end
    end
    L2_3 = tonumber
    L3_3 = A0_3.x
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = A1_3
    end
    L3_3 = tonumber
    L4_3 = A0_3.y
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = A1_3
    end
    L4_3 = tonumber
    L5_3 = A0_3.z
    L4_3 = L4_3(L5_3)
    if not L4_3 then
      L4_3 = A1_3
    end
    do return L2_3, L3_3, L4_3 end
    ::lbl_30::
    L2_3 = A1_3
    L3_3 = A1_3
    L4_3 = A1_3
    return L2_3, L3_3, L4_3
  end
  L3_2 = L2_2
  L4_2 = L0_2.pos
  L5_2 = 0.0
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  L6_2 = L2_2
  L7_2 = L0_2.rot
  L8_2 = 0.0
  L6_2, L7_2, L8_2 = L6_2(L7_2, L8_2)
  L9_2 = {}
  L10_2 = type
  L11_2 = L0_2.prop
  L10_2 = L10_2(L11_2)
  if "string" == L10_2 then
    L10_2 = L0_2.prop
    if "" ~= L10_2 then
      L10_2 = L0_2.prop
      if L10_2 then
        goto lbl_54
      end
    end
  end
  L10_2 = "apex_esim_card"
  ::lbl_54::
  L9_2.prop = L10_2
  L10_2 = math
  L10_2 = L10_2.tointeger
  L11_2 = tonumber
  L12_2 = L0_2.bone
  L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  if not L10_2 then
    L10_2 = 60309
  end
  L9_2.bone = L10_2
  L9_2.px = L3_2
  L9_2.py = L4_2
  L9_2.pz = L5_2
  L9_2.rx = L6_2
  L9_2.ry = L7_2
  L9_2.rz = L8_2
  L10_2 = type
  L11_2 = L1_2.dict
  L10_2 = L10_2(L11_2)
  if "string" == L10_2 then
    L10_2 = L1_2.dict
    if "" ~= L10_2 then
      L10_2 = L1_2.dict
      if L10_2 then
        goto lbl_83
      end
    end
  end
  L10_2 = "amb@world_human_tourist_map@male@base"
  ::lbl_83::
  L9_2.dict = L10_2
  L10_2 = type
  L11_2 = L1_2.clip
  L10_2 = L10_2(L11_2)
  if "string" == L10_2 then
    L10_2 = L1_2.clip
    if "" ~= L10_2 then
      L10_2 = L1_2.clip
      if L10_2 then
        goto lbl_96
      end
    end
  end
  L10_2 = "base"
  ::lbl_96::
  L9_2.clip = L10_2
  L10_2 = math
  L10_2 = L10_2.tointeger
  L11_2 = tonumber
  L12_2 = L1_2.flag
  L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  if not L10_2 then
    L10_2 = 49
  end
  L9_2.flag = L10_2
  L10_2 = math
  L10_2 = L10_2.max
  L11_2 = 15.0
  L12_2 = math
  L12_2 = L12_2.min
  L13_2 = 70.0
  L14_2 = tonumber
  L15_2 = L0_2.fov
  L14_2 = L14_2(L15_2)
  if not L14_2 then
    L14_2 = 40.0
  end
  L12_2 = L12_2(L13_2, L14_2)
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.fov = L10_2
  L10_2 = math
  L10_2 = L10_2.max
  L11_2 = 0.3
  L12_2 = math
  L12_2 = L12_2.min
  L13_2 = 0.95
  L14_2 = tonumber
  L15_2 = L0_2.fill
  L14_2 = L14_2(L15_2)
  if not L14_2 then
    L14_2 = 0.72
  end
  L12_2 = L12_2(L13_2, L14_2)
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.fill = L10_2
  L10_2 = tonumber
  L11_2 = L0_2.distance
  L10_2 = L10_2(L11_2)
  L9_2.distance = L10_2
  L10_2 = math
  L10_2 = L10_2.max
  L11_2 = 10
  L12_2 = tonumber
  L13_2 = L0_2.timeout
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 60
  end
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.timeout = L10_2
  L10_2 = L0_2.side
  if "auto" == L10_2 then
    L10_2 = "auto"
    if L10_2 then
      goto lbl_167
    end
  end
  L10_2 = tonumber
  L11_2 = L0_2.side
  L10_2 = L10_2(L11_2)
  if -1 == L10_2 then
    L10_2 = -1
    if L10_2 then
      goto lbl_167
    end
  end
  L10_2 = 1
  ::lbl_167::
  L9_2.side = L10_2
  L10_2 = L0_2.view
  if "camera" == L10_2 then
    L10_2 = "camera"
    if L10_2 then
      goto lbl_175
    end
  end
  L10_2 = "desk"
  ::lbl_175::
  L9_2.view = L10_2
  return L9_2
end
L3_1 = CreateThread
function L4_1()
  local L0_2, L1_2
  L0_2 = SimCameraWrapped
  if L0_2 then
    return
  end
  SimCameraWrapped = true
  L0_2 = CameraActive
  function L1_2()
    local L0_3, L1_3
    L0_3 = L1_1.on
    if L0_3 then
      L0_3 = L1_1.view
      if "camera" == L0_3 then
        L0_3 = true
        return L0_3
      end
    end
    L0_3 = L0_2
    if L0_3 then
      L0_3 = L0_2
      return L0_3()
    end
    L0_3 = false
    return L0_3
  end
  CameraActive = L1_2
end
L3_1(L4_1)
function L3_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = {}
  L1_2 = {}
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "string" == L1_3 and "" ~= A0_3 then
      L1_3 = L0_2
      L1_3 = L1_3[A0_3]
      if not L1_3 then
        L1_3 = L0_2
        L1_3[A0_3] = true
        L1_3 = L1_2
        L1_3 = #L1_3
        L2_3 = L1_3 + 1
        L1_3 = L1_2
        L3_3 = GetHashKey
        L4_3 = A0_3
        L3_3 = L3_3(L4_3)
        L1_3[L2_3] = L3_3
      end
    end
  end
  L3_2 = pairs
  L4_2 = Config
  L4_2 = L4_2.Devices
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_2
    L10_2 = L8_2.prop
    L9_2(L10_2)
    L9_2 = type
    L10_2 = L8_2.fold
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L2_2
      L10_2 = L8_2.fold
      L10_2 = L10_2.base
      L9_2(L10_2)
      L9_2 = L2_2
      L10_2 = L8_2.fold
      L10_2 = L10_2.leaf
      L9_2(L10_2)
    end
  end
  L3_2 = pairs
  L4_2 = Config
  L4_2 = L4_2.FrameProps
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_2
    L10_2 = L8_2
    L9_2(L10_2)
  end
  L3_2 = L2_2
  L4_2 = Config
  L4_2 = L4_2.PhoneProp
  L3_2(L4_2)
  return L1_2
end
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L3_1
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L4_2()
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = GetClosestObjectOfType
    L10_2 = L1_2.x
    L11_2 = L1_2.y
    L12_2 = L1_2.z
    L13_2 = 2.0
    L14_2 = L8_2
    L15_2 = false
    L16_2 = false
    L17_2 = false
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    if L9_2 and 0 ~= L9_2 then
      L10_2 = GetEntityAttachedTo
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if L10_2 == L0_2 then
        L10_2 = #L2_2
        L10_2 = L10_2 + 1
        L2_2[L10_2] = L9_2
      end
    end
  end
  return L2_2
end
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L0_1
  L3_2 = DoesAnimDictExist
  L4_2 = A0_2
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = RequestAnimDict
  L3_2 = A0_2
  L2_2(L3_2)
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  while true do
    L3_2 = L0_1
    L4_2 = HasAnimDictLoaded
    L5_2 = A0_2
    L4_2, L5_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      break
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_2 = L3_2 - L2_2
    L4_2 = A1_2 or L4_2
    if not A1_2 then
      L4_2 = 1500
    end
    if not (L3_2 < L4_2) then
      break
    end
    L3_2 = Wait
    L4_2 = 10
    L3_2(L4_2)
  end
  L3_2 = L0_1
  L4_2 = HasAnimDictLoaded
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  return L3_2(L4_2, L5_2)
end
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = GetHashKey
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L0_1
  L4_2 = IsModelInCdimage
  L5_2 = L2_2
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 then
    L3_2 = L0_1
    L4_2 = IsModelValid
    L5_2 = L2_2
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_20
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_20::
  L3_2 = RequestModel
  L4_2 = L2_2
  L3_2(L4_2)
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  while true do
    L4_2 = L0_1
    L5_2 = HasModelLoaded
    L6_2 = L2_2
    L5_2, L6_2 = L5_2(L6_2)
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      break
    end
    L4_2 = GetGameTimer
    L4_2 = L4_2()
    L4_2 = L4_2 - L3_2
    L5_2 = A1_2 or L5_2
    if not A1_2 then
      L5_2 = 3000
    end
    if not (L4_2 < L5_2) then
      break
    end
    L4_2 = Wait
    L5_2 = 10
    L4_2(L5_2)
  end
  L4_2 = L0_1
  L5_2 = HasModelLoaded
  L6_2 = L2_2
  L5_2, L6_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L2_2 or L4_2
  if not L4_2 or not L2_2 then
    L4_2 = nil
  end
  return L4_2
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = vector3
  L3_2 = A0_2.x
  L4_2 = A1_2.x
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.y
  L5_2 = A1_2.y
  L4_2 = L4_2 - L5_2
  L5_2 = A0_2.z
  L6_2 = A1_2.z
  L5_2 = L5_2 - L6_2
  return L2_2(L3_2, L4_2, L5_2)
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2.x
  L3_2 = A1_2.x
  L2_2 = L2_2 * L3_2
  L3_2 = A0_2.y
  L4_2 = A1_2.y
  L3_2 = L3_2 * L4_2
  L2_2 = L2_2 + L3_2
  L3_2 = A0_2.z
  L4_2 = A1_2.z
  L3_2 = L3_2 * L4_2
  L2_2 = L2_2 + L3_2
  return L2_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = math
  L1_2 = L1_2.sqrt
  L2_2 = L8_1
  L3_2 = A0_2
  L4_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L2_2 = 1.0E-6
  if L1_2 < L2_2 then
    L2_2 = vector3
    L3_2 = 0.0
    L4_2 = 1.0
    L5_2 = 0.0
    return L2_2(L3_2, L4_2, L5_2)
  end
  L2_2 = vector3
  L3_2 = A0_2.x
  L3_2 = L3_2 / L1_2
  L4_2 = A0_2.y
  L4_2 = L4_2 / L1_2
  L5_2 = A0_2.z
  L5_2 = L5_2 / L1_2
  return L2_2(L3_2, L4_2, L5_2)
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  L2_2 = GetPedBoneCoords
  L3_2 = L1_2
  L4_2 = 31086
  L5_2 = 0.0
  L6_2 = 0.0
  L7_2 = 0.0
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L3_2 = nil
  L4_2 = nil
  L5_2 = nil
  L6_2 = L1_1.prop
  if L6_2 then
    L6_2 = DoesEntityExist
    L7_2 = L1_1.prop
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L6_2 = GetModelDimensions
      L7_2 = L1_1.model
      L6_2, L7_2 = L6_2(L7_2)
      L8_2 = math
      L8_2 = L8_2.abs
      L9_2 = L7_2.x
      L10_2 = L6_2.x
      L9_2 = L9_2 - L10_2
      L8_2 = L8_2(L9_2)
      L9_2 = math
      L9_2 = L9_2.abs
      L10_2 = L7_2.y
      L11_2 = L6_2.y
      L10_2 = L10_2 - L11_2
      L9_2 = L9_2(L10_2)
      L10_2 = math
      L10_2 = L10_2.abs
      L11_2 = L7_2.z
      L12_2 = L6_2.z
      L11_2 = L11_2 - L12_2
      L10_2 = L10_2(L11_2)
      L11_2 = GetOffsetFromEntityInWorldCoords
      L12_2 = L1_1.prop
      L13_2 = L6_2.x
      L14_2 = L7_2.x
      L13_2 = L13_2 + L14_2
      L13_2 = L13_2 * 0.5
      L14_2 = L6_2.y
      L15_2 = L7_2.y
      L14_2 = L14_2 + L15_2
      L14_2 = L14_2 * 0.5
      L15_2 = L6_2.z
      L16_2 = L7_2.z
      L15_2 = L15_2 + L16_2
      L15_2 = L15_2 * 0.5
      L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
      L3_2 = L11_2
      L11_2 = GetEntityMatrix
      L12_2 = L1_1.prop
      L11_2, L12_2, L13_2 = L11_2(L12_2)
      if L8_2 >= L10_2 and L9_2 >= L10_2 then
        L4_2 = L13_2
      elseif L8_2 >= L9_2 then
        L4_2 = L11_2
      else
        L4_2 = L12_2
      end
      L14_2 = math
      L14_2 = L14_2.max
      L15_2 = L8_2
      L16_2 = L9_2
      L17_2 = L10_2
      L18_2 = 0.05
      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
      L5_2 = L14_2
  end
  else
    L6_2 = GetPedBoneCoords
    L7_2 = L1_2
    L8_2 = A0_2.bone
    L9_2 = 0.0
    L10_2 = 0.0
    L11_2 = 0.0
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
    L3_2 = L6_2
    L6_2 = L7_1
    L7_2 = L2_2
    L8_2 = L3_2
    L6_2 = L6_2(L7_2, L8_2)
    L4_2 = L6_2
    L5_2 = 0.0856
  end
  L6_2 = L9_1
  L7_2 = L4_2
  L6_2 = L6_2(L7_2)
  L4_2 = L6_2
  L6_2 = A0_2.side
  L7_2 = L1_1.prop
  if not L7_2 or "auto" == L6_2 then
    L7_2 = L8_1
    L8_2 = L4_2
    L9_2 = L7_1
    L10_2 = L2_2
    L11_2 = L3_2
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L9_2(L10_2, L11_2)
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    if L7_2 >= 0.0 then
      L7_2 = 1
      if L7_2 then
        goto lbl_125
        L6_2 = L7_2 or L6_2
      end
    end
    L6_2 = -1
  end
  ::lbl_125::
  L7_2 = A0_2.distance
  if not L7_2 then
    L7_2 = A0_2.fill
    L7_2 = L7_2 * 2.0
    L7_2 = L7_2 * 0.75
    L8_2 = math
    L8_2 = L8_2.tan
    L9_2 = math
    L9_2 = L9_2.rad
    L10_2 = A0_2.fov
    L9_2 = L9_2(L10_2)
    L9_2 = L9_2 * 0.5
    L8_2 = L8_2(L9_2)
    L7_2 = L7_2 * L8_2
    L7_2 = L5_2 / L7_2
  end
  L8_2 = math
  L8_2 = L8_2.max
  L9_2 = 0.08
  L10_2 = math
  L10_2 = L10_2.min
  L11_2 = 0.6
  L12_2 = L7_2
  L10_2 = L10_2(L11_2, L12_2)
  L8_2 = L8_2(L9_2, L10_2)
  L7_2 = L8_2
  L8_2 = vector3
  L9_2 = L3_2.x
  L10_2 = L4_2.x
  L10_2 = L10_2 * L6_2
  L10_2 = L10_2 * L7_2
  L9_2 = L9_2 + L10_2
  L10_2 = L3_2.y
  L11_2 = L4_2.y
  L11_2 = L11_2 * L6_2
  L11_2 = L11_2 * L7_2
  L10_2 = L10_2 + L11_2
  L11_2 = L3_2.z
  L12_2 = L4_2.z
  L12_2 = L12_2 * L6_2
  L12_2 = L12_2 * L7_2
  L11_2 = L11_2 + L12_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L9_2 = L3_2
  return L8_2, L9_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  L2_2 = L1_1.cam
  if L2_2 then
    L2_2 = RenderScriptCams
    L3_2 = false
    L4_2 = true
    L5_2 = 250
    L6_2 = true
    L7_2 = true
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
    L2_2 = DestroyCam
    L3_2 = L1_1.cam
    L4_2 = false
    L2_2(L3_2, L4_2)
    L1_1.cam = nil
  end
  L2_2 = L1_1.prop
  if L2_2 then
    L2_2 = DoesEntityExist
    L3_2 = L1_1.prop
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = DetachEntity
      L3_2 = L1_1.prop
      L4_2 = true
      L5_2 = false
      L2_2(L3_2, L4_2, L5_2)
      L2_2 = SetEntityAsMissionEntity
      L3_2 = L1_1.prop
      L4_2 = true
      L5_2 = true
      L2_2(L3_2, L4_2, L5_2)
      L2_2 = DeleteEntity
      L3_2 = L1_1.prop
      L2_2(L3_2)
    end
    L1_1.prop = nil
    L2_2 = TriggerServerEvent
    L3_2 = "apex_phone:server:simCard"
    L4_2 = nil
    L2_2(L3_2, L4_2)
  end
  L2_2 = L1_1.model
  if L2_2 then
    L2_2 = SetModelAsNoLongerNeeded
    L3_2 = L1_1.model
    L2_2(L3_2)
    L1_1.model = nil
  end
  L2_2 = L1_1.dict
  if L2_2 then
    L2_2 = StopAnimTask
    L3_2 = L1_2
    L4_2 = L1_1.dict
    L5_2 = L1_1.clip
    L6_2 = 1.0
    L2_2(L3_2, L4_2, L5_2, L6_2)
    L2_2 = RemoveAnimDict
    L3_2 = L1_1.dict
    L2_2(L3_2)
    L2_2 = nil
    L1_1.clip = nil
    L1_1.dict = L2_2
  end
  L2_2 = {}
  L1_1.hidden = L2_2
  L2_2 = L1_1.view
  L2_2 = "camera" == L2_2
  L1_1.view = nil
  if A0_2 and L2_2 then
    L3_2 = PhoneOpen
    if L3_2 then
      L3_2 = L0_1
      L4_2 = HasAnimDictLoaded
      L5_2 = "cellphone@"
      L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2)
      L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      if L3_2 then
        L3_2 = CameraActive
        if L3_2 then
          L3_2 = CameraActive
          L3_2 = L3_2()
          if L3_2 then
            goto lbl_115
          end
        end
        L3_2 = TaskPlayAnim
        L4_2 = L1_2
        L5_2 = "cellphone@"
        L6_2 = "cellphone_text_in"
        L7_2 = 8.0
        L8_2 = 3.0
        L9_2 = -1
        L10_2 = 50
        L11_2 = 0
        L12_2 = false
        L13_2 = false
        L14_2 = false
        L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
        L3_2 = SetEntityAnimCurrentTime
        L4_2 = L1_2
        L5_2 = "cellphone@"
        L6_2 = "cellphone_text_in"
        L7_2 = 1.0
        L3_2(L4_2, L5_2, L6_2, L7_2)
      end
    end
  end
  ::lbl_115::
end
L12_1 = {}
L13_1 = 1
L14_1 = 2
L15_1 = 3
L16_1 = 4
L17_1 = 6
L18_1 = 7
L19_1 = 8
L20_1 = 9
L21_1 = 13
L22_1 = 19
L23_1 = 20
L24_1 = 21
L25_1 = 22
L12_1[1] = L13_1
L12_1[2] = L14_1
L12_1[3] = L15_1
L12_1[4] = L16_1
L12_1[5] = L17_1
L12_1[6] = L18_1
L12_1[7] = L19_1
L12_1[8] = L20_1
L12_1[9] = L21_1
L12_1[10] = L22_1
L12_1[11] = L23_1
L12_1[12] = L24_1
L12_1[13] = L25_1
L13_1 = {}
L14_1 = 24
L15_1 = 25
L16_1 = 37
L17_1 = 44
L18_1 = 45
L19_1 = 47
L20_1 = 58
L21_1 = 140
L22_1 = 141
L23_1 = 142
L24_1 = 143
L25_1 = 257
L26_1 = 263
L27_1 = 264
L28_1 = 199
L29_1 = 200
L30_1 = 322
L31_1 = 1
L32_1 = 2
L33_1 = 3
L34_1 = 4
L35_1 = 5
L36_1 = 6
L37_1 = 220
L38_1 = 221
L13_1[1] = L14_1
L13_1[2] = L15_1
L13_1[3] = L16_1
L13_1[4] = L17_1
L13_1[5] = L18_1
L13_1[6] = L19_1
L13_1[7] = L20_1
L13_1[8] = L21_1
L13_1[9] = L22_1
L13_1[10] = L23_1
L13_1[11] = L24_1
L13_1[12] = L25_1
L13_1[13] = L26_1
L13_1[14] = L27_1
L13_1[15] = L28_1
L13_1[16] = L29_1
L13_1[17] = L30_1
L13_1[18] = L31_1
L13_1[19] = L32_1
L13_1[20] = L33_1
L13_1[21] = L34_1
L13_1[22] = L35_1
L13_1[23] = L36_1
L13_1[24] = L37_1
L13_1[25] = L38_1
function L14_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L1_1.on
  if not L1_2 then
    return
  end
  L1_1.on = false
  L1_2 = L1_1.seq
  L1_2 = L1_2 + 1
  L1_1.seq = L1_2
  L1_2 = L11_1
  L2_2 = true
  L1_2(L2_2)
  if A0_2 then
    L1_2 = Push
    L2_2 = "sim:scanEnd"
    L3_2 = {}
    L3_2.reason = A0_2
    L1_2(L2_2, L3_2)
  end
end
SimStopScan = L14_1
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L0_2 = L1_1.on
  if L0_2 then
    L0_2 = {}
    L0_2.ok = true
    L1_2 = L1_1.prop
    L1_2 = nil ~= L1_2
    L0_2.prop = L1_2
    L0_2.already = true
    return L0_2
  end
  L0_2 = PhoneOpen
  if not L0_2 then
    L0_2 = {}
    L0_2.ok = false
    L0_2.error = "closed"
    return L0_2
  end
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = FW
  L1_2 = L1_2.IsDead
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = L0_1
    L2_2 = IsEntityDead
    L3_2 = L0_2
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L2_2(L3_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
    if not L1_2 then
      goto lbl_42
    end
  end
  L1_2 = {}
  L1_2.ok = false
  L1_2.error = "dead"
  do return L1_2 end
  ::lbl_42::
  L1_2 = L2_1
  L1_2 = L1_2()
  L1_1.on = true
  L2_2 = L1_2.view
  L1_1.view = L2_2
  L2_2 = L1_1.seq
  L2_2 = L2_2 + 1
  L1_1.seq = L2_2
  L2_2 = L1_1.seq
  L3_2 = L1_2.view
  if "camera" ~= L3_2 then
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L4_2 = CreateThread
    function L5_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3
      L0_3 = L6_1
      L1_3 = L1_2.prop
      L2_3 = 3000
      L0_3 = L0_3(L1_3, L2_3)
      if not L0_3 then
        return
      end
      L1_3 = L2_2
      L2_3 = L1_1.seq
      if L1_3 == L2_3 then
        L1_3 = L1_1.on
        if L1_3 then
          goto lbl_19
        end
      end
      L1_3 = SetModelAsNoLongerNeeded
      L2_3 = L0_3
      L1_3(L2_3)
      do return end
      ::lbl_19::
      L1_3 = PlayerPedId
      L1_3 = L1_3()
      L2_3 = GetEntityCoords
      L3_3 = L1_3
      L2_3 = L2_3(L3_3)
      L3_3 = CreateObject
      L4_3 = L0_3
      L5_3 = L2_3.x
      L6_3 = L2_3.y
      L7_3 = L2_3.z
      L7_3 = L7_3 + 0.2
      L8_3 = true
      L9_3 = true
      L10_3 = false
      L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
      if not L3_3 or 0 == L3_3 then
        L4_3 = SetModelAsNoLongerNeeded
        L5_3 = L0_3
        L4_3(L5_3)
        return
      end
      L4_3 = SetEntityCollision
      L5_3 = L3_3
      L6_3 = false
      L7_3 = false
      L4_3(L5_3, L6_3, L7_3)
      L4_3 = SetEntityCanBeDamaged
      L5_3 = L3_3
      L6_3 = false
      L4_3(L5_3, L6_3)
      L4_3 = AttachEntityToEntity
      L5_3 = L3_3
      L6_3 = L1_3
      L7_3 = GetPedBoneIndex
      L8_3 = L1_3
      L9_3 = L1_2.bone
      L7_3 = L7_3(L8_3, L9_3)
      L8_3 = L1_2.px
      L9_3 = L1_2.py
      L10_3 = L1_2.pz
      L11_3 = L1_2.rx
      L12_3 = L1_2.ry
      L13_3 = L1_2.rz
      L14_3 = true
      L15_3 = true
      L16_3 = false
      L17_3 = true
      L18_3 = 1
      L19_3 = true
      L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
      L4_3 = L2_2
      L5_3 = L1_1.seq
      if L4_3 == L5_3 then
        L4_3 = L1_1.on
        if L4_3 then
          goto lbl_91
        end
      end
      L4_3 = SetEntityAsMissionEntity
      L5_3 = L3_3
      L6_3 = true
      L7_3 = true
      L4_3(L5_3, L6_3, L7_3)
      L4_3 = DeleteEntity
      L5_3 = L3_3
      L4_3(L5_3)
      L4_3 = SetModelAsNoLongerNeeded
      L5_3 = L0_3
      L4_3(L5_3)
      do return end
      ::lbl_91::
      L4_3 = L3_3
      L1_1.model = L0_3
      L1_1.prop = L4_3
      L4_3 = NetworkGetNetworkIdFromEntity
      L5_3 = L3_3
      L4_3 = L4_3(L5_3)
      if L4_3 and 0 ~= L4_3 then
        L5_3 = TriggerServerEvent
        L6_3 = "apex_phone:server:simCard"
        L7_3 = L4_3
        L5_3(L6_3, L7_3)
      end
    end
    L4_2(L5_2)
    L4_2 = CreateThread
    function L5_2()
      local L0_3, L1_3, L2_3, L3_3
      while true do
        L0_3 = L1_1.on
        if not L0_3 then
          break
        end
        L0_3 = L2_2
        L1_3 = L1_1.seq
        if L0_3 ~= L1_3 then
          break
        end
        L0_3 = PhoneOpen
        if not L0_3 then
          L0_3 = L14_1
          L1_3 = "closed"
          L0_3(L1_3)
          break
        end
        L0_3 = PlayerPedId
        L0_3 = L0_3()
        L1_3 = FW
        L1_3 = L1_3.IsDead
        L1_3 = L1_3()
        if not L1_3 then
          L1_3 = DoesEntityExist
          L2_3 = L0_3
          L1_3 = L1_3(L2_3)
          if L1_3 then
            L1_3 = L0_1
            L2_3 = IsEntityDead
            L3_3 = L0_3
            L2_3, L3_3 = L2_3(L3_3)
            L1_3 = L1_3(L2_3, L3_3)
            if not L1_3 then
              goto lbl_38
            end
          end
        end
        L1_3 = L14_1
        L2_3 = "dead"
        L1_3(L2_3)
        do break end
        ::lbl_38::
        L1_3 = GetGameTimer
        L1_3 = L1_3()
        L2_3 = L3_2
        L1_3 = L1_3 - L2_3
        L2_3 = L1_2.timeout
        L2_3 = L2_3 * 1000
        if L1_3 > L2_3 then
          L1_3 = L14_1
          L2_3 = "timeout"
          L1_3(L2_3)
          break
        end
        L1_3 = Wait
        L2_3 = 250
        L1_3(L2_3)
      end
    end
    L4_2(L5_2)
    L4_2 = {}
    L4_2.ok = true
    L4_2.prop = false
    L4_2.view = "desk"
    return L4_2
  end
  L3_2 = L5_1
  L4_2 = L1_2.dict
  L5_2 = 1500
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L6_1
  L5_2 = L1_2.prop
  L6_2 = 3000
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L1_1.seq
  if L2_2 == L5_2 then
    L5_2 = L1_1.on
    if L5_2 then
      goto lbl_94
    end
  end
  if L4_2 then
    L5_2 = SetModelAsNoLongerNeeded
    L6_2 = L4_2
    L5_2(L6_2)
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "cancelled"
  do return L5_2 end
  ::lbl_94::
  L5_2 = PlayerPedId
  L5_2 = L5_2()
  L0_2 = L5_2
  if L4_2 then
    L5_2 = GetEntityCoords
    L6_2 = L0_2
    L5_2 = L5_2(L6_2)
    L6_2 = CreateObject
    L7_2 = L4_2
    L8_2 = L5_2.x
    L9_2 = L5_2.y
    L10_2 = L5_2.z
    L10_2 = L10_2 + 0.2
    L11_2 = true
    L12_2 = true
    L13_2 = false
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    if L6_2 and 0 ~= L6_2 then
      L7_2 = SetEntityCollision
      L8_2 = L6_2
      L9_2 = false
      L10_2 = false
      L7_2(L8_2, L9_2, L10_2)
      L7_2 = SetEntityCanBeDamaged
      L8_2 = L6_2
      L9_2 = false
      L7_2(L8_2, L9_2)
      L7_2 = AttachEntityToEntity
      L8_2 = L6_2
      L9_2 = L0_2
      L10_2 = GetPedBoneIndex
      L11_2 = L0_2
      L12_2 = L1_2.bone
      L10_2 = L10_2(L11_2, L12_2)
      L11_2 = L1_2.px
      L12_2 = L1_2.py
      L13_2 = L1_2.pz
      L14_2 = L1_2.rx
      L15_2 = L1_2.ry
      L16_2 = L1_2.rz
      L17_2 = true
      L18_2 = true
      L19_2 = false
      L20_2 = true
      L21_2 = 1
      L22_2 = true
      L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
      L7_2 = L6_2
      L1_1.model = L4_2
      L1_1.prop = L7_2
      L7_2 = NetworkGetNetworkIdFromEntity
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      if L7_2 and 0 ~= L7_2 then
        L8_2 = TriggerServerEvent
        L9_2 = "apex_phone:server:simCard"
        L10_2 = L7_2
        L8_2(L9_2, L10_2)
      end
    else
      L7_2 = SetModelAsNoLongerNeeded
      L8_2 = L4_2
      L7_2(L8_2)
    end
  end
  if L3_2 then
    L5_2 = TaskPlayAnim
    L6_2 = L0_2
    L7_2 = L1_2.dict
    L8_2 = L1_2.clip
    L9_2 = 3.0
    L10_2 = 3.0
    L11_2 = -1
    L12_2 = L1_2.flag
    L13_2 = 0
    L14_2 = false
    L15_2 = false
    L16_2 = false
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L5_2 = L1_2.dict
    L6_2 = L1_2.clip
    L1_1.clip = L6_2
    L1_1.dict = L5_2
  end
  L5_2 = nil
  L6_2 = L1_2.view
  if "camera" == L6_2 then
    L6_2 = CreateCam
    L7_2 = "DEFAULT_SCRIPTED_CAMERA"
    L8_2 = true
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = SetCamNearClip
    L8_2 = L6_2
    L9_2 = 0.02
    L7_2(L8_2, L9_2)
    L7_2 = SetCamFov
    L8_2 = L6_2
    L9_2 = L1_2.fov
    L7_2(L8_2, L9_2)
    L7_2 = L10_1
    L8_2 = L1_2
    L7_2, L8_2 = L7_2(L8_2)
    L9_2 = SetCamCoord
    L10_2 = L6_2
    L11_2 = L7_2.x
    L12_2 = L7_2.y
    L13_2 = L7_2.z
    L9_2(L10_2, L11_2, L12_2, L13_2)
    L9_2 = PointCamAtCoord
    L10_2 = L6_2
    L11_2 = L8_2.x
    L12_2 = L8_2.y
    L13_2 = L8_2.z
    L9_2(L10_2, L11_2, L12_2, L13_2)
    L9_2 = RenderScriptCams
    L10_2 = true
    L11_2 = true
    L12_2 = 350
    L13_2 = true
    L14_2 = true
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L1_1.cam = L6_2
    L9_2 = L4_1
    L9_2 = L9_2()
    L1_1.hidden = L9_2
    L5_2 = L7_2
  end
  L6_2 = GetGameTimer
  L6_2 = L6_2()
  L1_1.beat = L6_2
  L7_2 = CreateThread
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L0_3 = GetGameTimer
    L0_3 = L0_3()
    while true do
      L1_3 = L1_1.on
      if not L1_3 then
        break
      end
      L1_3 = L2_2
      L2_3 = L1_1.seq
      if L1_3 ~= L2_3 then
        break
      end
      L1_3 = GetGameTimer
      L1_3 = L1_3()
      L1_1.beat = L1_3
      L2_3 = PlayerPedId
      L2_3 = L2_3()
      L3_3 = PhoneOpen
      if not L3_3 then
        L3_3 = L14_1
        L4_3 = "closed"
        L3_3(L4_3)
        break
      end
      L3_3 = FW
      L3_3 = L3_3.IsDead
      L3_3 = L3_3()
      if not L3_3 then
        L3_3 = DoesEntityExist
        L4_3 = L2_3
        L3_3 = L3_3(L4_3)
        if L3_3 then
          L3_3 = L0_1
          L4_3 = IsEntityDead
          L5_3 = L2_3
          L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3 = L4_3(L5_3)
          L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
          if not L3_3 then
            goto lbl_43
          end
        end
      end
      L3_3 = L14_1
      L4_3 = "dead"
      L3_3(L4_3)
      do break end
      ::lbl_43::
      L3_3 = L6_2
      L3_3 = L1_3 - L3_3
      L4_3 = L1_2.timeout
      L4_3 = L4_3 * 1000
      if L3_3 > L4_3 then
        L3_3 = L14_1
        L4_3 = "timeout"
        L3_3(L4_3)
        break
      end
      L3_3 = 1
      L4_3 = L13_1
      L4_3 = #L4_3
      L5_3 = 1
      for L6_3 = L3_3, L4_3, L5_3 do
        L7_3 = DisableControlAction
        L8_3 = 0
        L9_3 = L13_1
        L9_3 = L9_3[L6_3]
        L10_3 = true
        L7_3(L8_3, L9_3, L10_3)
      end
      L3_3 = InvalidateIdleCam
      L3_3()
      L3_3 = L1_1.cam
      if L3_3 then
        L3_3 = HideHudAndRadarThisFrame
        L3_3()
        L3_3 = 1
        L4_3 = L12_1
        L4_3 = #L4_3
        L5_3 = 1
        for L6_3 = L3_3, L4_3, L5_3 do
          L7_3 = HideHudComponentThisFrame
          L8_3 = L12_1
          L8_3 = L8_3[L6_3]
          L7_3(L8_3)
        end
        L3_3 = L1_3 - L0_3
        L4_3 = 1000
        if L3_3 > L4_3 then
          L0_3 = L1_3
          L3_3 = L4_1
          L3_3 = L3_3()
          L1_1.hidden = L3_3
        end
        L3_3 = 1
        L4_3 = L1_1.hidden
        L4_3 = #L4_3
        L5_3 = 1
        for L6_3 = L3_3, L4_3, L5_3 do
          L7_3 = L1_1.hidden
          L7_3 = L7_3[L6_3]
          L8_3 = DoesEntityExist
          L9_3 = L7_3
          L8_3 = L8_3(L9_3)
          if L8_3 then
            L8_3 = SetEntityLocallyInvisible
            L9_3 = L7_3
            L8_3(L9_3)
          end
        end
      end
      L3_3 = L1_1.dict
      if L3_3 then
        L3_3 = L0_1
        L4_3 = IsEntityPlayingAnim
        L5_3 = L2_3
        L6_3 = L1_1.dict
        L7_3 = L1_1.clip
        L8_3 = 3
        L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3 = L4_3(L5_3, L6_3, L7_3, L8_3)
        L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
        if not L3_3 then
          L3_3 = TaskPlayAnim
          L4_3 = L2_3
          L5_3 = L1_1.dict
          L6_3 = L1_1.clip
          L7_3 = 8.0
          L8_3 = 3.0
          L9_3 = -1
          L10_3 = L1_2.flag
          L11_3 = 0
          L12_3 = false
          L13_3 = false
          L14_3 = false
          L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
        end
      end
      L3_3 = L1_1.cam
      if L3_3 then
        L3_3 = L5_2
        if L3_3 then
          L3_3 = L10_1
          L4_3 = L1_2
          L3_3, L4_3 = L3_3(L4_3)
          L5_3 = math
          L5_3 = L5_3.exp
          L6_3 = GetFrameTime
          L6_3 = L6_3()
          L6_3 = -L6_3
          L6_3 = L6_3 * 12.0
          L5_3 = L5_3(L6_3)
          L6_3 = 1.0
          L5_3 = L6_3 - L5_3
          L6_3 = vector3
          L7_3 = L5_2.x
          L8_3 = L3_3.x
          L9_3 = L5_2.x
          L8_3 = L8_3 - L9_3
          L8_3 = L8_3 * L5_3
          L7_3 = L7_3 + L8_3
          L8_3 = L5_2.y
          L9_3 = L3_3.y
          L10_3 = L5_2.y
          L9_3 = L9_3 - L10_3
          L9_3 = L9_3 * L5_3
          L8_3 = L8_3 + L9_3
          L9_3 = L5_2.z
          L10_3 = L3_3.z
          L11_3 = L5_2.z
          L10_3 = L10_3 - L11_3
          L10_3 = L10_3 * L5_3
          L9_3 = L9_3 + L10_3
          L6_3 = L6_3(L7_3, L8_3, L9_3)
          L5_2 = L6_3
          L6_3 = SetCamCoord
          L7_3 = L1_1.cam
          L8_3 = L5_2.x
          L9_3 = L5_2.y
          L10_3 = L5_2.z
          L6_3(L7_3, L8_3, L9_3, L10_3)
          L6_3 = PointCamAtCoord
          L7_3 = L1_1.cam
          L8_3 = L4_3.x
          L9_3 = L4_3.y
          L10_3 = L4_3.z
          L6_3(L7_3, L8_3, L9_3, L10_3)
        end
      end
      L3_3 = Wait
      L4_3 = 0
      L3_3(L4_3)
    end
  end
  L7_2(L8_2)
  L7_2 = {}
  L7_2.ok = true
  L8_2 = L1_1.prop
  L8_2 = nil ~= L8_2
  L7_2.prop = L8_2
  L8_2 = L1_2.view
  L7_2.view = L8_2
  return L7_2
end
L16_1 = RegisterNUICallback
L17_1 = "simScanStart"
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = pcall
  L3_2 = L15_1
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = print
    L5_2 = "^1[unique_phone]^0 simScanStart: %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
    L1_1.on = false
    L4_2 = L1_1.seq
    L4_2 = L4_2 + 1
    L1_1.seq = L4_2
    L4_2 = L11_1
    L5_2 = true
    L4_2(L5_2)
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "internal"
    L3_2 = L4_2
  end
  L4_2 = A1_2
  L5_2 = L3_2
  L4_2(L5_2)
end
L16_1(L17_1, L18_1)
L16_1 = RegisterNUICallback
L17_1 = "simScanStop"
function L18_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L14_1
  L3_2 = nil
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = true
  L2_2(L3_2)
end
L16_1(L17_1, L18_1)
L16_1 = 0
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L16_1
  L2_2 = L1_2 - L2_2
  L3_2 = 800
  if L2_2 < L3_2 then
    return
  end
  L16_1 = L1_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = type
  L3_2 = A0_2.metadata
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.metadata
    if L2_2 then
      goto lbl_31
    end
  end
  L2_2 = {}
  ::lbl_31::
  L3_2 = {}
  L3_2.from = "item"
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A0_2.slot
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.slot = L4_2
  L4_2 = type
  L5_2 = L2_2.iccid
  L4_2 = L4_2(L5_2)
  if "string" ~= L4_2 then
    L4_2 = type
    L5_2 = L2_2.iccid
    L4_2 = L4_2(L5_2)
    if "number" ~= L4_2 then
      goto lbl_56
    end
  end
  L4_2 = tostring
  L5_2 = L2_2.iccid
  L4_2 = L4_2(L5_2)
  ::lbl_56::
  if not L4_2 then
    L4_2 = nil
  end
  L3_2.iccid = L4_2
  L4_2 = type
  L5_2 = L2_2.number
  L4_2 = L4_2(L5_2)
  if "string" ~= L4_2 then
    L4_2 = type
    L5_2 = L2_2.number
    L4_2 = L4_2(L5_2)
    if "number" ~= L4_2 then
      goto lbl_73
    end
  end
  L4_2 = tostring
  L5_2 = L2_2.number
  L4_2 = L4_2(L5_2)
  ::lbl_73::
  if not L4_2 then
    L4_2 = nil
  end
  L3_2.number = L4_2
  L4_2 = PhoneOpen
  L5_2 = OpenPhone
  L5_2 = L5_2()
  if not L5_2 then
    return
  end
  L5_2 = SetTimeout
  if L4_2 then
    L6_2 = 0
    if L6_2 then
      goto lbl_88
    end
  end
  L6_2 = 450
  ::lbl_88::
  function L7_2()
    local L0_3, L1_3, L2_3
    L0_3 = PhoneOpen
    if L0_3 then
      L0_3 = Push
      L1_3 = "sim:scan"
      L2_3 = L3_2
      L0_3(L1_3, L2_3)
    end
  end
  L5_2(L6_2, L7_2)
end
UseEsim = L17_1
L17_1 = exports
L18_1 = "useEsim"
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = UseEsim
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L3_2 = A1_2 or L3_2
  if "table" ~= L3_2 or not A1_2 then
    L3_2 = type
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = {}
      L4_2 = A0_2.slot
      L3_2.slot = L4_2
      L4_2 = A0_2.metadata
      L3_2.metadata = L4_2
      if L3_2 then
        goto lbl_23
      end
    end
    L3_2 = nil
  end
  ::lbl_23::
  L2_2(L3_2)
end
L17_1(L18_1, L19_1)
L17_1 = RegisterNetEvent
L18_1 = "apex_phone:client:useEsim"
function L19_1(A0_2)
  local L1_2, L2_2
  L1_2 = UseEsim
  L2_2 = A0_2
  L1_2(L2_2)
end
L17_1(L18_1, L19_1)
L17_1 = AddEventHandler
L18_1 = "onResourceStop"
function L19_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = L1_1.on
  if not L1_2 then
    L1_2 = L1_1.prop
    if not L1_2 then
      L1_2 = L1_1.cam
      if not L1_2 then
        goto lbl_23
      end
    end
  end
  L1_1.on = false
  L1_2 = L1_1.seq
  L1_2 = L1_2 + 1
  L1_1.seq = L1_2
  L1_2 = L11_1
  L2_2 = false
  L1_2(L2_2)
  ::lbl_23::
end
L17_1(L18_1, L19_1)
