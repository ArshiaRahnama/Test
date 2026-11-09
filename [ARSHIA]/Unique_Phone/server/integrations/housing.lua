local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1
L0_1 = PhoneIntegrations
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L2_2 or L3_2
  if "table" ~= L3_2 or not L2_2 then
    L3_2 = {}
  end
  return L3_2
end
function L2_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "number" ~= L1_2 then
      goto lbl_15
    end
  end
  L1_2 = tostring
  L2_2 = A0_2
  do return L1_2(L2_2) end
  ::lbl_15::
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.citizenid
    if not L1_2 then
      L1_2 = A0_2.cid
      if not L1_2 then
        L1_2 = A0_2.identifier
      end
    end
    if nil ~= L1_2 then
      L2_2 = tostring
      L3_2 = L1_2
      return L2_2(L3_2)
    end
  end
  L1_2 = nil
  return L1_2
end
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = A0_2 or L4_2
  if "table" ~= L4_2 or not A0_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 and "" ~= L9_2 and L9_2 ~= A1_2 then
      L10_2 = #L2_2
      L10_2 = L10_2 + 1
      L11_2 = {}
      L11_2.cid = L9_2
      L12_2 = type
      L13_2 = L8_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        L12_2 = L8_2.name
        if L12_2 then
          goto lbl_39
        end
      end
      L12_2 = nil
      ::lbl_39::
      L11_2.name = L12_2
      L2_2[L10_2] = L11_2
    end
  end
  return L2_2
end
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    return L2_2
  end
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L7_2
    L9_2 = L9_2(L10_2)
    L9_2 = L7_2 or L9_2
    if "string" ~= L9_2 or not L7_2 then
      L9_2 = L2_1
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
    end
    if L9_2 and "" ~= L9_2 and L9_2 ~= A1_2 then
      L10_2 = #L2_2
      L10_2 = L10_2 + 1
      L11_2 = {}
      L11_2.cid = L9_2
      L12_2 = type
      L13_2 = L8_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        L12_2 = L8_2.name
        if L12_2 then
          goto lbl_56
        end
        L12_2 = L8_2.charName
        if L12_2 then
          goto lbl_56
        end
      end
      L12_2 = type
      L13_2 = L8_2
      L12_2 = L12_2(L13_2)
      L12_2 = L8_2 or L12_2
      if "string" ~= L12_2 or L8_2 == L9_2 or not L8_2 then
        L12_2 = nil
      end
      ::lbl_56::
      L11_2.name = L12_2
      L2_2[L10_2] = L11_2
    end
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L2_2
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.cid
    L3_3 = A1_3.cid
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L3_2(L4_2, L5_2)
  return L2_2
end
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = ipairs
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L3_2 = A0_2 or L3_2
  if "table" ~= L3_2 or not A0_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L2_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 == A1_2 then
      L8_2 = true
      return L8_2
    end
  end
  L2_2 = false
  return L2_2
end
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = 0
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2 = L1_2 + 1
  end
  L2_2 = #A0_2
  L2_2 = L1_2 == L2_2
  return L2_2
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = A1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = A0_2[L7_2]
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L0_1.decode
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      L8_2 = L9_2
    end
    if nil ~= L8_2 then
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = rawget
        L10_2 = L8_2
        L11_2 = "enter"
        L9_2 = L9_2(L10_2, L11_2)
        if L9_2 then
          goto lbl_48
        end
        L9_2 = rawget
        L10_2 = L8_2
        L11_2 = "entrance"
        L9_2 = L9_2(L10_2, L11_2)
        if L9_2 then
          goto lbl_48
        end
        L9_2 = rawget
        L10_2 = L8_2
        L11_2 = "door"
        L9_2 = L9_2(L10_2, L11_2)
        if L9_2 then
          goto lbl_48
        end
      end
      L9_2 = nil
      ::lbl_48::
      if nil ~= L9_2 then
        L10_2 = L0_1.xyz
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        if L10_2 then
          goto lbl_58
        end
      end
      L10_2 = L0_1.xyz
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      ::lbl_58::
      if L10_2 then
        return L10_2
      end
    end
  end
  L2_2 = nil
  return L2_2
end
function L8_1(A0_2)
  local L1_2, L2_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = A0_2 or L1_2
  if "" == A0_2 or not A0_2 then
    L1_2 = nil
  end
  return L1_2
end
function L9_1(A0_2)
  local L1_2
  if true == A0_2 or 1 == A0_2 then
    L1_2 = true
    return L1_2
  end
  if false == A0_2 or 0 == A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = nil
  return L1_2
end
L10_1 = {}
function L11_1()
  local L0_2, L1_2
end
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = A0_2
  L4_2 = "|"
  L5_2 = A1_2
  L3_2 = L3_2 .. L4_2 .. L5_2
  L4_2 = L10_1
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
      L8_2 = next
      L7_2.next = L8_2
      L8_2 = select
      L7_2.select = L8_2
      L8_2 = GetHashKey
      L7_2.GetHashKey = L8_2
      L8_2 = joaat
      L7_2.joaat = L8_2
      L8_2 = json
      L7_2.json = L8_2
      L8_2 = L11_1
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
      function L8_2(A0_3, A1_3)
        return A1_3
      end
      L7_2.GetConvar = L8_2
      L8_2 = setmetatable
      L9_2 = {}
      L10_2 = {}
      L11_2 = L11_1
      L10_2.__call = L11_2
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = setmetatable
        L1_3 = {}
        L2_3 = {}
        function L3_3()
          local L0_4, L1_4
          L0_4 = L11_1
          return L0_4
        end
        L2_3.__index = L3_3
        return L0_3(L1_3, L2_3)
      end
      L10_2.__index = L11_2
      L8_2 = L8_2(L9_2, L10_2)
      L7_2.exports = L8_2
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
        L8_2, L9_2 = L8_2(L9_2)
        if L8_2 then
          L10_2 = {}
          L10_2.env = L6_2
          L10_2.ret = L9_2
          L4_2 = L10_2
        end
      end
    end
    L6_2 = L10_1
    L6_2[L3_2] = L4_2
  end
  if not L4_2 then
    L5_2 = nil
    return L5_2
  end
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L1_3 = tostring
    L2_3 = A2_2
    L1_3 = L1_3(L2_3)
    L2_3 = L1_3
    L1_3 = L1_3.gmatch
    L3_3 = "[^%.]+"
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3, L3_3)
    for L5_3 in L1_3, L2_3, L3_3, L4_3 do
      L6_3 = type
      L7_3 = A0_3
      L6_3 = L6_3(L7_3)
      if "table" ~= L6_3 then
        L6_3 = nil
        return L6_3
      end
      L6_3 = rawget
      L7_3 = A0_3
      L8_3 = L5_3
      L6_3 = L6_3(L7_3, L8_3)
      A0_3 = L6_3
    end
    return A0_3
  end
  L6_2 = type
  L7_2 = L4_2.ret
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = L5_2
    L7_2 = L4_2.ret
    L6_2 = L6_2(L7_2)
    if L6_2 then
      goto lbl_136
    end
  end
  L6_2 = nil
  ::lbl_136::
  if nil == L6_2 then
    L7_2 = L5_2
    L8_2 = L4_2.env
    L7_2 = L7_2(L8_2)
    L6_2 = L7_2
  end
  return L6_2
end
L13_1 = AddEventHandler
L14_1 = "onResourceStart"
function L15_1()
  local L0_2, L1_2
  L0_2 = {}
  L10_1 = L0_2
end
L13_1(L14_1, L15_1)
L13_1 = AddEventHandler
L14_1 = "onResourceStop"
function L15_1()
  local L0_2, L1_2
  L0_2 = {}
  L10_1 = L0_2
end
L13_1(L14_1, L15_1)
L13_1 = {}
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L0_1.started
  L2_2 = "ox_doorlock"
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = L0_1.callExport
    L2_2 = "ox_doorlock"
    L3_2 = "getDoorFromName"
    L4_2 = A0_2
    L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      L3_2 = type
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        L3_2 = L2_2.id
        if nil ~= L3_2 then
          L3_2 = {}
          L3_2.kind = "ox"
          L4_2 = L2_2.id
          L3_2.id = L4_2
          L4_2 = L0_1.xyz
          L5_2 = L2_2.coords
          L4_2 = L4_2(L5_2)
          L3_2.coords = L4_2
          L4_2 = L9_1
          L5_2 = L2_2.state
          L4_2 = L4_2(L5_2)
          L3_2.locked = L4_2
          L3_2.raw = L2_2
          return L3_2
        end
      end
    end
  end
  L1_2 = L0_1.started
  L2_2 = "qb-doorlock"
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = L0_1.callExport
    L2_2 = "qb-doorlock"
    L3_2 = "getDoor"
    L4_2 = A0_2
    L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      L3_2 = type
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        L3_2 = L2_2.objCoords
        if not L3_2 then
          L3_2 = L2_2.textCoords
          if not L3_2 then
            L3_2 = type
            L4_2 = L2_2.doors
            L3_2 = L3_2(L4_2)
            if "table" == L3_2 then
              L3_2 = type
              L4_2 = L2_2.doors
              L4_2 = L4_2[1]
              L3_2 = L3_2(L4_2)
              if "table" == L3_2 then
                L3_2 = L2_2.doors
                L3_2 = L3_2[1]
                L3_2 = L3_2.objCoords
                if L3_2 then
                  goto lbl_76
                end
              end
            end
            L3_2 = nil
          end
        end
        ::lbl_76::
        L4_2 = {}
        L4_2.kind = "qb"
        L4_2.id = A0_2
        L5_2 = L0_1.xyz
        L6_2 = L3_2
        L5_2 = L5_2(L6_2)
        L4_2.coords = L5_2
        L5_2 = L9_1
        L6_2 = L2_2.locked
        L5_2 = L5_2(L6_2)
        L4_2.locked = L5_2
        L4_2.raw = L2_2
        return L4_2
      end
    end
  end
  L1_2 = nil
  return L1_2
end
L13_1.get = L14_1
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = A0_2.kind
  if "ox" == L3_2 then
    L3_2 = L0_1.callExport
    L4_2 = "ox_doorlock"
    L5_2 = "setDoorState"
    L6_2 = A0_2.id
    if A1_2 then
      L7_2 = 1
      if L7_2 then
        goto lbl_14
      end
    end
    L7_2 = 0
    ::lbl_14::
    L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
    L5_2 = L3_2 or L5_2
    L5_2 = L3_2 and false ~= L4_2
    return L5_2
  else
    L3_2 = A0_2.kind
    if "qb" == L3_2 then
      if A2_2 then
        L3_2 = FW
        L3_2 = L3_2.GetPlayer
        L4_2 = A2_2
        L3_2 = L3_2(L4_2)
        if L3_2 then
          goto lbl_36
        end
      end
      L3_2 = false
      do return L3_2 end
      ::lbl_36::
      L3_2 = TriggerEvent
      L4_2 = "qb-doorlock:server:updateState"
      L5_2 = A0_2.id
      L6_2 = true == A1_2
      L7_2 = false
      L8_2 = false
      L9_2 = true
      L10_2 = true
      L11_2 = true
      L12_2 = A2_2
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
      L3_2 = true
      return L3_2
    end
  end
  L3_2 = false
  return L3_2
