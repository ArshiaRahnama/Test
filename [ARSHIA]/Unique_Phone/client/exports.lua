local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1
L0_1 = {}
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 or "number" == L2_2 or "boolean" == L2_2 then
    return A0_2
  end
  if "table" ~= L2_2 or A1_2 > 6 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = getmetatable
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.__call
    if L4_2 then
      goto lbl_31
    end
  end
  L4_2 = rawget
  L5_2 = A0_2
  L6_2 = "__cfx_functionReference"
  L4_2 = L4_2(L5_2, L6_2)
  ::lbl_31::
  if nil ~= L4_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = {}
  L5_2 = pairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    if "string" == L11_2 or "number" == L11_2 then
      L12_2 = L1_1
      L13_2 = L10_2
      L14_2 = A1_2 + 1
      L12_2 = L12_2(L13_2, L14_2)
      if nil ~= L12_2 then
        L4_2[L9_2] = L12_2
      end
    end
  end
  return L4_2
end
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 and "number" ~= L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  if "" == A0_2 then
    L3_2 = nil
    return L3_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.sub
  L5_2 = 1
  L6_2 = A1_2
  return L3_2(L4_2, L5_2, L6_2)
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 and "number" ~= L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = #L2_2
  if 0 ~= L3_2 then
    L3_2 = #L2_2
    if not (L3_2 > 64) then
      L4_2 = L2_2
      L3_2 = L2_2.find
      L5_2 = "[^%w_%.%:%-]"
      L3_2 = L3_2(L4_2, L5_2)
      if not L3_2 then
        goto lbl_26
      end
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_26::
  return L2_2
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = RegisteredApps
  L2_2[L1_2] = nil
  L2_2 = L0_1
  L2_2[L1_2] = nil
  L2_2 = Push
  L3_2 = "unregisterApp"
  L4_2 = {}
  L4_2.id = L1_2
  L2_2(L3_2, L4_2)
  L2_2 = true
  return L2_2
end
L5_1 = exports
L6_1 = "RegisterApp"
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.id
    if L1_2 then
      L1_2 = A0_2.url
      if L1_2 then
        goto lbl_14
      end
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_14::
  L1_2 = L1_1
  L2_2 = A0_2
  L3_2 = 0
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L3_1
  L3_2 = L1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 RegisterApp: id \"%s\" is invalid - only letters, numbers, _ - . : (up to 64). App NOT registered."
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = tostring
    L7_2 = L1_2.id
    L6_2 = L6_2(L7_2)
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = 60
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
    L3_2 = false
    return L3_2
  end
  L3_2 = type
  L4_2 = L1_2.url
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    L3_2 = false
    return L3_2
  end
  L1_2.id = L2_2
  L3_2 = RegisteredApps
  L3_2[L2_2] = L1_2
  L3_2 = L0_1
  L4_2 = GetInvokingResource
  L4_2 = L4_2()
  if not L4_2 then
    L4_2 = GetCurrentResourceName
    L4_2 = L4_2()
  end
  L3_2[L2_2] = L4_2
  L3_2 = Push
  L4_2 = "registerApp"
  L5_2 = L1_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "UnregisterApp"
L7_1 = L4_1
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "RemoveApp"
L7_1 = L4_1
L5_1(L6_1, L7_1)
L5_1 = AddEventHandler
L6_1 = "onResourceStop"
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    if L6_2 == A0_2 then
      L7_2 = L4_1
      L8_2 = L5_2
      L7_2(L8_2)
    end
  end
