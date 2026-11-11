local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1
L0_1 = "apex_phone:airpods:"
L1_1 = GetCurrentResourceName
L1_1 = L1_1()
L2_1 = {}
L3_1 = {}
L4_1 = {}
L5_1 = false
L6_1 = {}
L7_1 = "left"
L8_1 = "right"
L6_1[1] = L7_1
L6_1[2] = L8_1
function L7_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
L8_1 = DoesEntityExist
L9_1 = IsEntityDead
L10_1 = IsModelInCdimage
L11_1 = IsModelValid
L12_1 = HasModelLoaded
L13_1 = IsEntityAttachedToEntity
L14_1 = NetworkIsPlayerActive
function L15_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L7_1
  L2_2 = L8_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L7_1
  L2_2 = L9_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L7_1
  L2_2 = L10_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
function L18_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L7_1
  L2_2 = L11_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L7_1
  L2_2 = L12_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L7_1
  L3_2 = L13_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  return L2_2(L3_2, L4_2, L5_2)
end
function L21_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L7_1
  L2_2 = L14_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
function L22_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.AirPods
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.AirPods
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L23_1(A0_2)
  local L1_2, L2_2
  if "slate" == A0_2 then
    L1_2 = type
    L2_2 = Config
    L2_2 = L2_2.SlateBuds
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = Config
      L1_2 = L1_2.SlateBuds
      if L1_2 then
        goto lbl_15
      end
    end
    L1_2 = {}
    ::lbl_15::
    return L1_2
  end
  L1_2 = L22_1
  return L1_2()
end
function L24_1(A0_2)
  local L1_2
  if true == A0_2 then
    L1_2 = "airbuds"
    return L1_2
  end
  if "slate" == A0_2 then
    L1_2 = "slate"
    return L1_2
  end
  L1_2 = nil
  return L1_2
end
L25_1 = {}
L26_1 = {}
L26_1.left = "apex_airpod_l_v3"
L26_1.right = "apex_airpod_r_v3"
L25_1.airbuds = L26_1
L26_1 = {}
L26_1.left = "apex_slate_bud_l"
L26_1.right = "apex_slate_bud_r"
L25_1.slate = L26_1
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2.models
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = L25_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = L25_1.airbuds
  end
  L3_2 = {}
  L4_2 = L1_2.left
  if not L4_2 then
    L4_2 = L2_2.left
  end
  L3_2.left = L4_2
  L4_2 = L1_2.right
  if not L4_2 then
    L4_2 = L2_2.right
  end
  L3_2.right = L4_2
  return L3_2
end
L27_1 = {}
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L27_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = L26_1
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    L2_2 = L27_1
    L3_2 = {}
    L4_2 = joaat
    L5_2 = L1_2.left
    L4_2 = L4_2(L5_2)
    L3_2.left = L4_2
    L4_2 = joaat
    L5_2 = L1_2.right
    L4_2 = L4_2(L5_2)
    L3_2.right = L4_2
    L2_2[A0_2] = L3_2
  end
  L1_2 = L27_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
L29_1 = {}
function L30_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L29_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = {}
    L2_2 = pairs
    L3_2 = L23_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    L3_2 = L3_2.modelFits
    if not L3_2 then
      L3_2 = {}
    end
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = joaat
      L9_2 = L6_2
      L8_2 = L8_2(L9_2)
      L1_2[L8_2] = L7_2
    end
    L2_2 = L29_1
    L2_2[A0_2] = L1_2
  end
  L1_2 = L29_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
function L31_1(A0_2, A1_2)
  local L2_2
  L2_2 = A0_2 - A1_2
  L2_2 = L2_2 % 4294967296
  return L2_2
end
function L32_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = L22_1
  L1_2 = L1_2()
  L1_2 = L1_2.maxDistance
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 45.0
  end
  L1_2 = L0_2 * L0_2
  return L1_2
end
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L2_2 = L2_1
  L2_2[A0_2] = nil
  L2_2 = ipairs
  L3_2 = L1_2.objects
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L15_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L8_2 = SetEntityAsMissionEntity
      L9_2 = L7_2
      L10_2 = true
      L11_2 = true
      L8_2(L9_2, L10_2, L11_2)
      L8_2 = DeleteEntity
      L9_2 = L7_2
      L8_2(L9_2)
    end
  end
