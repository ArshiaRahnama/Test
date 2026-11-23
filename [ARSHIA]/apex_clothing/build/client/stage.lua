local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1
L0_1 = Stage
if not L0_1 then
  L0_1 = {}
end
Stage = L0_1
L0_1 = {}
L1_1 = {}
L1_1.z = 0.0
L1_1.r = 2.6
L0_1.full = L1_1
L1_1 = {}
L1_1.z = 0.65
L1_1.r = 0.8
L0_1.head = L1_1
L1_1 = {}
L1_1.z = 0.25
L1_1.r = 1.4
L0_1.torso = L1_1
L1_1 = {}
L1_1.z = -0.35
L1_1.r = 1.6
L0_1.legs = L1_1
L1_1 = {}
L1_1.z = -0.8
L1_1.r = 1.2
L0_1.feet = L1_1
L1_1 = -1.2
L2_1 = 1.2
L3_1 = 0.6
L4_1 = 4.5
L5_1 = nil
L6_1 = false
L7_1 = 0.0
L8_1 = 0.15
L9_1 = L0_1.full
L9_1 = L9_1.r
L10_1 = "full"
L11_1 = nil
L12_1 = 0.0
L13_1 = false
function L14_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L0_2 = L5_1
  if not L0_2 then
    return
  end
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L3_2 = L10_1
  L2_2 = L0_1
  L2_2 = L2_2[L3_2]
  if not L2_2 then
    L2_2 = L0_1.full
  end
  L2_2 = L2_2.z
  L3_2 = math
  L3_2 = L3_2.cos
  L4_2 = L8_1
  L3_2 = L3_2(L4_2)
  L4_2 = L1_2.x
  L5_2 = L9_1
  L5_2 = L5_2 * L3_2
  L6_2 = math
  L6_2 = L6_2.cos
  L7_2 = L7_1
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 * L6_2
  L4_2 = L4_2 + L5_2
  L5_2 = L1_2.y
  L6_2 = L9_1
  L6_2 = L6_2 * L3_2
  L7_2 = math
  L7_2 = L7_2.sin
  L8_2 = L7_1
  L7_2 = L7_2(L8_2)
  L6_2 = L6_2 * L7_2
  L5_2 = L5_2 + L6_2
  L6_2 = L1_2.z
  L6_2 = L6_2 + L2_2
  L7_2 = L9_1
  L8_2 = math
  L8_2 = L8_2.sin
  L9_2 = L8_1
  L8_2 = L8_2(L9_2)
  L7_2 = L7_2 * L8_2
  L6_2 = L6_2 + L7_2
  L7_2 = SetCamCoord
  L8_2 = L5_1
  L9_2 = L4_2
  L10_2 = L5_2
  L11_2 = L6_2
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = L1_2.x
  L8_2 = L1_2.y
  L9_2 = L1_2.z
  L10_2 = L2_2 * 0.8
  L9_2 = L9_2 + L10_2
  L10_2 = Config
  L10_2 = L10_2.stage
  if L10_2 then
    L10_2 = Config
    L10_2 = L10_2.stage
    L10_2 = L10_2.previewScreenX
    if L10_2 then
      goto lbl_80
    end
  end
  L10_2 = 0.27
  ::lbl_80::
  L11_2 = 0.5
  if L10_2 < L11_2 then
    L11_2 = L7_2 - L4_2
    L12_2 = L8_2 - L5_2
    L13_2 = L9_2 - L6_2
    L14_2 = math
    L14_2 = L14_2.sqrt
    L15_2 = L11_2 * L11_2
    L16_2 = L12_2 * L12_2
    L15_2 = L15_2 + L16_2
    L16_2 = L13_2 * L13_2
    L15_2 = L15_2 + L16_2
    L14_2 = L14_2(L15_2)
    L15_2 = L12_2
    L16_2 = -L11_2
    L17_2 = math
    L17_2 = L17_2.sqrt
    L18_2 = L15_2 * L15_2
    L19_2 = L16_2 * L16_2
    L18_2 = L18_2 + L19_2
    L17_2 = L17_2(L18_2)
    L18_2 = 0.001
    if L14_2 > L18_2 then
      L18_2 = 0.001
      if L17_2 > L18_2 then
        L18_2 = GetCamFov
        L19_2 = L5_1
        L18_2 = L18_2(L19_2)
        if not L18_2 or L18_2 <= 0 then
          L18_2 = 50.0
        end
        L19_2 = 1.7777777777777777
        L20_2 = math
        L20_2 = L20_2.tan
        L21_2 = math
        L21_2 = L21_2.rad
        L22_2 = L18_2
        L21_2 = L21_2(L22_2)
        L21_2 = L21_2 * 0.5
        L20_2 = L20_2(L21_2)
        L20_2 = L20_2 * L19_2
        L21_2 = L9_1
        L20_2 = L20_2 * L21_2
        L21_2 = 0.5
        L21_2 = L21_2 - L10_2
        L21_2 = L20_2 * L21_2
        L21_2 = L21_2 * 2.0
        L22_2 = L15_2 / L17_2
        L22_2 = L22_2 * L21_2
        L7_2 = L7_2 + L22_2
        L22_2 = L16_2 / L17_2
        L22_2 = L22_2 * L21_2
        L8_2 = L8_2 + L22_2
      end
    end
  end
  L11_2 = PointCamAtCoord
  L12_2 = L5_1
  L13_2 = L7_2
  L14_2 = L8_2
  L15_2 = L9_2
  L11_2(L12_2, L13_2, L14_2, L15_2)