end
L5_1(L6_1, L7_1)
L5_1 = {}
L5_1.banner = true
L5_1.silent = true
L5_1.island = true
L5_1.lock = true
function L6_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = A0_2 or L4_2
  if "table" ~= L4_2 or not A0_2 then
    L4_2 = {}
    L4_2.app = A0_2
    L4_2.title = A1_2
    L4_2.msg = A2_2
    L4_2.data = A3_2
  end
  L5_2 = {}
  L6_2 = L2_1
  L7_2 = L4_2.app
  L8_2 = 32
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = "settings"
  end
  L5_2.app = L6_2
  L6_2 = L2_1
  L7_2 = L4_2.title
  L8_2 = 80
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = ""
  end
  L5_2.title = L6_2
  L6_2 = L2_1
  L7_2 = L4_2.msg
  if not L7_2 then
    L7_2 = L4_2.description
  end
  L8_2 = 255
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = ""
  end
  L5_2.msg = L6_2
  L6_2 = L2_1
  L7_2 = L4_2.description
  L8_2 = 255
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.description = L6_2
  L6_2 = L2_1
  L7_2 = L4_2.icon
  L8_2 = 512
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.icon = L6_2
  L6_2 = L2_1
  L7_2 = L4_2.image
  L8_2 = 512
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.image = L6_2
  L7_2 = L4_2.type
  L6_2 = L5_1
  L6_2 = L6_2[L7_2]
  if L6_2 then
    L6_2 = L4_2.type
    if L6_2 then
      goto lbl_67
    end
  end
  L6_2 = nil
  ::lbl_67::
  L5_2.type = L6_2
  L6_2 = L1_1
  L7_2 = L4_2.data
  L8_2 = 0
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.data = L6_2
  L6_2 = tonumber
  L7_2 = L4_2.duration
  L6_2 = L6_2(L7_2)
  if L6_2 and L6_2 > 0 then
    L7_2 = math
    L7_2 = L7_2.min
    L8_2 = L6_2
    L9_2 = 120000
    L7_2 = L7_2(L8_2, L9_2)
    L5_2.duration = L7_2
  end
  L7_2 = type
  L8_2 = L4_2.actions
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = {}
    L8_2 = ipairs
    L9_2 = L4_2.actions
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = type
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      L14_2 = L2_1
      L15_2 = L13_2.id
      L16_2 = 32
      L14_2 = "table" == L14_2 and L14_2
      L15_2 = type
      L16_2 = L13_2
      L15_2 = L15_2(L16_2)
      L15_2 = L2_1
      L16_2 = L13_2.label
      L17_2 = 40
      L15_2 = "table" == L15_2 and L15_2
      if L14_2 and L15_2 then
        L16_2 = #L7_2
        if L16_2 < 4 then
          L16_2 = #L7_2
          L16_2 = L16_2 + 1
          L17_2 = {}
          L17_2.id = L14_2
          L17_2.label = L15_2
          L7_2[L16_2] = L17_2
        end
      end
    end
    L8_2 = #L7_2
    if L8_2 > 0 then
      L5_2.actions = L7_2
    end
  end
  return L5_2
end
L7_1 = exports
L8_1 = "SendNotification"
function L9_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = Push
  L5_2 = "notification"
  L6_2 = L6_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L10_2 = A3_2
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L7_1(L8_1, L9_1)
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = PhoneOpen
  L2_2 = PhoneOpen
  if not L2_2 then
    L2_2 = OpenPhone
    L2_2 = L2_2()
    if not L2_2 then
      L2_2 = false
      return L2_2
    end
  end
  L2_2 = SetTimeout
  if L1_2 then
    L3_2 = 0
    if L3_2 then
      goto lbl_18
    end
  end
  L3_2 = 350
  ::lbl_18::
  function L4_2()
    local L0_3, L1_3
    L0_3 = PhoneOpen
    if L0_3 then
      L0_3 = A0_2
      L0_3()
    end
  end
  L2_2(L3_2, L4_2)
  L2_2 = true
  return L2_2
