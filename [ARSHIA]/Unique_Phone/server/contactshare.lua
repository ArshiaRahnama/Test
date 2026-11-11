local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1
function L0_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.ContactShare
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.ContactShare
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
L2_1 = {}
L2_1.off = true
L2_1.contacts = true
L2_1.everyone = true
L3_1 = {}
L3_1.me = true
L3_1.contact = true
L3_1.ask = true
L4_1 = 1.5
L5_1 = 3
L6_1 = 8
L7_1 = 60000
L8_1 = 6
L9_1 = 60000
L10_1 = 12
L11_1 = {}
L12_1 = {}
L13_1 = {}
L14_1 = {}
L15_1 = {}
L16_1 = {}
L17_1 = {}
L18_1 = {}
L19_1 = 0
L20_1 = {}
L20_1["cshare.send"] = 3
L20_1["cshare.answer"] = 2
L20_1["cshare.cancel"] = 1
L20_1["cshare.set"] = 1
L20_1["cshare.nearby"] = 1
L20_1["cshare.target"] = 3
L21_1 = Config
L21_1 = L21_1.RateLimit
L22_1 = type
L23_1 = L21_1
L22_1 = L22_1(L23_1)
if "table" == L22_1 then
  L22_1 = type
  L23_1 = L21_1.costs
  L22_1 = L22_1(L23_1)
  if "table" ~= L22_1 then
    L22_1 = {}
    L21_1.costs = L22_1
  end
  L22_1 = pairs
  L23_1 = L20_1
  L22_1, L23_1, L24_1, L25_1 = L22_1(L23_1)
  for L26_1, L27_1 in L22_1, L23_1, L24_1, L25_1 do
    L28_1 = L21_1.costs
    L28_1 = L28_1[L26_1]
    if nil == L28_1 then
      L28_1 = L21_1.costs
      L28_1[L26_1] = L27_1
    end
  end
end
function L20_1(A0_2)
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
function L21_1(A0_2)
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
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      L2_2 = ""
      return L2_2
    end
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "[%c]"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "^%s+"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%s+$"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = #L2_2
  if A1_2 < L3_2 then
    L4_2 = L2_2
    L3_2 = L2_2.sub
    L5_2 = 1
    L6_2 = A1_2
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2 = L3_2
  end
  return L2_2
end
function L23_1()
  local L0_2, L1_2, L2_2
  L0_2 = tonumber
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.offerSeconds
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 30
  end
  if L0_2 < 10 then
    L0_2 = 10
  elseif L0_2 > 120 then
    L0_2 = 120
  end
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = L0_2 * 1000
  return L1_2(L2_2)
end
function L24_1()
  local L0_2, L1_2, L2_2
  L0_2 = tonumber
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.cooldownSeconds
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 5
  end
  if L0_2 < 0 then
    L0_2 = 0
  else
    L1_2 = 300
    if L0_2 > L1_2 then
      L0_2 = 300
    end
  end
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = L0_2 * 1000
  return L1_2(L2_2)
end
function L25_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.distance
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 3.0
  end
  if L0_2 < 1.0 then
    L0_2 = 1.0
  elseif L0_2 > 15.0 then
    L0_2 = 15.0
  end
  return L0_2
end
function L26_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.targetDistance
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 2.0
  end
  if L0_2 < 1.0 then
    L0_2 = 1.0
  elseif L0_2 > 10.0 then
    L0_2 = 10.0
  end
  L1_2 = L4_1
  L1_2 = L0_2 + L1_2
  return L1_2
end
function L27_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2 or nil
  if A0_2 then
    L1_2 = GetPlayerPed
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    L1_2 = 0 ~= L1_2
  end
  return L1_2
end
function L28_1(A0_2)
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
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L28_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L28_1
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
function L30_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L29_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = nil ~= L3_2 and A2_2 >= L3_2
  return L4_2
end
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = GetPlayerPed
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 or 0 == L1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  L3_2 = GetEntityHealth
  L4_2 = L1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L4_2 = tonumber
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L4_2 = tonumber
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      if L4_2 <= 0 then
        L4_2 = false
        return L4_2
      end
    end
  end
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L0_3 = L0_3.isDead
    return L0_3
  end
  L4_2, L5_2 = L4_2(L5_2)
  if L4_2 and true == L5_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = FW
  L6_2 = L6_2.name
  if "qb" ~= L6_2 then
    L6_2 = FW
    L6_2 = L6_2.name
    if "qbx" ~= L6_2 then
      goto lbl_77
    end
  end
  L6_2 = pcall
  L7_2 = FW
  L7_2 = L7_2.GetPlayer
  L8_2 = A0_2
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  L8_2 = L6_2 or L8_2
  L8_2 = L7_2 or L8_2
  if L6_2 and L7_2 then
    L8_2 = L7_2.raw
    if L8_2 then
      L8_2 = L7_2.raw
      L8_2 = L8_2.PlayerData
      if L8_2 then
        L8_2 = L7_2.raw
        L8_2 = L8_2.PlayerData
        L8_2 = L8_2.metadata
      end
    end
  end
  L9_2 = type
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = L8_2.isdead
    if not L9_2 then
      L9_2 = L8_2.inlaststand
      if not L9_2 then
        goto lbl_77
      end
    end
    L9_2 = false
    return L9_2
  end
  ::lbl_77::
  L6_2 = true
  return L6_2
end
function L32_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetPhoneState
  if L1_2 then
    L1_2 = GetPhoneState
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  L2_2 = nil ~= L1_2
  return L2_2
end
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = Accounts
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = L13_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = Now
    L2_2 = L2_2()
    L3_2 = L1_2.t
    L2_2 = L2_2 - L3_2
    L3_2 = 60000
    if L2_2 < L3_2 then
      L2_2 = L1_2.ok
      return L2_2
    end
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2
  if L2_2 then
    L4_2 = tonumber
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = 0
    end
    L4_2 = L4_2 > 0
  end
  L5_2 = L13_1
  L6_2 = {}
  L7_2 = Now
  L7_2 = L7_2()
  L6_2.t = L7_2
  L6_2.ok = L4_2
  L5_2[A0_2] = L6_2
  return L4_2
end
function L34_1()
  local L0_2, L1_2
  L0_2 = L0_1
  L0_2 = L0_2()
  L0_2 = L0_2.receive
  L1_2 = L2_1
  L1_2 = L1_2[L0_2]
  L1_2 = L0_2 or L1_2
  if not L1_2 or not L0_2 then
    L1_2 = "everyone"
  end
  return L1_2