end
L13_1.set = L14_1
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = A0_2.kind
  if "ox" == L3_2 then
    L3_2 = {}
    L4_2 = ipairs
    L5_2 = type
    L6_2 = A0_2.raw
    L6_2 = L6_2.characters
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L5_2 = A0_2.raw
      L5_2 = L5_2.characters
      if L5_2 then
        goto lbl_19
      end
    end
    L5_2 = {}
    ::lbl_19::
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      if L9_2 ~= A1_2 then
        L10_2 = #L3_2
        L10_2 = L10_2 + 1
        L3_2[L10_2] = L9_2
      end
    end
    if A2_2 then
      L4_2 = #L3_2
      L4_2 = L4_2 + 1
      L3_2[L4_2] = A1_2
    end
    L4_2 = L0_1.callExport
    L5_2 = "ox_doorlock"
    L6_2 = "editDoor"
    L7_2 = A0_2.id
    L8_2 = {}
    L8_2.characters = L3_2
    L4_2(L5_2, L6_2, L7_2, L8_2)
  else
    L3_2 = A0_2.kind
    if "qb" == L3_2 then
      L3_2 = {}
      L4_2 = pairs
      L5_2 = type
      L6_2 = A0_2.raw
      L6_2 = L6_2.authorizedCitizenIDs
      L5_2 = L5_2(L6_2)
      if "table" == L5_2 then
        L5_2 = A0_2.raw
        L5_2 = L5_2.authorizedCitizenIDs
        if L5_2 then
          goto lbl_63
        end
      end
      L5_2 = {}
      ::lbl_63::
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L3_2[L8_2] = L9_2
      end
      if A2_2 then
        L4_2 = true
        if L4_2 then
          goto lbl_75
        end
      end
      L4_2 = nil
      ::lbl_75::
      L3_2[A1_2] = L4_2
      L4_2 = L0_1.callExport
      L5_2 = "qb-doorlock"
      L6_2 = "updateDoor"
      L7_2 = A0_2.id
      L8_2 = {}
      L8_2.authorizedCitizenIDs = L3_2
      L4_2(L5_2, L6_2, L7_2, L8_2)
    end
  end
end
L13_1.access = L14_1
L0_1.Doors = L13_1
L14_1 = L0_1.define
L15_1 = "housing"
L16_1 = "qb-houses"
L17_1 = {}
L17_1.label = "qb-houses"
L18_1 = {}
L19_1 = "qb-houses"
L18_1[1] = L19_1
L17_1.resources = L18_1
L17_1.aliasBuiltin = true
L14_1(L15_1, L16_1, L17_1)
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L1_1
  L2_2 = "SELECT property_id, owner_citizenid, shell, has_access, door_data FROM properties WHERE property_id = ? LIMIT 1"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  L1_2 = L1_2[1]
  return L1_2
end
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = tonumber
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A1_2.count
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  L2_2 = L2_2(L3_2)
  L3_2 = {}
  if not L2_2 or L2_2 < 1 then
    return L3_2
  end
  L4_2 = 1
  L5_2 = math
  L5_2 = L5_2.min
  L6_2 = L2_2
  L7_2 = 32
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L13_1.get
    L9_2 = "ps_mloproperty%s_%s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = A0_2
    L12_2 = L7_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2)
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
    if L8_2 then
      L9_2 = #L3_2
      L9_2 = L9_2 + 1
      L3_2[L9_2] = L8_2
    end
  end
  return L3_2
end
function L16_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L5_2 = TriggerEvent
  L6_2 = "ps-housing:server:updateProperty"
  L7_2 = "UpdateHas_access"
  L8_2 = tostring
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  L9_2 = A2_2
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = A1_2.shell
  if "mlo" == L5_2 then
    L5_2 = ipairs
    L6_2 = L15_1
    L7_2 = A0_2
    L8_2 = L0_1.decode
    L9_2 = A1_2.door_data
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2)
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = L13_1.access
      L12_2 = L10_2
      L13_2 = A3_2
      L14_2 = A4_2
      L11_2(L12_2, L13_2, L14_2)
    end
  end
end
L17_1 = L0_1.define
L18_1 = "housing"
L19_1 = "ps-housing"
L20_1 = {}
L20_1.label = "ps-housing"
L21_1 = {}
L22_1 = "ps-housing"
L21_1[1] = L22_1
L20_1.resources = L21_1
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT property_id, owner_citizenid, street, region, apartment, shell, has_access, door_data, garage_data FROM properties WHERE owner_citizenid = ? OR has_access LIKE ?"
  L6_2 = {}
  L7_2 = A1_2
  L8_2 = "%\""
  L9_2 = A1_2
  L10_2 = "\"%"
  L8_2 = L8_2 .. L9_2 .. L10_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L0_1.decode
    L10_2 = L8_2.has_access
    L9_2 = L9_2(L10_2)
    L10_2 = L8_2.owner_citizenid
    L10_2 = L10_2 == A1_2
    if not L10_2 then
      L11_2 = L5_1
      L12_2 = L9_2
      L13_2 = A1_2
      L11_2 = L11_2(L12_2, L13_2)
      if not L11_2 then
        goto lbl_169
      end
    end
    L11_2 = L0_1.decode
    L12_2 = L8_2.door_data
    L11_2 = L11_2(L12_2)
    L12_2 = L8_2.apartment
    if L12_2 then
      L12_2 = L8_2.apartment
      if "" ~= L12_2 then
        L12_2 = tostring
        L13_2 = L8_2.apartment
        L12_2 = L12_2(L13_2)
        if L12_2 then
          goto lbl_48
        end
      end
    end
    L12_2 = nil
    ::lbl_48::
    L13_2 = nil
    L14_2 = nil
    L15_2 = false
    if L12_2 then
      L16_2 = L12_1
      L17_2 = "ps-housing"
      L18_2 = "shared/config.lua"
      L19_2 = "Config.Apartments"
      L16_2 = L16_2(L17_2, L18_2, L19_2)
      L17_2 = type
      L18_2 = L16_2
      L17_2 = L17_2(L18_2)
      if "table" == L17_2 then
        L17_2 = type
        L18_2 = L16_2[L12_2]
        L17_2 = L17_2(L18_2)
        if "table" == L17_2 then
          L17_2 = L0_1.xyz
          L18_2 = L16_2[L12_2]
          L18_2 = L18_2.door
          L17_2 = L17_2(L18_2)
          L13_2 = L17_2 or L13_2
        end
      end
      if not L17_2 then
        L13_2 = nil
      end
    else
      L16_2 = L8_2.shell
      local useFb = false
      if "mlo" ~= L16_2 then
        L16_2 = L11_2.count
        if not L16_2 then
          useFb = true
        end
      end
      if not useFb then
        L16_2 = L15_1
        L17_2 = L8_2.property_id
        L18_2 = L11_2
        L16_2 = L16_2(L17_2, L18_2)
        L17_2 = L16_2[1]
        if L17_2 then
          L17_2 = L16_2[1]
          L17_2 = L17_2.coords
          L18_2 = L16_2[1]
          L18_2 = L18_2.locked
          L15_2 = true
          L14_2 = L18_2
          L13_2 = L17_2
        else
          useFb = true
        end
      end
      if useFb then
        L16_2 = L0_1.xyz
        L17_2 = L11_2
        L16_2 = L16_2(L17_2)
        L13_2 = L16_2
      end
    end
    ::lbl_100::
    if L12_2 then
      L16_2 = L12_2
      L17_2 = " "
      L18_2 = tostring
      L19_2 = L8_2.property_id
      L18_2 = L18_2(L19_2)
      L16_2 = L16_2 .. L17_2 .. L18_2
      if L16_2 then
        goto lbl_131
      end
    end
    L16_2 = tostring
    L17_2 = L8_2.street
    if not L17_2 then
      L17_2 = "Casa"
    end
    L16_2 = L16_2(L17_2)
    L17_2 = L8_2.region
    if L17_2 then
      L17_2 = L8_2.region
      if "" ~= L17_2 then
        L17_2 = ", "
        L18_2 = tostring
        L19_2 = L8_2.region
        L18_2 = L18_2(L19_2)
        L17_2 = L17_2 .. L18_2
        if L17_2 then
          goto lbl_130
        end
      end
    end
    L17_2 = ""
    ::lbl_130::
    L16_2 = L16_2 .. L17_2
    ::lbl_131::
    L17_2 = #L2_2
    L17_2 = L17_2 + 1
    L18_2 = {}
    L19_2 = tostring
    L20_2 = L8_2.property_id
    L19_2 = L19_2(L20_2)
    L18_2.id = L19_2
    L18_2.label = L16_2
    L18_2.owner = L10_2
    L19_2 = L8_2.owner_citizenid
    L18_2.ownerCid = L19_2
    L18_2.coords = L13_2
    L19_2 = L0_1.xyz
    L20_2 = L8_2.garage_data
    L19_2 = L19_2(L20_2)
    L18_2.garage = L19_2
    if L12_2 then
      L19_2 = 1
      if L19_2 then
        goto lbl_155
      end
    end
    L19_2 = 3
    ::lbl_155::
    L18_2.tier = L19_2
    L18_2.locked = L14_2
    L18_2.lockable = L15_2
    if L10_2 then
      L19_2 = L3_1
      L20_2 = L9_2
      L21_2 = A1_2
      L19_2 = L19_2(L20_2, L21_2)
      if L19_2 then
        goto lbl_167
      end
    end
    L19_2 = nil
    ::lbl_167::
    L18_2.keyholders = L19_2
    L2_2[L17_2] = L18_2
    ::lbl_169::
  end
  return L2_2
end
L20_1.list = L21_1
function L21_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L4_2 = L14_1
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L15_1
    L6_2 = A2_2
    L7_2 = L0_1.decode
    L8_2 = L4_2.door_data
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L7_2(L8_2)
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    if L5_2 then
      goto lbl_16
    end
  end
  L5_2 = {}
  ::lbl_16::
  L6_2 = L5_2[1]
  if not L6_2 then
    L6_2 = false
    L7_2 = "nolock"
    return L6_2, L7_2
  end
  L6_2 = false
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L13_1.set
    L14_2 = L12_2
    L15_2 = A3_2
    L16_2 = A0_2
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    if L13_2 then
      L6_2 = true
    end
  end
  L7_2 = L6_2
  if L6_2 then
  end
  L8_2 = "nolock"
  return L7_2, L8_2