end
L8_1 = exports
L9_1 = "OpenApp"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L1_2 = tostring
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    A0_2 = L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = false
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.sub
  L3_2 = 1
  L4_2 = 64
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  L1_2 = L7_1
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = Push
    L1_3 = "openApp"
    L2_3 = {}
    L3_3 = A0_2
    L2_3.id = L3_3
    L0_3(L1_3, L2_3)
  end
  return L1_2(L2_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "StartCall"
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      L2_2 = false
      return L2_2
    end
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "[^%d%+%-%s#%*]"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = 24
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  A0_2 = L2_2
  L3_2 = A0_2
  L2_2 = A0_2.find
  L4_2 = "%d"
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L7_1
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = Push
    L1_3 = "startCall"
    L2_3 = {}
    L3_3 = A0_2
    L2_3.number = L3_3
    L3_3 = A1_2
    L3_3 = true == L3_3
    L2_3.video = L3_3
    L0_3(L1_3, L2_3)
  end
  return L2_2(L3_2)
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "apex_phone:client:openApp"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    return
  end
  L2_2 = A0_2
  L1_2 = A0_2.sub
  L3_2 = 1
  L4_2 = 64
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  L1_2 = L7_1
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = Push
    L1_3 = "openApp"
    L2_3 = {}
    L3_3 = A0_2
    L2_3.id = L3_3
    L0_3(L1_3, L2_3)
  end
  L1_2(L2_2)
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "apex_phone:client:close"
function L10_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  if L0_2 then
    L0_2 = ClosePhone
    L0_2()
  end
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "OpenPhone"
function L10_1()
  local L0_2, L1_2
  L0_2 = OpenPhone
  L0_2 = L0_2()
  L0_2 = true == L0_2
  return L0_2
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "ClosePhone"
function L10_1()
  local L0_2, L1_2
  L0_2 = ClosePhone
  L0_2()
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "IsPhoneOpen"
function L10_1()
  local L0_2, L1_2
  L0_2 = PhoneOpen
  return L0_2
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "GetPhoneNumber"
function L10_1()
  local L0_2, L1_2
  L0_2 = FW
  L0_2 = L0_2.GetPlayerData
  L0_2 = L0_2()
  L0_2 = L0_2.phone
  return L0_2
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "IsFlashlightOn"
function L10_1()
  local L0_2, L1_2
  L0_2 = IsFlashlightOn
  return L0_2()
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "SetFlashlight"
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = SetFlashlight
  L2_2 = A0_2
  return L1_2(L2_2)
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "GetFramework"
function L10_1()
  local L0_2, L1_2
  L0_2 = FW
  L0_2 = L0_2.name
  return L0_2
end
L8_1(L9_1, L10_1)
L8_1 = exports
L9_1 = "SetWaypoint"
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  A1_2 = L4_2
  A0_2 = L3_2
  if not A0_2 or not A1_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = SetNewWaypoint
  L4_2 = A0_2 + 0.0
  L5_2 = A1_2 + 0.0
  L3_2(L4_2, L5_2)
  L3_2 = Push
  L4_2 = "notification"
  L5_2 = {}
  L5_2.app = "maps"
  L5_2.title = "Dire\195\167\195\181es"
  L6_2 = L2_1
  L7_2 = A2_2
  L8_2 = 80
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = "Waypoint marcado"
  end
  L5_2.msg = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L8_1(L9_1, L10_1)
L8_1 = RegisterNetEvent
L9_1 = "apex_phone:client:notification"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    return
  end
  L1_2 = Push
  L2_2 = "notification"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
L8_1(L9_1, L10_1)
L8_1 = {}
L9_1 = {}
L10_1 = {}
L11_1 = {}
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if A0_2 == A1_2 then
    L3_2 = true
    return L3_2
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = type
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = A2_2 or L3_2
      if not A2_2 then
        L3_2 = 0
      end
      if not (L3_2 > 8) then
        goto lbl_22
      end
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_22::
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L12_1
    L10_2 = L8_2
    L11_2 = A1_2[L7_2]
    L12_2 = A2_2 or L12_2
    if not A2_2 then
      L12_2 = 0
    end
    L12_2 = L12_2 + 1
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if not L9_2 then
      L9_2 = false
      return L9_2
    end
  end
  L3_2 = pairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = A0_2[L7_2]
    if nil == L8_2 then
      L8_2 = false
      return L8_2
    end
  end
  L3_2 = true
  return L3_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 and "number" ~= L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "[^%w_%.%-]"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if "" == L3_2 then
    L4_2 = nil
    return L4_2
  end
  L5_2 = L3_2
  L4_2 = L3_2.sub
  L6_2 = 1
  L7_2 = A1_2
  return L4_2(L5_2, L6_2, L7_2)
end
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L13_1
  L3_2 = A0_2
  L4_2 = 34
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L13_1
  L4_2 = A1_2
  L5_2 = 28
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = "res"
  end
  L4_2 = ":"
  L5_2 = L2_2
  L3_2 = L3_2 .. L4_2 .. L5_2
  return L3_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = L2_1
  L3_2 = A0_2.app
  L4_2 = 64
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.app = L2_2
  L2_2 = L2_1
  L3_2 = A0_2.title
  L4_2 = 60
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.title = L2_2
  L2_2 = L2_1
  L3_2 = A0_2.subtitle
  L4_2 = 90
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.subtitle = L2_2
  L2_2 = L2_1
  L3_2 = A0_2.state
  L4_2 = 24
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.state = L2_2
  L2_2 = L2_1
  L3_2 = A0_2.icon
  L4_2 = 2048
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.icon = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.progress
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = math
    L3_2 = L3_2.max
    L4_2 = 0.0
    L5_2 = math
    L5_2 = L5_2.min
    L6_2 = 1.0
    L7_2 = L2_2 + 0.0
    L5_2 = L5_2(L6_2, L7_2)
    L3_2 = L3_2(L4_2, L5_2)
    L1_2.progress = L3_2
  end
  L3_2 = tonumber
  L4_2 = A0_2.eta
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = math
    L4_2 = L4_2.max
    L5_2 = 0
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
    L1_2.eta = L4_2
  else
    L4_2 = L2_1
    L5_2 = A0_2.eta
    L6_2 = 24
    L4_2 = L4_2(L5_2, L6_2)
    L1_2.eta = L4_2
  end
  return L1_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2
  if A0_2 then
    L1_2 = L8_1
    L1_2 = L1_2[A0_2]
    if L1_2 then
      goto lbl_9
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_9::
  L1_2 = L8_1
  L1_2[A0_2] = nil
  L1_2 = L11_1
  L1_2[A0_2] = nil
  L1_2 = Push
  L2_2 = "activity"
  L3_2 = {}
  L3_2.op = "stop"
  L3_2.id = A0_2
  L1_2(L2_2, L3_2)
  L1_2 = true
  return L1_2
end
L17_1 = exports
L18_1 = "StartActivity"
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = GetInvokingResource
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = GetCurrentResourceName
    L2_2 = L2_2()
  end
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = L15_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L4_2.title
    if L5_2 then
      goto lbl_25
    end
  end
  L5_2 = false
  do return L5_2 end
  ::lbl_25::
  L5_2 = L8_1
  L5_2[L3_2] = L2_2
  L5_2 = L11_1
  L5_2[L3_2] = L4_2
  L5_2 = Push
  L6_2 = "activity"
  L7_2 = {}
  L7_2.op = "start"
  L7_2.id = L3_2
  L7_2.data = L4_2
  L5_2(L6_2, L7_2)
  return L3_2
end
L17_1(L18_1, L19_1)
L17_1 = exports
L18_1 = "UpdateActivity"
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = GetInvokingResource
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = GetCurrentResourceName
    L2_2 = L2_2()
  end
  L3_2 = L14_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L8_1
    L4_2 = L4_2[L3_2]
    if L4_2 == L2_2 then
      goto lbl_19
    end
  end
  L4_2 = false
  do return L4_2 end
  ::lbl_19::
  L4_2 = L15_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L12_1
  L6_2 = L4_2
  L7_2 = L11_1
  L7_2 = L7_2[L3_2]
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = L11_1
  L5_2[L3_2] = L4_2
  L5_2 = Push
  L6_2 = "activity"
  L7_2 = {}
  L7_2.op = "update"
  L7_2.id = L3_2
  L7_2.data = L4_2
  L5_2(L6_2, L7_2)
  L5_2 = true
  return L5_2
end
L17_1(L18_1, L19_1)
L17_1 = exports
L18_1 = "StopActivity"
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetInvokingResource
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = GetCurrentResourceName
    L1_2 = L1_2()
  end
  L2_2 = L14_1
  L3_2 = A0_2
  L4_2 = L1_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = L8_1
    L3_2 = L3_2[L2_2]
    if L3_2 == L1_2 then
      goto lbl_19
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_19::
  L3_2 = L16_1
  L4_2 = L2_2
  return L3_2(L4_2)
end
L17_1(L18_1, L19_1)
L17_1 = {}
L17_1["2x2"] = true
L17_1["4x2"] = true
L17_1["4x4"] = true
L18_1 = {}
L18_1.stat = true
L18_1.list = true
L18_1.progress = true
L18_1.text = true
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L13_1
  L2_2 = A0_2.id
  L3_2 = 32
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = {}
  L3_2 = type
  L4_2 = A0_2.sizes
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = ipairs
    L4_2 = A0_2.sizes
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L17_1
      L9_2 = L9_2[L8_2]
      if L9_2 then
        L9_2 = #L2_2
        if L9_2 < 3 then
          L9_2 = #L2_2
          L9_2 = L9_2 + 1
          L2_2[L9_2] = L8_2
        end
      end
    end
  end
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = {}
    L5_2 = A0_2.size
    L4_2 = L17_1
    L4_2 = L4_2[L5_2]
    if L4_2 then
      L4_2 = A0_2.size
      if L4_2 then
        goto lbl_55
      end
    end
    L4_2 = "2x2"
    ::lbl_55::
    L3_2[1] = L4_2
    L2_2 = L3_2
  end
  L3_2 = {}
  L3_2.op = "set"
  L3_2.id = L1_2
  L4_2 = L2_1
  L5_2 = A0_2.name
  L6_2 = 40
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = L1_2
  end
  L3_2.name = L4_2
  L4_2 = L2_1
  L5_2 = A0_2.app
  L6_2 = 64
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.app = L4_2
  L3_2.sizes = L2_2
  L5_2 = A0_2.template
  L4_2 = L18_1
  L4_2 = L4_2[L5_2]
  if L4_2 then
    L4_2 = A0_2.template
    if L4_2 then
      goto lbl_84
    end
  end
  L4_2 = nil
  ::lbl_84::
  L3_2.template = L4_2
  L4_2 = L1_1
  L5_2 = A0_2.data
  L6_2 = 0
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.data = L4_2
  return L3_2
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L13_1
  L2_2 = A0_2
  L3_2 = 32
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L9_1
    L2_2 = L2_2[L1_2]
    if L2_2 then
      goto lbl_13
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_13::
  L2_2 = L9_1
  L2_2[L1_2] = nil
  L2_2 = L10_1
  L2_2[L1_2] = nil
  L2_2 = Push
  L3_2 = "widget"
  L4_2 = {}
  L4_2.op = "remove"
  L4_2.id = L1_2
  L2_2(L3_2, L4_2)
  L2_2 = true
  return L2_2
end
L21_1 = exports
L22_1 = "RegisterWidget"
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = GetInvokingResource
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = GetCurrentResourceName
    L1_2 = L1_2()
  end
  L2_2 = L19_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L4_2 = L2_2.id
  L3_2 = L10_1
  L3_2 = L3_2[L4_2]
  if L3_2 then
    L4_2 = L2_2.id
    L3_2 = L10_1
    L3_2 = L3_2[L4_2]
    if L3_2 ~= L1_2 then
      L3_2 = print
      L4_2 = "^3[unique_phone]^0 RegisterWidget: widget \"%s\" already belongs to \"%s\" - not replaced."
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = L2_2.id
      L7_2 = tostring
      L9_2 = L2_2.id
      L8_2 = L10_1
      L8_2 = L8_2[L9_2]
      L7_2, L8_2, L9_2 = L7_2(L8_2)
      L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
      L3_2 = false
      return L3_2
    end
  end
  L4_2 = L2_2.id
  L3_2 = L9_1
  L3_2[L4_2] = L2_2
  L4_2 = L2_2.id
  L3_2 = L10_1
  L3_2[L4_2] = L1_2
  L3_2 = Push
  L4_2 = "widget"
  L5_2 = L2_2
  L3_2(L4_2, L5_2)
  L3_2 = L2_2.id
  return L3_2
end
L21_1(L22_1, L23_1)
L21_1 = exports
L22_1 = "UpdateWidget"
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetInvokingResource
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = GetCurrentResourceName
    L2_2 = L2_2()
  end
  L3_2 = L13_1
  L4_2 = A0_2
  L5_2 = 32
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L3_2 or L4_2
  if L3_2 then
    L4_2 = L9_1
    L4_2 = L4_2[L3_2]
  end
  if L4_2 then
    L5_2 = L10_1
    L5_2 = L5_2[L3_2]
    if L5_2 == L2_2 then
      goto lbl_23
    end
  end
  L5_2 = false
  do return L5_2 end
  ::lbl_23::
  L5_2 = L1_1
  L6_2 = A1_2
  L7_2 = 0
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L12_1
  L7_2 = L5_2
  L8_2 = L4_2.data
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L6_2 = true
    return L6_2
  end
  L4_2.data = L5_2
  L6_2 = Push
  L7_2 = "widget"
  L8_2 = L4_2
  L6_2(L7_2, L8_2)
  L6_2 = true
  return L6_2
end
L21_1(L22_1, L23_1)
L21_1 = exports
L22_1 = "UnregisterWidget"
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetInvokingResource
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = GetCurrentResourceName
    L1_2 = L1_2()
  end
  L2_2 = L13_1
  L3_2 = A0_2
  L4_2 = 32
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = L10_1
    L3_2 = L3_2[L2_2]
    if L3_2 == L1_2 then
      goto lbl_19
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_19::
  L3_2 = L20_1
  L4_2 = L2_2
  return L3_2(L4_2)
end
L21_1(L22_1, L23_1)
L21_1 = RegisterNUICallback
L22_1 = "widgetsRegistry"
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = {}
  L3_2 = pairs
  L4_2 = L9_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L2_2[L9_2] = L8_2
  end
  L3_2 = A1_2
  L4_2 = L2_2
  L3_2(L4_2)
end
L21_1(L22_1, L23_1)
L21_1 = AddEventHandler
L22_1 = "onResourceStop"
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L8_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    if L6_2 == A0_2 then
      L7_2 = L16_1
      L8_2 = L5_2
      L7_2(L8_2)
    end
  end
  L1_2 = pairs
  L2_2 = L10_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    if L6_2 == A0_2 then
      L7_2 = L20_1
      L8_2 = L5_2
      L7_2(L8_2)
    end
  end
end
L21_1(L22_1, L23_1)