end
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L11_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = L2_2.cid
    if L3_2 == A1_2 then
      L4_2 = L2_2.mode
      L3_2 = L2_1
      L3_2 = L3_2[L4_2]
      if L3_2 then
        L3_2 = L2_2.mode
        return L3_2
      end
    end
  end
  L3_2 = Accounts
  L3_2 = L3_2[A1_2]
  if L3_2 then
    L4_2 = type
    L5_2 = L3_2.settings
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = L3_2.settings
      L4_2 = L4_2.cshare
      L5_2 = L2_1
      L5_2 = L5_2[L4_2]
      L5_2 = L4_2 or L5_2
      if not L5_2 or not L4_2 then
        L5_2 = L34_1
        L5_2 = L5_2()
      end
      return L5_2
    end
  end
  L4_2 = L12_1
  L4_2 = L4_2[A1_2]
  if L4_2 then
    L5_2 = Now
    L5_2 = L5_2()
    L6_2 = L4_2.t
    L5_2 = L5_2 - L6_2
    L6_2 = 30000
    if not (L5_2 > L6_2) then
      goto lbl_75
    end
  end
  L5_2 = pcall
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT JSON_UNQUOTE(JSON_EXTRACT(settings, '$.cshare')) FROM apex_phone_accounts WHERE citizenid = ?"
  L8_2 = {}
  L9_2 = A1_2
  L8_2[1] = L9_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  L7_2 = {}
  L8_2 = Now
  L8_2 = L8_2()
  L7_2.t = L8_2
  if L5_2 then
    L8_2 = L2_1
    L8_2 = L8_2[L6_2]
    if L8_2 and L6_2 then
      goto lbl_71
      L8_2 = L6_2 or L8_2
    end
  end
  L8_2 = nil
  ::lbl_71::
  L7_2.mode = L8_2
  L4_2 = L7_2
  L7_2 = L12_1
  L7_2[A1_2] = L4_2
  ::lbl_75::
  L5_2 = L4_2.mode
  if not L5_2 then
    L5_2 = L34_1
    L5_2 = L5_2()
  end
  return L5_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L21_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "" == L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L14_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L4_2 = Now
    L4_2 = L4_2()
    L5_2 = L3_2.t
    L4_2 = L4_2 - L5_2
    L5_2 = 10000
    if not (L4_2 > L5_2) then
      goto lbl_62
    end
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT number FROM apex_phone_contacts WHERE owner = ?"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = {}
  end
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L21_1
    L12_2 = L10_2.number
    L11_2 = L11_2(L12_2)
    if "" ~= L11_2 then
      L4_2[L11_2] = true
    end
  end
  L5_2 = {}
  L6_2 = Now
  L6_2 = L6_2()
  L5_2.t = L6_2
  L5_2.set = L4_2
  L3_2 = L5_2
  L5_2 = L14_1
  L5_2[A0_2] = L3_2
  ::lbl_62::
  L4_2 = L3_2.set
  L4_2 = L4_2[L2_2]
  L4_2 = true == L4_2
  return L4_2
end
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = Accounts
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return L1_2
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT username, avatar, avatar_photo, settings FROM apex_phone_accounts WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 or not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = type
  L5_2 = L3_2.settings
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = pcall
    L5_2 = json
    L5_2 = L5_2.decode
    L6_2 = L3_2.settings
    L4_2, L5_2 = L4_2(L5_2, L6_2)
    L6_2 = L5_2 or L6_2
    if not L4_2 or not L5_2 then
      L6_2 = nil
    end
    L3_2.settings = L6_2
  end
  L4_2 = type
  L5_2 = L3_2.avatar_photo
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L3_2.avatar_photo
    if "" ~= L4_2 then
      L4_2 = L3_2.avatar_photo
      if L4_2 then
        goto lbl_50
      end
    end
  end
  L4_2 = nil
  ::lbl_50::
  L3_2.avatarPhoto = L4_2
  L3_2.avatar_photo = nil
  return L3_2
end
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if A1_2 then
    L2_2 = L37_1
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_9
    end
  end
  L2_2 = nil
  ::lbl_9::
  if L2_2 then
    L3_2 = type
    L4_2 = L2_2.settings
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L2_2.settings
      if L3_2 then
        goto lbl_21
      end
    end
  end
  L3_2 = {}
  ::lbl_21::
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
      goto lbl_38
    end
  end
  L4_2 = ""
  ::lbl_38::
  L5_2 = DeviceModelOf
  if L5_2 then
    L5_2 = DeviceModelOf
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_47
    end
  end
  L5_2 = "PearPhone"
  ::lbl_47::
  if "" == L4_2 then
    L6_2 = L5_2
    L7_2 = " de "
    L8_2 = tostring
    if L2_2 then
      L9_2 = L2_2.username
      if L9_2 then
        goto lbl_63
      end
    end
    L9_2 = GetPlayerName
    L10_2 = A0_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = "algu\195\169m"
    end
    ::lbl_63::
    L8_2 = L8_2(L9_2)
    L6_2 = L6_2 .. L7_2 .. L8_2
    L4_2 = L6_2
  else
    L6_2 = DefaultModels
    if L6_2 then
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
  end
  L7_2 = L4_2
  L6_2 = L4_2.sub
  L8_2 = 1
  L9_2 = 40
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = tonumber
  L8_2 = L2_2
  if L2_2 then
    L8_2 = L2_2.avatar
  end
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 1
  end
  return L6_2, L7_2
end
function L39_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = nil
  L4_2 = RequireLine
  if L4_2 then
    L4_2 = RequireLine
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_11
    end
  end
  L4_2 = nil
  ::lbl_11::
  if not L4_2 then
    L5_2 = GetPlayerNumber
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    L3_2 = L5_2
  end
  if nil ~= L3_2 then
    L5_2 = L22_1
    L6_2 = L3_2
    L7_2 = 20
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_26
      L3_2 = L5_2 or L3_2
    end
  end
  L3_2 = ""
  ::lbl_26::
  if "" == L3_2 and not A2_2 then
    L5_2 = nil
    L6_2 = "nosim"
    return L5_2, L6_2
  end
  L5_2 = L37_1
  L6_2 = A1_2
  L5_2 = L5_2(L6_2)
  L6_2 = ""
  L7_2 = pcall
  L8_2 = FW
  L8_2 = L8_2.GetName
  L9_2 = A0_2
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  if L7_2 then
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L22_1
      L10_2 = L8_2
      L11_2 = 64
      L9_2 = L9_2(L10_2, L11_2)
      L6_2 = L9_2
    end
  end
  if "" == L6_2 and L5_2 then
    L9_2 = L5_2.username
    if L9_2 then
      L9_2 = L22_1
      L10_2 = L5_2.username
      L11_2 = 64
      L9_2 = L9_2(L10_2, L11_2)
      L6_2 = L9_2
    end
  end
  if "" == L6_2 then
    L9_2 = L22_1
    L10_2 = GetPlayerName
    L11_2 = A0_2
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = ""
    end
    L11_2 = 64
    L9_2 = L9_2(L10_2, L11_2)
    L6_2 = L9_2
  end
  L6_2 = L3_2 or L6_2
  if "" == L6_2 and ("" == L3_2 or not L3_2) then
    L6_2 = "?"
  end
  L9_2 = nil
  L10_2 = L0_1
  L10_2 = L10_2()
  L10_2 = L10_2.sharePhoto
  if false ~= L10_2 and L5_2 then
    L10_2 = type
    L11_2 = L5_2.avatarPhoto
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L10_2 = L5_2.avatarPhoto
      L10_2 = #L10_2
      L11_2 = 120000
      if L10_2 <= L11_2 then
        L10_2 = L5_2.avatarPhoto
        L11_2 = L10_2
        L10_2 = L10_2.match
        L12_2 = "^data:image/"
        L10_2 = L10_2(L11_2, L12_2)
        if L10_2 then
          L9_2 = L5_2.avatarPhoto
        end
      end
    end
  end
  L10_2 = {}
  L10_2.name = L6_2
  L11_2 = L3_2 or L11_2
  if "" == L3_2 or not L3_2 then
    L11_2 = nil
  end
  L10_2.number = L11_2
  L11_2 = tonumber
  L12_2 = L5_2
  if L5_2 then
    L12_2 = L5_2.avatar
  end
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = nil
  end
  L10_2.avatar = L11_2
  L10_2.photo = L9_2
  return L10_2
