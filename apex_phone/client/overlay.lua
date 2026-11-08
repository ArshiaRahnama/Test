local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1
L0_1 = {}
L1_1 = false
function L2_1()
  local L0_2, L1_2
  L0_2 = next
  L1_2 = L0_1
  L0_2 = L0_2(L1_2)
  L0_2 = nil ~= L0_2
  return L0_2
end
function L3_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = pairs
  L1_2 = L0_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = L5_2.keep
      if L6_2 then
        L6_2 = true
        return L6_2
      end
    end
  end
  L0_2 = false
  return L0_2
end
function L4_1(A0_2)
  local L1_2
  if A0_2 then
    L1_2 = L0_1
    L1_2 = L1_2[A0_2]
    L1_2 = nil ~= L1_2
    return L1_2
  end
  L1_2 = L2_1
  return L1_2()
end
OverlayIsOpen = L4_1
L4_1 = 249
function L5_1()
  local L0_2, L1_2
  L0_2 = L1_1
  if L0_2 then
    return
  end
  L0_2 = true
  L1_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    while true do
      L0_3 = L2_1
      L0_3 = L0_3()
      if not L0_3 then
        break
      end
      L0_3 = L3_1
      L0_3 = L0_3()
      if L0_3 then
        L0_3 = DisableAllControlActions
        L1_3 = 0
        L0_3(L1_3)
        L0_3 = EnableControlAction
        L1_3 = 0
        L2_3 = L4_1
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisablePlayerFiring
        L1_3 = PlayerId
        L1_3 = L1_3()
        L2_3 = true
        L0_3(L1_3, L2_3)
      else
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 200
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 199
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 1
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 2
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 24
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 25
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 142
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
        L0_3 = DisableControlAction
        L1_3 = 0
        L2_3 = 106
        L3_3 = true
        L0_3(L1_3, L2_3, L3_3)
      end
      L0_3 = Wait
      L1_3 = 0
      L0_3(L1_3)
    end
    L0_3 = GetGameTimer
    L0_3 = L0_3()
    L0_3 = L0_3 + 450
    while true do
      L1_3 = L2_1
      L1_3 = L1_3()
      if L1_3 then
        break
      end
      L1_3 = GetGameTimer
      L1_3 = L1_3()
      if not (L0_3 > L1_3) then
        break
      end
      L1_3 = DisableControlAction
      L2_3 = 0
      L3_3 = 200
      L4_3 = true
      L1_3(L2_3, L3_3, L4_3)
      L1_3 = Wait
      L2_3 = 0
      L1_3(L2_3)
    end
    L1_3 = false
    L1_1 = L1_3
  end
  L0_2(L1_2)
end
function L6_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "string" ~= L4_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = PhoneOpen
  if L4_2 then
    L4_2 = ClosePhone
    if L4_2 then
      L4_2 = ClosePhone
      L4_2()
    end
  end
  L4_2 = type
  L5_2 = A3_2
  L4_2 = L4_2(L5_2)
  L4_2 = "table" == L4_2
  L5_2 = L0_1
  L6_2 = {}
  L6_2.keep = L4_2
  L5_2[A0_2] = L6_2
  L5_2 = SetNuiFocus
  L6_2 = true
  L7_2 = true
  L5_2(L6_2, L7_2)
  L5_2 = SetNuiFocusKeepInput
  L6_2 = L3_1
  L6_2, L7_2 = L6_2()
  L5_2(L6_2, L7_2)
  if A1_2 then
    L5_2 = Push
    L6_2 = A1_2
    L7_2 = A2_2 or L7_2
    if not A2_2 then
      L7_2 = {}
    end
    L5_2(L6_2, L7_2)
  end
  L5_2 = L5_1
  L5_2()
  L5_2 = true
  return L5_2