end
function L34_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = PlayerPedId
  L1_2 = L1_2()
  if 0 ~= L1_2 then
    L2_2 = L15_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_12::
  L2_2 = GetEntityCoords
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L3_2 = GetEntityCoords
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L2_2.x
  L5_2 = L3_2.x
  L4_2 = L4_2 - L5_2
  L5_2 = L2_2.y
  L6_2 = L3_2.y
  L5_2 = L5_2 - L6_2
  L6_2 = L2_2.z
  L7_2 = L3_2.z
  L6_2 = L6_2 - L7_2
  L7_2 = L4_2 * L4_2
  L8_2 = L5_2 * L5_2
  L7_2 = L7_2 + L8_2
  L8_2 = L6_2 * L6_2
  L7_2 = L7_2 + L8_2
  L8_2 = L32_1
  L8_2 = L8_2()
  L7_2 = L7_2 <= L8_2
  return L7_2
end
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L5_1
  L2_2 = A0_2.id
  L1_2 = L2_1
  L1_2 = L1_2[L2_2]
  L1_2 = L24_1
  L2_2 = GlobalState
  L3_2 = L0_1
  L4_2 = A0_2.id
  L3_2 = L3_2 .. L4_2
  L2_2 = L2_2[L3_2]
  L1_2 = L1_2(L2_2)
  L2_2 = A0_2.kind
  L1_2 = L21_1
  L2_2 = A0_2.player
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = GetPlayerServerId
    L2_2 = A0_2.player
    L1_2 = L1_2(L2_2)
    L2_2 = A0_2.id
    L1_2 = GetPlayerPed
    L2_2 = A0_2.player
    L1_2 = L1_2(L2_2)
    L2_2 = A0_2.ped
    L1_2 = L15_1
    L2_2 = A0_2.ped
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = L16_1
      L2_2 = A0_2.ped
      L1_2 = L1_2(L2_2)
      L1_2 = GetEntityModel
      L2_2 = A0_2.ped
      L1_2 = L1_2(L2_2)
      L2_2 = A0_2.pedModel
      L1_2 = L34_1
      L2_2 = A0_2.ped
      L1_2 = not L1_2 and L1_2
    end
  end
  return L1_2
end
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = ipairs
  L2_2 = A0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L4_1
    L7_2 = L7_2[L6_2]
    if L7_2 then
      if L7_2 <= 1 then
        L8_2 = L4_1
        L8_2[L6_2] = nil
        L8_2 = SetModelAsNoLongerNeeded
        L9_2 = L6_2
        L8_2(L9_2)
      else
        L8_2 = L4_1
        L9_2 = L7_2 - 1
        L8_2[L6_2] = L9_2
      end
    end
  end
