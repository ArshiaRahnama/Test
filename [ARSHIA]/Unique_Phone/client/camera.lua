local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1
L0_1 = false
L1_1 = false
L2_1 = 1.0
L3_1 = nil
L4_1 = false
L5_1 = 0.0
L6_1 = 0.0
L7_1 = false
L8_1 = 32
L9_1 = false
L10_1 = {}
L11_1 = 0
L12_1 = ""
L13_1 = 0.0
L14_1 = 0.0
L15_1 = 0.0
L16_1 = 0.0
L17_1 = 0.0
L18_1 = {}
L19_1 = 1
L20_1 = 2
L21_1 = 3
L22_1 = 4
L23_1 = 6
L24_1 = 7
L25_1 = 8
L26_1 = 9
L27_1 = 13
L28_1 = 19
L29_1 = 20
L30_1 = 21
L31_1 = 22
L18_1[1] = L19_1
L18_1[2] = L20_1
L18_1[3] = L21_1
L18_1[4] = L22_1
L18_1[5] = L23_1
L18_1[6] = L24_1
L18_1[7] = L25_1
L18_1[8] = L26_1
L18_1[9] = L27_1
L18_1[10] = L28_1
L18_1[11] = L29_1
L18_1[12] = L30_1
L18_1[13] = L31_1
function L19_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = HideHudAndRadarThisFrame
  L0_2()
  L0_2 = 1
  L1_2 = L18_1
  L1_2 = #L1_2
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = HideHudComponentThisFrame
    L5_2 = L18_1
    L5_2 = L5_2[L3_2]
    L4_2(L5_2)
  end
end
function L20_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L3_1
  if L0_2 then
    L0_2 = RenderScriptCams
    L1_2 = false
    L2_2 = true
    L3_2 = 250
    L4_2 = true
    L5_2 = true
    L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
    L0_2 = DestroyCam
    L1_2 = L3_1
    L2_2 = false
    L0_2(L1_2, L2_2)
    L0_2 = nil
    L3_1 = L0_2
  end
end
function L21_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L3_1
  if not L0_2 then
    L0_2 = CreateCam
    L1_2 = "DEFAULT_SCRIPTED_CAMERA"
    L2_2 = true
    L0_2 = L0_2(L1_2, L2_2)
    L3_1 = L0_2
    L0_2 = SetCamNearClip
    L1_2 = L3_1
    L2_2 = 0.05
    L0_2(L1_2, L2_2)
    L0_2 = RenderScriptCams
    L1_2 = true
    L2_2 = true
    L3_2 = 250
    L4_2 = true
    L5_2 = true
    L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  end
  L0_2 = L3_1
  return L0_2
end
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = math
  L2_2 = L2_2.rad
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.rad
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = math
  L4_2 = L4_2.sin
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L4_2 = -L4_2
  L5_2 = math
  L5_2 = L5_2.cos
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L4_2 = L4_2 * L5_2
  L5_2 = math
  L5_2 = L5_2.cos
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L6_2 = math
  L6_2 = L6_2.cos
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 * L6_2
  L6_2 = math
  L6_2 = L6_2.sin
  L7_2 = L3_2
  L6_2, L7_2 = L6_2(L7_2)
  return L4_2, L5_2, L6_2, L7_2