end
L20_1.lock = L21_1
function L21_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L5_2 = L14_1
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L5_2.owner_citizenid
    if L6_2 == A1_2 then
      goto lbl_12
    end
  end
  L6_2 = false
  L7_2 = "nokey"
  do return L6_2, L7_2 end
  ::lbl_12::
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L0_1.decode
  L9_2 = L5_2.has_access
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L6_2[L13_2] = L12_2
  end
  L7_2 = L5_1
  L8_2 = L6_2
  L9_2 = A4_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = #L6_2
    L7_2 = L7_2 + 1
    L6_2[L7_2] = A4_2
  end
  L7_2 = L16_1
  L8_2 = A2_2
  L9_2 = L5_2
  L10_2 = L6_2
  L11_2 = A4_2
  L12_2 = true
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = true
  return L7_2
end
L20_1.giveKey = L21_1
function L21_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = L14_1
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L4_2.owner_citizenid
    if L5_2 == A1_2 then
      goto lbl_12
    end
  end
  L5_2 = false
  L6_2 = "nokey"
  do return L5_2, L6_2 end
  ::lbl_12::
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L0_1.decode
  L8_2 = L4_2.has_access
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    if L11_2 ~= A3_2 then
      L12_2 = #L5_2
      L12_2 = L12_2 + 1
      L5_2[L12_2] = L11_2
    end
  end
  L6_2 = L16_1
  L7_2 = A2_2
  L8_2 = L4_2
  L9_2 = L5_2
  L10_2 = A3_2
  L11_2 = false
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = true
  return L6_2
end
L20_1.removeKey = L21_1
L17_1(L18_1, L19_1, L20_1)
L17_1 = L0_1.define
L18_1 = "housing"
L19_1 = "qbx_properties"
L20_1 = {}
L20_1.label = "qbx_properties"
L21_1 = {}
L22_1 = "qbx_properties"
L21_1[1] = L22_1
L20_1.resources = L21_1
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT id, property_name, coords, owner, keyholders, garage FROM properties WHERE owner = ? OR keyholders LIKE ?"
  L6_2 = {}
  L7_2 = A1_2
  L8_2 = "%\""
  L9_2 = A1_2
  L10_2 = "\"%"
  L8_2 = L8_2 .. L9_2 .. L10_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L0_1.decode
    L10_2 = L8_2.keyholders
    L9_2 = L9_2(L10_2)
    L10_2 = L8_2.owner
    L10_2 = L10_2 == A1_2
    if not L10_2 then
      L11_2 = L5_1
      L12_2 = L9_2
      L13_2 = A1_2
      L11_2 = L11_2(L12_2, L13_2)
      if not L11_2 then
        goto lbl_75
      end
    end
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L12_2 = {}
    L13_2 = tostring
    L14_2 = L8_2.id
    L13_2 = L13_2(L14_2)
    L12_2.id = L13_2
    L13_2 = L8_2.property_name
    if not L13_2 then
      L13_2 = "#"
      L14_2 = tostring
      L15_2 = L8_2.id
      L14_2 = L14_2(L15_2)
      L13_2 = L13_2 .. L14_2
    end
    L12_2.label = L13_2
    L12_2.owner = L10_2
    L13_2 = L8_2.owner
    L12_2.ownerCid = L13_2
    L13_2 = L0_1.xyz
    L14_2 = L8_2.coords
    L13_2 = L13_2(L14_2)
    L12_2.coords = L13_2
    L13_2 = L0_1.xyz
    L14_2 = L8_2.garage
    L13_2 = L13_2(L14_2)
    L12_2.garage = L13_2
    L12_2.tier = 3
    L12_2.lockable = false
    if L10_2 then
      L13_2 = L3_1
      L14_2 = L9_2
      L15_2 = A1_2
      L13_2 = L13_2(L14_2, L15_2)
      if L13_2 then
        goto lbl_73
      end
    end
    L13_2 = nil
    ::lbl_73::
    L12_2.keyholders = L13_2
    L2_2[L11_2] = L12_2
    ::lbl_75::
  end
  return L2_2
end
L20_1.list = L21_1
function L21_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L5_2 = L1_1
  L6_2 = "SELECT keyholders FROM properties WHERE id = ? AND owner = ? LIMIT 1"
  L7_2 = {}
  L8_2 = A2_2
  L9_2 = A1_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  L5_2 = L5_2[1]
  if not L5_2 then
    L6_2 = false
    L7_2 = "nokey"
    return L6_2, L7_2
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L0_1.decode
  L9_2 = L5_2.keyholders
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L6_2[L13_2] = L12_2
  end
  L7_2 = L5_1
  L8_2 = L6_2
  L9_2 = A4_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = #L6_2
    L7_2 = L7_2 + 1
    L6_2[L7_2] = A4_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE properties SET keyholders = ? WHERE id = ? AND owner = ?"
  L9_2 = {}
  L10_2 = json
  L10_2 = L10_2.encode
  L11_2 = L6_2
  L10_2 = L10_2(L11_2)
  L11_2 = A2_2
  L12_2 = A1_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L7_2(L8_2, L9_2)
  L7_2 = true
  return L7_2
end
L20_1.giveKey = L21_1
function L21_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = L1_1
  L5_2 = "SELECT keyholders FROM properties WHERE id = ? AND owner = ? LIMIT 1"
  L6_2 = {}
  L7_2 = A2_2
  L8_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2[1]
  if not L4_2 then
    L5_2 = false
    L6_2 = "nokey"
    return L5_2, L6_2
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L0_1.decode
  L8_2 = L4_2.keyholders
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    if L11_2 ~= A3_2 then
      L12_2 = #L5_2
      L12_2 = L12_2 + 1
      L5_2[L12_2] = L11_2
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE properties SET keyholders = ? WHERE id = ? AND owner = ?"
  L8_2 = {}
  L9_2 = #L5_2
  if L9_2 > 0 then
    L9_2 = json
    L9_2 = L9_2.encode
    L10_2 = L5_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_48
    end
  end
  L9_2 = "[]"
  ::lbl_48::
  L10_2 = A2_2
  L11_2 = A1_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L6_2(L7_2, L8_2)
  L6_2 = true
  return L6_2
end
L20_1.removeKey = L21_1
L17_1(L18_1, L19_1, L20_1)
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L1_1
  L4_2 = "SELECT o.id, o.name, o.rented, p.label, p.entering, p.gateway FROM owned_properties o LEFT JOIN properties p ON p.name = o.name WHERE o.owner = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L3_2(L4_2, L5_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L0_1.xyz
    L9_2 = L7_2.entering
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L9_2 = L7_2.gateway
      if L9_2 then
        L9_2 = L7_2.gateway
        if "" ~= L9_2 then
          L9_2 = L1_1
          L10_2 = "SELECT entering FROM properties WHERE name = ? LIMIT 1"
          L11_2 = {}
          L12_2 = L7_2.gateway
          L11_2[1] = L12_2
          L9_2 = L9_2(L10_2, L11_2)
          L9_2 = L9_2[1]
          if L9_2 then
            L10_2 = L0_1.xyz
            L11_2 = L9_2.entering
            L10_2 = L10_2(L11_2)
            if L10_2 then
              goto lbl_40
              L8_2 = L10_2 or L8_2
            end
          end
          L8_2 = nil
        end
      end
    end
    ::lbl_40::
    L9_2 = #L1_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = tostring
    L12_2 = L7_2.name
    L11_2 = L11_2(L12_2)
    L10_2.id = L11_2
    L11_2 = L7_2.label
    if not L11_2 then
      L11_2 = tostring
      L12_2 = L7_2.name
      L11_2 = L11_2(L12_2)
    end
    L10_2.label = L11_2
    L10_2.owner = true
    L10_2.coords = L8_2
    L10_2.tier = 3
    L10_2.lockable = false
    L10_2.keys = false
    L11_2 = {}
    L10_2.keyholders = L11_2
    L1_2[L9_2] = L10_2
  end
  return L1_2
end
L18_1 = L0_1.define
L19_1 = "housing"
L20_1 = "esx_property"
L21_1 = {}
L21_1.label = "esx_property (read-only)"
L22_1 = {}
L23_1 = "esx_property"
L22_1[1] = L23_1
L21_1.resources = L22_1
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L0_1.callExport
  L3_2 = "esx_property"
  L4_2 = "GetProperties"
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = tostring
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L5_2 = L4_2
    L4_2 = L4_2.find
    L6_2 = "No such export"
    L7_2 = 1
    L8_2 = true
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
    if L4_2 then
      L4_2 = L17_1
      L5_2 = A1_2
      return L4_2(L5_2)
    end
    L4_2 = error
    L5_2 = "esx_property:GetProperties failed: "
    L6_2 = tostring
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    L5_2 = L5_2 .. L6_2
    L4_2(L5_2)
  end
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 then
    L4_2 = error
    L5_2 = "esx_property:GetProperties returned "
    L6_2 = type
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    L5_2 = L5_2 .. L6_2
    L4_2(L5_2)
  end
  L4_2 = {}
  L5_2 = pairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = type
      L12_2 = L10_2.Keys
      L11_2 = L11_2(L12_2)
      if "table" == L11_2 then
        L11_2 = L10_2.Keys
        if L11_2 then
          goto lbl_61
        end
      end
      L11_2 = {}
      ::lbl_61::
      L12_2 = L10_2.Owner
      L12_2 = L12_2 == A1_2
      if not L12_2 then
        L13_2 = L11_2[A1_2]
        if nil == L13_2 then
          goto lbl_143
        end
      end
      L13_2 = type
      L14_2 = L10_2.garage
      L13_2 = L13_2(L14_2)
      if "table" == L13_2 then
        L13_2 = L10_2.garage
        L13_2 = L13_2.enabled
        if L13_2 then
          L13_2 = L0_1.xyz
          L14_2 = L10_2.garage
          L14_2 = L14_2.pos
          L13_2 = L13_2(L14_2)
          if L13_2 then
            goto lbl_87
          end
        end
      end
      L13_2 = nil
      ::lbl_87::
      L14_2 = #L4_2
      L14_2 = L14_2 + 1
      L15_2 = {}
      L16_2 = tostring
      L17_2 = L9_2
      L16_2 = L16_2(L17_2)
      L15_2.id = L16_2
      L16_2 = L10_2.setName
      if nil ~= L16_2 then
        L16_2 = L10_2.setName
        if "" ~= L16_2 then
          L16_2 = L10_2.setName
          if L16_2 then
            goto lbl_113
          end
        end
      end
      L16_2 = L10_2.Name
      if not L16_2 then
        L16_2 = "#"
        L17_2 = tostring
        L18_2 = L9_2
        L17_2 = L17_2(L18_2)
        L16_2 = L16_2 .. L17_2
      end
      ::lbl_113::
      L15_2.label = L16_2
      L15_2.owner = L12_2
      L16_2 = L10_2.Owner
      L15_2.ownerCid = L16_2
      L16_2 = L0_1.xyz
      L17_2 = L10_2.Entrance
      L16_2 = L16_2(L17_2)
      L15_2.coords = L16_2
      L16_2 = L13_2 or L16_2
      if not L13_2 then
        L16_2 = nil
      end
      L15_2.garage = L16_2
      L16_2 = L10_2.Locked
      L16_2 = true == L16_2
      L15_2.locked = L16_2
      L15_2.tier = 3
      if L12_2 then
        L16_2 = L4_1
        L17_2 = L11_2
        L18_2 = A1_2
        L16_2 = L16_2(L17_2, L18_2)
        if L16_2 then
          goto lbl_141
        end
      end
      L16_2 = nil
      ::lbl_141::
      L15_2.keyholders = L16_2
      L4_2[L14_2] = L15_2
    end
    ::lbl_143::
  end
  return L4_2
