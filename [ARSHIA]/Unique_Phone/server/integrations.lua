local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1
L0_1 = PhoneIntegrations
if not L0_1 then
  L0_1 = {}
end
PhoneIntegrations = L0_1
L0_1 = PhoneIntegrations
L1_1 = {}
L2_1 = "garage"
L3_1 = "bank"
L4_1 = "housing"
L5_1 = "billing"
L6_1 = "dispatch"
L7_1 = "society"
L8_1 = "number"
L1_1[1] = L2_1
L1_1[2] = L3_1
L1_1[3] = L4_1
L1_1[4] = L5_1
L1_1[5] = L6_1
L1_1[6] = L7_1
L1_1[7] = L8_1
L2_1 = {}
L2_1.garage = "list"
L2_1.bank = nil
L2_1.housing = "list"
L2_1.billing = "list"
L2_1.dispatch = "alert"
L2_1.society = "add"
L2_1.number = "assign"
L3_1 = L0_1.known
if not L3_1 then
  L3_1 = {}
  L4_1 = {}
  L3_1.garage = L4_1
  L4_1 = {}
  L3_1.bank = L4_1
  L4_1 = {}
  L3_1.housing = L4_1
  L4_1 = {}
  L3_1.billing = L4_1
  L4_1 = {}
  L3_1.dispatch = L4_1
  L4_1 = {}
  L3_1.society = L4_1
  L4_1 = {}
  L3_1.number = L4_1
end
L0_1.known = L3_1
L3_1 = L0_1.order
if not L3_1 then
  L3_1 = {}
  L4_1 = {}
  L3_1.garage = L4_1
  L4_1 = {}
  L3_1.bank = L4_1
  L4_1 = {}
  L3_1.housing = L4_1
  L4_1 = {}
  L3_1.billing = L4_1
  L4_1 = {}
  L3_1.dispatch = L4_1
  L4_1 = {}
  L3_1.society = L4_1
  L4_1 = {}
  L3_1.number = L4_1
end
L0_1.order = L3_1
L3_1 = L0_1.builtin
if not L3_1 then
  L3_1 = {}
end
L0_1.builtin = L3_1
L3_1 = L0_1.registered
if not L3_1 then
  L3_1 = {}
  L4_1 = {}
  L3_1.garage = L4_1
  L4_1 = {}
  L3_1.bank = L4_1
  L4_1 = {}
  L3_1.housing = L4_1
  L4_1 = {}
  L3_1.billing = L4_1
  L4_1 = {}
  L3_1.dispatch = L4_1
  L4_1 = {}
  L3_1.society = L4_1
  L4_1 = {}
  L3_1.number = L4_1
end
L0_1.registered = L3_1
L3_1 = {}
L0_1.active = L3_1
L3_1 = {}
L0_1.lastBanner = L3_1
L3_1 = {}
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L3_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    return
  end
  L2_2 = L3_1
  L2_2[A0_2] = true
  L2_2 = print
  L3_2 = "^3[unique_phone]^0 integrations: %s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = A1_2
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  L2_2(L3_2, L4_2, L5_2)
end
L0_1.warnOnce = L4_1
function L5_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = type
    L1_2 = Config
    L1_2 = L1_2.Integrations
    L0_2 = L0_2(L1_2)
    if "table" == L0_2 then
      L0_2 = Config
      L0_2 = L0_2.Integrations
      if L0_2 then
        goto lbl_18
      end
    end
  end
  L0_2 = {}
  ::lbl_18::
  return L0_2
end
function L6_1()
  local L0_2, L1_2
  L0_2 = L5_1
  L0_2 = L0_2()
  L0_2 = L0_2.debug
  L0_2 = true == L0_2
  return L0_2
end
function L7_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L6_1
  L1_2 = L1_2()
  if not L1_2 then
    return
  end
  L1_2 = pcall
  L2_2 = string
  L2_2 = L2_2.format
  L3_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = ...
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L3_2 = print
  L4_2 = "^5[unique_phone]^0 integrations: %s"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L2_2 or L6_2
  if not L1_2 or not L2_2 then
    L6_2 = tostring
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
L0_1.dbg = L7_1
function L7_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = GetResourceState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = "started" == L1_2 or "starting" == L1_2
  return L2_2