end
L23_1 = false
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L23_1
  if A0_2 == L1_2 then
    return
  end
  L23_1 = A0_2
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  L2_2 = SetPhonePropVisible
  if L2_2 then
    L2_2 = SetPhonePropVisible
    L3_2 = not A0_2
    L2_2(L3_2)
  end
  if A0_2 then
    L2_2 = CreateThread
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
      L0_3 = RequestAnimDict
      L1_3 = "cellphone@"
      L0_3(L1_3)
      L0_3 = 0
      while true do
        L1_3 = HasAnimDictLoaded
        L2_3 = "cellphone@"
        L1_3 = L1_3(L2_3)
        if not (not L1_3 and L0_3 < 120) then
          break
        end
        L1_3 = Wait
        L2_3 = 10
        L1_3(L2_3)
        L0_3 = L0_3 + 1
      end
      L1_3 = L23_1
      if L1_3 then
        L1_3 = HasAnimDictLoaded
        L2_3 = "cellphone@"
        L1_3 = L1_3(L2_3)
        if L1_3 then
          L1_3 = TaskPlayAnim
          L2_3 = L1_2
          L3_3 = "cellphone@"
          L4_3 = "cellphone_photo_in"
          L5_3 = 3.0
          L6_3 = -1.0
          L7_3 = -1
          L8_3 = 49
          L9_3 = 0
          L10_3 = false
          L11_3 = false
          L12_3 = false
          L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
          L1_3 = Wait
          L2_3 = 500
          L1_3(L2_3)
          L1_3 = L23_1
          if L1_3 then
            L1_3 = HasAnimDictLoaded
            L2_3 = "cellphone@"
            L1_3 = L1_3(L2_3)
            if L1_3 then
              L1_3 = TaskPlayAnim
              L2_3 = L1_2
              L3_3 = "cellphone@"
              L4_3 = "cellphone_photo_idle"
              L5_3 = 3.0
              L6_3 = -1.0
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
      end
    end
    L2_2(L3_2)
  else
    L2_2 = StopAnimTask
    L3_2 = L1_2
    L4_2 = "cellphone@"
    L5_2 = "cellphone_photo_idle"
    L6_2 = 1.0
    L2_2(L3_2, L4_2, L5_2, L6_2)
    L2_2 = StopAnimTask
    L3_2 = L1_2
    L4_2 = "cellphone@"
    L5_2 = "cellphone_photo_in"
    L6_2 = 1.0
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
end
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = {}
  L1_2 = 0
  L2_2 = L8_1
  L2_2 = L2_2 - 1
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = #L0_2
    L5_2 = L5_2 + 1
    L6_2 = L10_1
    L6_2 = L6_2[L4_2]
    if L6_2 then
      L6_2 = "1"
      if L6_2 then
        goto lbl_20
      end
    end
    L6_2 = "0"
    ::lbl_20::
    L0_2[L5_2] = L6_2
  end
  L1_2 = table
  L1_2 = L1_2.concat
  L2_2 = L0_2
  return L1_2(L2_2)
end
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = {}
  L1_2 = 0
  L2_2 = ""
  L12_1 = L2_2
  L11_1 = L1_2
  L10_1 = L0_2
  L0_2 = GetGameplayCamRot
  L1_2 = 2
  L0_2 = L0_2(L1_2)
  L1_2 = L0_2.z
  L2_2 = L0_2.x
  L3_2 = 0.0
  L4_2 = 0.0
  L17_1 = L4_2
  L16_1 = L3_2
  L14_1 = L2_2
  L13_1 = L1_2
  L1_2 = GetEntityHeading
  L2_2 = PlayerPedId
  L2_2, L3_2, L4_2 = L2_2()
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L15_1 = L1_2
  L1_2 = L15_1
  L2_2 = 0.0
  L6_1 = L2_2
  L5_1 = L1_2
  L1_2 = Push
  L2_2 = "faceCoverage"
  L3_2 = {}
  L4_2 = L25_1
  L4_2 = L4_2()
  L3_2.mask = L4_2
  L3_2.n = 0
  L4_2 = L8_1
  L3_2.total = L4_2
  L3_2.now = -1
  L1_2(L2_2, L3_2)
end
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L5_1
  L1_2 = GetEntityHeading
  L2_2 = PlayerPedId
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L2_2()
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L0_2 = L0_2 - L1_2
  L0_2 = L0_2 + 180.0
  L0_2 = L0_2 % 360.0
  L0_2 = L0_2 - 180.0
  L1_2 = L6_1
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = tonumber
  L4_2 = Config
  L4_2 = L4_2.FaceId
  if L4_2 then
    L4_2 = Config
    L4_2 = L4_2.FaceId
    L4_2 = L4_2.Spread
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 3
  end
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = Config
  L4_2 = L4_2.FaceId
  if L4_2 then
    L4_2 = Config
    L4_2 = L4_2.FaceId
    L4_2 = L4_2.MinAngle
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 5.0
  end
  L4_2 = math
  L4_2 = L4_2.sqrt
  L5_2 = L0_2 * L0_2
  L6_2 = L1_2 * 1.35
  L7_2 = L1_2 * 1.35
  L6_2 = L6_2 * L7_2
  L5_2 = L5_2 + L6_2
  L4_2 = L4_2(L5_2)
  if L3_2 > L4_2 then
    return
  end
  L4_2 = math
  L4_2 = L4_2.deg
  L5_2 = math
  L5_2 = L5_2.atan
  L6_2 = -L0_2
  L7_2 = L1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L4_2 = L4_2 + 360.0
  L4_2 = L4_2 % 360.0
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = L8_1
  L7_2 = 360.0
  L6_2 = L7_2 / L6_2
  L6_2 = L4_2 / L6_2
  L5_2 = L5_2(L6_2)
  L6_2 = L8_1
  L5_2 = L5_2 % L6_2
  L6_2 = -L2_2
  L7_2 = L2_2
  L8_2 = 1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = L5_2 + L9_2
    L11_2 = L8_1
    L10_2 = L10_2 % L11_2
    L11_2 = L10_1
    L11_2 = L11_2[L10_2]
    if not L11_2 then
      L11_2 = L10_1
      L11_2[L10_2] = true
      L11_2 = L11_1
      L11_2 = L11_2 + 1
      L11_1 = L11_2
    end
  end
  L6_2 = L25_1
  L6_2 = L6_2()
  L7_2 = L12_1
  if L6_2 ~= L7_2 then
    L12_1 = L6_2
    L7_2 = Push
    L8_2 = "faceCoverage"
    L9_2 = {}
    L9_2.mask = L6_2
    L10_2 = L11_1
    L9_2.n = L10_2
    L10_2 = L8_1
    L9_2.total = L10_2
    L9_2.now = L5_2
    L7_2(L8_2, L9_2)
  end
