local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1
L0_1 = Config
L0_1 = L0_1.AirDrop
if not L0_1 then
  L0_1 = {}
end
L1_1 = tonumber
L2_1 = L0_1.radius
L1_1 = L1_1(L2_1)
if not L1_1 then
  L1_1 = 12.0
end
L2_1 = math
L2_1 = L2_1.max
L3_1 = 10
L4_1 = math
L4_1 = L4_1.floor
L5_1 = tonumber
L6_1 = L0_1.offerSeconds
L5_1 = L5_1(L6_1)
if not L5_1 then
  L5_1 = 60
end
L4_1 = L4_1(L5_1)
L2_1 = L2_1(L3_1, L4_1)
L2_1 = L2_1 * 1000
L3_1 = 5000
L4_1 = 12000
L5_1 = {}
L5_1.off = true
L5_1.contacts = true
L5_1.everyone = true
L6_1 = {}
L7_1 = {}
L8_1 = {}
L9_1 = 0
L10_1 = {}
L10_1["airdrop.send"] = 3
L10_1["airdrop.answer"] = 2
L10_1["airdrop.cancel"] = 1
L10_1["airdrop.set"] = 1
L10_1["airdrop.nearby"] = 1
L11_1 = Config
L11_1 = L11_1.RateLimit
L12_1 = type
L13_1 = L11_1
L12_1 = L12_1(L13_1)
if "table" == L12_1 then
  L12_1 = type
  L13_1 = L11_1.costs
  L12_1 = L12_1(L13_1)
  if "table" ~= L12_1 then
    L12_1 = {}
    L11_1.costs = L12_1
  end
  L12_1 = pairs
  L13_1 = L10_1
  L12_1, L13_1, L14_1, L15_1 = L12_1(L13_1)
  for L16_1, L17_1 in L12_1, L13_1, L14_1, L15_1 do
    L18_1 = L11_1.costs
    L18_1 = L18_1[L16_1]
    if nil == L18_1 then
      L18_1 = L11_1.costs
      L18_1[L16_1] = L17_1
    end
  end
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  return L1_2(L2_2)
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetPlayerPed
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 or 0 == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = GetEntityCoords
  L3_2 = L1_2
  return L2_2(L3_2)
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L11_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L11_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if not L2_2 or not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3
    L0_3 = GetPlayerRoutingBucket
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L1_3 = GetPlayerRoutingBucket
    L2_3 = A1_2
    L1_3, L2_3 = L1_3(L2_3)
    return L0_3, L1_3, L2_3
  end
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  if L4_2 and L5_2 ~= L6_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = L2_2 - L3_2
  L7_2 = #L7_2
  return L7_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L12_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = nil ~= L2_2
  return L3_2