end
L15_1 = Stage
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = L6_1
  if L0_2 then
    return
  end
  L0_2 = true
  L6_1 = L0_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L11_1 = L1_2
  L1_2 = GetEntityHeading
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L12_1 = L1_2
  L1_2 = false
  L13_1 = L1_2
  L1_2 = Config
  L1_2 = L1_2.stage
  if L1_2 then
    L1_2 = Config
    L1_2 = L1_2.stage
    L1_2 = L1_2.teleport
    if L1_2 then
      L1_2 = Config
      L1_2 = L1_2.stage
      L1_2 = L1_2.coords
      if L1_2 then
        L1_2 = Config
        L1_2 = L1_2.stage
        L1_2 = L1_2.coords
        L2_2 = SetEntityCoords
        L3_2 = L0_2
        L4_2 = L1_2.x
        L5_2 = L1_2.y
        L6_2 = L1_2.z
        L7_2 = false
        L8_2 = false
        L9_2 = false
        L10_2 = false
        L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
        L2_2 = SetEntityHeading
        L3_2 = L0_2
        L4_2 = L1_2.w
        if not L4_2 then
          L4_2 = 0.0
        end
        L2_2(L3_2, L4_2)
        L2_2 = true
        L13_1 = L2_2
      end
    end
  end
  L1_2 = FreezeEntityPosition
  L2_2 = L0_2
  L3_2 = true
  L1_2(L2_2, L3_2)
  L1_2 = SetEntityInvincible
  L2_2 = L0_2
  L3_2 = true
  L1_2(L2_2, L3_2)
  L1_2 = ClearPedTasksImmediately
  L2_2 = L0_2
  L1_2(L2_2)
  L1_2 = DisplayRadar
  L2_2 = false
  L1_2(L2_2)
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = PlayerId
    L0_3 = L0_3()
    while true do
      L1_3 = L6_1
      if not L1_3 then
        break
      end
      L1_3 = HideHudAndRadarThisFrame
      L1_3()
      L1_3 = DisablePlayerFiring
      L2_3 = L0_3
      L3_3 = true
      L1_3(L2_3, L3_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 1
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 2
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 24
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 25
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 37
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 44
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 140
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 141
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 142
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 257
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 263
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 264
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
  end
  L1_2(L2_2)
end
L15_1.Enter = L16_1
L15_1 = Stage
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = L6_1
  if not L0_2 then
    L0_2 = L5_1
    if not L0_2 then
      return
    end
  end
  L0_2 = false
  L6_1 = L0_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = RenderScriptCams
  L2_2 = false
  L3_2 = true
  L4_2 = 400
  L5_2 = true
  L6_2 = true
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  L1_2 = L5_1
  if L1_2 then
    L1_2 = SetCamActive
    L2_2 = L5_1
    L3_2 = false
    L1_2(L2_2, L3_2)
    L1_2 = DestroyCam
    L2_2 = L5_1
    L3_2 = false
    L1_2(L2_2, L3_2)
    L1_2 = nil
    L5_1 = L1_2
  end
  L1_2 = FreezeEntityPosition
  L2_2 = L0_2
  L3_2 = false
  L1_2(L2_2, L3_2)
  L1_2 = SetEntityInvincible
  L2_2 = L0_2
  L3_2 = false
  L1_2(L2_2, L3_2)
  L1_2 = SetEntityVisible
  L2_2 = L0_2
  L3_2 = true
  L4_2 = false
  L1_2(L2_2, L3_2, L4_2)
  L1_2 = L13_1
  if L1_2 then
    L1_2 = L11_1
    if L1_2 then
      L1_2 = SetEntityCoords
      L2_2 = L0_2
      L3_2 = L11_1.x
      L4_2 = L11_1.y
      L5_2 = L11_1.z
      L6_2 = false
      L7_2 = false
      L8_2 = false
      L9_2 = false
      L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
      L1_2 = SetEntityHeading
      L2_2 = L0_2
      L3_2 = L12_1
      if not L3_2 then
        L3_2 = 0.0
      end
      L1_2(L2_2, L3_2)
    end
  end
  L1_2 = false
  L13_1 = L1_2
  L1_2 = nil
  L11_1 = L1_2
  L1_2 = DisplayRadar
  L2_2 = true
  L1_2(L2_2)
end
L15_1.Exit = L16_1
L15_1 = RegisterNUICallback
L16_1 = "stageOrbit"
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = L5_1
  if L2_2 then
    L2_2 = tonumber
    L3_2 = A0_2.dx
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0.0
    end
    L3_2 = tonumber
    L4_2 = A0_2.dy
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = 0.0
    end
    L4_2 = L7_1
    L5_2 = L2_2 * 0.008
    L4_2 = L4_2 - L5_2
    L7_1 = L4_2
    L4_2 = Utils
    L4_2 = L4_2.Clamp
    L5_2 = L8_1
    L6_2 = L3_2 * 0.006
    L5_2 = L5_2 + L6_2
    L6_2 = L1_1
    L7_2 = L2_1
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L8_1 = L4_2
    L4_2 = L14_1
    L4_2()
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L15_1(L16_1, L17_1)
L15_1 = RegisterNUICallback
L16_1 = "stageZoom"
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = L5_1
  if L2_2 then
    L2_2 = tonumber
    L3_2 = A0_2.delta
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0.0
    end
    L3_2 = Utils
    L3_2 = L3_2.Clamp
    L4_2 = L9_1
    L5_2 = L2_2 * 0.15
    L4_2 = L4_2 + L5_2
    L5_2 = L3_1
    L6_2 = L4_1
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L9_1 = L3_2
    L3_2 = L14_1
    L3_2()
  end
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L15_1(L16_1, L17_1)
L15_1 = RegisterNUICallback
L16_1 = "stageFocus"
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = A0_2.zone
  L3_2 = L5_1
  if L3_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L3_2 = L0_1
      L3_2 = L3_2[L2_2]
      if L3_2 then
        L10_1 = L2_2
        L3_2 = Utils
        L3_2 = L3_2.Clamp
        L4_2 = L0_1
        L4_2 = L4_2[L2_2]
        L4_2 = L4_2.r
        L5_2 = L3_1
        L6_2 = L4_1
        L3_2 = L3_2(L4_2, L5_2, L6_2)
        L9_1 = L3_2
        L3_2 = L14_1
        L3_2()
      end
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L3_2(L4_2)
end
L15_1(L16_1, L17_1)
