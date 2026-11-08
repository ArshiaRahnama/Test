local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1
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
L3_1 = 0
L4_1 = RegisterNUICallback
L5_1 = "worldSound"
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
  L2_2 = L1_1
  L2_2 = L2_2()
  if L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      goto lbl_14
    end
  end
  do return end
  ::lbl_14::
  L2_2 = A0_2.kind
  if "ring" == L2_2 then
    L2_2 = "ring"
    if L2_2 then
      goto lbl_21
    end
  end
  L2_2 = "notify"
  ::lbl_21::
  if "ring" == L2_2 then
    L3_2 = L0_1
    L3_2 = L3_2()
    L3_2 = L3_2.ring
    if false == L3_2 then
      return
    end
  end
  if "notify" == L2_2 then
    L3_2 = L0_1
    L3_2 = L3_2()
    L3_2 = L3_2.notify
    if false == L3_2 then
      return
    end
  end
  L3_2 = A0_2.on
  L3_2 = false ~= L3_2
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  if "notify" == L2_2 then
    L5_2 = L3_1
    L5_2 = L4_2 - L5_2
    L6_2 = 250
    if L5_2 < L6_2 then
      return
    end
    L3_1 = L4_2
  end
  L5_2 = tonumber
  L6_2 = A0_2.gain
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 1.0
  end
  if L5_2 < 0 then
    L5_2 = 0.0
  elseif L5_2 > 1 then
    L5_2 = 1.0
  end
  L6_2 = TriggerServerEvent
  L7_2 = "apex_phone:server:worldSound"
  L8_2 = L2_2
  L9_2 = tostring
  L10_2 = A0_2.name
  if not L10_2 then
    L10_2 = ""
  end
  L9_2 = L9_2(L10_2)
  L10_2 = L9_2
  L9_2 = L9_2.sub
  L11_2 = 1
  L12_2 = 32
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L10_2 = L3_2
  L11_2 = L5_2 + 0.0
  L12_2 = tostring
  L13_2 = A0_2.os
  if not L13_2 then
    L13_2 = "ios"
  end
  L12_2 = L12_2(L13_2)
  L13_2 = L12_2
  L12_2 = L12_2.sub
  L14_2 = 1
  L15_2 = 8
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
end
L4_1(L5_1, L6_1)
L4_1 = {}
L5_1 = false
function L6_1()
  local L0_2, L1_2
  L0_2 = GetEntityCoords
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  return L0_2(L1_2)
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = GetPlayerFromServerId
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 and -1 ~= L2_2 then
    L3_2 = GetPlayerPed
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 and 0 ~= L3_2 then
      L4_2 = DoesEntityExist
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      if true ~= L4_2 then
        L4_2 = DoesEntityExist
        L5_2 = L3_2
        L4_2 = L4_2(L5_2)
        if 1 ~= L4_2 then
          goto lbl_29
        end
      end
      L4_2 = GetEntityCoords
      L5_2 = L3_2
      return L4_2(L5_2)
    end
  end
  ::lbl_29::
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = tonumber
    L4_2 = A1_2.x
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = vector3
      L4_2 = A1_2.x
      L4_2 = L4_2 + 0.0
      L5_2 = A1_2.y
      L5_2 = L5_2 + 0.0
      L6_2 = A1_2.z
      L6_2 = L6_2 + 0.0
      return L3_2(L4_2, L5_2, L6_2)
    end
  end
  L3_2 = nil
  return L3_2
end
function L8_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L7_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = 0.0
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = L0_1
  L5_2 = L5_2()
  L5_2 = L5_2.range
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 12.0
  end
  if L4_2 <= 0 then
    L5_2 = 0.0
    return L5_2
  end
  L5_2 = L6_1
  L5_2 = L5_2()
  L5_2 = L3_2 - L5_2
  L5_2 = #L5_2
  if L4_2 <= L5_2 then
    L6_2 = 0.0
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = L0_1
  L7_2 = L7_2()
  L7_2 = L7_2.volume
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0.7
  end
  L7_2 = L5_2 / L4_2
  L8_2 = 1.0
  L7_2 = L8_2 - L7_2
  L8_2 = L6_2 * L7_2
  L8_2 = L8_2 * L7_2
  L9_2 = tonumber
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = 1.0
  end
  L8_2 = L8_2 * L9_2
  return L8_2