end
L0_1.started = L7_1
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "function" == L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = rawget
    L3_2 = A0_2
    L4_2 = "__cfx_functionReference"
    L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if "string" == L1_2 then
      L1_2 = true
      return L1_2
    end
    L1_2 = getmetatable
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L2_2 = type
      L3_2 = L1_2.__call
      L2_2 = L2_2(L3_2)
      if "function" == L2_2 then
        L2_2 = true
        return L2_2
      end
    end
  end
  L1_2 = false
  return L1_2
end
L0_1.isCallable = L7_1
function L7_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L0_1.started
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = false
    L3_2 = "not started"
    return L2_2, L3_2
  end
  L2_2 = table
  L2_2 = L2_2.pack
  L3_2, L4_2, L5_2, L6_2, L7_2 = ...
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L3_2 = table
  L3_2 = L3_2.pack
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = exports
    L1_3 = A0_2
    L0_3 = L0_3[L1_3]
    L1_3 = A1_2
    L1_3 = L0_3[L1_3]
    L2_3 = L0_3
    L3_3 = table
    L3_3 = L3_3.unpack
    L4_3 = L2_2
    L5_3 = 1
    L6_3 = L2_2.n
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
    return L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = table
  L4_2 = L4_2.unpack
  L5_2 = L3_2
  L6_2 = 1
  L7_2 = L3_2.n
  return L4_2(L5_2, L6_2, L7_2)
end
L0_1.callExport = L7_1
L7_1 = {}
function L8_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = A0_2
  L4_2 = "|"
  L5_2 = A1_2
  L3_2 = L3_2 .. L4_2 .. L5_2
  L4_2 = L7_1
  L4_2 = L4_2[L3_2]
  if nil == L4_2 then
    L4_2 = false
    L5_2 = L0_1.started
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      L5_2 = LoadResourceFile
      L6_2 = A0_2
      L7_2 = A1_2
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        goto lbl_22
      end
    end
    L5_2 = nil
    ::lbl_22::
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "string" == L6_2 and "" ~= L5_2 then
      L6_2 = setmetatable
      L7_2 = {}
      L8_2 = vector2
      L7_2.vector2 = L8_2
      L8_2 = vector3
      L7_2.vector3 = L8_2
      L8_2 = vector4
      L7_2.vector4 = L8_2
      L8_2 = vec2
      L7_2.vec2 = L8_2
      L8_2 = vec3
      L7_2.vec3 = L8_2
      L8_2 = vec4
      L7_2.vec4 = L8_2
      L8_2 = math
      L7_2.math = L8_2
      L8_2 = string
      L7_2.string = L8_2
      L8_2 = table
      L7_2.table = L8_2
      L8_2 = tostring
      L7_2.tostring = L8_2
      L8_2 = tonumber
      L7_2.tonumber = L8_2
      L8_2 = pairs
      L7_2.pairs = L8_2
      L8_2 = ipairs
      L7_2.ipairs = L8_2
      L8_2 = type
      L7_2.type = L8_2
      L8_2 = GetHashKey
      L7_2.GetHashKey = L8_2
      L8_2 = joaat
      L7_2.joaat = L8_2
      L8_2 = json
      L7_2.json = L8_2
      function L8_2()
        local L0_3, L1_3
      end
      L7_2.print = L8_2
      L8_2 = GetResourceState
      L7_2.GetResourceState = L8_2
      function L8_2()
        local L0_3, L1_3
        L0_3 = true
        return L0_3
      end
      L7_2.IsDuplicityVersion = L8_2
      function L8_2()
        local L0_3, L1_3
        L0_3 = A0_2
        return L0_3
      end
      L7_2.GetCurrentResourceName = L8_2
      L8_2 = {}
      function L9_2()
        local L0_3, L1_3
        L0_3 = nil
        return L0_3
      end
      L8_2.__index = L9_2
      L6_2 = L6_2(L7_2, L8_2)
      L7_2 = load
      L8_2 = L5_2
      L9_2 = "@"
      L10_2 = A0_2
      L11_2 = "/"
      L12_2 = A1_2
      L9_2 = L9_2 .. L10_2 .. L11_2 .. L12_2
      L10_2 = "t"
      L11_2 = L6_2
      L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
      if L7_2 then
        L8_2 = pcall
        L9_2 = L7_2
        L8_2 = L8_2(L9_2)
        if L8_2 then
          L4_2 = L6_2
        end
      end
    end
    L6_2 = L7_1
    L6_2[L3_2] = L4_2
  end
  if not L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L4_2
  L6_2 = tostring
  L7_2 = A2_2
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.gmatch
  L8_2 = "[^%.]+"
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2)
  for L10_2 in L6_2, L7_2, L8_2, L9_2 do
    L11_2 = type
    L12_2 = L5_2
    L11_2 = L11_2(L12_2)
    if "table" ~= L11_2 then
      L11_2 = nil
      return L11_2
    end
    L11_2 = rawget
    L12_2 = L5_2
    L13_2 = L10_2
    L11_2 = L11_2(L12_2, L13_2)
    L5_2 = L11_2
  end
  return L5_2