end
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L20_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 or L2_2 < 1 then
    L3_2 = nil
    L4_2 = "notfound"
    return L3_2, L4_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT name, number, avatar FROM apex_phone_contacts WHERE id = ? AND owner = ?"
  L5_2 = {}
  L6_2 = L2_2
  L7_2 = A0_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = nil
    L5_2 = "notfound"
    return L4_2, L5_2
  end
  L4_2 = L22_1
  L5_2 = L3_2.number
  L6_2 = 20
  L4_2 = L4_2(L5_2, L6_2)
  if "" == L4_2 then
    L5_2 = nil
    L6_2 = "notfound"
    return L5_2, L6_2
  end
  L5_2 = tonumber
  L6_2 = L3_2.avatar
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = type
    L7_2 = L3_2.avatar
    L6_2 = L6_2(L7_2)
    if "string" == L6_2 then
      L6_2 = L3_2.avatar
      L6_2 = #L6_2
      L7_2 = 255
      if L6_2 <= L7_2 then
        L6_2 = L3_2.avatar
        L7_2 = L6_2
        L6_2 = L6_2.match
        L8_2 = "^https?://"
        L6_2 = L6_2(L7_2, L8_2)
        if L6_2 then
          L5_2 = L3_2.avatar
        end
      end
    end
  end
  L6_2 = L22_1
  L7_2 = L3_2.name
  L8_2 = 64
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = {}
  L8_2 = L6_2 or L8_2
  if "" == L6_2 or not L6_2 then
    L8_2 = L4_2
  end
  L7_2.name = L8_2
  L7_2.number = L4_2
  L7_2.avatar = L5_2
  return L7_2
end
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if A0_2 and A1_2 then
    L2_2 = A1_2.number
    if L2_2 then
      goto lbl_11
    end
  end
  L2_2 = nil
  L3_2 = "invalid"
  do return L2_2, L3_2 end
  ::lbl_11::
  L2_2 = L21_1
  L3_2 = A1_2.number
  L2_2 = L2_2(L3_2)
  if "" == L2_2 then
    L3_2 = nil
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT id, name, number, avatar FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2.number
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = nil
  if not L3_2 then
    L5_2 = MySQL
    L5_2 = L5_2.query
    L5_2 = L5_2.await
    L6_2 = "SELECT id, name, number, avatar FROM apex_phone_contacts WHERE owner = ? LIMIT 5000"
    L7_2 = {}
    L8_2 = A0_2
    L7_2[1] = L8_2
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = {}
    end
    L4_2 = #L5_2
    L6_2 = ipairs
    L7_2 = L5_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = L21_1
      L13_2 = L11_2.number
      L12_2 = L12_2(L13_2)
      if L12_2 == L2_2 then
        L3_2 = L11_2
        break
      end
    end
  end
  if L3_2 then
    L5_2 = L3_2.name
    L6_2 = L3_2.avatar
    L7_2 = L21_1
    L8_2 = L5_2
    L7_2 = L7_2(L8_2)
    if nil ~= L5_2 and "" ~= L5_2 then
      if "" == L7_2 then
        goto lbl_79
      end
      L8_2 = L21_1
      L9_2 = L3_2.number
      L8_2 = L8_2(L9_2)
      if L7_2 ~= L8_2 then
        goto lbl_79
      end
    end
    L5_2 = A1_2.name
    ::lbl_79::
    if nil == L6_2 or "" == L6_2 then
      L8_2 = A1_2.avatar
      if nil ~= L8_2 then
        L6_2 = A1_2.avatar
      end
    end
    L8_2 = L3_2.name
    if L5_2 == L8_2 then
      L8_2 = L3_2.avatar
      if L6_2 == L8_2 then
        goto lbl_105
      end
    end
    L8_2 = MySQL
    L8_2 = L8_2.update
    L8_2 = L8_2.await
    L9_2 = "UPDATE apex_phone_contacts SET name = ?, avatar = ? WHERE id = ? AND owner = ?"
    L10_2 = {}
    L11_2 = L5_2
    L12_2 = L6_2
    L13_2 = L3_2.id
    L14_2 = A0_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L10_2[4] = L14_2
    L8_2(L9_2, L10_2)
    ::lbl_105::
    L8_2 = L14_1
    L8_2[A0_2] = nil
    L8_2 = {}
    L9_2 = tonumber
    L10_2 = L3_2.id
    L9_2 = L9_2(L10_2)
    L8_2.id = L9_2
    L8_2.name = L5_2
    L9_2 = L3_2.number
    L8_2.number = L9_2
    L8_2.merged = true
    return L8_2
  end
  if L4_2 then
    L5_2 = 5000
    if L4_2 >= L5_2 then
      L5_2 = nil
      L6_2 = "full"
      return L5_2, L6_2
    end
  end
  L5_2 = MySQL
  L5_2 = L5_2.insert
  L5_2 = L5_2.await
  L6_2 = "INSERT INTO apex_phone_contacts (owner, name, number, avatar, favorite) VALUES (?, ?, ?, ?, 0)"
  L7_2 = {}
  L8_2 = A0_2
  L9_2 = A1_2.name
  L10_2 = A1_2.number
  L11_2 = A1_2.avatar
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 or 0 == L5_2 then
    L6_2 = nil
    L7_2 = "internal"
    return L6_2, L7_2
  end
  L6_2 = L14_1
  L6_2[A0_2] = nil
  L6_2 = {}
  L7_2 = tonumber
  L8_2 = L5_2
  L7_2 = L7_2(L8_2)
  L6_2.id = L7_2
  L7_2 = A1_2.name
  L6_2.name = L7_2
  L7_2 = A1_2.number
  L6_2.number = L7_2
  L6_2.merged = false
  return L6_2
end
function L42_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L1_1
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = "disabled"
    return L1_2
  end
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = "noplayer"
    return L2_2
  end
  L2_2 = L31_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = "unavailable"
    return L2_2
  end
  L2_2 = HasPhoneItem
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = "nophone"
    return L2_2
  end
  L2_2 = L0_1
  L2_2 = L2_2()
  L2_2 = L2_2.requirePhoneOut
  if true == L2_2 then
    L2_2 = L32_1
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = "phoneout"
      return L2_2
    end
  end
  L2_2 = nil
  L3_2 = L1_2
  return L2_2, L3_2