end
function L9_1()
  local L0_2, L1_2
  L0_2 = L5_1
  if L0_2 then
    return
  end
  L0_2 = true
  L5_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    while true do
      L0_3 = next
      L1_3 = L4_1
      L0_3 = L0_3(L1_3)
      if nil == L0_3 then
        break
      end
      L0_3 = Wait
      L1_3 = 500
      L0_3(L1_3)
      L0_3 = GetGameTimer
      L0_3 = L0_3()
      L1_3 = pairs
      L2_3 = L4_1
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
      for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
        L7_3 = L6_3.expires
        if L0_3 > L7_3 then
          L7_3 = L4_1
          L7_3[L5_3] = nil
          L7_3 = Push
          L8_3 = "remoteSound"
          L9_3 = {}
          L9_3.id = L5_3
          L9_3.kind = "ring"
          L9_3.on = false
          L7_3(L8_3, L9_3)
        else
          L7_3 = L8_1
          L8_3 = L5_3
          L9_3 = L6_3.coords
          L10_3 = L6_3.gain
          L7_3 = L7_3(L8_3, L9_3, L10_3)
          L8_3 = math
          L8_3 = L8_3.abs
          L9_3 = L6_3.last
          if not L9_3 then
            L9_3 = -1
          end
          L9_3 = L7_3 - L9_3
          L8_3 = L8_3(L9_3)
          L9_3 = 0.02
          if L8_3 > L9_3 then
            L6_3.last = L7_3
            L8_3 = Push
            L9_3 = "remoteSoundGain"
            L10_3 = {}
            L10_3.id = L5_3
            L10_3.gain = L7_3
            L8_3(L9_3, L10_3)
          end
        end
      end
    end
    L0_3 = false
    L5_1 = L0_3
  end
  L0_2(L1_2)
end
L10_1 = RegisterNetEvent
L11_1 = "apex_phone:client:worldSound"
function L12_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L7_2 = L1_1
  L7_2 = L7_2()
  if not L7_2 then
    return
  end
  L7_2 = tonumber
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  A0_2 = L7_2
  if A0_2 then
    L7_2 = GetPlayerServerId
    L8_2 = PlayerId
    L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2()
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
    if A0_2 ~= L7_2 then
      goto lbl_19
    end
  end
  do return end
  ::lbl_19::
  L7_2 = tonumber
  L8_2 = A4_2
  L7_2 = L7_2(L8_2)
  A4_2 = L7_2 or A4_2
  if not L7_2 then
    A4_2 = 1.0
  end
  L7_2 = type
  L8_2 = A2_2
  L7_2 = L7_2(L8_2)
  if "string" ~= L7_2 or not A2_2 then
    A2_2 = ""
  end
  if "ring" == A1_2 then
    if false == A3_2 then
      L7_2 = L4_1
      L7_2 = L7_2[A0_2]
      if L7_2 then
        L7_2 = L4_1
        L7_2[A0_2] = nil
      end
      L7_2 = Push
      L8_2 = "remoteSound"
      L9_2 = {}
      L9_2.id = A0_2
      L9_2.kind = "ring"
      L9_2.on = false
      L7_2(L8_2, L9_2)
      return
    end
    L7_2 = L8_1
    L8_2 = A0_2
    L9_2 = A5_2
    L10_2 = A4_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = L4_1
    L9_2 = {}
    L9_2.coords = A5_2
    L10_2 = GetGameTimer
    L10_2 = L10_2()
    L10_2 = L10_2 + 45000
    L9_2.expires = L10_2
    L9_2.gain = A4_2
    L9_2.last = L7_2
    L8_2[A0_2] = L9_2
    L8_2 = Push
    L9_2 = "remoteSound"
    L10_2 = {}
    L10_2.id = A0_2
    L10_2.kind = "ring"
    L10_2.name = A2_2
    L10_2.on = true
    L10_2.gain = L7_2
    L10_2.os = A6_2
    L8_2(L9_2, L10_2)
    L8_2 = L2_1
    L9_2 = "ring from %s (%s) gain %.2f"
    L10_2 = A0_2
    L11_2 = A2_2
    L12_2 = L7_2
    L8_2(L9_2, L10_2, L11_2, L12_2)
    L8_2 = L9_1
    L8_2()
  else
    L7_2 = L8_1
    L8_2 = A0_2
    L9_2 = A5_2
    L10_2 = A4_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = 0.01
    if L7_2 <= L8_2 then
      return
    end
    L8_2 = Push
    L9_2 = "remoteSound"
    L10_2 = {}
    L10_2.id = A0_2
    L10_2.kind = "notify"
    L10_2.name = A2_2
    L10_2.on = true
    L10_2.gain = L7_2
    L10_2.os = A6_2
    L8_2(L9_2, L10_2)
  end
end
L10_1(L11_1, L12_1)
L10_1 = RegisterNetEvent
L11_1 = "apex_phone:client:worldSoundStop"
function L12_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if A0_2 then
    L1_2 = L4_1
    L1_2 = L1_2[A0_2]
    if L1_2 then
      L1_2 = L4_1
      L1_2[A0_2] = nil
    end
  end
  if A0_2 then
    L1_2 = Push
    L2_2 = "remoteSound"
    L3_2 = {}
    L3_2.id = A0_2
    L3_2.kind = "ring"
    L3_2.on = false
    L1_2(L2_2, L3_2)
  end
end
L10_1(L11_1, L12_1)
L10_1 = AddEventHandler
L11_1 = "onResourceStop"
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L4_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = Push
    L7_2 = "remoteSound"
    L8_2 = {}
    L8_2.id = L5_2
    L8_2.kind = "ring"
    L8_2.on = false
    L6_2(L7_2, L8_2)
  end
  L1_2 = {}
  L4_1 = L1_2
end
L10_1(L11_1, L12_1)