end
function L28_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetGameplayCamRot
  L2_2 = 2
  L1_2 = L1_2(L2_2)
  L2_2 = tonumber
  L3_2 = Config
  L3_2 = L3_2.FaceId
  if L3_2 then
    L3_2 = Config
    L3_2 = L3_2.FaceId
    L3_2 = L3_2.MaxAngle
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 46.0
  end
  L3_2 = L1_2.z
  L4_2 = L13_1
  L3_2 = L3_2 - L4_2
  L3_2 = L3_2 + 180.0
  L3_2 = L3_2 % 360.0
  L3_2 = L3_2 - 180.0
  L4_2 = L1_2.z
  L13_1 = L4_2
  L4_2 = L16_1
  L4_2 = L4_2 + L3_2
  L16_1 = L4_2
  L4_2 = L16_1
  if L2_2 < L4_2 then
    L16_1 = L2_2
  else
    L4_2 = L16_1
    L5_2 = -L2_2
    if L4_2 < L5_2 then
      L4_2 = -L2_2
      L16_1 = L4_2
    end
  end
  L4_2 = L17_1
  L5_2 = L1_2.x
  L6_2 = L14_1
  L5_2 = L5_2 - L6_2
  L4_2 = L4_2 + L5_2
  L17_1 = L4_2
  L4_2 = L1_2.x
  L14_1 = L4_2
  L4_2 = L17_1
  if L2_2 < L4_2 then
    L17_1 = L2_2
  else
    L4_2 = L17_1
    L5_2 = -L2_2
    if L4_2 < L5_2 then
      L4_2 = -L2_2
      L17_1 = L4_2
    end
  end
  L4_2 = L15_1
  L5_2 = L16_1
  L4_2 = L4_2 + L5_2
  L4_2 = L4_2 % 360.0
  L5_2 = L17_1
  L6_1 = L5_2
  L5_1 = L4_2
  L4_2 = GetPedBoneCoords
  L5_2 = L0_2
  L6_2 = 31086
  L7_2 = 0.0
  L8_2 = 0.0
  L9_2 = 0.0
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L5_2 = L22_1
  L6_2 = L6_1
  L7_2 = L5_1
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  L8_2 = 0.58
  L9_2 = SetCamCoord
  L10_2 = L21_1
  L10_2 = L10_2()
  L11_2 = L4_2.x
  L12_2 = L5_2 * L8_2
  L11_2 = L11_2 + L12_2
  L12_2 = L4_2.y
  L13_2 = L6_2 * L8_2
  L12_2 = L12_2 + L13_2
  L13_2 = L4_2.z
  L13_2 = L13_2 + 0.02
  L14_2 = L7_2 * L8_2
  L13_2 = L13_2 + L14_2
  L9_2(L10_2, L11_2, L12_2, L13_2)
  L9_2 = PointCamAtCoord
  L10_2 = L3_1
  L11_2 = L4_2.x
  L12_2 = L4_2.y
  L13_2 = L4_2.z
  L13_2 = L13_2 + 0.01
  L9_2(L10_2, L11_2, L12_2, L13_2)
  L9_2 = SetCamFov
  L10_2 = L3_1
  L11_2 = 32.0
  L9_2(L10_2, L11_2)
  L9_2 = L27_1
  L9_2()
end
L29_1 = 413312110
function L30_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = Citizen
  L1_2 = L1_2.InvokeNative
  L2_2 = 2635073306796480568
  if A0_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_10
    end
  end
  L3_2 = false
  ::lbl_10::
  L1_2(L2_2, L3_2)
end
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = SetEntityAsMissionEntity
  L2_2 = A0_2
  L3_2 = true
  L4_2 = true
  L1_2(L2_2, L3_2, L4_2)
  L1_2 = DeleteObject
  L2_2 = A0_2
  L1_2(L2_2)