end
L0_1.readResourceTable = L8_1
function L8_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 and L1_2 == L1_2 then
    L2_2 = math
    L2_2 = L2_2.huge
    if L1_2 ~= L2_2 then
      L2_2 = math
      L2_2 = L2_2.huge
      L2_2 = -L2_2
      if L1_2 ~= L2_2 then
        return L1_2
      end
    end
  end
  L2_2 = nil
  return L2_2
end
L0_1.num = L8_1
function L9_1(A0_2)
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
L0_1.decode = L9_1
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L0_1.decode
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    A0_2 = L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 and "vector3" ~= L1_2 and "vector4" ~= L1_2 and "userdata" ~= L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3
    L0_3 = A0_2.x
    if not L0_3 then
      L0_3 = A0_2
      L0_3 = L0_3[1]
    end
    L1_3 = A0_2.y
    if not L1_3 then
      L1_3 = A0_2
      L1_3 = L1_3[2]
    end
    L2_3 = A0_2.z
    if not L2_3 then
      L2_3 = A0_2
      L2_3 = L2_3[3]
    end
    return L0_3, L1_3, L2_3
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  if not L2_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = L8_1
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L7_2 = L8_1
  L8_2 = L4_2
  L7_2 = L7_2(L8_2)
  L8_2 = L8_1
  L9_2 = L5_2
  L8_2 = L8_2(L9_2)
  L5_2 = L8_2
  L4_2 = L7_2
  L3_2 = L6_2
  if not L3_2 or not L4_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = {}
  L6_2.x = L3_2
  L6_2.y = L4_2
  L7_2 = L5_2 or L7_2
  if not L5_2 then
    L7_2 = 0.0
  end
  L6_2.z = L7_2
  return L6_2
end
L0_1.xyz = L9_1
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L8_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = 100000000000
    if L1_2 < L2_2 then
      L2_2 = math
      L2_2 = L2_2.floor
      L3_2 = L1_2 * 1000
      return L2_2(L3_2)
    end
    L2_2 = math
    L2_2 = L2_2.floor
    L3_2 = L1_2
    return L2_2(L3_2)
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A0_2
    L2_2 = A0_2.match
    L4_2 = "^(%d%d%d%d)%-(%d%d)%-(%d%d)[ T]?(%d*):?(%d*):?(%d*)"
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L8_2 = pcall
      L9_2 = os
      L9_2 = L9_2.time
      L10_2 = {}
      L11_2 = tonumber
      L12_2 = L2_2
      L11_2 = L11_2(L12_2)
      L10_2.year = L11_2
      L11_2 = tonumber
      L12_2 = L3_2
      L11_2 = L11_2(L12_2)
      L10_2.month = L11_2
      L11_2 = tonumber
      L12_2 = L4_2
      L11_2 = L11_2(L12_2)
      L10_2.day = L11_2
      L11_2 = tonumber
      L12_2 = L5_2
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L10_2.hour = L11_2
      L11_2 = tonumber
      L12_2 = L6_2
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L10_2.min = L11_2
      L11_2 = tonumber
      L12_2 = L7_2
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L10_2.sec = L11_2
      L8_2, L9_2 = L8_2(L9_2, L10_2)
      if L8_2 and L9_2 then
        L10_2 = L9_2 * 1000
        return L10_2
      end
    end
  end
  L2_2 = os
  L2_2 = L2_2.time
  L2_2 = L2_2()
  L2_2 = L2_2 * 1000
  return L2_2