end
function L43_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  if A0_2 and A0_2 ~= A1_2 then
    L3_2 = L27_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_12
    end
  end
  L3_2 = "notnear"
  do return L3_2 end
  ::lbl_12::
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = "nophone"
    return L4_2
  end
  L4_2 = L31_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = "unavailable"
    return L4_2
  end
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = "nophone"
    return L4_2
  end
  L4_2 = L33_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = "nophone"
    return L4_2
  end
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if "off" == L4_2 then
    L5_2 = "off"
    return L5_2
  end
  if A2_2 then
    L5_2 = IsBlocked
    if L5_2 then
      L5_2 = IsBlocked
      L6_2 = L3_2
      L7_2 = A2_2
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L5_2 = "off"
        return L5_2
      end
    end
  end
  if "contacts" == L4_2 then
    L5_2 = L36_1
    L6_2 = L3_2
    L7_2 = A2_2
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = "off"
      return L5_2
    end
  end
  L5_2 = nil
  L6_2 = L3_2
  return L5_2, L6_2
end
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = pairs
  L3_2 = L15_1
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
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = 0
  L2_2 = pairs
  L3_2 = L15_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.to
    if L8_2 == A0_2 then
      L1_2 = L1_2 + 1
    end
  end
  return L1_2
end
function L46_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L16_1
  L3_2 = L16_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = {}
  end
  L2_2[A0_2] = L3_2
  L2_2 = L16_1
  L2_2 = L2_2[A0_2]
  L3_2 = Now
  L3_2 = L3_2()
  L2_2[A1_2] = L3_2
end
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L16_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = L16_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2[A1_2]
  end
  L3_2 = nil ~= L2_2
  return L3_2
end
function L48_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = A0_2[A1_2]
  if not L3_2 then
    L4_2 = 0
    return L4_2
  end
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L4_2 - L11_2
    if A2_2 > L12_2 then
      L12_2 = #L5_2
      L12_2 = L12_2 + 1
      L5_2[L12_2] = L11_2
    end
  end
  A0_2[A1_2] = L5_2
  L6_2 = #L5_2
  return L6_2
end
function L49_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2[A1_2]
  if not L2_2 then
    L2_2 = {}
  end
  A0_2[A1_2] = L2_2
  L2_2 = table
  L2_2 = L2_2.insert
  L3_2 = A0_2[A1_2]
  L4_2 = Now
  L4_2 = L4_2()
  L2_2(L3_2, L4_2)
end
L50_1 = {}
L50_1.disabled = "A partilha de contactos est\195\161 desligada."
L50_1.noplayer = "N\195\163o foi poss\195\173vel partilhar o contacto."
L50_1.unavailable = "N\195\163o podes partilhar contactos agora."
L50_1.nophone = "Essa pessoa n\195\163o tem telem\195\179vel."
L50_1.phoneout = "Tens de ter o telem\195\179vel na m\195\163o para partilhar o contacto."
L50_1.nosim = "Sem SIM: n\195\163o tens um n\195\186mero para partilhar."
L50_1.notnear = "Essa pessoa est\195\161 longe demais."
L50_1.off = "Essa pessoa n\195\163o est\195\161 a aceitar contactos."
L50_1.busy = "Essa pessoa j\195\161 tem pedidos por responder. Tenta daqui a pouco."
L50_1.cooldown = "Espera uns segundos antes de voltar a partilhar com essa pessoa."
L50_1.ratelimit = "Demasiados pedidos. Espera um pouco."
L50_1.invalid = "N\195\163o foi poss\195\173vel partilhar o contacto."
L50_1.notfound = "Esse contacto j\195\161 n\195\163o existe."
function L51_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  if A2_2 then
    L4_2 = L27_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      if not A1_2 then
        L4_2 = L32_1
        L5_2 = A0_2
        L4_2 = L4_2(L5_2)
        if L4_2 then
          goto lbl_21
        end
      end
      L4_2 = FW
      L4_2 = L4_2.Notify
      L5_2 = A0_2
      L6_2 = A2_2
      L7_2 = A3_2
      L4_2(L5_2, L6_2, L7_2)
    end
  end
  ::lbl_21::
end
function L52_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = A0_2.id
  A1_2.id = L4_2
  L4_2 = A0_2.kind
  A1_2.kind = L4_2
  L4_2 = L27_1
  L5_2 = A0_2.from
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    return
  end
  L4_2 = Push
  L5_2 = A0_2.from
  L6_2 = "cshare:result"
  L7_2 = A1_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = L51_1
  L5_2 = A0_2.from
  L6_2 = A0_2.via
  L6_2 = "target" == L6_2
  L7_2 = A2_2
  L8_2 = A3_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
end
function L53_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L6_2 = A0_2.id
  L5_2 = L15_1
  L5_2[L6_2] = nil
  L5_2 = A0_2.from
  L6_2 = L41_1
  L7_2 = A2_2
  L8_2 = A0_2.card
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L8_2 = {}
    L9_2 = L7_2 or L9_2
    if not L7_2 then
      L9_2 = "internal"
    end
    L8_2.error = L9_2
    return L8_2
  end
  L8_2 = L41_1
  L9_2 = A0_2.fromCid
  L10_2 = A3_2
  L8_2, L9_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L10_2 = {}
    L11_2 = L9_2 or L11_2
    if not L9_2 then
      L11_2 = "internal"
    end
    L10_2.error = L11_2
    return L10_2
  end
  L10_2 = Push
  L11_2 = A1_2
  L12_2 = "cshare:gone"
  L13_2 = {}
  L14_2 = A0_2.id
  L13_2.id = L14_2
  L13_2.mutual = true
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = Push
  L11_2 = A1_2
  L12_2 = "cshare:exchanged"
  L13_2 = {}
  L14_2 = A0_2.card
  L14_2 = L14_2.name
  L13_2.name = L14_2
  L14_2 = A0_2.card
  L14_2 = L14_2.number
  L13_2.number = L14_2
  L14_2 = L6_2.merged
  L13_2.merged = L14_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = Push
  L11_2 = L5_2
  L12_2 = "cshare:result"
  L13_2 = {}
  L14_2 = A0_2.id
  L13_2.id = L14_2
  L13_2.kind = "me"
  L13_2.accepted = true
  L13_2.mutual = true
  L14_2 = A3_2.name
  L13_2.name = L14_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = Push
  L11_2 = L5_2
  L12_2 = "cshare:exchanged"
  L13_2 = {}
  L14_2 = A3_2.name
  L13_2.name = L14_2
  L14_2 = A3_2.number
  L13_2.number = L14_2
  L14_2 = L8_2.merged
  L13_2.merged = L14_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = L51_1
  L11_2 = A1_2
  L12_2 = "target" == A4_2
  L13_2 = "Contactos trocados com %s."
  L14_2 = L13_2
  L13_2 = L13_2.format
  L15_2 = A0_2.card
  L15_2 = L15_2.name
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = "success"
  L10_2(L11_2, L12_2, L13_2, L14_2)
  L10_2 = L51_1
  L11_2 = L5_2
  L12_2 = A0_2.via
  L12_2 = "target" == L12_2
  L13_2 = "Contactos trocados com %s."
  L14_2 = L13_2
  L13_2 = L13_2.format
  L15_2 = A3_2.name
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = "success"
  L10_2(L11_2, L12_2, L13_2, L14_2)
  L10_2 = TriggerEvent
  L11_2 = "apex_phone:contactShared"
  L12_2 = L5_2
  L13_2 = A1_2
  L14_2 = "me"
  L15_2 = A0_2.card
  L15_2 = L15_2.number
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = TriggerEvent
  L11_2 = "apex_phone:contactShared"
  L12_2 = A1_2
  L13_2 = L5_2
  L14_2 = "me"
  L15_2 = A3_2.number
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = Dbg
  L11_2 = "cshare"
  L12_2 = "swap: %s <-> %s"
  L13_2 = tostring
  L14_2 = A1_2
  L13_2 = L13_2(L14_2)
  L14_2 = tostring
  L15_2 = L5_2
  L14_2, L15_2 = L14_2(L15_2)
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = {}
  L10_2.ok = true
  L10_2.mutual = true
  L11_2 = A0_2.card
  L11_2 = L11_2.name
  L10_2.name = L11_2
  L11_2 = A0_2.card
  L11_2 = L11_2.number
  L10_2.number = L11_2
  return L10_2
