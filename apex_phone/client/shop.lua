local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1
L0_1 = GetCurrentResourceName
L0_1 = L0_1()
function L1_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
L2_1 = nil
L3_1 = nil
L4_1 = {}
L5_1 = false
L6_1 = false
L7_1 = false
L8_1 = nil
L9_1 = false
L10_1 = 0
L11_1 = nil
L12_1 = nil
L13_1 = nil
function L14_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = Config
  L1_2 = L1_2.Debug
  if not L1_2 then
    return
  end
  L1_2 = pcall
  L2_2 = string
  L2_2 = L2_2.format
  L3_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = ...
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L3_2 = print
  L4_2 = "[unique_phone] shop: %s"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L2_2 or L6_2
  if not L1_2 or not L2_2 then
    L6_2 = tostring
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
function L15_1(A0_2)
  local L1_2, L2_2
  L1_2 = Tr
  if L1_2 then
    L1_2 = Tr
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_10
    end
  end
  L1_2 = A0_2
  ::lbl_10::
  return L1_2
end
function L16_1(A0_2)
  local L1_2, L2_2
  L1_2 = L2_1
  if L1_2 then
    L1_2 = type
    L2_2 = L2_1
    L2_2 = L2_2[A0_2]
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = L2_1
      L1_2 = L1_2[A0_2]
      if L1_2 then
        goto lbl_16
      end
    end
  end
  L1_2 = {}
  ::lbl_16::
  return L1_2
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = A0_2 or nil
  L1_2 = L1_1
  L2_2 = DoesEntityExist
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = A0_2 and 0 ~= A0_2 and L1_2
  return L1_2