end
L21_1.list = L22_1
L18_1(L19_1, L20_1, L21_1)
L18_1 = L0_1.define
L19_1 = "housing"
L20_1 = "qs-housing"
L21_1 = {}
L21_1.label = "qs-housing (list only)"
L22_1 = {}
L23_1 = "qs-housing"
L22_1[1] = L23_1
L21_1.resources = L22_1
L21_1.verified = false
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = L1_1
  L3_2 = "SELECT house, citizenid, keyholders FROM player_houses WHERE citizenid = ? OR keyholders LIKE ?"
  L4_2 = {}
  L5_2 = A1_2
  L6_2 = "%\""
  L7_2 = A1_2
  L8_2 = "\"%"
  L6_2 = L6_2 .. L7_2 .. L8_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L0_1.decode
    L13_2 = L11_2.keyholders
    L12_2 = L12_2(L13_2)
    L13_2 = L11_2.citizenid
    L13_2 = L13_2 == A1_2
    L14_2 = L11_2.house
    if L14_2 then
      if not L13_2 then
        L14_2 = L5_1
        L15_2 = L12_2
        L16_2 = A1_2
        L14_2 = L14_2(L15_2, L16_2)
        if not L14_2 then
          goto lbl_68
        end
      end
      L14_2 = L11_2.house
      L14_2 = L4_2[L14_2]
      if not L14_2 then
        L14_2 = #L3_2
        L14_2 = L14_2 + 1
        L15_2 = L11_2.house
        L3_2[L14_2] = L15_2
        L14_2 = L11_2.house
        L15_2 = {}
        L15_2.mine = L13_2
        L16_2 = L11_2.citizenid
        L15_2.owner = L16_2
        L15_2.keys = L12_2
        L4_2[L14_2] = L15_2
        L14_2 = #L5_2
        L14_2 = L14_2 + 1
        L5_2[L14_2] = "?"
      end
    end
    ::lbl_68::
  end
  L6_2 = #L3_2
  if 0 == L6_2 then
    L6_2 = {}
    return L6_2
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L1_1
  L9_2 = "SELECT name, label, coords, garage, tier FROM houselocations WHERE name IN (%s)"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = table
  L11_2 = L11_2.concat
  L12_2 = L5_2
  L13_2 = ","
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L11_2(L12_2, L13_2)
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L10_2 = L3_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L8_2(L9_2, L10_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.name
    L13_2 = L4_2[L13_2]
    if L13_2 then
      L14_2 = L0_1.decode
      L15_2 = L12_2.coords
      L14_2 = L14_2(L15_2)
      L15_2 = #L6_2
      L15_2 = L15_2 + 1
      L16_2 = {}
      L17_2 = L12_2.name
      L16_2.id = L17_2
      L17_2 = L12_2.label
      if not L17_2 then
        L17_2 = L12_2.name
      end
      L16_2.label = L17_2
      L17_2 = L13_2.mine
      L16_2.owner = L17_2
      L17_2 = L13_2.owner
      L16_2.ownerCid = L17_2
      L17_2 = L0_1.xyz
      L18_2 = L14_2.enter
      if not L18_2 then
        L18_2 = L14_2
      end
      L17_2 = L17_2(L18_2)
      L16_2.coords = L17_2
      L17_2 = L0_1.xyz
      L18_2 = L12_2.garage
      L17_2 = L17_2(L18_2)
      L16_2.garage = L17_2
      L17_2 = tonumber
      L18_2 = L12_2.tier
      L17_2 = L17_2(L18_2)
      L16_2.tier = L17_2
      L16_2.lockable = false
      L17_2 = L13_2.mine
      if L17_2 then
        L17_2 = L3_1
        L18_2 = L13_2.keys
        L19_2 = A1_2
        L17_2 = L17_2(L18_2, L19_2)
        if L17_2 then
          goto lbl_142
        end
      end
      L17_2 = nil
      ::lbl_142::
      L16_2.keyholders = L17_2
      L6_2[L15_2] = L16_2
    end
  end
  return L6_2
end
L21_1.list = L22_1
L18_1(L19_1, L20_1, L21_1)
L18_1 = L0_1.define
L19_1 = "housing"
L20_1 = "bcs_housing"
L21_1 = {}
L21_1.label = "bcs_housing"
L22_1 = {}
L23_1 = "bcs_housing"
L22_1[1] = L23_1
L21_1.resources = L22_1
L21_1.verified = false
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L0_1.callExport
  L3_2 = "bcs_housing"
  L4_2 = "GetOwnedHomeKeys"
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_20
    end
  end
  L4_2 = error
  L5_2 = "bcs_housing:GetOwnedHomeKeys failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_20::
  L4_2 = {}
  L5_2 = pairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = type
      L12_2 = L10_2.properties
      L11_2 = L11_2(L12_2)
      if "table" == L11_2 then
        L11_2 = L10_2.properties
        L10_2 = L11_2 or L10_2
      end
      if L11_2 or L10_2 then
        goto lbl_42
      end
    end
    L10_2 = nil
    ::lbl_42::
    L11_2 = L10_2 or L11_2
    if L10_2 then
      L11_2 = L8_1
      L12_2 = L10_2.identifier
      if not L12_2 then
        L12_2 = L10_2.id
        if not L12_2 then
          L12_2 = type
          L13_2 = L9_2
          L12_2 = L12_2(L13_2)
          L12_2 = L9_2 or L12_2
          if "string" ~= L12_2 or not L9_2 then
            L12_2 = nil
          end
        end
      end
      L11_2 = L11_2(L12_2)
    end
    if L11_2 then
      L12_2 = L10_2.owner
      L12_2 = L12_2 == A1_2
      L13_2 = nil
      if L12_2 then
        L14_2 = L0_1.callExport
        L15_2 = "bcs_housing"
        L16_2 = "GetKeyHolders"
        L17_2 = L11_2
        L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
        L16_2 = L4_1
        L17_2 = L15_2 or L17_2
        if not L14_2 or not L15_2 then
          L17_2 = nil
        end
        L18_2 = A1_2
        L16_2 = L16_2(L17_2, L18_2)
        L13_2 = L16_2
      end
      L14_2 = type
      L15_2 = L10_2.data
      L14_2 = L14_2(L15_2)
      if "table" == L14_2 then
        L14_2 = L10_2.data
        L14_2 = L14_2.garage
        if L14_2 then
          goto lbl_94
        end
      end
      L14_2 = nil
      ::lbl_94::
      L15_2 = #L4_2
      L15_2 = L15_2 + 1
      L16_2 = {}
      L16_2.id = L11_2
      L17_2 = L10_2.name
      if not L17_2 then
        L17_2 = L11_2
      end
      L16_2.label = L17_2
      L16_2.owner = L12_2
      L17_2 = L10_2.owner
      L16_2.ownerCid = L17_2
      L17_2 = L0_1.xyz
      L18_2 = L10_2.entry
      L17_2 = L17_2(L18_2)
      L16_2.coords = L17_2
      L17_2 = L0_1.xyz
      L18_2 = L14_2
      L17_2 = L17_2(L18_2)
      L16_2.garage = L17_2
      L17_2 = L9_1
      L18_2 = L10_2.locked
      L17_2 = L17_2(L18_2)
      L16_2.locked = L17_2
      L17_2 = L10_2.complex
      if "Apartment" ~= L17_2 then
        L17_2 = L10_2.complex
        if "Flat" ~= L17_2 then
          goto lbl_129
        end
      end
      L17_2 = 1
      ::lbl_129::
      if not L17_2 then
        L17_2 = 3
      end
      L16_2.tier = L17_2
      L17_2 = L10_2.type
      L17_2 = "mlo" ~= L17_2
      L16_2.lockable = L17_2
      L16_2.keyholders = L13_2
      L4_2[L15_2] = L16_2
    end
  end
  return L4_2
end
L21_1.list = L22_1
function L22_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = L0_1.callExport
  L5_2 = "bcs_housing"
  L6_2 = "isLocked"
  L7_2 = A2_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "boolean" == L6_2 then
      L6_2 = true == A3_2
      if L5_2 == L6_2 then
        L6_2 = true
        return L6_2
      end
    end
  end
  L6_2 = L0_1.callExport
  L7_2 = "bcs_housing"
  L8_2 = "LockHome"
  L9_2 = A2_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L7_2 = false
    L8_2 = "failed"
    return L7_2, L8_2
  end
  L7_2 = true
  return L7_2
end
L21_1.lock = L22_1
function L22_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L5_2 = L0_1.callExport
  L6_2 = "bcs_housing"
  L7_2 = "GetKeyList"
  L8_2 = A2_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  L7_2 = nil
  if L5_2 then
    L8_2 = type
    L9_2 = L6_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = {}
      L9_2 = pairs
      L10_2 = L6_2
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
        L15_2 = type
        L16_2 = L13_2
        L15_2 = L15_2(L16_2)
        if "string" == L15_2 then
          L15_2 = #L8_2
          L15_2 = L15_2 + 1
          L8_2[L15_2] = L13_2
        else
          L15_2 = type
          L16_2 = L14_2
          L15_2 = L15_2(L16_2)
          if "table" == L15_2 then
            L15_2 = L14_2.name
            if not L15_2 then
              L15_2 = L14_2.label
              if not L15_2 then
                goto lbl_52
              end
            end
            L15_2 = #L8_2
            L15_2 = L15_2 + 1
            L16_2 = tostring
            L17_2 = L14_2.name
            if not L17_2 then
              L17_2 = L14_2.label
            end
            L16_2 = L16_2(L17_2)
            L8_2[L15_2] = L16_2
          ::lbl_52::
          else
            L15_2 = type
            L16_2 = L14_2
            L15_2 = L15_2(L16_2)
            if "string" == L15_2 then
              L15_2 = #L8_2
              L15_2 = L15_2 + 1
              L8_2[L15_2] = L14_2
            end
          end
        end
      end
      L9_2 = table
      L9_2 = L9_2.sort
      L10_2 = L8_2
      L9_2(L10_2)
      L7_2 = L8_2[1]
    end
  end
  if nil == L7_2 then
    L8_2 = false
    L9_2 = "nokeyname"
    return L8_2, L9_2
  end
  L8_2 = L0_1.callExport
  L9_2 = "bcs_housing"
  L10_2 = "AddKeyHolder"
  L11_2 = A2_2
  L12_2 = A3_2
  L13_2 = L7_2
  L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  L10_2 = L8_2 or L10_2
  L10_2 = L8_2 and false ~= L9_2
  return L10_2
end
L21_1.giveKey = L22_1
function L22_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1.callExport
  L5_2 = "bcs_housing"
  L6_2 = "RemoveKeyHolder"
  L7_2 = A2_2
  L8_2 = A3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L6_2 = L4_2 or L6_2
  L6_2 = L4_2 and false ~= L5_2
  return L6_2
end
L21_1.removeKey = L22_1
L18_1(L19_1, L20_1, L21_1)
L18_1 = L0_1.define
L19_1 = "housing"
L20_1 = "nolag_properties"
L21_1 = {}
L21_1.label = "nolag_properties"
L22_1 = {}
L23_1 = "nolag_properties"
L22_1[1] = L23_1
L21_1.resources = L22_1
L21_1.verified = false
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = L0_1.callExport
  L3_2 = "nolag_properties"
  L4_2 = "GetAllProperties"
  L5_2 = A1_2
  L6_2 = "user"
  L7_2 = true
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_22
    end
  end
  L4_2 = error
  L5_2 = "nolag_properties:GetAllProperties failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_22::
  L4_2 = {}
  L5_2 = pairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L10_2.id
      if nil ~= L11_2 then
        L11_2 = L0_1.callExport
        L12_2 = "nolag_properties"
        L13_2 = "GetPropertyData"
        L14_2 = L10_2.id
        L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
        if L11_2 then
          L13_2 = type
          L14_2 = L12_2
          L13_2 = L13_2(L14_2)
          if "table" == L13_2 then
            L13_2 = L12_2.owner
            if L13_2 then
              goto lbl_52
            end
          end
        end
        L13_2 = nil
        ::lbl_52::
        L14_2 = nil
        if nil ~= L13_2 then
          L15_2 = tostring
          L16_2 = L13_2
          L15_2 = L15_2(L16_2)
          L14_2 = L15_2 == A1_2
        else
          L15_2 = L10_2.hasKey
          L14_2 = true ~= L15_2
        end
        L15_2 = nil
        if L14_2 then
          L16_2 = L0_1.callExport
          L17_2 = "nolag_properties"
          L18_2 = "GetKeyHolders"
          L19_2 = L10_2.id
          L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2)
          L18_2 = L4_1
          L19_2 = L17_2 or L19_2
          if not L16_2 or not L17_2 then
            L19_2 = nil
          end
          L20_2 = A1_2
          L18_2 = L18_2(L19_2, L20_2)
          L15_2 = L18_2
        end
        L16_2 = #L4_2
        L16_2 = L16_2 + 1
        L17_2 = {}
        L18_2 = tostring
        L19_2 = L10_2.id
        L18_2 = L18_2(L19_2)
        L17_2.id = L18_2
        L18_2 = L10_2.label
        if not L18_2 then
          L18_2 = "#"
          L19_2 = tostring
          L20_2 = L10_2.id
          L19_2 = L19_2(L20_2)
          L18_2 = L18_2 .. L19_2
        end
        L17_2.label = L18_2
        L17_2.owner = L14_2
        if L13_2 then
          L18_2 = tostring
          L19_2 = L13_2
          L18_2 = L18_2(L19_2)
          if L18_2 then
            goto lbl_112
          end
        end
        L18_2 = nil
        ::lbl_112::
        L17_2.ownerCid = L18_2
        L18_2 = L0_1.xyz
        L19_2 = L10_2.coords
        L18_2 = L18_2(L19_2)
        L17_2.coords = L18_2
        L18_2 = L9_1
        L19_2 = L10_2.doorLocked
        L18_2 = L18_2(L19_2)
        L17_2.locked = L18_2
        L17_2.tier = 3
        L17_2.keyholders = L15_2
        L4_2[L16_2] = L17_2
      end
    end
  end
  return L4_2