end
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if A0_2 then
    L2_2 = Accounts
    L2_2 = L2_2[A0_2]
    if L2_2 then
      goto lbl_8
    end
  end
  L2_2 = nil
  ::lbl_8::
  if not L2_2 and A0_2 then
    L3_2 = MySQL
    L3_2 = L3_2.single
    L3_2 = L3_2.await
    L4_2 = "SELECT username, avatar, phone, settings FROM apex_phone_accounts WHERE citizenid = ?"
    L5_2 = {}
    L6_2 = A0_2
    L5_2[1] = L6_2
    L3_2 = L3_2(L4_2, L5_2)
    L2_2 = L3_2
    if L2_2 then
      L3_2 = type
      L4_2 = L2_2.settings
      L3_2 = L3_2(L4_2)
      if "string" == L3_2 then
        L3_2 = pcall
        L4_2 = json
        L4_2 = L4_2.decode
        L5_2 = L2_2.settings
        L3_2, L4_2 = L3_2(L4_2, L5_2)
        L5_2 = L4_2 or L5_2
        if not L3_2 or not L4_2 then
          L5_2 = nil
        end
        L2_2.settings = L5_2
      end
    end
  end
  if L2_2 then
    L3_2 = type
    L4_2 = L2_2.settings
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L2_2.settings
      if L3_2 then
        goto lbl_52
      end
    end
  end
  L3_2 = {}
  ::lbl_52::
  L4_2 = type
  L5_2 = L3_2.deviceName
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L3_2.deviceName
    L5_2 = L4_2
    L4_2 = L4_2.gsub
    L6_2 = "^%s+"
    L7_2 = ""
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L5_2 = L4_2
    L4_2 = L4_2.gsub
    L6_2 = "%s+$"
    L7_2 = ""
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_69
    end
  end
  L4_2 = ""
  ::lbl_69::
  L5_2 = DeviceModelOf
  if L5_2 then
    L5_2 = DeviceModelOf
    L6_2 = A1_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_78
    end
  end
  L5_2 = "PearPhone"
  ::lbl_78::
  if "" == L4_2 then
    L6_2 = L5_2
    L7_2 = " de "
    L8_2 = tostring
    if L2_2 then
      L9_2 = L2_2.username
      if L9_2 then
        goto lbl_94
      end
    end
    L9_2 = GetPlayerName
    L10_2 = A1_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = "algu\195\169m"
    end
    ::lbl_94::
    L8_2 = L8_2(L9_2)
    L6_2 = L6_2 .. L7_2 .. L8_2
    L4_2 = L6_2
  else
    L6_2 = ipairs
    L7_2 = DefaultModels
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L7_2()
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      if L4_2 == L11_2 then
        L4_2 = L5_2
        break
      end
      L13_2 = L4_2
      L12_2 = L4_2.sub
      L14_2 = 1
      L15_2 = #L11_2
      L15_2 = L15_2 + 4
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      L13_2 = L11_2
      L14_2 = " de "
      L13_2 = L13_2 .. L14_2
      if L12_2 == L13_2 then
        L12_2 = L5_2
        L14_2 = L4_2
        L13_2 = L4_2.sub
        L15_2 = #L11_2
        L15_2 = L15_2 + 1
        L13_2 = L13_2(L14_2, L15_2)
        L12_2 = L12_2 .. L13_2
        L4_2 = L12_2
        break
      end
    end
  end
  L7_2 = L4_2
  L6_2 = L4_2.sub
  L8_2 = 1
  L9_2 = 40
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = tonumber
  L8_2 = L2_2 or L8_2
  if L2_2 then
    L8_2 = L2_2.avatar
  end
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 1
  end
  if L2_2 then
    L8_2 = L2_2.phone
    if L8_2 then
      goto lbl_150
    end
  end
  L8_2 = GetPlayerNumber
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  ::lbl_150::
  return L6_2, L7_2, L8_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%D"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
L16_1 = {}
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L16_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = Now
    L3_2 = L3_2()
    L4_2 = L2_2.t
    L3_2 = L3_2 - L4_2
    L4_2 = 10000
    if not (L3_2 > L4_2) then
      goto lbl_55
    end
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT number FROM apex_phone_contacts WHERE owner = ?"
  L7_2 = {}
  L8_2 = A0_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L15_1
    L11_2 = L9_2.number
    L10_2 = L10_2(L11_2)
    if "" ~= L10_2 then
      L3_2[L10_2] = true
    end
  end
  L4_2 = {}
  L5_2 = Now
  L5_2 = L5_2()
  L4_2.t = L5_2
  L4_2.set = L3_2
  L2_2 = L4_2
  L4_2 = L16_1
  L4_2[A0_2] = L2_2
  ::lbl_55::
  L3_2 = L15_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = "" ~= L3_2
  return L4_2
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L6_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = L2_2.mode
    if "off" ~= L3_2 then
      goto lbl_10
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_10::
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L2_2.cid
  if L3_2 ~= L4_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L2_2.mode
  if "contacts" == L3_2 then
    L3_2 = L14_1
    L4_2 = GetCid
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    L5_2 = A1_2
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L6_2 = L17_1
    L7_2 = L2_2.cid
    L8_2 = L5_2
    return L6_2(L7_2, L8_2)
  end
  L3_2 = true
  return L3_2
