local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1
function L0_1()
  local L0_2, L1_2
  L0_2 = GetResourceState
  L1_2 = "qb-houses"
  L0_2 = L0_2(L1_2)
  L0_2 = "started" == L0_2
  return L0_2
end
L1_1 = {}
L2_1 = RegisterNetEvent
L3_1 = "qb-houses:server:lockHouse"
function L4_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = L1_1
    if A0_2 then
      L3_2 = true
      if L3_2 then
        goto lbl_13
      end
    end
    L3_2 = false
    ::lbl_13::
    L2_2[A1_2] = L3_2
  end
end
L2_1(L3_1, L4_1)
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    return A0_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 or "null" == A0_2 then
    L1_2 = {}
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 and L2_2 then
      goto lbl_35
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = {}
  ::lbl_35::
  return L3_2
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L2_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2.enter
  if not L2_2 then
    L2_2 = L1_2
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
  if not L3_2 or not L4_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = {}
  L6_2.x = L3_2
  L6_2.y = L4_2
  L7_2 = L5_2 or L7_2
  if not L5_2 then
    L7_2 = 0
  end
  L6_2.z = L7_2
  return L6_2
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = {}
  L2_2 = #A0_2
  if 0 == L2_2 then
    return L1_2
  end
  L2_2 = {}
  L3_2 = 1
  L4_2 = #A0_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L2_2[L6_2] = "?"
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT citizenid, charinfo FROM players WHERE citizenid IN (%s)"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = table
  L6_2 = L6_2.concat
  L7_2 = L2_2
  L8_2 = ","
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2, L8_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L5_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L2_1
    L11_2 = L9_2.charinfo
    L10_2 = L10_2(L11_2)
    L11_2 = L10_2.firstname
    if not L11_2 then
      L11_2 = ""
    end
    L12_2 = " "
    L13_2 = L10_2.lastname
    if not L13_2 then
      L13_2 = ""
    end
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = L11_2
    L11_2 = L11_2.gsub
    L13_2 = "^%s+"
    L14_2 = ""
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    L12_2 = L11_2
    L11_2 = L11_2.gsub
    L13_2 = "%s+$"
    L14_2 = ""
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    L12_2 = L9_2.citizenid
    L13_2 = L11_2 or L13_2
    if "" == L11_2 or not L11_2 then
      L13_2 = nil
    end
    L1_2[L12_2] = L13_2
  end
  return L1_2
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = L0_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.off = true
    return L2_2
  end
  L2_2 = L1_2.cid
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT house, citizenid, keyholders FROM player_houses WHERE citizenid = ? OR keyholders LIKE ?"
    L2_3 = {}
    L3_3 = L2_2
    L4_3 = "%\""
    L5_3 = L2_2
    L6_3 = "\"%"
    L4_3 = L4_3 .. L5_3 .. L6_3
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L0_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = {}
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L0_3
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = L2_1
      L10_3 = L8_3.keyholders
      L9_3 = L9_3(L10_3)
      L10_3 = L8_3.citizenid
      L11_3 = L2_2
      L10_3 = L10_3 == L11_3
      if not L10_3 then
        L11_3 = ipairs
        L12_3 = L9_3
        L11_3, L12_3, L13_3, L14_3 = L11_3(L12_3)
        for L15_3, L16_3 in L11_3, L12_3, L13_3, L14_3 do
          L17_3 = L2_2
          if L16_3 == L17_3 then
            L10_3 = true
            break
          end
        end
      end
      if L10_3 then
        L11_3 = #L1_3
        L11_3 = L11_3 + 1
        L12_3 = L8_3.house
        L1_3[L11_3] = L12_3
        L11_3 = L8_3.house
        L12_3 = {}
        L13_3 = L8_3.citizenid
        L14_3 = L2_2
        L13_3 = L13_3 == L14_3
        L12_3.owner = L13_3
        L13_3 = L8_3.citizenid
        L12_3.ownerCid = L13_3
        L12_3.holders = L9_3
        L2_3[L11_3] = L12_3
      end
    end
    L3_3 = #L1_3
    if 0 == L3_3 then
      L3_3 = {}
      L4_3 = {}
      L3_3.houses = L4_3
      return L3_3
    end
    L3_3 = {}
    L4_3 = 1
    L5_3 = #L1_3
    L6_3 = 1
    for L7_3 = L4_3, L5_3, L6_3 do
      L3_3[L7_3] = "?"
    end
    L4_3 = MySQL
    L4_3 = L4_3.query
    L4_3 = L4_3.await
    L5_3 = "SELECT name, label, coords, garage, tier, price FROM houselocations WHERE name IN (%s)"
    L6_3 = L5_3
    L5_3 = L5_3.format
    L7_3 = table
    L7_3 = L7_3.concat
    L8_3 = L3_3
    L9_3 = ","
    L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3 = L7_3(L8_3, L9_3)
    L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3)
    L6_3 = L1_3
    L4_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L4_3 = {}
    end
    L5_3 = {}
    L6_3 = {}
    L7_3 = pairs
    L8_3 = L2_3
    L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
    for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
      L13_3 = L12_3.owner
      if L13_3 then
        L13_3 = ipairs
        L14_3 = L12_3.holders
        L13_3, L14_3, L15_3, L16_3 = L13_3(L14_3)
        for L17_3, L18_3 in L13_3, L14_3, L15_3, L16_3 do
          L19_3 = type
          L20_3 = L18_3
          L19_3 = L19_3(L20_3)
          if "string" == L19_3 then
            L19_3 = L2_2
            if L18_3 ~= L19_3 then
              L19_3 = L6_3[L18_3]
              if not L19_3 then
                L6_3[L18_3] = true
                L19_3 = #L5_3
                L19_3 = L19_3 + 1
                L5_3[L19_3] = L18_3
              end
            end
          end
        end
      else
        L13_3 = type
        L14_3 = L12_3.ownerCid
        L13_3 = L13_3(L14_3)
        if "string" == L13_3 then
          L13_3 = L12_3.ownerCid
          L13_3 = L6_3[L13_3]
          if not L13_3 then
            L13_3 = L12_3.ownerCid
            L6_3[L13_3] = true
            L13_3 = #L5_3
            L13_3 = L13_3 + 1
            L14_3 = L12_3.ownerCid
            L5_3[L13_3] = L14_3
          end
        end
      end
    end
    L7_3 = L4_1
    L8_3 = L5_3
    L7_3 = L7_3(L8_3)
    L8_3 = {}
    L9_3 = ipairs
    L10_3 = L4_3
    L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
    for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
      L15_3 = L14_3.name
      L15_3 = L2_3[L15_3]
      if L15_3 then
        L16_3 = {}
        L17_3 = L15_3.owner
        if L17_3 then
          L17_3 = ipairs
          L18_3 = L15_3.holders
          L17_3, L18_3, L19_3, L20_3 = L17_3(L18_3)
          for L21_3, L22_3 in L17_3, L18_3, L19_3, L20_3 do
            L23_3 = type
            L24_3 = L22_3
            L23_3 = L23_3(L24_3)
            if "string" == L23_3 then
              L23_3 = L2_2
              if L22_3 ~= L23_3 then
                L23_3 = #L16_3
                L23_3 = L23_3 + 1
                L24_3 = {}
                L24_3.cid = L22_3
                L25_3 = L7_3[L22_3]
                if not L25_3 then
                  L25_3 = "Sem nome"
                end
                L24_3.name = L25_3
                L25_3 = GetNumberByCitizenId
                L26_3 = L22_3
                L25_3 = L25_3(L26_3)
                L24_3.number = L25_3
                L25_3 = FW
                L25_3 = L25_3.GetPlayerByCid
                L26_3 = L22_3
                L25_3 = L25_3(L26_3)
                L25_3 = nil ~= L25_3
                L24_3.online = L25_3
                L16_3[L23_3] = L24_3
              end
            end
          end
        end
        L17_3 = L2_1
        L18_3 = L14_3.garage
        L17_3 = L17_3(L18_3)
        L18_3 = #L8_3
        L18_3 = L18_3 + 1
        L19_3 = {}
        L20_3 = L14_3.name
        L19_3.name = L20_3
        L20_3 = L14_3.label
        if not L20_3 then
          L20_3 = L14_3.name
        end
        L19_3.label = L20_3
        L20_3 = L15_3.owner
        L19_3.owner = L20_3
        L20_3 = L15_3.owner
        if not L20_3 then
          L20_3 = L15_3.ownerCid
          L20_3 = L7_3[L20_3]
          if L20_3 then
            goto lbl_247
          end
          L20_3 = "Outro jogador"
          if L20_3 then
            goto lbl_247
          end
        end
        L20_3 = nil
        ::lbl_247::
        L19_3.ownerName = L20_3
        L20_3 = L3_1
        L21_3 = L14_3.coords
        L20_3 = L20_3(L21_3)
        L19_3.coords = L20_3
        L20_3 = tonumber
        L21_3 = L17_3.x
        L20_3 = L20_3(L21_3)
        if L20_3 then
          L20_3 = tonumber
          L21_3 = L17_3.y
          L20_3 = L20_3(L21_3)
          if L20_3 then
            L20_3 = {}
            L21_3 = tonumber
            L22_3 = L17_3.x
            L21_3 = L21_3(L22_3)
            L20_3.x = L21_3
            L21_3 = tonumber
            L22_3 = L17_3.y
            L21_3 = L21_3(L22_3)
            L20_3.y = L21_3
            if L20_3 then
              goto lbl_275
            end
          end
        end
        L20_3 = nil
        ::lbl_275::
        L19_3.garage = L20_3
        L20_3 = tonumber
        L21_3 = L14_3.tier
        L20_3 = L20_3(L21_3)
        L19_3.tier = L20_3
        L20_3 = tonumber
        L21_3 = L14_3.price
        L20_3 = L20_3(L21_3)
        L19_3.price = L20_3
        L19_3.keyholders = L16_3
        L21_3 = L14_3.name
        L20_3 = L1_1
        L20_3 = L20_3[L21_3]
        L20_3 = false ~= L20_3
        L19_3.locked = L20_3
        L8_3[L18_3] = L19_3
      end
    end
    L9_3 = table
    L9_3 = L9_3.sort
    L10_3 = L8_3
    function L11_3(A0_4, A1_4)
      local L2_4, L3_4, L4_4
      L2_4 = A0_4.owner
      L3_4 = A1_4.owner
      if L2_4 ~= L3_4 then
        L2_4 = A0_4.owner
        return L2_4
      end
      L2_4 = tostring
      L3_4 = A0_4.label
      L2_4 = L2_4(L3_4)
      L3_4 = tostring
      L4_4 = A1_4.label
      L3_4 = L3_4(L4_4)
      L2_4 = L2_4 < L3_4
      return L2_4
    end
    L9_3(L10_3, L11_3)
    L9_3 = {}
    L9_3.houses = L8_3
    return L9_3
  end
  L3_2, L4_2 = L3_2(L4_2)
  if not L3_2 then
    L5_2 = print
    L6_2 = "^1[unique_phone]^0 house.list: %s"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = tostring
    L9_2 = L4_2
    L8_2, L9_2 = L8_2(L9_2)
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = {}
    L5_2.error = "internal"
    return L5_2
  end
  return L4_2