end
function L32_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = GetClosestObjectOfType
  L3_2 = L1_2.x
  L4_2 = L1_2.y
  L5_2 = L1_2.z
  L6_2 = 1.5
  L7_2 = L29_1
  L8_2 = false
  L9_2 = false
  L10_2 = false
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  if L2_2 and 0 ~= L2_2 then
    L3_2 = GetEntityAttachedTo
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 == L0_2 then
      L3_2 = L31_1
      L4_2 = L2_2
      L3_2(L4_2)
      return
    end
  end
  L3_2 = GetGamePool
  L4_2 = "CObject"
  L3_2 = L3_2(L4_2)
  L4_2 = 1
  L5_2 = #L3_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L3_2[L7_2]
    L9_2 = GetEntityModel
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L10_2 = L29_1
    if L9_2 == L10_2 then
      L9_2 = GetEntityAttachedTo
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if L9_2 == L0_2 then
        L10_2 = L31_1
        L11_2 = L8_2
        L10_2(L11_2)
        return
      elseif 0 == L9_2 then
        L10_2 = GetEntityCoords
        L11_2 = L8_2
        L10_2 = L10_2(L11_2)
        L10_2 = L1_2 - L10_2
        L10_2 = #L10_2
        L11_2 = 1.5
        if L10_2 < L11_2 then
          L10_2 = L31_1
          L11_2 = L8_2
          L10_2(L11_2)
        end
      end
    end
  end
end
L33_1 = false
function L34_1()
  local L0_2, L1_2, L2_2
  L0_2 = L33_1
  if L0_2 then
    return
  end
  L0_2 = true
  L33_1 = L0_2
  L0_2 = L20_1
  L0_2()
  L0_2 = CreateMobilePhone
  L1_2 = 0
  L0_2(L1_2)
  L0_2 = CellCamActivate
  L1_2 = true
  L2_2 = true
  L0_2(L1_2, L2_2)
  L0_2 = L30_1
  L1_2 = L1_1
  L0_2(L1_2)
  L0_2 = SetTimeout
  L1_2 = 500
  function L2_2()
    local L0_3, L1_3
    L0_3 = L33_1
    if L0_3 then
      L0_3 = L32_1
      L0_3()
    end
  end
  L0_2(L1_2, L2_2)
end
function L35_1()
  local L0_2, L1_2, L2_2
  L0_2 = L33_1
  if not L0_2 then
    return
  end
  L0_2 = false
  L33_1 = L0_2
  L0_2 = DestroyMobilePhone
  L0_2()
  L0_2 = CellCamActivate
  L1_2 = false
  L2_2 = false
  L0_2(L1_2, L2_2)
  L0_2 = L30_1
  L1_2 = false
  L0_2(L1_2)