end
OverlayOpen = L6_1
function L6_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L1_2 = L0_1
  L1_2[A0_2] = nil
  L1_2 = L2_1
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = PhoneOpen
    if not L1_2 then
      L1_2 = SetNuiFocus
      L2_2 = false
      L3_2 = false
      L1_2(L2_2, L3_2)
      L1_2 = SetNuiFocusKeepInput
      L2_2 = false
      L1_2(L2_2)
  end
  else
    L1_2 = L2_1
    L1_2 = L1_2()
    if L1_2 then
      L1_2 = SetNuiFocusKeepInput
      L2_2 = L3_1
      L2_2, L3_2 = L2_2()
      L1_2(L2_2, L3_2)
    end
  end
  L1_2 = TriggerEvent
  L2_2 = "apex_phone:overlayClosed"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L1_2 = Push
  L2_2 = "overlay:close"
  L3_2 = {}
  L3_2.id = A0_2
  L1_2(L2_2, L3_2)
  L1_2 = L6_1
  L2_2 = A0_2
  L1_2(L2_2)
end
OverlayClose = L7_1
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = 0
  L1_2 = pairs
  L2_2 = L0_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L0_2 = L0_2 + 1
    L6_2 = Push
    L7_2 = "overlay:close"
    L8_2 = {}
    L8_2.id = L5_2
    L6_2(L7_2, L8_2)
    L6_2 = L0_1
    L6_2[L5_2] = nil
    L6_2 = TriggerEvent
    L7_2 = "apex_phone:overlayClosed"
    L8_2 = L5_2
    L6_2(L7_2, L8_2)
  end
  if L0_2 > 0 then
    L1_2 = PhoneOpen
    if not L1_2 then
      L1_2 = SetNuiFocus
      L2_2 = false
      L3_2 = false
      L1_2(L2_2, L3_2)
      L1_2 = SetNuiFocusKeepInput
      L2_2 = false
      L1_2(L2_2)
    end
  end
  return L0_2
end
OverlayReset = L7_1
L7_1 = RegisterNUICallback
L8_1 = "overlay"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = type
    L3_2 = A0_2.id
    L2_2 = L2_2(L3_2)
    if "string" == L2_2 then
      L2_2 = A0_2.open
      if false == L2_2 then
        L2_2 = L6_1
        L3_2 = A0_2.id
        L2_2(L3_2)
      end
    end
  end
end
L7_1(L8_1, L9_1)
L7_1 = {}
L8_1 = 0
L9_1 = RegisterNetEvent
L10_1 = "apex_phone:client:ov"
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L7_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = L7_1
    L3_2[A0_2] = nil
    L4_2 = L2_2
    L3_2 = L2_2.resolve
    L5_2 = type
    L6_2 = A1_2
    L5_2 = L5_2(L6_2)
    L5_2 = A1_2 or L5_2
    if "table" ~= L5_2 or not A1_2 then
      L5_2 = {}
      L5_2.ok = false
      L5_2.error = "server"
    end
    L3_2(L4_2, L5_2)
  end
end
L9_1(L10_1, L11_1)
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L8_1
  L3_2 = L3_2 + 1
  L8_1 = L3_2
  L3_2 = L8_1
  L4_2 = promise
  L4_2 = L4_2.new
  L4_2 = L4_2()
  L5_2 = L7_1
  L5_2[L3_2] = L4_2
  L5_2 = TriggerServerEvent
  L6_2 = "apex_phone:server:ov"
  L7_2 = L3_2
  L8_2 = A0_2
  L9_2 = A1_2 or L9_2
  if not A1_2 then
    L9_2 = {}
  end
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = SetTimeout
  L6_2 = A2_2 or L6_2
  if not A2_2 then
    L6_2 = 10000
  end
  function L7_2()
    local L0_3, L1_3, L2_3
    L1_3 = L3_2
    L0_3 = L7_1
    L0_3 = L0_3[L1_3]
    if L0_3 then
      L1_3 = L3_2
      L0_3 = L7_1
      L0_3[L1_3] = nil
      L0_3 = L4_2
      L1_3 = L0_3
      L0_3 = L0_3.resolve
      L2_3 = {}
      L2_3.ok = false
      L2_3.error = "timeout"
      L0_3(L1_3, L2_3)
    end
  end
  L5_2(L6_2, L7_2)
  L5_2 = Citizen
  L5_2 = L5_2.Await
  L6_2 = L4_2
  return L5_2(L6_2)