end
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = pairs
  L3_2 = L7_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.from
    if L8_2 == A0_2 then
      L8_2 = L7_2.to
      if L8_2 == A1_2 then
        return L7_2
      end
    end
  end
  L2_2 = nil
  return L2_2
end
function L20_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L8_1
  L3_2 = L8_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = {}
  end
  L2_2[A0_2] = L3_2
  L2_2 = L8_1
  L2_2 = L2_2[A0_2]
  L3_2 = Now
  L3_2 = L3_2()
  L2_2[A1_2] = L3_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L8_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = L8_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2[A1_2]
  end
  L3_2 = nil ~= L2_2
  return L3_2
end
function L22_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  if A0_2 then
    L3_2 = GetPlayerPed
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if 0 ~= L3_2 then
      L3_2 = Push
      L4_2 = A0_2
      L5_2 = A1_2
      L6_2 = A2_2
      L3_2(L4_2, L5_2, L6_2)
    end
  end
end
L23_1 = RPC
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2.mode
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L4_2 = A1_2.mode
    L3_2 = L5_1
    L3_2 = L3_2[L4_2]
    if L3_2 then
      L3_2 = A1_2.mode
      if L3_2 then
        goto lbl_24
      end
    end
  end
  L3_2 = "off"
  ::lbl_24::
  L4_2 = L14_1
  L5_2 = L2_2
  L6_2 = A0_2
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L7_2 = L6_1
  L8_2 = {}
  L8_2.cid = L2_2
  L8_2.mode = L3_2
  L8_2.name = L4_2
  L8_2.avatar = L5_2
  L8_2.number = L6_2
  L7_2[A0_2] = L8_2
  L7_2 = Dbg
  L8_2 = "airdrop"
  L9_2 = "%s (%s) receives: %s"
  L10_2 = tostring
  L11_2 = L2_2
  L10_2 = L10_2(L11_2)
  L11_2 = A0_2
  L12_2 = L3_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = {}
  L7_2.ok = true
  L7_2.mode = L3_2
  return L7_2
end
L23_1["airdrop.set"] = L24_1
L23_1 = RPC
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = {}
  L3_2 = pairs
  L4_2 = L6_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L7_2 ~= A0_2 then
      L9_2 = L8_2.mode
      if "off" ~= L9_2 then
        L9_2 = GetPlayerPed
        L10_2 = L7_2
        L9_2 = L9_2(L10_2)
        if 0 == L9_2 then
          L9_2 = L6_1
          L9_2[L7_2] = nil
        else
          L9_2 = L13_1
          L10_2 = A0_2
          L11_2 = L7_2
          L9_2 = L9_2(L10_2, L11_2)
          if L9_2 then
            L9_2 = L18_1
            L10_2 = L7_2
            L11_2 = A0_2
            L9_2 = L9_2(L10_2, L11_2)
            if L9_2 then
              L9_2 = L14_1
              L10_2 = L8_2.cid
              L11_2 = L7_2
              L9_2, L10_2 = L9_2(L10_2, L11_2)
              L11_2 = #L2_2
              L11_2 = L11_2 + 1
              L12_2 = {}
              L12_2.src = L7_2
              L12_2.name = L9_2
              L12_2.avatar = L10_2
              L2_2[L11_2] = L12_2
            end
          end
        end
      end
    end
  end
  return L2_2