end
L36_1 = {}
L37_1 = 24
L38_1 = 25
L39_1 = 37
L40_1 = 44
L41_1 = 45
L42_1 = 47
L43_1 = 58
L44_1 = 140
L45_1 = 141
L46_1 = 142
L47_1 = 143
L48_1 = 257
L49_1 = 263
L50_1 = 264
L51_1 = 199
L52_1 = 200
L53_1 = 322
L36_1[1] = L37_1
L36_1[2] = L38_1
L36_1[3] = L39_1
L36_1[4] = L40_1
L36_1[5] = L41_1
L36_1[6] = L42_1
L36_1[7] = L43_1
L36_1[8] = L44_1
L36_1[9] = L45_1
L36_1[10] = L46_1
L36_1[11] = L47_1
L36_1[12] = L48_1
L36_1[13] = L49_1
L36_1[14] = L50_1
L36_1[15] = L51_1
L36_1[16] = L52_1
L36_1[17] = L53_1
L37_1 = {}
L38_1 = 1
L39_1 = 2
L40_1 = 3
L41_1 = 4
L42_1 = 5
L43_1 = 6
L44_1 = 220
L45_1 = 221
L37_1[1] = L38_1
L37_1[2] = L39_1
L37_1[3] = L40_1
L37_1[4] = L41_1
L37_1[5] = L42_1
L37_1[6] = L43_1
L37_1[7] = L44_1
L37_1[8] = L45_1
L38_1 = false
L39_1 = 0
L40_1 = {}
L41_1 = 30
L42_1 = 31
L43_1 = 32
L44_1 = 33
L45_1 = 34
L46_1 = 35
L47_1 = 21
L48_1 = 22
L40_1[1] = L41_1
L40_1[2] = L42_1
L40_1[3] = L43_1
L40_1[4] = L44_1
L40_1[5] = L45_1
L40_1[6] = L46_1
L40_1[7] = L47_1
L40_1[8] = L48_1
function L41_1()
  local L0_2, L1_2
  L0_2 = L38_1
  if L0_2 then
    L0_2 = GetGameTimer
    L0_2 = L0_2()
    L1_2 = L39_1
    L0_2 = L0_2 - L1_2
    L1_2 = 2000
    if L0_2 < L1_2 then
      return
    end
  end
  L0_2 = true
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L39_1 = L1_2
  L38_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = Config
    L0_3 = L0_3.CameraWalk
    L0_3 = false ~= L0_3
    L1_3 = 0
    while true do
      L2_3 = L0_1
      if not L2_3 then
        break
      end
      L2_3 = GetGameTimer
      L2_3 = L2_3()
      L39_1 = L2_3
      L2_3 = L19_1
      L2_3()
      L2_3 = 1
      L3_3 = L36_1
      L3_3 = #L3_3
      L4_3 = 1
      for L5_3 = L2_3, L3_3, L4_3 do
        L6_3 = DisableControlAction
        L7_3 = 0
        L8_3 = L36_1
        L8_3 = L8_3[L5_3]
        L9_3 = true
        L6_3(L7_3, L8_3, L9_3)
      end
      if L0_3 then
        L2_3 = 1
        L3_3 = L40_1
        L3_3 = #L3_3
        L4_3 = 1
        for L5_3 = L2_3, L3_3, L4_3 do
          L6_3 = EnableControlAction
          L7_3 = 0
          L8_3 = L40_1
          L8_3 = L8_3[L5_3]
          L9_3 = true
          L6_3(L7_3, L8_3, L9_3)
        end
        L2_3 = L39_1
        if L1_3 <= L2_3 then
          L2_3 = PhoneIsTyping
          if L2_3 then
            L2_3 = PhoneIsTyping
            L2_3 = L2_3()
          end
          if not L2_3 then
            L2_3 = L39_1
            L1_3 = L2_3 + 500
            L2_3 = SetNuiFocusKeepInput
            L3_3 = true
            L2_3(L3_3)
          end
        end
      else
        L2_3 = 1
        L3_3 = L40_1
        L3_3 = #L3_3
        L4_3 = 1
        for L5_3 = L2_3, L3_3, L4_3 do
          L6_3 = DisableControlAction
          L7_3 = 0
          L8_3 = L40_1
          L8_3 = L8_3[L5_3]
          L9_3 = true
          L6_3(L7_3, L8_3, L9_3)
        end
      end
      L2_3 = PhoneOpen
      if not L2_3 then
        L2_3 = false
        L3_3 = false
        L9_1 = L3_3
        L0_1 = L2_3
        break
      end
      L2_3 = PlayerPedId
      L2_3 = L2_3()
      L3_3 = DoesEntityExist
      L4_3 = L2_3
      L3_3 = L3_3(L4_3)
      if L3_3 then
        L3_3 = IsEntityDead
        L4_3 = L2_3
        L3_3 = L3_3(L4_3)
        if not L3_3 then
          goto lbl_96
        end
      end
      L3_3 = false
      L4_3 = false
      L9_1 = L4_3
      L0_1 = L3_3
      do break end
      ::lbl_96::
      L3_3 = L9_1
      if L3_3 then
        L3_3 = L28_1
        L3_3()
        L3_3 = IsControlPressed
        L4_3 = 0
        L5_3 = 24
        L3_3 = L3_3(L4_3, L5_3)
        if not L3_3 then
          L3_3 = IsDisabledControlPressed
          L4_3 = 0
          L5_3 = 24
          L3_3 = L3_3(L4_3, L5_3)
        end
        L4_3 = IsControlPressed
        L5_3 = 0
        L6_3 = 25
        L4_3 = L4_3(L5_3, L6_3)
        if not L4_3 then
          L4_3 = IsDisabledControlPressed
          L5_3 = 0
          L6_3 = 25
          L4_3 = L4_3(L5_3, L6_3)
        end
        L5_3 = IsControlJustPressed
        L6_3 = 1
        L7_3 = 176
        L5_3 = L5_3(L6_3, L7_3)
        if L5_3 and not L3_3 then
          L5_3 = Push
          L6_3 = "faceKey"
          L7_3 = {}
          L7_3.key = "accept"
          L5_3(L6_3, L7_3)
        else
          L5_3 = IsControlJustPressed
          L6_3 = 1
          L7_3 = 177
          L5_3 = L5_3(L6_3, L7_3)
          if L5_3 and not L4_3 then
            L5_3 = Push
            L6_3 = "faceKey"
            L7_3 = {}
            L7_3.key = "later"
            L5_3(L6_3, L7_3)
          end
        end
      else
        L3_3 = L4_1
        if not L3_3 then
          L3_3 = 1
          L4_3 = L37_1
          L4_3 = #L4_3
          L5_3 = 1
          for L6_3 = L3_3, L4_3, L5_3 do
            L7_3 = DisableControlAction
            L8_3 = 0
            L9_3 = L37_1
            L9_3 = L9_3[L6_3]
            L10_3 = true
            L7_3(L8_3, L9_3, L10_3)
          end
        end
        L3_3 = InvalidateIdleCam
        L3_3()
        L3_3 = InvalidateVehicleIdleCam
        L3_3()
      end
      do
        local ldx, ldy = PhoneLookDX or 0, PhoneLookDY or 0
        if ldx ~= 0 or ldy ~= 0 then
          PhoneLookDX, PhoneLookDY = 0, 0
          local sens = tonumber(Config.Camera and Config.Camera.LookSensitivity) or 1.0
          EnableControlAction(0, 1, true)    -- INPUT_LOOK_LR
          EnableControlAction(0, 2, true)    -- INPUT_LOOK_UD
          SetControlNormal(0, 1, math.max(-1.0, math.min(1.0, ldx * 0.02 * sens)))
          SetControlNormal(0, 2, math.max(-1.0, math.min(1.0, ldy * 0.02 * sens)))
        end
      end
      L3_3 = Wait
      L4_3 = 0
      L3_3(L4_3)
    end
    L2_3 = false
    L38_1 = L2_3
    L2_3 = L35_1
    L2_3()
    L2_3 = L20_1
    L2_3()
    L2_3 = L24_1
    L3_3 = false
    L2_3(L3_3)
    L2_3 = false
    L4_1 = L2_3
    L2_3 = SetPhoneFocus
    L3_3 = PhoneOpen
    L2_3(L3_3)
  end
  L0_2(L1_2)
