local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1
L0_1 = PhoneIntegrations
L1_1 = L0_1.SQL_NULL
if not L1_1 then
  L1_1 = setmetatable
  L2_1 = {}
  L3_1 = {}
  function L4_1()
    local L0_2, L1_2
    L0_2 = "NULL"
    return L0_2
  end
  L3_1.__tostring = L4_1
  L1_1 = L1_1(L2_1, L3_1)
end
L0_1.SQL_NULL = L1_1
function L1_1()
  local L0_2, L1_2
  L0_2 = FW
  L0_2 = L0_2.name
  if "esx" == L0_2 then
    L0_2 = "owned_vehicles"
    L1_2 = "owner"
    return L0_2, L1_2
  end
  L0_2 = "player_vehicles"
  L1_2 = "citizenid"
  return L0_2, L1_2
end
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = A0_2
    L2_3 = A1_2
    return L0_3(L1_3, L2_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      return L3_2
    end
  end
  L4_2 = nil
  L5_2 = L3_2
  return L4_2, L5_2
end
function L3_1(A0_2)
  local L1_2, L2_2
  if nil == A0_2 or false == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if "" == A0_2 or "null" == A0_2 or "NULL" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  return A0_2
end
function L4_1(A0_2)
  local L1_2, L2_2
  L1_2 = true == A0_2
  return L1_2
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L0_1.decode
  L2_2 = FW
  L2_2 = L2_2.name
  if "esx" == L2_2 then
    L2_2 = A0_2.vehicle
    if L2_2 then
      goto lbl_10
    end
  end
  L2_2 = A0_2.mods
  ::lbl_10::
  L1_2 = L1_2(L2_2)
  L2_2 = nil
  L3_2 = FW
  L3_2 = L3_2.name
  if "esx" == L3_2 then
    L3_2 = A0_2.model
    L2_2 = L3_2 or L2_2
    if not L3_2 then
      L3_2 = A0_2.vehicle_name
      L2_2 = L3_2 or L2_2
      if not L3_2 then
        L3_2 = A0_2.vehiclename
        L2_2 = L3_2 or L2_2
        if not L3_2 then
          L3_2 = L1_2.modelName
          L2_2 = L3_2 or L2_2
          if not L3_2 then
            L3_2 = L1_2.name
            L2_2 = L3_2 or L2_2
            if not L3_2 then
              L2_2 = L1_2.model
            end
          end
        end
      end
    end
  else
    L3_2 = A0_2.vehicle
    L2_2 = L3_2 or L2_2
    if not L3_2 then
      L3_2 = L1_2.modelName
      L2_2 = L3_2 or L2_2
      if not L3_2 then
        L2_2 = L1_2.model
      end
    end
  end
  L3_2 = A0_2.vehiclename
  if not L3_2 then
    L3_2 = A0_2.vehicle_name
    if not L3_2 then
      L3_2 = A0_2.custom_label
      if not L3_2 then
        L3_2 = A0_2.label
      end
    end
  end
  L4_2 = A0_2.name
  if nil ~= L4_2 then
    L4_2 = A0_2.name
    if "Unknown" ~= L4_2 and nil == L3_2 then
      L4_2 = FW
      L4_2 = L4_2.name
      if "esx" == L4_2 then
        L3_2 = A0_2.name
      end
    end
  end
  L4_2 = {}
  L5_2 = A0_2.plate
  L4_2.plate = L5_2
  if nil ~= L2_2 then
    L5_2 = tostring
    L6_2 = L2_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_75
    end
  end
  L5_2 = nil
  ::lbl_75::
  L4_2.model = L5_2
  L5_2 = tonumber
  L6_2 = A0_2.hash
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = tonumber
    L6_2 = L1_2.model
    L5_2 = L5_2(L6_2)
  end
  L4_2.hash = L5_2
  L5_2 = type
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L5_2 = L3_2 or L5_2
  if "string" ~= L5_2 or "" == L3_2 or not L3_2 then
    L5_2 = nil
  end
  L4_2.label = L5_2
  L5_2 = L0_1.num
  L6_2 = A0_2.fuel
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L0_1.num
    L6_2 = L1_2.fuelLevel
    L5_2 = L5_2(L6_2)
  end
  L4_2.fuel = L5_2
  L5_2 = L0_1.num
  L6_2 = A0_2.engine
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L0_1.num
    L6_2 = L1_2.engineHealth
    L5_2 = L5_2(L6_2)
  end
  L4_2.engine = L5_2
  L5_2 = L0_1.num
  L6_2 = A0_2.body
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L0_1.num
    L6_2 = L1_2.bodyHealth
    L5_2 = L5_2(L6_2)
  end
  L4_2.body = L5_2
  L5_2 = L0_1.num
  L6_2 = A0_2.drivingdistance
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L0_1.num
    L6_2 = A0_2.mileage
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = L0_1.num
      L6_2 = L1_2.mileage
      L5_2 = L5_2(L6_2)
      if not L5_2 then
        L5_2 = L0_1.num
        L6_2 = L1_2.odometer
        L5_2 = L5_2(L6_2)
      end
    end
  end
  L4_2.mileage = L5_2
  return L4_2
end
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L1_1
  L2_2, L3_2 = L2_2()
  L4_2 = L2_1
  L5_2 = "SELECT * FROM %s WHERE %s = ?%s"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = A1_2 or L9_2
  if not A1_2 then
    L9_2 = ""
  end
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L6_2 = {}
  L7_2 = A0_2
  L6_2[1] = L7_2
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if not L4_2 and A1_2 then
    L6_2 = L2_1
    L7_2 = "SELECT * FROM %s WHERE %s = ?"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = L2_2
    L10_2 = L3_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = {}
    L9_2 = A0_2
    L8_2[1] = L9_2
    L6_2, L7_2 = L6_2(L7_2, L8_2)
    L5_2 = L7_2
    L4_2 = L6_2
  end
  if not L4_2 then
    L6_2 = error
    L7_2 = "%s query failed: %s"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = L2_2
    L10_2 = tostring
    L11_2 = L5_2
    L10_2, L11_2 = L10_2(L11_2)
    L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  end
  return L4_2
end
function L7_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L0_1.callExport
  L3_2 = A0_2
  L4_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = ...
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_24
    end
  end
  L4_2 = error
  L5_2 = "%s:%s failed: %s"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = tostring
  L10_2 = L3_2
  L9_2, L10_2 = L9_2(L10_2)
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  ::lbl_24::
  return L3_2
end
function L8_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L0_1.callExport
  L3_2 = A0_2
  L4_2 = A1_2
  L5_2, L6_2, L7_2, L8_2 = ...
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L2_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = L3_2
  L7_2 = L4_2
  L8_2 = L5_2
  return L6_2, L7_2, L8_2
end
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = {}
  L1_2 = pcall
  L2_2 = GetAllVehicles
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_14
    end
  end
  do return L0_2 end
  ::lbl_14::
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = pcall
    L10_2 = GetVehicleNumberPlateText
    L11_2 = L8_2
    L9_2, L10_2 = L9_2(L10_2, L11_2)
    if L9_2 and L10_2 then
      L11_2 = L0_1.plateKey
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      L0_2[L11_2] = L8_2
    end
  end
  return L0_2
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = GetEntityCoords
    L1_3 = GetPlayerPed
    L2_3 = A0_2
    L1_3, L2_3 = L1_3(L2_3)
    return L0_3(L1_3, L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 and L2_2 then
    L3_2 = L0_1.xyz
    L4_2 = L2_2
    return L3_2(L4_2)
  end
  L3_2 = nil
  return L3_2
end
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = nil
  L3_2 = nil
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.coords
    if L10_2 then
      if not A1_2 then
        return L9_2
      end
      L10_2 = L9_2.coords
      L10_2 = L10_2.x
      L11_2 = A1_2.x
      L10_2 = L10_2 - L11_2
      L11_2 = L9_2.coords
      L11_2 = L11_2.y
      L12_2 = A1_2.y
      L11_2 = L11_2 - L12_2
      L12_2 = L10_2 * L10_2
      L13_2 = L11_2 * L11_2
      L12_2 = L12_2 + L13_2
      if not L3_2 or L3_2 > L12_2 then
        L13_2 = L9_2
        L3_2 = L12_2
        L2_2 = L13_2
      end
    end
  end
  return L2_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = 0
  L2_2 = 0
  L3_2 = 0
  L4_2 = 0
  L5_2 = ipairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L0_1.xyz
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = L11_2.x
      L12_2 = L1_2 + L12_2
      L13_2 = L11_2.y
      L13_2 = L2_2 + L13_2
      L14_2 = L11_2.z
      L14_2 = L3_2 + L14_2
      L4_2 = L4_2 + 1
      L3_2 = L14_2
      L2_2 = L13_2
      L1_2 = L12_2
    end
  end
  if 0 == L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = {}
  L6_2 = L1_2 / L4_2
  L5_2.x = L6_2
  L6_2 = L2_2 / L4_2
  L5_2.y = L6_2
  L6_2 = L3_2 / L4_2
  L5_2.z = L6_2
  return L5_2
end
function L13_1(...)
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = 1
  L1_2 = select
  L2_2 = "#"
  L3_2, L4_2, L5_2, L6_2, L7_2 = ...
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = L0_1.xyz
    L5_2 = select
    L6_2 = L3_2
    L7_2 = ...
    L5_2 = L5_2(L6_2, L7_2)
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L5_2 = L4_2.x
      if 0 == L5_2 then
        L5_2 = L4_2.y
        if 0 == L5_2 then
          goto lbl_24
        end
      end
      return L4_2
    end
    ::lbl_24::
  end
  L0_2 = nil
  return L0_2
end
function L14_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1.builtin
  if L4_2 then
    L4_2 = L0_1.builtin
    L4_2 = L4_2.garage
  end
  if L4_2 then
    L5_2 = L0_1.isCallable
    L6_2 = L4_2.track
    L5_2 = L5_2(L6_2)
    if L5_2 then
      L5_2 = L4_2.track
      L6_2 = A0_2
      L7_2 = A1_2
      L8_2 = A2_2
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      if L5_2 then
        return L5_2
      end
    end
  end
  if A3_2 then
    L5_2 = pcall
    L6_2 = A3_2
    L5_2, L6_2 = L5_2(L6_2)
    if L5_2 then
      L7_2 = L0_1.xyz
      L8_2 = L6_2
      return L7_2(L8_2)
    end
  end
  L5_2 = nil
  return L5_2
end
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = {}
  L1_2 = L8_1
  L2_2 = "apex_garage"
  L3_2 = "GetConfiguredGarages"
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = pairs
    L3_2 = L1_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L8_2 = tostring
        L9_2 = L6_2
        L8_2 = L8_2(L9_2)
        L9_2 = {}
        L10_2 = L7_2.label
        L9_2.label = L10_2
        L10_2 = L13_1
        L11_2 = L7_2.access
        L12_2 = L7_2.store
        L13_2 = type
        L14_2 = L7_2.spawns
        L13_2 = L13_2(L14_2)
        if "table" == L13_2 then
          L13_2 = L7_2.spawns
          L13_2 = L13_2[1]
          if L13_2 then
            goto lbl_41
          end
        end
        L13_2 = nil
        ::lbl_41::
        L10_2 = L10_2(L11_2, L12_2, L13_2)
        L9_2.coords = L10_2
        L0_2[L8_2] = L9_2
      end
    end
  end
  L2_2 = ipairs
  L3_2 = L2_1
  L4_2 = "SELECT gid, label, zone, spawns FROM `apex_garage_garages`"
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.gid
    if nil ~= L8_2 then
      L8_2 = tostring
      L9_2 = L7_2.gid
      L8_2 = L8_2(L9_2)
      L8_2 = L0_2[L8_2]
      if not L8_2 then
        L8_2 = L0_1.decode
        L9_2 = L7_2.spawns
        L8_2 = L8_2(L9_2)
        L9_2 = tostring
        L10_2 = L7_2.gid
        L9_2 = L9_2(L10_2)
        L10_2 = {}
        L11_2 = L7_2.label
        L10_2.label = L11_2
        L11_2 = L13_1
        L12_2 = L0_1.decode
        L13_2 = L7_2.zone
        L12_2 = L12_2(L13_2)
        L13_2 = L8_2[1]
        L11_2 = L11_2(L12_2, L13_2)
        L10_2.coords = L11_2
        L0_2[L9_2] = L10_2
      end
    end
  end
  L2_2 = ipairs
  L3_2 = L2_1
  L4_2 = "SELECT id, label, x, y, z FROM `apex_garage_private`"
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = "priv_"
    L9_2 = tostring
    L10_2 = L7_2.id
    L9_2 = L9_2(L10_2)
    L8_2 = L8_2 .. L9_2
    L9_2 = {}
    L10_2 = L7_2.label
    L9_2.label = L10_2
    L10_2 = L13_1
    L11_2 = L7_2
    L10_2 = L10_2(L11_2)
    L9_2.coords = L10_2
    L0_2[L8_2] = L9_2
  end
  return L0_2
end
L16_1 = L0_1.define
L17_1 = "garage"
L18_1 = "apex_garage"
L19_1 = {}
L19_1.label = "apex_garage"
L20_1 = {}
L21_1 = "apex_garage"
L20_1[1] = L21_1
L19_1.resources = L20_1
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = {}
  L3_2 = L8_1
  L4_2 = "apex_garage"
  L5_2 = "GetOpenImpounds"
  L6_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 then
    L4_2 = L2_1
    L5_2 = "SELECT plate, garage_id FROM `apex_garage_impounds` WHERE owner = ? AND released_at IS NULL"
    L6_2 = {}
    L7_2 = A1_2
    L6_2[1] = L7_2
    L4_2 = L4_2(L5_2, L6_2)
    L3_2 = L4_2 or L3_2
    if not L4_2 then
      L4_2 = {}
      L3_2 = L4_2
    end
  end
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L9_2.plate
      if L10_2 then
        L10_2 = L0_1.plateKey
        L11_2 = L9_2.plate
        L10_2 = L10_2(L11_2)
        L2_2[L10_2] = L9_2
      end
    end
  end
  L4_2 = L15_1
  L4_2 = L4_2()
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L6_1
  L8_2 = A1_2
  L9_2 = " AND job_vehicle = 0 AND gang_vehicle = 0"
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L7_2(L8_2, L9_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L5_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    L13_2 = L0_1.plateKey
    L14_2 = L11_2.plate
    L13_2 = L13_2(L14_2)
    L13_2 = L2_2[L13_2]
    L14_2 = nil
    if L13_2 then
      L15_2 = "impound"
      L14_2 = L13_2.garage_id
      L12_2.state = L15_2
    else
      L15_2 = L4_1
      L16_2 = L11_2.in_garage
      L15_2 = L15_2(L16_2)
      if not L15_2 then
        L15_2 = FW
        L15_2 = L15_2.name
        L15_2 = L4_1
        L16_2 = L11_2.stored
        L15_2 = "esx" == L15_2 and L15_2
      end
      if L15_2 then
        L16_2 = "garage"
        if L16_2 then
          goto lbl_90
        end
      end
      L16_2 = "out"
      ::lbl_90::
      L14_2 = L11_2.garage_id
      L12_2.state = L16_2
    end
    L15_2 = L3_1
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    L14_2 = L15_2
    if L14_2 then
      L15_2 = L4_2[L14_2]
      if L15_2 then
        goto lbl_102
      end
    end
    L15_2 = nil
    ::lbl_102::
    L16_2 = L14_2
    if L15_2 then
      L17_2 = L15_2.label
      if L17_2 then
        goto lbl_109
      end
    end
    L17_2 = nil
    ::lbl_109::
    if L15_2 then
      L18_2 = L15_2.coords
      if L18_2 then
        goto lbl_115
      end
    end
    L18_2 = nil
    ::lbl_115::
    L12_2.coords = L18_2
    L12_2.garageLabel = L17_2
    L12_2.garage = L16_2
    L16_2 = L3_1
    L17_2 = L11_2.nickname
    L16_2 = L16_2(L17_2)
    L12_2.nickname = L16_2
    L16_2 = #L5_2
    L16_2 = L16_2 + 1
    L5_2[L16_2] = L12_2
  end
  return L5_2
end
L19_1.list = L20_1
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L19_1.track = L20_1
function L20_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.in_garage = 0
  return L0_2
end
L19_1.deliverOut = L20_1
function L20_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2
  L5_2 = L0_1.callExport
  L6_2 = "apex_garage"
  L7_2 = "RegisterVehicleOutside"
  L8_2 = A2_2
  L9_2 = A4_2
  L5_2(L6_2, L7_2, L8_2, L9_2)
end
L19_1.deliverAfter = L20_1
L16_1(L17_1, L18_1, L19_1)
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = ipairs
  L2_2 = {}
  L3_2 = "Config.GarageLocations"
  L4_2 = "Config.ImpoundLocations"
  L5_2 = "Config.JobGarageLocations"
  L6_2 = "Config.GangGarageLocations"
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L0_1.readResourceTable
    L8_2 = "jg-advancedgarages"
    L9_2 = "config/config.lua"
    L10_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2[A0_2]
      if L8_2 then
        goto lbl_29
      end
    end
    L8_2 = nil
    ::lbl_29::
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L0_1.xyz
      L10_2 = L8_2.coords
      L9_2, L10_2 = L9_2(L10_2)
      return L9_2, L10_2
    end
  end
  L1_2 = nil
  return L1_2
end
L17_1 = L0_1.define
L18_1 = "garage"
L19_1 = "jg-advancedgarages"
L20_1 = {}
L20_1.label = "jg-advancedgarages"
L21_1 = {}
L22_1 = "jg-advancedgarages"
L21_1[1] = L22_1
L20_1.resources = L21_1
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = {}
  L3_2 = L8_1
  L4_2 = "jg-advancedgarages"
  L5_2 = "getAllGarages"
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = pairs
    L5_2 = L3_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = L9_2.name
        if not L10_2 then
          L10_2 = type
          L11_2 = L8_2
          L10_2 = L10_2(L11_2)
          L10_2 = L8_2 or L10_2
          if "string" ~= L10_2 or not L8_2 then
            L10_2 = nil
          end
        end
        if nil ~= L10_2 then
          L11_2 = tostring
          L12_2 = L10_2
          L11_2 = L11_2(L12_2)
          L12_2 = L13_1
          L13_2 = L9_2.takeVehicle
          L14_2 = L9_2.putVehicle
          L15_2 = L9_2.spawnPoint
          L16_2 = L9_2.coords
          L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
          L2_2[L11_2] = L12_2
        end
      end
    end
  end
  L4_2 = {}
  L5_2 = nil
  L6_2 = ipairs
  L7_2 = L6_1
  L8_2 = A1_2
  L9_2 = " AND job_vehicle = 0 AND gang_vehicle = 0"
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L7_2(L8_2, L9_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L5_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    L13_2 = L4_1
    L14_2 = L11_2.impound
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L13_2 = "impound"
      if L13_2 then
        goto lbl_77
      end
    end
    L13_2 = L4_1
    L14_2 = L11_2.in_garage
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L13_2 = "garage"
      if L13_2 then
        goto lbl_77
      end
    end
    L13_2 = "out"
    ::lbl_77::
    L12_2.state = L13_2
    L13_2 = L11_2.garage_id
    L12_2.garage = L13_2
    L13_2 = L11_2.nickname
    L12_2.nickname = L13_2
    L13_2 = L11_2.garage_id
    if nil ~= L13_2 then
      L13_2 = tostring
      L14_2 = L11_2.garage_id
      L13_2 = L13_2(L14_2)
      L13_2 = L2_2[L13_2]
      if L13_2 then
        goto lbl_94
      end
    end
    L13_2 = L16_1
    L14_2 = L11_2.garage_id
    L13_2 = L13_2(L14_2)
    ::lbl_94::
    L12_2.coords = L13_2
    L13_2 = L12_2.coords
    if not L13_2 then
      L13_2 = L11_2.garage_id
      if L13_2 then
        if not L5_2 then
          L13_2 = {}
          L5_2 = L13_2
        end
        L13_2 = L11_2.garage_id
        L13_2 = L5_2[L13_2]
        if nil == L13_2 then
          L13_2 = L2_1
          L14_2 = "SELECT x, y, z FROM player_priv_garages WHERE name = ? LIMIT 1"
          L15_2 = {}
          L16_2 = L11_2.garage_id
          L15_2[1] = L16_2
          L13_2 = L13_2(L14_2, L15_2)
          L14_2 = L11_2.garage_id
          if L13_2 then
            L15_2 = L13_2[1]
            if L15_2 then
              L15_2 = L0_1.xyz
              L16_2 = L13_2[1]
              L15_2 = L15_2(L16_2)
              if L15_2 then
                goto lbl_129
              end
            end
          end
          L15_2 = false
          ::lbl_129::
          L5_2[L14_2] = L15_2
        end
        L13_2 = L11_2.garage_id
        L13_2 = L5_2[L13_2]
        if not L13_2 then
          L13_2 = nil
        end
        L12_2.coords = L13_2
      end
    end
    L13_2 = #L4_2
    L13_2 = L13_2 + 1
    L4_2[L13_2] = L12_2
  end
  return L4_2
end
L20_1.list = L21_1
function L21_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L20_1.track = L21_1
function L21_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.in_garage = 0
  return L0_2
end
L20_1.deliverOut = L21_1
L17_1(L18_1, L19_1, L20_1)
function L17_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L0_2 = L8_1
  L1_2 = "cd_garage"
  L2_2 = "GetGarageLocations"
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = {}
  L2_2 = type
  L3_2 = L0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return L1_2
  end
  L2_2 = pairs
  L3_2 = L0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2.garage_id
      if not L8_2 then
        L8_2 = L7_2.Garage_ID
        if not L8_2 then
          L8_2 = L7_2.id
          if not L8_2 then
            L8_2 = L7_2.garageId
            if not L8_2 then
              L8_2 = L6_2
            end
          end
        end
      end
      L9_2 = type
      L10_2 = L7_2.coords
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = L7_2.coords
        L9_2 = L9_2.open
        if L9_2 then
          goto lbl_49
        end
        L9_2 = L7_2.coords
        L9_2 = L9_2.spawn
        if L9_2 then
          goto lbl_49
        end
      end
      L9_2 = nil
      ::lbl_49::
      L10_2 = tostring
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      L11_2 = {}
      L12_2 = L7_2.garage_label
      if not L12_2 then
        L12_2 = L7_2.label
      end
      L11_2.label = L12_2
      L12_2 = L13_1
      L13_2 = L9_2
      L14_2 = L7_2.coords
      L15_2 = {}
      L16_2 = L7_2.x_1
      if not L16_2 then
        L16_2 = L7_2.x
      end
      L15_2.x = L16_2
      L16_2 = L7_2.y_1
      if not L16_2 then
        L16_2 = L7_2.y
      end
      L15_2.y = L16_2
      L16_2 = L7_2.z_1
      if not L16_2 then
        L16_2 = L7_2.z
      end
      L15_2.z = L16_2
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      L11_2.coords = L12_2
      L1_2[L10_2] = L11_2
    end
  end
  return L1_2
end
L18_1 = L0_1.define
L19_1 = "garage"
L20_1 = "cd_garage"
L21_1 = {}
L21_1.label = "cd_garage"
L22_1 = {}
L23_1 = "cd_garage"
L22_1[1] = L23_1
L21_1.resources = L22_1
L21_1.verified = false
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = L17_1
  L4_2 = L4_2()
  L5_2 = ipairs
  L6_2 = L6_1
  L7_2 = A1_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L5_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    L12_2 = tonumber
    L13_2 = L10_2.in_garage
    L12_2 = L12_2(L13_2)
    if nil == L12_2 then
      L13_2 = L10_2.in_garage
      if true == L13_2 then
        L12_2 = 1
      end
    end
    if 2 ~= L12_2 then
      L13_2 = L4_1
      L14_2 = L10_2.impound
      L13_2 = L13_2(L14_2)
      if not L13_2 then
        goto lbl_35
      end
    end
    L13_2 = "impound"
    ::lbl_35::
    if not L13_2 then
      if 1 == L12_2 then
        L13_2 = "garage"
        if L13_2 then
          goto lbl_41
        end
      end
      L13_2 = "out"
    end
    ::lbl_41::
    L11_2.state = L13_2
    L13_2 = L3_1
    L14_2 = L10_2.garage_id
    if not L14_2 then
      L14_2 = L10_2.garage
    end
    L13_2 = L13_2(L14_2)
    L14_2 = L11_2.state
    if "impound" == L14_2 then
      L14_2 = L8_1
      L15_2 = "cd_garage"
      L16_2 = "GetVehicleImpoundData"
      L17_2 = L10_2.plate
      L14_2 = L14_2(L15_2, L16_2, L17_2)
      L15_2 = type
      L16_2 = L14_2
      L15_2 = L15_2(L16_2)
      if "table" == L15_2 then
        L15_2 = type
        L16_2 = L14_2.impound
        L15_2 = L15_2(L16_2)
        if "table" == L15_2 then
          L15_2 = L14_2.impound
          if L15_2 then
            goto lbl_70
          end
        end
        L15_2 = nil
        ::lbl_70::
        L16_2 = L3_1
        if L15_2 then
          L17_2 = L15_2.id
          if L17_2 then
            goto lbl_85
          end
        end
        L17_2 = type
        L18_2 = L14_2.impound
        L17_2 = L17_2(L18_2)
        if "table" ~= L17_2 then
          L17_2 = L14_2.impound
          if L17_2 then
            goto lbl_85
          end
        end
        L17_2 = nil
        ::lbl_85::
        L16_2 = L16_2(L17_2)
        if L16_2 then
          L13_2 = L16_2
        end
        L17_2 = L3_1
        if L15_2 then
          L18_2 = L15_2.label
          if L18_2 then
            goto lbl_96
          end
        end
        L18_2 = L14_2.impound_label
        ::lbl_96::
        L17_2 = L17_2(L18_2)
        if L17_2 then
          L18_2 = L13_2 or L18_2
          if not L13_2 then
            L18_2 = L17_2
          end
          L19_2 = L13_2 or L19_2
          if not L13_2 then
            L19_2 = L17_2
          end
          L19_2 = L3_2[L19_2]
          if not L19_2 then
            L19_2 = L17_2
          end
          L3_2[L18_2] = L19_2
        end
      end
    end
    L11_2.garage = L13_2
    if nil ~= L13_2 then
      L14_2 = L3_2[L13_2]
      if nil == L14_2 then
        L14_2 = L8_1
        L15_2 = "cd_garage"
        L16_2 = "GetGarageLabelFromGarageId"
        L17_2 = L13_2
        L14_2 = L14_2(L15_2, L16_2, L17_2)
        L15_2 = type
        L16_2 = L14_2
        L15_2 = L15_2(L16_2)
        L15_2 = L14_2 or L15_2
        if "string" ~= L15_2 or "" == L14_2 or not L14_2 then
          L15_2 = L4_2[L13_2]
          if L15_2 then
            L15_2 = L4_2[L13_2]
            L15_2 = L15_2.label
            if L15_2 then
              goto lbl_138
            end
          end
          L15_2 = false
        end
        ::lbl_138::
        L3_2[L13_2] = L15_2
      end
      L14_2 = L3_2[L13_2]
      if not L14_2 then
        L14_2 = nil
      end
      L11_2.garageLabel = L14_2
      L14_2 = L4_2[L13_2]
      if L14_2 then
        L14_2 = L4_2[L13_2]
        L14_2 = L14_2.coords
        if L14_2 then
          goto lbl_152
        end
      end
      L14_2 = nil
      ::lbl_152::
      L11_2.coords = L14_2
    end
    L14_2 = L3_1
    L15_2 = L10_2.custom_label
    L14_2 = L14_2(L15_2)
    if L14_2 then
      L14_2 = L10_2.custom_label
      L11_2.nickname = L14_2
    end
    L14_2 = #L2_2
    L14_2 = L14_2 + 1
    L2_2[L14_2] = L11_2
  end
  return L2_2
end
L21_1.list = L22_1
function L22_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L21_1.track = L22_1
function L22_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.in_garage = 0
  return L0_2
end
L21_1.deliverOut = L22_1
L18_1(L19_1, L20_1, L21_1)
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L0_1.readResourceTable
  L2_2 = "okokGarage"
  L3_2 = "config.lua"
  L4_2 = "Config.Garages"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    L3_2 = nil
    return L2_2, L3_2
  end
  L2_2 = pairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2.id
      if nil ~= L8_2 then
        L8_2 = tostring
        L9_2 = L7_2.id
        L8_2 = L8_2(L9_2)
        L9_2 = tostring
        L10_2 = A0_2
        L9_2 = L9_2(L10_2)
        if L8_2 == L9_2 then
          L8_2 = L0_1.xyz
          L9_2 = L7_2.coords
          L8_2 = L8_2(L9_2)
          L9_2 = L7_2.name
          return L8_2, L9_2
        end
      end
    end
  end
  L2_2 = nil
  L3_2 = nil
  return L2_2, L3_2
end
L19_1 = L0_1.define
L20_1 = "garage"
L21_1 = "okokGarage"
L22_1 = {}
L22_1.label = "okokGarage"
L23_1 = {}
L24_1 = "okokGarage"
L23_1[1] = L24_1
L22_1.resources = L23_1
L22_1.verified = false
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L6_1
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L5_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L10_2 = FW
    L10_2 = L10_2.name
    if "esx" == L10_2 then
      L10_2 = type
      L11_2 = L8_2.impoundTime
      L10_2 = L10_2(L11_2)
      if "string" == L10_2 then
        L10_2 = L8_2.impoundTime
      end
      L10_2 = "" ~= L10_2
      if L10_2 then
        L11_2 = "impound"
        if L11_2 then
          goto lbl_51
        end
      end
      L11_2 = tonumber
      L12_2 = L8_2.stored
      L11_2 = L11_2(L12_2)
      if 1 ~= L11_2 then
        L11_2 = L8_2.stored
        if true ~= L11_2 then
          goto lbl_50
        end
      end
      L11_2 = "garage"
      ::lbl_50::
      if not L11_2 then
        L11_2 = "out"
      end
      ::lbl_51::
      L9_2.state = L11_2
    else
      L10_2 = L0_1.vehState
      L11_2 = L8_2.state
      L10_2 = L10_2(L11_2)
      L9_2.state = L10_2
    end
    L10_2 = L8_2.parking
    if not L10_2 then
      L10_2 = L8_2.garage
    end
    L9_2.garage = L10_2
    if nil ~= L10_2 then
      L11_2 = L18_1
      L12_2 = L10_2
      L11_2, L12_2 = L11_2(L12_2)
      L13_2 = L11_2
      L9_2.garageLabel = L12_2
      L9_2.coords = L13_2
    end
    L11_2 = type
    L12_2 = L8_2.vehiclename
    L11_2 = L11_2(L12_2)
    if "string" == L11_2 then
      L11_2 = L8_2.vehiclename
      if "" ~= L11_2 then
        L11_2 = L8_2.vehiclename
        L9_2.label = L11_2
      end
    end
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L2_2[L11_2] = L9_2
  end
  return L2_2
end
L22_1.list = L23_1
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L22_1.track = L23_1
L19_1(L20_1, L21_1, L22_1)
function L19_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = {}
  L1_2 = L8_1
  L2_2 = "qs-advancedgarages"
  L3_2 = "GetGarages"
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = pairs
    L3_2 = L1_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L8_2 = type
        L9_2 = L7_2.coords
        L8_2 = L8_2(L9_2)
        if "table" == L8_2 then
          L8_2 = L7_2.coords
          if L8_2 then
            goto lbl_31
          end
        end
        L8_2 = {}
        ::lbl_31::
        L9_2 = tostring
        L10_2 = L7_2.name
        if not L10_2 then
          L10_2 = L7_2.id
          if not L10_2 then
            L10_2 = L6_2
          end
        end
        L9_2 = L9_2(L10_2)
        L10_2 = {}
        L11_2 = L7_2.label
        if not L11_2 then
          L11_2 = L7_2.name
        end
        L10_2.label = L11_2
        L11_2 = L4_1
        L12_2 = L7_2.isImpound
        L11_2 = L11_2(L12_2)
        L10_2.impound = L11_2
        L11_2 = L13_1
        L12_2 = L8_2.menuCoords
        L13_2 = L8_2.spawnCoords
        L14_2 = L7_2.coords
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        L10_2.coords = L11_2
        L0_2[L9_2] = L10_2
      end
    end
  end
  L2_2 = ipairs
  L3_2 = L2_1
  L4_2 = "SELECT name, coords, isImpound FROM player_garages"
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.name
    if nil ~= L8_2 then
      L8_2 = tostring
      L9_2 = L7_2.name
      L8_2 = L8_2(L9_2)
      L8_2 = L0_2[L8_2]
      if not L8_2 then
        L8_2 = L0_1.decode
        L9_2 = L7_2.coords
        L8_2 = L8_2(L9_2)
        L9_2 = tostring
        L10_2 = L7_2.name
        L9_2 = L9_2(L10_2)
        L10_2 = {}
        L11_2 = L7_2.name
        L10_2.label = L11_2
        L11_2 = L4_1
        L12_2 = L7_2.isImpound
        L11_2 = L11_2(L12_2)
        L10_2.impound = L11_2
        L11_2 = L13_1
        L12_2 = L8_2.menuCoords
        L13_2 = L8_2.spawnCoords
        L14_2 = L8_2
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        L10_2.coords = L11_2
        L0_2[L9_2] = L10_2
      end
    end
  end
  return L0_2
end
L20_1 = L0_1.define
L21_1 = "garage"
L22_1 = "qs-advancedgarages"
L23_1 = {}
L23_1.label = "qs-advancedgarages"
L24_1 = {}
L25_1 = "qs-advancedgarages"
L24_1[1] = L25_1
L23_1.resources = L24_1
L23_1.verified = false
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L19_1
  L2_2 = L2_2()
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L6_1
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L3_1
    L11_2 = L9_2.jobVehicle
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = L5_1
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      L11_2 = L3_1
      L12_2 = L9_2.garage
      L11_2 = L11_2(L12_2)
      L12_2 = nil == L11_2
      if not L12_2 then
        L13_2 = L2_2[L11_2]
        if L13_2 then
          goto lbl_36
        end
      end
      L13_2 = nil
      ::lbl_36::
      L14_2 = FW
      L14_2 = L14_2.name
      if "esx" ~= L14_2 then
        L14_2 = tonumber
        L15_2 = L9_2.state
        L14_2 = L14_2(L15_2)
        if nil ~= L14_2 then
          L14_2 = L0_1.vehState
          L15_2 = L9_2.state
          L14_2 = L14_2(L15_2)
          L10_2.state = L14_2
      end
      else
        if L12_2 then
          L14_2 = "out"
          if L14_2 then
            goto lbl_56
          end
        end
        L14_2 = "garage"
        ::lbl_56::
        L10_2.state = L14_2
      end
      L14_2 = L10_2.state
      if "garage" == L14_2 and L13_2 then
        L14_2 = L13_2.impound
        if L14_2 then
          L10_2.state = "impound"
        end
      end
      if not L12_2 then
        L14_2 = L11_2
        if L13_2 then
          L15_2 = L13_2.label
          if L15_2 then
            goto lbl_75
          end
        end
        L15_2 = nil
        ::lbl_75::
        if L13_2 then
          L16_2 = L13_2.coords
          if L16_2 then
            goto lbl_81
          end
        end
        L16_2 = nil
        ::lbl_81::
        L10_2.coords = L16_2
        L10_2.garageLabel = L15_2
        L10_2.garage = L14_2
      end
      L14_2 = #L3_2
      L14_2 = L14_2 + 1
      L3_2[L14_2] = L10_2
    end
  end
  return L3_2
end
L23_1.list = L24_1
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L23_1.track = L24_1
function L24_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.garage = "OUT"
  return L0_2
end
L23_1.deliverOut = L24_1
L20_1(L21_1, L22_1, L23_1)
L20_1 = L0_1.define
L21_1 = "garage"
L22_1 = "vms_garagesv2"
L23_1 = {}
L23_1.label = "vms_garagesv2"
L24_1 = {}
L25_1 = "vms_garagesv2"
L24_1[1] = L25_1
L23_1.resources = L24_1
L23_1.verified = false
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L6_1
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L3_1
    L11_2 = L9_2.company
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = L3_1
      L11_2 = L9_2.gang
      L10_2 = L10_2(L11_2)
      if not L10_2 then
        L10_2 = L5_1
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        L11_2 = L3_1
        L12_2 = L9_2.garage
        L11_2 = L11_2(L12_2)
        L12_2 = L9_2.impound_date
        if nil ~= L12_2 then
          L12_2 = L3_1
          L13_2 = L9_2.impound_date
          L12_2 = L12_2(L13_2)
          if L12_2 then
            L12_2 = "impound"
            if L12_2 then
              goto lbl_44
            end
          end
        end
        if L11_2 then
          L12_2 = "garage"
          if L12_2 then
            goto lbl_44
          end
        end
        L12_2 = "out"
        ::lbl_44::
        L10_2.state = L12_2
        if L11_2 then
          L12_2 = L2_2[L11_2]
          if nil == L12_2 then
            L12_2 = L0_1.callExport
            L13_2 = "vms_garagesv2"
            L14_2 = "getGarageInfo"
            L15_2 = L11_2
            L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2, L15_2)
            if L12_2 then
              L15_2 = {}
              L16_2 = type
              L17_2 = L13_2
              L16_2 = L16_2(L17_2)
              L16_2 = L13_2 or L16_2
              if "string" ~= L16_2 or not L13_2 then
                L16_2 = nil
              end
              L15_2.label = L16_2
              L16_2 = L13_1
              L17_2 = L14_2
              L16_2 = L16_2(L17_2)
              L15_2.coords = L16_2
              if L15_2 then
                goto lbl_75
              end
            end
            L15_2 = false
            ::lbl_75::
            L2_2[L11_2] = L15_2
          end
          L10_2.garage = L11_2
          L12_2 = L2_2[L11_2]
          if L12_2 then
            L12_2 = L2_2[L11_2]
            L12_2 = L12_2.label
            if L12_2 then
              goto lbl_85
            end
          end
          L12_2 = nil
          ::lbl_85::
          L10_2.garageLabel = L12_2
          L12_2 = L2_2[L11_2]
          if L12_2 then
            L12_2 = L2_2[L11_2]
            L12_2 = L12_2.coords
            if L12_2 then
              goto lbl_94
            end
          end
          L12_2 = nil
          ::lbl_94::
          L10_2.coords = L12_2
        end
        L12_2 = L10_2.mileage
        if not L12_2 then
          L12_2 = L0_1.num
          L13_2 = L9_2.milage
          L12_2 = L12_2(L13_2)
        end
        L10_2.mileage = L12_2
        L12_2 = #L3_2
        L12_2 = L12_2 + 1
        L3_2[L12_2] = L10_2
      end
    end
  end
  return L3_2
end
L23_1.list = L24_1
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L23_1.track = L24_1
function L24_1()
  local L0_2, L1_2
  L0_2 = {}
  L1_2 = L0_1.SQL_NULL
  L0_2.garage = L1_2
  return L0_2
end
L23_1.deliverOut = L24_1
L20_1(L21_1, L22_1, L23_1)
L20_1 = L0_1.define
L21_1 = "garage"
L22_1 = "codem-garagesv2"
L23_1 = {}
L23_1.label = "codem-garagesv2"
L24_1 = {}
L25_1 = "codem-garagesv2"
L24_1[1] = L25_1
L23_1.resources = L24_1
L23_1.verified = false
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = L7_1
  L3_2 = "codem-garagesv2"
  L4_2 = "GetPlayerVehicles"
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L8_1
  L4_2 = "codem-garagesv2"
  L5_2 = "GetGarages"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = L8_1
  L5_2 = "codem-garagesv2"
  L6_2 = "GetImpounds"
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    if nil == A0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = type
    L2_3 = L3_2
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = L3_2
      L1_3 = L1_3[A0_3]
      if L1_3 then
        goto lbl_24
      end
    end
    L1_3 = type
    L2_3 = L4_2
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = L4_2
      L1_3 = L1_3[A0_3]
      if L1_3 then
        goto lbl_24
      end
    end
    L1_3 = nil
    ::lbl_24::
    L2_3 = type
    L3_3 = L1_3
    L2_3 = L2_3(L3_3)
    if "table" ~= L2_3 then
      L2_3 = nil
      return L2_3
    end
    L2_3 = {}
    L3_3 = L1_3.label
    L2_3.label = L3_3
    L3_3 = L13_1
    L4_3 = L1_3.coords
    L5_3 = L1_3.coord
    L6_3 = L1_3.position
    L3_3 = L3_3(L4_3, L5_3, L6_3)
    L2_3.coords = L3_3
    return L2_3
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = L12_2.plate
      if L13_2 then
        L13_2 = L3_1
        L14_2 = L12_2.fleet
        L13_2 = L13_2(L14_2)
        if not L13_2 then
          L13_2 = L0_1.decode
          L14_2 = L12_2.props
          if not L14_2 then
            L14_2 = L12_2.mods
            if not L14_2 then
              L14_2 = FW
              L14_2 = L14_2.name
              if "esx" == L14_2 then
                L14_2 = L12_2.vehicle
                if L14_2 then
                  goto lbl_57
                end
              end
              L14_2 = nil
            end
          end
          ::lbl_57::
          L13_2 = L13_2(L14_2)
          L14_2 = L12_2.model
          if not L14_2 then
            L14_2 = L12_2.modelName
            if not L14_2 then
              L14_2 = FW
              L14_2 = L14_2.name
              if "esx" ~= L14_2 then
                L14_2 = L12_2.vehicle
                if L14_2 then
                  goto lbl_72
                end
              end
              L14_2 = L13_2.model
            end
          end
          ::lbl_72::
          L15_2 = {}
          L16_2 = L12_2.plate
          L15_2.plate = L16_2
          if nil ~= L14_2 then
            L16_2 = tostring
            L17_2 = L14_2
            L16_2 = L16_2(L17_2)
            if L16_2 then
              goto lbl_84
            end
          end
          L16_2 = nil
          ::lbl_84::
          L15_2.model = L16_2
          L16_2 = tonumber
          L17_2 = L12_2.hash
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = tonumber
            L17_2 = L13_2.model
            L16_2 = L16_2(L17_2)
          end
          L15_2.hash = L16_2
          L16_2 = L0_1.vehState
          L17_2 = L12_2.state
          L16_2 = L16_2(L17_2)
          L15_2.state = L16_2
          L16_2 = L0_1.num
          L17_2 = L12_2.fuel
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = L0_1.num
            L17_2 = L13_2.fuelLevel
            L16_2 = L16_2(L17_2)
          end
          L15_2.fuel = L16_2
          L16_2 = L0_1.num
          L17_2 = L12_2.engine
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = L0_1.num
            L17_2 = L13_2.engineHealth
            L16_2 = L16_2(L17_2)
          end
          L15_2.engine = L16_2
          L16_2 = L0_1.num
          L17_2 = L12_2.body
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = L0_1.num
            L17_2 = L13_2.bodyHealth
            L16_2 = L16_2(L17_2)
          end
          L15_2.body = L16_2
          L16_2 = L0_1.num
          L17_2 = L12_2.mileage
          L16_2 = L16_2(L17_2)
          L15_2.mileage = L16_2
          L16_2 = L3_1
          L17_2 = L12_2.garage
          L16_2 = L16_2(L17_2)
          L17_2 = L15_2.state
          if "impound" == L17_2 then
            L17_2 = type
            L18_2 = L12_2.impound
            L17_2 = L17_2(L18_2)
            if "table" == L17_2 then
              L17_2 = L12_2.impound
              if L17_2 then
                goto lbl_148
              end
            end
            L17_2 = L8_1
            L18_2 = "codem-garagesv2"
            L19_2 = "GetImpoundData"
            L20_2 = L12_2.plate
            L17_2 = L17_2(L18_2, L19_2, L20_2)
            ::lbl_148::
            L18_2 = type
            L19_2 = L17_2
            L18_2 = L18_2(L19_2)
            if "table" == L18_2 then
              L18_2 = L3_1
              L19_2 = L17_2.lot
              L18_2 = L18_2(L19_2)
              if L18_2 then
                L16_2 = L17_2.lot
              end
            end
          end
          L17_2 = L5_2
          L18_2 = L16_2
          L17_2 = L17_2(L18_2)
          L18_2 = L16_2
          if L17_2 then
            L19_2 = L17_2.label
            if L19_2 then
              goto lbl_169
            end
          end
          L19_2 = nil
          ::lbl_169::
          if L17_2 then
            L20_2 = L17_2.coords
            if L20_2 then
              goto lbl_175
            end
          end
          L20_2 = nil
          ::lbl_175::
          L15_2.coords = L20_2
          L15_2.garageLabel = L19_2
          L15_2.garage = L18_2
          L18_2 = L3_1
          L19_2 = L12_2.nickname
          if not L19_2 then
            L19_2 = L12_2.custom_label
            if not L19_2 then
              L19_2 = L12_2.label
            end
          end
          L18_2 = L18_2(L19_2)
          L15_2.nickname = L18_2
          L18_2 = #L6_2
          L18_2 = L18_2 + 1
          L6_2[L18_2] = L15_2
        end
      end
    end
  end
  return L6_2
end
L23_1.list = L24_1
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L23_1.track = L24_1
L20_1(L21_1, L22_1, L23_1)
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = ipairs
  L2_2 = {}
  L3_2 = "Config.Garages"
  L4_2 = "Config.JobGarages"
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L0_1.readResourceTable
    L8_2 = "codem-garage"
    L9_2 = "config.lua"
    L10_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2[A0_2]
      if L8_2 then
        goto lbl_27
      end
    end
    L8_2 = nil
    ::lbl_27::
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = type
      L10_2 = L8_2.car
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = L8_2.car
        if L9_2 then
          goto lbl_42
        end
      end
      L9_2 = {}
      ::lbl_42::
      L10_2 = type
      L11_2 = L8_2.npc
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = L8_2.npc
        if L10_2 then
          goto lbl_52
        end
      end
      L10_2 = {}
      ::lbl_52::
      L11_2 = L13_1
      L12_2 = L9_2.garage
      L13_2 = L10_2.npc
      L14_2 = L9_2.spawncar
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2)
      return L11_2, L12_2, L13_2, L14_2
    end
  end
  L1_2 = nil
  return L1_2
end
L21_1 = L0_1.define
L22_1 = "garage"
L23_1 = "codem-garage"
L24_1 = {}
L24_1.label = "codem-garage"
L25_1 = {}
L26_1 = "codem-garage"
L25_1[1] = L26_1
L24_1.resources = L25_1
L24_1.verified = false
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L6_1
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L5_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L10_2 = FW
    L10_2 = L10_2.name
    if "esx" == L10_2 then
      L10_2 = L0_1.vehState
      L11_2 = tonumber
      L12_2 = L8_2.stored
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = L8_2.stored
        if true == L11_2 then
          L11_2 = 1
          if L11_2 then
            goto lbl_29
          end
        end
        L11_2 = 0
      end
      ::lbl_29::
      L10_2 = L10_2(L11_2)
      L9_2.state = L10_2
    else
      L10_2 = L0_1.vehState
      L11_2 = tonumber
      L12_2 = L8_2.state
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L10_2 = L10_2(L11_2)
      L9_2.state = L10_2
    end
    L10_2 = L3_1
    L11_2 = L8_2.parking
    L10_2 = L10_2(L11_2)
    L11_2 = L10_2
    L12_2 = L20_1
    L13_2 = L10_2
    L12_2 = L12_2(L13_2)
    L9_2.coords = L12_2
    L9_2.garage = L11_2
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L2_2[L11_2] = L9_2
  end
  return L2_2
end
L24_1.list = L25_1
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L24_1.track = L25_1
L21_1(L22_1, L23_1, L24_1)
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if nil == A1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L8_1
  L3_2 = "op-garages"
  L4_2 = A0_2
  L5_2 = tostring
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L2_2.Label
  if nil == L3_2 then
    L3_2 = type
    L4_2 = tostring
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    L4_2 = L2_2[L4_2]
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = tostring
      L4_2 = A1_2
      L3_2 = L3_2(L4_2)
      L2_2 = L2_2[L3_2]
    end
  end
  L3_2 = {}
  L4_2 = L2_2.Label
  L3_2.label = L4_2
  L4_2 = L13_1
  L5_2 = L2_2.AccessPoint
  L6_2 = L2_2.CenterOfZone
  L7_2 = L2_2.Coords
  L8_2 = L2_2.onespawn
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L3_2.coords = L4_2
  return L3_2
end
L22_1 = L0_1.define
L23_1 = "garage"
L24_1 = "op-garages"
L25_1 = {}
L25_1.label = "op-garages"
L26_1 = {}
L27_1 = "op-garages"
L26_1[1] = L27_1
L25_1.resources = L26_1
L25_1.verified = false
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = {}
  L3_2 = {}
  function L4_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3
    L2_3 = A0_3
    L3_3 = tostring
    L4_3 = A1_3
    L3_3 = L3_3(L4_3)
    L2_3 = L2_3 .. L3_3
    L3_3 = L2_2
    L3_3 = L3_3[L2_3]
    if nil == L3_3 then
      L3_3 = L2_2
      L4_3 = L21_1
      L5_3 = A0_3
      L6_3 = A1_3
      L4_3 = L4_3(L5_3, L6_3)
      if not L4_3 then
        L4_3 = false
      end
      L3_3[L2_3] = L4_3
    end
    L3_3 = L2_2
    L3_3 = L3_3[L2_3]
    if not L3_3 then
      L3_3 = nil
    end
    return L3_3
  end
  L5_2 = ipairs
  L6_2 = L6_1
  L7_2 = A1_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L5_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    L12_2 = L10_2.stored
    L13_2 = FW
    L13_2 = L13_2.name
    if "esx" ~= L13_2 or nil == L12_2 then
      L12_2 = L10_2.state
    end
    L13_2 = tonumber
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      if true == L12_2 then
        L13_2 = 1
        if L13_2 then
          goto lbl_34
        end
      end
      L13_2 = 0
    end
    ::lbl_34::
    L14_2 = nil
    L15_2 = L4_1
    L16_2 = L10_2.isTowedOut
    L15_2 = L15_2(L16_2)
    if L15_2 then
      L15_2 = "impound"
      L16_2 = L3_1
      L17_2 = L10_2.vehicleImpound
      L16_2 = L16_2(L17_2)
      L11_2.garage = L16_2
      L11_2.state = L15_2
      L15_2 = L11_2.garage
      if L15_2 then
        L15_2 = L4_2
        L16_2 = "getImpoundByIndex"
        L17_2 = L11_2.garage
        L15_2 = L15_2(L16_2, L17_2)
        L14_2 = L15_2 or L14_2
      end
      if not L15_2 then
        L14_2 = nil
      end
    else
      if 0 == L13_2 then
        L15_2 = "garage"
        if L15_2 then
          goto lbl_63
        end
      end
      L15_2 = "out"
      ::lbl_63::
      L16_2 = L3_1
      L17_2 = L10_2.vehicleGarage
      L16_2 = L16_2(L17_2)
      L11_2.garage = L16_2
      L11_2.state = L15_2
      L15_2 = L11_2.garage
      if L15_2 then
        L15_2 = L4_2
        L16_2 = "getGarageByIndex"
        L17_2 = L11_2.garage
        L15_2 = L15_2(L16_2, L17_2)
        if L15_2 then
          goto lbl_78
          L14_2 = L15_2 or L14_2
        end
      end
      L14_2 = nil
    end
    ::lbl_78::
    if L14_2 then
      L15_2 = L14_2.label
      if L15_2 then
        goto lbl_84
      end
    end
    L15_2 = nil
    ::lbl_84::
    if L14_2 then
      L16_2 = L14_2.coords
      if L16_2 then
        goto lbl_90
      end
    end
    L16_2 = nil
    ::lbl_90::
    L11_2.coords = L16_2
    L11_2.garageLabel = L15_2
    L15_2 = #L3_2
    L15_2 = L15_2 + 1
    L3_2[L15_2] = L11_2
  end
  return L3_2
end
L25_1.list = L26_1
function L26_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L25_1.track = L26_1
L25_1.deliverBase = false
function L26_1(A0_2)
  local L1_2
  L1_2 = FW
  L1_2 = L1_2.name
  if "esx" == L1_2 then
    L1_2 = A0_2.stored
    if nil ~= L1_2 then
      L1_2 = {}
      L1_2.stored = 1
      return L1_2
    end
  end
  L1_2 = {}
  L1_2.state = 1
  return L1_2
end
L25_1.deliverOut = L26_1
L22_1(L23_1, L24_1, L25_1)
L22_1 = {}
L22_1.stored = "garage"
L22_1.out = "out"
L22_1.parked = "out"
L22_1.impounded = "impound"
L23_1 = L0_1.define
L24_1 = "garage"
L25_1 = "kartik-garages"
L26_1 = {}
L26_1.label = "kartik-garages"
L27_1 = {}
L28_1 = "kartik-garages"
L27_1[1] = L28_1
L26_1.resources = L27_1
L26_1.verified = false
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = L7_1
  L3_2 = "kartik-garages"
  L4_2 = "GetPlayerVehicles"
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_1
  L6_2 = "SELECT * FROM %s WHERE %s = ?"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L1_1
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2()
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L7_2 = {}
  L8_2 = A1_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.plate
    if L10_2 then
      L10_2 = L0_1.plateKey
      L11_2 = L9_2.plate
      L10_2 = L10_2(L11_2)
      L11_2 = L5_1
      L12_2 = L9_2
      L11_2 = L11_2(L12_2)
      L3_2[L10_2] = L11_2
    end
  end
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = L11_2.plate
      if L12_2 then
        L12_2 = L0_1.plateKey
        L13_2 = L11_2.plate
        L12_2 = L12_2(L13_2)
        L12_2 = L3_2[L12_2]
        if not L12_2 then
          L12_2 = {}
        end
        L13_2 = L3_1
        L14_2 = L11_2.garage
        L13_2 = L13_2(L14_2)
        if L13_2 then
          L14_2 = L4_2[L13_2]
          if nil == L14_2 then
            L14_2 = L8_1
            L15_2 = "kartik-garages"
            L16_2 = "GetGarage"
            L17_2 = L13_2
            L14_2 = L14_2(L15_2, L16_2, L17_2)
            L15_2 = type
            L16_2 = L14_2
            L15_2 = L15_2(L16_2)
            if "table" == L15_2 then
              L15_2 = {}
              L16_2 = L14_2.label
              if not L16_2 then
                L16_2 = L14_2.name
              end
              L15_2.label = L16_2
              L16_2 = L13_1
              L17_2 = L14_2.coords
              L18_2 = L14_2.location
              L19_2 = L14_2.position
              L20_2 = L14_2.entry
              L21_2 = L14_2.blip
              L22_2 = type
              L23_2 = L14_2.spawn_coords
              L22_2 = L22_2(L23_2)
              if "table" == L22_2 then
                L22_2 = L14_2.spawn_coords
                L22_2 = L22_2[1]
                if L22_2 then
                  goto lbl_104
                end
              end
              L22_2 = L14_2.spawn_coords
              ::lbl_104::
              L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
              L15_2.coords = L16_2
              if L15_2 then
                goto lbl_109
              end
            end
            L15_2 = false
            ::lbl_109::
            L4_2[L13_2] = L15_2
          end
        end
        if L13_2 then
          L14_2 = L4_2[L13_2]
          if L14_2 then
            goto lbl_116
          end
        end
        L14_2 = nil
        ::lbl_116::
        L15_2 = #L5_2
        L15_2 = L15_2 + 1
        L16_2 = {}
        L17_2 = L11_2.plate
        L16_2.plate = L17_2
        L17_2 = L11_2.model
        if nil ~= L17_2 then
          L17_2 = tostring
          L18_2 = L11_2.model
          L17_2 = L17_2(L18_2)
          if L17_2 then
            goto lbl_132
          end
        end
        L17_2 = L12_2.model
        ::lbl_132::
        L16_2.model = L17_2
        L17_2 = L12_2.hash
        L16_2.hash = L17_2
        L17_2 = tostring
        L18_2 = L11_2.status
        if not L18_2 then
          L18_2 = ""
        end
        L17_2 = L17_2(L18_2)
        L18_2 = L17_2
        L17_2 = L17_2.lower
        L17_2 = L17_2(L18_2)
        L18_2 = L22_1
        L17_2 = L18_2[L17_2]
        if not L17_2 then
          L17_2 = "out"
        end
        L16_2.state = L17_2
        L16_2.garage = L13_2
        if L14_2 then
          L17_2 = L14_2.label
          if L17_2 then
            goto lbl_156
          end
        end
        L17_2 = nil
        ::lbl_156::
        L16_2.garageLabel = L17_2
        if L14_2 then
          L17_2 = L14_2.coords
          if L17_2 then
            goto lbl_163
          end
        end
        L17_2 = nil
        ::lbl_163::
        L16_2.coords = L17_2
        L17_2 = L12_2.fuel
        L16_2.fuel = L17_2
        L17_2 = L12_2.engine
        L16_2.engine = L17_2
        L17_2 = L12_2.body
        L16_2.body = L17_2
        L17_2 = L0_1.num
        L18_2 = L11_2.mileage
        L17_2 = L17_2(L18_2)
        if not L17_2 then
          L17_2 = L12_2.mileage
        end
        L16_2.mileage = L17_2
        L5_2[L15_2] = L16_2
      end
    end
  end
  return L5_2
end
L26_1.list = L27_1
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = L8_1
    L1_3 = "kartik-garages"
    L2_3 = "GetParkedVehicle"
    L3_3 = A2_2
    L0_3 = L0_3(L1_3, L2_3, L3_3)
    L1_3 = type
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = L0_3.coords
      if L1_3 or L0_3 then
        goto lbl_17
        L1_3 = L0_3 or L1_3
      end
    end
    L1_3 = nil
    ::lbl_17::
    return L1_3
  end
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L26_1.track = L27_1
L23_1(L24_1, L25_1, L26_1)
L23_1 = {}
L23_1.garaged = "garage"
L23_1.out = "out"
L23_1.impounded = "impound"
L24_1 = L0_1.define
L25_1 = "garage"
L26_1 = "tgiann-realparking"
L27_1 = {}
L27_1.label = "tgiann-realparking"
L28_1 = {}
L29_1 = "tgiann-realparking"
L28_1[1] = L29_1
L27_1.resources = L28_1
L27_1.verified = false
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L7_1
  L3_2 = "tgiann-realparking"
  L4_2 = "GetPlayerVehicleDetails"
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L8_1
  L4_2 = "tgiann-realparking"
  L5_2 = "GetGarageList"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = {}
  L5_2 = nil
  L6_2 = type
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = pairs
    L7_2 = L3_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = type
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        L12_2 = L11_2.type
        if "impound" == L12_2 then
          L12_2 = #L4_2
          L12_2 = L12_2 + 1
          L13_2 = {}
          L13_2.key = L10_2
          L14_2 = L11_2.label
          L13_2.label = L14_2
          L14_2 = L13_1
          L15_2 = L11_2
          L14_2 = L14_2(L15_2)
          L13_2.coords = L14_2
          L4_2[L12_2] = L13_2
        end
      end
    end
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = L12_2.plate
      if L13_2 then
        L13_2 = L0_1.decode
        L14_2 = L12_2.properties
        L13_2 = L13_2(L14_2)
        L14_2 = {}
        L15_2 = L12_2.plate
        L14_2.plate = L15_2
        L15_2 = L13_2.modelName
        if not L15_2 then
          L15_2 = L13_2.model
          if nil ~= L15_2 then
            L15_2 = tostring
            L16_2 = L13_2.model
            L15_2 = L15_2(L16_2)
            if L15_2 then
              goto lbl_83
            end
          end
          L15_2 = nil
        end
        ::lbl_83::
        L14_2.model = L15_2
        L15_2 = tonumber
        L16_2 = L13_2.model
        L15_2 = L15_2(L16_2)
        L14_2.hash = L15_2
        L15_2 = tostring
        L16_2 = L12_2.state
        if not L16_2 then
          L16_2 = ""
        end
        L15_2 = L15_2(L16_2)
        L16_2 = L23_1
        L15_2 = L16_2[L15_2]
        if not L15_2 then
          L15_2 = "out"
        end
        L14_2.state = L15_2
        L15_2 = L0_1.num
        L16_2 = L13_2.fuelLevel
        L15_2 = L15_2(L16_2)
        L14_2.fuel = L15_2
        L15_2 = L0_1.num
        L16_2 = L13_2.engineHealth
        L15_2 = L15_2(L16_2)
        L14_2.engine = L15_2
        L15_2 = L0_1.num
        L16_2 = L13_2.bodyHealth
        L15_2 = L15_2(L16_2)
        L14_2.body = L15_2
        L15_2 = L14_2.state
        if "garage" == L15_2 then
          L15_2 = L12_2.garageKey
          if L15_2 then
            L15_2 = type
            L16_2 = L3_2
            L15_2 = L15_2(L16_2)
            if "table" == L15_2 then
              L15_2 = L12_2.garageKey
              L15_2 = L3_2[L15_2]
              if L15_2 then
                goto lbl_128
              end
            end
          end
          L15_2 = nil
          ::lbl_128::
          L16_2 = L3_1
          L17_2 = L12_2.garageKey
          L16_2 = L16_2(L17_2)
          L14_2.garage = L16_2
          L16_2 = L12_2.garageLabel
          if not L16_2 then
            L16_2 = type
            L17_2 = L15_2
            L16_2 = L16_2(L17_2)
            if "table" == L16_2 then
              L16_2 = L15_2.label
              if L16_2 then
                goto lbl_144
              end
            end
            L16_2 = nil
          end
          ::lbl_144::
          L14_2.garageLabel = L16_2
          L16_2 = L13_1
          L17_2 = L12_2.coords
          L18_2 = L15_2
          L16_2 = L16_2(L17_2, L18_2)
          L14_2.coords = L16_2
        else
          L15_2 = L14_2.state
          if "impound" == L15_2 then
            if not L5_2 then
              L15_2 = L10_1
              L16_2 = A0_2
              L15_2 = L15_2(L16_2)
              L5_2 = L15_2 or L5_2
              if not L15_2 then
                L5_2 = false
              end
            end
            L15_2 = L11_1
            L16_2 = L4_2
            L17_2 = L5_2 or L17_2
            if not L5_2 then
              L17_2 = nil
            end
            L15_2 = L15_2(L16_2, L17_2)
            if L15_2 then
              L16_2 = tostring
              L17_2 = L15_2.key
              L16_2 = L16_2(L17_2)
              L17_2 = L15_2.label
              L18_2 = L15_2.coords
              L14_2.coords = L18_2
              L14_2.garageLabel = L17_2
              L14_2.garage = L16_2
            end
          end
        end
        L15_2 = #L6_2
        L15_2 = L15_2 + 1
        L6_2[L15_2] = L14_2
      end
    end
  end
  return L6_2
end
L27_1.list = L28_1
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L27_1.track = L28_1
L24_1(L25_1, L26_1, L27_1)
L24_1 = L0_1.define
L25_1 = "garage"
L26_1 = "tgiann-garage"
L27_1 = {}
L27_1.label = "tgiann-garage"
L28_1 = {}
L29_1 = "tgiann-garage"
L28_1[1] = L29_1
L27_1.resources = L28_1
L27_1.verified = false
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L6_1
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L3_1
    L10_2 = L8_2.job
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = L5_1
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      L10_2 = L8_2.stored
      if nil == L10_2 then
        L10_2 = L8_2.state
      end
      L11_2 = L4_1
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if L11_2 then
        L11_2 = "garage"
        if L11_2 then
          goto lbl_38
        end
      end
      L11_2 = tonumber
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if 2 == L11_2 then
        L11_2 = "impound"
        if L11_2 then
          goto lbl_38
        end
      end
      L11_2 = "out"
      ::lbl_38::
      L9_2.state = L11_2
      L11_2 = L3_1
      L12_2 = L8_2.garageNumber
      L11_2 = L11_2(L12_2)
      L9_2.garage = L11_2
      L11_2 = #L2_2
      L11_2 = L11_2 + 1
      L2_2[L11_2] = L9_2
    end
  end
  return L2_2
end
L27_1.list = L28_1
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L27_1.track = L28_1
function L28_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.stored = 0
  return L0_2
end
L27_1.deliverOut = L28_1
L24_1(L25_1, L26_1, L27_1)
L24_1 = L0_1.define
L25_1 = "garage"
L26_1 = "ak47_garage"
L27_1 = {}
L27_1.label = "ak47_garage"
L28_1 = {}
L29_1 = "ak47_garage"
L28_1[1] = L29_1
L27_1.resources = L28_1
L27_1.verified = false
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L6_1
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L5_1
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    L11_2 = tonumber
    L12_2 = L9_2.stored
    L11_2 = L11_2(L12_2)
    if nil == L11_2 then
      L12_2 = L9_2.stored
      if true == L12_2 then
        L12_2 = 1
        if L12_2 then
          goto lbl_31
          L11_2 = L12_2 or L11_2
        end
      end
      L12_2 = tonumber
      L13_2 = L9_2.state
      L12_2 = L12_2(L13_2)
      L11_2 = L12_2 or L11_2
      if not L12_2 then
        L11_2 = 0
      end
    end
    ::lbl_31::
    L12_2 = L0_1.vehState
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    L10_2.state = L12_2
    L12_2 = L3_1
    L13_2 = L9_2.garage
    L12_2 = L12_2(L13_2)
    if L12_2 then
      L13_2 = L2_2[L12_2]
      if nil == L13_2 then
        L13_2 = L8_1
        L14_2 = "ak47_garage"
        L15_2 = "GetGarageById"
        L16_2 = L12_2
        L13_2 = L13_2(L14_2, L15_2, L16_2)
        L14_2 = type
        L15_2 = L13_2
        L14_2 = L14_2(L15_2)
        if "table" == L14_2 then
          L14_2 = type
          L15_2 = L13_2.polyzone
          L14_2 = L14_2(L15_2)
          if "table" == L14_2 then
            L14_2 = L13_2.polyzone
            if L14_2 then
              goto lbl_63
            end
          end
          L14_2 = {}
          ::lbl_63::
          L15_2 = {}
          L16_2 = L13_2.name
          if not L16_2 then
            L16_2 = L13_2.label
          end
          L15_2.label = L16_2
          L16_2 = L13_1
          L17_2 = type
          L18_2 = L13_2.spawns
          L17_2 = L17_2(L18_2)
          if "table" == L17_2 then
            L17_2 = L13_2.spawns
            L17_2 = L17_2[1]
            if L17_2 then
              goto lbl_81
            end
          end
          L17_2 = nil
          ::lbl_81::
          L18_2 = L12_1
          L19_2 = L14_2.points
          L18_2 = L18_2(L19_2)
          L19_2 = L13_2.coords
          L16_2 = L16_2(L17_2, L18_2, L19_2)
          L15_2.coords = L16_2
          L2_2[L12_2] = L15_2
        else
          L2_2[L12_2] = false
        end
      end
    end
    if L12_2 then
      L13_2 = L2_2[L12_2]
      if L13_2 then
        goto lbl_96
      end
    end
    L13_2 = nil
    ::lbl_96::
    L14_2 = L12_2
    if L13_2 then
      L15_2 = L13_2.label
      if L15_2 then
        goto lbl_103
      end
    end
    L15_2 = nil
    ::lbl_103::
    if L13_2 then
      L16_2 = L13_2.coords
      if L16_2 then
        goto lbl_109
      end
    end
    L16_2 = nil
    ::lbl_109::
    L10_2.coords = L16_2
    L10_2.garageLabel = L15_2
    L10_2.garage = L14_2
    L14_2 = L3_1
    L15_2 = L9_2.customname
    L14_2 = L14_2(L15_2)
    L10_2.nickname = L14_2
    L14_2 = #L3_2
    L14_2 = L14_2 + 1
    L3_2[L14_2] = L10_2
  end
  return L3_2
end
L27_1.list = L28_1
function L28_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.stored = 0
  return L0_2
end
L27_1.deliverOut = L28_1
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = L8_1
    L1_3 = "ak47_garage"
    L2_3 = "GetVehicleLocation"
    L3_3 = A2_2
    L0_3 = L0_3(L1_3, L2_3, L3_3)
    return L0_3
  end
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L27_1.track = L28_1
L24_1(L25_1, L26_1, L27_1)
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  if 1 == L2_2 then
    L3_2 = "garage"
    return L3_2
  end
  if 2 == L2_2 then
    L3_2 = "impound"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  if L3_2 > 0 then
    L3_2 = "impound"
    return L3_2
  end
  L3_2 = "out"
  return L3_2
end
L25_1 = L0_1.define
L26_1 = "garage"
L27_1 = "ak47_qb_garage"
L28_1 = {}
L28_1.label = "ak47_qb_garage"
L29_1 = {}
L30_1 = "ak47_qb_garage"
L29_1[1] = L30_1
L28_1.resources = L29_1
L28_1.verified = false
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L6_1
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L5_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L10_2 = L24_1
    L11_2 = L8_2.state
    L12_2 = L8_2.depotprice
    L10_2 = L10_2(L11_2, L12_2)
    L9_2.state = L10_2
    L10_2 = L3_1
    L11_2 = L8_2.garage
    L10_2 = L10_2(L11_2)
    L9_2.garage = L10_2
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L2_2[L10_2] = L9_2
  end
  return L2_2
end
L28_1.list = L29_1
function L29_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L28_1.track = L29_1
L25_1(L26_1, L27_1, L28_1)
L25_1 = L0_1.define
L26_1 = "garage"
L27_1 = "zerio-garage"
L28_1 = {}
L28_1.label = "zerio-garage"
L29_1 = {}
L30_1 = "zerio-garage"
L29_1[1] = L30_1
L28_1.resources = L29_1
L28_1.verified = false
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = {}
  L5_2 = "GetGarages"
  L6_2 = "GetImpounds"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_1
    L10_2 = "zerio-garage"
    L11_2 = L8_2
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = pairs
      L11_2 = L9_2
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = type
        L17_2 = L15_2
        L16_2 = L16_2(L17_2)
        if "table" == L16_2 then
          L16_2 = L15_2.name
          if not L16_2 then
            L16_2 = L15_2.id
            if not L16_2 then
              L16_2 = L14_2
            end
          end
          L17_2 = tostring
          L18_2 = L16_2
          L17_2 = L17_2(L18_2)
          L18_2 = {}
          L19_2 = L15_2.label
          if not L19_2 then
            L19_2 = L15_2.name
          end
          L18_2.label = L19_2
          L19_2 = L13_1
          L20_2 = L15_2.coords
          L21_2 = L15_2.marker
          L22_2 = L15_2.prop
          L23_2 = {}
          L24_2 = L15_2.prop_x
          L23_2.x = L24_2
          L24_2 = L15_2.prop_y
          L23_2.y = L24_2
          L24_2 = L15_2.prop_z
          L23_2.z = L24_2
          L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
          L18_2.coords = L19_2
          L2_2[L17_2] = L18_2
        end
      end
    end
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L6_1
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L5_1
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    L11_2 = FW
    L11_2 = L11_2.name
    if "esx" == L11_2 then
      L11_2 = L9_2.stored
      if L11_2 then
        goto lbl_86
      end
    end
    L11_2 = L9_2.state
    ::lbl_86::
    L12_2 = L0_1.vehState
    L13_2 = tonumber
    L14_2 = L11_2
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      if true == L11_2 then
        L13_2 = 1
        if L13_2 then
          goto lbl_98
        end
      end
      L13_2 = 0
    end
    ::lbl_98::
    L12_2 = L12_2(L13_2)
    L10_2.state = L12_2
    L12_2 = L3_1
    L13_2 = L9_2.garage
    L12_2 = L12_2(L13_2)
    if L12_2 then
      L13_2 = L2_2[L12_2]
      if L13_2 then
        goto lbl_109
      end
    end
    L13_2 = nil
    ::lbl_109::
    L14_2 = L12_2
    if L13_2 then
      L15_2 = L13_2.label
      if L15_2 then
        goto lbl_116
      end
    end
    L15_2 = nil
    ::lbl_116::
    if L13_2 then
      L16_2 = L13_2.coords
      if L16_2 then
        goto lbl_122
      end
    end
    L16_2 = nil
    ::lbl_122::
    L10_2.coords = L16_2
    L10_2.garageLabel = L15_2
    L10_2.garage = L14_2
    L14_2 = L3_1
    L15_2 = L9_2.nickname
    L14_2 = L14_2(L15_2)
    L10_2.nickname = L14_2
    L14_2 = #L3_2
    L14_2 = L14_2 + 1
    L3_2[L14_2] = L10_2
  end
  return L3_2
end
L28_1.list = L29_1
function L29_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L28_1.track = L29_1
L25_1(L26_1, L27_1, L28_1)
function L25_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = ipairs
  L2_2 = {}
  L3_2 = {}
  L4_2 = "conf/public_garage.lua"
  L5_2 = "garagecoord"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L4_2 = {}
  L5_2 = "conf/impound.lua"
  L6_2 = "impoundcoord"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L0_1.readResourceTable
    L8_2 = "renzu_garage"
    L9_2 = L6_2[1]
    L10_2 = L6_2[2]
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = ipairs
      L9_2 = L7_2
      L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
      for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
        L14_2 = type
        L15_2 = L13_2
        L14_2 = L14_2(L15_2)
        if "table" == L14_2 then
          L14_2 = tostring
          L15_2 = L13_2.garage
          L14_2 = L14_2(L15_2)
          L15_2 = tostring
          L16_2 = A0_2
          L15_2 = L15_2(L16_2)
          if L14_2 == L15_2 then
            L14_2 = {}
            L15_2 = L13_2.name
            if not L15_2 then
              L15_2 = L13_2.garage
            end
            L14_2.label = L15_2
            L15_2 = L13_1
            L16_2 = {}
            L17_2 = L13_2.garage_x
            L16_2.x = L17_2
            L17_2 = L13_2.garage_y
            L16_2.y = L17_2
            L17_2 = L13_2.garage_z
            L16_2.z = L17_2
            L15_2 = L15_2(L16_2)
            L14_2.coords = L15_2
            return L14_2
          end
        end
      end
    end
  end
  L1_2 = nil
  return L1_2
end
L26_1 = L0_1.define
L27_1 = "garage"
L28_1 = "renzu_garage"
L29_1 = {}
L29_1.label = "renzu_garage"
L30_1 = {}
L31_1 = "renzu_garage"
L30_1[1] = L31_1
L29_1.resources = L30_1
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3
    L0_3 = GlobalState
    L0_3 = L0_3.VehicleNickNames
    return L0_3
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 and L3_2 then
      goto lbl_16
    end
  end
  L4_2 = {}
  L3_2 = L4_2
  ::lbl_16::
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L6_1
  L8_2 = A1_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L5_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    L13_2 = FW
    L13_2 = L13_2.name
    if "esx" == L13_2 then
      L13_2 = L11_2.stored
      if L13_2 then
        goto lbl_37
      end
    end
    L13_2 = L11_2.state
    ::lbl_37::
    L14_2 = L4_1
    L15_2 = L11_2.impound
    L14_2 = L14_2(L15_2)
    if L14_2 then
      L14_2 = "impound"
      if L14_2 then
        goto lbl_54
      end
    end
    L14_2 = L4_1
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    if L14_2 then
      L14_2 = "garage"
      if L14_2 then
        goto lbl_54
      end
    end
    L14_2 = "out"
    ::lbl_54::
    L12_2.state = L14_2
    L14_2 = L3_1
    L15_2 = FW
    L15_2 = L15_2.name
    if "esx" == L15_2 then
      L15_2 = L11_2.garage_id
      if L15_2 then
        goto lbl_64
      end
    end
    L15_2 = L11_2.garage
    ::lbl_64::
    L14_2 = L14_2(L15_2)
    if L14_2 then
      L15_2 = L4_2[L14_2]
      if nil == L15_2 then
        L15_2 = L25_1
        L16_2 = L14_2
        L15_2 = L15_2(L16_2)
        if not L15_2 then
          L15_2 = false
        end
        L4_2[L14_2] = L15_2
      end
    end
    if L14_2 then
      L15_2 = L4_2[L14_2]
      if L15_2 then
        goto lbl_83
      end
    end
    L15_2 = nil
    ::lbl_83::
    L16_2 = L14_2
    if L15_2 then
      L17_2 = L15_2.label
      if L17_2 then
        goto lbl_90
      end
    end
    L17_2 = nil
    ::lbl_90::
    if L15_2 then
      L18_2 = L15_2.coords
      if L18_2 then
        goto lbl_96
      end
    end
    L18_2 = nil
    ::lbl_96::
    L12_2.coords = L18_2
    L12_2.garageLabel = L17_2
    L12_2.garage = L16_2
    L16_2 = L11_2.plate
    L16_2 = L3_2[L16_2]
    if not L16_2 then
      L16_2 = L0_1.plate
      L17_2 = L11_2.plate
      L16_2 = L16_2(L17_2)
      L16_2 = L3_2[L16_2]
    end
    L17_2 = type
    L18_2 = L16_2
    L17_2 = L17_2(L18_2)
    L17_2 = L16_2 or L17_2
    if "string" ~= L17_2 or "" == L16_2 or not L16_2 then
      L17_2 = nil
    end
    L12_2.nickname = L17_2
    L17_2 = #L5_2
    L17_2 = L17_2 + 1
    L5_2[L17_2] = L12_2
  end
  return L5_2
end
L29_1.list = L30_1
function L30_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = L1_1
    L0_3 = L0_3()
    L1_3 = L2_1
    L2_3 = "SELECT park_coord FROM %s WHERE TRIM(UPPER(plate)) = ? AND isparked = 1 LIMIT 1"
    L3_3 = L2_3
    L2_3 = L2_3.format
    L4_3 = L0_3
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = {}
    L4_3 = L0_1.plate
    L5_3 = A2_2
    L4_3 = L4_3(L5_3)
    L5_3 = L4_3
    L4_3 = L4_3.upper
    L4_3, L5_3 = L4_3(L5_3)
    L3_3[1] = L4_3
    L3_3[2] = L5_3
    L1_3 = L1_3(L2_3, L3_3)
    if L1_3 then
      L2_3 = L1_3[1]
      if L2_3 then
        L2_3 = L0_1.decode
        L3_3 = L1_3[1]
        L3_3 = L3_3.park_coord
        L2_3 = L2_3(L3_3)
        if L2_3 then
          goto lbl_29
        end
      end
    end
    L2_3 = nil
    ::lbl_29::
    return L2_3
  end
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L29_1.track = L30_1
L26_1(L27_1, L28_1, L29_1)
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2.interaction
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.interaction
    L1_2 = L1_2.coords
    if L1_2 then
      goto lbl_18
    end
  end
  L1_2 = nil
  ::lbl_18::
  L2_2 = type
  L3_2 = A0_2.zones
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.zones
    L2_2 = L2_2.points
    if L2_2 then
      goto lbl_28
    end
  end
  L2_2 = nil
  ::lbl_28::
  L3_2 = L13_1
  L4_2 = L1_2
  L5_2 = L12_1
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L6_2 = type
  L7_2 = A0_2.spawnPoint
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A0_2.spawnPoint
    L6_2 = L6_2[1]
    if L6_2 then
      goto lbl_43
    end
  end
  L6_2 = nil
  ::lbl_43::
  return L3_2(L4_2, L5_2, L6_2)
end
L27_1 = L0_1.define
L28_1 = "garage"
L29_1 = "rhd_garage"
L30_1 = {}
L30_1.label = "rhd_garage"
L31_1 = {}
L32_1 = "rhd_garage"
L31_1[1] = L32_1
L30_1.resources = L31_1
function L31_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = L8_1
  L3_2 = "rhd_garage"
  L4_2 = "Garage"
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = {}
  L4_2 = nil
  L5_2 = nil
  L6_2 = type
  L7_2 = L2_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = pairs
    L7_2 = L2_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = type
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        L12_2 = L11_2.impound
        if true == L12_2 then
          L12_2 = #L3_2
          L12_2 = L12_2 + 1
          L13_2 = {}
          L13_2.name = L10_2
          L14_2 = L26_1
          L15_2 = L11_2
          L14_2 = L14_2(L15_2)
          L13_2.coords = L14_2
          L3_2[L12_2] = L13_2
        end
      end
    end
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_1
  L9_2 = "SELECT plate, garage FROM police_impound WHERE citizenid = ?"
  L10_2 = {}
  L11_2 = A1_2
  L10_2[1] = L11_2
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = {}
  end
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.plate
    if L13_2 then
      L13_2 = L0_1.plateKey
      L14_2 = L12_2.plate
      L13_2 = L13_2(L14_2)
      L14_2 = L12_2.garage
      L6_2[L13_2] = L14_2
    end
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L6_1
  L10_2 = A1_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L9_2(L10_2)
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L5_1
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    L15_2 = tonumber
    L16_2 = FW
    L16_2 = L16_2.name
    if "esx" == L16_2 then
      L16_2 = L13_2.stored
      if L16_2 then
        goto lbl_90
      end
    end
    L16_2 = L13_2.state
    ::lbl_90::
    L15_2 = L15_2(L16_2)
    if not L15_2 then
      L15_2 = 0
    end
    L16_2 = L3_1
    L17_2 = L13_2.garage
    L16_2 = L16_2(L17_2)
    if 1 == L15_2 then
      L14_2.state = "garage"
    elseif 2 == L15_2 then
      L14_2.state = "impound"
      L17_2 = L3_1
      L18_2 = L0_1.plateKey
      L19_2 = L13_2.plate
      L18_2 = L18_2(L19_2)
      L18_2 = L6_2[L18_2]
      L17_2 = L17_2(L18_2)
      L16_2 = L17_2 or L16_2
      if not L17_2 then
      end
    else
      if not L5_2 then
        L17_2 = L9_1
        L17_2 = L17_2()
        L5_2 = L17_2
      end
      L17_2 = L0_1.plateKey
      L18_2 = L13_2.plate
      L17_2 = L17_2(L18_2)
      L17_2 = L5_2[L17_2]
      if L17_2 then
        L14_2.state = "out"
      else
        L14_2.state = "impound"
        if not L4_2 then
          L17_2 = L10_1
          L18_2 = A0_2
          L17_2 = L17_2(L18_2)
          L4_2 = L17_2 or L4_2
          if not L17_2 then
            L4_2 = false
          end
        end
        L17_2 = L11_1
        L18_2 = L3_2
        L19_2 = L4_2 or L19_2
        if not L4_2 then
          L19_2 = nil
        end
        L17_2 = L17_2(L18_2, L19_2)
        if L17_2 then
          L18_2 = tostring
          L19_2 = L17_2.name
          L18_2 = L18_2(L19_2)
          L16_2 = L18_2
        end
      end
    end
    if L16_2 then
      L17_2 = type
      L18_2 = L2_2
      L17_2 = L17_2(L18_2)
      if "table" == L17_2 then
        L17_2 = L2_2[L16_2]
        if L17_2 then
          goto lbl_158
        end
      end
    end
    L17_2 = nil
    ::lbl_158::
    L18_2 = L16_2
    L19_2 = L26_1
    L20_2 = L17_2
    L19_2 = L19_2(L20_2)
    L14_2.coords = L19_2
    L14_2.garage = L18_2
    L18_2 = L3_1
    L19_2 = L13_2.vehicle_name
    L18_2 = L18_2(L19_2)
    L14_2.nickname = L18_2
    L18_2 = #L7_2
    L18_2 = L18_2 + 1
    L7_2[L18_2] = L14_2
  end
  return L7_2
end
L30_1.list = L31_1
function L31_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L30_1.track = L31_1
L27_1(L28_1, L29_1, L30_1)
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    return L2_2
  end
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.Type
      if not L9_2 then
        L9_2 = "car"
      end
      if L9_2 == A1_2 then
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L10_2 = {}
        L11_2 = L13_1
        L12_2 = L8_2.Position
        L13_2 = L8_2.PedPosition
        L14_2 = L8_2.SpawnPosition
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        L10_2.coords = L11_2
        L2_2[L9_2] = L10_2
      end
    end
  end
  return L2_2
end
L28_1 = L0_1.define
L29_1 = "garage"
L30_1 = "lunar_garage"
L31_1 = {}
L31_1.label = "lunar_garage"
L32_1 = {}
L33_1 = "lunar_garage"
L32_1[1] = L33_1
L31_1.resources = L32_1
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = L0_1.readResourceTable
  L3_2 = "lunar_garage"
  L4_2 = "config/config.lua"
  L5_2 = "Config.Garages"
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L0_1.readResourceTable
  L4_2 = "lunar_garage"
  L5_2 = "config/config.lua"
  L6_2 = "Config.Impounds"
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L0_1.readResourceTable
  L5_2 = "lunar_garage"
  L6_2 = "config/config.lua"
  L7_2 = "Config.Blips"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = nil
  L6_2 = nil
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L6_1
  L10_2 = A1_2
  L11_2 = " AND job IS NULL"
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L9_2(L10_2, L11_2)
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L3_1
    L15_2 = L13_2.job
    L14_2 = L14_2(L15_2)
    if not L14_2 then
      L14_2 = L5_1
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      L15_2 = L3_1
      L16_2 = L13_2.type
      L15_2 = L15_2(L16_2)
      if not L15_2 then
        L15_2 = "car"
      end
      L16_2 = L4_1
      L17_2 = L13_2.stored
      L16_2 = L16_2(L17_2)
      if L16_2 then
        L14_2.state = "garage"
      else
        if not L5_2 then
          L16_2 = L9_1
          L16_2 = L16_2()
          L5_2 = L16_2
        end
        L16_2 = L0_1.plateKey
        L17_2 = L13_2.plate
        L16_2 = L16_2(L17_2)
        L16_2 = L5_2[L16_2]
        if L16_2 then
          L16_2 = "out"
          if L16_2 then
            goto lbl_62
          end
        end
        L16_2 = "impound"
        ::lbl_62::
        L14_2.state = L16_2
      end
      L16_2 = L14_2.state
      if "out" ~= L16_2 then
        L16_2 = L14_2.state
        if "garage" == L16_2 then
          L16_2 = "Garage"
          if L16_2 then
            goto lbl_73
          end
        end
        L16_2 = "Impound"
        ::lbl_73::
        if not L6_2 then
          L17_2 = L10_1
          L18_2 = A0_2
          L17_2 = L17_2(L18_2)
          L6_2 = L17_2 or L6_2
          if not L17_2 then
            L6_2 = false
          end
        end
        L17_2 = L11_1
        L18_2 = L27_1
        L19_2 = L14_2.state
        L19_2 = L2_2 or L19_2
        if "garage" ~= L19_2 or not L2_2 then
          L19_2 = L3_2
        end
        L20_2 = L15_2
        L18_2 = L18_2(L19_2, L20_2)
        L19_2 = L6_2 or L19_2
        if not L6_2 then
          L19_2 = nil
        end
        L17_2 = L17_2(L18_2, L19_2)
        L18_2 = type
        L19_2 = L4_2
        L18_2 = L18_2(L19_2)
        if "table" == L18_2 then
          L18_2 = type
          L19_2 = L4_2[L15_2]
          L18_2 = L18_2(L19_2)
          if "table" == L18_2 then
            L18_2 = L4_2[L15_2]
            L18_2 = L18_2[L16_2]
            if L18_2 then
              goto lbl_110
            end
          end
        end
        L18_2 = nil
        ::lbl_110::
        L19_2 = type
        L20_2 = L18_2
        L19_2 = L19_2(L20_2)
        if "table" == L19_2 then
          L19_2 = L18_2.Name
          if L19_2 then
            goto lbl_119
          end
        end
        L19_2 = nil
        ::lbl_119::
        L14_2.garageLabel = L19_2
        if L17_2 then
          L19_2 = L17_2.coords
          if L19_2 then
            goto lbl_126
          end
        end
        L19_2 = nil
        ::lbl_126::
        L14_2.coords = L19_2
      end
      L16_2 = #L7_2
      L16_2 = L16_2 + 1
      L7_2[L16_2] = L14_2
    end
  end
  return L7_2
end
L31_1.list = L32_1
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L31_1.track = L32_1
function L32_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.stored = 0
  return L0_2
end
L31_1.deliverOut = L32_1
L28_1(L29_1, L30_1, L31_1)
L28_1 = L0_1.define
L29_1 = "garage"
L30_1 = "MojiaGarages"
L31_1 = {}
L31_1.label = "MojiaGarages"
L32_1 = {}
L33_1 = "MojiaGarages"
L32_1[1] = L33_1
L31_1.resources = L32_1
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = L0_1.readResourceTable
  L3_2 = "MojiaGarages"
  L4_2 = "config.lua"
  L5_2 = "Garages"
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 or not L2_2 then
    L3_2 = {}
    L2_2 = L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L3_2[0] = L4_2
  L4_2 = {}
  L3_2[2] = L4_2
  L4_2 = pairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = tonumber
      L11_2 = L9_2.garastate
      L10_2 = L10_2(L11_2)
      if L10_2 then
        goto lbl_39
      end
    end
    L10_2 = nil
    ::lbl_39::
    if L10_2 then
      L11_2 = L3_2[L10_2]
      if L11_2 then
        L11_2 = L3_2[L10_2]
        L12_2 = L3_2[L10_2]
        L12_2 = #L12_2
        L12_2 = L12_2 + 1
        L13_2 = {}
        L13_2.key = L8_2
        L14_2 = L9_2.label
        L13_2.label = L14_2
        L14_2 = L13_1
        L15_2 = L9_2.blippoint
        L14_2 = L14_2(L15_2)
        L13_2.coords = L14_2
        L11_2[L12_2] = L13_2
      end
    end
  end
  L4_2 = nil
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L6_1
  L8_2 = A1_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L5_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    L13_2 = L24_1
    L14_2 = L11_2.state
    L15_2 = L11_2.depotprice
    L13_2 = L13_2(L14_2, L15_2)
    L12_2.state = L13_2
    L13_2 = L3_1
    L14_2 = L11_2.garage
    L13_2 = L13_2(L14_2)
    L14_2 = nil
    L15_2 = nil
    L16_2 = L12_2.state
    if "garage" == L16_2 then
      if L13_2 then
        L16_2 = L2_2[L13_2]
        if L16_2 then
          goto lbl_92
        end
      end
      L16_2 = nil
      ::lbl_92::
      L17_2 = type
      L18_2 = L16_2
      L17_2 = L17_2(L18_2)
      if "table" == L17_2 then
        L17_2 = L16_2.label
        if L17_2 then
          goto lbl_101
        end
      end
      L17_2 = nil
      ::lbl_101::
      L18_2 = type
      L19_2 = L16_2
      L18_2 = L18_2(L19_2)
      if "table" == L18_2 then
        L18_2 = L13_1
        L19_2 = L16_2.blippoint
        L18_2 = L18_2(L19_2)
        if L18_2 then
          goto lbl_112
          L15_2 = L18_2 or L15_2
        end
      end
      L15_2 = nil
      ::lbl_112::
      L14_2 = L17_2
    else
      L16_2 = L12_2.state
      if "impound" == L16_2 then
        if not L4_2 then
          L16_2 = L10_1
          L17_2 = A0_2
          L16_2 = L16_2(L17_2)
          L4_2 = L16_2 or L4_2
          if not L16_2 then
            L4_2 = false
          end
        end
        L16_2 = L11_1
        L17_2 = tonumber
        L18_2 = L11_2.state
        L17_2 = L17_2(L18_2)
        if 2 == L17_2 then
          L17_2 = 2
          if L17_2 then
            goto lbl_135
          end
        end
        L17_2 = 0
        ::lbl_135::
        L17_2 = L3_2[L17_2]
        L18_2 = L4_2 or L18_2
        if not L4_2 then
          L18_2 = nil
        end
        L16_2 = L16_2(L17_2, L18_2)
        if L16_2 then
          L17_2 = tostring
          L18_2 = L16_2.key
          L17_2 = L17_2(L18_2)
          L18_2 = L16_2.label
          L15_2 = L16_2.coords
          L14_2 = L18_2
          L13_2 = L17_2
        end
      end
    end
    L16_2 = L13_2
    L17_2 = L14_2
    L12_2.coords = L15_2
    L12_2.garageLabel = L17_2
    L12_2.garage = L16_2
    L16_2 = #L5_2
    L16_2 = L16_2 + 1
    L5_2[L16_2] = L12_2
  end
  return L5_2
end
L31_1.list = L32_1
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = L2_1
    L1_3 = "SELECT posX, posY, posZ FROM player_vehicles WHERE TRIM(UPPER(plate)) = ? AND state = 0 LIMIT 1"
    L2_3 = {}
    L3_3 = L0_1.plate
    L4_3 = A2_2
    L3_3 = L3_3(L4_3)
    L4_3 = L3_3
    L3_3 = L3_3.upper
    L3_3, L4_3 = L3_3(L4_3)
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L0_3 = L0_3(L1_3, L2_3)
    L1_3 = L0_3 or L1_3
    if L0_3 then
      L1_3 = L0_3[1]
    end
    if L1_3 then
      L2_3 = {}
      L3_3 = L1_3.posX
      L2_3.x = L3_3
      L3_3 = L1_3.posY
      L2_3.y = L3_3
      L3_3 = L1_3.posZ
      L2_3.z = L3_3
      if L2_3 then
        goto lbl_28
      end
    end
    L2_3 = nil
    ::lbl_28::
    return L2_3
  end
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L31_1.track = L32_1
L28_1(L29_1, L30_1, L31_1)
L28_1 = L0_1.define
L29_1 = "garage"
L30_1 = "t1ger_garage"
L31_1 = {}
L31_1.label = "t1ger_garage"
L32_1 = {}
L33_1 = "t1ger_garage"
L32_1[1] = L33_1
L31_1.resources = L32_1
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = "config.lua"
  L3_2 = L0_1.readResourceTable
  L4_2 = "t1ger_garage"
  L5_2 = L2_2
  L6_2 = "Config.Garage.Locations"
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L0_1.readResourceTable
  L5_2 = "t1ger_garage"
  L6_2 = L2_2
  L7_2 = "Config.Impound.Locations"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = L0_1.readResourceTable
  L6_2 = "t1ger_garage"
  L7_2 = L2_2
  L8_2 = "Config.Impound.Seize"
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = L0_1.readResourceTable
  L7_2 = "t1ger_garage"
  L8_2 = L2_2
  L9_2 = "Config.Garage.UseNames"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  function L7_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L3_3 = type
    L4_3 = A0_3
    L3_3 = L3_3(L4_3)
    if "table" ~= L3_3 then
      L3_3 = nil
      return L3_3
    end
    L3_3 = pairs
    L4_3 = A0_3
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = type
      L10_3 = L8_3
      L9_3 = L9_3(L10_3)
      if "table" == L9_3 then
        L9_3 = L8_3.type
        if not L9_3 then
          L9_3 = "car"
        end
        if L9_3 == A2_3 then
          if nil ~= A1_3 then
            L9_3 = tostring
            L10_3 = L8_3.name
            L9_3 = L9_3(L10_3)
            L10_3 = tostring
            L11_3 = A1_3
            L10_3 = L10_3(L11_3)
            if L9_3 ~= L10_3 then
              goto lbl_34
            end
          end
          return L8_3
        end
      end
      ::lbl_34::
    end
    L3_3 = nil
    return L3_3
  end
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L6_1
  L11_2 = A1_2
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L10_2(L11_2)
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L5_1
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    L16_2 = L3_1
    L17_2 = L14_2.type
    L16_2 = L16_2(L17_2)
    if not L16_2 then
      L16_2 = "car"
    end
    L17_2 = L3_1
    L18_2 = L14_2.garage
    L17_2 = L17_2(L18_2)
    L18_2 = nil
    L19_2 = L4_1
    L20_2 = L14_2.seized
    L19_2 = L19_2(L20_2)
    if L19_2 then
      L19_2 = "impound"
      L15_2.garage = "impound"
      L15_2.state = L19_2
      L19_2 = type
      L20_2 = L5_2
      L19_2 = L19_2(L20_2)
      if "table" ~= L19_2 then
        goto lbl_106
      end
      L19_2 = L13_1
      L20_2 = L5_2.pos
      L19_2 = L19_2(L20_2)
      L15_2.coords = L19_2
      L19_2 = type
      L20_2 = L5_2.blip
      L19_2 = L19_2(L20_2)
      if "table" == L19_2 then
        L19_2 = L5_2.blip
        L19_2 = L19_2.name
        if L19_2 then
          goto lbl_71
        end
      end
      L19_2 = nil
      ::lbl_71::
      L15_2.garageLabel = L19_2
    elseif "impound" == L17_2 then
      L19_2 = "impound"
      L15_2.garage = "impound"
      L15_2.state = L19_2
      L19_2 = L7_2
      L20_2 = L4_2
      L21_2 = nil
      L22_2 = L16_2
      L19_2 = L19_2(L20_2, L21_2, L22_2)
      L18_2 = L19_2
    else
      L19_2 = L4_1
      L20_2 = L14_2.state
      L19_2 = L19_2(L20_2)
      if L19_2 then
        L19_2 = "garage"
        if L19_2 then
          goto lbl_94
        end
      end
      L19_2 = "out"
      ::lbl_94::
      L15_2.state = L19_2
      L15_2.garage = L17_2
      if L17_2 and "private" ~= L17_2 then
        L19_2 = L7_2
        L20_2 = L3_2
        L21_2 = L17_2
        L22_2 = L16_2
        L19_2 = L19_2(L20_2, L21_2, L22_2)
        L18_2 = L19_2
      end
    end
    ::lbl_106::
    if L18_2 then
      L19_2 = L15_2.coords
      if not L19_2 then
        L19_2 = L13_1
        L20_2 = L18_2.pos
        L19_2 = L19_2(L20_2)
      end
      L15_2.coords = L19_2
      L19_2 = type
      L20_2 = L18_2.blip
      L19_2 = L19_2(L20_2)
      if "table" == L19_2 then
        L19_2 = L18_2.blip
        L19_2 = L19_2.name
        if L19_2 then
          goto lbl_125
        end
      end
      L19_2 = nil
      ::lbl_125::
      L20_2 = L15_2.state
      if "garage" == L20_2 and L19_2 and false ~= L6_2 then
        L20_2 = L19_2
        L21_2 = ": "
        L22_2 = tostring
        L23_2 = L17_2
        L22_2 = L22_2(L23_2)
        L20_2 = L20_2 .. L21_2 .. L22_2
        L15_2.garageLabel = L20_2
      else
        L20_2 = L15_2.garageLabel
        if not L20_2 then
          L20_2 = L19_2
        end
        L15_2.garageLabel = L20_2
      end
    end
    L19_2 = L15_2.fuel
    if nil == L19_2 then
      L19_2 = L0_1.num
      L20_2 = L14_2.fuel
      L19_2 = L19_2(L20_2)
      L15_2.fuel = L19_2
    end
    L19_2 = #L8_2
    L19_2 = L19_2 + 1
    L8_2[L19_2] = L15_2
  end
  return L8_2
end
L31_1.list = L32_1
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L31_1.track = L32_1
function L32_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.state = 0
  return L0_2
end
L31_1.deliverOut = L32_1
L28_1(L29_1, L30_1, L31_1)
L28_1 = L0_1.define
L29_1 = "garage"
L30_1 = "esx_advancedgarage"
L31_1 = {}
L31_1.label = "esx_advancedgarage"
L32_1 = {}
L33_1 = "esx_advancedgarage"
L32_1[1] = L33_1
L31_1.resources = L32_1
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L6_1
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L5_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L10_2 = tonumber
    L11_2 = L8_2.stored
    L10_2 = L10_2(L11_2)
    if 1 ~= L10_2 then
      L10_2 = L8_2.stored
      if true ~= L10_2 then
        goto lbl_23
      end
    end
    L10_2 = "garage"
    ::lbl_23::
    if not L10_2 then
      L10_2 = "out"
    end
    L9_2.state = L10_2
    L10_2 = L8_2.garage
    if nil ~= L10_2 then
      L10_2 = L8_2.garage
      if "all" ~= L10_2 then
        L10_2 = L8_2.garage
        L9_2.garage = L10_2
      end
    end
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L2_2[L10_2] = L9_2
  end
  return L2_2
end
L31_1.list = L32_1
L28_1(L29_1, L30_1, L31_1)
L28_1 = L0_1.define
L29_1 = "garage"
L30_1 = "qbx_garages"
L31_1 = {}
L31_1.label = "qbx_garages"
L32_1 = {}
L33_1 = "qbx_garages"
L34_1 = "qbx_vehicles"
L32_1[1] = L33_1
L32_1[2] = L34_1
L31_1.resources = L32_1
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = L0_1.callExport
  L3_2 = "qbx_vehicles"
  L4_2 = "GetPlayerVehicles"
  L5_2 = {}
  L5_2.citizenid = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_22
    end
  end
  L4_2 = error
  L5_2 = "qbx_vehicles:GetPlayerVehicles failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_22::
  L4_2 = L0_1.callExport
  L5_2 = "qbx_garages"
  L6_2 = "GetGarages"
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 and L5_2 then
      goto lbl_38
    end
  end
  L6_2 = {}
  L5_2 = L6_2
  ::lbl_38::
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_1
  L9_2 = "SELECT id, plate, fuel, engine, body, drivingdistance FROM player_vehicles WHERE citizenid = ?"
  L10_2 = {}
  L11_2 = A1_2
  L10_2[1] = L11_2
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = {}
  end
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.id
    L6_2[L13_2] = L12_2
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L3_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = type
    L15_2 = L13_2.props
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = L13_2.props
      if L14_2 then
        goto lbl_75
      end
    end
    L14_2 = {}
    ::lbl_75::
    L15_2 = L13_2.id
    L15_2 = L6_2[L15_2]
    if not L15_2 then
      L15_2 = {}
    end
    L16_2 = L13_2.garage
    if L16_2 then
      L16_2 = L13_2.garage
      L16_2 = L5_2[L16_2]
      if L16_2 then
        goto lbl_89
      end
    end
    L16_2 = nil
    ::lbl_89::
    L17_2 = type
    L18_2 = L16_2
    L17_2 = L17_2(L18_2)
    if "table" == L17_2 then
      L17_2 = type
      L18_2 = L16_2.accessPoints
      L17_2 = L17_2(L18_2)
      if "table" == L17_2 then
        L17_2 = L16_2.accessPoints
        L17_2 = L17_2[1]
        if L17_2 then
          goto lbl_104
        end
      end
    end
    L17_2 = nil
    ::lbl_104::
    L18_2 = #L7_2
    L18_2 = L18_2 + 1
    L19_2 = {}
    L20_2 = L15_2.plate
    if not L20_2 then
      L20_2 = L14_2.plate
    end
    L19_2.plate = L20_2
    L20_2 = L13_2.modelName
    L19_2.model = L20_2
    L20_2 = tonumber
    L21_2 = L14_2.model
    L20_2 = L20_2(L21_2)
    L19_2.hash = L20_2
    L20_2 = L13_2.garage
    L19_2.garage = L20_2
    L20_2 = type
    L21_2 = L16_2
    L20_2 = L20_2(L21_2)
    if "table" == L20_2 then
      L20_2 = L16_2.label
      if L20_2 then
        goto lbl_131
      end
    end
    L20_2 = nil
    ::lbl_131::
    L19_2.garageLabel = L20_2
    L20_2 = L0_1.vehState
    L21_2 = L13_2.state
    L20_2 = L20_2(L21_2)
    L19_2.state = L20_2
    L20_2 = L0_1.num
    L21_2 = L15_2.fuel
    L20_2 = L20_2(L21_2)
    if not L20_2 then
      L20_2 = L0_1.num
      L21_2 = L14_2.fuelLevel
      L20_2 = L20_2(L21_2)
    end
    L19_2.fuel = L20_2
    L20_2 = L0_1.num
    L21_2 = L15_2.engine
    L20_2 = L20_2(L21_2)
    if not L20_2 then
      L20_2 = L0_1.num
      L21_2 = L14_2.engineHealth
      L20_2 = L20_2(L21_2)
    end
    L19_2.engine = L20_2
    L20_2 = L0_1.num
    L21_2 = L15_2.body
    L20_2 = L20_2(L21_2)
    if not L20_2 then
      L20_2 = L0_1.num
      L21_2 = L14_2.bodyHealth
      L20_2 = L20_2(L21_2)
    end
    L19_2.body = L20_2
    L20_2 = L0_1.num
    L21_2 = L15_2.drivingdistance
    L20_2 = L20_2(L21_2)
    L19_2.mileage = L20_2
    if L17_2 then
      L20_2 = L0_1.xyz
      L21_2 = L17_2.coords
      L20_2 = L20_2(L21_2)
      if L20_2 then
        goto lbl_175
      end
    end
    L20_2 = nil
    ::lbl_175::
    L19_2.coords = L20_2
    L7_2[L18_2] = L19_2
  end
  return L7_2
end
L31_1.list = L32_1
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L31_1.track = L32_1
function L32_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L6_2 = A5_2 or nil
  if A5_2 then
    L6_2 = tonumber
    L7_2 = A5_2.id
    L6_2 = L6_2(L7_2)
  end
  if L6_2 and A3_2 then
    L7_2 = Entity
    L8_2 = A3_2
    L7_2 = L7_2(L8_2)
    L7_2 = L7_2.state
    L8_2 = L7_2
    L7_2 = L7_2.set
    L9_2 = "vehicleid"
    L10_2 = L6_2
    L11_2 = false
    L7_2(L8_2, L9_2, L10_2, L11_2)
  end
end
L31_1.deliverAfter = L32_1
L28_1(L29_1, L30_1, L31_1)
L28_1 = L0_1.define
L29_1 = "garage"
L30_1 = "qb-garages"
L31_1 = {}
L31_1.label = "qb-garages"
L32_1 = {}
L33_1 = "qb-garages"
L32_1[1] = L33_1
L31_1.resources = L32_1
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = L0_1.callExport
  L3_2 = "qb-garages"
  L4_2 = "getAllGarages"
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  L4_2 = {}
  L5_2 = nil
  if L2_2 then
    L6_2 = type
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = ipairs
      L7_2 = L3_2
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = type
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        if "table" == L12_2 then
          L12_2 = L11_2.name
          if L12_2 then
            L12_2 = L11_2.name
            L4_2[L12_2] = L11_2
            L12_2 = L11_2.type
            if "depot" == L12_2 then
              if nil ~= L5_2 then
                L12_2 = L11_2.vehicle
                if "car" ~= L12_2 then
                  goto lbl_41
                end
                L12_2 = L5_2.vehicle
                if "car" == L12_2 then
                  goto lbl_41
                end
              end
              L5_2 = L11_2
            end
          end
        end
        ::lbl_41::
      end
    end
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_1
  L9_2 = "SELECT plate, depotprice FROM player_vehicles WHERE citizenid = ? AND depotprice > 0"
  L10_2 = {}
  L11_2 = A1_2
  L10_2[1] = L11_2
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = {}
  end
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.plate
    if L13_2 then
      L13_2 = L12_2.plate
      L14_2 = L12_2.depotprice
      L6_2[L13_2] = L14_2
    end
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = FW
  L9_2 = L9_2.GetVehicles
  L10_2 = A1_2
  L11_2 = true
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L9_2(L10_2, L11_2)
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.state
    if "out" == L14_2 then
      L15_2 = tonumber
      L16_2 = L13_2.plate
      L16_2 = L6_2[L16_2]
      L15_2 = L15_2(L16_2)
      if not L15_2 then
        L15_2 = 0
      end
      if L15_2 > 0 then
        L14_2 = "impound"
      end
    end
    L15_2 = L13_2.garage
    if L15_2 then
      L15_2 = L13_2.garage
      L15_2 = L4_2[L15_2]
      if L15_2 then
        goto lbl_100
      end
    end
    L15_2 = nil
    ::lbl_100::
    if "impound" == L14_2 and L5_2 then
      if L15_2 then
        L16_2 = L15_2.type
        if "depot" == L16_2 then
          goto lbl_110
        end
      end
      L15_2 = L5_2
    end
    ::lbl_110::
    if not L15_2 then
      L16_2 = L13_2.garage
      if L16_2 then
        L16_2 = type
        L17_2 = Config
        L17_2 = L17_2.Garages
        L16_2 = L16_2(L17_2)
        if "table" == L16_2 then
          L16_2 = Config
          L16_2 = L16_2.Garages
          L17_2 = L13_2.garage
          L16_2 = L16_2[L17_2]
          if L16_2 then
            goto lbl_128
          end
        end
      end
    end
    L16_2 = nil
    ::lbl_128::
    L17_2 = #L7_2
    L17_2 = L17_2 + 1
    L18_2 = {}
    L19_2 = L13_2.plate
    L18_2.plate = L19_2
    L19_2 = L13_2.model
    L18_2.model = L19_2
    L19_2 = L13_2.hash
    L18_2.hash = L19_2
    L19_2 = L13_2.label
    L18_2.label = L19_2
    if L15_2 then
      L19_2 = L15_2.name
      if L19_2 then
        goto lbl_147
      end
    end
    L19_2 = L13_2.garage
    ::lbl_147::
    L18_2.garage = L19_2
    if L15_2 then
      L19_2 = L15_2.label
      if L19_2 then
        goto lbl_154
      end
    end
    L19_2 = nil
    ::lbl_154::
    L18_2.garageLabel = L19_2
    L18_2.state = L14_2
    L19_2 = L13_2.fuel
    L18_2.fuel = L19_2
    L19_2 = L13_2.engine
    L18_2.engine = L19_2
    L19_2 = L13_2.body
    L18_2.body = L19_2
    if L15_2 then
      L19_2 = L0_1.xyz
      L20_2 = L15_2.takeVehicle
      L19_2 = L19_2(L20_2)
      if L19_2 then
        goto lbl_172
      end
    end
    L19_2 = L0_1.xyz
    L20_2 = L16_2
    L19_2 = L19_2(L20_2)
    ::lbl_172::
    L18_2.coords = L19_2
    L7_2[L17_2] = L18_2
  end
  return L7_2
end
L31_1.list = L32_1
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L31_1.track = L32_1
L28_1(L29_1, L30_1, L31_1)
function L28_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = {}
  L3_2 = "getGarages"
  L4_2 = "getImpounds"
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L8_1
    L8_2 = "esx_garage"
    L9_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2)
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = pairs
      L9_2 = L7_2
      L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
      for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
        L14_2 = type
        L15_2 = L13_2
        L14_2 = L14_2(L15_2)
        if "table" == L14_2 then
          L14_2 = tostring
          L15_2 = L13_2.id
          if not L15_2 then
            L15_2 = L12_2
          end
          L14_2 = L14_2(L15_2)
          L15_2 = {}
          L16_2 = L13_2.label
          if not L16_2 then
            L16_2 = type
            L17_2 = L12_2
            L16_2 = L16_2(L17_2)
            L16_2 = L12_2 or L16_2
            if "string" ~= L16_2 or not L12_2 then
              L16_2 = L14_2
            end
          end
          L15_2.label = L16_2
          L16_2 = L13_1
          L17_2 = L13_2.entryPoint
          L18_2 = L13_2.EntryPoint
          L19_2 = L13_2.getOutPoint
          L20_2 = L13_2.GetOutPoint
          L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
          L15_2.coords = L16_2
          L0_2[L14_2] = L15_2
        end
      end
    end
  end
  return L0_2
end
L29_1 = L0_1.define
L30_1 = "garage"
L31_1 = "esx_garage"
L32_1 = {}
L32_1.label = "esx_garage"
L33_1 = {}
L34_1 = "esx_garage"
L33_1[1] = L34_1
L32_1.resources = L33_1
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L28_1
  L2_2 = L2_2()
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L6_1
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L5_1
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    L11_2 = tonumber
    L12_2 = L9_2.stored
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = L9_2.stored
      if true == L11_2 then
        L11_2 = 1
        if L11_2 then
          goto lbl_26
        end
      end
      L11_2 = 0
    end
    ::lbl_26::
    L12_2 = L3_1
    L13_2 = L9_2.pound
    L12_2 = L12_2(L13_2)
    L13_2 = L3_1
    L14_2 = L9_2.parking
    L13_2 = L13_2(L14_2)
    L14_2 = nil
    if 2 == L11_2 or 1 == L11_2 and L12_2 then
      L15_2 = "impound"
      L14_2 = L12_2
      L10_2.state = L15_2
    elseif 1 == L11_2 then
      L15_2 = "garage"
      L14_2 = L13_2
      L10_2.state = L15_2
    else
      L10_2.state = "out"
    end
    if L14_2 then
      L15_2 = L2_2[L14_2]
      if L15_2 then
        goto lbl_56
      end
    end
    L15_2 = nil
    ::lbl_56::
    L16_2 = L14_2
    if L15_2 then
      L17_2 = L15_2.label
      if L17_2 then
        goto lbl_63
      end
    end
    L17_2 = nil
    ::lbl_63::
    if L15_2 then
      L18_2 = L15_2.coords
      if L18_2 then
        goto lbl_69
      end
    end
    L18_2 = nil
    ::lbl_69::
    L10_2.coords = L18_2
    L10_2.garageLabel = L17_2
    L10_2.garage = L16_2
    L16_2 = L3_1
    L17_2 = L9_2.custom_name
    L16_2 = L16_2(L17_2)
    L10_2.nickname = L16_2
    L16_2 = #L3_2
    L16_2 = L16_2 + 1
    L3_2[L16_2] = L10_2
  end
  return L3_2
end
L32_1.list = L33_1
function L33_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2)
end
L32_1.track = L33_1
L29_1(L30_1, L31_1, L32_1)