end
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = A0_2.id
  L2_2 = L2_1
  L2_2 = L2_2[L3_2]
  if L2_2 ~= A0_2 then
    return
  end
  L3_2 = A0_2.id
  L2_2 = L3_1
  L4_2 = {}
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L4_2.at = L5_2
  L5_2 = A0_2.ped
  L4_2.ped = L5_2
  L5_2 = A0_2.pedModel
  L4_2.model = L5_2
  L5_2 = A0_2.kind
  L4_2.kind = L5_2
  L2_2[L3_2] = L4_2
  L2_2 = L33_1
  L3_2 = A0_2.id
  L2_2(L3_2)
  L2_2 = A0_2.player
  L3_2 = PlayerId
  L3_2 = L3_2()
  if L2_2 == L3_2 then
    L2_2 = print
    L3_2 = "^3[unique_phone]^0 auriculares (%s): %s; nova tentativa em %gs."
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = A0_2.kind
    L6_2 = A1_2
    L7_2 = tonumber
    L8_2 = L22_1
    L8_2 = L8_2()
    L8_2 = L8_2.retryDelayMs
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      L7_2 = 10000
    end
    L7_2 = L7_2 / 1000
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  end
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2
  L1_2 = {}
  L2_2 = L28_1
  L3_2 = A0_2.kind
  L2_2 = L2_2(L3_2)
  L3_2 = L26_1
  L4_2 = A0_2.kind
  L3_2 = L3_2(L4_2)
  L4_2 = A0_2.kind
  if "slate" == L4_2 then
    L4_2 = "stream/apex_slate_buds.ytyp"
    if L4_2 then
      goto lbl_16
    end
  end
  L4_2 = "stream/apex_airpods.ytyp"
  ::lbl_16::
  L5_2 = ipairs
  L6_2 = L6_1
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L2_2[L10_2]
    L12_2 = L17_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      L12_2 = L18_1
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if L12_2 then
        goto lbl_46
      end
    end
    L12_2 = L36_1
    L13_2 = L1_2
    L12_2(L13_2)
    L12_2 = L37_1
    L13_2 = A0_2
    L14_2 = "modelo indisponivel: "
    L15_2 = tostring
    L16_2 = L3_2[L10_2]
    L15_2 = L15_2(L16_2)
    L16_2 = " ("
    L17_2 = L4_2
    L18_2 = "?)"
    L14_2 = L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2
    L12_2(L13_2, L14_2)
    do return end
    ::lbl_46::
    L12_2 = L4_1
    L13_2 = L4_1
    L13_2 = L13_2[L11_2]
    if not L13_2 then
      L13_2 = 0
    end
    L13_2 = L13_2 + 1
    L12_2[L11_2] = L13_2
    L12_2 = #L1_2
    L12_2 = L12_2 + 1
    L1_2[L12_2] = L11_2
    L12_2 = RequestModel
    L13_2 = L11_2
    L12_2(L13_2)
  end
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L6_2 = tonumber
  L7_2 = L22_1
  L7_2 = L7_2()
  L7_2 = L7_2.modelLoadTimeoutMs
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 5000
  end
  while true do
    L7_2 = L19_1
    L8_2 = L2_2.left
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L7_2 = L19_1
      L8_2 = L2_2.right
      L7_2 = L7_2(L8_2)
      if L7_2 then
        break
      end
    end
    L7_2 = L35_1
    L8_2 = A0_2
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      L7_2 = L36_1
      L8_2 = L1_2
      L7_2(L8_2)
      L8_2 = A0_2.id
      L7_2 = L2_1
      L7_2 = L7_2[L8_2]
      if L7_2 == A0_2 then
        L7_2 = L33_1
        L8_2 = A0_2.id
        L7_2(L8_2)
      end
      return
    end
    L7_2 = L31_1
    L8_2 = GetGameTimer
    L8_2 = L8_2()
    L9_2 = L5_2
    L7_2 = L7_2(L8_2, L9_2)
    if L6_2 <= L7_2 then
      L7_2 = L36_1
      L8_2 = L1_2
      L7_2(L8_2)
      L7_2 = L37_1
      L8_2 = A0_2
      L9_2 = "tempo limite a carregar os auriculares"
      L7_2(L8_2, L9_2)
      return
    end
    L7_2 = Wait
    L8_2 = 0
    L7_2(L8_2)
  end
  L7_2 = L35_1
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = L36_1
    L8_2 = L1_2
    L7_2(L8_2)
    L8_2 = A0_2.id
    L7_2 = L2_1
    L7_2 = L7_2[L8_2]
    if L7_2 == A0_2 then
      L7_2 = L33_1
      L8_2 = A0_2.id
      L7_2(L8_2)
    end
    return
  end
  L7_2 = GetPedBoneIndex
  L8_2 = A0_2.ped
  L9_2 = A0_2.fit
  L9_2 = L9_2.bone
  L7_2 = L7_2(L8_2, L9_2)
  if L7_2 < 0 then
    L8_2 = L36_1
    L9_2 = L1_2
    L8_2(L9_2)
    L8_2 = L37_1
    L9_2 = A0_2
    L10_2 = "osso de fixacao inexistente neste ped"
    L8_2(L9_2, L10_2)
    return
  end
  L8_2 = GetEntityCoords
  L9_2 = A0_2.ped
  L8_2 = L8_2(L9_2)
  L9_2 = ipairs
  L10_2 = L6_1
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = CreateObjectNoOffset
    L16_2 = L2_2[L14_2]
    L17_2 = L8_2.x
    L18_2 = L8_2.y
    L19_2 = L8_2.z
    L20_2 = false
    L21_2 = false
    L22_2 = false
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
    if 0 ~= L15_2 then
      L16_2 = L15_1
      L17_2 = L15_2
      L16_2 = L16_2(L17_2)
      if L16_2 then
        goto lbl_184
      end
    end
    L16_2 = L36_1
    L17_2 = L1_2
    L16_2(L17_2)
    L16_2 = L37_1
    L17_2 = A0_2
    L18_2 = "nao foi possivel criar o par de auriculares"
    L16_2(L17_2, L18_2)
    do return end
    ::lbl_184::
    L16_2 = A0_2.objects
    L17_2 = A0_2.objects
    L17_2 = #L17_2
    L17_2 = L17_2 + 1
    L16_2[L17_2] = L15_2
    L16_2 = SetEntityVisible
    L17_2 = L15_2
    L18_2 = false
    L19_2 = false
    L16_2(L17_2, L18_2, L19_2)
    L16_2 = SetEntityAsMissionEntity
    L17_2 = L15_2
    L18_2 = true
    L19_2 = true
    L16_2(L17_2, L18_2, L19_2)
    L16_2 = SetEntityCollision
    L17_2 = L15_2
    L18_2 = false
    L19_2 = false
    L16_2(L17_2, L18_2, L19_2)
    L16_2 = SetEntityNoCollisionEntity
    L17_2 = L15_2
    L18_2 = A0_2.ped
    L19_2 = false
    L16_2(L17_2, L18_2, L19_2)
    L16_2 = SetEntityDynamic
    L17_2 = L15_2
    L18_2 = false
    L16_2(L17_2, L18_2)
    L16_2 = SetEntityHasGravity
    L17_2 = L15_2
    L18_2 = false
    L16_2(L17_2, L18_2)
    L16_2 = SetEntityInvincible
    L17_2 = L15_2
    L18_2 = true
    L16_2(L17_2, L18_2)
    L16_2 = SetEntityCanBeDamaged
    L17_2 = L15_2
    L18_2 = false
    L16_2(L17_2, L18_2)
    L16_2 = A0_2.fit
    L16_2 = L16_2[L14_2]
    L17_2 = L16_2.offset
    L18_2 = L16_2.rotation
    L19_2 = AttachEntityToEntity
    L20_2 = L15_2
    L21_2 = A0_2.ped
    L22_2 = L7_2
    L23_2 = L17_2.x
    L24_2 = L17_2.y
    L25_2 = L17_2.z
    L26_2 = L18_2.x
    L27_2 = L18_2.y
    L28_2 = L18_2.z
    L29_2 = false
    L30_2 = false
    L31_2 = false
    L32_2 = true
    L33_2 = 2
    L34_2 = true
    L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2)
    L19_2 = L20_1
    L20_2 = L15_2
    L21_2 = A0_2.ped
    L19_2 = L19_2(L20_2, L21_2)
    if not L19_2 then
      L19_2 = L36_1
      L20_2 = L1_2
      L19_2(L20_2)
      L19_2 = L37_1
      L20_2 = A0_2
      L21_2 = "nao foi possivel fixar os auriculares ao ped"
      L19_2(L20_2, L21_2)
      return
    end
    L19_2 = SetEntityVisible
    L20_2 = L15_2
    L21_2 = true
    L22_2 = false
    L19_2(L20_2, L21_2, L22_2)
  end
  L9_2 = L36_1
  L10_2 = L1_2
  L9_2(L10_2)
  A0_2.ready = true
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = A0_2.ready
  if not L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = ipairs
  L2_2 = A0_2.objects
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L15_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L7_2 = L20_1
      L8_2 = L6_2
      L9_2 = A0_2.ped
      L7_2 = L7_2(L8_2, L9_2)
      if L7_2 then
        goto lbl_23
      end
    end
    L7_2 = false
    do return L7_2 end
    ::lbl_23::
  end
  L1_2 = A0_2.objects
  L1_2 = #L1_2
  L1_2 = 2 == L1_2
  return L1_2