end
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = A0_2.raw
    if L0_3 then
      L0_3 = A0_2.raw
      L0_3 = L0_3.PlayerData
      if L0_3 then
        L0_3 = A0_2.raw
        L0_3 = L0_3.PlayerData
        L0_3 = L0_3.license
        if L0_3 then
          goto lbl_14
        end
      end
    end
    L0_3 = nil
    ::lbl_14::
    L1_3 = exports
    L1_3 = L1_3["qb-houses"]
    L2_3 = L1_3
    L1_3 = L1_3.hasKey
    L3_3 = L0_3
    L4_3 = A0_2.cid
    L5_3 = A1_2
    return L1_3(L2_3, L3_3, L4_3, L5_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 and L3_2 then
    L4_2 = true
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT citizenid, keyholders FROM player_houses WHERE house = ?"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L4_2.citizenid
  L6_2 = A0_2.cid
  if L5_2 == L6_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = ipairs
  L6_2 = L2_1
  L7_2 = L4_2.keyholders
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = A0_2.cid
    if L10_2 == L11_2 then
      L11_2 = true
      return L11_2
    end
  end
  L5_2 = false
  return L5_2
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L0_1
  L3_2 = L3_2()
  if not L3_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "off"
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2.house
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.house
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 64
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_34
    end
  end
  L3_2 = nil
  ::lbl_34::
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = L6_1
  L5_2 = L2_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "nokey"
    return L4_2
  end
  L4_2 = A1_2.locked
  L4_2 = false ~= L4_2
  L5_2 = L1_1
  L5_2[L3_2] = L4_2
  L5_2 = TriggerClientEvent
  L6_2 = "qb-houses:client:lockHouse"
  L7_2 = -1
  L8_2 = L4_2
  L9_2 = L3_2
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = TriggerEvent
  L6_2 = "apex_phone:homeToggle"
  L7_2 = A0_2
  L8_2 = {}
  L8_2.house = L3_2
  L8_2.locked = L4_2
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = {}
  L5_2.ok = true
  L5_2.locked = L4_2
  return L5_2
end
L8_1 = PhoneIntegrations
L9_1 = L8_1.defineBuiltin
L10_1 = "housing"
L11_1 = {}
L11_1.label = "qb-houses (phone built-in)"
function L12_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L5_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L1_2.houses
    if L2_2 then
      goto lbl_14
    end
  end
  L2_2 = {}
  ::lbl_14::
  return L2_2
end
L11_1.list = L12_1
function L12_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2
  L4_2 = L7_1
  L5_2 = A0_2
  L6_2 = {}
  L6_2.house = A2_2
  L6_2.locked = A3_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L4_2.ok
  L5_2 = true == L5_2
  L6_2 = L4_2.error
  return L5_2, L6_2
end
L11_1.lock = L12_1
L9_1(L10_1, L11_1)
L9_1 = {}
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = {}
  L3_2 = type
  L4_2 = A0_2.keyholders
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    return L2_2
  end
  L3_2 = ipairs
  L4_2 = A0_2.keyholders
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.cid
      if L9_2 then
        goto lbl_28
      end
      L9_2 = L8_2.citizenid
      if L9_2 then
        goto lbl_28
      end
      L9_2 = L8_2.identifier
      if L9_2 then
        goto lbl_28
      end
    end
    L9_2 = L8_2
    ::lbl_28::
    if nil ~= L9_2 then
      L10_2 = tostring
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "" ~= L10_2 then
        L10_2 = tostring
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        L11_2 = tostring
        L12_2 = A1_2
        L11_2 = L11_2(L12_2)
        if L10_2 ~= L11_2 then
          L10_2 = tostring
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          L9_2 = L10_2
          L10_2 = L8_1.nameOf
          L11_2 = L9_2
          L10_2, L11_2 = L10_2(L11_2)
          if not L10_2 then
            L12_2 = type
            L13_2 = L8_2
            L12_2 = L12_2(L13_2)
            if "table" == L12_2 then
              L12_2 = type
              L13_2 = L8_2.name
              L12_2 = L12_2(L13_2)
              if "string" == L12_2 then
                L12_2 = L8_2.name
                if "" ~= L12_2 then
                  L10_2 = L8_2.name
                end
              end
            end
          end
          L12_2 = #L2_2
          L12_2 = L12_2 + 1
          L13_2 = {}
          L13_2.cid = L9_2
          L14_2 = L10_2 or L14_2
          if not L10_2 then
            L14_2 = "Sem nome"
          end
          L13_2.name = L14_2
          L14_2 = GetNumberByCitizenId
          L15_2 = L9_2
          L14_2 = L14_2(L15_2)
          L13_2.number = L14_2
          L14_2 = nil ~= L11_2
          L13_2.online = L14_2
          L2_2[L12_2] = L13_2
        end
      end
    end
  end
  return L2_2
end
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L3_2 = {}
  L4_2 = IntegrationHas
  L5_2 = "housing"
  L6_2 = "giveKey"
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = IntegrationHas
    L5_2 = "housing"
    L6_2 = "removeKey"
    L4_2 = L4_2(L5_2, L6_2)
  end
  L5_2 = ipairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L10_2.id
      if L11_2 then
        goto lbl_29
      end
      L11_2 = L10_2.name
      if L11_2 then
        goto lbl_29
      end
    end
    L11_2 = nil
    ::lbl_29::
    if nil ~= L11_2 then
      L12_2 = tostring
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "" ~= L12_2 then
        L12_2 = tostring
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        L13_2 = L12_2
        L12_2 = L12_2.sub
        L14_2 = 1
        L15_2 = 64
        L12_2 = L12_2(L13_2, L14_2, L15_2)
        L11_2 = L12_2
        L12_2 = L10_2.owner
        L12_2 = true == L12_2
        L13_2 = L8_1.xyz
        L14_2 = L10_2.coords
        L13_2 = L13_2(L14_2)
        L14_2 = L8_1.xyz
        L15_2 = L10_2.garage
        L14_2 = L14_2(L15_2)
        L15_2 = L10_2.locked
        if nil == L15_2 then
          L16_2 = A2_2
          L17_2 = "|"
          L18_2 = L11_2
          L16_2 = L16_2 .. L17_2 .. L18_2
          L17_2 = L9_1
          L15_2 = L17_2[L16_2]
        end
        L16_2 = #L3_2
        L16_2 = L16_2 + 1
        L17_2 = {}
        L17_2.name = L11_2
        L18_2 = tostring
        L19_2 = L10_2.label
        if not L19_2 then
          L19_2 = L11_2
        end
        L18_2 = L18_2(L19_2)
        L17_2.label = L18_2
        L17_2.owner = L12_2
        if not L12_2 then
          L18_2 = L10_2.ownerName
          if L18_2 then
            goto lbl_97
          end
          L18_2 = L10_2.ownerCid
          if L18_2 then
            L18_2 = L8_1.nameOf
            L19_2 = tostring
            L20_2 = L10_2.ownerCid
            L19_2, L20_2 = L19_2(L20_2)
            L18_2 = L18_2(L19_2, L20_2)
            if L18_2 then
              goto lbl_97
            end
          end
          L18_2 = "Outro jogador"
          if L18_2 then
            goto lbl_97
          end
        end
        L18_2 = nil
        ::lbl_97::
        L17_2.ownerName = L18_2
        L17_2.coords = L13_2
        if L14_2 then
          L18_2 = {}
          L19_2 = L14_2.x
          L18_2.x = L19_2
          L19_2 = L14_2.y
          L18_2.y = L19_2
          if L18_2 then
            goto lbl_110
          end
        end
        L18_2 = nil
        ::lbl_110::
        L17_2.garage = L18_2
        L18_2 = L8_1.num
        L19_2 = L10_2.tier
        L18_2 = L18_2(L19_2)
        L17_2.tier = L18_2
        L18_2 = L8_1.num
        L19_2 = L10_2.price
        L18_2 = L18_2(L19_2)
        L17_2.price = L18_2
        if L12_2 then
          L18_2 = L10_1
          L19_2 = L10_2
          L20_2 = A1_2
          L18_2 = L18_2(L19_2, L20_2)
          if L18_2 then
            goto lbl_129
          end
        end
        L18_2 = {}
        ::lbl_129::
        L17_2.keyholders = L18_2
        L18_2 = false ~= L15_2
        L17_2.locked = L18_2
        if L4_2 then
          L18_2 = L10_2.keys
          if false ~= L18_2 then
            L18_2 = "server"
            if L18_2 then
              goto lbl_144
            end
          end
        end
        L18_2 = "none"
        ::lbl_144::
        L17_2.keyMode = L18_2
        L18_2 = L10_2.lockable
        L18_2 = false ~= L18_2
        L17_2.lockable = L18_2
        L3_2[L16_2] = L17_2
      end
    end
  end
  L5_2 = table
  L5_2 = L5_2.sort
  L6_2 = L3_2
  function L7_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = A0_3.owner
    L3_3 = A1_3.owner
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.owner
      return L2_3
    end
    L2_3 = tostring
    L3_3 = A0_3.label
    L2_3 = L2_3(L3_3)
    L3_3 = tostring
    L4_3 = A1_3.label
    L3_3 = L3_3(L4_3)
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L5_2(L6_2, L7_2)
  return L3_2
end
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = IntegrationTry
  L4_2 = "housing"
  L5_2 = "list"
  L6_2 = A0_2
  L7_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      goto lbl_16
    end
  end
  L5_2 = nil
  do return L5_2 end
  ::lbl_16::
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L10_2.id
      if L11_2 then
        goto lbl_32
      end
      L11_2 = L10_2.name
      if L11_2 then
        goto lbl_32
      end
    end
    L11_2 = nil
    ::lbl_32::
    if nil ~= L11_2 then
      L12_2 = tostring
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      L13_2 = L12_2
      L12_2 = L12_2.sub
      L14_2 = 1
      L15_2 = 64
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      if L12_2 == A2_2 then
        return L10_2
      end
    end
  end
  L5_2 = nil
  return L5_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A1_2.error
    if not L2_2 then
      goto lbl_10
    end
  end
  do return A1_2 end
  ::lbl_10::
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = L8_1.housingExtras
    if L3_2 then
      goto lbl_20
    end
  end
  do return A1_2 end
  ::lbl_20::
  L3_2 = L8_1.housingExtras
  L4_2 = A0_2
  L5_2 = L2_2.cid
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = #L3_2
  if 0 == L4_2 then
    return A1_2
  end
  L4_2 = type
  L5_2 = A1_2.houses
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A1_2.houses
    if L4_2 then
      goto lbl_38
    end
  end
  L4_2 = {}
  ::lbl_38::
  L5_2 = ipairs
  L6_2 = L11_1
  L7_2 = L3_2
  L8_2 = L2_2.cid
  L9_2 = "apt"
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2, L8_2, L9_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L4_2[L11_2] = L10_2
  end
  L5_2 = table
  L5_2 = L5_2.sort
  L6_2 = L4_2
  function L7_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = A0_3.owner
    L3_3 = A1_3.owner
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.owner
      return L2_3
    end
    L2_3 = tostring
    L3_3 = A0_3.label
    L2_3 = L2_3(L3_3)
    L3_3 = tostring
    L4_3 = A1_3.label
    L3_3 = L3_3(L4_3)
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L5_2(L6_2, L7_2)
  L5_2 = L4_2
  A1_2.off = nil
  A1_2.houses = L5_2
  return A1_2
end
L14_1 = RPC
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = Integration
  L2_2 = "housing"
  L1_2, L2_2 = L1_2(L2_2)
  if "builtin" == L2_2 then
    L3_2 = L13_1
    L4_2 = A0_2
    L5_2 = L5_1
    L6_2 = A0_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2)
    return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayer
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "noplayer"
    return L4_2
  end
  L4_2 = IntegrationTry
  L5_2 = "housing"
  L6_2 = "list"
  L7_2 = A0_2
  L8_2 = L3_2.cid
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_43
    end
  end
  L6_2 = L13_1
  L7_2 = A0_2
  L8_2 = L5_1
  L9_2 = A0_2
  L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2)
  do return L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2) end
  ::lbl_43::
  L6_2 = L13_1
  L7_2 = A0_2
  L8_2 = {}
  L9_2 = L11_1
  L10_2 = L5_2
  L11_2 = L3_2.cid
  L12_2 = L2_2
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L8_2.houses = L9_2
  L8_2.provider = L2_2
  return L6_2(L7_2, L8_2)