end
function L54_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  if not A3_2 then
    L4_2 = {}
    A3_2 = L4_2
  end
  L4_2 = A3_2.via
  if "target" == L4_2 then
    L4_2 = "target"
    if L4_2 then
      goto lbl_13
    end
  end
  L4_2 = "phone"
  ::lbl_13::
  L5_2 = L3_1
  L5_2 = L5_2[A2_2]
  if not L5_2 then
    L5_2 = {}
    L5_2.error = "invalid"
    return L5_2
  end
  if "target" == L4_2 then
    L5_2 = L0_1
    L5_2 = L5_2()
    L5_2 = L5_2.target
    if false == L5_2 then
      L5_2 = {}
      L5_2.error = "disabled"
      return L5_2
    end
  end
  if "ask" == A2_2 then
    L5_2 = L0_1
    L5_2 = L5_2()
    L5_2 = L5_2.askForContact
    if false == L5_2 then
      L5_2 = {}
      L5_2.error = "disabled"
      return L5_2
    end
  end
  L5_2 = L42_1
  L6_2 = A0_2
  L5_2, L6_2 = L5_2(L6_2)
  if L5_2 then
    L7_2 = {}
    L7_2.error = L5_2
    return L7_2
  end
  L7_2 = L20_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  A1_2 = L7_2
  if not A1_2 or A1_2 < 1 or A1_2 == A0_2 then
    L7_2 = {}
    L7_2.error = "invalid"
    return L7_2
  end
  L7_2 = L27_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = {}
    L7_2.error = "notnear"
    return L7_2
  end
  if "target" == L4_2 then
    L7_2 = L26_1
    L7_2 = L7_2()
    if L7_2 then
      goto lbl_83
    end
  end
  L7_2 = L25_1
  L7_2 = L7_2()
  ::lbl_83::
  L8_2 = L30_1
  L9_2 = A0_2
  L10_2 = A1_2
  L11_2 = L7_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  if not L8_2 then
    L8_2 = {}
    L8_2.error = "notnear"
    return L8_2
  end
  L8_2 = nil
  L9_2 = nil
  if "contact" == A2_2 then
    L10_2 = L40_1
    L11_2 = L6_2
    L12_2 = A3_2.contactId
    L10_2, L11_2 = L10_2(L11_2, L12_2)
    L9_2 = L11_2
    L8_2 = L10_2
  else
    L10_2 = L39_1
    L11_2 = A0_2
    L12_2 = L6_2
    L13_2 = "ask" == A2_2
    L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2)
    L9_2 = L11_2
    L8_2 = L10_2
  end
  if not L8_2 then
    L10_2 = {}
    L11_2 = L9_2 or L11_2
    if not L9_2 then
      L11_2 = "invalid"
    end
    L10_2.error = L11_2
    return L10_2
  end
  if "contact" ~= A2_2 then
    L10_2 = L8_2.number
    if L10_2 then
      goto lbl_129
    end
  end
  L10_2 = nil
  ::lbl_129::
  if "contact" == A2_2 then
    L11_2 = RequireLine
    if L11_2 then
      L11_2 = RequireLine
      L12_2 = A0_2
      L11_2 = L11_2(L12_2)
      if L11_2 then
        goto lbl_143
      end
    end
    L11_2 = GetPlayerNumber
    L12_2 = A0_2
    L11_2 = L11_2(L12_2)
    L10_2 = L11_2
  end
  ::lbl_143::
  L11_2 = L43_1
  L12_2 = A1_2
  L13_2 = A0_2
  L14_2 = L10_2
  L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
  if L11_2 then
    L13_2 = {}
    L13_2.error = L11_2
    return L13_2
  end
  if "me" == A2_2 then
    L13_2 = L44_1
    L14_2 = A1_2
    L15_2 = A0_2
    L13_2 = L13_2(L14_2, L15_2)
    if L13_2 then
      L14_2 = L13_2.kind
      if "me" == L14_2 then
        L14_2 = L13_2.toCid
        if L14_2 == L6_2 then
          L14_2 = L13_2.fromCid
          if L14_2 == L12_2 then
            L14_2 = Now
            L14_2 = L14_2()
            L15_2 = L13_2.expires
            if L14_2 < L15_2 then
              L14_2 = L53_1
              L15_2 = L13_2
              L16_2 = A0_2
              L17_2 = L6_2
              L18_2 = L8_2
              L19_2 = L4_2
              return L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
            end
          end
        end
      end
    end
  end
  L13_2 = L44_1
  L14_2 = A0_2
  L15_2 = A1_2
  L13_2 = L13_2(L14_2, L15_2)
  if L13_2 then
    L13_2 = {}
    L13_2.error = "busy"
    return L13_2
  end
  L13_2 = L47_1
  L14_2 = A0_2
  L15_2 = A1_2
  L13_2 = L13_2(L14_2, L15_2)
  if L13_2 then
    L13_2 = {}
    L13_2.error = "cooldown"
    return L13_2
  end
  L13_2 = L48_1
  L14_2 = L17_1
  L15_2 = A0_2
  L16_2 = L7_1
  L13_2 = L13_2(L14_2, L15_2, L16_2)
  L14_2 = L6_1
  if L13_2 >= L14_2 then
    L13_2 = {}
    L13_2.error = "ratelimit"
    return L13_2
  end
  L13_2 = L45_1
  L14_2 = A1_2
  L13_2 = L13_2(L14_2)
  L14_2 = L5_1
  if not (L13_2 >= L14_2) then
    L13_2 = L48_1
    L14_2 = L18_1
    L15_2 = A1_2
    L16_2 = L9_1
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    L14_2 = L8_1
    if not (L13_2 >= L14_2) then
      goto lbl_234
    end
  end
  L13_2 = {}
  L13_2.error = "busy"
  do return L13_2 end
  ::lbl_234::
  L13_2 = L19_1
  L13_2 = L13_2 + 1
  L19_1 = L13_2
  L13_2 = L19_1
  L14_2 = L38_1
  L15_2 = A0_2
  L16_2 = L6_2
  L14_2, L15_2 = L14_2(L15_2, L16_2)
  L16_2 = L23_1
  L16_2 = L16_2()
  L17_2 = L15_1
  L18_2 = {}
  L18_2.id = L13_2
  L18_2.kind = A2_2
  L18_2.via = L4_2
  L18_2.from = A0_2
  L18_2.to = A1_2
  L18_2.fromCid = L6_2
  L18_2.toCid = L12_2
  L18_2.card = L8_2
  L18_2.radius = L7_2
  L19_2 = Now
  L19_2 = L19_2()
  L19_2 = L19_2 + L16_2
  L18_2.expires = L19_2
  L17_2[L13_2] = L18_2
  L17_2 = L46_1
  L18_2 = A0_2
  L19_2 = A1_2
  L17_2(L18_2, L19_2)
  L17_2 = L49_1
  L18_2 = L17_1
  L19_2 = A0_2
  L17_2(L18_2, L19_2)
  L17_2 = L49_1
  L18_2 = L18_1
  L19_2 = A1_2
  L17_2(L18_2, L19_2)
  L17_2 = Push
  L18_2 = A1_2
  L19_2 = "cshare:offer"
  L20_2 = {}
  L20_2.id = L13_2
  L20_2.kind = A2_2
  L20_2.from = L14_2
  L20_2.avatar = L15_2
  L21_2 = math
  L21_2 = L21_2.floor
  L22_2 = L16_2 / 1000
  L21_2 = L21_2(L22_2)
  L20_2.seconds = L21_2
  L21_2 = {}
  L22_2 = L8_2.name
  L21_2.name = L22_2
  L22_2 = L8_2.number
  L21_2.number = L22_2
  L22_2 = L8_2.avatar
  L21_2.avatar = L22_2
  L22_2 = L8_2.photo
  L21_2.photo = L22_2
  L20_2.card = L21_2
  L17_2(L18_2, L19_2, L20_2)
  L17_2 = L32_1
  L18_2 = A1_2
  L17_2 = L17_2(L18_2)
  if not L17_2 then
    L17_2 = FW
    L17_2 = L17_2.Notify
    L18_2 = A1_2
    if "ask" == A2_2 then
      L19_2 = "%s pede o teu contacto. Abre o telem\195\179vel para responder."
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = L14_2
      L19_2 = L19_2(L20_2, L21_2)
      if L19_2 then
        goto lbl_322
      end
    end
    L19_2 = "%s quer partilhar um contacto contigo. Abre o telem\195\179vel para responder."
    L20_2 = L19_2
    L19_2 = L19_2.format
    L21_2 = L14_2
    L19_2 = L19_2(L20_2, L21_2)
    ::lbl_322::
    L20_2 = "primary"
    L17_2(L18_2, L19_2, L20_2)
  end
  if "target" == L4_2 then
    L17_2 = FW
    L17_2 = L17_2.Notify
    L18_2 = A0_2
    if "ask" == A2_2 then
      L19_2 = "Pedido de contacto enviado. \195\128 espera de resposta."
      if L19_2 then
        goto lbl_335
      end
    end
    L19_2 = "Contacto enviado. \195\128 espera de resposta."
    ::lbl_335::
    L20_2 = "primary"
    L17_2(L18_2, L19_2, L20_2)
  end
  L17_2 = Dbg
  L18_2 = "cshare"
  L19_2 = "offer #%d (%s, %s): %s -> %s"
  L20_2 = L13_2
  L21_2 = A2_2
  L22_2 = L4_2
  L23_2 = tostring
  L24_2 = A0_2
  L23_2 = L23_2(L24_2)
  L24_2 = tostring
  L25_2 = A1_2
  L24_2, L25_2 = L24_2(L25_2)
  L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  L17_2 = {}
  L17_2.ok = true
  L17_2.id = L13_2
  return L17_2