end
L0_1.ms = L9_1
L9_1 = {}
L9_1.garage = "garage"
L9_1.garaged = "garage"
L9_1["in"] = "garage"
L9_1.stored = "garage"
L9_1.parked = "garage"
L9_1.inside = "garage"
L9_1.out = "out"
L9_1.outside = "out"
L9_1.spawned = "out"
L9_1["false"] = "out"
L9_1.impound = "impound"
L9_1.impounded = "impound"
L9_1.pound = "impound"
L9_1.depot = "impound"
L9_1.seized = "impound"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  if true == A0_2 then
    L1_2 = "garage"
    return L1_2
  end
  if false == A0_2 or nil == A0_2 then
    L1_2 = "out"
    return L1_2
  end
  L1_2 = L8_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    if 1 == L1_2 then
      L2_2 = "garage"
      if L2_2 then
        goto lbl_27
      end
    end
    if 2 == L1_2 then
      L2_2 = "impound"
      if L2_2 then
        goto lbl_27
      end
    end
    L2_2 = "out"
    ::lbl_27::
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L3_2 = L9_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L2_2 = "out"
  end
  return L2_2
end
L0_1.vehState = L10_1
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "^%s+"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+$"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
L0_1.plate = L10_1
function L10_1(A0_2)
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
L0_1.plateKey = L10_1
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = FW
  if L1_2 then
    L1_2 = FW
    L1_2 = L1_2.GetPlayerByCid
    if L1_2 then
      L1_2 = FW
      L1_2 = L1_2.GetPlayerByCid
      L2_2 = A0_2
      L1_2 = L1_2(L2_2)
      if L1_2 then
        goto lbl_15
      end
    end
  end
  L1_2 = nil
  ::lbl_15::
  if L1_2 then
    L2_2 = L1_2.firstname
    if not L2_2 then
      L2_2 = ""
    end
    L3_2 = " "
    L4_2 = L1_2.lastname
    if not L4_2 then
      L4_2 = ""
    end
    L2_2 = L2_2 .. L3_2 .. L4_2
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
    if "" ~= L2_2 then
      L3_2 = L2_2
      L4_2 = L1_2
      return L3_2, L4_2
    end
  end
  L2_2 = nil
  L3_2 = L1_2
  return L2_2, L3_2
end
L0_1.nameOf = L10_1
function L10_1(A0_2)
  local L1_2
  L1_2 = "garage" == A0_2 or "bank" == A0_2 or "housing" == A0_2 or "billing" == A0_2 or "dispatch" == A0_2 or "society" == A0_2 or "number" == A0_2
  return L1_2
end
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L10_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L3_2 = type
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L3_2 = type
      L4_2 = A2_2
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        goto lbl_17
      end
    end
  end
  do return end
  ::lbl_17::
  A2_2.id = A1_2
  L3_2 = A2_2.verified
  L3_2 = false ~= L3_2
  A2_2.verified = L3_2
  L3_2 = L0_1.known
  L3_2 = L3_2[A0_2]
  L3_2 = L3_2[A1_2]
  if not L3_2 then
    L3_2 = table
    L3_2 = L3_2.insert
    L4_2 = L0_1.order
    L4_2 = L4_2[A0_2]
    L5_2 = A1_2
    L3_2(L4_2, L5_2)
  end
  L3_2 = L0_1.known
  L3_2 = L3_2[A0_2]
  L3_2[A1_2] = A2_2
  L3_2 = L0_1.active
  L3_2[A0_2] = nil
end
L0_1.define = L11_1
function L11_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L10_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      goto lbl_12
    end
  end
  do return end
  ::lbl_12::
  A1_2.id = "builtin"
  L2_2 = L0_1.builtin
  L2_2[A0_2] = A1_2
  L2_2 = L0_1.active
  L2_2[A0_2] = nil