end
L23_1["airdrop.nearby"] = L24_1
L23_1 = RPC
function L24_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L10_1
  L4_2 = A1_2.to
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 < 1 or L3_2 == A0_2 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = GetPlayerPed
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if 0 == L4_2 then
    L4_2 = {}
    L4_2.error = "notnear"
    return L4_2
  end
  L4_2 = L18_1
  L5_2 = L3_2
  L6_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.error = "off"
    return L4_2
  end
  L4_2 = L13_1
  L5_2 = A0_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.error = "notnear"
    return L4_2
  end
  L4_2 = L10_1
  L5_2 = A1_2.photoId
  L4_2 = L4_2(L5_2)
  if not L4_2 or L4_2 < 1 then
    L5_2 = {}
    L5_2.error = "notfound"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT id, seed, video FROM apex_phone_photos WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "notfound"
    return L6_2
  end
  L6_2 = L19_1
  L7_2 = A0_2
  L8_2 = L3_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L6_2 = {}
    L6_2.error = "busy"
    return L6_2
  end
  L6_2 = L21_1
  L7_2 = A0_2
  L8_2 = L3_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L6_2 = {}
    L6_2.error = "cooldown"
    return L6_2
  end
  L6_2 = nil
  L7_2 = type
  L8_2 = A1_2.thumb
  L7_2 = L7_2(L8_2)
  if "string" == L7_2 then
    L7_2 = A1_2.thumb
    L7_2 = #L7_2
    L8_2 = L4_1
    if L7_2 <= L8_2 then
      L7_2 = A1_2.thumb
      L8_2 = L7_2
      L7_2 = L7_2.match
      L9_2 = "^data:(image/[%w%.%+%-]+);base64,"
      L7_2 = L7_2(L8_2, L9_2)
      if "image/jpeg" == L7_2 or "image/jpg" == L7_2 then
        L6_2 = A1_2.thumb
      end
    end
  end
  L7_2 = L9_1
  L7_2 = L7_2 + 1
  L9_1 = L7_2
  L7_2 = L9_1
  L8_2 = L14_1
  L9_2 = L2_2
  L10_2 = A0_2
  L8_2, L9_2 = L8_2(L9_2, L10_2)
  L10_2 = L7_1
  L11_2 = {}
  L11_2.id = L7_2
  L11_2.from = A0_2
  L11_2.to = L3_2
  L11_2.fromCid = L2_2
  L12_2 = L6_1
  L12_2 = L12_2[L3_2]
  L12_2 = L12_2.cid
  L11_2.toCid = L12_2
  L11_2.photoId = L4_2
  L12_2 = tonumber
  L13_2 = L5_2.seed
  L12_2 = L12_2(L13_2)
  L11_2.seed = L12_2
  L12_2 = Now
  L12_2 = L12_2()
  L13_2 = L2_1
  L12_2 = L12_2 + L13_2
  L11_2.expires = L12_2
  L10_2[L7_2] = L11_2
  L10_2 = Push
  L11_2 = L3_2
  L12_2 = "airdrop:offer"
  L13_2 = {}
  L13_2.id = L7_2
  L13_2.from = L8_2
  L13_2.avatar = L9_2
  L13_2.thumb = L6_2
  L14_2 = tonumber
  L15_2 = L5_2.seed
  L14_2 = L14_2(L15_2)
  L13_2.seed = L14_2
  L14_2 = L5_2.video
  L14_2 = 1 == L14_2
  L13_2.video = L14_2
  L14_2 = math
  L14_2 = L14_2.floor
  L15_2 = L2_1
  L15_2 = L15_2 / 1000
  L14_2 = L14_2(L15_2)
  L13_2.seconds = L14_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = Dbg
  L11_2 = "airdrop"
  L12_2 = "offer #%d: %s \226\134\146 %s (photo %d)"
  L13_2 = L7_2
  L14_2 = A0_2
  L15_2 = L3_2
  L16_2 = L4_2
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L10_2 = {}
  L10_2.ok = true
  L10_2.id = L7_2
  return L10_2