end
L14_1["house.list"] = L15_1
L14_1 = RPC
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L8_1.isExtraHouse
  if L2_2 then
    L2_2 = L8_1.isExtraHouse
    L3_2 = A1_2.house
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = {}
      L2_2.ok = false
      L2_2.error = "nolock"
      return L2_2
    end
  end
  L2_2 = Integration
  L3_2 = "housing"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" == L3_2 then
    L4_2 = L7_1
    L5_2 = A0_2
    L6_2 = A1_2
    return L4_2(L5_2, L6_2)
  end
  L4_2 = FW
  L4_2 = L4_2.GetPlayer
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "noplayer"
    return L5_2
  end
  L5_2 = type
  L6_2 = A1_2.house
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = A1_2.house
    L6_2 = L5_2
    L5_2 = L5_2.sub
    L7_2 = 1
    L8_2 = 64
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    if L5_2 then
      goto lbl_48
    end
  end
  L5_2 = nil
  ::lbl_48::
  if not L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = IntegrationHas
  L7_2 = "housing"
  L8_2 = "lock"
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "unsupported"
    return L6_2
  end
  L6_2 = L12_1
  L7_2 = A0_2
  L8_2 = L4_2.cid
  L9_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "nokey"
    return L7_2
  end
  L7_2 = L6_2.lockable
  if false == L7_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "nolock"
    return L7_2
  end
  L7_2 = A1_2.locked
  L7_2 = false ~= L7_2
  L8_2 = IntegrationTry
  L9_2 = "housing"
  L10_2 = "lock"
  L11_2 = A0_2
  L12_2 = L4_2.cid
  L13_2 = L5_2
  L14_2 = L7_2
  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L8_2 then
    L11_2 = {}
    L11_2.ok = false
    L11_2.error = "internal"
    return L11_2
  end
  if false == L9_2 then
    L11_2 = {}
    L11_2.ok = false
    L12_2 = type
    L13_2 = L10_2
    L12_2 = L12_2(L13_2)
    L12_2 = L10_2 or L12_2
    if "string" ~= L12_2 or not L10_2 then
      L12_2 = "nokey"
    end
    L11_2.error = L12_2
    return L11_2
  end
  L11_2 = L3_2
  L12_2 = "|"
  L13_2 = L5_2
  L11_2 = L11_2 .. L12_2 .. L13_2
  L12_2 = L9_1
  L12_2[L11_2] = L7_2
  L11_2 = TriggerEvent
  L12_2 = "apex_phone:homeToggle"
  L13_2 = A0_2
  L14_2 = {}
  L14_2.house = L5_2
  L14_2.locked = L7_2
  L14_2.provider = L3_2
  L11_2(L12_2, L13_2, L14_2)
  L11_2 = {}
  L11_2.ok = true
  L11_2.locked = L7_2
  return L11_2
