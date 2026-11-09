local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = ipairs
  L2_2 = Config
  L2_2 = L2_2.Services
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.id
    if L7_2 == A0_2 then
      return L6_2
    end
  end
  L1_2 = nil
  return L1_2
end
function L1_1(A0_2)
  if type(A0_2) == "table" then
    local out, seen = {}, {}
    for _, job in ipairs(A0_2) do
      for _, src in ipairs(FW.GetJobPlayers(job) or {}) do
        if not seen[src] then
          seen[src] = true
          out[#out + 1] = src
        end
      end
    end
    return out
  end
  return FW.GetJobPlayers(A0_2)
end
function L2_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = A0_2.coords
  if L1_2 then
    L1_2 = A0_2.coords
    if "" ~= L1_2 then
      L1_2 = pcall
      L2_2 = json
      L2_2 = L2_2.decode
      L3_2 = A0_2.coords
      L1_2, L2_2 = L1_2(L2_2, L3_2)
      L3_2 = L2_2 or L3_2
      if not L1_2 or not L2_2 then
        L3_2 = nil
      end
      A0_2.coords = L3_2
  end
  else
    A0_2.coords = nil
  end
  return A0_2
end
function L3_1(A0_2)
  local L1_2
  L1_2 = A0_2 or nil
  if A0_2 then
    L1_2 = A0_2.job
    if L1_2 then
      L1_2 = A0_2.job
      L1_2 = L1_2.onduty
      L1_2 = false ~= L1_2
    end
  end
  return L1_2
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tonumber
  L2_2 = A0_2.x
  L1_2 = L1_2(L2_2)
  L2_2 = tonumber
  L3_2 = A0_2.y
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A0_2.z
  L3_2 = L3_2(L4_2)
  if L1_2 and L2_2 and L1_2 == L1_2 and L2_2 == L2_2 then
    L4_2 = math
    L4_2 = L4_2.abs
    L5_2 = L1_2
    L4_2 = L4_2(L5_2)
    L5_2 = 20000
    if not (L4_2 > L5_2) then
      L4_2 = math
      L4_2 = L4_2.abs
      L5_2 = L2_2
      L4_2 = L4_2(L5_2)
      L5_2 = 20000
      if not (L4_2 > L5_2) then
        goto lbl_41
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_41::
  if L3_2 and L3_2 == L3_2 then
    L4_2 = math
    L4_2 = L4_2.abs
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L5_2 = 5000
    if not (L4_2 > L5_2) then
      goto lbl_53
    end
  end
  L3_2 = 0.0
  ::lbl_53::
  function L4_2(A0_3)
    local L1_3, L2_3
    L1_3 = math
    L1_3 = L1_3.floor
    L2_3 = A0_3 * 100
    L2_3 = L2_3 + 0.5
    L1_3 = L1_3(L2_3)
    L1_3 = L1_3 / 100
    return L1_3
  end
  L5_2 = {}
  L6_2 = L4_2
  L7_2 = L1_2
  L6_2 = L6_2(L7_2)
  L5_2.x = L6_2
  L6_2 = L4_2
  L7_2 = L2_2
  L6_2 = L6_2(L7_2)
  L5_2.y = L6_2
  L6_2 = L4_2
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2.z = L6_2
  return L5_2
end
L5_1 = {}
function L6_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = Config
  L1_2 = L1_2.ServiceCooldown
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 60
  end
  return L0_2
end
L7_1 = CreateThread
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  while true do
    L0_2 = Wait
    L1_2 = 600000
    L0_2(L1_2)
    L0_2 = os
    L0_2 = L0_2.time
    L0_2 = L0_2()
    L1_2 = L6_1
    L1_2 = L1_2()
    L2_2 = pairs
    L3_2 = L5_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L0_2 - L7_2
      if L1_2 <= L8_2 then
        L8_2 = L5_1
        L8_2[L6_2] = nil
      end
    end
  end
end
L7_1(L8_1)
L7_1 = PhoneIntegrations
if L7_1 then
  L8_1 = L7_1.defineBuiltin
  if L8_1 then
    L8_1 = L7_1.defineBuiltin
    L9_1 = "dispatch"
    L10_1 = {}
    L10_1.label = "Phone only (Services app notifications)"
    function L11_1()
      local L0_2, L1_2
      L0_2 = false
      return L0_2
    end
    L10_1.alert = L11_1
    L8_1(L9_1, L10_1)
  end
end
L8_1 = {}
L9_1 = {}
L10_1 = "police"
L9_1[1] = L10_1
L8_1.police = L9_1
L9_1 = {}
L10_1 = "ambulance"
L9_1[1] = L10_1
L8_1.ambulance = L9_1
function L9_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Integrations
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Integrations
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L9_1
  L1_2 = L1_2()
  L1_2 = L1_2.dispatchJobs
  if nil == L1_2 then
    L1_2 = L8_1
  end
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = A0_2.job
  L2_2 = L1_2[L2_2]
  if nil == L2_2 then
    L3_2 = A0_2.id
    L2_2 = L1_2[L3_2]
  end
  if true == L2_2 then
    L3_2 = {}
    L4_2 = A0_2.job
    L3_2[1] = L4_2
    L2_2 = L3_2
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = {}
    L4_2 = L2_2
    L3_2[1] = L4_2
    L2_2 = L3_2
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 and "" ~= L9_2 then
      L10_2 = #L3_2
      L10_2 = L10_2 + 1
      L3_2[L10_2] = L9_2
    end
  end
  L4_2 = #L3_2
  L4_2 = L3_2 or L4_2
  if not (L4_2 > 0) or not L3_2 then
    L4_2 = nil
  end
  return L4_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = Integration
  L1_2 = L1_2(L2_2)
  if "function" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L10_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = Integration
  L3_2 = "dispatch"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" == L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L1_2
  L5_2 = L3_2
  return L4_2, L5_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = ipairs
  L2_2 = A0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L1_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    L7_2 = #L7_2
    if L7_2 > 0 then
      L7_2 = true
      return L7_2
    end
  end
  L1_2 = false
  return L1_2
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
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
  if not (L3_2 and L4_2) or 0 == L3_2 and 0 == L4_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = L4_1
  L7_2 = {}
  L7_2.x = L3_2
  L7_2.y = L4_2
  L7_2.z = L5_2
  return L6_2(L7_2)
end
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L13_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not A1_2 then
    return L2_2
  end
  if L2_2 then
    L3_2 = A1_2.x
    L4_2 = L2_2.x
    L3_2 = L3_2 - L4_2
    L4_2 = A1_2.y
    L5_2 = L2_2.y
    L4_2 = L4_2 - L5_2
    L5_2 = L3_2 * L3_2
    L6_2 = L4_2 * L4_2
    L5_2 = L5_2 + L6_2
    L6_2 = 22500.0
    if L5_2 > L6_2 then
      return L2_2
    end
  end
  return A1_2
end
function L15_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L6_2 = type
  L7_2 = A5_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = type
    L7_2 = A5_2.street
    L6_2 = L6_2(L7_2)
    if "string" == L6_2 then
      L6_2 = A5_2.street
      L7_2 = L6_2
      L6_2 = L6_2.sub
      L8_2 = 1
      L9_2 = 80
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      if L6_2 then
        goto lbl_19
      end
    end
  end
  L6_2 = nil
  ::lbl_19::
  L7_2 = {}
  L8_2 = A3_2.id
  L7_2.id = L8_2
  L8_2 = A2_2.id
  L7_2.service = L8_2
  L8_2 = A2_2.label
  if not L8_2 then
    L8_2 = A2_2.id
  end
  L7_2.label = L8_2
  L8_2 = A2_2.job
  L7_2.job = L8_2
  L7_2.jobs = A4_2
  L8_2 = A3_2.requester_name
  L7_2.caller = L8_2
  L8_2 = A3_2.requester_phone
  L7_2.phone = L8_2
  L8_2 = A1_2.cid
  L7_2.cid = L8_2
  L8_2 = A3_2.description
  L7_2.message = L8_2
  L8_2 = L14_1
  L9_2 = A0_2
  L10_2 = A3_2.coords
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.coords = L8_2
  L8_2 = L6_2 or L8_2
  if "" == L6_2 or not L6_2 then
    L8_2 = nil
  end
  L7_2.street = L8_2
  L8_2 = tostring
  L9_2 = L9_1
  L9_2 = L9_2()
  L9_2 = L9_2.dispatchCode
  if not L9_2 then
    L9_2 = "911"
  end
  L8_2 = L8_2(L9_2)
  L7_2.code = L8_2
  L8_2 = IntegrationTry
  L9_2 = "dispatch"
  L10_2 = "alert"
  L11_2 = A0_2
  L12_2 = L7_2
  L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  L10_2 = L8_2 or L10_2
  L10_2 = L8_2 and false ~= L9_2 and nil ~= L9_2
  return L10_2
end
L16_1 = RPC
function L17_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = Config
  L2_2 = L2_2.Services
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = #L0_2
    L7_2 = L7_2 + 1
    L8_2 = {}
    L9_2 = L6_2.id
    L8_2.id = L9_2
    L9_2 = L6_2.label
    L8_2.label = L9_2
    L9_2 = L6_2.job
    L8_2.job = L9_2
    L9_2 = L6_2.icon
    L8_2.icon = L9_2
    L9_2 = L6_2.color
    L8_2.color = L9_2
    L9_2 = L6_2.business
    L8_2.business = L9_2
    L0_2[L7_2] = L8_2
  end
  return L0_2
end
L16_1["services.list"] = L17_1
L16_1 = RPC
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L0_1
  L4_2 = tostring
  L5_2 = A1_2.service
  if not L5_2 then
    L5_2 = ""
  end
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = tostring
  L5_2 = L2_2.cid
  L4_2 = L4_2(L5_2)
  L5_2 = ":"
  L6_2 = L3_2.id
  L4_2 = L4_2 .. L5_2 .. L6_2
  L5_2 = os
  L5_2 = L5_2.time
  L5_2 = L5_2()
  L6_2 = L5_1
  L6_2 = L6_2[L4_2]
  if L6_2 then
    L7_2 = L5_2 - L6_2
    L8_2 = L6_1
    L8_2 = L8_2()
    if L7_2 < L8_2 then
      L7_2 = {}
      L7_2.error = "cooldown"
      L8_2 = L6_1
      L8_2 = L8_2()
      L9_2 = L5_2 - L6_2
      L8_2 = L8_2 - L9_2
      L7_2.wait = L8_2
      return L7_2
    end
  end
  L7_2 = L1_1
  L8_2 = L3_2.jobs
  if not L8_2 then
    L8_2 = L3_2.job
  end
  L7_2 = L7_2(L8_2)
  L8_2 = L11_1
  L9_2 = L3_2
  L8_2 = L8_2(L9_2)
  L9_2 = #L7_2
  if 0 == L9_2 then
    if L8_2 then
      L9_2 = L12_1
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if L9_2 then
        goto lbl_75
      end
    end
    L9_2 = {}
    L9_2.error = "nobody"
    return L9_2
  end
  ::lbl_75::
  L9_2 = L5_1
  L9_2[L4_2] = L5_2
  L9_2 = L2_2.firstname
  if not L9_2 then
    L9_2 = ""
  end
  L10_2 = " "
  L11_2 = L2_2.lastname
  if not L11_2 then
    L11_2 = ""
  end
  L9_2 = L9_2 .. L10_2 .. L11_2
  L10_2 = Now
  L10_2 = L10_2()
  L11_2 = tostring
  L12_2 = A1_2.description
  if not L12_2 then
    L12_2 = ""
  end
  L11_2 = L11_2(L12_2)
  L12_2 = L11_2
  L11_2 = L11_2.sub
  L13_2 = 1
  L14_2 = 300
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L12_2 = L4_1
  L13_2 = A1_2.coords
  L12_2 = L12_2(L13_2)
  L13_2 = MySQL
  L13_2 = L13_2.insert
  L13_2 = L13_2.await
  L14_2 = "INSERT INTO apex_phone_services (requester, requester_name, requester_phone, service, description, coords, status, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
  L15_2 = {}
  L16_2 = L2_2.cid
  L17_2 = L9_2
  L18_2 = GetPlayerNumber
  L19_2 = A0_2
  L18_2 = L18_2(L19_2)
  L19_2 = L3_2.id
  L20_2 = L11_2
  if L12_2 then
    L21_2 = json
    L21_2 = L21_2.encode
    L22_2 = L12_2
    L21_2 = L21_2(L22_2)
    if L21_2 then
      goto lbl_124
    end
  end
  L21_2 = nil
  ::lbl_124::
  L22_2 = "pending"
  L23_2 = L10_2
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L15_2[4] = L19_2
  L15_2[5] = L20_2
  L15_2[6] = L21_2
  L15_2[7] = L22_2
  L15_2[8] = L23_2
  L13_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L14_2 = L5_1
    L14_2 = L14_2[L4_2]
    if L14_2 == L5_2 then
      L14_2 = L5_1
      L14_2[L4_2] = L6_2
    end
    L14_2 = {}
    L14_2.error = "internal"
    return L14_2
  end
  L14_2 = {}
  L14_2.id = L13_2
  L15_2 = L2_2.cid
  L14_2.requester = L15_2
  L14_2.requester_name = L9_2
  L15_2 = GetPlayerNumber
  L16_2 = A0_2
  L15_2 = L15_2(L16_2)
  L14_2.requester_phone = L15_2
  L15_2 = L3_2.id
  L14_2.service = L15_2
  L15_2 = L3_2.label
  L14_2.serviceLabel = L15_2
  L14_2.description = L11_2
  L14_2.coords = L12_2
  L14_2.status = "pending"
  L14_2.created = L10_2
  if L8_2 then
    L15_2 = L9_1
    L15_2 = L15_2()
    L15_2 = L15_2.dispatchOnly
    if true == L15_2 then
      L15_2 = L15_1
      L16_2 = A0_2
      L17_2 = L2_2
      L18_2 = L3_2
      L19_2 = L14_2
      L20_2 = L8_2
      L21_2 = A1_2
      L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
      if not L15_2 then
        L15_2 = ipairs
        L16_2 = L7_2
        L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
        for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
          L21_2 = Push
          L22_2 = L20_2
          L23_2 = "serviceRequest"
          L24_2 = L14_2
          L21_2(L22_2, L23_2, L24_2)
        end
      end
      return L14_2
    end
  end
  L15_2 = ipairs
  L16_2 = L7_2
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    L21_2 = Push
    L22_2 = L20_2
    L23_2 = "serviceRequest"
    L24_2 = L14_2
    L21_2(L22_2, L23_2, L24_2)
  end
  if L8_2 then
    L15_2 = L15_1
    L16_2 = A0_2
    L17_2 = L2_2
    L18_2 = L3_2
    L19_2 = L14_2
    L20_2 = L8_2
    L21_2 = A1_2
    L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  end
  return L14_2
end
L16_1["services.request"] = L17_1
L16_1 = RPC
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.update
  L3_2 = "UPDATE apex_phone_services SET status = \"cancelled\" WHERE id = ? AND requester = ? AND status IN (\"pending\", \"accepted\")"
  L4_2 = {}
  L5_2 = tonumber
  L6_2 = A1_2.id
  L5_2 = L5_2(L6_2)
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2, L7_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2(L3_2, L4_2)
  L2_2 = {}
  L2_2.ok = true
  return L2_2
end
L16_1["services.cancel"] = L17_1
L16_1 = RPC
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT * FROM apex_phone_services WHERE requester = ? ORDER BY created DESC LIMIT 30"
  L3_2 = {}
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2)
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L3_2[6] = L9_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L2_1
    L9_2 = L7_2
    L8_2(L9_2)
  end
  return L1_2