end
L21_1.list = L22_1
function L22_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = L0_1.callExport
  L5_2 = "nolag_properties"
  L6_2 = "ToggleDoorlock"
  L7_2 = A0_2
  L8_2 = tonumber
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = A2_2
  end
  L9_2 = true == A3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L6_2 = L4_2 or L6_2
  L6_2 = L4_2 and false ~= L5_2
  return L6_2
end
L21_1.lock = L22_1
function L22_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L5_2 = L0_1.callExport
  L6_2 = "nolag_properties"
  L7_2 = "AddKey"
  L8_2 = A0_2
  L9_2 = tonumber
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = A2_2
  end
  L10_2 = A4_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L7_2 = L5_2 or L7_2
  L7_2 = L5_2 and false ~= L6_2
  return L7_2
end
L21_1.giveKey = L22_1
function L22_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = L0_1.callExport
  L5_2 = "nolag_properties"
  L6_2 = "RemoveKey"
  L7_2 = A0_2
  L8_2 = tonumber
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = A2_2
  end
  L9_2 = A3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L6_2 = L4_2 or L6_2
  L6_2 = L4_2 and false ~= L5_2
  return L6_2
end
L21_1.removeKey = L22_1
L18_1(L19_1, L20_1, L21_1)
function L18_1(A0_2, A1_2)
  local L2_2, L3_2
  if not A0_2 then
    L2_2 = false
    L3_2 = "failed"
    return L2_2, L3_2
  end
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A1_2.success
    L2_2 = true == L2_2
    L3_2 = A1_2.success
    if true ~= L3_2 then
      L3_2 = "failed"
      if L3_2 then
        goto lbl_23
      end
    end
    L3_2 = nil
    ::lbl_23::
    return L2_2, L3_2
  end
  L2_2 = false ~= A1_2
  return L2_2
end
L19_1 = L0_1.define
L20_1 = "housing"
L21_1 = "kartik-properties"
L22_1 = {}
L22_1.label = "kartik-properties"
L23_1 = {}
L24_1 = "kartik-properties"
L23_1[1] = L24_1
L22_1.resources = L23_1
L22_1.verified = false
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = L0_1.callExport
  L3_2 = "kartik-properties"
  L4_2 = "GetPlayerHousingData"
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_20
    end
  end
  L4_2 = error
  L5_2 = "kartik-properties:GetPlayerHousingData failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_20::
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L8_1
      L12_2 = L10_2.houseId
      if not L12_2 then
        L12_2 = L10_2.id
      end
      L11_2 = L11_2(L12_2)
      if L11_2 then
        goto lbl_40
      end
    end
    L11_2 = nil
    ::lbl_40::
    if L11_2 then
      L12_2 = L10_2.owner
      L12_2 = nil ~= L12_2
      L13_2 = nil
      if L12_2 then
        L14_2 = {}
        L13_2 = L14_2
        L14_2 = ipairs
        L15_2 = type
        L16_2 = L10_2.keyholders
        L15_2 = L15_2(L16_2)
        if "table" == L15_2 then
          L15_2 = L10_2.keyholders
          if L15_2 then
            goto lbl_69
          end
        end
        L15_2 = {}
        ::lbl_69::
        L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
        for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
          L20_2 = type
          L21_2 = L19_2
          L20_2 = L20_2(L21_2)
          if "table" == L20_2 then
            L20_2 = L8_1
            L21_2 = L19_2.identifier
            L20_2 = L20_2(L21_2)
            if L20_2 then
              goto lbl_82
            end
          end
          L20_2 = nil
          ::lbl_82::
          if L20_2 and L20_2 ~= A1_2 then
            L21_2 = L19_2.isowner
            if not L21_2 then
              L21_2 = #L13_2
              L21_2 = L21_2 + 1
              L22_2 = {}
              L22_2.cid = L20_2
              L23_2 = L19_2.name
              L22_2.name = L23_2
              L13_2[L21_2] = L22_2
            end
          end
        end
      end
      L14_2 = #L4_2
      L14_2 = L14_2 + 1
      L15_2 = {}
      L15_2.id = L11_2
      L16_2 = L10_2.label
      if not L16_2 then
        L16_2 = "#"
        L17_2 = L11_2
        L16_2 = L16_2 .. L17_2
      end
      L15_2.label = L16_2
      L15_2.owner = L12_2
      L16_2 = L10_2.owner
      if L16_2 then
        L16_2 = tostring
        L17_2 = L10_2.owner
        L16_2 = L16_2(L17_2)
        if L16_2 then
          goto lbl_124
        end
      end
      L16_2 = nil
      ::lbl_124::
      L15_2.ownerCid = L16_2
      L16_2 = L0_1.xyz
      L17_2 = L10_2.coords
      L16_2 = L16_2(L17_2)
      L15_2.coords = L16_2
      L16_2 = L9_1
      L17_2 = L10_2.locked
      L16_2 = L16_2(L17_2)
      L15_2.locked = L16_2
      L15_2.tier = 3
      L15_2.keyholders = L13_2
      L4_2[L14_2] = L15_2
    end
  end
  return L4_2
end
L22_1.list = L23_1
function L23_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = L18_1
  L5_2 = L0_1.callExport
  L6_2 = "kartik-properties"
  L7_2 = "SetPropertyLocked"
  L8_2 = tonumber
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = A2_2
  end
  L9_2 = true == A3_2
  L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
end
L22_1.lock = L23_1
function L23_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L5_2 = L18_1
  L6_2 = L0_1.callExport
  L7_2 = "kartik-properties"
  L8_2 = "GrantHousingKey"
  L9_2 = tonumber
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = A2_2
  end
  L10_2 = A4_2
  L11_2 = A1_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  return L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
end
L22_1.giveKey = L23_1
function L23_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L18_1
  L5_2 = L0_1.callExport
  L6_2 = "kartik-properties"
  L7_2 = "RevokeHousingKey"
  L8_2 = tonumber
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = A2_2
  end
  L9_2 = A3_2
  L10_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L22_1.removeKey = L23_1