end
L14_1["house.lock"] = L15_1
L14_1 = RPC
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L8_1.isExtraHouse
  if L2_2 then
    L2_2 = L8_1.isExtraHouse
    L3_2 = A1_2.house
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = {}
      L2_2.ok = false
      L2_2.error = "unsupported"
      return L2_2
    end
  end
  L2_2 = Integration
  L3_2 = "housing"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" == L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "client"
    return L4_2
  end
  L4_2 = FW
  L4_2 = L4_2.GetPlayer
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "noplayer"
    return L5_2
  end
  L5_2 = type
  L6_2 = A1_2.house
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = A1_2.house
    L6_2 = L5_2
    L5_2 = L5_2.sub
    L7_2 = 1
    L8_2 = 64
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    if L5_2 then
      goto lbl_58
    end
  end
  L5_2 = nil
  ::lbl_58::
  if not L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = L12_1
  L7_2 = A0_2
  L8_2 = L4_2.cid
  L9_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if L6_2 then
    L7_2 = L6_2.owner
    if true == L7_2 then
      goto lbl_80
    end
  end
  L7_2 = {}
  L7_2.ok = false
  L7_2.error = "nokey"
  do return L7_2 end
  ::lbl_80::
  L7_2 = L6_2.keys
  if false == L7_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "unsupported"
    return L7_2
  end
  L7_2 = nil
  L8_2 = nil
  L9_2 = nil
  L10_2 = A1_2.action
  if "give" == L10_2 then
    L10_2 = FW
    L10_2 = L10_2.GetPlayer
    L11_2 = tonumber
    L12_2 = A1_2.target
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L11_2(L12_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    if not L10_2 then
      L11_2 = {}
      L11_2.ok = false
      L11_2.error = "offline"
      return L11_2
    end
    L11_2 = L10_2.cid
    L12_2 = L4_2.cid
    if L11_2 == L12_2 then
      L11_2 = {}
      L11_2.ok = false
      L11_2.error = "self"
      return L11_2
    end
    L11_2 = IntegrationTry
    L12_2 = "housing"
    L13_2 = "giveKey"
    L14_2 = A0_2
    L15_2 = L4_2.cid
    L16_2 = L5_2
    L17_2 = L10_2.src
    L18_2 = L10_2.cid
    L11_2, L12_2, L13_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L9_2 = L13_2
    L8_2 = L12_2
    L7_2 = L11_2
  else
    L10_2 = A1_2.action
    if "remove" == L10_2 then
      L10_2 = tostring
      L11_2 = A1_2.cid
      if not L11_2 then
        L11_2 = ""
      end
      L10_2 = L10_2(L11_2)
      L11_2 = L10_2
      L10_2 = L10_2.sub
      L12_2 = 1
      L13_2 = 64
      L10_2 = L10_2(L11_2, L12_2, L13_2)
      if "" == L10_2 then
        L11_2 = {}
        L11_2.ok = false
        L11_2.error = "invalid"
        return L11_2
      end
      L11_2 = IntegrationTry
      L12_2 = "housing"
      L13_2 = "removeKey"
      L14_2 = A0_2
      L15_2 = L4_2.cid
      L16_2 = L5_2
      L17_2 = L10_2
      L11_2, L12_2, L13_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
      L9_2 = L13_2
      L8_2 = L12_2
      L7_2 = L11_2
    else
      L10_2 = {}
      L10_2.ok = false
      L10_2.error = "invalid"
      return L10_2
    end
  end
  if not L7_2 then
    L10_2 = {}
    L10_2.ok = false
    L10_2.error = "unsupported"
    return L10_2
  end
  if false == L8_2 then
    L10_2 = {}
    L10_2.ok = false
    L11_2 = type
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    L11_2 = L9_2 or L11_2
    if "string" ~= L11_2 or not L9_2 then
      L11_2 = "failed"
    end
    L10_2.error = L11_2
    return L10_2
  end
  L10_2 = {}
  L10_2.ok = true
  return L10_2
end
L14_1["house.key"] = L15_1
L14_1 = RPC
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A1_2.number
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 20
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = GetCitizenIdByNumber
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "target"
    return L5_2
  end
  L5_2 = L2_2.cid
  if L4_2 == L5_2 then
    L5_2 = {}
    L5_2.error = "self"
    return L5_2
  end
  L5_2 = FW
  L5_2 = L5_2.GetPlayerByCid
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "offline"
    return L6_2
  end
  L6_2 = {}
  L7_2 = L5_2.src
  L6_2.src = L7_2
  L6_2.cid = L4_2
  L7_2 = L5_2.firstname
  if not L7_2 then
    L7_2 = ""
  end
  L8_2 = " "
  L9_2 = L5_2.lastname
  if not L9_2 then
    L9_2 = ""
  end
  L7_2 = L7_2 .. L8_2 .. L9_2
  L6_2.name = L7_2
  return L6_2
end
L14_1["house.resolve"] = L15_1