end
L40_1 = {}
L41_1 = 5000
L42_1 = -L41_1
function L43_1(A0_2)
  local L1_2, L2_2
  if -1 == A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L21_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
function L44_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = ipairs
  L1_2 = GetActivePlayers
  L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L1_2()
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = GetPlayerServerId
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if L6_2 > 0 then
      L7_2 = L40_1
      L8_2 = L24_1
      L9_2 = GlobalState
      L10_2 = L0_1
      L11_2 = L6_2
      L10_2 = L10_2 .. L11_2
      L9_2 = L9_2[L10_2]
      L8_2 = L8_2(L9_2)
      L7_2[L6_2] = L8_2
    end
  end
end
function L45_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = {}
  L1_2 = tonumber
  L2_2 = L22_1
  L2_2 = L2_2()
  L2_2 = L2_2.retryDelayMs
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 10000
  end
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L31_1
  L4_2 = L2_2
  L5_2 = L42_1
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L41_1
  if L3_2 >= L4_2 then
    L42_1 = L2_2
    L3_2 = L44_1
    L3_2()
  end
  L3_2 = next
  L4_2 = L40_1
  L3_2 = L3_2(L4_2)
  if nil == L3_2 then
    L3_2 = next
    L4_2 = L2_1
    L3_2 = L3_2(L4_2)
    if nil == L3_2 then
      L3_2 = next
      L4_2 = L3_1
      L3_2 = L3_2(L4_2)
      if nil == L3_2 then
        return
      end
    end
  end
  L3_2 = pairs
  L4_2 = L40_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = GetPlayerFromServerId
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L7_2 > 0 then
      L9_2 = L43_1
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if L9_2 then
        L9_2 = L24_1
        L10_2 = GlobalState
        L11_2 = L0_1
        L12_2 = L7_2
        L11_2 = L11_2 .. L12_2
        L10_2 = L10_2[L11_2]
        L9_2 = L9_2(L10_2)
        if L9_2 then
          goto lbl_63
        end
      end
    end
    L9_2 = nil
    ::lbl_63::
    if L9_2 then
      L10_2 = GetPlayerPed
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      if 0 ~= L10_2 then
        L11_2 = L15_1
        L12_2 = L10_2
        L11_2 = L11_2(L12_2)
        if L11_2 then
          L11_2 = L16_1
          L12_2 = L10_2
          L11_2 = L11_2(L12_2)
          if not L11_2 then
            L11_2 = L34_1
            L12_2 = L10_2
            L11_2 = L11_2(L12_2)
            if L11_2 then
              L0_2[L7_2] = true
              L11_2 = GetEntityModel
              L12_2 = L10_2
              L11_2 = L11_2(L12_2)
              L12_2 = L2_1
              L12_2 = L12_2[L7_2]
              if L12_2 then
                L13_2 = L12_2.ped
                if L13_2 == L10_2 then
                  L13_2 = L12_2.player
                  if L13_2 == L8_2 then
                    L13_2 = L12_2.pedModel
                    if L13_2 == L11_2 then
                      L13_2 = L12_2.kind
                      if L13_2 == L9_2 then
                        L13_2 = L39_1
                        L14_2 = L12_2
                        L13_2 = L13_2(L14_2)
                        if L13_2 then
                          goto lbl_114
                        end
                      end
                    end
                  end
                end
                L13_2 = L33_1
                L14_2 = L7_2
                L13_2(L14_2)
                L12_2 = nil
              end
              ::lbl_114::
              L13_2 = L3_1
              L13_2 = L13_2[L7_2]
              L14_2 = L13_2
              if L13_2 then
                L14_2 = L13_2.ped
                L14_2 = L14_2 == L10_2
              end
              if not L12_2 and not L14_2 then
                L15_2 = L3_1
                L15_2[L7_2] = nil
                L15_2 = L23_1
                L16_2 = L9_2
                L15_2 = L15_2(L16_2)
                L16_2 = L15_2.fits
                if not L16_2 then
                  L16_2 = {}
                end
                L17_2 = L30_1
                L18_2 = L9_2
                L17_2 = L17_2(L18_2)
                L17_2 = L17_2[L11_2]
                if not L17_2 then
                  L17_2 = L15_2.defaultFit
                  if not L17_2 then
                    L17_2 = "male_template"
                  end
                end
                L17_2 = L16_2[L17_2]
                L18_2 = {}
                L18_2.id = L7_2
                L18_2.player = L8_2
                L18_2.ped = L10_2
                L18_2.pedModel = L11_2
                L18_2.kind = L9_2
                L18_2.fit = L17_2
                L19_2 = {}
                L18_2.objects = L19_2
                L12_2 = L18_2
                L18_2 = L2_1
                L18_2[L7_2] = L12_2
                if not L17_2 then
                  L18_2 = L37_1
                  L19_2 = L12_2
                  L20_2 = "preset de ajuste inexistente (fits do par na config)"
                  L18_2(L19_2, L20_2)
                else
                  L18_2 = L12_2
                  L19_2 = CreateThread
                  function L20_2()
                    local L0_3, L1_3
                    L0_3 = L38_1
                    L1_3 = L18_2
                    L0_3(L1_3)
                  end
                  L19_2(L20_2)
                end
              end
            end
          end
        end
      end
    end
  end
  L3_2 = pairs
  L4_2 = L2_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = L0_2[L7_2]
    if not L8_2 then
      L8_2 = L33_1
      L9_2 = L7_2
      L8_2(L9_2)
    end
  end
  L3_2 = pairs
  L4_2 = L3_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = L0_2[L7_2]
    if not L8_2 then
      L8_2 = L3_1
      L8_2[L7_2] = nil
    end
  end