end
L42_1 = RegisterNUICallback
L43_1 = "cameraMode"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L9_1
  if L2_2 then
    if A0_2 then
      L2_2 = A0_2.on
      if L2_2 then
        goto lbl_16
      end
    end
    L2_2 = A1_2
    L3_2 = {}
    L3_2.ok = true
    L3_2.ignored = true
    L2_2(L3_2)
    return
  end
  ::lbl_16::
  L2_2 = L0_1
  L3_2 = A0_2.on
  if L3_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_24
    end
  end
  L3_2 = false
  ::lbl_24::
  L0_1 = L3_2
  L3_2 = A0_2.front
  if L3_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_32
    end
  end
  L3_2 = false
  ::lbl_32::
  L1_1 = L3_2
  L3_2 = false
  L9_1 = L3_2
  L3_2 = tonumber
  L4_2 = A0_2.zoom
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 1.0
  end
  L2_1 = L3_2
  L3_2 = L2_1
  if L3_2 < 1.0 then
    L3_2 = 1.0
    L2_1 = L3_2
  else
    L3_2 = L2_1
    if L3_2 > 8.0 then
      L3_2 = 8.0
      L2_1 = L3_2
    end
  end
  L3_2 = L0_1
  if L3_2 then
    L3_2 = SetPhoneFocus
    L4_2 = PhoneOpen
    L5_2 = true
    L3_2(L4_2, L5_2)
    L3_2 = L34_1
    L3_2()
    L3_2 = L30_1
    L4_2 = L1_1
    L3_2(L4_2)
    if not L2_2 then
      L3_2 = L41_1
      L3_2()
    end
  else
    L3_2 = false
    L7_1 = L3_2
    L3_2 = false
    L4_1 = L3_2
    L3_2 = L35_1
    L3_2()
    L3_2 = SetPhoneFocus
    L4_2 = PhoneOpen
    L3_2(L4_2)
  end
  L3_2 = A1_2
  L4_2 = {}
  L4_2.ok = true
  L3_2(L4_2)