L19_1(L20_1, L21_1, L22_1)
L19_1 = 600
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = L8_1
  L4_2 = A0_2.id
  L3_2 = L3_2(L4_2)
  L4_2 = L0_1.callExport
  L5_2 = "tk_housing"
  L6_2 = "isPropertyLocked"
  L7_2 = A0_2.id
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  L6_2 = nil
  if L4_2 then
    L7_2 = L9_1
    L8_2 = L5_2
    L7_2 = L7_2(L8_2)
    L6_2 = L7_2
  end
  L7_2 = nil
  if A2_2 then
    L8_2 = L0_1.callExport
    L9_2 = "tk_housing"
    L10_2 = "getPropertyKeyholders"
    L11_2 = A0_2.id
    L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
    if L8_2 then
      L10_2 = L6_1
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L10_2 = L3_1
        L11_2 = L9_2
        L12_2 = A1_2
        L10_2 = L10_2(L11_2, L12_2)
        if L10_2 then
          goto lbl_46
          L7_2 = L10_2 or L7_2
        end
      end
    end
    L10_2 = L4_1
    L11_2 = L9_2 or L11_2
    if not L8_2 or not L9_2 then
      L11_2 = nil
    end
    L12_2 = A1_2
    L10_2 = L10_2(L11_2, L12_2)
    L7_2 = L10_2
  end
  ::lbl_46::
  L8_2 = {}
  L8_2.id = L3_2
  L9_2 = A0_2.name
  if not L9_2 then
    L9_2 = A0_2.address
    if not L9_2 then
      L9_2 = "#"
      L10_2 = L3_2
      L9_2 = L9_2 .. L10_2
    end
  end
  L8_2.label = L9_2
  L8_2.owner = A2_2
  L9_2 = A0_2.owner
  if L9_2 then
    L9_2 = tostring
    L10_2 = A0_2.owner
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_69
    end
  end
  L9_2 = nil
  ::lbl_69::
  L8_2.ownerCid = L9_2
  L9_2 = L0_1.xyz
  L10_2 = A0_2.coords
  L9_2 = L9_2(L10_2)
  L8_2.coords = L9_2
  L8_2.locked = L6_2
  L8_2.tier = 3
  L8_2.keyholders = L7_2
  return L8_2
end
L21_1 = L0_1.define
L22_1 = "housing"
L23_1 = "tk_housing"
L24_1 = {}
L24_1.label = "tk_housing"
L25_1 = {}
L26_1 = "tk_housing"
L25_1[1] = L26_1
L24_1.resources = L25_1
L24_1.verified = false
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L2_2 = L0_1.callExport
  L3_2 = "tk_housing"
  L4_2 = "getPropertiesByIdentifier"
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_20
    end
  end
  L4_2 = error
  L5_2 = "tk_housing:getPropertiesByIdentifier failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_20::
  L4_2 = {}
  L5_2 = {}
  L6_2 = pairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = L11_2.id
      if nil ~= L12_2 then
        L12_2 = tostring
        L13_2 = L11_2.id
        L12_2 = L12_2(L13_2)
        L12_2 = L5_2[L12_2]
        if not L12_2 then
          L12_2 = tostring
          L13_2 = L11_2.id
          L12_2 = L12_2(L13_2)
          L5_2[L12_2] = true
          L12_2 = #L4_2
          L12_2 = L12_2 + 1
          L13_2 = L20_1
          L14_2 = L11_2
          L15_2 = A1_2
          L16_2 = true
          L13_2 = L13_2(L14_2, L15_2, L16_2)
          L4_2[L12_2] = L13_2
        end
      end
    end
  end
  L6_2 = L0_1.callExport
  L7_2 = "tk_housing"
  L8_2 = "getProperties"
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = 0
      L9_2 = pairs
      L10_2 = L7_2
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
        L15_2 = type
        L16_2 = L14_2
        L15_2 = L15_2(L16_2)
        if "table" == L15_2 then
          L15_2 = L14_2.id
          if nil ~= L15_2 then
            L15_2 = L14_2.owner
            if nil ~= L15_2 then
              L15_2 = tostring
              L16_2 = L14_2.id
              L15_2 = L15_2(L16_2)
              L15_2 = L5_2[L15_2]
              if not L15_2 then
                L8_2 = L8_2 + 1
                L15_2 = L19_1
                if L8_2 > L15_2 then
                  break
                end
                L15_2 = L0_1.callExport
                L16_2 = "tk_housing"
                L17_2 = "getPropertyKeyholders"
                L18_2 = L14_2.id
                L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
                if L15_2 then
                  L17_2 = type
                  L18_2 = L16_2
                  L17_2 = L17_2(L18_2)
                  if "table" == L17_2 then
                    L17_2 = false
                    L18_2 = pairs
                    L19_2 = L16_2
                    L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
                    for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
                      L24_2 = L2_1
                      L25_2 = L23_2
                      L24_2 = L24_2(L25_2)
                      if L24_2 == A1_2 or L22_2 == A1_2 then
                        L17_2 = true
                        break
                      end
                    end
                    if L17_2 then
                      L18_2 = tostring
                      L19_2 = L14_2.id
                      L18_2 = L18_2(L19_2)
                      L5_2[L18_2] = true
                      L18_2 = #L4_2
                      L18_2 = L18_2 + 1
                      L19_2 = L20_1
                      L20_2 = L14_2
                      L21_2 = A1_2
                      L22_2 = false
                      L19_2 = L19_2(L20_2, L21_2, L22_2)
                      L4_2[L18_2] = L19_2
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return L4_2
end
L24_1.list = L25_1
function L25_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1.callExport
  L5_2 = "tk_housing"
  L6_2 = "setPropertyLocked"
  L7_2 = tonumber
  L8_2 = A2_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = A2_2
  end
  L8_2 = true == A3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L6_2 = L4_2 or L6_2
  L6_2 = L4_2 and false ~= L5_2
  return L6_2
end
L24_1.lock = L25_1
function L25_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2
  L5_2 = L0_1.callExport
  L6_2 = "tk_housing"
  L7_2 = "addPropertyKeyholder"
  L8_2 = tonumber
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = A2_2
  end
  L9_2 = A4_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L7_2 = L5_2 or L7_2
  L7_2 = L5_2 and false ~= L6_2
  return L7_2
end
L24_1.giveKey = L25_1
function L25_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1.callExport
  L5_2 = "tk_housing"
  L6_2 = "removePropertyKeyholder"
  L7_2 = tonumber
  L8_2 = A2_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = A2_2
  end
  L8_2 = A3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L6_2 = L4_2 or L6_2
  L6_2 = L4_2 and false ~= L5_2
  return L6_2
end
L24_1.removeKey = L25_1
L21_1(L22_1, L23_1, L24_1)
L21_1 = 600
function L22_1(A0_2)
  local L1_2, L2_2
  L1_2 = L0_1.decode
  L2_2 = A0_2.metadata
  return L1_2(L2_2)
end
function L23_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = L8_1
  L5_2 = A0_2.id
  L4_2 = L4_2(L5_2)
  L5_2 = L22_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L6_2 = L0_1.xyz
  L7_2 = L5_2.enter
  L6_2 = L6_2(L7_2)
  L7_2 = A0_2.object_id
  if nil ~= L7_2 then
    L7_2 = tostring
    L8_2 = A0_2.object_id
    L7_2 = L7_2(L8_2)
    if "" ~= L7_2 then
      L7_2 = tostring
      L8_2 = A0_2.object_id
      L7_2 = L7_2(L8_2)
      L8_2 = A3_2[L7_2]
      if nil == L8_2 then
        L8_2 = L0_1.callExport
        L9_2 = "vms_housing"
        L10_2 = "GetProperty"
        L11_2 = A0_2.object_id
        L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
        if L8_2 then
          L10_2 = type
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          if "table" == L10_2 and L9_2 then
            goto lbl_39
            L10_2 = L9_2 or L10_2
          end
        end
        L10_2 = false
        ::lbl_39::
        A3_2[L7_2] = L10_2
      end
      L8_2 = A3_2[L7_2]
      if L8_2 then
        L9_2 = L0_1.xyz
        L10_2 = L22_1
        L11_2 = L8_2
        L10_2 = L10_2(L11_2)
        L10_2 = L10_2.enter
        L9_2 = L9_2(L10_2)
        L6_2 = L9_2 or L6_2
        if not L9_2 then
        end
      end
    end
  end
  L7_2 = nil
  if A2_2 then
    L8_2 = L0_1.decode
    L9_2 = A0_2.keys
    L8_2 = L8_2(L9_2)
    L9_2 = L6_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L9_2 = {}
      if L9_2 then
        goto lbl_71
        L7_2 = L9_2 or L7_2
      end
    end
    L9_2 = L4_1
    L10_2 = L8_2
    L11_2 = A1_2
    L9_2 = L9_2(L10_2, L11_2)
    L7_2 = L9_2
  end
  ::lbl_71::
  L8_2 = {}
  L8_2.id = L4_2
  L9_2 = A0_2.name
  if L9_2 then
    L9_2 = A0_2.name
    if "" ~= L9_2 then
      L9_2 = A0_2.name
      if L9_2 then
        goto lbl_89
      end
    end
  end
  L9_2 = A0_2.address
  if not L9_2 then
    L9_2 = "#"
    L10_2 = L4_2
    L9_2 = L9_2 .. L10_2
  end
  ::lbl_89::
  L8_2.label = L9_2
  L8_2.owner = A2_2
  L9_2 = A0_2.owner
  if L9_2 then
    L9_2 = tostring
    L10_2 = A0_2.owner
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_100
    end
  end
  L9_2 = nil
  ::lbl_100::
  L8_2.ownerCid = L9_2
  if not A2_2 then
    L9_2 = L8_1
    L10_2 = A0_2.owner_name
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_109
    end
  end
  L9_2 = nil
  ::lbl_109::
  L8_2.ownerName = L9_2
  L9_2 = L6_2 or L9_2
  if not L6_2 then
    L9_2 = L0_1.xyz
    L10_2 = L5_2.menu
    L9_2 = L9_2(L10_2)
  end
  L8_2.coords = L9_2
  L9_2 = L0_1.xyz
  L10_2 = L5_2.garage
  L9_2 = L9_2(L10_2)
  L8_2.garage = L9_2
  L9_2 = L9_1
  L10_2 = L5_2.locked
  L9_2 = L9_2(L10_2)
  L8_2.locked = L9_2
  L9_2 = A0_2.object_id
  if L9_2 then
    L9_2 = 1
    if L9_2 then
      goto lbl_131
    end
  end
  L9_2 = 3
  ::lbl_131::
  L8_2.tier = L9_2
  L8_2.keyholders = L7_2
  return L8_2