end
L46_1 = AddStateBagChangeHandler
L47_1 = nil
L48_1 = "global"
function L49_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L5_1
  if not L3_2 then
    L3_2 = type
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L4_2 = A1_2
      L3_2 = A1_2.sub
      L5_2 = 1
      L6_2 = L0_1
      L6_2 = #L6_2
      L3_2 = L3_2(L4_2, L5_2, L6_2)
      L4_2 = L0_1
      if L3_2 == L4_2 then
        goto lbl_18
      end
    end
  end
  do return end
  ::lbl_18::
  L3_2 = tonumber
  L5_2 = A1_2
  L4_2 = A1_2.sub
  L6_2 = L0_1
  L6_2 = #L6_2
  L6_2 = L6_2 + 1
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    return
  end
  L4_2 = L40_1
  L5_2 = L24_1
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  L4_2[L3_2] = L5_2
  L4_2 = L24_1
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L33_1
    L5_2 = L3_2
    L4_2(L5_2)
    L4_2 = L3_1
    L4_2[L3_2] = nil
  end
end
L46_1 = L46_1(L47_1, L48_1, L49_1)
L47_1 = AddEventHandler
L48_1 = "onResourceStop"
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L1_1
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = true
  L5_1 = L1_2
  L1_2 = RemoveStateBagChangeHandler
  L2_2 = L46_1
  L1_2(L2_2)
  L1_2 = pairs
  L2_2 = L2_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = L33_1
    L7_2 = L5_2
    L6_2(L7_2)
  end
  L1_2 = pairs
  L2_2 = L4_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = SetModelAsNoLongerNeeded
    L7_2 = L5_2
    L6_2(L7_2)
  end
  L1_2 = {}
  L4_1 = L1_2