end
L42_1(L43_1, L44_1)
L42_1 = RegisterNUICallback
L43_1 = "cameraDrag"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = true
      if L2_2 then
        goto lbl_10
      end
    end
  end
  L2_2 = false
  ::lbl_10::
  L4_1 = false   -- Unique RP: look comes from cameraLook (mouse deltas from the UI), not from the game's own mouse look
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L42_1(L43_1, L44_1)
L42_1 = RegisterNUICallback
L43_1 = "cameraLook"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if L0_1 and A0_2 then
    PhoneLookDX = (PhoneLookDX or 0) + (tonumber(A0_2.dx) or 0)
    PhoneLookDY = (PhoneLookDY or 0) + (tonumber(A0_2.dy) or 0)
  end
  L2_2 = L0_1
  if L2_2 then
    L2_2 = L9_1
    if not L2_2 then
      L2_2 = L5_1
      L3_2 = tonumber
      L4_2 = A0_2.dx
      L3_2 = L3_2(L4_2)
      if not L3_2 then
        L3_2 = 0.0
      end
      L2_2 = L2_2 - L3_2
      L2_2 = L2_2 % 360.0
      L5_1 = L2_2
      L2_2 = L6_1
      L3_2 = tonumber
      L4_2 = A0_2.dy
      L3_2 = L3_2(L4_2)
      if not L3_2 then
        L3_2 = 0.0
      end
      L2_2 = L2_2 - L3_2
      L6_1 = L2_2
      L2_2 = L6_1
      if L2_2 > 80.0 then
        L2_2 = 80.0
        L6_1 = L2_2
      else
        L2_2 = L6_1
        if L2_2 < -80.0 then
          L2_2 = -80.0
          L6_1 = L2_2
        end
      end
      L2_2 = true
      L7_1 = L2_2
    end
  end
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L42_1(L43_1, L44_1)
L42_1 = RegisterNUICallback
L43_1 = "faceCam"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L2_2 = A0_2.on
    if L2_2 then
      L2_2 = L9_1
      if not L2_2 then
        L2_2 = L0_1
        L3_2 = true
        L4_2 = true
        L5_2 = true
        L1_1 = L5_2
        L9_1 = L4_2
        L0_1 = L3_2
        L3_2 = SetPhoneFocus
        L4_2 = PhoneOpen
        L5_2 = true
        L3_2(L4_2, L5_2)
        L3_2 = L35_1
        L3_2()
        L3_2 = L26_1
        L3_2()
        if not L2_2 then
          L3_2 = L41_1
          L3_2()
        end
      end
      L2_2 = A1_2
      L3_2 = {}
      L3_2.ok = true
      L4_2 = L8_1
      L3_2.ticks = L4_2
      L2_2(L3_2)
  end
  else
    L2_2 = false
    L3_2 = false
    L4_2 = false
    L7_1 = L4_2
    L9_1 = L3_2
    L0_1 = L2_2
    L2_2 = SetPhoneFocus
    L3_2 = PhoneOpen
    L2_2(L3_2)
    L2_2 = A1_2
    L3_2 = {}
    L3_2.ok = true
    L2_2(L3_2)
  end
end
L42_1(L43_1, L44_1)
L42_1 = RegisterNUICallback
L43_1 = "shotBegin"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = PhoneOpen
  if L2_2 then
    L2_2 = SetPhoneFocus
    L3_2 = true
    L4_2 = L0_1
    if not L4_2 then
      L4_2 = nil
    end
    L5_2 = false
    L2_2(L3_2, L4_2, L5_2)
  end
  L2_2 = Wait
  L3_2 = 90
  L2_2(L3_2)
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L42_1(L43_1, L44_1)
L42_1 = RegisterNUICallback
L43_1 = "shotEnd"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = PhoneOpen
  if L2_2 then
    L2_2 = SetPhoneFocus
    L3_2 = true
    L4_2 = L0_1
    if not L4_2 then
      L4_2 = nil
    end
    L2_2(L3_2, L4_2)
  end
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L42_1(L43_1, L44_1)
function L42_1()
  local L0_2, L1_2
  L0_2 = L0_1
  return L0_2