end
L23_1["airdrop.send"] = L24_1
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = MySQL
  L1_2 = L1_2.insert
  L1_2 = L1_2.await
  L2_2 = "INSERT INTO apex_phone_photos (owner, url, seed, favorite, video, duration, poster, created) "
  L3_2 = "SELECT ?, url, seed, 0, video, duration, poster, ? FROM apex_phone_photos WHERE id = ? AND owner = ?"
  L2_2 = L2_2 .. L3_2
  L3_2 = {}
  L4_2 = A0_2.toCid
  L5_2 = Now
  L5_2 = L5_2()
  L6_2 = A0_2.photoId
  L7_2 = A0_2.fromCid
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 or 0 == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = tonumber
  L4_2 = Config
  L4_2 = L4_2.MaxPhotos
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 60
  end
  L2_2 = L2_2(L3_2)
  if L2_2 < 1 then
    L2_2 = 1
  end
  L3_2 = tonumber
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT COUNT(*) FROM apex_phone_photos WHERE owner = ?"
  L6_2 = {}
  L7_2 = A0_2.toCid
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if not L3_2 then
    L3_2 = 0
  end
  if L2_2 < L3_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L5_2 = "DELETE FROM apex_phone_photos WHERE owner = ? AND favorite = 0 ORDER BY created ASC LIMIT "
    L6_2 = math
    L6_2 = L6_2.floor
    L7_2 = L3_2 - L2_2
    L6_2 = L6_2(L7_2)
    L5_2 = L5_2 .. L6_2
    L6_2 = {}
    L7_2 = A0_2.toCid
    L6_2[1] = L7_2
    L4_2(L5_2, L6_2)
  end
  return L1_2
end
L24_1 = RPC
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L10_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L7_1
    L4_2 = L4_2[L3_2]
    if L4_2 then
      goto lbl_20
    end
  end
  L4_2 = nil
  ::lbl_20::
  if L4_2 then
    L5_2 = L4_2.to
    if L5_2 == A0_2 then
      L5_2 = L4_2.toCid
      if L5_2 == L2_2 then
        goto lbl_32
      end
    end
  end
  L5_2 = {}
  L5_2.error = "notfound"
  do return L5_2 end
  ::lbl_32::
  L5_2 = L7_1
  L5_2[L3_2] = nil
  L5_2 = A1_2.accept
  if not L5_2 then
    L5_2 = L20_1
    L6_2 = L4_2.from
    L7_2 = A0_2
    L5_2(L6_2, L7_2)
    L5_2 = L22_1
    L6_2 = L4_2.from
    L7_2 = "airdrop:result"
    L8_2 = {}
    L8_2.id = L3_2
    L8_2.accepted = false
    L5_2(L6_2, L7_2, L8_2)
    L5_2 = {}
    L5_2.ok = true
    return L5_2
  end
  L5_2 = GetPlayerPed
  L6_2 = L4_2.from
  L5_2 = L5_2(L6_2)
  if 0 == L5_2 then
    L5_2 = {}
    L5_2.error = "gone"
    return L5_2
  end
  L5_2 = L13_1
  L6_2 = A0_2
  L7_2 = L4_2.from
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = L22_1
    L6_2 = L4_2.from
    L7_2 = "airdrop:result"
    L8_2 = {}
    L8_2.id = L3_2
    L8_2.accepted = false
    L8_2.error = "notnear"
    L5_2(L6_2, L7_2, L8_2)
    L5_2 = {}
    L5_2.error = "notnear"
    return L5_2
  end
  L5_2 = L23_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = L22_1
    L7_2 = L4_2.from
    L8_2 = "airdrop:result"
    L9_2 = {}
    L9_2.id = L3_2
    L9_2.accepted = false
    L9_2.error = "notfound"
    L6_2(L7_2, L8_2, L9_2)
    L6_2 = {}
    L6_2.error = "notfound"
    return L6_2
  end
  L6_2 = Push
  L7_2 = A0_2
  L8_2 = "photos:changed"
  L9_2 = {}
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = L22_1
  L7_2 = L4_2.from
  L8_2 = "airdrop:result"
  L9_2 = {}
  L9_2.id = L3_2
  L9_2.accepted = true
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = Dbg
  L7_2 = "airdrop"
  L8_2 = "offer #%d accepted: photo %d copied to %s as %d"
  L9_2 = L3_2
  L10_2 = L4_2.photoId
  L11_2 = tostring
  L12_2 = L2_2
  L11_2 = L11_2(L12_2)
  L12_2 = L5_2
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = {}
  L6_2.ok = true
  L6_2.photoId = L5_2
  return L6_2