end
L16_1["services.mine"] = L17_1
L16_1 = RPC
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = L1_2.job
  L2_2 = L2_2.name
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = Config
  L5_2 = L5_2.Services
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    if ServiceHasJob(L9_2, L2_2) then
      L10_2 = #L3_2
      L10_2 = L10_2 + 1
      L11_2 = L9_2.id
      L3_2[L10_2] = L11_2
    end
  end
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = {}
    return L4_2
  end
  L4_2 = {}
  L5_2 = 1
  L6_2 = #L3_2
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L4_2[L8_2] = "?"
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L5_2[L12_2] = L11_2
  end
  L6_2 = #L5_2
  L6_2 = L6_2 + 1
  L7_2 = L1_2.cid
  L5_2[L6_2] = L7_2
  L6_2 = L3_1
  L7_2 = L1_2
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L6_2 = "(status = \"pending\" OR (status = \"accepted\" AND accepted_cid = ?))"
    if L6_2 then
      goto lbl_71
    end
  end
  L6_2 = "(status = \"accepted\" AND accepted_cid = ?)"
  ::lbl_71::
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT * FROM apex_phone_services WHERE service IN ("
  L9_2 = table
  L9_2 = L9_2.concat
  L10_2 = L4_2
  L11_2 = ","
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = ") AND "
  L11_2 = L6_2
  L12_2 = " ORDER BY created DESC LIMIT 40"
  L8_2 = L8_2 .. L9_2 .. L10_2 .. L11_2 .. L12_2
  L9_2 = L5_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = ipairs
  L9_2 = L7_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L2_1
    L15_2 = L13_2
    L14_2(L15_2)
  end
  return L7_2
end
L16_1["services.pending"] = L17_1
L16_1 = RPC
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
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
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_services WHERE id = ?"
  L6_2 = {}
  L7_2 = L3_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "gone"
    return L5_2
  end
  L5_2 = L0_1
  L6_2 = L4_2.service
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L2_2.job
    if L6_2 then
      L6_2 = L2_2.job
      L6_2 = L6_2.name
      if ServiceHasJob(L5_2, L6_2) then
        goto lbl_56
      end
    end
  end
  L6_2 = {}
  L6_2.ok = false
  L6_2.error = "job"
  do return L6_2 end
  ::lbl_56::
  L6_2 = L3_1
  L7_2 = L2_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "offduty"
    return L6_2
  end
  L6_2 = L4_2.status
  if "pending" ~= L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "gone"
    return L6_2
  end
  L6_2 = L4_2.requester
  L7_2 = L2_2.cid
  if L6_2 == L7_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "self"
    return L6_2
  end
  L6_2 = L2_2.job
  L6_2 = L6_2.label
  if not L6_2 then
    L6_2 = ""
  end
  L7_2 = " \194\183 "
  L8_2 = L2_2.firstname
  if not L8_2 then
    L8_2 = ""
  end
  L9_2 = " "
  L10_2 = L2_2.lastname
  if not L10_2 then
    L10_2 = ""
  end
  L6_2 = L6_2 .. L7_2 .. L8_2 .. L9_2 .. L10_2
  L7_2 = L6_2
  L6_2 = L6_2.sub
  L8_2 = 1
  L9_2 = 64
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_services SET status = ?, accepted_by = ?, accepted_cid = ? WHERE id = ? AND status = ?"
  L9_2 = {}
  L10_2 = "accepted"
  L11_2 = L6_2
  L12_2 = L2_2.cid
  L13_2 = L3_2
  L14_2 = "pending"
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = tonumber
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  if 1 ~= L8_2 then
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "gone"
    return L8_2
  end
  L4_2.status = "accepted"
  L4_2.accepted_by = L6_2
  L8_2 = L2_2.cid
  L4_2.accepted_cid = L8_2
  L8_2 = L2_1
  L9_2 = L4_2
  L8_2(L9_2)
  L8_2 = FW
  L8_2 = L8_2.GetPlayerByCid
  L9_2 = L4_2.requester
  L8_2 = L8_2(L9_2)
  if L8_2 then
    L9_2 = Push
    L10_2 = L8_2.src
    L11_2 = "serviceUpdate"
    L12_2 = L4_2
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = {}
  L9_2.ok = true
  L9_2.request = L4_2
  return L9_2
end
L16_1["services.accept"] = L17_1
L16_1 = RPC
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_services WHERE id = ? AND accepted_cid = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_services SET status = ? WHERE id = ? AND accepted_cid = ? AND status = ?"
  L7_2 = {}
  L8_2 = "done"
  L9_2 = L3_2
  L10_2 = L2_2
  L11_2 = "accepted"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 1 ~= L6_2 then
    L6_2 = {}
    L6_2.ok = false
    return L6_2
  end
  L4_2.status = "done"
  L6_2 = L2_1
  L7_2 = L4_2
  L6_2(L7_2)
  L6_2 = FW
  L6_2 = L6_2.GetPlayerByCid
  L7_2 = L4_2.requester
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L7_2 = Push
    L8_2 = L6_2.src
    L9_2 = "serviceUpdate"
    L10_2 = L4_2
    L7_2(L8_2, L9_2, L10_2)
  end
  L7_2 = {}
  L7_2.ok = true
  return L7_2
end
L16_1["services.complete"] = L17_1