end
L0_1.defineBuiltin = L11_1
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L2_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = L0_1.isCallable
    L4_2 = A1_2[L2_2]
    return L3_2(L4_2)
  end
  L3_2 = pairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L0_1.isCallable
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L9_2 = true
      return L9_2
    end
  end
  L3_2 = false
  return L3_2
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L0_1.isCallable
  L3_2 = A1_2.detect
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = pcall
    L3_2 = A1_2.detect
    L2_2, L3_2 = L2_2(L3_2)
    L4_2 = L2_2 or L4_2
    L4_2 = L2_2 and true == L3_2
    return L4_2
  end
  L2_2 = type
  L3_2 = A1_2.resources
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = ipairs
    L3_2 = A1_2.resources
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L0_1.started
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if not L8_2 then
        L8_2 = false
        return L8_2
      end
    end
    L2_2 = true
    return L2_2
  end
  L2_2 = false
  return L2_2
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = rawget
  L2_2 = _G
  L3_2 = "CustomIntegrations"
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L1_2[A0_2]
    if L2_2 then
      goto lbl_14
    end
  end
  L2_2 = nil
  ::lbl_14::
  L3_2 = L11_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    return L2_2
  end
  L3_2 = nil
  return L3_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L0_1.registered
  L3_2 = L3_2[A0_2]
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = L6_2
  end
  L2_2 = table
  L2_2 = L2_2.sort
  L3_2 = L1_2
  L2_2(L3_2)
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L0_1.registered
    L8_2 = L8_2[A0_2]
    L8_2 = L8_2[L7_2]
    if L8_2 then
      L9_2 = L11_1
      L10_2 = A0_2
      L11_2 = L8_2.impl
      L9_2 = L9_2(L10_2, L11_2)
      if L9_2 then
        L9_2 = L7_2
        L10_2 = L8_2.impl
        return L9_2, L10_2
      end
    end
  end
  L2_2 = nil
  return L2_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = L5_1
  L1_2 = L1_2()
  L1_2 = L1_2[A0_2]
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 or "" == L1_2 then
    L1_2 = "auto"
  end
  L2_2 = L0_1.builtin
  L2_2 = L2_2[A0_2]
  if "builtin" == L1_2 then
    L3_2 = "builtin"
    L4_2 = L2_2
    return L3_2, L4_2
  end
  if "custom" == L1_2 then
    L3_2 = L14_1
    L4_2 = A0_2
    L3_2, L4_2 = L3_2(L4_2)
    if L3_2 then
      L5_2 = "registered:"
      L6_2 = L3_2
      L5_2 = L5_2 .. L6_2
      L6_2 = L4_2
      return L5_2, L6_2
    end
    L5_2 = L13_1
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      L6_2 = "custom"
      L7_2 = L5_2
      return L6_2, L7_2
    end
    L6_2 = L4_1
    L7_2 = "nocustom_"
    L8_2 = A0_2
    L7_2 = L7_2 .. L8_2
    L8_2 = "Config.Integrations.%s = 'custom' but integrations/custom.lua has no %s adapter and nothing was registered: using the phone's built-in behaviour"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = A0_2
    L11_2 = A0_2
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L8_2(L9_2, L10_2, L11_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L6_2 = "builtin"
    L7_2 = L2_2
    return L6_2, L7_2
  end
  if "auto" ~= L1_2 then
    L3_2 = L0_1.registered
    L3_2 = L3_2[A0_2]
    L3_2 = L3_2[L1_2]
    if L3_2 then
      L4_2 = L11_1
      L5_2 = A0_2
      L6_2 = L3_2.impl
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        L4_2 = "registered:"
        L5_2 = L1_2
        L4_2 = L4_2 .. L5_2
        L5_2 = L3_2.impl
        return L4_2, L5_2
      end
    end
    L4_2 = L0_1.known
    L4_2 = L4_2[A0_2]
    L4_2 = L4_2[L1_2]
    if not L4_2 then
      L5_2 = L4_1
      L6_2 = "unknown_"
      L7_2 = A0_2
      L8_2 = L1_2
      L6_2 = L6_2 .. L7_2 .. L8_2
      L7_2 = "Config.Integrations.%s = '%s' is not a known provider: using the phone's built-in behaviour"
      L8_2 = L7_2
      L7_2 = L7_2.format
      L9_2 = A0_2
      L10_2 = L1_2
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L7_2(L8_2, L9_2, L10_2)
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      L5_2 = "builtin"
      L6_2 = L2_2
      return L5_2, L6_2
    end
    L5_2 = L12_1
    L6_2 = A0_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      L5_2 = L4_2.aliasBuiltin
      if L5_2 then
        L5_2 = "builtin"
        L6_2 = L2_2
        return L5_2, L6_2
      end
      L5_2 = L1_2
      L6_2 = L4_2
      return L5_2, L6_2
    end
    L5_2 = L4_1
    L6_2 = "missing_"
    L7_2 = A0_2
    L8_2 = L1_2
    L6_2 = L6_2 .. L7_2 .. L8_2
    L7_2 = "Config.Integrations.%s = '%s' but that resource is not started: using the phone's built-in behaviour until it starts"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = A0_2
    L10_2 = L1_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L7_2(L8_2, L9_2, L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L5_2 = "builtin"
    L6_2 = L2_2
    return L5_2, L6_2
  end
  L3_2 = L14_1
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  if L3_2 then
    L5_2 = "registered:"
    L6_2 = L3_2
    L5_2 = L5_2 .. L6_2
    L6_2 = L4_2
    return L5_2, L6_2
  end
  L5_2 = L13_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = "custom"
    L7_2 = L5_2
    return L6_2, L7_2
  end
  L6_2 = ipairs
  L7_2 = L0_1.order
  L7_2 = L7_2[A0_2]
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L0_1.known
    L12_2 = L12_2[A0_2]
    L12_2 = L12_2[L11_2]
    if L12_2 then
      L13_2 = L12_2.manualOnly
      if not L13_2 then
        L13_2 = L12_1
        L14_2 = A0_2
        L15_2 = L12_2
        L13_2 = L13_2(L14_2, L15_2)
        if L13_2 then
          L13_2 = L12_2.aliasBuiltin
          if L13_2 then
            L13_2 = "builtin"
            L14_2 = L2_2
            return L13_2, L14_2
          end
          L13_2 = L11_2
          L14_2 = L12_2
          return L13_2, L14_2
        end
      end
    end
  end
  L6_2 = "builtin"
  L7_2 = L2_2
  return L6_2, L7_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L0_1.active
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = L1_2.def
    L3_2 = L1_2.id
    return L2_2, L3_2
  end
  L2_2 = L15_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L3_2 then
    L4_2 = L0_1.builtin
    L4_2 = L4_2[A0_2]
    L3_2 = L4_2 or L3_2
    if not L4_2 then
      L4_2 = {}
      L3_2 = L4_2
    end
  end
  L4_2 = L0_1.active
  L5_2 = {}
  L5_2.id = L2_2
  L5_2.def = L3_2
  L4_2[A0_2] = L5_2
  L4_2 = L0_1.lastBanner
  L4_2 = L4_2[A0_2]
  if nil ~= L4_2 then
    L4_2 = L0_1.lastBanner
    L4_2 = L4_2[A0_2]
    if L4_2 ~= L2_2 then
      L4_2 = print
      L5_2 = "^2[unique_phone]^0 integrations: %s -> %s"
      L6_2 = L5_2
      L5_2 = L5_2.format
      L7_2 = A0_2
      L8_2 = L2_2
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
      L4_2(L5_2, L6_2, L7_2, L8_2)
    end
  end
  L4_2 = L0_1.lastBanner
  L4_2[A0_2] = L2_2
  L4_2 = L3_2
  L5_2 = L2_2
  return L4_2, L5_2
end
Integration = L16_1
function L16_1(A0_2)
  local L1_2, L2_2
  L1_2 = Integration
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  return L2_2
end
IntegrationId = L16_1
function L16_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = Integration
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L2_2 or L4_2
  if L2_2 then
    L4_2 = L2_2[A1_2]
  end
  if "builtin" ~= L3_2 then
    L5_2 = L0_1.isCallable
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      L5_2 = table
      L5_2 = L5_2.pack
      L6_2 = pcall
      L7_2 = L4_2
      L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = ...
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L6_2 = L5_2[1]
      if L6_2 then
        L6_2 = table
        L6_2 = L6_2.unpack
        L7_2 = L5_2
        L8_2 = 2
        L9_2 = L5_2.n
        return L6_2(L7_2, L8_2, L9_2)
      end
      L6_2 = L4_1
      L7_2 = "err_"
      L8_2 = A0_2
      L9_2 = L3_2
      L10_2 = A1_2
      L7_2 = L7_2 .. L8_2 .. L9_2 .. L10_2
      L8_2 = "%s provider '%s' failed in %s (%s): using the phone's built-in behaviour for this call"
      L9_2 = L8_2
      L8_2 = L8_2.format
      L10_2 = A0_2
      L11_2 = L3_2
      L12_2 = A1_2
      L13_2 = tostring
      L14_2 = L5_2[2]
      L13_2, L14_2 = L13_2(L14_2)
      L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
  L5_2 = L0_1.builtin
  L5_2 = L5_2[A0_2]
  L6_2 = L5_2 or L6_2
  if L5_2 then
    L6_2 = L5_2[A1_2]
  end
  L7_2 = L0_1.isCallable
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if L7_2 then
    L7_2 = L6_2
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = ...
    return L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  end
  L7_2 = nil
  return L7_2
end
IntegrationCall = L16_1
function L16_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = Integration
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L2_2 or L4_2
  if L2_2 then
    L4_2 = L2_2[A1_2]
  end
  L5_2 = L0_1.isCallable
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = table
  L5_2 = L5_2.pack
  L6_2 = pcall
  L7_2 = L4_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = ...
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = L5_2[1]
  if not L6_2 then
    L6_2 = L4_1
    L7_2 = "err_"
    L8_2 = A0_2
    L9_2 = L3_2
    L10_2 = A1_2
    L7_2 = L7_2 .. L8_2 .. L9_2 .. L10_2
    L8_2 = "%s provider '%s' failed in %s (%s)"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = A0_2
    L11_2 = L3_2
    L12_2 = A1_2
    L13_2 = tostring
    L14_2 = L5_2[2]
    L13_2, L14_2 = L13_2(L14_2)
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L6_2 = false
    return L6_2
  end
  L6_2 = true
  L7_2 = table
  L7_2 = L7_2.unpack
  L8_2 = L5_2
  L9_2 = 2
  L10_2 = L5_2.n
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2, L9_2, L10_2)
  return L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
end
IntegrationTry = L16_1
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = Integration
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L0_1.isCallable
  L4_2 = L2_2[A1_2]
  L3_2 = nil ~= L2_2 and L3_2
  return L3_2
end
IntegrationHas = L16_1
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = ipairs
  L1_2 = L1_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = L0_1.active
    L6_2[L5_2] = nil
  end
end
L0_1.invalidate = L16_1
L17_1 = AddEventHandler
L18_1 = "onResourceStart"
function L19_1()
  local L0_2, L1_2
  L0_2 = {}
  L7_1 = L0_2
  L0_2 = L16_1
  L0_2()
end
L17_1(L18_1, L19_1)
L17_1 = AddEventHandler
L18_1 = "onResourceStop"
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = {}
  L7_1 = L1_2
  L1_2 = ipairs
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = pairs
    L8_2 = L0_1.registered
    L8_2 = L8_2[L6_2]
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = L12_2.owner
      if L13_2 == A0_2 then
        L13_2 = L0_1.registered
        L13_2 = L13_2[L6_2]
        L13_2[L11_2] = nil
      end
    end
  end
  L1_2 = L16_1
  L1_2()
end
L17_1(L18_1, L19_1)
function L17_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L10_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = false
    L4_2 = "category"
    return L3_2, L4_2
  end
  L3_2 = L11_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = false
    L4_2 = "impl"
    return L3_2, L4_2
  end
  L3_2 = GetInvokingResource
  L3_2 = L3_2()
  if not L3_2 then
    L3_2 = GetCurrentResourceName
    L3_2 = L3_2()
  end
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "string" ~= L4_2 or "" == A2_2 or not A2_2 then
    A2_2 = L3_2
  end
  L4_2 = L0_1.registered
  L4_2 = L4_2[A0_2]
  L5_2 = {}
  L5_2.impl = A1_2
  L5_2.owner = L3_2
  L4_2[A2_2] = L5_2
  L4_2 = L16_1
  L4_2()
  L4_2 = print
  L5_2 = "^2[unique_phone]^0 integrations: %s provider \"%s\" registered by %s"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = A0_2
  L8_2 = A2_2
  L9_2 = L3_2
  L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = true
  return L4_2
end
L18_1 = exports
L19_1 = "RegisterIntegration"
L20_1 = L17_1
L18_1(L19_1, L20_1)
L18_1 = exports
L19_1 = "UnregisterIntegration"
function L20_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L10_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 or "" == A1_2 or not A1_2 then
    L2_2 = GetInvokingResource
    L2_2 = L2_2()
    A1_2 = L2_2 or A1_2
    if not L2_2 then
      A1_2 = ""
    end
  end
  L2_2 = L0_1.registered
  L2_2 = L2_2[A0_2]
  L2_2 = L2_2[A1_2]
  if L2_2 then
    L2_2 = L0_1.registered
    L2_2 = L2_2[A0_2]
    L2_2[A1_2] = nil
    L2_2 = L16_1
    L2_2()
    L2_2 = true
    return L2_2
  end
  L2_2 = false
  return L2_2
end
L18_1(L19_1, L20_1)
L18_1 = exports
L19_1 = "GetIntegration"
function L20_1(A0_2)
  local L1_2, L2_2
  L1_2 = L10_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = IntegrationId
  L2_2 = A0_2
  return L1_2(L2_2)
end
L18_1(L19_1, L20_1)
L0_1.register = L17_1
function L18_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = Integration
    L8_2 = L6_2
    L7_2, L8_2 = L7_2(L8_2)
    if L7_2 then
      L9_2 = L7_2.verified
      if false == L9_2 then
        L9_2 = " (best effort)"
        if L9_2 then
          goto lbl_19
        end
      end
    end
    L9_2 = ""
    ::lbl_19::
    L10_2 = #L0_2
    L10_2 = L10_2 + 1
    L11_2 = "%s=%s%s"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L6_2
    L14_2 = L8_2
    L15_2 = L9_2
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
    L0_2[L10_2] = L11_2
  end
  L1_2 = table
  L1_2 = L1_2.concat
  L2_2 = L0_2
  L3_2 = " | "
  return L1_2(L2_2, L3_2)
end
L0_1.statusLine = L18_1
L19_1 = CreateThread
function L20_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = Wait
  L1_2 = 3000
  L0_2(L1_2)
  L0_2 = print
  L1_2 = "^2[unique_phone]^0 integrations: %s"
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = L18_1
  L3_2 = L3_2()
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
  L0_2(L1_2, L2_2, L3_2)
end
L19_1(L20_1)
L19_1 = RegisterCommand
L20_1 = "phoneintegrations"
function L21_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
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
  L1_2 = L16_1
  L1_2()
  L1_2 = print
  L2_2 = "^2[unique_phone]^0 integrations: %s"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = L18_1
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L4_2()
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L1_2 = ipairs
  L2_2 = L1_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = {}
    L8_2 = ipairs
    L9_2 = L0_1.order
    L9_2 = L9_2[L6_2]
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = L0_1.known
      L14_2 = L14_2[L6_2]
      L14_2 = L14_2[L13_2]
      L15_2 = #L7_2
      L15_2 = L15_2 + 1
      L16_2 = L13_2
      L17_2 = L12_1
      L18_2 = L6_2
      L19_2 = L14_2
      L17_2 = L17_2(L18_2, L19_2)
      if L17_2 then
        L17_2 = "*"
        if L17_2 then
          goto lbl_48
        end
      end
      L17_2 = ""
      ::lbl_48::
      L18_2 = L14_2.verified
      if false == L18_2 then
        L18_2 = "?"
        if L18_2 then
          goto lbl_55
        end
      end
      L18_2 = ""
      ::lbl_55::
      L16_2 = L16_2 .. L17_2 .. L18_2
      L7_2[L15_2] = L16_2
    end
    L8_2 = {}
    L9_2 = pairs
    L10_2 = L0_1.registered
    L10_2 = L10_2[L6_2]
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = #L8_2
      L15_2 = L15_2 + 1
      L16_2 = L13_2
      L17_2 = "<"
      L18_2 = tostring
      L19_2 = L14_2.owner
      L18_2 = L18_2(L19_2)
      L19_2 = ">"
      L16_2 = L16_2 .. L17_2 .. L18_2 .. L19_2
      L8_2[L15_2] = L16_2
    end
    L9_2 = print
    L10_2 = "  %-8s config=%s  known: %s  registered: %s  custom: %s"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L6_2
    L13_2 = tostring
    L14_2 = L5_1
    L14_2 = L14_2()
    L14_2 = L14_2[L6_2]
    if not L14_2 then
      L14_2 = "auto"
    end
    L13_2 = L13_2(L14_2)
    L14_2 = table
    L14_2 = L14_2.concat
    L15_2 = L7_2
    L16_2 = ", "
    L14_2 = L14_2(L15_2, L16_2)
    L15_2 = #L8_2
    if L15_2 > 0 then
      L15_2 = table
      L15_2 = L15_2.concat
      L16_2 = L8_2
      L17_2 = ", "
      L15_2 = L15_2(L16_2, L17_2)
      if L15_2 then
        goto lbl_109
      end
    end
    L15_2 = "-"
    ::lbl_109::
    L16_2 = L13_1
    L17_2 = L6_2
    L16_2 = L16_2(L17_2)
    if L16_2 then
      L16_2 = "yes"
      if L16_2 then
        goto lbl_118
      end
    end
    L16_2 = "no"
    ::lbl_118::
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  end
  L1_2 = print
  L2_2 = "  (* = resource started, ? = best effort, not verified against the real resource)"
  L1_2(L2_2)
end
L22_1 = false
L19_1(L20_1, L21_1, L22_1)