end
L55_1 = RPC
function L56_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L4_2 = A1_2.mode
    L3_2 = L2_1
    L3_2 = L3_2[L4_2]
    if L3_2 then
      L3_2 = A1_2.mode
      if L3_2 then
        goto lbl_24
      end
    end
  end
  L3_2 = nil
  ::lbl_24::
  L4_2 = L11_1
  L5_2 = {}
  L5_2.cid = L2_2
  L5_2.mode = L3_2
  L4_2[A0_2] = L5_2
  L4_2 = L0_1
  L4_2 = L4_2()
  L5_2 = {}
  L5_2.ok = true
  L6_2 = L3_2 or L6_2
  if not L3_2 then
    L6_2 = L34_1
    L6_2 = L6_2()
  end
  L5_2.mode = L6_2
  L6_2 = L34_1
  L6_2 = L6_2()
  L5_2.default = L6_2
  L6_2 = L1_1
  L6_2 = L6_2()
  L5_2.enabled = L6_2
  L6_2 = L4_2.askForContact
  L6_2 = false ~= L6_2
  L5_2.ask = L6_2
  L6_2 = L4_2.target
  L6_2 = false ~= L6_2
  L5_2.target = L6_2
  L6_2 = L25_1
  L6_2 = L6_2()
  L5_2.distance = L6_2
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = L23_1
  L7_2 = L7_2()
  L7_2 = L7_2 / 1000
  L6_2 = L6_2(L7_2)
  L5_2.seconds = L6_2
  return L5_2
end
L55_1["cshare.set"] = L56_1
L55_1 = RPC
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = L1_1
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = {}
    L1_2.error = "disabled"
    return L1_2
  end
  L1_2 = L42_1
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = {}
    L3_2.error = L1_2
    return L3_2
  end
  L3_2 = RequireLine
  if L3_2 then
    L3_2 = RequireLine
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_31
    end
  end
  L3_2 = GetPlayerNumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  ::lbl_31::
  if not L3_2 then
    L3_2 = nil
  end
  L4_2 = L25_1
  L4_2 = L4_2()
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = GetPlayers
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L7_2()
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = tonumber
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 and L12_2 ~= A0_2 then
      L13_2 = L29_1
      L14_2 = A0_2
      L15_2 = L12_2
      L13_2 = L13_2(L14_2, L15_2)
      if L13_2 and L4_2 >= L13_2 then
        L14_2 = L43_1
        L15_2 = L12_2
        L16_2 = A0_2
        L17_2 = L3_2
        L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
        if not L14_2 then
          L16_2 = L38_1
          L17_2 = L12_2
          L18_2 = L15_2
          L16_2, L17_2 = L16_2(L17_2, L18_2)
          L18_2 = #L5_2
          L18_2 = L18_2 + 1
          L19_2 = {}
          L19_2.src = L12_2
          L19_2.name = L16_2
          L19_2.avatar = L17_2
          L20_2 = math
          L20_2 = L20_2.floor
          L21_2 = L13_2 * 10
          L21_2 = L21_2 + 0.5
          L20_2 = L20_2(L21_2)
          L20_2 = L20_2 / 10
          L19_2.d = L20_2
          L5_2[L18_2] = L19_2
        end
      end
    end
  end
  L6_2 = table
  L6_2 = L6_2.sort
  L7_2 = L5_2
  function L8_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.d
    L3_3 = A1_3.d
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L6_2(L7_2, L8_2)
  while true do
    L6_2 = #L5_2
    L7_2 = L10_1
    if not (L6_2 > L7_2) then
      break
    end
    L6_2 = #L5_2
    L5_2[L6_2] = nil
  end
  return L5_2
