local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.upper
  return L1_2(L2_2)
end
L1_1 = RegisterNUICallback
L2_1 = "locateVehicle"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L0_1
  L3_2 = A0_2.plate
  L2_2 = L2_2(L3_2)
  if "" == L2_2 then
    L3_2 = A1_2
    L4_2 = false
    L3_2(L4_2)
    return
  end
  L3_2 = nil
  L4_2 = 1.0E9
  L5_2 = GetEntityCoords
  L6_2 = PlayerPedId
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2()
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = ipairs
  L7_2 = GetGamePool
  L8_2 = "CVehicle"
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L0_1
    L13_2 = GetVehicleNumberPlateText
    L14_2 = L11_2
    L13_2, L14_2 = L13_2(L14_2)
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 == L2_2 then
      L12_2 = GetEntityCoords
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      L13_2 = L12_2 - L5_2
      L13_2 = #L13_2
      if L4_2 > L13_2 then
        L14_2 = L12_2
        L4_2 = L13_2
        L3_2 = L14_2
      end
    end
  end
  if L3_2 then
    L6_2 = SetNewWaypoint
    L7_2 = L3_2.x
    L8_2 = L3_2.y
    L6_2(L7_2, L8_2)
    L6_2 = A1_2
    L7_2 = {}
    L8_2 = L3_2.x
    L7_2.x = L8_2
    L8_2 = L3_2.y
    L7_2.y = L8_2
    L8_2 = L3_2.z
    L7_2.z = L8_2
    L7_2.dist = L4_2
    L6_2(L7_2)
  else
    L6_2 = A1_2
    L7_2 = false
    L6_2(L7_2)
  end
end
L1_1(L2_1, L3_1)
L1_1 = RegisterNUICallback
L2_1 = "garageWaypoint"
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2.x
  if L2_2 then
    L2_2 = A0_2.y
    if L2_2 then
      L2_2 = SetNewWaypoint
      L3_2 = A0_2.x
      L3_2 = L3_2 + 0.0
      L4_2 = A0_2.y
      L4_2 = L4_2 + 0.0
      L2_2(L3_2, L4_2)
    end
  end
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L1_1(L2_1, L3_1)
L1_1 = false
L2_1 = {}
function L3_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
function L4_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetResourceState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = "started" == L1_2 or "starting" == L1_2
  return L2_2
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0.5
  end
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = A0_2 & 4294967295
  return L1_2
end
function L6_1(A0_2)
  local L1_2, L2_2
  L1_2 = L5_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = 2147483648
  if A0_2 >= L1_2 then
    A0_2 = A0_2 - 4294967296
  end
  return A0_2
end
function L7_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = _G
  L1_2 = L1_2[A0_2]
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = table
  L2_2 = L2_2.pack
  L3_2 = pcall
  L4_2 = L1_2
  L5_2, L6_2 = ...
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = L2_2[1]
  if not L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = table
  L3_2 = L3_2.unpack
  L4_2 = L2_2
  L5_2 = 2
  L6_2 = L2_2.n
  return L3_2(L4_2, L5_2, L6_2)
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = promise
  L2_2 = L2_2.new
  L2_2 = L2_2()
  L3_2 = ServerRpc
  L4_2 = A0_2
  L5_2 = A1_2
  function L6_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L2_2
    L2_3 = L1_3
    L1_3 = L1_3.resolve
    L3_3 = A0_3
    L1_3(L2_3, L3_3)
  end
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = Citizen
  L3_2 = L3_2.Await
  L4_2 = L2_2
  return L3_2(L4_2)
end
L9_1 = {}
L10_1 = L5_1
L11_1 = GetHashKey
L12_1 = "submersible"
L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1 = L11_1(L12_1)
L10_1 = L10_1(L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1)
L9_1[L10_1] = true
L10_1 = L5_1
L11_1 = GetHashKey
L12_1 = "submersible2"
L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1 = L11_1(L12_1)
L10_1 = L10_1(L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1)
L9_1[L10_1] = true
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = L7_1
  L3_2 = "IsThisModelAHeli"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L1_2 = "heli"
    return L1_2
  end
  L1_2 = L3_1
  L2_2 = L7_1
  L3_2 = "IsThisModelAPlane"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L1_2 = "plane"
    return L1_2
  end
  L1_2 = L5_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L9_1
  L1_2 = L2_2[L1_2]
  if L1_2 then
    L1_2 = "submarine"
    return L1_2
  end
  L1_2 = L3_1
  L2_2 = L7_1
  L3_2 = "IsThisModelABoat"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L1_2 = L3_1
    L2_2 = L7_1
    L3_2 = "IsThisModelAJetski"
    L4_2 = A0_2
    L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if not L1_2 then
      goto lbl_48
    end
  end
  L1_2 = "boat"
  do return L1_2 end
  ::lbl_48::
  L1_2 = L3_1
  L2_2 = L7_1
  L3_2 = "IsThisModelATrain"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L1_2 = "train"
    return L1_2
  end
  L1_2 = L3_1
  L2_2 = L7_1
  L3_2 = "IsThisModelABike"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L1_2 = L3_1
    L2_2 = L7_1
    L3_2 = "IsThisModelABicycle"
    L4_2 = A0_2
    L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if not L1_2 then
      goto lbl_76
    end
  end
  L1_2 = "bike"
  do return L1_2 end
  ::lbl_76::
  L1_2 = L3_1
  L2_2 = L7_1
  L3_2 = "IsThisModelACar"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L1_2 = L3_1
    L2_2 = L7_1
    L3_2 = "IsThisModelAQuadbike"
    L4_2 = A0_2
    L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if not L1_2 then
      goto lbl_94
    end
  end
  L1_2 = "automobile"
  do return L1_2 end
  ::lbl_94::
  L1_2 = tonumber
  L2_2 = L7_1
  L3_2 = "GetVehicleClassFromName"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if 11 == L1_2 then
    L1_2 = "trailer"
    return L1_2
  end
  L1_2 = "automobile"
  return L1_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L7_1
  L2_2 = "GetDisplayNameFromVehicleModel"
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 or "" == L1_2 or "CARNOTFOUND" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L3_2 = L1_2
  L2_2 = L1_2.lower
  return L2_2(L3_2)
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L3_1
  L2_2 = L7_1
  L3_2 = "IsAnyVehicleNearPoint"
  L4_2 = A0_2.x
  L5_2 = A0_2.y
  L6_2 = A0_2.z
  L7_2 = 3.5
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  if L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L7_1
  L2_2 = "GetWaterHeight"
  L3_2 = A0_2.x
  L4_2 = A0_2.y
  L5_2 = A0_2.z
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L3_2 = L3_1
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L3_2 = tonumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = A0_2.z
      L3_2 = L3_2 - 1.0
      if L2_2 > L3_2 then
        L3_2 = false
        return L3_2
      end
    end
  end
  L3_2 = true
  return L3_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 15.0
  end
  L3_2 = tonumber
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  A1_2 = L3_2 or A1_2
  if not L3_2 then
    A1_2 = 90.0
  end
  A0_2 = L2_2
  L2_2 = GetEntityCoords
  L3_2 = PlayerPedId
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L3_2()
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L3_2 = ipairs
  L4_2 = {}
  L5_2 = 0
  L6_2 = 1
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = nil
    L10_2 = 1
    L11_2 = 80
    L12_2 = 1
    for L13_2 = L10_2, L11_2, L12_2 do
      L14_2 = L7_1
      L15_2 = "GetNthClosestVehicleNodeWithHeading"
      L16_2 = L2_2.x
      L17_2 = L2_2.y
      L18_2 = L2_2.z
      L19_2 = L13_2
      L20_2 = L8_2
      L21_2 = 3.0
      L22_2 = 0.0
      L14_2, L15_2, L16_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
      L17_2 = L3_1
      L18_2 = L14_2
      L17_2 = L17_2(L18_2)
      if L17_2 and L15_2 then
        L17_2 = L15_2.x
        L18_2 = L2_2.x
        L17_2 = L17_2 - L18_2
        L18_2 = L15_2.y
        L19_2 = L2_2.y
        L18_2 = L18_2 - L19_2
        L19_2 = math
        L19_2 = L19_2.sqrt
        L20_2 = L17_2 * L17_2
        L21_2 = L18_2 * L18_2
        L20_2 = L20_2 + L21_2
        L19_2 = L19_2(L20_2)
        L20_2 = A1_2 * 1.5
        if L19_2 > L20_2 then
          break
        end
        if A1_2 >= L19_2 and L19_2 >= 6.0 then
          L20_2 = math
          L20_2 = L20_2.abs
          L21_2 = L15_2.z
          L22_2 = L2_2.z
          L21_2 = L21_2 - L22_2
          L20_2 = L20_2(L21_2)
          if L20_2 < 40.0 then
            L20_2 = L12_1
            L21_2 = L15_2
            L20_2 = L20_2(L21_2)
            if L20_2 then
              if A0_2 <= L19_2 then
                L20_2 = L15_2
                L21_2 = tonumber
                L22_2 = L16_2
                L21_2 = L21_2(L22_2)
                if not L21_2 then
                  L21_2 = 0.0
                end
                L22_2 = L19_2
                return L20_2, L21_2, L22_2
              end
              if not L9_2 then
                L20_2 = {}
                L21_2 = L15_2
                L22_2 = tonumber
                L23_2 = L16_2
                L22_2 = L22_2(L23_2)
                if not L22_2 then
                  L22_2 = 0.0
                end
                L23_2 = L19_2
                L20_2[1] = L21_2
                L20_2[2] = L22_2
                L20_2[3] = L23_2
                L9_2 = L20_2
              end
            end
          end
        end
      end
    end
    if L9_2 then
      L10_2 = L9_2[1]
      L11_2 = L9_2[2]
      L12_2 = L9_2[3]
      return L10_2, L11_2, L12_2
    end
  end
  L3_2 = nil
  return L3_2