end
L47_1(L48_1, L49_1)
L47_1 = CreateThread
function L48_1()
  local L0_2, L1_2, L2_2
  while true do
    L0_2 = L5_1
    if L0_2 then
      break
    end
    L0_2 = Config
    L0_2 = L0_2.AirPods
    if not L0_2 then
      L0_2 = Config
      L0_2 = L0_2.SlateBuds
      if not L0_2 then
        goto lbl_14
      end
    end
    L0_2 = L45_1
    L0_2()
    ::lbl_14::
    L0_2 = Wait
    L1_2 = tonumber
    L2_2 = L22_1
    L2_2 = L2_2()
    L2_2 = L2_2.reconcileMs
    L1_2 = L1_2(L2_2)
    if not L1_2 then
      L1_2 = 300
    end
    L0_2(L1_2)
  end
end
L47_1(L48_1)
function L47_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L24_1
  L1_2 = GlobalState
  L2_2 = L0_1
  L3_2 = GetPlayerServerId
  L4_2 = PlayerId
  L4_2 = L4_2()
  L3_2 = L3_2(L4_2)
  L2_2 = L2_2 .. L3_2
  L1_2 = L1_2[L2_2]
  L0_2 = L0_2(L1_2)
  L0_2 = nil ~= L0_2
  return L0_2
end
AirPodsWorn = L47_1