end
L24_1 = L0_1.define
L25_1 = "housing"
L26_1 = "vms_housing"
L27_1 = {}
L27_1.label = "vms_housing (list only)"
L28_1 = {}
L29_1 = "vms_housing"
L28_1[1] = L29_1
L27_1.resources = L28_1
L27_1.verified = false
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = L0_1.callExport
  L3_2 = "vms_housing"
  L4_2 = "GetPlayerProperties"
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_20
    end
  end
  L4_2 = error
  L5_2 = "vms_housing:GetPlayerProperties failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_20::
  L4_2 = L3_2.id
  if nil ~= L4_2 then
    L4_2 = {}
    L5_2 = L3_2
    L4_2[1] = L5_2
    L3_2 = L4_2
  end
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  L7_2 = pairs
  L8_2 = L3_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = L12_2.id
      if nil ~= L13_2 then
        L13_2 = tostring
        L14_2 = L12_2.id
        L13_2 = L13_2(L14_2)
        L13_2 = L5_2[L13_2]
        if not L13_2 then
          L13_2 = tostring
          L14_2 = L12_2.id
          L13_2 = L13_2(L14_2)
          L5_2[L13_2] = true
          L13_2 = #L4_2
          L13_2 = L13_2 + 1
          L14_2 = L23_1
          L15_2 = L12_2
          L16_2 = A1_2
          L17_2 = L12_2.owner
          L17_2 = nil ~= L17_2
          L18_2 = L6_2
          L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
          L4_2[L13_2] = L14_2
        end
      end
    end
  end
  L7_2 = L0_1.callExport
  L8_2 = "vms_housing"
  L9_2 = "GetAllProperties"
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  if L7_2 then
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = 0
      L10_2 = pairs
      L11_2 = L8_2
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = type
        L17_2 = L15_2
        L16_2 = L16_2(L17_2)
        if "table" == L16_2 then
          L16_2 = L15_2.id
          if nil ~= L16_2 then
            L16_2 = L15_2.owner
            if nil ~= L16_2 then
              L16_2 = tostring
              L17_2 = L15_2.owner
              L16_2 = L16_2(L17_2)
              if "" ~= L16_2 then
                L16_2 = tostring
                L17_2 = L15_2.id
                L16_2 = L16_2(L17_2)
                L16_2 = L5_2[L16_2]
                if not L16_2 then
                  L9_2 = L9_2 + 1
                  L16_2 = L21_1
                  if L9_2 > L16_2 then
                    break
                  end
                  L16_2 = L0_1.decode
                  L17_2 = L15_2.keys
                  L16_2 = L16_2(L17_2)
                  L17_2 = false
                  L18_2 = L6_1
                  L19_2 = L16_2
                  L18_2 = L18_2(L19_2)
                  if not L18_2 then
                    L18_2 = L16_2[A1_2]
                    L17_2 = nil ~= L18_2
                  else
                    L18_2 = #L16_2
                    if L18_2 > 0 and A0_2 then
                      L18_2 = L0_1.callExport
                      L19_2 = "vms_housing"
                      L20_2 = "HasKeys"
                      L21_2 = A0_2
                      L22_2 = A1_2
                      L23_2 = L15_2.id
                      L18_2, L19_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2)
                      L17_2 = L18_2 or L17_2
                      L17_2 = L18_2 and true == L19_2
                    end
                  end
                  if L17_2 then
                    L18_2 = tostring
                    L19_2 = L15_2.id
                    L18_2 = L18_2(L19_2)
                    L5_2[L18_2] = true
                    L18_2 = #L4_2
                    L18_2 = L18_2 + 1
                    L19_2 = L23_1
                    L20_2 = L15_2
                    L21_2 = A1_2
                    L22_2 = false
                    L23_2 = L6_2
                    L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
                    L4_2[L18_2] = L19_2
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return L4_2
end
L27_1.list = L28_1
L24_1(L25_1, L26_1, L27_1)
L24_1 = 600
function L25_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L4_2 = L8_1
  L5_2 = A0_2.id
  if not L5_2 then
    L5_2 = A0_2.propertyId
    if not L5_2 then
      L5_2 = A0_2.property_id
      if not L5_2 then
        L5_2 = type
        L6_2 = A1_2
        L5_2 = L5_2(L6_2)
        L5_2 = A1_2 or L5_2
        if "number" == L5_2 or not A1_2 then
          L5_2 = nil
        end
      end
    end
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = nil
  if A3_2 then
    L6_2 = L0_1.callExport
    L7_2 = "RxHousing"
    L8_2 = "GetPropertyKeyholders"
    L9_2 = tonumber
    L10_2 = L4_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = L4_2
    end
    L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      L8_2 = L6_1
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if L8_2 then
        L8_2 = L3_1
        L9_2 = L7_2
        L10_2 = A2_2
        L8_2 = L8_2(L9_2, L10_2)
        if L8_2 then
          goto lbl_59
          L5_2 = L8_2 or L5_2
        end
      end
    end
    L8_2 = L4_1
    L9_2 = L7_2 or L9_2
    if not L6_2 or not L7_2 then
      L9_2 = nil
    end
    L10_2 = A2_2
    L8_2 = L8_2(L9_2, L10_2)
    L5_2 = L8_2
  end
  ::lbl_59::
  L6_2 = {}
  L6_2.id = L4_2
  L7_2 = A0_2.label
  if not L7_2 then
    L7_2 = A0_2.name
    if not L7_2 then
      L7_2 = A0_2.address
      if not L7_2 then
        L7_2 = "#"
        L8_2 = L4_2
        L7_2 = L7_2 .. L8_2
      end
    end
  end
  L6_2.label = L7_2
  L6_2.owner = A3_2
  L7_2 = A0_2.owner
  if L7_2 then
    L7_2 = tostring
    L8_2 = A0_2.owner
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_85
    end
  end
  L7_2 = nil
  ::lbl_85::
  L6_2.ownerCid = L7_2
  L7_2 = L7_1
  L8_2 = A0_2
  L9_2 = {}
  L10_2 = "entrance"
  L11_2 = "enter"
  L12_2 = "coords"
  L13_2 = "door"
  L14_2 = "entry"
  L15_2 = "position"
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.coords = L7_2
  L7_2 = L7_1
  L8_2 = A0_2
  L9_2 = {}
  L10_2 = "garage"
  L11_2 = "garageCoords"
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.garage = L7_2
  L7_2 = L9_1
  L8_2 = A0_2.locked
  L7_2 = L7_2(L8_2)
  L6_2.locked = L7_2
  L6_2.lockable = false
  L6_2.tier = 3
  L6_2.keyholders = L5_2
  return L6_2
end
L26_1 = L0_1.define
L27_1 = "housing"
L28_1 = "RxHousing"
L29_1 = {}
L29_1.label = "RxHousing"
L30_1 = {}
L31_1 = "RxHousing"
L30_1[1] = L31_1
L29_1.resources = L30_1
L29_1.verified = false
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = L0_1.callExport
  L3_2 = "RxHousing"
  L4_2 = "GetOwnedProperties"
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_20
    end
  end
  L4_2 = error
  L5_2 = "RxHousing:GetOwnedProperties failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_20::
  L4_2 = {}
  L5_2 = {}
  L6_2 = pairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = L25_1
      L13_2 = L11_2
      L14_2 = L10_2
      L15_2 = A1_2
      L16_2 = true
      L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
      if L12_2 then
        goto lbl_42
      end
    end
    L12_2 = nil
    ::lbl_42::
    if L12_2 then
      L13_2 = L12_2.id
      L13_2 = L5_2[L13_2]
      if not L13_2 then
        L13_2 = L12_2.id
        L5_2[L13_2] = true
        L13_2 = #L4_2
        L13_2 = L13_2 + 1
        L4_2[L13_2] = L12_2
      end
    end
  end
  L6_2 = L0_1.callExport
  L7_2 = "RxHousing"
  L8_2 = "GetAllProperties"
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = 0
      L9_2 = pairs
      L10_2 = L7_2
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
        L15_2 = type
        L16_2 = L14_2
        L15_2 = L15_2(L16_2)
        if "table" == L15_2 then
          L15_2 = L14_2.owner
          if nil ~= L15_2 then
            L15_2 = L8_1
            L16_2 = L14_2.id
            if not L16_2 then
              L16_2 = L14_2.propertyId
              if not L16_2 then
                L16_2 = L14_2.property_id
                if not L16_2 then
                  L16_2 = type
                  L17_2 = L13_2
                  L16_2 = L16_2(L17_2)
                  L16_2 = L13_2 or L16_2
                  if "number" == L16_2 or not L13_2 then
                    L16_2 = nil
                  end
                end
              end
            end
            L15_2 = L15_2(L16_2)
            if L15_2 then
              L16_2 = L5_2[L15_2]
              if not L16_2 then
                L16_2 = tostring
                L17_2 = L14_2.owner
                L16_2 = L16_2(L17_2)
                if L16_2 ~= A1_2 then
                  L8_2 = L8_2 + 1
                  L16_2 = L24_1
                  if L8_2 > L16_2 then
                    break
                  end
                  L16_2 = L0_1.callExport
                  L17_2 = "RxHousing"
                  L18_2 = "HasKey"
                  L19_2 = tonumber
                  L20_2 = L15_2
                  L19_2 = L19_2(L20_2)
                  if not L19_2 then
                    L19_2 = L15_2
                  end
                  L20_2 = A1_2
                  L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
                  if L16_2 and true == L17_2 then
                    L18_2 = L25_1
                    L19_2 = L14_2
                    L20_2 = L13_2
                    L21_2 = A1_2
                    L22_2 = false
                    L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
                    if L18_2 then
                      L5_2[L15_2] = true
                      L19_2 = #L4_2
                      L19_2 = L19_2 + 1
                      L4_2[L19_2] = L18_2
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return L4_2
end
L29_1.list = L30_1
function L30_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2
  L5_2 = L0_1.callExport
  L6_2 = "RxHousing"
  L7_2 = "AddKeyholder"
  L8_2 = tonumber
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = A2_2
  end
  L9_2 = A4_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L7_2 = L5_2 or L7_2
  L7_2 = L5_2 and false ~= L6_2
  return L7_2
end
L29_1.giveKey = L30_1
function L30_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1.callExport
  L5_2 = "RxHousing"
  L6_2 = "RemoveKeyholder"
  L7_2 = tonumber
  L8_2 = A2_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = A2_2
  end
  L8_2 = A3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L6_2 = L4_2 or L6_2
  L6_2 = L4_2 and false ~= L5_2
  return L6_2