end
CameraActive = L42_1
L42_1 = RegisterNUICallback
L43_1 = "faceReset"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L9_1
  if L2_2 then
    L2_2 = L26_1
    L2_2()
  end
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L42_1(L43_1, L44_1)
L42_1 = RegisterCommand
L43_1 = "camtest"
function L44_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = print
  L1_2 = "^5[unique_phone]^7 "
  L2_2 = TrF
  L3_2 = "modo c\195\162mara: %s \194\183 Face Key: %s \194\183 telem\195\179vel aberto: %s"
  L4_2 = tostring
  L5_2 = L0_1
  L4_2 = L4_2(L5_2)
  L5_2 = tostring
  L6_2 = L9_1
  L5_2 = L5_2(L6_2)
  L6_2 = tostring
  L7_2 = PhoneOpen
  L6_2, L7_2 = L6_2(L7_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L1_2 = L1_2 .. L2_2
  L0_2(L1_2)
  L0_2 = PhoneOpen
  if not L0_2 then
    L0_2 = print
    L1_2 = "^3[unique_phone]^0 "
    L2_2 = TrF
    L3_2 = "abre o telem\195\179vel (%s) e volta a escrever /camtest."
    L4_2 = tostring
    L5_2 = Config
    L5_2 = L5_2.OpenKey
    if not L5_2 then
      L5_2 = "F1"
    end
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
    L1_2 = L1_2 .. L2_2
    L0_2(L1_2)
    return
  end
  L0_2 = Push
  L1_2 = "camtest"
  L2_2 = {}
  L0_2(L1_2, L2_2)
  L0_2 = FW
  L0_2 = L0_2.Notify
  L1_2 = "A testar o visor\226\128\166"
  L2_2 = "primary"
  L0_2(L1_2, L2_2)
end
L45_1 = false
L42_1(L43_1, L44_1, L45_1)
L42_1 = RegisterCommand
L43_1 = "camfix"
function L44_1()
  local L0_2, L1_2, L2_2
  L0_2 = FW
  L0_2 = L0_2.Notify
  L1_2 = "A reiniciar o screenshot-basic\226\128\166"
  L2_2 = "primary"
  L0_2(L1_2, L2_2)
  L0_2 = TriggerServerEvent
  L1_2 = "apex_phone:server:camfix"
  L0_2(L1_2)
end
L45_1 = false
L42_1(L43_1, L44_1, L45_1)
L42_1 = RegisterNetEvent
L43_1 = "apex_phone:client:camfixed"
function L44_1(A0_2)
  local L1_2, L2_2, L3_2
  if A0_2 then
    L1_2 = FW
    L1_2 = L1_2.Notify
    L2_2 = "screenshot-basic reiniciado."
    L3_2 = "success"
    L1_2(L2_2, L3_2)
  else
    L1_2 = FW
    L1_2 = L1_2.Notify
    L2_2 = "Sem permiss\195\163o de admin para reiniciar o screenshot-basic."
    L3_2 = "error"
    L1_2(L2_2, L3_2)
  end
end
L42_1(L43_1, L44_1)
L42_1 = RegisterNUICallback
L43_1 = "camtestResult"
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = A0_2.available
  if L2_2 then
    L2_2 = print
    L3_2 = "^2[unique_phone]^0 "
    L4_2 = TrF
    L5_2 = "visor OK: WebGL dispon\195\173vel, %sx%s, %s"
    L6_2 = tostring
    L7_2 = A0_2.w
    if not L7_2 then
      L7_2 = "?"
    end
    L6_2 = L6_2(L7_2)
    L7_2 = tostring
    L8_2 = A0_2.h
    if not L8_2 then
      L8_2 = "?"
    end
    L7_2 = L7_2(L8_2)
    L8_2 = A0_2.black
    if L8_2 then
      L8_2 = "^3"
      L9_2 = Tr
      L10_2 = "imagem PRETA"
      L9_2 = L9_2(L10_2)
      L10_2 = "^0"
      L8_2 = L8_2 .. L9_2 .. L10_2
      if L8_2 then
        goto lbl_39
      end
    end
    L8_2 = Tr
    L9_2 = "imagem com conte\195\186do"
    L8_2 = L8_2(L9_2)
    ::lbl_39::
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
    L3_2 = L3_2 .. L4_2
    L2_2(L3_2)
    L2_2 = FW
    L2_2 = L2_2.Notify
    L3_2 = A0_2.black
    if L3_2 then
      L3_2 = "Visor a preto: abre a C\195\162mara e espera um instante"
      if L3_2 then
        goto lbl_51
      end
    end
    L3_2 = "Visor OK"
    ::lbl_51::
    L4_2 = A0_2.black
    if L4_2 then
      L4_2 = "error"
      if L4_2 then
        goto lbl_58
      end
    end
    L4_2 = "success"
    ::lbl_58::
    L2_2(L3_2, L4_2)
  else
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 "
    L4_2 = Tr
    L5_2 = "o visor N\195\131O arrancou: o WebGL n\195\163o est\195\161 dispon\195\173vel nesta NUI."
    L4_2 = L4_2(L5_2)
    L3_2 = L3_2 .. L4_2
    L2_2(L3_2)
    L2_2 = print
    L3_2 = "^3[unique_phone]^0 "
    L4_2 = Tr
    L5_2 = "confirma que html/js/gamerender.js existe e que o index.html o carrega antes do js/apps/photos.js."
    L4_2 = L4_2(L5_2)
    L3_2 = L3_2 .. L4_2
    L2_2(L3_2)
    L2_2 = FW
    L2_2 = L2_2.Notify
    L3_2 = "O visor n\195\163o arrancou (WebGL)"
    L4_2 = "error"
    L2_2(L3_2, L4_2)
  end
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L42_1(L43_1, L44_1)
function L42_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L0_1
  if not L0_2 then
    L0_2 = L9_1
  end
  L1_2 = false
  L2_2 = false
  L3_2 = false
  L4_2 = false
  L7_1 = L4_2
  L4_1 = L3_2
  L9_1 = L2_2
  L0_1 = L1_2
  L1_2 = L35_1
  L1_2()
  L1_2 = L20_1
  L1_2()
  L1_2 = L24_1
  L2_2 = false
  L1_2(L2_2)
  return L0_2
end
CameraReset = L42_1
L42_1 = AddEventHandler
L43_1 = "onResourceStop"
function L44_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = CameraReset
  L1_2()
  L1_2 = SetPhoneFocus
  L2_2 = false
  L1_2(L2_2)
end
L42_1(L43_1, L44_1)