end
OverlayRequest = L9_1
L9_1 = RegisterNUICallback
L10_1 = "ov"
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = type
    L3_2 = A0_2.name
    L2_2 = L2_2(L3_2)
    if "string" == L2_2 then
      goto lbl_18
    end
  end
  L2_2 = A1_2
  L3_2 = {}
  L3_2.ok = false
  L3_2.error = "invalid"
  L2_2(L3_2)
  do return end
  ::lbl_18::
  L2_2 = OverlayClientHooks
  if L2_2 then
    L2_2 = OverlayClientHooks
    L3_2 = A0_2.name
    L2_2 = L2_2[L3_2]
  end
  if L2_2 then
    L3_2 = A1_2
    L4_2 = L2_2
    L5_2 = type
    L6_2 = A0_2.data
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L5_2 = A0_2.data
      if L5_2 then
        goto lbl_38
      end
    end
    L5_2 = {}
    ::lbl_38::
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = {}
      L4_2.ok = false
    end
    L3_2(L4_2)
    return
  end
  L3_2 = A1_2
  L4_2 = OverlayRequest
  L5_2 = A0_2.name
  L6_2 = type
  L7_2 = A0_2.data
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A0_2.data
    if L6_2 then
      goto lbl_59
    end
  end
  L6_2 = {}
  ::lbl_59::
  L7_2 = tonumber
  L8_2 = A0_2.timeout
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = nil
  end
  L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L9_1(L10_1, L11_1)
L9_1 = OverlayClientHooks
if not L9_1 then
  L9_1 = {}
end
OverlayClientHooks = L9_1
L9_1 = AddEventHandler
L10_1 = "onResourceStop"
function L11_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = L2_1
  L1_2 = L1_2()
  if L1_2 then
    L1_2 = SetNuiFocus
    L2_2 = false
    L3_2 = false
    L1_2(L2_2, L3_2)
  end
end
L9_1(L10_1, L11_1)
L9_1 = {}
L10_1 = ipairs
L11_1 = AdminSchema
if L11_1 then
  L11_1 = AdminSchema
  L11_1 = L11_1.settings
  if L11_1 then
    goto lbl_57
  end
end
L11_1 = {}
::lbl_57::
L10_1, L11_1, L12_1, L13_1 = L10_1(L11_1)
for L14_1, L15_1 in L10_1, L11_1, L12_1, L13_1 do
  L16_1 = L15_1.path
  L17_1 = {}
  L18_1 = AdminSchemaGet
  L19_1 = L15_1.path
  L18_1 = L18_1(L19_1)
  L17_1.v = L18_1
  L9_1[L16_1] = L17_1
end
L10_1 = nil
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not A0_2 then
    L1_2 = {}
    A0_2 = L1_2
  end
  L1_2 = type
  L2_2 = A0_2.config
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.config
    if L1_2 then
      goto lbl_21
    end
  end
  L1_2 = {}
  ::lbl_21::
  L2_2 = pairs
  L3_2 = L9_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L1_2[L6_2]
    if nil ~= L8_2 then
      L9_2 = AdminSchemaSet
      L10_2 = L6_2
      L11_2 = L8_2
      L9_2(L10_2, L11_2)
    else
      L9_2 = AdminSchemaSet
      L10_2 = L6_2
      L11_2 = L7_2.v
      L9_2(L10_2, L11_2)
    end
  end
  L2_2 = {}
  L3_2 = type
  L4_2 = A0_2.disabledApps
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.disabledApps
    if L3_2 then
      goto lbl_52
    end
  end
  L3_2 = {}
  ::lbl_52::
  L2_2.disabledApps = L3_2
  L3_2 = type
  L4_2 = A0_2.theme
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.theme
    if L3_2 then
      goto lbl_62
    end
  end
  L3_2 = nil
  ::lbl_62::
  L2_2.theme = L3_2
  L3_2 = Config
  L3_2 = L3_2.DefaultLanguage
  L2_2.defaultLang = L3_2
  L3_2 = Config
  L3_2 = L3_2.DefaultTheme
  L2_2.defaultTheme = L3_2
  L10_1 = L2_2
  L2_2 = Push
  L3_2 = "admin:settings"
  L4_2 = L10_1
  L2_2(L3_2, L4_2)
  L2_2 = PhoneLangDefaultChanged
  if L2_2 then
    L2_2 = pcall
    L3_2 = PhoneLangDefaultChanged
    L2_2(L3_2)
  end