end
L14_1 = {}
L14_1.modSpoilers = 0
L14_1.modFrontBumper = 1
L14_1.modRearBumper = 2
L14_1.modSideSkirt = 3
L14_1.modExhaust = 4
L14_1.modFrame = 5
L14_1.modGrille = 6
L14_1.modHood = 7
L14_1.modFender = 8
L14_1.modRightFender = 9
L14_1.modRoof = 10
L14_1.modEngine = 11
L14_1.modBrakes = 12
L14_1.modTransmission = 13
L14_1.modHorns = 14
L14_1.modSuspension = 15
L14_1.modArmor = 16
L14_1.modNitrous = 17
L14_1.modSubwoofer = 19
L14_1.modHydraulics = 21
L14_1.modFrontWheels = 23
L14_1.modBackWheels = 24
L14_1.modPlateHolder = 25
L14_1.modVanityPlate = 26
L14_1.modTrimA = 27
L14_1.modOrnaments = 28
L14_1.modDashboard = 29
L14_1.modDial = 30
L14_1.modDoorSpeaker = 31
L14_1.modSeats = 32
L14_1.modSteeringWheel = 33
L14_1.modShifterLeavers = 34
L14_1.modAPlate = 35
L14_1.modSpeakers = 36
L14_1.modTrunk = 37
L14_1.modHydrolic = 38
L14_1.modEngineBlock = 39
L14_1.modAirFilter = 40
L14_1.modStruts = 41
L14_1.modArchCover = 42
L14_1.modAerials = 43
L14_1.modTrimB = 44
L14_1.modTank = 45
L14_1.modWindows = 46
L14_1.modDoorR = 47
L14_1.modLivery = 48
L14_1.modLightbar = 49
L15_1 = {}
L15_1.modTurbo = 18
L15_1.modSmokeEnabled = 20
L15_1.modXenon = 22
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tonumber
  L2_2 = A0_2[1]
  if not L2_2 then
    L2_2 = A0_2.r
  end
  L1_2 = L1_2(L2_2)
  L2_2 = tonumber
  L3_2 = A0_2[2]
  if not L3_2 then
    L3_2 = A0_2.g
  end
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A0_2[3]
  if not L4_2 then
    L4_2 = A0_2.b
  end
  L3_2 = L3_2(L4_2)
  if L1_2 and L2_2 and L3_2 then
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L1_2
    L4_2 = L4_2(L5_2)
    L5_2 = math
    L5_2 = L5_2.floor
    L6_2 = L2_2
    L5_2 = L5_2(L6_2)
    L6_2 = math
    L6_2 = L6_2.floor
    L7_2 = L3_2
    L6_2, L7_2 = L6_2(L7_2)
    return L4_2, L5_2, L6_2, L7_2
  end
  L4_2 = nil
  return L4_2