end
L55_1["cshare.nearby"] = L56_1
L55_1 = RPC
function L56_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = A1_2.kind
  if "contact" == L2_2 then
    L2_2 = "contact"
    if L2_2 then
      goto lbl_18
    end
  end
  L2_2 = "me"
  ::lbl_18::
  L3_2 = L54_1
  L4_2 = A0_2
  L5_2 = A1_2.to
  L6_2 = L2_2
  L7_2 = {}
  L7_2.via = "phone"
  L8_2 = A1_2.contactId
  L7_2.contactId = L8_2
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L55_1["cshare.send"] = L56_1
L55_1 = RPC
function L56_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L20_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L15_1
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
  L5_2 = L15_1
  L5_2[L3_2] = nil
  L5_2 = A1_2.accept
  if not L5_2 then
    L5_2 = L46_1
    L6_2 = L4_2.from
    L7_2 = A0_2
    L5_2(L6_2, L7_2)
    L5_2 = L52_1
    L6_2 = L4_2
    L7_2 = {}
    L7_2.accepted = false
    L8_2 = L4_2.kind
    if "ask" == L8_2 then
      L8_2 = "Recusaram partilhar o contacto contigo."
      if L8_2 then
        goto lbl_53
      end
    end
    L8_2 = "N\195\163o aceitaram o contacto."
    ::lbl_53::
    L9_2 = "error"
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = {}
    L5_2.ok = true
    return L5_2
  end
  L5_2 = L27_1
  L6_2 = L4_2.from
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L5_2 = GetCid
    L6_2 = L4_2.from
    L5_2 = L5_2(L6_2)
    L6_2 = L4_2.fromCid
    if L5_2 == L6_2 then
      goto lbl_74
    end
  end
  L5_2 = {}
  L5_2.error = "gone"
  do return L5_2 end
  ::lbl_74::
  L5_2 = L30_1
  L6_2 = A0_2
  L7_2 = L4_2.from
  L8_2 = L4_2.radius
  L9_2 = L4_1
  L8_2 = L8_2 + L9_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L5_2 = L52_1
    L6_2 = L4_2
    L7_2 = {}
    L7_2.accepted = false
    L7_2.error = "notnear"
    L8_2 = "A outra pessoa afastou-se antes de responder."
    L9_2 = "error"
    L5_2(L6_2, L7_2, L8_2, L9_2)
    L5_2 = {}
    L5_2.error = "notnear"
    return L5_2
  end
  L5_2 = L4_2.kind
  if "ask" == L5_2 then
    L5_2 = L39_1
    L6_2 = A0_2
    L7_2 = L2_2
    L5_2, L6_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L7_2 = L52_1
      L8_2 = L4_2
      L9_2 = {}
      L9_2.accepted = false
      L9_2.error = L6_2
      L10_2 = "Essa pessoa n\195\163o tem um n\195\186mero para partilhar."
      L11_2 = "error"
      L7_2(L8_2, L9_2, L10_2, L11_2)
      L7_2 = {}
      L7_2.error = L6_2
      return L7_2
    end
    L7_2 = L41_1
    L8_2 = L4_2.fromCid
    L9_2 = L5_2
    L7_2, L8_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L9_2 = L52_1
      L10_2 = L4_2
      L11_2 = {}
      L11_2.accepted = false
      L11_2.error = L8_2
      L12_2 = "N\195\163o foi poss\195\173vel guardar o contacto."
      L13_2 = "error"
      L9_2(L10_2, L11_2, L12_2, L13_2)
      L9_2 = {}
      L9_2.error = L8_2
      return L9_2
    end
    L9_2 = Push
    L10_2 = L4_2.from
    L11_2 = "cshare:received"
    L12_2 = {}
    L13_2 = L5_2.name
    L12_2.name = L13_2
    L13_2 = L5_2.number
    L12_2.number = L13_2
    L13_2 = L7_2.merged
    L12_2.merged = L13_2
    L9_2(L10_2, L11_2, L12_2)
    L9_2 = L52_1
    L10_2 = L4_2
    L11_2 = {}
    L11_2.accepted = true
    L12_2 = L5_2.name
    L11_2.name = L12_2
    L12_2 = "Novo contacto guardado: %s."
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L5_2.name
    L12_2 = L12_2(L13_2, L14_2)
    L13_2 = "success"
    L9_2(L10_2, L11_2, L12_2, L13_2)
    L9_2 = TriggerEvent
    L10_2 = "apex_phone:contactShared"
    L11_2 = A0_2
    L12_2 = L4_2.from
    L13_2 = "ask"
    L14_2 = L5_2.number
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L9_2 = Dbg
    L10_2 = "cshare"
    L11_2 = "request #%d accepted: %s gave the contact to %s"
    L12_2 = L3_2
    L13_2 = tostring
    L14_2 = A0_2
    L13_2 = L13_2(L14_2)
    L14_2 = tostring
    L15_2 = L4_2.from
    L14_2, L15_2 = L14_2(L15_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L9_2 = {}
    L9_2.ok = true
    L9_2.kind = "ask"
    return L9_2
  end
  L5_2 = L41_1
  L6_2 = L2_2
  L7_2 = L4_2.card
  L5_2, L6_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L7_2 = L52_1
    L8_2 = L4_2
    L9_2 = {}
    L9_2.accepted = false
    L9_2.error = L6_2
    L10_2 = "N\195\163o foi poss\195\173vel guardar o contacto."
    L11_2 = "error"
    L7_2(L8_2, L9_2, L10_2, L11_2)
    L7_2 = {}
    L7_2.error = L6_2
    return L7_2
  end
  L7_2 = L52_1
  L8_2 = L4_2
  L9_2 = {}
  L9_2.accepted = true
  L10_2 = L4_2.kind
  if "me" == L10_2 then
    L10_2 = "O teu contacto foi guardado."
    if L10_2 then
      goto lbl_217
    end
  end
  L10_2 = "O contacto foi guardado."
  ::lbl_217::
  L11_2 = "success"
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = TriggerEvent
  L8_2 = "apex_phone:contactShared"
  L9_2 = L4_2.from
  L10_2 = A0_2
  L11_2 = L4_2.kind
  L12_2 = L4_2.card
  L12_2 = L12_2.number
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = Dbg
  L8_2 = "cshare"
  L9_2 = "offer #%d accepted by %s (contact %s%s)"
  L10_2 = L3_2
  L11_2 = tostring
  L12_2 = A0_2
  L11_2 = L11_2(L12_2)
  L12_2 = tostring
  L13_2 = L5_2.id
  L12_2 = L12_2(L13_2)
  L13_2 = L5_2.merged
  if L13_2 then
    L13_2 = ", merged"
    if L13_2 then
      goto lbl_244
    end
  end
  L13_2 = ""
  ::lbl_244::
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L7_2 = {}
  L7_2.ok = true
  L8_2 = L5_2.id
  L7_2.id = L8_2
  L8_2 = L5_2.name
  L7_2.name = L8_2
  L8_2 = L5_2.number
  L7_2.number = L8_2
  L8_2 = L5_2.merged
  L7_2.merged = L8_2
  return L7_2
end
L55_1["cshare.answer"] = L56_1
L55_1 = RPC
function L56_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L20_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = L15_1
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
  L4_2 = L15_1
  L4_2[L2_2] = nil
  L4_2 = L46_1
  L5_2 = A0_2
  L6_2 = L3_2.to
  L4_2(L5_2, L6_2)
  L4_2 = L27_1
  L5_2 = L3_2.to
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = Push
    L5_2 = L3_2.to
    L6_2 = "cshare:gone"
    L7_2 = {}
    L7_2.id = L2_2
    L4_2(L5_2, L6_2, L7_2)
  end
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L55_1["cshare.cancel"] = L56_1
L55_1 = RegisterNetEvent
L56_1 = "apex_phone:server:cshareTarget"
function L57_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = source
  L3_2 = RateLimitAllow
  L4_2 = L2_2
  L5_2 = "cshare.target"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    return
  end
  if "ask" == A1_2 then
    L3_2 = "ask"
    if L3_2 then
      goto lbl_15
    end
  end
  L3_2 = "me"
  ::lbl_15::
  L4_2 = L54_1
  L5_2 = L2_2
  L6_2 = A0_2
  L7_2 = L3_2
  L8_2 = {}
  L8_2.via = "target"
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if L4_2 then
    L5_2 = L4_2.error
    if L5_2 then
      L5_2 = FW
      L5_2 = L5_2.Notify
      L6_2 = L2_2
      L8_2 = L4_2.error
      L7_2 = L50_1
      L7_2 = L7_2[L8_2]
      if not L7_2 then
        L7_2 = L50_1.invalid
      end
      L8_2 = "error"
      L5_2(L6_2, L7_2, L8_2)
    end
  end
end
L55_1(L56_1, L57_1)
L55_1 = exports
L56_1 = "ShareContact"
function L57_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if not A0_2 or A0_2 <= 0 then
    L2_2 = {}
    L2_2.error = "invalid"
    return L2_2
  end
  L2_2 = L54_1
  L3_2 = A0_2
  L4_2 = A1_2
  L5_2 = "me"
  L6_2 = {}
  L6_2.via = "target"
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
L55_1(L56_1, L57_1)
L55_1 = exports
L56_1 = "RequestContact"
function L57_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if not A0_2 or A0_2 <= 0 then
    L2_2 = {}
    L2_2.error = "invalid"
    return L2_2
  end
  L2_2 = L54_1
  L3_2 = A0_2
  L4_2 = A1_2
  L5_2 = "ask"
  L6_2 = {}
  L6_2.via = "target"
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
L55_1(L56_1, L57_1)
function L55_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = Now
  L0_2 = L0_2()
  L1_2 = pairs
  L2_2 = L15_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.expires
    if L0_2 >= L7_2 then
      L7_2 = L15_1
      L7_2[L5_2] = nil
      L7_2 = L46_1
      L8_2 = L6_2.from
      L9_2 = L6_2.to
      L7_2(L8_2, L9_2)
      L7_2 = L27_1
      L8_2 = L6_2.to
      L7_2 = L7_2(L8_2)
      if L7_2 then
        L7_2 = Push
        L8_2 = L6_2.to
        L9_2 = "cshare:gone"
        L10_2 = {}
        L10_2.id = L5_2
        L10_2.expired = true
        L7_2(L8_2, L9_2, L10_2)
      end
      L7_2 = L52_1
      L8_2 = L6_2
      L9_2 = {}
      L9_2.accepted = false
      L9_2.expired = true
      L10_2 = L6_2.kind
      if "ask" == L10_2 then
        L10_2 = "O pedido de contacto expirou."
        if L10_2 then
          goto lbl_42
        end
      end
      L10_2 = "O pedido de contacto expirou sem resposta."
      ::lbl_42::
      L11_2 = "error"
      L7_2(L8_2, L9_2, L10_2, L11_2)
    end
  end
end
CShareSweep = L55_1
L56_1 = CreateThread
function L57_1()
  local L0_2, L1_2
  while true do
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
    L0_2 = next
    L1_2 = L15_1
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = L55_1
      L0_2()
    end
  end
end
L56_1(L57_1)
L56_1 = AddEventHandler
L57_1 = "playerDropped"
function L58_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = source
  L1_2 = L11_1
  L1_2 = L1_2[L0_2]
  L2_2 = L11_1
  L2_2[L0_2] = nil
  if L1_2 then
    L2_2 = L1_2.cid
    if L2_2 then
      L3_2 = L1_2.cid
      L2_2 = L12_1
      L2_2[L3_2] = nil
      L3_2 = L1_2.cid
      L2_2 = L14_1
      L2_2[L3_2] = nil
    end
  end
  L2_2 = L16_1
  L2_2[L0_2] = nil
  L2_2 = pairs
  L3_2 = L16_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2[L0_2] = nil
  end
  L2_2 = L17_1
  L3_2 = L18_1
  L4_2 = nil
  L3_2[L0_2] = nil
  L2_2[L0_2] = L4_2
  L2_2 = pairs
  L3_2 = L15_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.from
    if L8_2 == L0_2 then
      L8_2 = L15_1
      L8_2[L6_2] = nil
      L8_2 = L27_1
      L9_2 = L7_2.to
      L8_2 = L8_2(L9_2)
      if L8_2 then
        L8_2 = Push
        L9_2 = L7_2.to
        L10_2 = "cshare:gone"
        L11_2 = {}
        L11_2.id = L6_2
        L8_2(L9_2, L10_2, L11_2)
      end
    else
      L8_2 = L7_2.to
      if L8_2 == L0_2 then
        L8_2 = L15_1
        L8_2[L6_2] = nil
        L8_2 = L52_1
        L9_2 = L7_2
        L10_2 = {}
        L10_2.accepted = false
        L10_2.error = "gone"
        L8_2(L9_2, L10_2)
      end
    end
  end
end
L56_1(L57_1, L58_1)