end
L24_1["airdrop.answer"] = L25_1
L24_1 = RPC
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L10_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = L7_1
    L3_2 = L3_2[L2_2]
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  if L3_2 then
    L4_2 = L3_2.from
    if L4_2 == A0_2 then
      goto lbl_20
    end
  end
  L4_2 = {}
  L4_2.error = "notfound"
  do return L4_2 end
  ::lbl_20::
  L4_2 = L7_1
  L4_2[L2_2] = nil
  L4_2 = L20_1
  L5_2 = A0_2
  L6_2 = L3_2.to
  L4_2(L5_2, L6_2)
  L4_2 = L22_1
  L5_2 = L3_2.to
  L6_2 = "airdrop:gone"
  L7_2 = {}
  L7_2.id = L2_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L24_1["airdrop.cancel"] = L25_1
L24_1 = CreateThread
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  while true do
    L0_2 = Wait
    L1_2 = 15000
    L0_2(L1_2)
    L0_2 = Now
    L0_2 = L0_2()
    L1_2 = pairs
    L2_2 = L7_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = L6_2.expires
      if L0_2 >= L7_2 then
        L7_2 = L7_1
        L7_2[L5_2] = nil
        L7_2 = L20_1
        L8_2 = L6_2.from
        L9_2 = L6_2.to
        L7_2(L8_2, L9_2)
        L7_2 = L22_1
        L8_2 = L6_2.to
        L9_2 = "airdrop:gone"
        L10_2 = {}
        L10_2.id = L5_2
        L10_2.expired = true
        L7_2(L8_2, L9_2, L10_2)
        L7_2 = L22_1
        L8_2 = L6_2.from
        L9_2 = "airdrop:result"
        L10_2 = {}
        L10_2.id = L5_2
        L10_2.accepted = false
        L10_2.expired = true
        L7_2(L8_2, L9_2, L10_2)
      end
    end
  end
end
L24_1(L25_1)
L24_1 = AddEventHandler
L25_1 = "playerDropped"
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = source
  L1_2 = L6_1
  L1_2 = L1_2[L0_2]
  L2_2 = L6_1
  L2_2[L0_2] = nil
  if L1_2 then
    L2_2 = L1_2.cid
    if L2_2 then
      L3_2 = L1_2.cid
      L2_2 = L16_1
      L2_2[L3_2] = nil
    end
  end
  L2_2 = L8_1
  L2_2[L0_2] = nil
  L2_2 = pairs
  L3_2 = L8_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2[L0_2] = nil
  end
  L2_2 = pairs
  L3_2 = L7_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.from
    if L8_2 == L0_2 then
      L8_2 = L7_1
      L8_2[L6_2] = nil
      L8_2 = L22_1
      L9_2 = L7_2.to
      L10_2 = "airdrop:gone"
      L11_2 = {}
      L11_2.id = L6_2
      L8_2(L9_2, L10_2, L11_2)
    else
      L8_2 = L7_2.to
      if L8_2 == L0_2 then
        L8_2 = L7_1
        L8_2[L6_2] = nil
        L8_2 = L22_1
        L9_2 = L7_2.from
        L10_2 = "airdrop:result"
        L11_2 = {}
        L11_2.id = L6_2
        L11_2.accepted = false
        L11_2.error = "gone"
        L8_2(L9_2, L10_2, L11_2)
      end
    end
  end
end
L24_1(L25_1, L26_1)