end
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if not A0_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = A0_2 or L1_2
  if "number" ~= L1_2 or not A0_2 then
    L1_2 = GetHashKey
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  L2_2 = L1_1
  L3_2 = IsModelInCdimage
  L4_2 = L1_2
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L2_2 = L1_1
    L3_2 = IsModelValid
    L4_2 = L1_2
    L3_2, L4_2, L5_2 = L3_2(L4_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      goto lbl_33
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_33::
  L2_2 = RequestModel
  L3_2 = L1_2
  L2_2(L3_2)
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L2_2 = L2_2 + 8000
  while true do
    L3_2 = L1_1
    L4_2 = HasModelLoaded
    L5_2 = L1_2
    L4_2, L5_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      break
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    if L2_2 < L3_2 then
      L3_2 = nil
      return L3_2
    end
    L3_2 = Wait
    L4_2 = 25
    L3_2(L4_2)
  end
  return L1_2
end
function L19_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = 1
  L4_2 = 12
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = GetGroundZFor_3dCoord
    L8_2 = A0_2
    L9_2 = A1_2
    L10_2 = A2_2 + 1.5
    L11_2 = false
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
    L9_2 = L1_1
    L10_2 = L7_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "number" == L9_2 then
        L9_2 = math
        L9_2 = L9_2.abs
        L10_2 = A2_2 - 1.0
        L10_2 = L8_2 - L10_2
        L9_2 = L9_2(L10_2)
        if L9_2 < 4.0 then
          return L8_2
        end
      end
    end
    L9_2 = RequestCollisionAtCoord
    L10_2 = A0_2
    L11_2 = A1_2
    L12_2 = A2_2
    L9_2(L10_2, L11_2, L12_2)
    L9_2 = Wait
    L10_2 = 100
    L9_2(L10_2)
  end
  L3_2 = nil
  return L3_2
end
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = StartShapeTestCapsule
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2 + 0.35
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2 + 1.65
  L10_2 = 0.28
  L11_2 = 17
  L12_2 = PlayerPedId
  L12_2 = L12_2()
  L13_2 = 7
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L4_2 = L4_2 + 600
  while true do
    L5_2 = GetShapeTestResult
    L6_2 = L3_2
    L5_2, L6_2 = L5_2(L6_2)
    if 1 ~= L5_2 then
      L7_2 = true == L6_2 or 1 == L6_2
      return L7_2
    end
    L7_2 = GetGameTimer
    L7_2 = L7_2()
    if L4_2 < L7_2 then
      L7_2 = false
      return L7_2
    end
    L7_2 = Wait
    L8_2 = 0
    L7_2(L8_2)
  end
end
L21_1 = {}
L22_1 = {}
L23_1 = true
L24_1 = 12
L22_1[1] = L23_1
L22_1[2] = L24_1
L23_1 = {}
L24_1 = false
L25_1 = 28
L23_1[1] = L24_1
L23_1[2] = L25_1
L24_1 = {}
L25_1 = false
L26_1 = 0
L24_1[1] = L25_1
L24_1[2] = L26_1
L21_1[1] = L22_1
L21_1[2] = L23_1
L21_1[3] = L24_1
function L22_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = ipairs
  L4_2 = L21_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = GetSafeCoordForPed
    L10_2 = A0_2
    L11_2 = A1_2
    L12_2 = A2_2
    L13_2 = L8_2[1]
    L14_2 = L8_2[2]
    L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L11_2 = L1_1
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    if L11_2 and L10_2 then
      L11_2 = L10_2.x
      if 0.0 == L11_2 then
        L11_2 = L10_2.y
        if 0.0 == L11_2 then
          goto lbl_26
        end
      end
      return L10_2
    end
    ::lbl_26::
  end
  L3_2 = nil
  return L3_2
end
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = A1_2.x
  L3_2 = A0_2.x
  L2_2 = L2_2 - L3_2
  L3_2 = A1_2.y
  L4_2 = A0_2.y
  L3_2 = L3_2 - L4_2
  L4_2 = math
  L4_2 = L4_2.abs
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L5_2 = 0.001
  if L4_2 < L5_2 then
    L4_2 = math
    L4_2 = L4_2.abs
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L5_2 = 0.001
    if L4_2 < L5_2 then
      L4_2 = nil
      return L4_2
    end
  end
  L4_2 = math
  L4_2 = L4_2.deg
  L5_2 = math
  L5_2 = L5_2.atan
  L6_2 = L3_2
  L7_2 = L2_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L4_2 = L4_2 - 90.0
  L4_2 = L4_2 % 360.0
  return L4_2
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = A0_2.cfg
  L1_2 = L1_2.ped
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = L1_2.scenario
  if nil ~= L2_2 then
    L2_2 = L1_2.scenario
    return L2_2
  end
  L2_2 = L16_1
  L3_2 = "ped"
  L2_2 = L2_2(L3_2)
  L2_2 = L2_2.scenario
  return L2_2
end
function L25_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L17_1
  L2_2 = A0_2.ped
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    return
  end
  L1_2 = A0_2.heading
  if L1_2 then
    L1_2 = SetEntityHeading
    L2_2 = A0_2.ped
    L3_2 = A0_2.heading
    L1_2(L2_2, L3_2)
  end
  L1_2 = L24_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 and "" ~= L1_2 then
    L2_2 = TaskStartScenarioInPlace
    L3_2 = A0_2.ped
    L4_2 = L1_2
    L5_2 = 0
    L6_2 = true
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
end
function L26_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L16_1
  L1_2 = "interaction"
  L0_2 = L0_2(L1_2)
  L0_2 = L0_2.label
  L1_2 = L15_1
  L2_2 = type
  L3_2 = L0_2
  L2_2 = L2_2(L3_2)
  L2_2 = L0_2 or L2_2
  if "string" ~= L2_2 or "" == L0_2 or not L0_2 then
    L2_2 = "Falar com o vendedor"
  end
  return L1_2(L2_2)
end
function L27_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = "apex_phone:shop:"
  L2_2 = tostring
  L3_2 = A0_2.cfg
  L3_2 = L3_2.id
  L2_2 = L2_2(L3_2)
  L1_2 = L1_2 .. L2_2
  return L1_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L5_1
  if L1_2 then
    L1_2 = A0_2.targeted
    if not L1_2 then
      L1_2 = A0_2.ped
      if L1_2 then
        L1_2 = A0_2.removed
        if not L1_2 then
          goto lbl_14
        end
      end
    end
  end
  do return end
  ::lbl_14::
  L1_2 = L16_1
  L2_2 = "interaction"
  L1_2 = L1_2(L2_2)
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = exports
    L0_3 = L0_3.ox_target
    L1_3 = L0_3
    L0_3 = L0_3.addLocalEntity
    L2_3 = A0_2.ped
    L3_3 = {}
    L4_3 = {}
    L5_3 = L27_1
    L6_3 = A0_2
    L5_3 = L5_3(L6_3)
    L4_3.name = L5_3
    L5_3 = L26_1
    L5_3 = L5_3()
    L4_3.label = L5_3
    L5_3 = L1_2.icon
    if not L5_3 then
      L5_3 = "fa-solid fa-mobile-screen-button"
    end
    L4_3.icon = L5_3
    L5_3 = L1_2.distance
    if not L5_3 then
      L5_3 = 2.0
    end
    L4_3.distance = L5_3
    function L5_3()
      local L0_4, L1_4
      L0_4 = L6_1
      L0_4 = L7_1
      L0_4 = not L0_4 and L0_4
      return L0_4
    end
    L4_3.canInteract = L5_3
    function L5_3()
      local L0_4, L1_4
      L0_4 = CreateThread
      function L1_4()
        local L0_5, L1_5, L2_5
        L0_5 = L13_1
        L1_5 = A0_2
        L2_5 = false
        L0_5(L1_5, L2_5)
      end
      L0_4(L1_4)
    end
    L4_3.onSelect = L5_3
    L3_3[1] = L4_3
    L0_3(L1_3, L2_3, L3_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  A0_2.targeted = L2_2
  if not L2_2 then
    L4_2 = print
    L5_2 = "[unique_phone] shop: ox_target: %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
end
function L29_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = A0_2.targeted
  if L1_2 then
    L1_2 = A0_2.ped
    if L1_2 then
      L1_2 = A0_2.ped
      L2_2 = L27_1
      L3_2 = A0_2
      L2_2 = L2_2(L3_2)
      L3_2 = pcall
      function L4_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = exports
        L0_3 = L0_3.ox_target
        L1_3 = L0_3
        L0_3 = L0_3.removeLocalEntity
        L2_3 = L1_2
        L3_3 = L2_2
        L0_3(L1_3, L2_3, L3_3)
      end
      L3_2(L4_2)
    end
  end
  A0_2.targeted = false
end
function L30_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.ped
  if not L1_2 then
    L1_2 = A0_2.spawning
    if not L1_2 then
      L1_2 = A0_2.removed
      if not L1_2 then
        goto lbl_11
      end
    end
  end
  do return end
  ::lbl_11::
  A0_2.spawning = true
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3
    L0_3 = L16_1
    L1_3 = "ped"
    L0_3 = L0_3(L1_3)
    L1_3 = A0_2.cfg
    L1_3 = L1_3.ped
    if not L1_3 then
      L1_3 = {}
    end
    L2_3 = L18_1
    L3_3 = L1_3.model
    if not L3_3 then
      L3_3 = L0_3.model
    end
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = L18_1
      L3_3 = L0_3.model
      L2_3 = L2_3(L3_3)
      if not L2_3 then
        L2_3 = L18_1
        L3_3 = "a_m_y_business_02"
        L2_3 = L2_3(L3_3)
      end
    end
    if not L2_3 then
      L3_3 = print
      L4_3 = "[unique_phone] shop \"%s\": invalid seller model"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = tostring
      L7_3 = A0_2.cfg
      L7_3 = L7_3.id
      L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3 = L6_3(L7_3)
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
      L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
      A0_2.spawning = false
      return
    end
    L3_3 = A0_2.cfg
    L3_3 = L3_3.coords
    L4_3 = L3_3.x
    L5_3 = L3_3.y
    L6_3 = L3_3.z
    L7_3 = L3_3.w
    if not L7_3 then
      L7_3 = 0.0
    end
    L7_3 = L7_3 + 0.0
    L8_3 = RequestCollisionAtCoord
    L9_3 = L4_3
    L10_3 = L5_3
    L11_3 = L6_3
    L8_3(L9_3, L10_3, L11_3)
    L8_3 = L19_1
    L9_3 = L4_3
    L10_3 = L5_3
    L11_3 = L6_3
    L8_3 = L8_3(L9_3, L10_3, L11_3)
    if not L8_3 then
      L8_3 = L6_3 - 1.0
    end
    L9_3 = L1_3.snapToPavement
    if nil == L9_3 then
      L9_3 = L0_3.snapToPavement
    end
    if false ~= L9_3 then
      L10_3 = L20_1
      L11_3 = L4_3
      L12_3 = L5_3
      L13_3 = L8_3
      L10_3 = L10_3(L11_3, L12_3, L13_3)
      if L10_3 then
        L10_3 = L22_1
        L11_3 = L4_3
        L12_3 = L5_3
        L13_3 = L6_3
        L10_3 = L10_3(L11_3, L12_3, L13_3)
        L11_3 = L0_3.snapMax
        if not L11_3 then
          L11_3 = 6.0
        end
        if L10_3 then
          L12_3 = L10_3.x
          L12_3 = L12_3 - L4_3
          L12_3 = L12_3 ^ 2
          L13_3 = L10_3.y
          L13_3 = L13_3 - L5_3
          L13_3 = L13_3 ^ 2
          L12_3 = L12_3 + L13_3
          L13_3 = L11_3 * L11_3
          if L12_3 <= L13_3 then
            L12_3 = L10_3.x
            L5_3 = L10_3.y
            L4_3 = L12_3
            L12_3 = L19_1
            L13_3 = L4_3
            L14_3 = L5_3
            L15_3 = L10_3.z
            L15_3 = L15_3 + 1.0
            L12_3 = L12_3(L13_3, L14_3, L15_3)
            L8_3 = L12_3 or L8_3
            if not L12_3 then
              L8_3 = L10_3.z
            end
            L12_3 = print
            L13_3 = "[unique_phone] shop \"%s\": the configured position is occupied. The seller was moved to: %.2f, %.2f, %.2f (heading %.1f). Fix it in the admin panel (Shop > Locations)."
            L14_3 = L13_3
            L13_3 = L13_3.format
            L15_3 = tostring
            L16_3 = A0_2.cfg
            L16_3 = L16_3.id
            L15_3 = L15_3(L16_3)
            L16_3 = L4_3
            L17_3 = L5_3
            L18_3 = L8_3 + 1.0
            L19_3 = L7_3
            L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3 = L13_3(L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
            L12_3(L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
        end
        else
          L12_3 = print
          L13_3 = "[unique_phone] shop \"%s\": the position seems occupied and there is no free sidewalk within %.0f m. Fix it in the admin panel (Shop > Locations)."
          L14_3 = L13_3
          L13_3 = L13_3.format
          L15_3 = tostring
          L16_3 = A0_2.cfg
          L16_3 = L16_3.id
          L15_3 = L15_3(L16_3)
          L16_3 = L11_3
          L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3 = L13_3(L14_3, L15_3, L16_3)
          L12_3(L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
        end
      end
    end
    L10_3 = A0_2.removed
    if L10_3 then
      L10_3 = SetModelAsNoLongerNeeded
      L11_3 = L2_3
      L10_3(L11_3)
      A0_2.spawning = false
      return
    end
    L10_3 = CreatePed
    L11_3 = 4
    L12_3 = L2_3
    L13_3 = L4_3
    L14_3 = L5_3
    L15_3 = L8_3
    L16_3 = L7_3
    L17_3 = false
    L18_3 = true
    L10_3 = L10_3(L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3)
    L11_3 = SetModelAsNoLongerNeeded
    L12_3 = L2_3
    L11_3(L12_3)
    if not L10_3 or 0 == L10_3 then
      A0_2.spawning = false
      return
    end
    A0_2.pending = L10_3
    L11_3 = SetEntityHeading
    L12_3 = L10_3
    L13_3 = L7_3
    L11_3(L12_3, L13_3)
    L11_3 = SetEntityAsMissionEntity
    L12_3 = L10_3
    L13_3 = true
    L14_3 = true
    L11_3(L12_3, L13_3, L14_3)
    L11_3 = SetBlockingOfNonTemporaryEvents
    L12_3 = L10_3
    L13_3 = true
    L11_3(L12_3, L13_3)
    L11_3 = SetPedFleeAttributes
    L12_3 = L10_3
    L13_3 = 0
    L14_3 = false
    L11_3(L12_3, L13_3, L14_3)
    L11_3 = SetPedCanRagdoll
    L12_3 = L10_3
    L13_3 = false
    L11_3(L12_3, L13_3)
    L11_3 = SetPedCanRagdollFromPlayerImpact
    L12_3 = L10_3
    L13_3 = false
    L11_3(L12_3, L13_3)
    L11_3 = SetPedDiesWhenInjured
    L12_3 = L10_3
    L13_3 = false
    L11_3(L12_3, L13_3)
    L11_3 = SetPedCanBeTargetted
    L12_3 = L10_3
    L13_3 = false
    L11_3(L12_3, L13_3)
    L11_3 = SetPedKeepTask
    L12_3 = L10_3
    L13_3 = true
    L11_3(L12_3, L13_3)
    L11_3 = SetEntityInvincible
    L12_3 = L10_3
    L13_3 = true
    L11_3(L12_3, L13_3)
    L11_3 = Wait
    L12_3 = 400
    L11_3(L12_3)
    A0_2.pending = nil
    L11_3 = L17_1
    L12_3 = L10_3
    L11_3 = L11_3(L12_3)
    if not L11_3 then
      A0_2.spawning = false
      return
    end
    L11_3 = A0_2.removed
    if L11_3 then
      L11_3 = DeleteEntity
      L12_3 = L10_3
      L11_3(L12_3)
      A0_2.spawning = false
      return
    end
    L11_3 = FreezeEntityPosition
    L12_3 = L10_3
    L13_3 = true
    L11_3(L12_3, L13_3)
    L11_3 = L10_3
    A0_2.heading = L7_3
    A0_2.ped = L11_3
    L11_3 = L25_1
    L12_3 = A0_2
    L11_3(L12_3)
    L11_3 = L28_1
    L12_3 = A0_2
    L11_3(L12_3)
    A0_2.spawning = false
    L11_3 = L14_1
    L12_3 = "shop seller %s created"
    L13_3 = tostring
    L14_3 = A0_2.cfg
    L14_3 = L14_3.id
    L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3 = L13_3(L14_3)
    L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
  end
  L1_2(L2_2)
end
function L31_1(A0_2)
  local L1_2, L2_2
  L1_2 = L29_1
  L2_2 = A0_2
  L1_2(L2_2)
  L1_2 = L17_1
  L2_2 = A0_2.ped
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = DeleteEntity
    L2_2 = A0_2.ped
    L1_2(L2_2)
  end
  A0_2.ped = nil
end
function L32_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L16_1
  L1_2 = "blip"
  L0_2 = L0_2(L1_2)
  L1_2 = GetGameBuildNumber
  if L1_2 then
    L1_2 = GetGameBuildNumber
    L1_2 = L1_2()
    if L1_2 then
      goto lbl_12
    end
  end
  L1_2 = 0
  ::lbl_12::
  L2_2 = L0_2.spriteModern
  if L2_2 then
    L2_2 = tonumber
    L3_2 = L0_2.modernBuild
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 3570
    end
    if L1_2 >= L2_2 then
      L2_2 = L0_2.spriteModern
      return L2_2
    end
  end
  L2_2 = L0_2.sprite
  if not L2_2 then
    L2_2 = 817
  end
  return L2_2
end
function L33_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = A0_2.blip
  if L1_2 then
    L1_2 = L1_1
    L2_2 = DoesBlipExist
    L3_2 = A0_2.blip
    L2_2, L3_2 = L2_2(L3_2)
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      L1_2 = RemoveBlip
      L2_2 = A0_2.blip
      L1_2(L2_2)
    end
  end
  A0_2.blip = nil
end
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2.cfg
  L2_2 = L2_2.blipLabel
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L2_2 = A1_2 or L2_2
  if ("string" ~= L3_2 or "" == L2_2) and A1_2 then
    L2_2 = A1_2.label
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 or "" == L2_2 then
    L3_2 = L15_1
    L4_2 = "Loja de telem\195\179veis"
    return L3_2(L4_2)
  end
  L3_2 = L15_1
  L4_2 = L2_2
  return L3_2(L4_2)
end
function L35_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = BeginTextCommandSetBlipName
  L3_2 = "STRING"
  L2_2(L3_2)
  L2_2 = AddTextComponentSubstringPlayerName
  L3_2 = A1_2
  L2_2(L3_2)
  L2_2 = EndTextCommandSetBlipName
  L3_2 = A0_2
  L2_2(L3_2)
end
function L36_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = L16_1
  L1_2 = "blip"
  L0_2 = L0_2(L1_2)
  L1_2 = L0_2.enabled
  if false ~= L1_2 then
    L1_2 = L2_1
    if L1_2 then
      L1_2 = L2_1.enabled
      if false ~= L1_2 then
        goto lbl_14
      end
    end
  end
  do return end
  ::lbl_14::
  L1_2 = L32_1
  L1_2 = L1_2()
  L2_2 = ipairs
  L3_2 = L4_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.removed
    if not L8_2 then
      L8_2 = L7_2.blip
      if not L8_2 then
        L8_2 = L7_2.cfg
        L8_2 = L8_2.blip
        if false ~= L8_2 then
          L8_2 = L7_2.cfg
          L8_2 = L8_2.coords
          if L8_2 then
            L8_2 = L7_2.cfg
            L8_2 = L8_2.coords
            L9_2 = AddBlipForCoord
            L10_2 = L8_2.x
            L11_2 = L8_2.y
            L12_2 = L8_2.z
            L9_2 = L9_2(L10_2, L11_2, L12_2)
            L10_2 = SetBlipSprite
            L11_2 = L9_2
            L12_2 = L1_2
            L10_2(L11_2, L12_2)
            L10_2 = SetBlipColour
            L11_2 = L9_2
            L12_2 = L0_2.color
            if not L12_2 then
              L12_2 = 3
            end
            L10_2(L11_2, L12_2)
            L10_2 = SetBlipScale
            L11_2 = L9_2
            L12_2 = L0_2.scale
            if not L12_2 then
              L12_2 = 0.8
            end
            L12_2 = L12_2 + 0.0
            L10_2(L11_2, L12_2)
            L10_2 = SetBlipDisplay
            L11_2 = L9_2
            L12_2 = 4
            L10_2(L11_2, L12_2)
            L10_2 = SetBlipAsShortRange
            L11_2 = L9_2
            L12_2 = true
            L10_2(L11_2, L12_2)
            L10_2 = L35_1
            L11_2 = L9_2
            L12_2 = L34_1
            L13_2 = L7_2
            L14_2 = L0_2
            L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
            L10_2(L11_2, L12_2, L13_2, L14_2)
            L7_2.blip = L9_2
          end
        end
      end
    end
  end
end
function L37_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L16_1
  L1_2 = "blip"
  L0_2 = L0_2(L1_2)
  L1_2 = ipairs
  L2_2 = L4_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.removed
    if not L7_2 then
      L7_2 = L6_2.blip
      if L7_2 then
        L7_2 = L1_1
        L8_2 = DoesBlipExist
        L9_2 = L6_2.blip
        L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
        L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
        if L7_2 then
          L7_2 = L35_1
          L8_2 = L6_2.blip
          L9_2 = L34_1
          L10_2 = L6_2
          L11_2 = L0_2
          L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2)
          L7_2(L8_2, L9_2, L10_2, L11_2)
        end
      end
      L7_2 = L6_2.targeted
      if L7_2 then
        L7_2 = L6_2.ped
        if L7_2 then
          L7_2 = L29_1
          L8_2 = L6_2
          L7_2(L8_2)
          L7_2 = L28_1
          L8_2 = L6_2
          L7_2(L8_2)
        end
      end
    end
  end
end
L38_1 = PhoneLangOnChange
if L38_1 then
  L38_1 = PhoneLangOnChange
  L39_1 = L37_1
  L38_1(L39_1)
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L1_2 = L16_1
  L2_2 = "camera"
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2.enabled
  if false ~= L2_2 then
    L2_2 = L17_1
    L3_2 = A0_2.ped
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_13
    end
  end
  do return end
  ::lbl_13::
  L2_2 = GetEntityCoords
  L3_2 = A0_2.ped
  L2_2 = L2_2(L3_2)
  L3_2 = GetEntityCoords
  L4_2 = PlayerPedId
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L4_2()
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  L4_2 = L3_2.x
  L5_2 = L2_2.x
  L4_2 = L4_2 - L5_2
  L5_2 = L3_2.y
  L6_2 = L2_2.y
  L5_2 = L5_2 - L6_2
  L6_2 = math
  L6_2 = L6_2.sqrt
  L7_2 = L4_2 * L4_2
  L8_2 = L5_2 * L5_2
  L7_2 = L7_2 + L8_2
  L6_2 = L6_2(L7_2)
  L7_2 = 0.2
  if L6_2 < L7_2 then
    L7_2 = GetEntityForwardVector
    L8_2 = A0_2.ped
    L7_2 = L7_2(L8_2)
    L8_2 = L7_2.x
    L9_2 = L7_2.y
    L6_2 = 1.0
    L5_2 = L9_2
    L4_2 = L8_2
  end
  L7_2 = L4_2 / L6_2
  L5_2 = L5_2 / L6_2
  L4_2 = L7_2
  L7_2 = -L5_2
  L8_2 = L4_2
  L9_2 = L1_2.distance
  if not L9_2 then
    L9_2 = 1.85
  end
  L10_2 = L1_2.height
  if not L10_2 then
    L10_2 = 0.55
  end
  L11_2 = L1_2.shift
  if not L11_2 then
    L11_2 = 0.78
  end
  L12_2 = L2_2.x
  L13_2 = L4_2 * L9_2
  L12_2 = L12_2 + L13_2
  L13_2 = L7_2 * L11_2
  L13_2 = L13_2 * 0.35
  L12_2 = L12_2 + L13_2
  L13_2 = L2_2.y
  L14_2 = L5_2 * L9_2
  L13_2 = L13_2 + L14_2
  L14_2 = L8_2 * L11_2
  L14_2 = L14_2 * 0.35
  L13_2 = L13_2 + L14_2
  L14_2 = L2_2.z
  L14_2 = L14_2 + L10_2
  L15_2 = L2_2.x
  L16_2 = L7_2 * L11_2
  L15_2 = L15_2 + L16_2
  L16_2 = L2_2.y
  L17_2 = L8_2 * L11_2
  L16_2 = L16_2 + L17_2
  L17_2 = L2_2.z
  L17_2 = L17_2 + L10_2
  L17_2 = L17_2 - 0.08
  L18_2 = CreateCamWithParams
  L19_2 = "DEFAULT_SCRIPTED_CAMERA"
  L20_2 = L12_2
  L21_2 = L13_2
  L22_2 = L14_2
  L23_2 = 0.0
  L24_2 = 0.0
  L25_2 = 0.0
  L26_2 = L1_2.fov
  if not L26_2 then
    L26_2 = 42.0
  end
  L26_2 = L26_2 + 0.0
  L27_2 = false
  L28_2 = 0
  L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  L11_1 = L18_2
  L18_2 = PointCamAtCoord
  L19_2 = L11_1
  L20_2 = L15_2
  L21_2 = L16_2
  L22_2 = L17_2
  L18_2(L19_2, L20_2, L21_2, L22_2)
  L18_2 = SetCamActive
  L19_2 = L11_1
  L20_2 = true
  L18_2(L19_2, L20_2)
  L18_2 = RenderScriptCams
  L19_2 = true
  L20_2 = true
  L21_2 = math
  L21_2 = L21_2.floor
  L22_2 = L1_2.ease
  if not L22_2 then
    L22_2 = 700
  end
  L21_2 = L21_2(L22_2)
  L22_2 = true
  L23_2 = true
  L18_2(L19_2, L20_2, L21_2, L22_2, L23_2)
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L11_1
  if not L1_2 then
    return
  end
  L1_2 = L11_1
  L2_2 = nil
  L11_1 = L2_2
  L2_2 = RenderScriptCams
  L3_2 = false
  L4_2 = not A0_2
  if A0_2 then
    L5_2 = 0
    if L5_2 then
      goto lbl_26
    end
  end
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = L16_1
  L7_2 = "camera"
  L6_2 = L6_2(L7_2)
  L6_2 = L6_2.ease
  if not L6_2 then
    L6_2 = 700
  end
  L5_2 = L5_2(L6_2)
  ::lbl_26::
  L6_2 = true
  L7_2 = true
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L2_2 = SetCamActive
  L3_2 = L1_2
  L4_2 = false
  L2_2(L3_2, L4_2)
  L2_2 = DestroyCam
  L3_2 = L1_2
  L4_2 = false
  L2_2(L3_2, L4_2)
end
function L40_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = A0_2.ped
  L2_2 = L17_1
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    return
  end
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = ClearPedTasks
  L4_2 = L1_2
  L3_2(L4_2)
  L3_2 = L23_1
  L4_2 = GetEntityCoords
  L5_2 = L1_2
  L4_2 = L4_2(L5_2)
  L5_2 = GetEntityCoords
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  if L3_2 then
    L4_2 = SetEntityHeading
    L5_2 = L1_2
    L6_2 = L3_2
    L4_2(L5_2, L6_2)
  end
  L4_2 = TaskLookAtEntity
  L5_2 = L1_2
  L6_2 = L2_2
  L7_2 = -1
  L8_2 = 2048
  L9_2 = 3
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = PlayPedAmbientSpeechNative
  L5_2 = L1_2
  L6_2 = "GENERIC_HI"
  L7_2 = "SPEECH_PARAMS_FORCE_NORMAL"
  L4_2(L5_2, L6_2, L7_2)
end
function L41_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = A0_2.ped
  L2_2 = L17_1
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    return
  end
  L2_2 = TaskClearLookAt
  L3_2 = L1_2
  L2_2(L3_2)
  L2_2 = PlayPedAmbientSpeechNative
  L3_2 = L1_2
  L4_2 = "GENERIC_BYE"
  L5_2 = "SPEECH_PARAMS_FORCE_NORMAL"
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = SetTimeout
  L3_2 = 1400
  function L4_2()
    local L0_3, L1_3
    L0_3 = L6_1
    if not L0_3 then
      L0_3 = A0_2.ped
      L1_3 = L1_2
      if L0_3 == L1_3 then
        L0_3 = L17_1
        L1_3 = L1_2
        L0_3 = L0_3(L1_3)
        if L0_3 then
          L0_3 = L25_1
          L1_3 = A0_2
          L0_3(L1_3)
        end
      end
    end
  end
  L2_2(L3_2, L4_2)
end
function L42_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L0_2 = L12_1
  if L0_2 then
    L0_2 = L12_1
    return L0_2
  end
  L0_2 = L2_1
  if L0_2 then
    L0_2 = type
    L1_2 = L2_1.imagePath
    L0_2 = L0_2(L1_2)
    if "string" == L0_2 then
      L0_2 = L2_1.imagePath
      if L0_2 then
        goto lbl_18
      end
    end
  end
  L0_2 = "nui://apex_phone/inventory_images/%s.png"
  ::lbl_18::
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L16_1
  L4_2 = "products"
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.enabled
    if false ~= L8_2 then
      L8_2 = {}
      L9_2 = ipairs
      L10_2 = L7_2.variants
      if not L10_2 then
        L10_2 = {}
      end
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
        L15_2 = L14_2.enabled
        if false ~= L15_2 then
          L15_2 = #L8_2
          L15_2 = L15_2 + 1
          L16_2 = {}
          L17_2 = L14_2.item
          L16_2.item = L17_2
          L17_2 = L14_2.color
          L16_2.color = L17_2
          L17_2 = L14_2.swatch
          L16_2.swatch = L17_2
          L17_2 = math
          L17_2 = L17_2.floor
          L18_2 = tonumber
          L19_2 = L14_2.price
          L18_2 = L18_2(L19_2)
          if not L18_2 then
            L18_2 = tonumber
            L19_2 = L7_2.price
            L18_2 = L18_2(L19_2)
            if not L18_2 then
              L18_2 = 0
            end
          end
          L17_2 = L17_2(L18_2)
          L16_2.price = L17_2
          L17_2 = type
          L18_2 = L14_2.image
          L17_2 = L17_2(L18_2)
          if "string" == L17_2 then
            L17_2 = L14_2.image
            if "" ~= L17_2 then
              L17_2 = L14_2.image
              if L17_2 then
                goto lbl_82
              end
            end
          end
          L18_2 = L0_2
          L17_2 = L0_2.format
          L19_2 = L14_2.item
          L17_2 = L17_2(L18_2, L19_2)
          ::lbl_82::
          L16_2.image = L17_2
          L17_2 = type
          L18_2 = L14_2.model
          L17_2 = L17_2(L18_2)
          if "string" == L17_2 then
            L17_2 = L14_2.model
            if "" ~= L17_2 then
              L17_2 = "models/"
              L18_2 = L14_2.model
              L17_2 = L17_2 .. L18_2
              if L17_2 then
                goto lbl_97
              end
            end
          end
          L17_2 = nil
          ::lbl_97::
          L16_2.model = L17_2
          L8_2[L15_2] = L16_2
        end
      end
      L9_2 = #L8_2
      if L9_2 > 0 then
        L9_2 = #L1_2
        L9_2 = L9_2 + 1
        L10_2 = {}
        L11_2 = L7_2.id
        L10_2.id = L11_2
        L11_2 = L7_2.name
        L10_2.name = L11_2
        L11_2 = L7_2.brand
        L10_2.brand = L11_2
        L11_2 = L7_2.os
        L10_2.os = L11_2
        L11_2 = L7_2.tagline
        L10_2.tagline = L11_2
        L11_2 = L7_2.badge
        L10_2.badge = L11_2
        L11_2 = L7_2.usage
        L10_2.usage = L11_2
        L11_2 = math
        L11_2 = L11_2.floor
        L12_2 = tonumber
        L13_2 = L7_2.price
        L12_2 = L12_2(L13_2)
        if not L12_2 then
          L12_2 = 0
        end
        L11_2 = L11_2(L12_2)
        L10_2.price = L11_2
        L11_2 = L7_2.categories
        if not L11_2 then
          L11_2 = {}
        end
        L10_2.categories = L11_2
        L11_2 = L7_2.features
        if not L11_2 then
          L11_2 = {}
        end
        L10_2.features = L11_2
        L11_2 = L7_2.specs
        if not L11_2 then
          L11_2 = {}
        end
        L10_2.specs = L11_2
        L11_2 = L7_2.viewer
        if not L11_2 then
          L11_2 = {}
        end
        L10_2.viewer = L11_2
        L10_2.variants = L8_2
        L1_2[L9_2] = L10_2
      end
    end
  end
  L2_2 = L16_1
  L3_2 = "payment"
  L2_2 = L2_2(L3_2)
  L3_2 = {}
  L4_2 = L16_1
  L5_2 = "categories"
  L4_2 = L4_2(L5_2)
  L3_2.categories = L4_2
  L3_2.products = L1_2
  L4_2 = L2_1
  if L4_2 then
    L4_2 = L2_1.currency
    if L4_2 then
      goto lbl_203
    end
  end
  L4_2 = {}
  L5_2 = Config
  L5_2 = L5_2.Currency
  if L5_2 then
    L5_2 = Config
    L5_2 = L5_2.Currency
    L5_2 = L5_2.symbol
    if L5_2 then
      goto lbl_191
    end
  end
  L5_2 = "$"
  ::lbl_191::
  L4_2.symbol = L5_2
  L5_2 = Config
  L5_2 = L5_2.Currency
  if L5_2 then
    L5_2 = Config
    L5_2 = L5_2.Currency
    L5_2 = L5_2.position
    if L5_2 then
      goto lbl_202
    end
  end
  L5_2 = "before"
  ::lbl_202::
  L4_2.position = L5_2
  ::lbl_203::
  L3_2.currency = L4_2
  L4_2 = {}
  L5_2 = L2_2.accounts
  if not L5_2 then
    L5_2 = {}
    L6_2 = "bank"
    L7_2 = "cash"
    L5_2[1] = L6_2
    L5_2[2] = L7_2
  end
  L4_2.accounts = L5_2
  L5_2 = L2_2.default
  L4_2.default = L5_2
  L3_2.payment = L4_2
  L12_1 = L3_2
  L3_2 = L12_1
  return L3_2
end
function L43_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if not A0_2 then
    L1_2 = {}
    L1_2.id = ""
    L1_2.label = ""
    L2_2 = {}
    L2_2.name = ""
    L2_2.role = ""
    L2_2.greeting = ""
    L1_2.vendor = L2_2
    return L1_2
  end
  L1_2 = A0_2.cfg
  L1_2 = L1_2.vendor
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = {}
  L3_2 = A0_2.cfg
  L3_2 = L3_2.id
  L2_2.id = L3_2
  L3_2 = A0_2.cfg
  L3_2 = L3_2.label
  if not L3_2 then
    L3_2 = ""
  end
  L2_2.label = L3_2
  L3_2 = {}
  L4_2 = L1_2.name
  if not L4_2 then
    L4_2 = ""
  end
  L3_2.name = L4_2
  L4_2 = L1_2.role
  if not L4_2 then
    L4_2 = "Vendedor"
  end
  L3_2.role = L4_2
  L4_2 = L1_2.greeting
  if not L4_2 then
    L4_2 = ""
  end
  L3_2.greeting = L4_2
  L2_2.vendor = L3_2
  return L2_2
end
function L44_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L17_1
  L2_2 = A0_2.ped
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = GetEntityCoords
  L2_2 = PlayerPedId
  L2_2, L3_2 = L2_2()
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = GetEntityCoords
  L3_2 = A0_2.ped
  L2_2 = L2_2(L3_2)
  L1_2 = L1_2 - L2_2
  L1_2 = #L1_2
  L2_2 = L2_1
  if L2_2 then
    L2_2 = L2_1.closeDistance
    if L2_2 then
      goto lbl_29
    end
  end
  L2_2 = 6.0
  ::lbl_29::
  L1_2 = L1_2 > L2_2
  return L1_2
end
function L45_1()
  local L0_2, L1_2, L2_2
  L0_2 = L10_1
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3
    while true do
      L0_3 = L6_1
      if not L0_3 then
        break
      end
      L0_3 = L10_1
      L1_3 = L0_2
      if L0_3 ~= L1_3 then
        break
      end
      L0_3 = HideHudAndRadarThisFrame
      L0_3()
      L0_3 = L11_1
      if L0_3 then
        L0_3 = L2_1
        if L0_3 then
          L0_3 = L2_1.hidePlayer
          if false ~= L0_3 then
            L0_3 = SetEntityLocallyInvisible
            L1_3 = PlayerPedId
            L1_3 = L1_3()
            L0_3(L1_3)
          end
        end
      end
      L0_3 = Wait
      L1_3 = 0
      L0_3(L1_3)
    end
  end
  L1_2(L2_2)
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3
    while true do
      L0_3 = L6_1
      if not L0_3 then
        break
      end
      L0_3 = L10_1
      L1_3 = L0_2
      if L0_3 ~= L1_3 then
        break
      end
      L0_3 = FW
      L0_3 = L0_3.IsDead
      L0_3 = L0_3()
      if not L0_3 then
        L0_3 = L44_1
        L1_3 = L8_1
        L0_3 = L0_3(L1_3)
        if not L0_3 then
          goto lbl_22
        end
      end
      L0_3 = OverlayClose
      L1_3 = "shop"
      L0_3(L1_3)
      do break end
      ::lbl_22::
      L0_3 = Wait
      L1_3 = 250
      L0_3(L1_3)
    end
  end
  L1_2(L2_2)
end
function L46_1()
  local L0_2, L1_2, L2_2
  L0_2 = L6_1
  if not L0_2 then
    return
  end
  L0_2 = false
  L6_1 = L0_2
  L0_2 = L10_1
  L0_2 = L0_2 + 1
  L10_1 = L0_2
  L0_2 = L39_1
  L1_2 = false
  L0_2(L1_2)
  L0_2 = L8_1
  if L0_2 then
    L1_2 = L41_1
    L2_2 = L0_2
    L1_2(L2_2)
  end
  L1_2 = nil
  L2_2 = false
  L9_1 = L2_2
  L8_1 = L1_2
  L1_2 = TriggerServerEvent
  L2_2 = "apex_phone:server:shopClosed"
  L1_2(L2_2)
end
L47_1 = AddEventHandler
L48_1 = "apex_phone:overlayClosed"
function L49_1(A0_2)
  local L1_2
  if "shop" == A0_2 then
    L1_2 = L46_1
    L1_2()
  end
end
L47_1(L48_1, L49_1)
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L6_1
  if not L2_2 then
    L2_2 = L7_1
    if not L2_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L2_2 = OverlayIsOpen
  if L2_2 then
    L2_2 = OverlayIsOpen
    L3_2 = "shop"
    L2_2 = L2_2(L3_2)
    if L2_2 then
      return
    end
  end
  A1_2 = true == A1_2
  if not A1_2 then
    L2_2 = L2_1
    if L2_2 then
      L2_2 = L2_1.enabled
      if false ~= L2_2 then
        goto lbl_30
      end
    end
    return
  end
  ::lbl_30::
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = FW
  L3_2 = L3_2.IsDead
  L3_2 = L3_2()
  if not L3_2 then
    L3_2 = L1_1
    L4_2 = IsPauseMenuActive
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2()
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
    if not L3_2 then
      goto lbl_44
    end
  end
  do return end
  ::lbl_44::
  if not A1_2 then
    L3_2 = L1_1
    L4_2 = IsPedInAnyVehicle
    L5_2 = L2_2
    L6_2 = false
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2, L6_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
    if L3_2 then
      L3_2 = FW
      L3_2 = L3_2.Notify
      L4_2 = "Sai do ve\195\173culo para falar com o vendedor."
      L5_2 = "error"
      L3_2(L4_2, L5_2)
      return
    end
  end
  if not A1_2 then
    if A0_2 then
      L3_2 = L17_1
      L4_2 = A0_2.ped
      L3_2 = L3_2(L4_2)
      if L3_2 then
        goto lbl_70
      end
    end
    return
  end
  ::lbl_70::
  L3_2 = true
  L7_1 = L3_2
  L3_2 = OverlayRequest
  L4_2 = "shop.state"
  L5_2 = {}
  if A0_2 then
    L6_2 = A0_2.cfg
    L6_2 = L6_2.id
    if L6_2 then
      goto lbl_83
    end
  end
  L6_2 = ""
  ::lbl_83::
  L5_2.shop = L6_2
  L6_2 = 8000
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = false
  L7_1 = L4_2
  L4_2 = L6_1
  if L4_2 then
    return
  end
  if L3_2 then
    L4_2 = L3_2.ok
    if L4_2 then
      goto lbl_108
    end
  end
  L4_2 = FW
  L4_2 = L4_2.Notify
  if L3_2 then
    L5_2 = L3_2.message
    if L5_2 then
      goto lbl_105
    end
  end
  L5_2 = "A loja n\195\163o est\195\161 dispon\195\173vel."
  ::lbl_105::
  L6_2 = "error"
  L4_2(L5_2, L6_2)
  do return end
  ::lbl_108::
  if A0_2 then
    L4_2 = L44_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      return
    end
  end
  L4_2 = FW
  L4_2 = L4_2.IsDead
  L4_2 = L4_2()
  if L4_2 then
    return
  end
  L4_2 = true
  L5_2 = A0_2
  L9_1 = A1_2
  L8_1 = L5_2
  L6_1 = L4_2
  L4_2 = L10_1
  L4_2 = L4_2 + 1
  L10_1 = L4_2
  if A0_2 then
    L4_2 = L40_1
    L5_2 = A0_2
    L4_2(L5_2)
    L4_2 = L38_1
    L5_2 = A0_2
    L4_2(L5_2)
  end
  L4_2 = OverlayOpen
  L5_2 = "shop"
  L6_2 = "shop:open"
  L7_2 = {}
  L8_2 = L43_1
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  L7_2.shop = L8_2
  L8_2 = L42_1
  L8_2 = L8_2()
  L7_2.catalog = L8_2
  L8_2 = L3_2.state
  L7_2.state = L8_2
  L7_2.admin = A1_2
  L8_2 = L11_1
  L8_2 = nil == L8_2
  L7_2.centered = L8_2
  L8_2 = {}
  L9_2 = Config
  L9_2 = L9_2.KeepVoice
  L9_2 = false ~= L9_2
  L8_2.keepInput = L9_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = L45_1
  L4_2()
end
L13_1 = L47_1
L47_1 = OverlayClientHooks
if not L47_1 then
  L47_1 = {}
end
OverlayClientHooks = L47_1
L47_1 = OverlayClientHooks
function L48_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L6_1
  if not L1_2 then
    L1_2 = {}
    L1_2.ok = false
    L1_2.error = "closed"
    L1_2.message = "A loja est\195\161 fechada."
    return L1_2
  end
  L1_2 = L8_1
  L2_2 = OverlayRequest
  L3_2 = "shop.buy"
  L4_2 = {}
  if L1_2 then
    L5_2 = L1_2.cfg
    L5_2 = L5_2.id
    if L5_2 then
      goto lbl_22
    end
  end
  L5_2 = ""
  ::lbl_22::
  L4_2.shop = L5_2
  L5_2 = type
  L6_2 = A0_2.item
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = A0_2.item
    if L5_2 then
      goto lbl_32
    end
  end
  L5_2 = ""
  ::lbl_32::
  L4_2.item = L5_2
  L5_2 = type
  L6_2 = A0_2.account
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = A0_2.account
    if L5_2 then
      goto lbl_42
    end
  end
  L5_2 = ""
  ::lbl_42::
  L4_2.account = L5_2
  L5_2 = 12000
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "timeout"
    L2_2 = L3_2
  end
  L3_2 = L2_2.ok
  if not L3_2 then
    L3_2 = L2_2.message
    if not L3_2 then
      L3_2 = L2_2.error
      if "timeout" == L3_2 then
        L3_2 = "O servidor n\195\163o respondeu. Tenta outra vez."
        if L3_2 then
          goto lbl_68
        end
      end
      L3_2 = "Ocorreu um erro no servidor. Tenta outra vez."
      ::lbl_68::
      L2_2.message = L3_2
    end
  end
  L3_2 = L2_2.ok
  if L3_2 and L1_2 then
    L3_2 = L17_1
    L4_2 = L1_2.ped
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = PlayPedAmbientSpeechNative
      L4_2 = L1_2.ped
      L5_2 = "GENERIC_THANKS"
      L6_2 = "SPEECH_PARAMS_FORCE_NORMAL"
      L3_2(L4_2, L5_2, L6_2)
    end
  end
  return L2_2
end
L47_1["shop.buy"] = L48_1
L47_1 = OverlayClientHooks
function L48_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L6_1
  if not L0_2 then
    L0_2 = {}
    L0_2.ok = false
    L0_2.error = "closed"
    return L0_2
  end
  L0_2 = OverlayRequest
  L1_2 = "shop.state"
  L2_2 = {}
  L3_2 = L8_1
  if L3_2 then
    L3_2 = L8_1.cfg
    L3_2 = L3_2.id
    if L3_2 then
      goto lbl_21
    end
  end
  L3_2 = ""
  ::lbl_21::
  L2_2.shop = L3_2
  L0_2 = L0_2(L1_2, L2_2)
  if not L0_2 then
    L0_2 = {}
    L0_2.ok = false
  end
  return L0_2
end
L47_1["shop.refresh"] = L48_1
function L47_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L4_2 = GetScreenCoordFromWorldCoord
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = A2_2
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2, L7_2)
  L7_2 = L1_1
  L8_2 = L4_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    return
  end
  L7_2 = SetTextScale
  L8_2 = 0.0
  L9_2 = 0.32
  L7_2(L8_2, L9_2)
  L7_2 = SetTextFont
  L8_2 = 4
  L7_2(L8_2)
  L7_2 = SetTextColour
  L8_2 = 255
  L9_2 = 255
  L10_2 = 255
  L11_2 = 235
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = SetTextCentre
  L8_2 = true
  L7_2(L8_2)
  L7_2 = BeginTextCommandDisplayText
  L8_2 = "STRING"
  L7_2(L8_2)
  L7_2 = AddTextComponentSubstringPlayerName
  L8_2 = A3_2
  L7_2(L8_2)
  L7_2 = EndTextCommandDisplayText
  L8_2 = L5_2
  L9_2 = L6_2
  L7_2(L8_2, L9_2)
  L7_2 = DrawRect
  L8_2 = L5_2
  L9_2 = L6_2 + 0.0122
  L10_2 = #A3_2
  L10_2 = L10_2 / 340.0
  L10_2 = L10_2 + 0.014
  L11_2 = 0.031
  L12_2 = 12
  L13_2 = 12
  L14_2 = 14
  L15_2 = 175
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
end
L48_1 = CreateThread
function L49_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  while true do
    L0_2 = 750
    L1_2 = L5_1
    if not L1_2 then
      L1_2 = L6_1
      if not L1_2 then
        L1_2 = L7_1
        if not L1_2 then
          L1_2 = L2_1
          if L1_2 then
            L1_2 = L2_1.enabled
            if false ~= L1_2 then
              L1_2 = PlayerPedId
              L1_2 = L1_2()
              L2_2 = GetEntityCoords
              L3_2 = L1_2
              L2_2 = L2_2(L3_2)
              L3_2 = L16_1
              L4_2 = "interaction"
              L3_2 = L3_2(L4_2)
              L4_2 = L3_2.key
              if not L4_2 then
                L4_2 = 38
              end
              L5_2 = L3_2.distance
              if not L5_2 then
                L5_2 = 2.0
              end
              L6_2 = ipairs
              L7_2 = L4_1
              L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
              for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
                L12_2 = L11_2.removed
                if not L12_2 then
                  L12_2 = L17_1
                  L13_2 = L11_2.ped
                  L12_2 = L12_2(L13_2)
                  if L12_2 then
                    L12_2 = GetEntityCoords
                    L13_2 = L11_2.ped
                    L12_2 = L12_2(L13_2)
                    L13_2 = L2_2 - L12_2
                    L13_2 = #L13_2
                    if L13_2 < 10.0 then
                      L0_2 = 0
                    end
                    if L5_2 >= L13_2 then
                      L14_2 = L47_1
                      L15_2 = L12_2.x
                      L16_2 = L12_2.y
                      L17_2 = L12_2.z
                      L17_2 = L17_2 + 1.02
                      L18_2 = "[%s] %s"
                      L19_2 = L18_2
                      L18_2 = L18_2.format
                      L20_2 = L3_2.keyLabel
                      if not L20_2 then
                        L20_2 = "E"
                      end
                      L21_2 = L26_1
                      L21_2 = L21_2()
                      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2, L20_2, L21_2)
                      L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
                      L14_2 = L1_1
                      L15_2 = IsControlJustReleased
                      L16_2 = 0
                      L17_2 = L4_2
                      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L15_2(L16_2, L17_2)
                      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
                      if L14_2 then
                        L14_2 = L1_1
                        L15_2 = IsPedInAnyVehicle
                        L16_2 = L1_2
                        L17_2 = false
                        L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L15_2(L16_2, L17_2)
                        L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
                        if not L14_2 then
                          L14_2 = CreateThread
                          function L15_2()
                            local L0_3, L1_3, L2_3
                            L0_3 = L13_1
                            L1_3 = L11_2
                            L2_3 = false
                            L0_3(L1_3, L2_3)
                          end
                          L14_2(L15_2)
                        end
                      end
                      break
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    L1_2 = Wait
    L2_2 = L0_2
    L1_2(L2_2)
  end
end
L48_1(L49_1)
L48_1 = RegisterNetEvent
L49_1 = "apex_phone:client:shopAdminOpen"
function L50_1()
  local L0_2, L1_2, L2_2
  L0_2 = L13_1
  L1_2 = nil
  L2_2 = true
  L0_2(L1_2, L2_2)
end
L48_1(L49_1, L50_1)
function L48_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = ipairs
  L2_2 = L16_1
  L3_2 = "shops"
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L2_2(L3_2)
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.id
    if L7_2 == A0_2 then
      return L6_2
    end
  end
  L1_2 = nil
  return L1_2
end
function L49_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if A0_2 and A1_2 then
    L2_2 = A0_2.coords
    if L2_2 then
      L2_2 = A1_2.coords
      if L2_2 then
        goto lbl_13
      end
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_13::
  L2_2 = A0_2.coords
  L2_2 = L2_2.x
  L3_2 = A1_2.coords
  L3_2 = L3_2.x
  L2_2 = L2_2 - L3_2
  L3_2 = A0_2.coords
  L3_2 = L3_2.y
  L4_2 = A1_2.coords
  L4_2 = L4_2.y
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.coords
  L4_2 = L4_2.z
  L5_2 = A1_2.coords
  L5_2 = L5_2.z
  L4_2 = L4_2 - L5_2
  L5_2 = A0_2.ped
  if not L5_2 then
    L5_2 = {}
  end
  L5_2 = L5_2.model
  L6_2 = A1_2.ped
  if not L6_2 then
    L6_2 = {}
  end
  L6_2 = L6_2.model
  L7_2 = L2_2 * L2_2
  L8_2 = L3_2 * L3_2
  L7_2 = L7_2 + L8_2
  L8_2 = L4_2 * L4_2
  L7_2 = L7_2 + L8_2
  L8_2 = 0.25
  L7_2 = L7_2 < L8_2 and L5_2 == L6_2
  return L7_2
end
function L50_1(A0_2)
  local L1_2, L2_2
  A0_2.removed = true
  L1_2 = L29_1
  L2_2 = A0_2
  L1_2(L2_2)
  L1_2 = L17_1
  L2_2 = A0_2.ped
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = DeleteEntity
    L2_2 = A0_2.ped
    L1_2(L2_2)
  end
  A0_2.ped = nil
  L1_2 = A0_2.pending
  if L1_2 then
    L1_2 = L17_1
    L2_2 = A0_2.pending
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = DeleteEntity
      L2_2 = A0_2.pending
      L1_2(L2_2)
    end
  end
  A0_2.pending = nil
  L1_2 = L33_1
  L2_2 = A0_2
  L1_2(L2_2)
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L8_1
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = A0_2 or L2_2
  if "table" ~= L2_2 or not A0_2 then
    L2_2 = nil
  end
  L2_1 = L2_2
  L2_2 = nil
  L12_1 = L2_2
  L2_2 = L2_1
  L2_2 = nil ~= L2_2
  L3_2 = nil
  L4_2 = L6_1
  if L4_2 and L1_2 then
    if L2_2 then
      L4_2 = L48_1
      L5_2 = L1_2.cfg
      L5_2 = L5_2.id
      L4_2 = L4_2(L5_2)
      if L4_2 then
        goto lbl_36
      end
    end
    L4_2 = nil
    ::lbl_36::
    if L4_2 then
      L5_2 = L49_1
      L6_2 = L4_2
      L7_2 = L1_2.cfg
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L3_2 = L1_2
        L3_2.cfg = L4_2
    end
    else
      L5_2 = OverlayClose
      L6_2 = "shop"
      L5_2(L6_2)
    end
  end
  L4_2 = ipairs
  L5_2 = L4_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    if L9_2 ~= L3_2 then
      L10_2 = L50_1
      L11_2 = L9_2
      L10_2(L11_2)
    else
      L10_2 = L33_1
      L11_2 = L9_2
      L10_2(L11_2)
    end
  end
  L4_2 = {}
  L4_1 = L4_2
  if L2_2 then
    L4_2 = ipairs
    L5_2 = L16_1
    L6_2 = "shops"
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2)
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      if L3_2 then
        L10_2 = L9_2.id
        L11_2 = L3_2.cfg
        L11_2 = L11_2.id
        if L10_2 == L11_2 then
          L10_2 = L4_1
          L10_2 = #L10_2
          L11_2 = L10_2 + 1
          L10_2 = L4_1
          L10_2[L11_2] = L3_2
      end
      else
        L10_2 = type
        L11_2 = L9_2.coords
        L10_2 = L10_2(L11_2)
        if "table" == L10_2 then
          L10_2 = L4_1
          L10_2 = #L10_2
          L11_2 = L10_2 + 1
          L10_2 = L4_1
          L12_2 = {}
          L12_2.cfg = L9_2
          L12_2.removed = false
          L10_2[L11_2] = L12_2
        end
      end
    end
    L4_2 = L36_1
    L4_2()
  end
  if L3_2 then
    L4_2 = L3_2.ped
    if L4_2 then
      L4_2 = L29_1
      L5_2 = L3_2
      L4_2(L5_2)
      L4_2 = L28_1
      L5_2 = L3_2
      L4_2(L5_2)
    end
  end
  L4_2 = L6_1
  if L4_2 then
    L4_2 = Push
    L5_2 = "shop:catalog"
    L6_2 = {}
    L7_2 = L42_1
    L7_2 = L7_2()
    L6_2.catalog = L7_2
    L7_2 = L43_1
    L8_2 = L8_1
    L7_2 = L7_2(L8_2)
    L6_2.shop = L7_2
    L4_2(L5_2, L6_2)
  end
  L4_2 = L14_1
  L5_2 = "data rev %s: %d shops%s"
  L6_2 = tostring
  L7_2 = L2_1
  if L7_2 then
    L7_2 = L2_1.rev
  end
  L6_2 = L6_2(L7_2)
  L7_2 = L4_1
  L7_2 = #L7_2
  if L2_2 then
    L8_2 = ""
    if L8_2 then
      goto lbl_153
    end
  end
  L8_2 = " (shop disabled)"
  ::lbl_153::
  L4_2(L5_2, L6_2, L7_2, L8_2)
end
L52_1 = AddStateBagChangeHandler
L53_1 = "apex_phone:shop"
L54_1 = "global"
function L55_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A2_2.rev
    L4_2 = L3_1
    if L3_2 ~= L4_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L3_2 = A2_2.rev
  L3_1 = L3_2
  L3_2 = L51_1
  L4_2 = A2_2
  L3_2(L4_2)
end
L52_1(L53_1, L54_1, L55_1)
L52_1 = CreateThread
function L53_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = L16_1
  L1_2 = "interaction"
  L0_2 = L0_2(L1_2)
  L0_2 = L0_2.mode
  if not L0_2 then
    L0_2 = "auto"
  end
  L1_2 = GetResourceState
  L2_2 = "ox_target"
  L1_2 = L1_2(L2_2)
  L1_2 = "started" == L1_2
  L2_2 = "key" ~= L0_2 and L2_2
  L5_1 = L2_2
  L2_2 = 1
  L3_2 = 40
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = GlobalState
    L6_2 = L6_2["apex_phone:shop"]
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L7_2 = L6_2.rev
      L8_2 = L3_1
      if L7_2 ~= L8_2 then
        L7_2 = L6_2.rev
        L3_1 = L7_2
        L7_2 = L51_1
        L8_2 = L6_2
        L7_2(L8_2)
      end
      break
    end
    L7_2 = Wait
    L8_2 = 500
    L7_2(L8_2)
  end
  L2_2 = L2_1
  if L2_2 then
    L2_2 = L16_1
    L3_2 = "interaction"
    L2_2 = L2_2(L3_2)
    L2_2 = L2_2.mode
    L0_2 = L2_2 or L0_2
    if not L2_2 then
      L0_2 = "auto"
    end
    L2_2 = "key" ~= L0_2 and L2_2
    L5_1 = L2_2
    if "target" == L0_2 and not L1_2 then
      L2_2 = print
      L3_2 = "[unique_phone] shop: interaction.mode = \"target\" but ox_target is not running: using the key"
      L2_2(L3_2)
    end
  end
  while true do
    L2_2 = L16_1
    L3_2 = "ped"
    L2_2 = L2_2(L3_2)
    L2_2 = L2_2.spawnDistance
    if not L2_2 then
      L2_2 = 70.0
    end
    L3_2 = GetEntityCoords
    L4_2 = PlayerPedId
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2()
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L4_2 = ipairs
    L5_2 = L4_1
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = L9_2.removed
      if not L10_2 then
        L10_2 = L9_2.cfg
        L10_2 = L10_2.coords
        if L10_2 then
          L10_2 = L9_2.cfg
          L10_2 = L10_2.coords
          L11_2 = vector3
          L12_2 = L10_2.x
          L13_2 = L10_2.y
          L14_2 = L10_2.z
          L11_2 = L11_2(L12_2, L13_2, L14_2)
          L11_2 = L3_2 - L11_2
          L11_2 = #L11_2
          if L2_2 > L11_2 then
            L12_2 = L9_2.ped
            if not L12_2 then
              L12_2 = L9_2.spawning
              if not L12_2 then
                L12_2 = L30_1
                L13_2 = L9_2
                L12_2(L13_2)
              end
            end
          else
            L12_2 = L2_2 + 15.0
            if L11_2 > L12_2 then
              L12_2 = L9_2.ped
              if L12_2 then
                L12_2 = L6_1
                if L12_2 then
                  L12_2 = L8_1
                  if L12_2 == L9_2 then
                    goto lbl_131
                  end
                end
                L12_2 = L31_1
                L13_2 = L9_2
                L12_2(L13_2)
              end
            end
          end
        end
      end
      ::lbl_131::
    end
    L4_2 = Wait
    L5_2 = 1000
    L4_2(L5_2)
  end
end
L52_1(L53_1)
L52_1 = AddEventHandler
L53_1 = "onClientResourceStop"
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if "ox_target" ~= A0_2 then
    return
  end
  L1_2 = ipairs
  L2_2 = L4_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2.targeted = false
  end
  L1_2 = L5_1
  if L1_2 then
    L1_2 = false
    L5_1 = L1_2
    L1_2 = L14_1
    L2_2 = "ox_target stopped: using the key"
    L1_2(L2_2)
  end
end
L52_1(L53_1, L54_1)
L52_1 = AddEventHandler
L53_1 = "onClientResourceStart"
function L54_1(A0_2)
  local L1_2, L2_2, L3_2
  if "ox_target" ~= A0_2 then
    return
  end
  L1_2 = L16_1
  L2_2 = "interaction"
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2.mode
  if "key" == L1_2 then
    return
  end
  L1_2 = true
  L5_1 = L1_2
  L1_2 = SetTimeout
  L2_2 = 1000
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = ipairs
    L1_3 = L4_1
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
    for L4_3, L5_3 in L0_3, L1_3, L2_3, L3_3 do
      L6_3 = L5_3.ped
      if L6_3 then
        L6_3 = L5_3.removed
        if not L6_3 then
          L6_3 = L28_1
          L7_3 = L5_3
          L6_3(L7_3)
        end
      end
    end
  end
  L1_2(L2_2, L3_2)
end
L52_1(L53_1, L54_1)
L52_1 = AddEventHandler
L53_1 = "onResourceStop"
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L0_1
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = false
  L6_1 = L1_2
  L1_2 = L10_1
  L1_2 = L1_2 + 1
  L10_1 = L1_2
  L1_2 = L39_1
  L2_2 = true
  L1_2(L2_2)
  L1_2 = ipairs
  L2_2 = L4_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L50_1
    L8_2 = L6_2
    L7_2(L8_2)
  end
  L1_2 = {}
  L4_1 = L1_2
end
L52_1(L53_1, L54_1)
