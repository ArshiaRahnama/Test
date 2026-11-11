local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1
L0_1 = CreateThread
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_garage_meta` (
        `plate` VARCHAR(16) NOT NULL, `owner` VARCHAR(64) NOT NULL, `nickname` VARCHAR(40) NULL, `favorite` TINYINT NOT NULL DEFAULT 0,
        PRIMARY KEY (`plate`, `owner`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = L0_2
  L1_2(L2_2)
  L1_2 = pcall
  L2_2 = MigrateTable
  L3_2 = L0_2
  L1_2(L2_2, L3_2)
  L1_2 = FW
  L1_2 = L1_2.WidenColumns
  L2_2 = {}
  L3_2 = {}
  L4_2 = "apex_phone_garage_meta"
  L5_2 = "owner"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L2_2[1] = L3_2
  L1_2(L2_2)
end
L0_1(L1_1)
L0_1 = PhoneIntegrations
L1_1 = {}
L1_1.out = 0
L1_1.garage = 1
L1_1.impound = 2
L2_1 = RPC
L2_1 = L2_1["garage.vehicles"]
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = L0_1.plateKey
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = pcall
  L3_2 = GetAllVehicles
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_20
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_20::
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = pcall
    L11_2 = GetVehicleNumberPlateText
    L12_2 = L9_2
    L10_2, L11_2 = L10_2(L11_2, L12_2)
    if L10_2 then
      L12_2 = L0_1.plateKey
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if L12_2 == L1_2 then
        L12_2 = GetEntityCoords
        L13_2 = L9_2
        L12_2 = L12_2(L13_2)
        L13_2 = {}
        L14_2 = L12_2.x
        L14_2 = L14_2 + 0.0
        L13_2.x = L14_2
        L14_2 = L12_2.y
        L14_2 = L14_2 + 0.0
        L13_2.y = L14_2
        L14_2 = L12_2.z
        L14_2 = L14_2 + 0.0
        L13_2.z = L14_2
        return L13_2
      end
    end
  end
  L4_2 = nil
  return L4_2
end
L4_1 = L0_1.defineBuiltin
L5_1 = "garage"
L6_1 = {}
L6_1.label = "Phone (framework vehicles table)"
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = FW
  L4_2 = L4_2.GetVehicles
  L5_2 = A1_2
  L6_2 = true
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.garage
    if L9_2 then
      L9_2 = Config
      L9_2 = L9_2.Garages
      if L9_2 then
        L9_2 = Config
        L9_2 = L9_2.Garages
        L10_2 = L8_2.garage
        L9_2 = L9_2[L10_2]
      end
    end
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2.plate
    L11_2.plate = L12_2
    L12_2 = L8_2.model
    L11_2.model = L12_2
    L12_2 = L8_2.hash
    L11_2.hash = L12_2
    L12_2 = L8_2.label
    L11_2.label = L12_2
    L12_2 = L8_2.garage
    L11_2.garage = L12_2
    L12_2 = L8_2.state
    L11_2.state = L12_2
    L12_2 = L8_2.fuel
    L11_2.fuel = L12_2
    L12_2 = L8_2.engine
    L11_2.engine = L12_2
    L12_2 = L8_2.body
    L11_2.body = L12_2
    if L9_2 then
      L12_2 = {}
      L13_2 = L9_2.x
      L12_2.x = L13_2
      L13_2 = L9_2.y
      L12_2.y = L13_2
      if L12_2 then
        goto lbl_56
      end
    end
    L12_2 = nil
    ::lbl_56::
    L11_2.coords = L12_2
    L2_2[L10_2] = L11_2
  end
  return L2_2
end
L6_1.list = L7_1
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = ipairs
  L4_2 = FW
  L4_2 = L4_2.GetVehicles
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.plate
    if L9_2 == A2_2 then
      L9_2 = L8_2.mods
      if not L9_2 then
        L9_2 = {}
      end
      L10_2 = {}
      L11_2 = L8_2.plate
      L10_2.plate = L11_2
      L11_2 = L8_2.engine
      if not L11_2 then
        L11_2 = L9_2.engineHealth
      end
      L10_2.engine = L11_2
      L11_2 = L8_2.body
      if not L11_2 then
        L11_2 = L9_2.bodyHealth
      end
      L10_2.body = L11_2
      L11_2 = L9_2.mileage
      if not L11_2 then
        L11_2 = L9_2.odometer
      end
      L10_2.mileage = L11_2
      return L10_2
    end
  end
  L3_2 = nil
  return L3_2
end
L6_1.detail = L7_1
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = L3_1
  L4_2 = A2_2
  return L3_2(L4_2)
end
L6_1.track = L7_1
L4_1(L5_1, L6_1)
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L1_2 = {}
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return L1_2
  end
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2.plate
      if nil ~= L8_2 then
        L8_2 = L0_1.plate
        L9_2 = L7_2.plate
        L8_2 = L8_2(L9_2)
        if "" ~= L8_2 then
          L8_2 = L0_1.vehState
          L9_2 = L7_2.state
          L8_2 = L8_2(L9_2)
          L9_2 = L7_2.garageLabel
          if not L9_2 then
            L9_2 = L7_2.garage
          end
          if nil ~= L9_2 then
            L10_2 = tostring
            L11_2 = L9_2
            L10_2 = L10_2(L11_2)
            if L10_2 then
              goto lbl_41
              L9_2 = L10_2 or L9_2
            end
          end
          L9_2 = nil
          ::lbl_41::
          L10_2 = L0_1.xyz
          L11_2 = L7_2.coords
          L10_2 = L10_2(L11_2)
          if not L10_2 then
            L11_2 = L7_2.garage
            if nil ~= L11_2 then
              L11_2 = type
              L12_2 = Config
              L12_2 = L12_2.Garages
              L11_2 = L11_2(L12_2)
              if "table" == L11_2 then
                L11_2 = L0_1.xyz
                L12_2 = Config
                L12_2 = L12_2.Garages
                L13_2 = L7_2.garage
                L12_2 = L12_2[L13_2]
                L11_2 = L11_2(L12_2)
                L10_2 = L11_2
              end
            end
          end
          L11_2 = L0_1.num
          L12_2 = L7_2.fuel
          L11_2 = L11_2(L12_2)
          if L11_2 and L11_2 > 0 and L11_2 < 1 then
            L11_2 = L11_2 * 100
          end
          L12_2 = #L1_2
          L12_2 = L12_2 + 1
          L13_2 = {}
          L14_2 = L0_1.plate
          L15_2 = L7_2.plate
          L14_2 = L14_2(L15_2)
          L13_2.plate = L14_2
          L14_2 = L7_2.model
          if nil ~= L14_2 then
            L14_2 = tostring
            L15_2 = L7_2.model
            L14_2 = L14_2(L15_2)
            if L14_2 then
              goto lbl_99
            end
          end
          L14_2 = L7_2.hash
          if L14_2 then
            L14_2 = tostring
            L15_2 = L7_2.hash
            L14_2 = L14_2(L15_2)
            if L14_2 then
              goto lbl_99
            end
          end
          L14_2 = "veiculo"
          ::lbl_99::
          L13_2.model = L14_2
          L14_2 = L0_1.num
          L15_2 = L7_2.hash
          L14_2 = L14_2(L15_2)
          L13_2.hash = L14_2
          L14_2 = L7_2.label
          if nil ~= L14_2 then
            L14_2 = tostring
            L15_2 = L7_2.label
            L14_2 = L14_2(L15_2)
            if L14_2 then
              goto lbl_113
            end
          end
          L14_2 = nil
          ::lbl_113::
          L13_2.label = L14_2
          L13_2.garage = L9_2
          L14_2 = L1_1
          L14_2 = L14_2[L8_2]
          if not L14_2 then
            L14_2 = 0
          end
          L13_2.state = L14_2
          L13_2.fuel = L11_2
          L14_2 = L0_1.num
          L15_2 = L7_2.engine
          L14_2 = L14_2(L15_2)
          L13_2.engine = L14_2
          L14_2 = L0_1.num
          L15_2 = L7_2.body
          L14_2 = L14_2(L15_2)
          L13_2.body = L14_2
          if L10_2 then
            L14_2 = {}
            L15_2 = L10_2.x
            L14_2.x = L15_2
            L15_2 = L10_2.y
            L14_2.y = L15_2
            if L14_2 then
              goto lbl_141
            end
          end
          L14_2 = nil
          ::lbl_141::
          L13_2.coords = L14_2
          L14_2 = type
          L15_2 = L7_2.nickname
          L14_2 = L14_2(L15_2)
          if "string" == L14_2 then
            L14_2 = L7_2.nickname
            if "" ~= L14_2 then
              L14_2 = L7_2.nickname
              L15_2 = L14_2
              L14_2 = L14_2.sub
              L16_2 = 1
              L17_2 = 40
              L14_2 = L14_2(L15_2, L16_2, L17_2)
              if L14_2 then
                goto lbl_158
              end
            end
          end
          L14_2 = nil
          ::lbl_158::
          L13_2.nickname = L14_2
          L1_2[L12_2] = L13_2
        end
      end
    end
  end
  return L1_2
end
function L5_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = Integration
  L4_2 = "garage"
  L3_2, L4_2 = L3_2(L4_2)
  if "builtin" == L4_2 then
    L5_2 = L2_1
    if L5_2 then
      L5_2 = L2_1
      L6_2 = A0_2
      L7_2 = A2_2
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        goto lbl_17
      end
    end
    L5_2 = {}
    ::lbl_17::
    return L5_2
  end
  L5_2 = IntegrationTry
  L6_2 = "garage"
  L7_2 = "list"
  L8_2 = A0_2
  L9_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if L5_2 then
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L7_2 = L4_1
      L8_2 = L6_2
      return L7_2(L8_2)
    end
  end
  L7_2 = L2_1
  if L7_2 then
    L7_2 = L2_1
    L8_2 = A0_2
    L9_2 = A2_2
    L7_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      goto lbl_46
    end
  end
  L7_2 = {}
  ::lbl_46::
  return L7_2
end
L6_1 = RPC
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L5_1
  L4_2 = A0_2
  L5_2 = L2_2
  L6_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L2_2 then
    return L3_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT plate, nickname, favorite FROM apex_phone_garage_meta WHERE owner = ?"
  L6_2 = {}
  L7_2 = L2_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.plate
    L5_2[L12_2] = L11_2
  end
  L6_2 = ipairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.plate
    L12_2 = L5_2[L12_2]
    if L12_2 then
      L13_2 = L12_2.nickname
      if L13_2 then
        goto lbl_51
      end
    end
    L13_2 = L11_2.nickname
    if not L13_2 then
      L13_2 = nil
    end
    ::lbl_51::
    L11_2.nickname = L13_2
    if L12_2 then
      L13_2 = L12_2.favorite
    end
    L13_2 = 1 == L13_2 or L13_2
    L11_2.favorite = L13_2
  end
  return L3_2
end
L6_1["garage.vehicles"] = L7_1
L6_1 = RPC
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A1_2.plate
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = Integration
  L5_2 = "garage"
  L4_2, L5_2 = L4_2(L5_2)
  if "builtin" == L5_2 then
    L6_2 = L0_1.builtin
    L6_2 = L6_2.garage
    L6_2 = L6_2.detail
    L7_2 = A0_2
    L8_2 = L2_2
    L9_2 = L3_2
    return L6_2(L7_2, L8_2, L9_2)
  end
  L6_2 = IntegrationTry
  L7_2 = "garage"
  L8_2 = "detail"
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L3_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  if L6_2 then
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = {}
      L8_2.plate = L3_2
      L9_2 = L0_1.num
      L10_2 = L7_2.engine
      L9_2 = L9_2(L10_2)
      L8_2.engine = L9_2
      L9_2 = L0_1.num
      L10_2 = L7_2.body
      L9_2 = L9_2(L10_2)
      L8_2.body = L9_2
      L9_2 = L0_1.num
      L10_2 = L7_2.mileage
      L9_2 = L9_2(L10_2)
      L8_2.mileage = L9_2
      return L8_2
    end
  end
  L8_2 = IntegrationTry
  L9_2 = "garage"
  L10_2 = "list"
  L11_2 = A0_2
  L12_2 = L2_2
  L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  if L8_2 then
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L0_1.plateKey
      L11_2 = L3_2
      L10_2 = L10_2(L11_2)
      L11_2 = ipairs
      L12_2 = L9_2
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
      for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
        L17_2 = type
        L18_2 = L16_2
        L17_2 = L17_2(L18_2)
        if "table" == L17_2 then
          L17_2 = L0_1.plateKey
          L18_2 = L16_2.plate
          L17_2 = L17_2(L18_2)
          if L17_2 == L10_2 then
            L17_2 = {}
            L17_2.plate = L3_2
            L18_2 = L0_1.num
            L19_2 = L16_2.engine
            L18_2 = L18_2(L19_2)
            L17_2.engine = L18_2
            L18_2 = L0_1.num
            L19_2 = L16_2.body
            L18_2 = L18_2(L19_2)
            L17_2.body = L18_2
            L18_2 = L0_1.num
            L19_2 = L16_2.mileage
            L18_2 = L18_2(L19_2)
            L17_2.mileage = L18_2
            return L17_2
          end
        end
      end
      L11_2 = nil
      return L11_2
    end
  end
  L10_2 = L0_1.builtin
  L10_2 = L10_2.garage
  L10_2 = L10_2.detail
  L11_2 = A0_2
  L12_2 = L2_2
  L13_2 = L3_2
  return L10_2(L11_2, L12_2, L13_2)
end
L6_1["garage.detail"] = L7_1
L6_1 = RPC
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L0_1.plate
  L4_2 = type
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A1_2.plate
    if L4_2 then
      goto lbl_18
    end
  end
  L4_2 = ""
  ::lbl_18::
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 16
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if "" == L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L0_1.plateKey
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = false
  L6_2 = ipairs
  L7_2 = L5_1
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = {}
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L0_1.plateKey
    L13_2 = L11_2.plate
    L12_2 = L12_2(L13_2)
    if L12_2 == L4_2 then
      L5_2 = true
      break
    end
  end
  if not L5_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = L0_1.xyz
  L7_2 = IntegrationCall
  L8_2 = "garage"
  L9_2 = "track"
  L10_2 = A0_2
  L11_2 = L2_2
  L12_2 = L3_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  if not L6_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = {}
  L8_2 = L6_2.x
  L7_2.x = L8_2
  L8_2 = L6_2.y
  L7_2.y = L8_2
  L8_2 = L6_2.z
  L7_2.z = L8_2
  return L7_2
end
L6_1["garage.track"] = L7_1
L6_1 = RPC
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = A1_2.nickname
  if L2_2 then
    L2_2 = tostring
    L3_2 = A1_2.nickname
    L2_2 = L2_2(L3_2)
    L3_2 = L2_2
    L2_2 = L2_2.sub
    L4_2 = 1
    L5_2 = 40
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      goto lbl_14
    end
  end
  L2_2 = nil
  ::lbl_14::
  if "" == L2_2 then
    L2_2 = nil
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO apex_phone_garage_meta (plate, owner, nickname, favorite) VALUES (?, ?, ?, 0) ON DUPLICATE KEY UPDATE nickname = VALUES(nickname)"
  L5_2 = {}
  L6_2 = tostring
  L7_2 = A1_2.plate
  L6_2 = L6_2(L7_2)
  L7_2 = GetCid
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L6_1["garage.rename"] = L7_1
L6_1 = RPC
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "INSERT INTO apex_phone_garage_meta (plate, owner, nickname, favorite) VALUES (?, ?, NULL, ?) ON DUPLICATE KEY UPDATE favorite = VALUES(favorite)"
  L4_2 = {}
  L5_2 = tostring
  L6_2 = A1_2.plate
  L5_2 = L5_2(L6_2)
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = A1_2.favorite
  if L7_2 then
    L7_2 = 1
    if L7_2 then
      goto lbl_20
    end
  end
  L7_2 = 0
  ::lbl_20::
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2(L3_2, L4_2)
  L2_2 = {}
  L2_2.ok = true
  return L2_2
end
L6_1["garage.favorite"] = L7_1
L6_1 = L0_1.SQL_NULL
if not L6_1 then
  L6_1 = setmetatable
  L7_1 = {}
  L8_1 = {}
  function L9_1()
    local L0_2, L1_2
    L0_2 = "NULL"
    return L0_2
  end
  L8_1.__tostring = L9_1
  L6_1 = L6_1(L7_1, L8_1)
end
L7_1 = {}
L7_1.enabled = true
L7_1.price = 250
L7_1.account = "bank"
L7_1.cooldown = 60
L7_1.minDistance = 15
L7_1.maxDistance = 90
L7_1.keys = "auto"
L7_1.mode = "valet"
L8_1 = {}
L8_1.ped = "s_m_y_valet_01"
L8_1.minDistance = 120
L8_1.maxDistance = 260
L8_1.timeout = 150
L8_1.speed = 17.0
L8_1.drivingStyle = 786603
L9_1 = {}
L9_1.automobile = true
L9_1.bike = true
L10_1 = {}
L11_1 = {}
L12_1 = {}
L13_1 = {}
L14_1 = nil
L15_1 = {}
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L15_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    return
  end
  L2_2 = L15_1
  L2_2[A0_2] = true
  L2_2 = print
  L3_2 = "^3[unique_phone]^0 garage delivery: %s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = A1_2
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  L2_2(L3_2, L4_2, L5_2)
end
L17_1 = AddEventHandler
L18_1 = "playerDropped"
function L19_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L10_1
    L1_2[L0_2] = nil
  end
end
L17_1(L18_1, L19_1)
function L17_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.GarageDelivery
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.GarageDelivery
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L7_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L6_2] = L7_2
  end
  L2_2 = L0_2.enabled
  if false == L2_2 then
    L1_2.enabled = false
  end
  L2_2 = L0_1.num
  L3_2 = L0_2.price
  L2_2 = L2_2(L3_2)
  if L2_2 and L2_2 >= 0 then
    L3_2 = math
    L3_2 = L3_2.floor
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    L1_2.price = L3_2
  end
  L3_2 = L0_2.account
  if "cash" == L3_2 then
    L3_2 = "cash"
    if L3_2 then
      goto lbl_46
    end
  end
  L3_2 = "bank"
  ::lbl_46::
  L1_2.account = L3_2
  L3_2 = L0_1.num
  L4_2 = L0_2.cooldown
  L3_2 = L3_2(L4_2)
  if L3_2 and L3_2 >= 0 then
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L1_2.cooldown = L4_2
  end
  L4_2 = L0_1.num
  L5_2 = L0_2.minDistance
  L4_2 = L4_2(L5_2)
  L5_2 = L0_1.num
  L6_2 = L0_2.maxDistance
  L5_2 = L5_2(L6_2)
  if L4_2 and L4_2 >= 0 then
    L1_2.minDistance = L4_2
  end
  if L5_2 and L5_2 > 0 then
    L1_2.maxDistance = L5_2
  end
  L6_2 = L1_2.maxDistance
  L7_2 = L1_2.minDistance
  L7_2 = L7_2 + 10
  if L6_2 < L7_2 then
    L6_2 = L1_2.minDistance
    L6_2 = L6_2 + 10
    L1_2.maxDistance = L6_2
  end
  L6_2 = type
  L7_2 = L0_2.keys
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L6_2 = L0_2.keys
    if "" ~= L6_2 then
      L6_2 = L0_2.keys
      L1_2.keys = L6_2
    end
  end
  L6_2 = L0_2.mode
  if "road" ~= L6_2 then
    L6_2 = L0_2.mode
    if "spawn" ~= L6_2 then
      goto lbl_104
    end
  end
  L6_2 = "road"
  ::lbl_104::
  if not L6_2 then
    L6_2 = "valet"
  end
  L1_2.mode = L6_2
  L6_2 = {}
  L7_2 = type
  L8_2 = L0_2.valet
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = L0_2.valet
    if L7_2 then
      goto lbl_118
    end
  end
  L7_2 = {}
  ::lbl_118::
  L8_2 = pairs
  L9_2 = L8_1
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L6_2[L12_2] = L13_2
  end
  L8_2 = type
  L9_2 = L7_2.ped
  L8_2 = L8_2(L9_2)
  if "string" == L8_2 then
    L8_2 = L7_2.ped
    if "" ~= L8_2 then
      L8_2 = L7_2.ped
      L9_2 = L8_2
      L8_2 = L8_2.sub
      L10_2 = 1
      L11_2 = 64
      L8_2 = L8_2(L9_2, L10_2, L11_2)
      L6_2.ped = L8_2
    end
  end
  L8_2 = L0_1.num
  L9_2 = L7_2.minDistance
  L8_2 = L8_2(L9_2)
  L9_2 = L0_1.num
  L10_2 = L7_2.maxDistance
  L9_2 = L9_2(L10_2)
  if L8_2 and L8_2 >= 30 then
    L6_2.minDistance = L8_2
  end
  if L9_2 and L9_2 > 0 then
    L6_2.maxDistance = L9_2
  end
  L10_2 = L6_2.maxDistance
  L11_2 = L6_2.minDistance
  L11_2 = L11_2 + 20
  if L10_2 < L11_2 then
    L10_2 = L6_2.minDistance
    L10_2 = L10_2 + 20
    L6_2.maxDistance = L10_2
  end
  L10_2 = L0_1.num
  L11_2 = L7_2.timeout
  L10_2 = L10_2(L11_2)
  if L10_2 and L10_2 >= 30 then
    L11_2 = math
    L11_2 = L11_2.floor
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    L6_2.timeout = L11_2
  end
  L11_2 = L0_1.num
  L12_2 = L7_2.speed
  L11_2 = L11_2(L12_2)
  if L11_2 and L11_2 > 0 then
    L6_2.speed = L11_2
  end
  L12_2 = L0_1.num
  L13_2 = L7_2.drivingStyle
  L12_2 = L12_2(L13_2)
  if L12_2 and L12_2 >= 0 then
    L13_2 = math
    L13_2 = L13_2.floor
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    L6_2.drivingStyle = L13_2
  end
  L1_2.valet = L6_2
  return L1_2
end
function L18_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
function L19_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = A0_2 & 4294967295
  return L1_2
end
function L20_1(A0_2)
  local L1_2, L2_2
  L1_2 = L19_1
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
function L21_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = GetHashKey
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = tonumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = L19_1
      L4_2 = L2_2
      return L3_2(L4_2)
    end
  end
  L3_2 = type
  L4_2 = joaat
  L3_2 = L3_2(L4_2)
  if "function" == L3_2 then
    L3_2 = pcall
    L4_2 = joaat
    L5_2 = A0_2
    L3_2, L4_2 = L3_2(L4_2, L5_2)
    L2_2 = L4_2
    L1_2 = L3_2
    if L1_2 then
      L3_2 = tonumber
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        L3_2 = L19_1
        L4_2 = L2_2
        return L3_2(L4_2)
      end
    end
  end
  L3_2 = nil
  return L3_2
end
function L22_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = type
  L1_2 = CreateVehicleServerSetter
  L0_2 = L0_2(L1_2)
  if "function" ~= L0_2 then
    L0_2 = false
    return L0_2
  end
  L0_2 = tostring
  L1_2 = GetConvar
  L2_2 = "onesync"
  L3_2 = "off"
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2, L3_2)
  L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2)
  L1_2 = L0_2
  L0_2 = L0_2.lower
  L0_2 = L0_2(L1_2)
  if "off" ~= L0_2 and "false" ~= L0_2 and "0" ~= L0_2 and "" ~= L0_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = tostring
  L2_2 = GetConvar
  L3_2 = "onesync_enabled"
  L4_2 = "false"
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  L1_2 = "true" == L1_2
  return L1_2
end
function L23_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L17_1
  L0_2 = L0_2()
  L1_2 = L0_2.enabled
  if not L1_2 then
    L1_2 = "disabled"
    L2_2 = L0_2
    return L1_2, L2_2
  end
  L1_2 = FW
  L1_2 = L1_2.name
  if "esx" ~= L1_2 then
    L1_2 = FW
    L1_2 = L1_2.name
    if "qb" ~= L1_2 then
      L1_2 = FW
      L1_2 = L1_2.name
      if "qbx" ~= L1_2 then
        L1_2 = "framework"
        L2_2 = L0_2
        return L1_2, L2_2
      end
    end
  end
  L1_2 = L22_1
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = L16_1
    L2_2 = "onesync"
    L3_2 = "OneSync is off on this server, so the Garage app cannot deliver vehicles (the button is hidden). Turn OneSync on (txAdmin: Settings > FXServer) or set Config.GarageDelivery.enabled = false."
    L1_2(L2_2, L3_2)
    L1_2 = "onesync"
    L2_2 = L0_2
    return L1_2, L2_2
  end
  L1_2 = Integration
  L2_2 = "garage"
  L1_2 = L1_2(L2_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L1_2.deliver
    if false == L2_2 then
      L2_2 = "unsupported"
      L3_2 = L0_2
      return L2_2, L3_2
    end
  end
  L2_2 = nil
  L3_2 = L0_2
  return L2_2, L3_2
end
L24_1 = {}
L25_1 = {}
L25_1.name = "qbx_vehiclekeys"
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = exports
  L2_2 = L2_2.qbx_vehiclekeys
  L3_2 = L2_2
  L2_2 = L2_2.GiveKeys
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
L25_1.fn = L26_1
L26_1 = {}
L26_1.name = "qb-vehiclekeys"
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = exports
    L0_3 = L0_3["qb-vehiclekeys"]
    L1_3 = L0_3
    L0_3 = L0_3.GiveKeys
    L2_3 = A0_2
    L3_3 = A2_2
    L0_3(L1_3, L2_3, L3_3)
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = TriggerClientEvent
    L5_2 = "vehiclekeys:client:SetOwner"
    L6_2 = A0_2
    L7_2 = A2_2
    L4_2(L5_2, L6_2, L7_2)
  end
end
L26_1.fn = L27_1
L27_1 = {}
L27_1.name = "wasabi_carlock"
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = exports
  L3_2 = L3_2.wasabi_carlock
  L4_2 = L3_2
  L3_2 = L3_2.GiveKey
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L27_1.fn = L28_1
L28_1 = {}
L28_1.name = "qs-vehiclekeys"
L28_1.needsModel = true
function L29_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = exports
  L4_2 = L4_2["qs-vehiclekeys"]
  L5_2 = L4_2
  L4_2 = L4_2.GiveServerKeys
  L6_2 = A0_2
  L7_2 = A2_2
  L8_2 = A3_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
end
L28_1.fn = L29_1
L29_1 = {}
L29_1.name = "MrNewbVehicleKeys"
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = exports
  L2_2 = L2_2.MrNewbVehicleKeys
  L3_2 = L2_2
  L2_2 = L2_2.GiveKeys
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
L29_1.fn = L30_1
L30_1 = {}
L30_1.name = "Renewed-Vehiclekeys"
function L31_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = exports
  L3_2 = L3_2["Renewed-Vehiclekeys"]
  L4_2 = L3_2
  L3_2 = L3_2.addKey
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L30_1.fn = L31_1
L31_1 = {}
L31_1.name = "tgiann-hotwire"
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = TriggerClientEvent
  L4_2 = "tgiann-hotwire:addKey"
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L31_1.fn = L32_1
L32_1 = {}
L32_1.name = "vehicles_keys"
function L33_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = TriggerClientEvent
  L4_2 = "vehicles_keys:client:addNewKey"
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L32_1.fn = L33_1
L33_1 = {}
L33_1.name = "codem-vehiclekeys"
function L34_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = exports
  L3_2 = L3_2["codem-vehiclekeys"]
  L4_2 = L3_2
  L3_2 = L3_2.GiveKeys
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L33_1.fn = L34_1
L34_1 = {}
L34_1.name = "ti_vehicleKeys"
function L35_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = exports
  L3_2 = L3_2.ti_vehicleKeys
  L4_2 = L3_2
  L3_2 = L3_2.GiveKeys
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L34_1.fn = L35_1
L35_1 = {}
L35_1.name = "rcore_carkeys"
function L36_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = exports
  L3_2 = L3_2.rcore_carkeys
  L4_2 = L3_2
  L3_2 = L3_2.giveKeys
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L35_1.fn = L36_1
L36_1 = {}
L36_1.name = "brutal_vehiclekeys"
function L37_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = exports
  L3_2 = L3_2.brutal_vehiclekeys
  L4_2 = L3_2
  L3_2 = L3_2.GiveKeys
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L36_1.fn = L37_1
L37_1 = {}
L37_1.name = "mono_carkeys"
function L38_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = exports
  L3_2 = L3_2.mono_carkeys
  L4_2 = L3_2
  L3_2 = L3_2.GiveKey
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L37_1.fn = L38_1
L38_1 = {}
L38_1.name = "okokGarage"
function L39_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = TriggerClientEvent
  L4_2 = "okokGarage:GiveKeysClient"
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L38_1.fn = L39_1
L39_1 = {}
L39_1.name = "ak47_vehiclekeys"
function L40_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = TriggerClientEvent
  L4_2 = "ak47_vehiclekeys:setKeys"
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
end
L39_1.fn = L40_1
L24_1[1] = L25_1
L24_1[2] = L26_1
L24_1[3] = L27_1
L24_1[4] = L28_1
L24_1[5] = L29_1
L24_1[6] = L30_1
L24_1[7] = L31_1
L24_1[8] = L32_1
L24_1[9] = L33_1
L24_1[10] = L34_1
L24_1[11] = L35_1
L24_1[12] = L36_1
L24_1[13] = L37_1
L24_1[14] = L38_1
L24_1[15] = L39_1
function L25_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L5_2 = {}
  if "none" == A4_2 then
    return L5_2
  end
  L6_2 = ipairs
  L7_2 = L24_1
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    if "auto" == A4_2 then
      L12_2 = L0_1.started
      L13_2 = L11_2.name
      L12_2 = L12_2(L13_2)
      if L12_2 then
        goto lbl_20
      end
    end
    L12_2 = L11_2.name
    ::lbl_20::
    if A4_2 == L12_2 then
      L12_2 = L11_2.needsModel
      if L12_2 and not A3_2 then
        L12_2 = #L5_2
        L12_2 = L12_2 + 1
        L13_2 = L11_2.name
        L14_2 = " skipped: no model name"
        L13_2 = L13_2 .. L14_2
        L5_2[L12_2] = L13_2
      else
        L12_2 = pcall
        L13_2 = L11_2.fn
        L14_2 = A0_2
        L15_2 = A1_2
        L16_2 = A2_2
        L17_2 = A3_2
        L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
        L14_2 = #L5_2
        L14_2 = L14_2 + 1
        L15_2 = L11_2.name
        if L12_2 then
          L16_2 = " ok"
          if L16_2 then
            goto lbl_54
          end
        end
        L16_2 = " FAILED: "
        L17_2 = tostring
        L18_2 = L13_2
        L17_2 = L17_2(L18_2)
        L16_2 = L16_2 .. L17_2
        ::lbl_54::
        L15_2 = L15_2 .. L16_2
        L5_2[L14_2] = L15_2
        if not L12_2 then
          L14_2 = L16_1
          L15_2 = "key_"
          L16_2 = L11_2.name
          L15_2 = L15_2 .. L16_2
          L16_2 = "%s did not take the key (%s)"
          L17_2 = L16_2
          L16_2 = L16_2.format
          L18_2 = L11_2.name
          L19_2 = tostring
          L20_2 = L13_2
          L19_2, L20_2 = L19_2(L20_2)
          L16_2, L17_2, L18_2, L19_2, L20_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
          L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
        end
      end
    end
  end
  return L5_2
end
function L26_1()
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
function L27_1(A0_2, A1_2)
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
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L26_1
  L2_2, L3_2 = L2_2()
  L4_2 = L27_1
  L5_2 = "SELECT * FROM `%s` WHERE `%s` = ? AND `plate` = ? LIMIT 2"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = L2_2
  L8_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = #L4_2
    if 1 == L5_2 then
      goto lbl_35
    end
  end
  L5_2 = L27_1
  L6_2 = "SELECT * FROM `%s` WHERE `%s` = ? AND REPLACE(UPPER(`plate`), ' ', '') = ? LIMIT 2"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L2_2
  L9_2 = L3_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = {}
  L8_2 = A0_2
  L9_2 = L0_1.plateKey
  L10_2 = A1_2
  L9_2, L10_2 = L9_2(L10_2)
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2 = L5_2(L6_2, L7_2)
  L4_2 = L5_2
  ::lbl_35::
  if L4_2 then
    L5_2 = #L4_2
    if 1 == L5_2 then
      L5_2 = L4_2[1]
      L6_2 = L2_2
      L7_2 = L3_2
      return L5_2, L6_2, L7_2
    end
  end
  L5_2 = nil
  L6_2 = L2_2
  L7_2 = L3_2
  return L5_2, L6_2, L7_2
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L13_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    return L2_2
  end
  L3_2 = L27_1
  L4_2 = "SHOW COLUMNS FROM `%s`"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2, L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  if L3_2 then
    L4_2 = #L3_2
    if L4_2 > 0 then
      L4_2 = {}
      L2_2 = L4_2
      L4_2 = ipairs
      L5_2 = L3_2
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = L9_2.Field
        if L10_2 then
          L10_2 = L9_2.Field
          L2_2[L10_2] = true
        end
      end
      L4_2 = L13_1
      L4_2[A0_2] = L2_2
      return L2_2
    end
  end
  L4_2 = {}
  L2_2 = L4_2
  L4_2 = pairs
  L5_2 = A1_2 or L5_2
  if not A1_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    L2_2[L8_2] = true
  end
  return L2_2
end
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = nil
  L3_2 = FW
  L3_2 = L3_2.name
  if "esx" == L3_2 then
    L3_2 = {}
    L4_2 = A1_2.model
    L5_2 = A1_2.modelName
    L6_2 = A0_2.model
    L3_2[1] = L4_2
    L3_2[2] = L5_2
    L3_2[3] = L6_2
    L2_2 = L3_2
  else
    L3_2 = {}
    L4_2 = A0_2.vehicle
    L5_2 = A0_2.hash
    L6_2 = A1_2.model
    L7_2 = A1_2.modelName
    L3_2[1] = L4_2
    L3_2[2] = L5_2
    L3_2[3] = L6_2
    L3_2[4] = L7_2
    L2_2 = L3_2
  end
  L3_2 = 1
  L4_2 = #L2_2
  L4_2 = L4_2 + 1
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = L2_2[L6_2]
    if nil ~= L7_2 then
      L8_2 = nil
      L9_2 = nil
      L10_2 = type
      L11_2 = L7_2
      L10_2 = L10_2(L11_2)
      if "number" == L10_2 then
        L10_2 = L19_1
        L11_2 = L7_2
        L10_2 = L10_2(L11_2)
        L8_2 = L10_2
      else
        L10_2 = type
        L11_2 = L7_2
        L10_2 = L10_2(L11_2)
        if "string" == L10_2 and "" ~= L7_2 then
          L11_2 = L7_2
          L10_2 = L7_2.match
          L12_2 = "^%-?%d+$"
          L10_2 = L10_2(L11_2, L12_2)
          if L10_2 then
            L10_2 = L19_1
            L11_2 = tonumber
            L12_2 = L7_2
            L11_2, L12_2 = L11_2(L12_2)
            L10_2 = L10_2(L11_2, L12_2)
            L8_2 = L10_2
          else
            L10_2 = L21_1
            L11_2 = L7_2
            L10_2 = L10_2(L11_2)
            L12_2 = L7_2
            L11_2 = L7_2.lower
            L11_2 = L11_2(L12_2)
            L9_2 = L11_2
            L8_2 = L10_2
          end
        end
      end
      if L8_2 and 0 ~= L8_2 then
        L10_2 = L8_2
        L11_2 = L9_2
        return L10_2, L11_2
      end
    end
  end
  L3_2 = nil
  return L3_2
end
function L31_1(A0_2)
  local L1_2, L2_2
  if true == A0_2 then
    L1_2 = 1
    return L1_2
  elseif false == A0_2 then
    L1_2 = 0
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      return L1_2
    end
  end
  return A0_2
end
function L32_1(A0_2)
  local L1_2
  if true == A0_2 then
    L1_2 = 1
    return L1_2
  elseif false == A0_2 then
    L1_2 = 0
    return L1_2
  end
  return A0_2
end
function L33_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L5_2 = L29_1
  L6_2 = A0_2
  L7_2 = A3_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = {}
  L7_2 = {}
  L8_2 = {}
  L9_2 = {}
  L10_2 = {}
  L11_2 = pairs
  L12_2 = A4_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = type
    L18_2 = L15_2
    L17_2 = L17_2(L18_2)
    if "string" == L17_2 then
      L18_2 = L15_2
      L17_2 = L15_2.match
      L19_2 = "^[%w_]+$"
      L17_2 = L17_2(L18_2, L19_2)
      if L17_2 then
        L17_2 = L5_2[L15_2]
        if L17_2 then
          L17_2 = A3_2[L15_2]
          L18_2 = nil
          L19_2 = L6_1
          if L16_2 == L19_2 then
            L18_2 = nil == L17_2
          else
            L18_2 = nil ~= L17_2
          end
          if nil == L17_2 then
            L19_2 = #L8_2
            L19_2 = L19_2 + 1
            L20_2 = "`%s` IS NULL"
            L21_2 = L20_2
            L20_2 = L20_2.format
            L22_2 = L15_2
            L20_2 = L20_2(L21_2, L22_2)
            L8_2[L19_2] = L20_2
          else
            L19_2 = #L8_2
            L19_2 = L19_2 + 1
            L20_2 = "`%s` = ?"
            L21_2 = L20_2
            L20_2 = L20_2.format
            L22_2 = L15_2
            L20_2 = L20_2(L21_2, L22_2)
            L8_2[L19_2] = L20_2
            L19_2 = #L9_2
            L19_2 = L19_2 + 1
            L20_2 = L32_1
            L21_2 = L17_2
            L20_2 = L20_2(L21_2)
            L9_2[L19_2] = L20_2
          end
          if not L18_2 then
            L19_2 = L6_1
            if L16_2 == L19_2 then
              L19_2 = #L6_2
              L19_2 = L19_2 + 1
              L20_2 = "`%s` = NULL"
              L21_2 = L20_2
              L20_2 = L20_2.format
              L22_2 = L15_2
              L20_2 = L20_2(L21_2, L22_2)
              L6_2[L19_2] = L20_2
            else
              L19_2 = #L6_2
              L19_2 = L19_2 + 1
              L20_2 = "`%s` = ?"
              L21_2 = L20_2
              L20_2 = L20_2.format
              L22_2 = L15_2
              L20_2 = L20_2(L21_2, L22_2)
              L6_2[L19_2] = L20_2
              L19_2 = #L7_2
              L19_2 = L19_2 + 1
              L20_2 = L32_1
              L21_2 = L16_2
              L20_2 = L20_2(L21_2)
              L7_2[L19_2] = L20_2
            end
            L19_2 = #L10_2
            L19_2 = L19_2 + 1
            L20_2 = {}
            L20_2.col = L15_2
            L20_2.old = L17_2
            L20_2.new = L16_2
            L10_2[L19_2] = L20_2
          end
        end
      end
    end
  end
  L11_2 = #L6_2
  if 0 == L11_2 then
    L11_2 = false
    L12_2 = "unsupported"
    return L11_2, L12_2
  end
  L11_2 = {}
  L12_2 = ipairs
  L13_2 = L7_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = #L11_2
    L18_2 = L18_2 + 1
    L11_2[L18_2] = L17_2
  end
  L12_2 = #L11_2
  L12_2 = L12_2 + 1
  L11_2[L12_2] = A2_2
  L12_2 = #L11_2
  L12_2 = L12_2 + 1
  L13_2 = A3_2.plate
  L11_2[L12_2] = L13_2
  L12_2 = ipairs
  L13_2 = L9_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = #L11_2
    L18_2 = L18_2 + 1
    L11_2[L18_2] = L17_2
  end
  L12_2 = "UPDATE `%s` SET %s WHERE `%s` = ? AND `plate` = ?%s"
  L13_2 = L12_2
  L12_2 = L12_2.format
  L14_2 = A0_2
  L15_2 = table
  L15_2 = L15_2.concat
  L16_2 = L6_2
  L17_2 = ", "
  L15_2 = L15_2(L16_2, L17_2)
  L16_2 = A1_2
  L17_2 = #L8_2
  if L17_2 > 0 then
    L17_2 = " AND "
    L18_2 = table
    L18_2 = L18_2.concat
    L19_2 = L8_2
    L20_2 = " AND "
    L18_2 = L18_2(L19_2, L20_2)
    L17_2 = L17_2 .. L18_2
    if L17_2 then
      goto lbl_182
    end
  end
  L17_2 = ""
  ::lbl_182::
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L13_2 = pcall
  function L14_2()
    local L0_3, L1_3, L2_3
    L0_3 = MySQL
    L0_3 = L0_3.update
    L0_3 = L0_3.await
    L1_3 = L12_2
    L2_3 = L11_2
    return L0_3(L1_3, L2_3)
  end
  L13_2, L14_2 = L13_2(L14_2)
  if not L13_2 then
    L15_2 = false
    L16_2 = "db"
    L17_2 = tostring
    L18_2 = L14_2
    L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L17_2(L18_2)
    return L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  end
  L15_2 = tonumber
  L16_2 = L14_2
  L15_2 = L15_2(L16_2)
  if not L15_2 then
    L15_2 = 0
  end
  if L15_2 < 1 then
    L15_2 = false
    L16_2 = "state"
    return L15_2, L16_2
  end
  L15_2 = true
  function L16_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3
    L0_3 = {}
    L1_3 = {}
    L2_3 = {}
    L3_3 = {}
    L4_3 = ipairs
    L5_3 = L10_2
    L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
    for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
      L10_3 = L9_3.old
      if nil == L10_3 then
        L10_3 = #L0_3
        L10_3 = L10_3 + 1
        L11_3 = "`%s` = NULL"
        L12_3 = L11_3
        L11_3 = L11_3.format
        L13_3 = L9_3.col
        L11_3 = L11_3(L12_3, L13_3)
        L0_3[L10_3] = L11_3
      else
        L10_3 = #L0_3
        L10_3 = L10_3 + 1
        L11_3 = "`%s` = ?"
        L12_3 = L11_3
        L11_3 = L11_3.format
        L13_3 = L9_3.col
        L11_3 = L11_3(L12_3, L13_3)
        L0_3[L10_3] = L11_3
        L10_3 = #L1_3
        L10_3 = L10_3 + 1
        L11_3 = L32_1
        L12_3 = L9_3.old
        L11_3 = L11_3(L12_3)
        L1_3[L10_3] = L11_3
      end
      L10_3 = L9_3.new
      L11_3 = L6_1
      if L10_3 == L11_3 then
        L10_3 = #L2_3
        L10_3 = L10_3 + 1
        L11_3 = "`%s` IS NULL"
        L12_3 = L11_3
        L11_3 = L11_3.format
        L13_3 = L9_3.col
        L11_3 = L11_3(L12_3, L13_3)
        L2_3[L10_3] = L11_3
      else
        L10_3 = #L2_3
        L10_3 = L10_3 + 1
        L11_3 = "`%s` = ?"
        L12_3 = L11_3
        L11_3 = L11_3.format
        L13_3 = L9_3.col
        L11_3 = L11_3(L12_3, L13_3)
        L2_3[L10_3] = L11_3
        L10_3 = #L3_3
        L10_3 = L10_3 + 1
        L11_3 = L32_1
        L12_3 = L9_3.new
        L11_3 = L11_3(L12_3)
        L3_3[L10_3] = L11_3
      end
    end
    L4_3 = {}
    L5_3 = ipairs
    L6_3 = L1_3
    L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
    for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
      L11_3 = #L4_3
      L11_3 = L11_3 + 1
      L4_3[L11_3] = L10_3
    end
    L5_3 = #L4_3
    L5_3 = L5_3 + 1
    L6_3 = A2_2
    L4_3[L5_3] = L6_3
    L5_3 = #L4_3
    L5_3 = L5_3 + 1
    L6_3 = A3_2.plate
    L4_3[L5_3] = L6_3
    L5_3 = ipairs
    L6_3 = L3_3
    L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
    for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
      L11_3 = #L4_3
      L11_3 = L11_3 + 1
      L4_3[L11_3] = L10_3
    end
    L5_3 = pcall
    function L6_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4
      L0_4 = MySQL
      L0_4 = L0_4.update
      L0_4 = L0_4.await
      L1_4 = "UPDATE `%s` SET %s WHERE `%s` = ? AND `plate` = ? AND %s"
      L2_4 = L1_4
      L1_4 = L1_4.format
      L3_4 = A0_2
      L4_4 = table
      L4_4 = L4_4.concat
      L5_4 = L0_3
      L6_4 = ", "
      L4_4 = L4_4(L5_4, L6_4)
      L5_4 = A1_2
      L6_4 = table
      L6_4 = L6_4.concat
      L7_4 = L2_3
      L8_4 = " AND "
      L6_4, L7_4, L8_4 = L6_4(L7_4, L8_4)
      L1_4 = L1_4(L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4)
      L2_4 = L4_3
      return L0_4(L1_4, L2_4)
    end
    L5_3, L6_3 = L5_3(L6_3)
    L7_3 = L5_3
    if L5_3 then
      L7_3 = tonumber
      L8_3 = L6_3
      L7_3 = L7_3(L8_3)
      if not L7_3 then
        L7_3 = 0
      end
      L7_3 = L7_3 >= 1
    end
    return L7_3
  end
  return L15_2, L16_2
end
function L34_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = A2_2.def
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = L0_1.isCallable
  L5_2 = L3_2.takeOut
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = pcall
    L5_2 = L3_2.takeOut
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = A2_2.entry
    L8_2 = L8_2.plate
    L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
    if not L4_2 then
      L6_2 = L16_1
      L7_2 = "takeout_"
      L8_2 = tostring
      L9_2 = A2_2.id
      L8_2 = L8_2(L9_2)
      L7_2 = L7_2 .. L8_2
      L8_2 = "%s takeOut failed: %s"
      L9_2 = L8_2
      L8_2 = L8_2.format
      L10_2 = tostring
      L11_2 = A2_2.id
      L10_2 = L10_2(L11_2)
      L11_2 = tostring
      L12_2 = L5_2
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
      L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L6_2 = false
      L7_2 = "internal"
      return L6_2, L7_2
    end
    if true ~= L5_2 then
      L6_2 = false
      L7_2 = "state"
      return L6_2, L7_2
    end
    L6_2 = true
    function L7_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = L0_1.isCallable
      L1_3 = L3_2.putBack
      L0_3 = L0_3(L1_3)
      if L0_3 then
        L0_3 = pcall
        L1_3 = L3_2.putBack
        L2_3 = A0_2
        L3_3 = A1_2
        L4_3 = A2_2.entry
        L4_3 = L4_3.plate
        L0_3, L1_3 = L0_3(L1_3, L2_3, L3_3, L4_3)
        L2_3 = L0_3 or L2_3
        L2_3 = L0_3 and false ~= L1_3
        return L2_3
      end
      L0_3 = false
      return L0_3
    end
    return L6_2, L7_2
  end
  L4_2 = {}
  L5_2 = L3_2.deliverBase
  if false ~= L5_2 then
    L5_2 = FW
    L5_2 = L5_2.name
    if "esx" == L5_2 then
      L4_2.stored = 0
    else
      L4_2.state = 0
    end
  end
  L5_2 = L0_1.isCallable
  L6_2 = L3_2.deliverOut
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L5_2 = pcall
    L6_2 = L3_2.deliverOut
    L7_2 = A2_2.row
    L5_2, L6_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      L7_2 = type
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      if "table" == L7_2 then
        L7_2 = pairs
        L8_2 = L6_2
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
          L4_2[L11_2] = L12_2
        end
    end
    elseif not L5_2 then
      L7_2 = L16_1
      L8_2 = "out_"
      L9_2 = tostring
      L10_2 = A2_2.id
      L9_2 = L9_2(L10_2)
      L8_2 = L8_2 .. L9_2
      L9_2 = "%s deliverOut failed: %s"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L12_2 = A2_2.id
      L11_2 = L11_2(L12_2)
      L12_2 = tostring
      L13_2 = L6_2
      L12_2, L13_2, L14_2 = L12_2(L13_2)
      L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
      L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
  L5_2 = L33_1
  L6_2 = A2_2.tbl
  L7_2 = A2_2.ownerCol
  L8_2 = A1_2
  L9_2 = A2_2.row
  L10_2 = L4_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  if not L5_2 then
    if "unsupported" == L6_2 then
      L8_2 = L16_1
      L9_2 = "unsup_"
      L10_2 = tostring
      L11_2 = A2_2.id
      L10_2 = L10_2(L11_2)
      L9_2 = L9_2 .. L10_2
      L10_2 = "provider \"%s\" says plate %s is in a garage, but none of the columns the phone can write mean that here, so the delivery was refused (no copy made). Give takeOut/putBack in integrations/custom.lua for this garage."
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = tostring
      L13_2 = A2_2.id
      L12_2 = L12_2(L13_2)
      L13_2 = tostring
      L14_2 = A2_2.entry
      L14_2 = L14_2.plate
      L13_2, L14_2 = L13_2(L14_2)
      L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    elseif "db" == L6_2 then
      L8_2 = print
      L9_2 = "^1[unique_phone]^0 garage delivery: could not mark %s as out: %s"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L12_2 = A2_2.entry
      L12_2 = L12_2.plate
      L11_2 = L11_2(L12_2)
      L12_2 = tostring
      L13_2 = L7_2
      L12_2, L13_2, L14_2 = L12_2(L13_2)
      L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    end
    L8_2 = false
    L9_2 = L6_2
    return L8_2, L9_2
  end
  L8_2 = true
  L9_2 = L6_2
  return L8_2, L9_2
end
function L35_1()
  local L0_2, L1_2
  L0_2 = ShopBridge
  if L0_2 then
    L0_2 = ShopBridge
    L0_2 = L0_2.Ready
    if L0_2 then
      L0_2 = ShopBridge
      L0_2 = L0_2.Ready
      L0_2 = L0_2()
    end
  end
  return L0_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L35_1
  L2_2 = L2_2()
  if L2_2 then
    L2_2 = pcall
    L3_2 = ShopBridge
    L3_2 = L3_2.GetBalance
    L4_2 = A0_2
    L5_2 = A1_2
    L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      L4_2 = tonumber
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      if L4_2 then
        L4_2 = tonumber
        L5_2 = L3_2
        return L4_2(L5_2)
      end
    end
  end
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = pcall
  L4_2 = L2_2.GetMoney
  L5_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L5_2 = tonumber
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_42
    end
  end
  L5_2 = nil
  ::lbl_42::
  return L5_2
end
function L37_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if A2_2 <= 0 then
    L4_2 = true
    return L4_2
  end
  L4_2 = L35_1
  L4_2 = L4_2()
  if L4_2 then
    L4_2 = pcall
    L5_2 = ShopBridge
    L5_2 = L5_2.RemoveMoney
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = A2_2
    L9_2 = A3_2
    L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    L6_2 = L4_2 or L6_2
    L6_2 = L4_2 and true == L5_2
    return L6_2
  end
  L4_2 = FW
  L4_2 = L4_2.GetPlayer
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = pcall
  L6_2 = L4_2.RemoveMoney
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L7_2 = L5_2 or L7_2
  L7_2 = L5_2 and true == L6_2
  return L7_2
end
function L38_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if A3_2 <= 0 then
    L5_2 = true
    return L5_2
  end
  L5_2 = GetPlayerName
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L5_2 = L35_1
    L5_2 = L5_2()
    if L5_2 then
      L5_2 = pcall
      L6_2 = ShopBridge
      L6_2 = L6_2.AddMoney
      L7_2 = A0_2
      L8_2 = A2_2
      L9_2 = A3_2
      L10_2 = A4_2
      L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
      if L5_2 and true == L6_2 then
        L7_2 = true
        return L7_2
      end
    else
      L5_2 = FW
      L5_2 = L5_2.GetPlayer
      L6_2 = A0_2
      L5_2 = L5_2(L6_2)
      if L5_2 then
        L6_2 = pcall
        L7_2 = L5_2.AddMoney
        L8_2 = A2_2
        L9_2 = A3_2
        L10_2 = A4_2
        L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
        if L6_2 and true == L7_2 then
          L8_2 = true
          return L8_2
        end
      end
    end
  end
  L5_2 = FW
  L5_2 = L5_2.AddMoneyOffline
  if L5_2 then
    L5_2 = pcall
    L6_2 = FW
    L6_2 = L6_2.AddMoneyOffline
    L7_2 = A1_2
    L8_2 = A2_2
    L9_2 = A3_2
    L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
    L7_2 = L5_2 or L7_2
    L7_2 = L5_2 and true == L6_2
    return L7_2
  end
  L5_2 = false
  return L5_2
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = pcall
  L2_2 = GetAllVehicles
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_13
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_13::
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
      if L11_2 == A0_2 then
        L11_2 = true
        return L11_2
      end
    end
  end
  L3_2 = false
  return L3_2
end
function L40_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = GetPlayerPed
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    if not L0_3 or 0 == L0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = GetEntityCoords
    L2_3 = L0_3
    return L1_3(L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if not L1_2 or not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = L2_2.x
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = L2_2.y
  L4_2 = L4_2(L5_2)
  L5_2 = tonumber
  L6_2 = L2_2.z
  L5_2 = L5_2(L6_2)
  if not L3_2 or 0 == L3_2 and 0 == L4_2 and 0 == L5_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = {}
  L6_2.x = L3_2
  L6_2.y = L4_2
  L6_2.z = L5_2
  return L6_2
end
function L41_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if A0_2 and A0_2 == A0_2 then
    L1_2 = math
    L1_2 = L1_2.huge
    if A0_2 ~= L1_2 then
      L1_2 = math
      L1_2 = L1_2.huge
      L1_2 = -L1_2
      if A0_2 ~= L1_2 then
        goto lbl_20
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_20::
  return A0_2
end
function L42_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = Integration
  L4_2 = "garage"
  L3_2, L4_2 = L3_2(L4_2)
  L5_2 = nil
  if "builtin" ~= L4_2 then
    L6_2 = IntegrationTry
    L7_2 = "garage"
    L8_2 = "list"
    L9_2 = A0_2
    L10_2 = A1_2
    L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    if L6_2 then
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L5_2 = L7_2
    end
    else
      L8_2 = L0_1.builtin
      L8_2 = L8_2.garage
      L4_2 = "builtin"
      L3_2 = L8_2
    end
  end
  if "builtin" == L4_2 then
    L6_2 = L0_1.builtin
    L3_2 = L6_2.garage
    L6_2 = L3_2.list
    L7_2 = A0_2
    L8_2 = A1_2
    L6_2 = L6_2(L7_2, L8_2)
    L5_2 = L6_2
  end
  L6_2 = ipairs
  L7_2 = L5_2 or L7_2
  if not L5_2 then
    L7_2 = {}
  end
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = L11_2.plate
      if nil ~= L12_2 then
        L12_2 = L0_1.plateKey
        L13_2 = L11_2.plate
        L12_2 = L12_2(L13_2)
        if L12_2 == A2_2 then
          L12_2 = L11_2
          L13_2 = L3_2
          L14_2 = L4_2
          return L12_2, L13_2, L14_2
        end
      end
    end
  end
  L6_2 = nil
  L7_2 = L3_2
  L8_2 = L4_2
  return L6_2, L7_2, L8_2
end
function L43_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L4_2 = L12_1
  L4_2 = L4_2[A1_2]
  if L4_2 then
    L5_2 = A3_2.cooldown
    if L5_2 > 0 then
      L5_2 = A3_2.cooldown
      L6_2 = os
      L6_2 = L6_2.time
      L6_2 = L6_2()
      L6_2 = L6_2 - L4_2
      L5_2 = L5_2 - L6_2
      if L5_2 > 0 then
        L6_2 = nil
        L7_2 = "cooldown"
        L8_2 = {}
        L8_2.wait = L5_2
        return L6_2, L7_2, L8_2
      end
    end
  end
  L5_2 = L42_1
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L8_2 = nil
    L9_2 = "notfound"
    return L8_2, L9_2
  end
  L8_2 = L0_1.vehState
  L9_2 = L5_2.state
  L8_2 = L8_2(L9_2)
  if "impound" == L8_2 then
    L9_2 = nil
    L10_2 = "impound"
    return L9_2, L10_2
  end
  if "garage" ~= L8_2 then
    L9_2 = nil
    L10_2 = "state"
    return L9_2, L10_2
  end
  L9_2 = L39_1
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L9_2 = nil
    L10_2 = "state"
    return L9_2, L10_2
  end
  L9_2 = L28_1
  L10_2 = A1_2
  L11_2 = L0_1.plate
  L12_2 = L5_2.plate
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L11_2(L12_2)
  L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  if not L9_2 then
    L12_2 = L16_1
    L13_2 = "norow_"
    L14_2 = tostring
    L15_2 = L7_2
    L14_2 = L14_2(L15_2)
    L13_2 = L13_2 .. L14_2
    L14_2 = "provider \"%s\" lists plate %s but there is no single row for it in %s, so it cannot be delivered."
    L15_2 = L14_2
    L14_2 = L14_2.format
    L16_2 = tostring
    L17_2 = L7_2
    L16_2 = L16_2(L17_2)
    L17_2 = tostring
    L18_2 = L5_2.plate
    L17_2 = L17_2(L18_2)
    L18_2 = L10_2
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
    L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    L12_2 = nil
    L13_2 = "unsupported"
    return L12_2, L13_2
  end
  L12_2 = L0_1.decode
  L13_2 = FW
  L13_2 = L13_2.name
  if "esx" == L13_2 then
    L13_2 = L9_2.vehicle
    if L13_2 then
      goto lbl_92
    end
  end
  L13_2 = L9_2.mods
  ::lbl_92::
  L12_2 = L12_2(L13_2)
  L13_2 = L30_1
  L14_2 = L9_2
  L15_2 = L12_2
  L13_2, L14_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L15_2 = L16_1
    L16_2 = "nomodel_"
    L17_2 = tostring
    L18_2 = L9_2.plate
    L17_2 = L17_2(L18_2)
    L16_2 = L16_2 .. L17_2
    L17_2 = "plate %s has no model in %s (props.model / hash / vehicle), so it cannot be delivered."
    L18_2 = L17_2
    L17_2 = L17_2.format
    L19_2 = tostring
    L20_2 = L9_2.plate
    L19_2 = L19_2(L20_2)
    L20_2 = L10_2
    L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2, L19_2, L20_2)
    L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
    L15_2 = nil
    L16_2 = "model"
    return L15_2, L16_2
  end
  L15_2 = {}
  L15_2.entry = L5_2
  L15_2.def = L6_2
  L15_2.id = L7_2
  L15_2.row = L9_2
  L15_2.tbl = L10_2
  L15_2.ownerCol = L11_2
  L15_2.props = L12_2
  L15_2.hash = L13_2
  L15_2.name = L14_2
  L16_2 = L0_1.plate
  L17_2 = L9_2.plate
  L16_2 = L16_2(L17_2)
  L15_2.plate = L16_2
  return L15_2
end
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = {}
  L2_2.ok = false
  L2_2.error = A0_2
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = pairs
    L4_2 = A1_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L2_2[L7_2] = L8_2
    end
  end
  return L2_2
end
L45_1 = RPC
function L46_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L1_2, L2_2 = L1_2()
  if L1_2 then
    L3_2 = {}
    L3_2.enabled = false
    L3_2.reason = L1_2
    return L3_2
  end
  L3_2 = {}
  L3_2.enabled = true
  L4_2 = L2_2.price
  L3_2.price = L4_2
  L4_2 = L2_2.account
  L3_2.account = L4_2
  L4_2 = L2_2.mode
  L3_2.mode = L4_2
  return L3_2
end
L45_1["garage.deliveryInfo"] = L46_1
L45_1 = RPC
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L23_1
  L2_2, L3_2 = L2_2()
  if L2_2 then
    L4_2 = L44_1
    L5_2 = L2_2
    return L4_2(L5_2)
  end
  L4_2 = DeviceSessions
  if L4_2 then
    L4_2 = DeviceSessions
    L4_2 = L4_2[A0_2]
    if L4_2 then
      L4_2 = L44_1
      L5_2 = "foreign"
      return L4_2(L5_2)
    end
  end
  L4_2 = FW
  L4_2 = L4_2.GetCidPhone
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  if not L4_2 or not L5_2 then
    L6_2 = L44_1
    L7_2 = "noplayer"
    return L6_2(L7_2)
  end
  L6_2 = L0_1.plate
  L7_2 = type
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = A1_2.plate
    if L7_2 then
      goto lbl_42
    end
  end
  L7_2 = ""
  ::lbl_42::
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.sub
  L8_2 = 1
  L9_2 = 16
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if "" == L6_2 then
    L7_2 = L44_1
    L8_2 = "notfound"
    return L7_2(L8_2)
  end
  L7_2 = L11_1
  L7_2 = L7_2[L5_2]
  if L7_2 then
    L7_2 = L44_1
    L8_2 = "busy"
    return L7_2(L8_2)
  end
  L7_2 = L43_1
  L8_2 = A0_2
  L9_2 = L5_2
  L10_2 = L0_1.plateKey
  L11_2 = L6_2
  L10_2 = L10_2(L11_2)
  L11_2 = L3_2
  L7_2, L8_2, L9_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  if not L7_2 then
    L10_2 = L44_1
    L11_2 = L8_2
    L12_2 = L9_2
    return L10_2(L11_2, L12_2)
  end
  L10_2 = L3_2.price
  if L10_2 > 0 then
    L10_2 = L36_1
    L11_2 = A0_2
    L12_2 = L3_2.account
    L10_2 = L10_2(L11_2, L12_2)
    if L10_2 then
      L11_2 = L3_2.price
      if L10_2 < L11_2 then
        L11_2 = L44_1
        L12_2 = "money"
        L13_2 = {}
        L14_2 = L3_2.account
        L13_2.account = L14_2
        return L11_2(L12_2, L13_2)
      end
    end
  end
  L10_2 = "%d:%d:%d"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = A0_2
  L13_2 = GetGameTimer
  L13_2 = L13_2()
  L14_2 = math
  L14_2 = L14_2.random
  L15_2 = 100000
  L16_2 = 999999
  L14_2, L15_2, L16_2 = L14_2(L15_2, L16_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L11_2 = L10_1
  L12_2 = {}
  L12_2.token = L10_2
  L12_2.cid = L5_2
  L13_2 = L0_1.plateKey
  L14_2 = L6_2
  L13_2 = L13_2(L14_2)
  L12_2.key = L13_2
  L13_2 = GetGameTimer
  L13_2 = L13_2()
  L12_2.at = L13_2
  L11_2[A0_2] = L12_2
  L11_2 = {}
  L11_2.ok = true
  L11_2.token = L10_2
  L12_2 = L7_2.hash
  L11_2.model = L12_2
  L12_2 = L3_2.minDistance
  L11_2.minDistance = L12_2
  L12_2 = L3_2.maxDistance
  L11_2.maxDistance = L12_2
  L12_2 = L3_2.price
  L11_2.price = L12_2
  L12_2 = L3_2.account
  L11_2.account = L12_2
  L12_2 = L3_2.mode
  L11_2.mode = L12_2
  L12_2 = L3_2.mode
  if "valet" == L12_2 then
    L12_2 = L3_2.valet
    if L12_2 then
      goto lbl_143
    end
  end
  L12_2 = nil
  ::lbl_143::
  L11_2.valet = L12_2
  return L11_2
end
L45_1["garage.deliverPrepare"] = L46_1
function L45_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2
  L5_2 = L41_1
  L6_2 = A3_2.x
  L5_2 = L5_2(L6_2)
  L6_2 = L41_1
  L7_2 = A3_2.y
  L6_2 = L6_2(L7_2)
  L7_2 = L41_1
  L8_2 = A3_2.z
  L7_2 = L7_2(L8_2)
  L8_2 = L41_1
  L9_2 = A3_2.h
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0.0
  end
  if not (L5_2 and L6_2) or not L7_2 then
    L9_2 = L44_1
    L10_2 = "nospot"
    return L9_2(L10_2)
  end
  L9_2 = type
  L10_2 = A3_2.vtype
  L9_2 = L9_2(L10_2)
  if "string" == L9_2 then
    L9_2 = A3_2.vtype
    if L9_2 then
      goto lbl_35
    end
  end
  L9_2 = ""
  ::lbl_35::
  L10_2 = L9_1
  L10_2 = L10_2[L9_2]
  if not L10_2 then
    L10_2 = L44_1
    L11_2 = "type"
    return L10_2(L11_2)
  end
  L10_2 = A4_2.mode
  L10_2 = "valet" == L10_2
  if L10_2 then
    L11_2 = A4_2.valet
    L11_2 = L11_2.maxDistance
    if L11_2 then
      goto lbl_58
    end
  end
  L11_2 = A4_2.maxDistance
  ::lbl_58::
  L12_2 = L40_1
  L13_2 = A0_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L13_2 = L44_1
    L14_2 = "nospot"
    return L13_2(L14_2)
  end
  L13_2 = L12_2.x
  L13_2 = L5_2 - L13_2
  L14_2 = L12_2.y
  L14_2 = L6_2 - L14_2
  L15_2 = math
  L15_2 = L15_2.sqrt
  L16_2 = L13_2 * L13_2
  L17_2 = L14_2 * L14_2
  L16_2 = L16_2 + L17_2
  L15_2 = L15_2(L16_2)
  L16_2 = L11_2 + 40
  if not (L15_2 > L16_2) then
    L15_2 = math
    L15_2 = L15_2.abs
    L16_2 = L12_2.z
    L16_2 = L7_2 - L16_2
    L15_2 = L15_2(L16_2)
    if L10_2 then
      L16_2 = 90
      if L16_2 then
        goto lbl_98
      end
    end
    L16_2 = 60
    ::lbl_98::
    if not (L15_2 > L16_2) then
      goto lbl_104
    end
  end
  L15_2 = L44_1
  L16_2 = "far"
  do return L15_2(L16_2) end
  ::lbl_104::
  L15_2 = L43_1
  L16_2 = A0_2
  L17_2 = A1_2
  L18_2 = A2_2.key
  L19_2 = A4_2
  L15_2, L16_2, L17_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
  if not L15_2 then
    L18_2 = L44_1
    L19_2 = L16_2
    L20_2 = L17_2
    return L18_2(L19_2, L20_2)
  end
  L18_2 = GetGameTimer
  L18_2 = L18_2()
  L19_2 = {}
  function L20_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3
    L0_3 = true
    L1_3 = L19_2
    L1_3 = #L1_3
    L2_3 = 1
    L3_3 = -1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = pcall
      L6_3 = L19_2
      L6_3 = L6_3[L4_3]
      L6_3 = L6_3.fn
      L5_3, L6_3 = L5_3(L6_3)
      if not L5_3 or not L6_3 then
        L7_3 = L19_2
        L7_3 = L7_3[L4_3]
        L7_3 = L7_3.money
        if L7_3 then
          L0_3 = false
        end
        L7_3 = print
        L8_3 = "^1[unique_phone]^0 garage delivery: could not undo \"%s\" for %s (%s, plate %s)%s"
        L9_3 = L8_3
        L8_3 = L8_3.format
        L10_3 = L19_2
        L10_3 = L10_3[L4_3]
        L10_3 = L10_3.what
        L11_3 = tostring
        L12_3 = GetPlayerName
        L13_3 = A0_2
        L12_3, L13_3, L14_3, L15_3, L16_3 = L12_3(L13_3)
        L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3, L16_3)
        L12_3 = tostring
        L13_3 = A1_2
        L12_3 = L12_3(L13_3)
        L13_3 = L15_2.plate
        if L5_3 then
          L14_3 = ""
          if L14_3 then
            goto lbl_47
          end
        end
        L14_3 = ": "
        L15_3 = tostring
        L16_3 = L6_3
        L15_3 = L15_3(L16_3)
        L14_3 = L14_3 .. L15_3
        ::lbl_47::
        L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3 = L8_3(L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
        L7_3(L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
      end
    end
    return L0_3
  end
  L21_2 = L34_1
  L22_2 = A0_2
  L23_2 = A1_2
  L24_2 = L15_2
  L21_2, L22_2 = L21_2(L22_2, L23_2, L24_2)
  if not L21_2 then
    L23_2 = L44_1
    L24_2 = L22_2
    return L23_2(L24_2)
  end
  L23_2 = #L19_2
  L23_2 = L23_2 + 1
  L24_2 = {}
  L24_2.what = "garage state"
  L24_2.fn = L22_2
  L19_2[L23_2] = L24_2
  function L23_2(A0_3)
    local L1_3
    L1_3 = A4_2.price
    if L1_3 > 0 then
      return A0_3
    end
    L1_3 = nil
    return L1_3
  end
  L24_2 = nil
  L25_2 = pcall
  function L26_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = A4_2.price
    if L0_3 > 0 then
      L0_3 = L37_1
      L1_3 = A0_2
      L2_3 = A4_2.account
      L3_3 = A4_2.price
      L4_3 = "Unique_Phone-delivery-"
      L5_3 = L15_2.plate
      L4_3 = L4_3 .. L5_3
      L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3)
      if not L0_3 then
        L0_3 = nil
        L1_3 = L44_1
        L2_3 = "money"
        L3_3 = {}
        L4_3 = A4_2.account
        L3_3.account = L4_3
        L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L1_3(L2_3, L3_3)
        return L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
      end
      L0_3 = L19_2
      L0_3 = #L0_3
      L1_3 = L0_3 + 1
      L0_3 = L19_2
      L2_3 = {}
      L2_3.what = "refund"
      L2_3.money = true
      function L3_3()
        local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4
        L0_4 = L38_1
        L1_4 = A0_2
        L2_4 = A1_2
        L3_4 = A4_2.account
        L4_4 = A4_2.price
        L5_4 = "Unique_Phone-delivery-refund"
        return L0_4(L1_4, L2_4, L3_4, L4_4, L5_4)
      end
      L2_3.fn = L3_3
      L0_3[L1_3] = L2_3
    end
    L0_3 = GetGameTimer
    L0_3 = L0_3()
    L1_3 = L18_2
    L0_3 = L0_3 - L1_3
    L1_3 = 6000
    if L0_3 > L1_3 then
      L0_3 = nil
      L1_3 = L44_1
      L2_3 = "timeout"
      L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L1_3(L2_3)
      return L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    end
    L0_3 = pcall
    L1_3 = CreateVehicleServerSetter
    L2_3 = L20_1
    L3_3 = L15_2.hash
    L2_3 = L2_3(L3_3)
    L3_3 = L9_2
    L4_3 = L5_2
    L4_3 = L4_3 + 0.0
    L5_3 = L6_2
    L5_3 = L5_3 + 0.0
    L6_3 = L7_2
    L6_3 = L6_3 + 0.0
    L7_3 = L8_2
    L7_3 = L7_3 + 0.0
    L0_3, L1_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
    if L0_3 and L1_3 and 0 ~= L1_3 then
      L24_2 = L1_3
      L2_3 = GetGameTimer
      L2_3 = L2_3()
      while true do
        L3_3 = L18_1
        L4_3 = DoesEntityExist
        L5_3 = L1_3
        L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L4_3(L5_3)
        L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
        if L3_3 then
          break
        end
        L3_3 = GetGameTimer
        L3_3 = L3_3()
        L3_3 = L3_3 - L2_3
        L4_3 = 3000
        if not (L3_3 < L4_3) then
          break
        end
        L3_3 = Wait
        L4_3 = 50
        L3_3(L4_3)
      end
    end
    if L0_3 and L1_3 and 0 ~= L1_3 then
      L2_3 = L18_1
      L3_3 = DoesEntityExist
      L4_3 = L1_3
      L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3)
      L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
      if L2_3 then
        goto lbl_133
      end
    end
    L2_3 = print
    L3_3 = "^1[unique_phone]^0 garage delivery: the server could not create %s (model %s, %s) for %s: %s"
    L4_3 = L3_3
    L3_3 = L3_3.format
    L5_3 = L15_2.plate
    L6_3 = tostring
    L7_3 = L15_2.hash
    L6_3 = L6_3(L7_3)
    L7_3 = L9_2
    L8_3 = tostring
    L9_3 = A1_2
    L8_3 = L8_3(L9_3)
    if L0_3 then
      L9_3 = "no entity"
      if L9_3 then
        goto lbl_126
      end
    end
    L9_3 = tostring
    L10_3 = L1_3
    L9_3 = L9_3(L10_3)
    ::lbl_126::
    L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3)
    L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    L2_3 = nil
    L3_3 = L44_1
    L4_3 = "spawn"
    L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3)
    do return L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 end
    ::lbl_133::
    return L1_3
  end
  L25_2, L26_2, L27_2 = L25_2(L26_2)
  if not L25_2 or not L26_2 then
    if not L25_2 then
      L28_2 = print
      L29_2 = "^1[unique_phone]^0 garage delivery error before the vehicle existed: %s"
      L30_2 = L29_2
      L29_2 = L29_2.format
      L31_2 = tostring
      L32_2 = L26_2
      L31_2, L32_2, L33_2, L34_2, L35_2 = L31_2(L32_2)
      L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L29_2(L30_2, L31_2, L32_2, L33_2, L34_2, L35_2)
      L28_2(L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2)
    end
    if L24_2 then
      L28_2 = pcall
      L29_2 = DeleteEntity
      L30_2 = L24_2
      L28_2(L29_2, L30_2)
    end
    L28_2 = L20_2
    L28_2 = L28_2()
    L29_2 = L27_2 or L29_2
    if not L25_2 or not L27_2 then
      L29_2 = L44_1
      L30_2 = "internal"
      L29_2 = L29_2(L30_2)
    end
    L30_2 = L29_2.error
    if "money" ~= L30_2 then
      L30_2 = L23_2
      L31_2 = L28_2
      L30_2 = L30_2(L31_2)
      L29_2.refunded = L30_2
    end
    return L29_2
  end
  L28_2 = L12_1
  L29_2 = os
  L29_2 = L29_2.time
  L29_2 = L29_2()
  L28_2[A1_2] = L29_2
  L28_2 = pcall
  function L29_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3
    L0_3 = pcall
    L1_3 = SetVehicleNumberPlateText
    L2_3 = L26_2
    L3_3 = L15_2.plate
    L0_3(L1_3, L2_3, L3_3)
    L0_3 = pcall
    function L1_3()
      local L0_4, L1_4, L2_4, L3_4
      L0_4 = SetEntityRoutingBucket
      L1_4 = L26_2
      L2_4 = GetPlayerRoutingBucket
      L3_4 = A0_2
      L2_4, L3_4 = L2_4(L3_4)
      L0_4(L1_4, L2_4, L3_4)
    end
    L0_3(L1_3)
    L0_3 = pcall
    L1_3 = SetEntityOrphanMode
    L2_3 = L26_2
    L3_3 = 2
    L0_3(L1_3, L2_3, L3_3)
    L0_3 = 0
    L1_3 = 1
    L2_3 = 20
    L3_3 = 1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = pcall
      L6_3 = NetworkGetNetworkIdFromEntity
      L7_3 = L26_2
      L5_3, L6_3 = L5_3(L6_3, L7_3)
      if L5_3 then
        L7_3 = tonumber
        L8_3 = L6_3
        L7_3 = L7_3(L8_3)
        if L7_3 then
          goto lbl_31
          L0_3 = L7_3 or L0_3
        end
      end
      L0_3 = 0
      ::lbl_31::
      if L0_3 and L0_3 > 0 then
        break
      end
      L7_3 = Wait
      L8_3 = 50
      L7_3(L8_3)
    end
    L1_3 = L0_1.num
    L2_3 = L15_2.row
    L2_3 = L2_3.fuel
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = L0_1.num
      L2_3 = L15_2.props
      L2_3 = L2_3.fuelLevel
      L1_3 = L1_3(L2_3)
      if not L1_3 then
        L1_3 = 100.0
      end
    end
    L2_3 = L0_1.num
    L3_3 = L15_2.row
    L3_3 = L3_3.engine
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = L0_1.num
      L3_3 = L15_2.props
      L3_3 = L3_3.engineHealth
      L2_3 = L2_3(L3_3)
    end
    L3_3 = L0_1.num
    L4_3 = L15_2.row
    L4_3 = L4_3.body
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = L0_1.num
      L4_3 = L15_2.props
      L4_3 = L4_3.bodyHealth
      L3_3 = L3_3(L4_3)
    end
    L4_3 = GetGameTimer
    L4_3 = L4_3()
    L5_3 = pcall
    function L6_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4
      L0_4 = Entity
      L1_4 = L26_2
      L0_4 = L0_4(L1_4)
      L0_4 = L0_4.state
      L1_4 = L0_4
      L0_4 = L0_4.set
      L2_4 = "apex_phone:delivery"
      L3_4 = {}
      L4_4 = L15_2.props
      L3_4.props = L4_4
      L4_4 = L15_2.plate
      L3_4.plate = L4_4
      L4_4 = L1_3
      L3_4.fuel = L4_4
      L4_4 = L2_3
      L3_4.engine = L4_4
      L4_4 = L3_3
      L3_4.body = L4_4
      L4_4 = A0_2
      L3_4.owner = L4_4
      L4_4 = L4_3
      L3_4.t = L4_4
      L4_4 = true
      L0_4(L1_4, L2_4, L3_4, L4_4)
    end
    L5_3(L6_3)
    L5_3 = pcall
    function L6_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4
      L0_4 = Entity
      L1_4 = L26_2
      L0_4 = L0_4(L1_4)
      L0_4 = L0_4.state
      L1_4 = L0_4
      L0_4 = L0_4.set
      L2_4 = "fuel"
      L3_4 = L1_3
      L3_4 = L3_4 + 0.0
      L4_4 = true
      L0_4(L1_4, L2_4, L3_4, L4_4)
    end
    L5_3(L6_3)
    L5_3 = SetTimeout
    L6_3 = 30000
    function L7_3()
      local L0_4, L1_4, L2_4
      L0_4 = L18_1
      L1_4 = DoesEntityExist
      L2_4 = L26_2
      L1_4, L2_4 = L1_4(L2_4)
      L0_4 = L0_4(L1_4, L2_4)
      if L0_4 then
        L0_4 = pcall
        function L1_4()
          local L0_5, L1_5, L2_5, L3_5, L4_5
          L0_5 = Entity
          L1_5 = L26_2
          L0_5 = L0_5(L1_5)
          L0_5 = L0_5.state
          L1_5 = L0_5
          L0_5 = L0_5.set
          L2_5 = "apex_phone:delivery"
          L3_5 = nil
          L4_5 = true
          L0_5(L1_5, L2_5, L3_5, L4_5)
        end
        L0_4(L1_4)
      end
    end
    L5_3(L6_3, L7_3)
    L5_3 = L15_2.name
    if not L5_3 then
      L6_3 = type
      L7_3 = A3_2.modelName
      L6_3 = L6_3(L7_3)
      if "string" == L6_3 then
        L6_3 = A3_2.modelName
        if "" ~= L6_3 then
          L6_3 = L21_1
          L7_3 = A3_2.modelName
          L6_3 = L6_3(L7_3)
          L7_3 = L15_2.hash
          if L6_3 == L7_3 then
            L6_3 = A3_2.modelName
            L7_3 = L6_3
            L6_3 = L6_3.lower
            L6_3 = L6_3(L7_3)
            L7_3 = L6_3
            L6_3 = L6_3.sub
            L8_3 = 1
            L9_3 = 32
            L6_3 = L6_3(L7_3, L8_3, L9_3)
            L5_3 = L6_3
          end
        end
      end
    end
    L6_3 = L25_1
    L7_3 = A0_2
    L8_3 = L26_2
    L9_3 = L15_2.plate
    L10_3 = L5_3
    L11_3 = A4_2.keys
    L6_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3)
    L7_3 = L0_1.isCallable
    L8_3 = L15_2.def
    if L8_3 then
      L8_3 = L15_2.def
      L8_3 = L8_3.deliverAfter
    end
    L7_3 = L7_3(L8_3)
    if L7_3 then
      L7_3 = pcall
      L8_3 = L15_2.def
      L8_3 = L8_3.deliverAfter
      L9_3 = A0_2
      L10_3 = A1_2
      L11_3 = L15_2.plate
      L12_3 = L26_2
      L13_3 = L0_3
      L14_3 = L15_2.row
      L7_3, L8_3 = L7_3(L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
      if not L7_3 then
        L9_3 = L16_1
        L10_3 = "after_"
        L11_3 = tostring
        L12_3 = L15_2.id
        L11_3 = L11_3(L12_3)
        L10_3 = L10_3 .. L11_3
        L11_3 = "%s deliverAfter failed: %s"
        L12_3 = L11_3
        L11_3 = L11_3.format
        L13_3 = tostring
        L14_3 = L15_2.id
        L13_3 = L13_3(L14_3)
        L14_3 = tostring
        L15_3 = L8_3
        L14_3, L15_3, L16_3 = L14_3(L15_3)
        L11_3, L12_3, L13_3, L14_3, L15_3, L16_3 = L11_3(L12_3, L13_3, L14_3, L15_3, L16_3)
        L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
      end
    end
    L7_3 = {}
    L8_3 = os
    L8_3 = L8_3.time
    L8_3 = L8_3()
    L7_3.at = L8_3
    L8_3 = L15_2.plate
    L7_3.plate = L8_3
    L8_3 = L15_2.id
    L7_3.provider = L8_3
    L7_3.keys = L6_3
    L7_3.result = "ok"
    L14_1 = L7_3
    L7_3 = Dbg
    if L7_3 then
      L7_3 = Dbg
      L8_3 = "garage"
      L9_3 = "delivery %s -> %s (%s), netId %s, keys: %s"
      L10_3 = L15_2.plate
      L11_3 = tostring
      L12_3 = A1_2
      L11_3 = L11_3(L12_3)
      L12_3 = L15_2.id
      L13_3 = tostring
      L14_3 = L0_3
      L13_3 = L13_3(L14_3)
      L14_3 = table
      L14_3 = L14_3.concat
      L15_3 = L6_3
      L16_3 = ", "
      L14_3, L15_3, L16_3 = L14_3(L15_3, L16_3)
      L7_3(L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
    end
    L7_3 = pcall
    L8_3 = TriggerEvent
    L9_3 = "apex_phone:vehicleDelivered"
    L10_3 = A0_2
    L11_3 = {}
    L12_3 = A1_2
    L11_3.cid = L12_3
    L12_3 = L15_2.plate
    L11_3.plate = L12_3
    L11_3.netId = L0_3
    L12_3 = L15_2.hash
    L11_3.model = L12_3
    L12_3 = L15_2.id
    L11_3.provider = L12_3
    L12_3 = A4_2.price
    L11_3.price = L12_3
    L12_3 = L10_2
    L11_3.valet = L12_3
    L7_3(L8_3, L9_3, L10_3, L11_3)
    L7_3 = {}
    L7_3.ok = true
    L7_3.netId = L0_3
    L8_3 = L15_2.plate
    L7_3.plate = L8_3
    L8_3 = L5_2
    L7_3.x = L8_3
    L8_3 = L6_2
    L7_3.y = L8_3
    L8_3 = L7_2
    L7_3.z = L8_3
    L8_3 = L15_2.props
    L7_3.props = L8_3
    L7_3.fuel = L1_3
    L7_3.engine = L2_3
    L7_3.body = L3_3
    L7_3.t = L4_3
    L8_3 = A4_2.price
    L7_3.price = L8_3
    L8_3 = A4_2.account
    L7_3.account = L8_3
    L8_3 = L10_2
    L7_3.valet = L8_3
    return L7_3
  end
  L28_2, L29_2 = L28_2(L29_2)
  if L28_2 then
    L30_2 = type
    L31_2 = L29_2
    L30_2 = L30_2(L31_2)
    if "table" == L30_2 then
      return L29_2
    end
  end
  L30_2 = print
  L31_2 = "^1[unique_phone]^0 garage delivery: %s was delivered but finishing it failed: %s"
  L32_2 = L31_2
  L31_2 = L31_2.format
  L33_2 = L15_2.plate
  L34_2 = tostring
  L35_2 = L29_2
  L34_2, L35_2 = L34_2(L35_2)
  L31_2, L32_2, L33_2, L34_2, L35_2 = L31_2(L32_2, L33_2, L34_2, L35_2)
  L30_2(L31_2, L32_2, L33_2, L34_2, L35_2)
  L30_2 = pcall
  L31_2 = NetworkGetNetworkIdFromEntity
  L32_2 = L26_2
  L30_2, L31_2 = L30_2(L31_2, L32_2)
  L32_2 = {}
  L32_2.ok = true
  if L30_2 then
    L33_2 = tonumber
    L34_2 = L31_2
    L33_2 = L33_2(L34_2)
    if L33_2 then
      goto lbl_223
    end
  end
  L33_2 = 0
  ::lbl_223::
  L32_2.netId = L33_2
  L33_2 = L15_2.plate
  L32_2.plate = L33_2
  L32_2.x = L5_2
  L32_2.y = L6_2
  L32_2.z = L7_2
  L33_2 = L15_2.props
  L32_2.props = L33_2
  L33_2 = GetGameTimer
  L33_2 = L33_2()
  L32_2.t = L33_2
  L33_2 = A4_2.price
  L32_2.price = L33_2
  L33_2 = A4_2.account
  L32_2.account = L33_2
  return L32_2
end
L46_1 = RPC
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L10_1
  L2_2 = L2_2[A0_2]
  L3_2 = L10_1
  L3_2[A0_2] = nil
  L3_2 = L23_1
  L3_2, L4_2 = L3_2()
  if L3_2 then
    L5_2 = L44_1
    L6_2 = L3_2
    return L5_2(L6_2)
  end
  L5_2 = DeviceSessions
  if L5_2 then
    L5_2 = DeviceSessions
    L5_2 = L5_2[A0_2]
    if L5_2 then
      L5_2 = L44_1
      L6_2 = "foreign"
      return L5_2(L6_2)
    end
  end
  if L2_2 then
    L5_2 = type
    L6_2 = A1_2.token
    L5_2 = L5_2(L6_2)
    if "string" == L5_2 then
      L5_2 = L2_2.token
      L6_2 = A1_2.token
      if L5_2 == L6_2 then
        L5_2 = GetGameTimer
        L5_2 = L5_2()
        L6_2 = L2_2.at
        L5_2 = L5_2 - L6_2
        L6_2 = 30000
        if not (L5_2 > L6_2) then
          goto lbl_57
        end
      end
    end
  end
  L5_2 = L44_1
  L6_2 = "ticket"
  do return L5_2(L6_2) end
  ::lbl_57::
  L5_2 = FW
  L5_2 = L5_2.GetCidPhone
  L6_2 = A0_2
  L5_2, L6_2 = L5_2(L6_2)
  if L5_2 and L6_2 then
    L7_2 = L2_2.cid
    if L6_2 == L7_2 then
      goto lbl_72
    end
  end
  L7_2 = L44_1
  L8_2 = "ticket"
  do return L7_2(L8_2) end
  ::lbl_72::
  L7_2 = L11_1
  L7_2 = L7_2[L6_2]
  if L7_2 then
    L7_2 = L44_1
    L8_2 = "busy"
    return L7_2(L8_2)
  end
  L7_2 = L11_1
  L7_2[L6_2] = true
  L7_2 = table
  L7_2 = L7_2.pack
  L8_2 = pcall
  L9_2 = L45_1
  L10_2 = A0_2
  L11_2 = L6_2
  L12_2 = L2_2
  L13_2 = A1_2
  L14_2 = L4_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L8_2 = L11_1
  L8_2[L6_2] = nil
  L8_2 = L7_2[1]
  if not L8_2 then
    L8_2 = print
    L9_2 = "^1[unique_phone]^0 garage delivery error: %s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = tostring
    L12_2 = L7_2[2]
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L8_2 = {}
    L9_2 = os
    L9_2 = L9_2.time
    L9_2 = L9_2()
    L8_2.at = L9_2
    L9_2 = L2_2.key
    L8_2.plate = L9_2
    L9_2 = "error: "
    L10_2 = tostring
    L11_2 = L7_2[2]
    L10_2 = L10_2(L11_2)
    L9_2 = L9_2 .. L10_2
    L8_2.result = L9_2
    L14_1 = L8_2
    L8_2 = L44_1
    L9_2 = "internal"
    return L8_2(L9_2)
  end
  L8_2 = L7_2[2]
  L9_2 = type
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = L8_2.ok
    if not L9_2 then
      L9_2 = {}
      L10_2 = os
      L10_2 = L10_2.time
      L10_2 = L10_2()
      L9_2.at = L10_2
      L10_2 = L2_2.key
      L9_2.plate = L10_2
      L10_2 = tostring
      L11_2 = L8_2.error
      L10_2 = L10_2(L11_2)
      L9_2.result = L10_2
      L14_1 = L9_2
    end
  end
  return L8_2
end
L46_1["garage.deliver"] = L47_1
L46_1 = Config
L46_1 = L46_1.RateLimit
L47_1 = type
L48_1 = L46_1
L47_1 = L47_1(L48_1)
if "table" == L47_1 then
  L47_1 = type
  L48_1 = L46_1.costs
  L47_1 = L47_1(L48_1)
  if "table" ~= L47_1 then
    L47_1 = {}
    L46_1.costs = L47_1
  end
  L47_1 = L46_1.costs
  L47_1 = L47_1["garage.deliverPrepare"]
  if nil == L47_1 then
    L47_1 = L46_1.costs
    L47_1["garage.deliverPrepare"] = 3
  end
  L47_1 = L46_1.costs
  L47_1 = L47_1["garage.deliver"]
  if nil == L47_1 then
    L47_1 = L46_1.costs
    L47_1["garage.deliver"] = 5
  end
end
L46_1 = RegisterCommand
L47_1 = "phonedelivery"
function L48_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  if 0 ~= A0_2 then
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3
      L0_3 = FW
      L0_3 = L0_3.IsAdmin
      L1_3 = A0_2
      return L0_3(L1_3)
    end
    L1_2, L2_2 = L1_2(L2_2)
    if not L1_2 or not L2_2 then
      return
    end
  end
  L1_2 = L23_1
  L1_2, L2_2 = L1_2()
  L3_2 = Integration
  L4_2 = "garage"
  L3_2, L4_2 = L3_2(L4_2)
  L5_2 = print
  L6_2 = "^2[unique_phone]^0 garage delivery: %s | mode %s | framework %s | OneSync %s | garage provider %s | price %s %s | cooldown %ss | distance %s-%s m | keys %s"
  L7_2 = L6_2
  L6_2 = L6_2.format
  if L1_2 then
    L8_2 = "OFF ("
    L9_2 = L1_2
    L10_2 = ")"
    L8_2 = L8_2 .. L9_2 .. L10_2
    if L8_2 then
      goto lbl_28
    end
  end
  L8_2 = "ON"
  ::lbl_28::
  L9_2 = L2_2.mode
  L10_2 = tostring
  L11_2 = FW
  L11_2 = L11_2.name
  L10_2 = L10_2(L11_2)
  L11_2 = L22_1
  L11_2 = L11_2()
  if L11_2 then
    L11_2 = "on"
    if L11_2 then
      goto lbl_41
    end
  end
  L11_2 = "OFF"
  ::lbl_41::
  L12_2 = tostring
  L13_2 = L4_2
  L12_2 = L12_2(L13_2)
  L13_2 = tostring
  L14_2 = L2_2.price
  L13_2 = L13_2(L14_2)
  L14_2 = L2_2.account
  L15_2 = tostring
  L16_2 = L2_2.cooldown
  L15_2 = L15_2(L16_2)
  L16_2 = tostring
  L17_2 = L2_2.minDistance
  L16_2 = L16_2(L17_2)
  L17_2 = tostring
  L18_2 = L2_2.maxDistance
  L17_2 = L17_2(L18_2)
  L18_2 = L2_2.keys
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L5_2 = L2_2.mode
  if "valet" == L5_2 then
    L5_2 = print
    L6_2 = "  valet: ped %s | drives from %s-%s m away | timeout %ss | speed %s m/s | driving style %s"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = L2_2.valet
    L8_2 = L8_2.ped
    L9_2 = tostring
    L10_2 = L2_2.valet
    L10_2 = L10_2.minDistance
    L9_2 = L9_2(L10_2)
    L10_2 = tostring
    L11_2 = L2_2.valet
    L11_2 = L11_2.maxDistance
    L10_2 = L10_2(L11_2)
    L11_2 = tostring
    L12_2 = L2_2.valet
    L12_2 = L12_2.timeout
    L11_2 = L11_2(L12_2)
    L12_2 = tostring
    L13_2 = L2_2.valet
    L13_2 = L13_2.speed
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = L2_2.valet
    L14_2 = L14_2.drivingStyle
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L13_2(L14_2)
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L24_1
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L0_1.started
    L13_2 = L11_2.name
    L12_2 = L12_2(L13_2)
    if L12_2 then
      L12_2 = #L5_2
      L12_2 = L12_2 + 1
      L13_2 = L11_2.name
      L5_2[L12_2] = L13_2
    end
  end
  L6_2 = print
  L7_2 = "  key resources fed by the server: %s"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = #L5_2
  if L9_2 > 0 then
    L9_2 = table
    L9_2 = L9_2.concat
    L10_2 = L5_2
    L11_2 = ", "
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      goto lbl_123
    end
  end
  L9_2 = "none started (client-only key scripts are fed by the client)"
  ::lbl_123::
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L7_2(L8_2, L9_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L6_2 = L14_1
  if L6_2 then
    L6_2 = print
    L7_2 = "  last delivery: %s plate %s via %s -> %s%s"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = os
    L9_2 = L9_2.date
    L10_2 = "%H:%M:%S"
    L11_2 = L14_1.at
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = tostring
    L11_2 = L14_1.plate
    L10_2 = L10_2(L11_2)
    L11_2 = tostring
    L12_2 = L14_1.provider
    if not L12_2 then
      L12_2 = "?"
    end
    L11_2 = L11_2(L12_2)
    L12_2 = tostring
    L13_2 = L14_1.result
    L12_2 = L12_2(L13_2)
    L13_2 = L14_1.keys
    if L13_2 then
      L13_2 = "; keys: "
      L14_2 = table
      L14_2 = L14_2.concat
      L15_2 = L14_1.keys
      L16_2 = ", "
      L14_2 = L14_2(L15_2, L16_2)
      L13_2 = L13_2 .. L14_2
      if L13_2 then
        goto lbl_161
      end
    end
    L13_2 = ""
    ::lbl_161::
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  else
    L6_2 = print
    L7_2 = "  last delivery: none since the phone started"
    L6_2(L7_2)
  end
end
L49_1 = false
L46_1(L47_1, L48_1, L49_1)