end
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  function L2_2(A0_3)
    local L1_3, L2_3
    L1_3 = pcall
    L2_3 = A0_3
    L1_3(L2_3)
  end
  L3_2 = L2_2
  function L4_2()
    local L0_3, L1_3, L2_3
    L0_3 = SetVehicleModKit
    L1_3 = A0_2
    L2_3 = 0
    L0_3(L1_3, L2_3)
  end
  L3_2(L4_2)
  L3_2 = A1_2.plateIndex
  if L3_2 then
    L3_2 = L2_2
    function L4_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleNumberPlateTextIndex
      L1_3 = A0_2
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.plateIndex
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L3_2(L4_2)
  end
  L3_2 = A1_2.bodyHealth
  if L3_2 then
    L3_2 = L2_2
    function L4_2()
      local L0_3, L1_3, L2_3
      L0_3 = SetVehicleBodyHealth
      L1_3 = A0_2
      L2_3 = A1_2.bodyHealth
      L2_3 = L2_3 + 0.0
      L0_3(L1_3, L2_3)
    end
    L3_2(L4_2)
  end
  L3_2 = A1_2.engineHealth
  if L3_2 then
    L3_2 = L2_2
    function L4_2()
      local L0_3, L1_3, L2_3
      L0_3 = SetVehicleEngineHealth
      L1_3 = A0_2
      L2_3 = A1_2.engineHealth
      L2_3 = L2_3 + 0.0
      L0_3(L1_3, L2_3)
    end
    L3_2(L4_2)
  end
  L3_2 = A1_2.tankHealth
  if L3_2 then
    L3_2 = L2_2
    function L4_2()
      local L0_3, L1_3, L2_3
      L0_3 = SetVehiclePetrolTankHealth
      L1_3 = A0_2
      L2_3 = A1_2.tankHealth
      L2_3 = L2_3 + 0.0
      L0_3(L1_3, L2_3)
    end
    L3_2(L4_2)
  end
  L3_2 = A1_2.dirtLevel
  if L3_2 then
    L3_2 = L2_2
    function L4_2()
      local L0_3, L1_3, L2_3
      L0_3 = SetVehicleDirtLevel
      L1_3 = A0_2
      L2_3 = A1_2.dirtLevel
      L2_3 = L2_3 + 0.0
      L0_3(L1_3, L2_3)
    end
    L3_2(L4_2)
  end
  L3_2 = L2_2
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = GetVehicleColours
    L1_3 = A0_2
    L0_3, L1_3 = L0_3(L1_3)
    L2_3 = tonumber
    L3_3 = A1_2.color1
    L2_3 = L2_3(L3_3)
    if L2_3 then
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.color1
      L2_3 = L2_3(L3_3)
      L0_3 = L2_3
    end
    L2_3 = tonumber
    L3_3 = A1_2.color2
    L2_3 = L2_3(L3_3)
    if L2_3 then
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.color2
      L2_3 = L2_3(L3_3)
      L1_3 = L2_3
    end
    L2_3 = SetVehicleColours
    L3_3 = A0_2
    L4_3 = L0_3
    L5_3 = L1_3
    L2_3(L3_3, L4_3, L5_3)
  end
  L3_2(L4_2)
  L3_2 = L16_1
  L4_2 = A1_2.color1
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  if L3_2 then
    L6_2 = L2_2
    function L7_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = SetVehicleCustomPrimaryColour
      L1_3 = A0_2
      L2_3 = L3_2
      L3_3 = L4_2
      L4_3 = L5_2
      L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L6_2(L7_2)
  end
  L6_2 = L16_1
  L7_2 = A1_2.color2
  L6_2, L7_2, L8_2 = L6_2(L7_2)
  if L6_2 then
    L9_2 = L2_2
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = SetVehicleCustomSecondaryColour
      L1_3 = A0_2
      L2_3 = L6_2
      L3_3 = L7_2
      L4_3 = L8_2
      L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L9_2(L10_2)
  end
  L9_2 = tonumber
  L10_2 = A1_2.pearlescentColor
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = tonumber
    L10_2 = A1_2.wheelColor
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      goto lbl_67
    end
  end
  L9_2 = L2_2
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = GetVehicleExtraColours
    L1_3 = A0_2
    L0_3, L1_3 = L0_3(L1_3)
    L2_3 = SetVehicleExtraColours
    L3_3 = A0_2
    L4_3 = math
    L4_3 = L4_3.floor
    L5_3 = tonumber
    L6_3 = A1_2.pearlescentColor
    L5_3 = L5_3(L6_3)
    if not L5_3 then
      L5_3 = L0_3
    end
    L4_3 = L4_3(L5_3)
    L5_3 = math
    L5_3 = L5_3.floor
    L6_3 = tonumber
    L7_3 = A1_2.wheelColor
    L6_3 = L6_3(L7_3)
    if not L6_3 then
      L6_3 = L1_3
    end
    L5_3, L6_3, L7_3 = L5_3(L6_3)
    L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
  end
  L9_2(L10_2)
  ::lbl_67::
  L9_2 = tonumber
  L10_2 = A1_2.interiorColor
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = L2_2
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleInteriorColor
      L1_3 = A0_2
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.interiorColor
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L9_2(L10_2)
  end
  L9_2 = tonumber
  L10_2 = A1_2.dashboardColor
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = L2_2
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleDashboardColor
      L1_3 = A0_2
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.dashboardColor
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L9_2(L10_2)
  end
  L9_2 = tonumber
  L10_2 = A1_2.wheels
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = L2_2
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleWheelType
      L1_3 = A0_2
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.wheels
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L9_2(L10_2)
  end
  L9_2 = tonumber
  L10_2 = A1_2.windowTint
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = L2_2
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleWindowTint
      L1_3 = A0_2
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.windowTint
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L9_2(L10_2)
  end
  L9_2 = type
  L10_2 = A1_2.neonEnabled
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = 1
    L10_2 = 4
    L11_2 = 1
    for L12_2 = L9_2, L10_2, L11_2 do
      L13_2 = A1_2.neonEnabled
      L13_2 = L13_2[L12_2]
      if nil ~= L13_2 then
        L14_2 = L2_2
        function L15_2()
          local L0_3, L1_3, L2_3, L3_3
          L0_3 = SetVehicleNeonLightEnabled
          L1_3 = A0_2
          L2_3 = L12_2
          L2_3 = L2_3 - 1
          L3_3 = L13_2
          L3_3 = true == L3_3
          L0_3(L1_3, L2_3, L3_3)
        end
        L14_2(L15_2)
      end
    end
  end
  L9_2 = L16_1
  L10_2 = A1_2.neonColor
  L9_2, L10_2, L11_2 = L9_2(L10_2)
  if L9_2 then
    L12_2 = L2_2
    function L13_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = SetVehicleNeonLightsColour
      L1_3 = A0_2
      L2_3 = L9_2
      L3_3 = L10_2
      L4_3 = L11_2
      L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L12_2(L13_2)
  end
  L12_2 = L16_1
  L13_2 = A1_2.tyreSmokeColor
  L12_2, L13_2, L14_2 = L12_2(L13_2)
  if L12_2 then
    L15_2 = L2_2
    function L16_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = SetVehicleTyreSmokeColor
      L1_3 = A0_2
      L2_3 = L12_2
      L3_3 = L13_2
      L4_3 = L14_2
      L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L15_2(L16_2)
  end
  L15_2 = tonumber
  L16_2 = A1_2.xenonColor
  L15_2 = L15_2(L16_2)
  if L15_2 then
    L15_2 = L2_2
    function L16_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleXenonLightsColor
      L1_3 = A0_2
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = A1_2.xenonColor
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L15_2(L16_2)
  end
  L15_2 = type
  L16_2 = A1_2.extras
  L15_2 = L15_2(L16_2)
  if "table" == L15_2 then
    L15_2 = pairs
    L16_2 = A1_2.extras
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
      L21_2 = tonumber
      L22_2 = L19_2
      L21_2 = L21_2(L22_2)
      if L21_2 then
        L22_2 = L2_2
        function L23_2()
          local L0_3, L1_3, L2_3, L3_3
          L0_3 = SetVehicleExtra
          L1_3 = A0_2
          L2_3 = math
          L2_3 = L2_3.floor
          L3_3 = L21_2
          L2_3 = L2_3(L3_3)
          L3_3 = L20_2
          L3_3 = true ~= L3_3
          L0_3(L1_3, L2_3, L3_3)
        end
        L22_2(L23_2)
      end
    end
  end
  L15_2 = pairs
  L16_2 = L14_1
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    L21_2 = tonumber
    L22_2 = A1_2[L19_2]
    L21_2 = L21_2(L22_2)
    if L21_2 then
      if 23 == L20_2 then
        L22_2 = A1_2.modCustomTiresF
      end
      L22_2 = true == L22_2
      L23_2 = L2_2
      function L24_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3
        L0_3 = SetVehicleMod
        L1_3 = A0_2
        L2_3 = L20_2
        L3_3 = math
        L3_3 = L3_3.floor
        L4_3 = L21_2
        L3_3 = L3_3(L4_3)
        L4_3 = L22_2
        L0_3(L1_3, L2_3, L3_3, L4_3)
      end
      L23_2(L24_2)
    end
  end
  L15_2 = pairs
  L16_2 = L15_1
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    L21_2 = A1_2[L19_2]
    if nil ~= L21_2 then
      L21_2 = L2_2
      function L22_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3
        L0_3 = ToggleVehicleMod
        L1_3 = A0_2
        L2_3 = L20_2
        L4_3 = L19_2
        L3_3 = A1_2
        L3_3 = L3_3[L4_3]
        L3_3 = true == L3_3
        L0_3(L1_3, L2_3, L3_3)
      end
      L21_2(L22_2)
    end
  end
  L15_2 = tonumber
  L16_2 = A1_2.livery
  L15_2 = L15_2(L16_2)
  if not L15_2 then
    L15_2 = tonumber
    L16_2 = A1_2.modLivery
    L15_2 = L15_2(L16_2)
  end
  if L15_2 and L15_2 >= 0 then
    L16_2 = L2_2
    function L17_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleLivery
      L1_3 = A0_2
      L2_3 = math
      L2_3 = L2_3.floor
      L3_3 = L15_2
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L16_2(L17_2)
  end
  L16_2 = A1_2.plate
  if L16_2 then
    L16_2 = L2_2
    function L17_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = SetVehicleNumberPlateText
      L1_3 = A0_2
      L2_3 = tostring
      L3_3 = A1_2.plate
      L2_3, L3_3 = L2_3(L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L16_2(L17_2)
  end
  L16_2 = true
  return L16_2
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = next
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if nil ~= L2_2 then
      goto lbl_13
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_13::
  L2_2 = FW
  L2_2 = L2_2.GetCore
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.GetCore
    L2_2 = L2_2()
    if L2_2 then
      goto lbl_23
    end
  end
  L2_2 = nil
  ::lbl_23::
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = nil
    L4_2 = FW
    L4_2 = L4_2.name
    if "esx" == L4_2 then
      L4_2 = type
      L5_2 = L2_2.Game
      L4_2 = L4_2(L5_2)
      if "table" == L4_2 then
        L4_2 = L2_2.Game
        L4_2 = L4_2.SetVehicleProperties
        L3_2 = L4_2 or L3_2
      end
      if not L4_2 then
        L3_2 = nil
      end
    else
      L4_2 = FW
      L4_2 = L4_2.name
      if "qb" ~= L4_2 then
        L4_2 = FW
        L4_2 = L4_2.name
        if "qbx" ~= L4_2 then
          goto lbl_62
        end
      end
      L4_2 = type
      L5_2 = L2_2.Functions
      L4_2 = L4_2(L5_2)
      if "table" == L4_2 then
        L4_2 = L2_2.Functions
        L4_2 = L4_2.SetVehicleProperties
        if L4_2 then
          goto lbl_62
          L3_2 = L4_2 or L3_2
        end
      end
      L3_2 = nil
    end
    ::lbl_62::
    if L3_2 then
      L4_2 = pcall
      L5_2 = L3_2
      L6_2 = A0_2
      L7_2 = A1_2
      L4_2 = L4_2(L5_2, L6_2, L7_2)
      if L4_2 then
        L4_2 = true
        return L4_2
      end
    end
  end
  L3_2 = pcall
  L4_2 = L17_1
  L5_2 = A0_2
  L6_2 = A1_2
  return L3_2(L4_2, L5_2, L6_2)
end
L19_1 = {}
L20_1 = "LegacyFuel"
L21_1 = "cdn-fuel"
L22_1 = "ps-fuel"
L23_1 = "lj-fuel"
L24_1 = "qs-fuelstations"
L25_1 = "okokGasStation"
L26_1 = "lc_fuel"
L19_1[1] = L20_1
L19_1[2] = L21_1
L19_1[3] = L22_1
L19_1[4] = L23_1
L19_1[5] = L24_1
L19_1[6] = L25_1
L19_1[7] = L26_1
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = tonumber
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  A1_2 = L2_2
  if not A1_2 then
    return
  end
  if A1_2 < 0 then
    A1_2 = 0.0
  elseif A1_2 > 100 then
    A1_2 = 100.0
  end
  L2_2 = pcall
  L3_2 = SetVehicleFuelLevel
  L4_2 = A0_2
  L5_2 = A1_2 + 0.0
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = Entity
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L1_3 = L0_3
    L0_3 = L0_3.set
    L2_3 = "fuel"
    L3_3 = A1_2
    L3_3 = L3_3 + 0.0
    L4_3 = true
    L0_3(L1_3, L2_3, L3_3, L4_3)
  end
  L2_2(L3_2)
  L2_2 = ipairs
  L3_2 = L19_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L4_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L8_2 = pcall
      function L9_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = exports
        L1_3 = L7_2
        L0_3 = L0_3[L1_3]
        L1_3 = L0_3
        L0_3 = L0_3.SetFuel
        L2_3 = A0_2
        L3_3 = A1_2
        L3_3 = L3_3 + 0.0
        L0_3(L1_3, L2_3, L3_3)
      end
      L8_2(L9_2)
    end
  end
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 and A0_2 and 0 ~= A0_2 then
    L2_2 = L3_1
    L3_2 = DoesEntityExist
    L4_2 = A0_2
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L3_2(L4_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    if L2_2 then
      goto lbl_19
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_19::
  L2_2 = tostring
  L3_2 = A1_2.t
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = ":"
  L4_2 = tostring
  L5_2 = A1_2.plate
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L2_2 = L2_2 .. L3_2 .. L4_2
  L3_2 = L2_1
  L3_2 = L3_2[L2_2]
  if L3_2 then
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L4_2 = L2_1
    L4_2 = L4_2[L2_2]
    L3_2 = L3_2 - L4_2
    L4_2 = 15000
    if L3_2 < L4_2 then
      L3_2 = true
      return L3_2
    end
  end
  L3_2 = L2_1
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L3_2[L2_2] = L4_2
  L3_2 = L18_1
  L4_2 = A0_2
  L5_2 = A1_2.props
  L3_2(L4_2, L5_2)
  L3_2 = A1_2.plate
  if L3_2 then
    L3_2 = pcall
    L4_2 = SetVehicleNumberPlateText
    L5_2 = A0_2
    L6_2 = tostring
    L7_2 = A1_2.plate
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2(L7_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L3_2 = tonumber
  L4_2 = A1_2.engine
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = A1_2.body
  L4_2 = L4_2(L5_2)
  if L3_2 then
    L5_2 = pcall
    L6_2 = SetVehicleEngineHealth
    L7_2 = A0_2
    L8_2 = math
    L8_2 = L8_2.max
    L9_2 = 0.0
    L10_2 = math
    L10_2 = L10_2.min
    L11_2 = 1000.0
    L12_2 = L3_2 + 0.0
    L10_2 = L10_2(L11_2, L12_2)
    L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2, L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  if L4_2 then
    L5_2 = pcall
    L6_2 = SetVehicleBodyHealth
    L7_2 = A0_2
    L8_2 = math
    L8_2 = L8_2.max
    L9_2 = 0.0
    L10_2 = math
    L10_2 = L10_2.min
    L11_2 = 1000.0
    L12_2 = L4_2 + 0.0
    L10_2 = L10_2(L11_2, L12_2)
    L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2, L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L5_2 = L20_1
  L6_2 = A0_2
  L7_2 = A1_2.fuel
  L5_2(L6_2, L7_2)
  L5_2 = pcall
  L6_2 = SetVehicleOnGroundProperly
  L7_2 = A0_2
  L5_2(L6_2, L7_2)
  L5_2 = pcall
  L6_2 = SetVehicleHasBeenOwnedByPlayer
  L7_2 = A0_2
  L8_2 = true
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = pcall
  L6_2 = SetVehicleNeedsToBeHotwired
  L7_2 = A0_2
  L8_2 = false
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = true
  return L5_2
end
L22_1 = AddStateBagChangeHandler
L23_1 = "apex_phone:delivery"
L24_1 = nil
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    return
  end
  L3_2 = CreateThread
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = nil
    L1_3 = 1
    L2_3 = 100
    L3_3 = 1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = L7_1
      L6_3 = "GetEntityFromStateBagName"
      L7_3 = A0_2
      L5_3 = L5_3(L6_3, L7_3)
      if not L5_3 or 0 == L5_3 then
        L6_3 = tonumber
        L7_3 = tostring
        L8_3 = A0_2
        L7_3 = L7_3(L8_3)
        L8_3 = L7_3
        L7_3 = L7_3.match
        L9_3 = "^entity:(%d+)$"
        L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3, L9_3)
        L6_3 = L6_3(L7_3, L8_3, L9_3, L10_3)
        if L6_3 then
          L7_3 = L3_1
          L8_3 = L7_1
          L9_3 = "NetworkDoesEntityExistWithNetworkId"
          L10_3 = L6_3
          L8_3, L9_3, L10_3 = L8_3(L9_3, L10_3)
          L7_3 = L7_3(L8_3, L9_3, L10_3)
          if L7_3 then
            L7_3 = NetToVeh
            L8_3 = L6_3
            L7_3 = L7_3(L8_3)
            L5_3 = L7_3
          end
        end
      end
      if L5_3 and 0 ~= L5_3 then
        L0_3 = L5_3
        break
      end
      L6_3 = Wait
      L7_3 = 100
      L6_3(L7_3)
    end
    if not L0_3 then
      return
    end
    L1_3 = 1
    L2_3 = 15
    L3_3 = 1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = L3_1
      L6_3 = DoesEntityExist
      L7_3 = L0_3
      L6_3, L7_3, L8_3, L9_3, L10_3 = L6_3(L7_3)
      L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
      if not L5_3 then
        return
      end
      L5_3 = NetworkGetEntityOwner
      L6_3 = L0_3
      L5_3 = L5_3(L6_3)
      L6_3 = PlayerId
      L6_3 = L6_3()
      if L5_3 == L6_3 then
        L5_3 = pcall
        L6_3 = L21_1
        L7_3 = L0_3
        L8_3 = A2_2
        L5_3(L6_3, L7_3, L8_3)
        return
      end
      L5_3 = Wait
      L6_3 = 400
      L5_3(L6_3)
    end
  end
  L3_2(L4_2)
end
L22_1(L23_1, L24_1, L25_1)
L22_1 = {}
L23_1 = {}
L23_1.name = "qbx_vehiclekeys"
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = exports
  L2_2 = L2_2.qbx_vehiclekeys
  L3_2 = L2_2
  L2_2 = L2_2.GiveKeys
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
L23_1.fn = L24_1
L24_1 = {}
L24_1.name = "qb-vehiclekeys"
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerEvent
  L3_2 = "vehiclekeys:client:SetOwner"
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L24_1.fn = L25_1
L25_1 = {}
L25_1.name = "wasabi_carlock"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2.wasabi_carlock
  L3_2 = L2_2
  L2_2 = L2_2.GiveKey
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L25_1.fn = L26_1
L26_1 = {}
L26_1.name = "qs-vehiclekeys"
L26_1.needsModel = true
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = exports
  L3_2 = L3_2["qs-vehiclekeys"]
  L4_2 = L3_2
  L3_2 = L3_2.GiveKeys
  L5_2 = A1_2
  L6_2 = A2_2
  L7_2 = true
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
L26_1.fn = L27_1
L27_1 = {}
L27_1.name = "MrNewbVehicleKeys"
L27_1.needsEntity = true
function L28_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = exports
  L1_2 = L1_2.MrNewbVehicleKeys
  L2_2 = L1_2
  L1_2 = L1_2.GiveKeys
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
L27_1.fn = L28_1
L28_1 = {}
L28_1.name = "Renewed-Vehiclekeys"
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2["Renewed-Vehiclekeys"]
  L3_2 = L2_2
  L2_2 = L2_2.addKey
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L28_1.fn = L29_1
L29_1 = {}
L29_1.name = "tgiann-hotwire"
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2["tgiann-hotwire"]
  L3_2 = L2_2
  L2_2 = L2_2.setVehicleKey
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L29_1.fn = L30_1
L30_1 = {}
L30_1.name = "vehicles_keys"
function L31_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerServerEvent
  L3_2 = "vehicles_keys:selfGiveVehicleKeys"
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L30_1.fn = L31_1
L31_1 = {}
L31_1.name = "codem-vehiclekeys"
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2["codem-vehiclekeys"]
  L3_2 = L2_2
  L2_2 = L2_2.GiveKeys
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L31_1.fn = L32_1
L32_1 = {}
L32_1.name = "ti_vehicleKeys"
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2.ti_vehicleKeys
  L3_2 = L2_2
  L2_2 = L2_2.GiveKeys
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L32_1.fn = L33_1
L33_1 = {}
L33_1.name = "brutal_vehiclekeys"
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2.brutal_vehiclekeys
  L3_2 = L2_2
  L2_2 = L2_2.GiveKeys
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L33_1.fn = L34_1
L34_1 = {}
L34_1.name = "mono_carkeys"
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2.mono_carkeys
  L3_2 = L2_2
  L2_2 = L2_2.GiveKey
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L34_1.fn = L35_1
L35_1 = {}
L35_1.name = "cd_garage"
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerEvent
  L3_2 = "cd_garage:AddKeys"
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L35_1.fn = L36_1
L36_1 = {}
L36_1.name = "okokGarage"
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerServerEvent
  L3_2 = "okokGarage:GiveKeys"
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L36_1.fn = L37_1
L37_1 = {}
L37_1.name = "mk_vehiclekeys"
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2.mk_vehiclekeys
  L3_2 = L2_2
  L2_2 = L2_2.AddKey
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L37_1.fn = L38_1
L38_1 = {}
L38_1.name = "t1ger_keys"
function L39_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2.t1ger_keys
  L3_2 = L2_2
  L2_2 = L2_2.GiveKeys
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L38_1.fn = L39_1
L39_1 = {}
L39_1.name = "ak47_vehiclekeys"
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerServerEvent
  L3_2 = "ak47_vehiclekeys:giveKeys"
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L39_1.fn = L40_1
L40_1 = {}
L40_1.name = "F_RealCarKeysSystem"
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerServerEvent
  L3_2 = "F_RealCarKeysSystem:server:addKey"
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L40_1.fn = L41_1
L41_1 = {}
L41_1.name = "xd_locksystem"
function L42_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = exports
  L2_2 = L2_2.xd_locksystem
  L3_2 = L2_2
  L2_2 = L2_2.GiveKey
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L41_1.fn = L42_1
L42_1 = {}
L42_1.name = "esx_vehiclelock"
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = TriggerServerEvent
  L3_2 = "esx_vehiclelock:giveKey"
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L42_1.fn = L43_1
L22_1[1] = L23_1
L22_1[2] = L24_1
L22_1[3] = L25_1
L22_1[4] = L26_1
L22_1[5] = L27_1
L22_1[6] = L28_1
L22_1[7] = L29_1
L22_1[8] = L30_1
L22_1[9] = L31_1
L22_1[10] = L32_1
L22_1[11] = L33_1
L22_1[12] = L34_1
L22_1[13] = L35_1
L22_1[14] = L36_1
L22_1[15] = L37_1
L22_1[16] = L38_1
L22_1[17] = L39_1
L22_1[18] = L40_1
L22_1[19] = L41_1
L22_1[20] = L42_1
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L3_2 = type
  L4_2 = Config
  L4_2 = L4_2.GarageDelivery
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = type
    L4_2 = Config
    L4_2 = L4_2.GarageDelivery
    L4_2 = L4_2.keys
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L3_2 = Config
      L3_2 = L3_2.GarageDelivery
      L3_2 = L3_2.keys
      if L3_2 then
        goto lbl_20
      end
    end
  end
  L3_2 = "auto"
  ::lbl_20::
  if "none" == L3_2 then
    return
  end
  L4_2 = ipairs
  L5_2 = L22_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    if "auto" == L3_2 then
      L10_2 = L4_1
      L11_2 = L9_2.name
      L10_2 = L10_2(L11_2)
      if L10_2 then
        goto lbl_37
      end
    end
    L10_2 = L9_2.name
    ::lbl_37::
    if L3_2 == L10_2 then
      L10_2 = L9_2.needsModel
      if L10_2 then
        L10_2 = not A2_2
        if L10_2 then
          goto lbl_70
        end
      end
      L10_2 = L9_2.needsEntity
      if L10_2 then
        L10_2 = not A0_2
        if L10_2 then
          goto lbl_70
        end
      end
      L10_2 = pcall
      L11_2 = L9_2.fn
      L12_2 = A0_2
      L13_2 = A1_2
      L14_2 = A2_2
      L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      if not L10_2 then
        L12_2 = Config
        L12_2 = L12_2.Debug
        if L12_2 then
          L12_2 = print
          L13_2 = "[unique_phone] garage delivery: key resource %s refused the call: %s"
          L14_2 = L13_2
          L13_2 = L13_2.format
          L15_2 = L9_2.name
          L16_2 = tostring
          L17_2 = L11_2
          L16_2, L17_2 = L16_2(L17_2)
          L13_2, L14_2, L15_2, L16_2, L17_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
          L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
        end
      end
    end
    ::lbl_70::
  end
end
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = pcall
  L3_2 = AddBlipForEntity
  L4_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not (L2_2 and L3_2) or 0 == L3_2 then
    return
  end
  L4_2 = pcall
  L5_2 = SetBlipSprite
  L6_2 = L3_2
  L7_2 = 225
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = pcall
  L5_2 = SetBlipColour
  L6_2 = L3_2
  L7_2 = 2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = pcall
  L5_2 = SetBlipScale
  L6_2 = L3_2
  L7_2 = 0.9
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3
    L0_3 = BeginTextCommandSetBlipName
    L1_3 = "STRING"
    L0_3(L1_3)
    L0_3 = AddTextComponentSubstringPlayerName
    L1_3 = tostring
    L2_3 = A1_2
    if not L2_3 then
      L2_3 = ""
    end
    L1_3, L2_3 = L1_3(L2_3)
    L0_3(L1_3, L2_3)
    L0_3 = EndTextCommandSetBlipName
    L1_3 = L3_2
    L0_3(L1_3)
  end
  L4_2(L5_2)
  L4_2 = CreateThread
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = GetGameTimer
    L0_3 = L0_3()
    while true do
      L1_3 = GetGameTimer
      L1_3 = L1_3()
      L1_3 = L1_3 - L0_3
      L2_3 = 180000
      if not (L1_3 < L2_3) then
        break
      end
      L1_3 = Wait
      L2_3 = 1000
      L1_3(L2_3)
      L1_3 = L3_1
      L2_3 = DoesEntityExist
      L3_3 = A0_2
      L2_3, L3_3 = L2_3(L3_3)
      L1_3 = L1_3(L2_3, L3_3)
      if not L1_3 then
        break
      end
      L1_3 = GetVehiclePedIsIn
      L2_3 = PlayerPedId
      L2_3 = L2_3()
      L3_3 = false
      L1_3 = L1_3(L2_3, L3_3)
      L2_3 = A0_2
      if L1_3 == L2_3 then
        break
      end
    end
    L1_3 = L3_1
    L2_3 = DoesBlipExist
    L3_3 = L3_2
    L2_3, L3_3 = L2_3(L3_3)
    L1_3 = L1_3(L2_3, L3_3)
    if L1_3 then
      L1_3 = RemoveBlip
      L2_3 = L3_2
      L1_3(L2_3)
    end
  end
  L4_2(L5_2)
end
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if not A0_2 or A0_2 <= 0 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  while true do
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_2 = L3_2 - L2_2
    if not (A1_2 > L3_2) then
      break
    end
    L3_2 = L3_1
    L4_2 = NetworkDoesEntityExistWithNetworkId
    L5_2 = A0_2
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if not L3_2 then
      L3_2 = L3_1
      L4_2 = NetworkDoesNetworkIdExist
      L5_2 = A0_2
      L4_2, L5_2, L6_2 = L4_2(L5_2)
      L3_2 = L3_2(L4_2, L5_2, L6_2)
      if not L3_2 then
        goto lbl_48
      end
    end
    L3_2 = NetToVeh
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if L3_2 and 0 ~= L3_2 then
      L4_2 = L3_1
      L5_2 = DoesEntityExist
      L6_2 = L3_2
      L5_2, L6_2 = L5_2(L6_2)
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        return L3_2
      end
    end
    ::lbl_48::
    L3_2 = Wait
    L4_2 = 100
    L3_2(L4_2)
  end
  L3_2 = nil
  return L3_2
end
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  while true do
    L3_2 = L3_1
    L4_2 = NetworkHasControlOfEntity
    L5_2 = A0_2
    L4_2, L5_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      break
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_2 = L3_2 - L2_2
    if not (A1_2 < L3_2) then
      L3_2 = L3_1
      L4_2 = DoesEntityExist
      L5_2 = A0_2
      L4_2, L5_2 = L4_2(L5_2)
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        goto lbl_25
      end
    end
    L3_2 = false
    do return L3_2 end
    ::lbl_25::
    L3_2 = NetworkRequestControlOfEntity
    L4_2 = A0_2
    L3_2(L4_2)
    L3_2 = Wait
    L4_2 = 50
    L3_2(L4_2)
  end
  L3_2 = true
  return L3_2
end
function L27_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = {}
    L1_2.ok = false
    L1_2.error = "server"
    return L1_2
  end
  L1_2 = {}
  L1_2.ok = false
  L2_2 = tostring
  L3_2 = A0_2.error
  if not L3_2 then
    L3_2 = "server"
  end
  L2_2 = L2_2(L3_2)
  L1_2.error = L2_2
  L2_2 = A0_2.wait
  L1_2.wait = L2_2
  L2_2 = A0_2.account
  L1_2.account = L2_2
  L2_2 = A0_2.refunded
  L1_2.refunded = L2_2
  return L1_2
end
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = {}
  L3_2.state = A0_2
  L3_2.plate = A1_2
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = pairs
    L5_2 = A2_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L3_2[L8_2] = L9_2
    end
  end
  L4_2 = Push
  L5_2 = "garageValet"
  L6_2 = L3_2
  L4_2(L5_2, L6_2)
end
function L29_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if A0_2 and 0 ~= A0_2 then
    L1_2 = L3_1
    L2_2 = DoesEntityExist
    L3_2 = A0_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
    if L1_2 then
      goto lbl_13
    end
  end
  do return end
  ::lbl_13::
  L1_2 = pcall
  L2_2 = SetEntityAsMissionEntity
  L3_2 = A0_2
  L4_2 = true
  L5_2 = true
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = pcall
  L2_2 = DeleteEntity
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
  L1_2 = L3_1
  L2_2 = DoesEntityExist
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if L1_2 then
    L1_2 = pcall
    L2_2 = DeletePed
    L3_2 = A0_2
    L1_2(L2_2, L3_2)
  end
end
function L30_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = L3_1
    L1_3 = DoesEntityExist
    L2_3 = A0_2
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3 = L1_3(L2_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
    if not L0_3 then
      return
    end
    L0_3 = A1_2
    if L0_3 then
      L0_3 = A1_2
      if 0 ~= L0_3 then
        L0_3 = GetVehiclePedIsIn
        L1_3 = A0_2
        L2_3 = false
        L0_3 = L0_3(L1_3, L2_3)
        L1_3 = A1_2
        if L0_3 == L1_3 then
          L0_3 = TaskLeaveVehicle
          L1_3 = A0_2
          L2_3 = A1_2
          L3_3 = 0
          L0_3(L1_3, L2_3, L3_3)
          L0_3 = GetGameTimer
          L0_3 = L0_3()
          while true do
            L1_3 = GetVehiclePedIsIn
            L2_3 = A0_2
            L3_3 = false
            L1_3 = L1_3(L2_3, L3_3)
            L2_3 = A1_2
            if L1_3 ~= L2_3 then
              break
            end
            L1_3 = GetGameTimer
            L1_3 = L1_3()
            L1_3 = L1_3 - L0_3
            L2_3 = 6000
            if not (L1_3 < L2_3) then
              break
            end
            L1_3 = Wait
            L2_3 = 100
            L1_3(L2_3)
          end
        end
      end
    end
    L0_3 = L3_1
    L1_3 = DoesEntityExist
    L2_3 = A0_2
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3 = L1_3(L2_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
    if not L0_3 then
      return
    end
    L0_3 = pcall
    L1_3 = TaskWanderStandard
    L2_3 = A0_2
    L3_3 = 10.0
    L4_3 = 10
    L0_3(L1_3, L2_3, L3_3, L4_3)
    L0_3 = Wait
    L1_3 = 25000
    L0_3(L1_3)
    L0_3 = L3_1
    L1_3 = DoesEntityExist
    L2_3 = A0_2
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3 = L1_3(L2_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
    if not L0_3 then
      return
    end
    L0_3 = 255
    L1_3 = 0
    L2_3 = -51
    for L3_3 = L0_3, L1_3, L2_3 do
      L4_3 = pcall
      L5_3 = SetEntityAlpha
      L6_3 = A0_2
      L7_3 = L3_3
      L8_3 = false
      L4_3(L5_3, L6_3, L7_3, L8_3)
      L4_3 = Wait
      L5_3 = 120
      L4_3(L5_3)
    end
    L0_3 = L29_1
    L1_3 = A0_2
    L0_3(L1_3)
  end
  L2_2(L3_2)
end
function L31_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  if A3_2 then
    L6_2 = L29_1
    L7_2 = A3_2
    L6_2(L7_2)
  end
  if A0_2 and 0 ~= A0_2 then
    L6_2 = L3_1
    L7_2 = DoesEntityExist
    L8_2 = A0_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L7_2(L8_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    if L6_2 then
      goto lbl_18
    end
  end
  do return end
  ::lbl_18::
  L6_2 = L13_1
  L7_2 = A4_2 or L7_2
  if not A4_2 then
    L7_2 = 15.0
  end
  L8_2 = A5_2 or L8_2
  if not A5_2 then
    L8_2 = 90.0
  end
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  L8_2 = false
  if L6_2 then
    L9_2 = L26_1
    L10_2 = A0_2
    L11_2 = 3000
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L9_2 = pcall
      L10_2 = SetEntityCoordsNoOffset
      L11_2 = A0_2
      L12_2 = L6_2.x
      L13_2 = L6_2.y
      L14_2 = L6_2.z
      L14_2 = L14_2 + 0.5
      L15_2 = false
      L16_2 = false
      L17_2 = false
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
      L9_2 = pcall
      L10_2 = SetEntityHeading
      L11_2 = A0_2
      L12_2 = L7_2 + 0.0
      L9_2(L10_2, L11_2, L12_2)
      L9_2 = pcall
      L10_2 = SetVehicleOnGroundProperly
      L11_2 = A0_2
      L9_2(L10_2, L11_2)
      L9_2 = pcall
      L10_2 = SetVehicleEngineOn
      L11_2 = A0_2
      L12_2 = false
      L13_2 = true
      L14_2 = true
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
      L8_2 = true
    end
  end
  L9_2 = GetEntityCoords
  L10_2 = A0_2
  L9_2 = L9_2(L10_2)
  L10_2 = SetNewWaypoint
  L11_2 = L9_2.x
  L11_2 = L11_2 + 0.0
  L12_2 = L9_2.y
  L12_2 = L12_2 + 0.0
  L10_2(L11_2, L12_2)
  L10_2 = L24_1
  L11_2 = A0_2
  L12_2 = A1_2
  L10_2(L11_2, L12_2)
  L10_2 = print
  L11_2 = "[unique_phone] garage valet: %s, the vehicle %s was %s (plate %s)"
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = tostring
  L14_2 = A2_2
  L13_2 = L13_2(L14_2)
  L14_2 = tostring
  L15_2 = A0_2
  L14_2 = L14_2(L15_2)
  if L8_2 then
    L15_2 = "moved to the nearest free road"
    if L15_2 then
      goto lbl_95
    end
  end
  L15_2 = "left where it was, marked on the GPS"
  ::lbl_95::
  L16_2 = tostring
  L17_2 = A1_2
  L16_2, L17_2 = L16_2(L17_2)
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L10_2 = L28_1
  L11_2 = "fallback"
  L12_2 = A1_2
  L13_2 = {}
  L13_2.why = A2_2
  L14_2 = L9_2.x
  L13_2.x = L14_2
  L14_2 = L9_2.y
  L13_2.y = L14_2
  L10_2(L11_2, L12_2, L13_2)
end
function L32_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2
  L5_2 = CreateThread
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3
    L0_3 = type
    L1_3 = A2_2
    L0_3 = L0_3(L1_3)
    if "table" == L0_3 then
      L0_3 = A2_2
      if L0_3 then
        goto lbl_11
      end
    end
    L0_3 = {}
    ::lbl_11::
    A2_2 = L0_3
    L0_3 = L26_1
    L1_3 = A0_2
    L2_3 = 4000
    L0_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L0_3 = L31_1
      L1_3 = A0_2
      L2_3 = A1_2
      L3_3 = "no control of the vehicle"
      L4_3 = nil
      L5_3 = A3_2
      L6_3 = A4_2
      return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
    end
    L0_3 = GetHashKey
    L1_3 = type
    L2_3 = A2_2.ped
    L1_3 = L1_3(L2_3)
    if "string" == L1_3 then
      L1_3 = A2_2.ped
      if "" ~= L1_3 then
        L1_3 = A2_2.ped
        if L1_3 then
          goto lbl_40
        end
      end
    end
    L1_3 = "s_m_y_valet_01"
    ::lbl_40::
    L0_3 = L0_3(L1_3)
    L1_3 = L3_1
    L2_3 = IsModelInCdimage
    L3_3 = L0_3
    L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L2_3(L3_3)
    L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
    if L1_3 then
      L1_3 = L3_1
      L2_3 = IsModelValid
      L3_3 = L0_3
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L2_3(L3_3)
      L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      if L1_3 then
        goto lbl_59
      end
    end
    L1_3 = GetHashKey
    L2_3 = "s_m_y_valet_01"
    L1_3 = L1_3(L2_3)
    L0_3 = L1_3
    ::lbl_59::
    L1_3 = RequestModel
    L2_3 = L0_3
    L1_3(L2_3)
    L1_3 = GetGameTimer
    L1_3 = L1_3()
    while true do
      L2_3 = L3_1
      L3_3 = HasModelLoaded
      L4_3 = L0_3
      L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L3_3(L4_3)
      L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      if L2_3 then
        break
      end
      L2_3 = GetGameTimer
      L2_3 = L2_3()
      L2_3 = L2_3 - L1_3
      L3_3 = 6000
      if not (L2_3 < L3_3) then
        break
      end
      L2_3 = Wait
      L3_3 = 50
      L2_3(L3_3)
    end
    L2_3 = L3_1
    L3_3 = HasModelLoaded
    L4_3 = L0_3
    L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L3_3(L4_3)
    L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
    if not L2_3 then
      L2_3 = L31_1
      L3_3 = A0_2
      L4_3 = A1_2
      L5_3 = "the valet model never loaded"
      L6_3 = nil
      L7_3 = A3_2
      L8_3 = A4_2
      return L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
    end
    L2_3 = CreatePedInsideVehicle
    L3_3 = A0_2
    L4_3 = 26
    L5_3 = L0_3
    L6_3 = -1
    L7_3 = true
    L8_3 = false
    L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
    L3_3 = SetModelAsNoLongerNeeded
    L4_3 = L0_3
    L3_3(L4_3)
    if L2_3 and 0 ~= L2_3 then
      L3_3 = L3_1
      L4_3 = DoesEntityExist
      L5_3 = L2_3
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L4_3(L5_3)
      L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      if L3_3 then
        goto lbl_129
      end
    end
    L3_3 = L31_1
    L4_3 = A0_2
    L5_3 = A1_2
    L6_3 = "the valet ped could not be created"
    L7_3 = nil
    L8_3 = A3_2
    L9_3 = A4_2
    do return L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3) end
    ::lbl_129::
    L3_3 = pcall
    L4_3 = SetEntityAsMissionEntity
    L5_3 = L2_3
    L6_3 = true
    L7_3 = true
    L3_3(L4_3, L5_3, L6_3, L7_3)
    L3_3 = pcall
    L4_3 = SetBlockingOfNonTemporaryEvents
    L5_3 = L2_3
    L6_3 = true
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetPedKeepTask
    L5_3 = L2_3
    L6_3 = true
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetPedCanBeDraggedOut
    L5_3 = L2_3
    L6_3 = false
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetPedCanRagdoll
    L5_3 = L2_3
    L6_3 = false
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetEntityInvincible
    L5_3 = L2_3
    L6_3 = true
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetDriverAbility
    L5_3 = L2_3
    L6_3 = 1.0
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetDriverAggressiveness
    L5_3 = L2_3
    L6_3 = 0.0
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetVehicleEngineOn
    L5_3 = A0_2
    L6_3 = true
    L7_3 = true
    L8_3 = false
    L3_3(L4_3, L5_3, L6_3, L7_3, L8_3)
    L3_3 = pcall
    L4_3 = SetVehicleDoorsLocked
    L5_3 = A0_2
    L6_3 = 1
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = pcall
    L4_3 = SetVehicleLights
    L5_3 = A0_2
    L6_3 = 0
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = L24_1
    L4_3 = A0_2
    L5_3 = A1_2
    L3_3(L4_3, L5_3)
    L3_3 = tonumber
    L4_3 = A2_2.speed
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = 17.0
    end
    L4_3 = math
    L4_3 = L4_3.tointeger
    L5_3 = tonumber
    L6_3 = A2_2.drivingStyle
    L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L5_3(L6_3)
    L4_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
    if not L4_3 then
      L4_3 = 786603
    end
    L5_3 = tonumber
    L6_3 = A2_2.timeout
    L5_3 = L5_3(L6_3)
    if not L5_3 then
      L5_3 = 150
    end
    L5_3 = L5_3 * 1000
    L6_3 = GetGameTimer
    L6_3 = L6_3()
    L7_3 = nil
    L8_3 = GetEntityCoords
    L9_3 = A0_2
    L8_3 = L8_3(L9_3)
    L9_3 = GetGameTimer
    L9_3 = L9_3()
    L10_3 = nil
    L11_3 = L28_1
    L12_3 = "driving"
    L13_3 = A1_2
    L11_3(L12_3, L13_3)
    while true do
      L11_3 = GetGameTimer
      L11_3 = L11_3()
      L11_3 = L11_3 - L6_3
      if L5_3 < L11_3 then
        L10_3 = "timeout"
        break
      end
      L11_3 = L3_1
      L12_3 = DoesEntityExist
      L13_3 = A0_2
      L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L12_3(L13_3)
      L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      if not L11_3 then
        L11_3 = L29_1
        L12_3 = L2_3
        L11_3(L12_3)
        return
      end
      L11_3 = L3_1
      L12_3 = DoesEntityExist
      L13_3 = L2_3
      L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L12_3(L13_3)
      L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      if L11_3 then
        L11_3 = L3_1
        L12_3 = IsEntityDead
        L13_3 = L2_3
        L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L12_3(L13_3)
        L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
        if not L11_3 then
          goto lbl_262
        end
      end
      L10_3 = "the valet is gone"
      do break end
      ::lbl_262::
      L11_3 = GetVehiclePedIsIn
      L12_3 = L2_3
      L13_3 = false
      L11_3 = L11_3(L12_3, L13_3)
      L12_3 = A0_2
      if L11_3 ~= L12_3 then
        L10_3 = "the valet left the vehicle"
        break
      end
      L11_3 = GetEntityCoords
      L12_3 = PlayerPedId
      L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3 = L12_3()
      L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      L12_3 = GetEntityCoords
      L13_3 = A0_2
      L12_3 = L12_3(L13_3)
      L13_3 = L12_3 - L11_3
      L13_3 = #L13_3
      if L13_3 <= 9.0 then
        L14_3 = GetEntitySpeed
        L15_3 = A0_2
        L14_3 = L14_3(L15_3)
        if L14_3 < 6.0 then
          break
        end
      end
      if L13_3 <= 14.0 then
        L14_3 = pcall
        L15_3 = TaskVehicleTempAction
        L16_3 = L2_3
        L17_3 = A0_2
        L18_3 = 1
        L19_3 = 1200
        L14_3(L15_3, L16_3, L17_3, L18_3, L19_3)
        L7_3 = L11_3
      else
        if L7_3 then
          L14_3 = L11_3 - L7_3
          L14_3 = #L14_3
          if not (L14_3 > 12.0) then
            goto lbl_319
          end
        end
        L7_3 = L11_3
        L14_3 = pcall
        L15_3 = TaskVehicleDriveToCoordLongrange
        L16_3 = L2_3
        L17_3 = A0_2
        L18_3 = L11_3.x
        L19_3 = L11_3.y
        L20_3 = L11_3.z
        L21_3 = L3_3 + 0.0
        L22_3 = L4_3
        L23_3 = 7.0
        L14_3(L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3)
      end
      ::lbl_319::
      L14_3 = L12_3 - L8_3
      L14_3 = #L14_3
      if L14_3 > 2.0 then
        L8_3 = L12_3
        L14_3 = GetGameTimer
        L14_3 = L14_3()
        L9_3 = L14_3
      end
      L14_3 = GetGameTimer
      L14_3 = L14_3()
      L14_3 = L14_3 - L9_3
      L15_3 = 25000
      if L14_3 > L15_3 and L13_3 > 30.0 then
        L10_3 = "stuck"
        break
      end
      L14_3 = Wait
      L15_3 = 400
      L14_3(L15_3)
    end
    if L10_3 then
      L11_3 = L31_1
      L12_3 = A0_2
      L13_3 = A1_2
      L14_3 = L10_3
      L15_3 = L2_3
      L16_3 = A3_2
      L17_3 = A4_2
      return L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3)
    end
    L11_3 = pcall
    L12_3 = TaskVehicleTempAction
    L13_3 = L2_3
    L14_3 = A0_2
    L15_3 = 1
    L16_3 = 1500
    L11_3(L12_3, L13_3, L14_3, L15_3, L16_3)
    L11_3 = Wait
    L12_3 = 900
    L11_3(L12_3)
    L11_3 = pcall
    L12_3 = SetVehicleHandbrake
    L13_3 = A0_2
    L14_3 = true
    L11_3(L12_3, L13_3, L14_3)
    L11_3 = pcall
    L12_3 = TaskLeaveVehicle
    L13_3 = L2_3
    L14_3 = A0_2
    L15_3 = 0
    L11_3(L12_3, L13_3, L14_3, L15_3)
    L11_3 = GetGameTimer
    L11_3 = L11_3()
    while true do
      L12_3 = GetVehiclePedIsIn
      L13_3 = L2_3
      L14_3 = false
      L12_3 = L12_3(L13_3, L14_3)
      L13_3 = A0_2
      if L12_3 ~= L13_3 then
        break
      end
      L12_3 = GetGameTimer
      L12_3 = L12_3()
      L12_3 = L12_3 - L11_3
      L13_3 = 6000
      if not (L12_3 < L13_3) then
        break
      end
      L12_3 = Wait
      L13_3 = 100
      L12_3(L13_3)
    end
    L12_3 = pcall
    L13_3 = SetVehicleHandbrake
    L14_3 = A0_2
    L15_3 = false
    L12_3(L13_3, L14_3, L15_3)
    L12_3 = L26_1
    L13_3 = A0_2
    L14_3 = 1500
    L12_3 = L12_3(L13_3, L14_3)
    if L12_3 then
      L12_3 = pcall
      L13_3 = SetVehicleEngineOn
      L14_3 = A0_2
      L15_3 = false
      L16_3 = true
      L17_3 = true
      L12_3(L13_3, L14_3, L15_3, L16_3, L17_3)
      L12_3 = pcall
      L13_3 = SetVehicleDoorsLocked
      L14_3 = A0_2
      L15_3 = 1
      L12_3(L13_3, L14_3, L15_3)
    end
    L12_3 = GetEntityCoords
    L13_3 = A0_2
    L12_3 = L12_3(L13_3)
    L13_3 = SetNewWaypoint
    L14_3 = L12_3.x
    L14_3 = L14_3 + 0.0
    L15_3 = L12_3.y
    L15_3 = L15_3 + 0.0
    L13_3(L14_3, L15_3)
    L13_3 = L28_1
    L14_3 = "arrived"
    L15_3 = A1_2
    L16_3 = {}
    L17_3 = L12_3.x
    L16_3.x = L17_3
    L17_3 = L12_3.y
    L16_3.y = L17_3
    L13_3(L14_3, L15_3, L16_3)
    L13_3 = L30_1
    L14_3 = L2_3
    L15_3 = A0_2
    L13_3(L14_3, L15_3)
  end
  L5_2(L6_2)
end
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = tostring
  L3_2 = A0_2.plate
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = 16
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if "" == L2_2 then
    L3_2 = A1_2
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "notfound"
    return L3_2(L4_2)
  end
  L3_2 = L8_1
  L4_2 = "garage.deliverPrepare"
  L5_2 = {}
  L5_2.plate = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L3_2.ok
    if L4_2 then
      goto lbl_40
    end
  end
  L4_2 = A1_2
  L5_2 = L27_1
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L5_2(L6_2)
  do return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2) end
  ::lbl_40::
  L4_2 = L6_1
  L5_2 = L3_2.model
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L3_1
    L6_2 = IsModelInCdimage
    L7_2 = L4_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L6_2(L7_2)
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    if L5_2 then
      L5_2 = L3_1
      L6_2 = IsModelAVehicle
      L7_2 = L4_2
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L6_2(L7_2)
      L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      if L5_2 then
        goto lbl_66
      end
    end
  end
  L5_2 = A1_2
  L6_2 = {}
  L6_2.ok = false
  L6_2.error = "model"
  do return L5_2(L6_2) end
  ::lbl_66::
  L5_2 = L10_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if "automobile" ~= L5_2 and "bike" ~= L5_2 then
    L6_2 = A1_2
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "type"
    return L6_2(L7_2)
  end
  L6_2 = L3_2.mode
  L6_2 = "valet" == L6_2
  L7_2 = nil
  L8_2 = nil
  if L6_2 then
    L9_2 = L13_1
    L10_2 = L3_2.valet
    L10_2 = L10_2.minDistance
    L11_2 = L3_2.valet
    L11_2 = L11_2.maxDistance
    L9_2, L10_2 = L9_2(L10_2, L11_2)
    L8_2 = L10_2
    L7_2 = L9_2
    if not L7_2 then
      L6_2 = false
    end
  end
  if not L7_2 then
    L9_2 = L13_1
    L10_2 = L3_2.minDistance
    L11_2 = L3_2.maxDistance
    L9_2, L10_2 = L9_2(L10_2, L11_2)
    L8_2 = L10_2
    L7_2 = L9_2
  end
  if not L7_2 then
    L9_2 = A1_2
    L10_2 = {}
    L10_2.ok = false
    L10_2.error = "nospot"
    return L9_2(L10_2)
  end
  L9_2 = L11_1
  L10_2 = L4_2
  L9_2 = L9_2(L10_2)
  L10_2 = L8_1
  L11_2 = "garage.deliver"
  L12_2 = {}
  L13_2 = L3_2.token
  L12_2.token = L13_2
  L13_2 = L7_2.x
  L12_2.x = L13_2
  L13_2 = L7_2.y
  L12_2.y = L13_2
  L13_2 = L7_2.z
  L13_2 = L13_2 + 0.5
  L12_2.z = L13_2
  L12_2.h = L8_2
  L12_2.vtype = L5_2
  L12_2.modelName = L9_2
  L12_2.valet = L6_2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = type
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  if "table" == L11_2 then
    L11_2 = L10_2.ok
    if L11_2 then
      goto lbl_157
    end
  end
  L11_2 = A1_2
  L12_2 = L27_1
  L13_2 = L10_2
  L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2)
  do return L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2) end
  ::lbl_157::
  if L6_2 then
    L11_2 = L10_2.valet
    L6_2 = true == L11_2
  end
  L11_2 = tonumber
  L12_2 = L10_2.x
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = L7_2.x
  end
  L12_2 = tonumber
  L13_2 = L10_2.y
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = L7_2.y
  end
  if not L6_2 then
    L13_2 = SetNewWaypoint
    L14_2 = L11_2 + 0.0
    L15_2 = L12_2 + 0.0
    L13_2(L14_2, L15_2)
  end
  L13_2 = GetEntityCoords
  L14_2 = PlayerPedId
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L14_2()
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  L14_2 = A1_2
  L15_2 = {}
  L15_2.ok = true
  L15_2.x = L11_2
  L15_2.y = L12_2
  L16_2 = math
  L16_2 = L16_2.floor
  L17_2 = math
  L17_2 = L17_2.sqrt
  L18_2 = L13_2.x
  L18_2 = L11_2 - L18_2
  L18_2 = L18_2 ^ 2
  L19_2 = L13_2.y
  L19_2 = L12_2 - L19_2
  L19_2 = L19_2 ^ 2
  L18_2 = L18_2 + L19_2
  L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
  L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
  L15_2.dist = L16_2
  L15_2.valet = L6_2
  L14_2(L15_2)
  L14_2 = L25_1
  L15_2 = L10_2.netId
  L16_2 = 8000
  L14_2 = L14_2(L15_2, L16_2)
  if L14_2 then
    L15_2 = L26_1
    L16_2 = L14_2
    L17_2 = 2000
    L15_2 = L15_2(L16_2, L17_2)
    if L15_2 then
      L15_2 = pcall
      L16_2 = L21_1
      L17_2 = L14_2
      L18_2 = L10_2
      L15_2(L16_2, L17_2, L18_2)
    end
    if L6_2 then
      L15_2 = L32_1
      L16_2 = L14_2
      L17_2 = L10_2.plate
      if not L17_2 then
        L17_2 = L2_2
      end
      L18_2 = L3_2.valet
      L19_2 = L3_2.minDistance
      L20_2 = L3_2.maxDistance
      L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
    else
      L15_2 = L24_1
      L16_2 = L14_2
      L17_2 = L10_2.plate
      L15_2(L16_2, L17_2)
    end
  elseif L6_2 then
    L15_2 = SetNewWaypoint
    L16_2 = L11_2 + 0.0
    L17_2 = L12_2 + 0.0
    L15_2(L16_2, L17_2)
    L15_2 = L28_1
    L16_2 = "fallback"
    L17_2 = L10_2.plate
    if not L17_2 then
      L17_2 = L2_2
    end
    L18_2 = {}
    L18_2.why = "the vehicle never reached this client"
    L18_2.x = L11_2
    L18_2.y = L12_2
    L15_2(L16_2, L17_2, L18_2)
  end
  L15_2 = L23_1
  L16_2 = L14_2
  L17_2 = L10_2.plate
  if not L17_2 then
    L17_2 = L2_2
  end
  L18_2 = L9_2
  L15_2(L16_2, L17_2, L18_2)
end
L34_1 = RegisterNUICallback
L35_1 = "garageDeliver"
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = false
  function L3_2(A0_3)
    local L1_3, L2_3
    L1_3 = L2_2
    if L1_3 then
      return
    end
    L1_3 = true
    L2_2 = L1_3
    L1_3 = A1_2
    L2_3 = A0_3
    L1_3(L2_3)
  end
  L4_2 = L1_1
  if L4_2 then
    L4_2 = L3_2
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "busy"
    L4_2(L5_2)
    return
  end
  L4_2 = true
  L1_1 = L4_2
  L4_2 = CreateThread
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = pcall
    L1_3 = L33_1
    L2_3 = type
    L3_3 = A0_2
    L2_3 = L2_3(L3_3)
    if "table" == L2_3 then
      L2_3 = A0_2
      if L2_3 then
        goto lbl_13
      end
    end
    L2_3 = {}
    ::lbl_13::
    L3_3 = L3_2
    L0_3, L1_3 = L0_3(L1_3, L2_3, L3_3)
    L2_3 = false
    L1_1 = L2_3
    if not L0_3 then
      L2_3 = print
      L3_3 = "[unique_phone] garage delivery (client): %s"
      L4_3 = L3_3
      L3_3 = L3_3.format
      L5_3 = tostring
      L6_3 = L1_3
      L5_3, L6_3 = L5_3(L6_3)
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
      L2_3(L3_3, L4_3, L5_3, L6_3)
    end
    L2_3 = L3_2
    L3_3 = {}
    L3_3.ok = false
    L3_3.error = "client"
    L2_3(L3_3)
  end
  L4_2(L5_2)
end
L34_1(L35_1, L36_1)