end
function L12_1()
  local L0_2, L1_2, L2_2
  L0_2 = nil
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3
    L0_3 = GlobalState
    L0_3 = L0_3["apex_phone:settings"]
    L0_2 = L0_3
  end
  L1_2(L2_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L11_1
  L2_2 = L0_2
  L1_2(L2_2)
  L1_2 = true
  return L1_2
end
AdminSettingsApply = L12_1
L12_1 = AddStateBagChangeHandler
L13_1 = "apex_phone:settings"
L14_1 = "global"
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = L11_1
  L4_2 = A2_2
  L3_2(L4_2)
end
L12_1(L13_1, L14_1, L15_1)
L12_1 = CreateThread
function L13_1()
  local L0_2, L1_2
  L0_2 = Wait
  L1_2 = 1500
  L0_2(L1_2)
  L0_2 = L11_1
  L1_2 = GlobalState
  L1_2 = L1_2["apex_phone:settings"]
  L0_2(L1_2)
end
L12_1(L13_1)
L12_1 = RegisterNUICallback
L13_1 = "admin:settingsGet"
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A1_2
  L3_2 = L10_1
  if not L3_2 then
    L3_2 = {}
    L4_2 = {}
    L3_2.disabledApps = L4_2
  end
  L2_2(L3_2)
end
L12_1(L13_1, L14_1)
L12_1 = RegisterNetEvent
L13_1 = "apex_phone:client:wipeSay"
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = tostring
  L4_2 = A0_2 or L4_2
  if not A0_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = FW
  if L3_2 then
    L3_2 = FW
    L3_2 = L3_2.Notify
    if L3_2 then
      L3_2 = FW
      L3_2 = L3_2.Notify
      L4_2 = A0_2
      L5_2 = A1_2 or L5_2
      if not A1_2 then
        L5_2 = "primary"
      end
      L3_2(L4_2, L5_2)
    end
  end
  if A2_2 then
    L3_2 = TriggerEvent
    L4_2 = "chat:addMessage"
    L5_2 = {}
    if "error" == A1_2 then
      L6_2 = {}
      L7_2 = 255
      L8_2 = 90
      L9_2 = 90
      L6_2[1] = L7_2
      L6_2[2] = L8_2
      L6_2[3] = L9_2
      if L6_2 then
        goto lbl_43
      end
    end
    L6_2 = {}
    L7_2 = 255
    L8_2 = 200
    L9_2 = 80
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    ::lbl_43::
    L5_2.color = L6_2
    L6_2 = {}
    L7_2 = "phonewipe"
    L8_2 = Tr
    if L8_2 then
      L8_2 = Tr
      L9_2 = A0_2
      L8_2 = L8_2(L9_2)
      if L8_2 then
        goto lbl_56
      end
    end
    L8_2 = A0_2
    ::lbl_56::
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L5_2.args = L6_2
    L3_2(L4_2, L5_2)
  end
end
L12_1(L13_1, L14_1)
L12_1 = RegisterNetEvent
L13_1 = "apex_phone:client:wipeAsk"
function L14_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not A0_2 then
    L1_2 = {}
    A0_2 = L1_2
  end
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = "Isto apaga os dados de TODOS os jogadores no telem\195\179vel: %d tabelas, cerca de %d linhas (contas, n\195\186meros, mensagens, fotos, redes sociais, faturas, apps de trabalho...).\n\n%s\n%s\n\nDepois: restart apex_phone."
    L1_3 = L0_3
    L0_3 = L0_3.format
    L2_3 = tonumber
    L3_3 = A0_2.tables
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = tonumber
    L4_3 = A0_2.rows
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = 0
    end
    L4_3 = A0_2.all
    if L4_3 then
      L4_3 = "Inclui as defini\195\167\195\181es do painel admin."
      if L4_3 then
        goto lbl_22
      end
    end
    L4_3 = "As defini\195\167\195\181es do painel admin ficam."
    ::lbl_22::
    L5_3 = A0_2.backup
    if L5_3 then
      L5_3 = "Antes de apagar \195\169 feita uma c\195\179pia de cada tabela (zbak_apexphone_*)."
      if L5_3 then
        goto lbl_29
      end
    end
    L5_3 = "SEM c\195\179pia (nobackup)."
    ::lbl_29::
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
    L1_3 = nil
    L2_3 = GetResourceState
    L3_3 = "ox_lib"
    L2_3 = L2_3(L3_3)
    if "started" == L2_3 then
      L2_3 = pcall
      function L3_3()
        local L0_4, L1_4, L2_4, L3_4
        L0_4 = exports
        L0_4 = L0_4.ox_lib
        L1_4 = L0_4
        L0_4 = L0_4.alertDialog
        L2_4 = {}
        L2_4.header = "Apagar a base de dados do telem\195\179vel?"
        L3_4 = L0_3
        L2_4.content = L3_4
        L2_4.centered = true
        L2_4.cancel = true
        L3_4 = {}
        L3_4.confirm = "Apagar tudo"
        L3_4.cancel = "Cancelar"
        L2_4.labels = L3_4
        return L0_4(L1_4, L2_4)
      end
      L2_3, L3_3 = L2_3(L3_3)
      L1_3 = L3_3 or L1_3
      if not L2_3 or not L3_3 then
        L1_3 = nil
      end
    end
    if "confirm" == L1_3 then
      L2_3 = TriggerServerEvent
      L3_3 = "apex_phone:server:wipeConfirm"
      L4_3 = A0_2.code
      L5_3 = A0_2.all
      L5_3 = true == L5_3
      L6_3 = A0_2.backup
      L6_3 = false ~= L6_3
      L2_3(L3_3, L4_3, L5_3, L6_3)
    elseif nil == L1_3 then
      L2_3 = FW
      if L2_3 then
        L2_3 = FW
        L2_3 = L2_3.Notify
        if L2_3 then
          L2_3 = FW
          L2_3 = L2_3.Notify
          L3_3 = "Para confirmar escreve: /phonewipe confirm %s"
          L4_3 = L3_3
          L3_3 = L3_3.format
          L5_3 = tostring
          L6_3 = A0_2.code
          L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L5_3(L6_3)
          L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
          L4_3 = "error"
          L2_3(L3_3, L4_3)
        end
      end
      L2_3 = TriggerEvent
      L3_3 = "chat:addMessage"
      L4_3 = {}
      L5_3 = {}
      L6_3 = 255
      L7_3 = 90
      L8_3 = 90
      L5_3[1] = L6_3
      L5_3[2] = L7_3
      L5_3[3] = L8_3
      L4_3.color = L5_3
      L5_3 = {}
      L6_3 = "phonewipe"
      L7_3 = "Para confirmar (60 s): /phonewipe confirm %s"
      L8_3 = L7_3
      L7_3 = L7_3.format
      L9_3 = tostring
      L10_3 = A0_2.code
      L9_3, L10_3 = L9_3(L10_3)
      L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3, L9_3, L10_3)
      L5_3[1] = L6_3
      L5_3[2] = L7_3
      L5_3[3] = L8_3
      L5_3[4] = L9_3
      L5_3[5] = L10_3
      L4_3.args = L5_3
      L2_3(L3_3, L4_3)
    else
      L2_3 = FW
      if L2_3 then
        L2_3 = FW
        L2_3 = L2_3.Notify
        if L2_3 then
          L2_3 = FW
          L2_3 = L2_3.Notify
          L3_3 = "Cancelado. Nada foi apagado."
          L4_3 = "primary"
          L2_3(L3_3, L4_3)
        end
      end
    end
  end
  L1_2(L2_2)
end
L12_1(L13_1, L14_1)