end
L29_1.removeKey = L30_1
L26_1(L27_1, L28_1, L29_1)
L26_1 = L0_1.define
L27_1 = "housing"
L28_1 = "origen_housing"
L29_1 = {}
L29_1.label = "origen_housing (list only)"
L30_1 = {}
L31_1 = "origen_housing"
L30_1[1] = L31_1
L29_1.resources = L30_1
L29_1.verified = false
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = L0_1.callExport
  L3_2 = "origen_housing"
  L4_2 = "getOwnedHouses"
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_20
    end
  end
  L4_2 = error
  L5_2 = "origen_housing:getOwnedHouses failed: "
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  ::lbl_20::
  L4_2 = {}
  L5_2 = pairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L8_1
      L12_2 = L10_2.id
      if not L12_2 then
        L12_2 = L10_2.houseID
        if not L12_2 then
          L12_2 = L10_2.houseId
          if not L12_2 then
            L12_2 = type
            L13_2 = L9_2
            L12_2 = L12_2(L13_2)
            L12_2 = L9_2 or L12_2
            if "number" == L12_2 or not L9_2 then
              L12_2 = nil
            end
          end
        end
      end
      L11_2 = L11_2(L12_2)
      if L11_2 then
        L12_2 = #L4_2
        L12_2 = L12_2 + 1
        L13_2 = {}
        L13_2.id = L11_2
        L14_2 = L10_2.label
        if not L14_2 then
          L14_2 = L10_2.name
          if not L14_2 then
            L14_2 = L10_2.address
            if not L14_2 then
              L14_2 = "#"
              L15_2 = L11_2
              L14_2 = L14_2 .. L15_2
            end
          end
        end
        L13_2.label = L14_2
        L13_2.owner = true
        L14_2 = L7_1
        L15_2 = L10_2
        L16_2 = {}
        L17_2 = "entrance"
        L18_2 = "enter"
        L19_2 = "coords"
        L20_2 = "door"
        L21_2 = "entry"
        L22_2 = "position"
        L16_2[1] = L17_2
        L16_2[2] = L18_2
        L16_2[3] = L19_2
        L16_2[4] = L20_2
        L16_2[5] = L21_2
        L16_2[6] = L22_2
        L14_2 = L14_2(L15_2, L16_2)
        L13_2.coords = L14_2
        L14_2 = L7_1
        L15_2 = L10_2
        L16_2 = {}
        L17_2 = "garage"
        L18_2 = "garageCoords"
        L16_2[1] = L17_2
        L16_2[2] = L18_2
        L14_2 = L14_2(L15_2, L16_2)
        L13_2.garage = L14_2
        L14_2 = L9_1
        L15_2 = L10_2.locked
        L14_2 = L14_2(L15_2)
        L13_2.locked = L14_2
        L13_2.lockable = false
        L13_2.keys = false
        L13_2.tier = 3
        L14_2 = {}
        L13_2.keyholders = L14_2
        L4_2[L12_2] = L13_2
      end
    end
  end
  return L4_2
end
L29_1.list = L30_1
L26_1(L27_1, L28_1, L29_1)
L26_1 = ipairs
L27_1 = {}
L28_1 = "ak47_qb_housing"
L29_1 = "ak47_housing"
L27_1[1] = L28_1
L27_1[2] = L29_1
L26_1, L27_1, L28_1, L29_1 = L26_1(L27_1)
for L30_1, L31_1 in L26_1, L27_1, L28_1, L29_1 do
  L32_1 = L0_1.define
  L33_1 = "housing"
  L34_1 = L31_1
  L35_1 = {}
  L36_1 = L31_1
  L37_1 = " (list only)"
  L36_1 = L36_1 .. L37_1
  L35_1.label = L36_1
  L36_1 = {}
  L37_1 = L31_1
  L36_1[1] = L37_1
  L35_1.resources = L36_1
  L35_1.verified = false
  function L36_1(A0_2, A1_2)
    local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
    L2_2 = {}
    L3_2 = ipairs
    L4_2 = L1_1
    L5_2 = "SELECT id, enter FROM `%s` WHERE owner = ?"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = L31_1
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = {}
    L7_2 = A1_2
    L6_2[1] = L7_2
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2, L6_2)
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = #L2_2
      L9_2 = L9_2 + 1
      L10_2 = {}
      L11_2 = tostring
      L12_2 = L8_2.id
      L11_2 = L11_2(L12_2)
      L10_2.id = L11_2
      L11_2 = "Casa "
      L12_2 = tostring
      L13_2 = L8_2.id
      L12_2 = L12_2(L13_2)
      L11_2 = L11_2 .. L12_2
      L10_2.label = L11_2
      L10_2.owner = true
      L11_2 = L0_1.xyz
      L12_2 = L8_2.enter
      L11_2 = L11_2(L12_2)
      L10_2.coords = L11_2
      L10_2.tier = 3
      L10_2.lockable = false
      L10_2.keys = false
      L11_2 = {}
      L10_2.keyholders = L11_2
      L2_2[L9_2] = L10_2
    end
    return L2_2
  end
  L35_1.list = L36_1
  L32_1(L33_1, L34_1, L35_1)
end
L26_1 = L0_1.define
L27_1 = "housing"
L28_1 = "loaf_housing"
L29_1 = {}
L29_1.label = "loaf_housing (list only)"
L30_1 = {}
L31_1 = "loaf_housing"
L30_1[1] = L31_1
L29_1.resources = L30_1
L29_1.verified = false
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT p.propertyid, h.label, h.entrance, h.garage_entrance FROM loaf_properties p LEFT JOIN loaf_houses h ON h.id = p.propertyid WHERE p.owner = ?"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = tostring
    L12_2 = L8_2.propertyid
    L11_2 = L11_2(L12_2)
    L10_2.id = L11_2
    L11_2 = L8_2.label
    if not L11_2 then
      L11_2 = "#"
      L12_2 = tostring
      L13_2 = L8_2.propertyid
      L12_2 = L12_2(L13_2)
      L11_2 = L11_2 .. L12_2
    end
    L10_2.label = L11_2
    L10_2.owner = true
    L11_2 = L0_1.xyz
    L12_2 = L8_2.entrance
    L11_2 = L11_2(L12_2)
    L10_2.coords = L11_2
    L11_2 = L0_1.xyz
    L12_2 = L8_2.garage_entrance
    L11_2 = L11_2(L12_2)
    L10_2.garage = L11_2
    L10_2.tier = 3
    L10_2.lockable = false
    L10_2.keys = false
    L11_2 = {}
    L10_2.keyholders = L11_2
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L29_1.list = L30_1
L26_1(L27_1, L28_1, L29_1)
L26_1 = L0_1.order
L27_1 = {}
L28_1 = "ps-housing"
L29_1 = "kartik-properties"
L30_1 = "tk_housing"
L31_1 = "nolag_properties"
L32_1 = "bcs_housing"
L33_1 = "vms_housing"
L34_1 = "qs-housing"
L35_1 = "RxHousing"
L36_1 = "origen_housing"
L37_1 = "ak47_qb_housing"
L38_1 = "ak47_housing"
L39_1 = "loaf_housing"
L40_1 = "qbx_properties"
L41_1 = "qb-houses"
L42_1 = "esx_property"
L27_1[1] = L28_1
L27_1[2] = L29_1
L27_1[3] = L30_1
L27_1[4] = L31_1
L27_1[5] = L32_1
L27_1[6] = L33_1
L27_1[7] = L34_1
L27_1[8] = L35_1
L27_1[9] = L36_1
L27_1[10] = L37_1
L27_1[11] = L38_1
L27_1[12] = L39_1
L27_1[13] = L40_1
L27_1[14] = L41_1
L27_1[15] = L42_1
L26_1.housing = L27_1
L26_1 = "apt:"
L27_1 = {}
L28_1 = {}
L28_1.id = "qb-apartments"
L28_1.res = "qb-apartments"
function L29_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L12_1
  L2_2 = "qb-apartments"
  L3_2 = "config.lua"
  L4_2 = "Apartments.Locations"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = type
    L3_2 = L1_2[A0_2]
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = L1_2[A0_2]
      if L2_2 then
        goto lbl_20
      end
    end
  end
  L2_2 = nil
  ::lbl_20::
  if L2_2 then
    L3_2 = type
    L4_2 = L2_2.coords
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L0_1.xyz
      L4_2 = L2_2.coords
      L4_2 = L4_2.enter
      L3_2 = L3_2(L4_2)
      if L3_2 then
        goto lbl_34
      end
    end
  end
  L3_2 = nil
  ::lbl_34::
  return L3_2
end
L28_1.door = L29_1
L29_1 = {}
L29_1.id = "qbx_apartments"
L29_1.res = "qbx_apartments"
function L30_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L12_1
  L2_2 = "qbx_apartments"
  L3_2 = "config/shared.lua"
  L4_2 = "locations"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = type
    L3_2 = L1_2[A0_2]
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = L1_2[A0_2]
      if L2_2 then
        goto lbl_20
      end
    end
  end
  L2_2 = nil
  ::lbl_20::
  if L2_2 then
    L3_2 = L0_1.xyz
    L4_2 = L2_2.enter
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_28
    end
  end
  L3_2 = nil
  ::lbl_28::
  return L3_2
end
L29_1.door = L30_1
L27_1[1] = L28_1
L27_1[2] = L29_1
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
L0_1.isExtraHouse = L28_1
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = type
  L3_2 = Config
  L2_2 = L2_2(L3_2)
  L2_2 = type
  L3_2 = Config
  L3_2 = L3_2.Integrations
  L2_2 = L2_2(L3_2)
  L2_2 = Config
  L2_2 = L2_2.Integrations
  L2_2 = "table" == L2_2 and L2_2
  if false == L2_2 or "off" == L2_2 or "none" == L2_2 or nil == A1_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L27_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    if nil ~= L2_2 and "auto" ~= L2_2 and true ~= L2_2 then
      L10_2 = L9_2.id
      if L2_2 ~= L10_2 then
        goto lbl_67
      end
    end
    L10_2 = L0_1.started
    L11_2 = L9_2.res
    L10_2 = L10_2(L11_2)
    if L10_2 then
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
        L0_3 = ipairs
        L1_3 = L1_1
        L2_3 = "SELECT name, type, label FROM apartments WHERE citizenid = ?"
        L3_3 = {}
        L4_3 = A1_2
        L3_3[1] = L4_3
        L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3 = L1_3(L2_3, L3_3)
        L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
        for L4_3, L5_3 in L0_3, L1_3, L2_3, L3_3 do
          L6_3 = L5_3.name
          if L6_3 then
            L6_3 = L3_2
            L6_3 = #L6_3
            L7_3 = L6_3 + 1
            L6_3 = L3_2
            L8_3 = {}
            L9_3 = L26_1
            L10_3 = tostring
            L11_3 = L5_3.name
            L10_3 = L10_3(L11_3)
            L9_3 = L9_3 .. L10_3
            L8_3.id = L9_3
            L9_3 = L5_3.label
            if not L9_3 then
              L9_3 = tostring
              L10_3 = L5_3.name
              L9_3 = L9_3(L10_3)
            end
            L8_3.label = L9_3
            L8_3.owner = true
            L9_3 = L9_2.door
            L10_3 = L5_3.type
            L9_3 = L9_3(L10_3)
            L8_3.coords = L9_3
            L8_3.tier = 1
            L8_3.lockable = false
            L8_3.keys = false
            L9_3 = {}
            L8_3.keyholders = L9_3
            L6_3[L7_3] = L8_3
          end
        end
      end
      L10_2, L11_2 = L10_2(L11_2)
      if not L10_2 then
        L12_2 = L0_1.warnOnce
        L13_2 = "apt_"
        L14_2 = L9_2.id
        L13_2 = L13_2 .. L14_2
        L14_2 = "apartments add-on %s failed (%s): apartments are not shown"
        L15_2 = L14_2
        L14_2 = L14_2.format
        L16_2 = L9_2.id
        L17_2 = tostring
        L18_2 = L11_2
        L17_2, L18_2 = L17_2(L18_2)
        L14_2, L15_2, L16_2, L17_2, L18_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
        L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
      end
      break
    end
    ::lbl_67::
  end
  return L3_2
end
L0_1.housingExtras = L28_1
