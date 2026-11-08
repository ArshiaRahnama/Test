local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1
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
function L1_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
L2_1 = "apex_phone:cshare:give"
L3_1 = "apex_phone:cshare:ask"
L4_1 = nil
L5_1 = nil
L6_1 = nil
L7_1 = -10000
L8_1 = false
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L1_2 = L7_1
  L1_2 = L0_2 - L1_2
  L2_2 = 1500
  if L1_2 < L2_2 then
    L1_2 = L8_1
    return L1_2
  end
  L7_1 = L0_2
  L1_2 = true
  L2_2 = FW
  L2_2 = L2_2.IsDead
  L2_2 = L2_2()
  if L2_2 then
    L1_2 = false
  else
    L2_2 = Config
    L2_2 = L2_2.RequireItem
    if L2_2 then
      L1_2 = false
      L2_2 = FW
      L2_2 = L2_2.FirstItemOf
      if L2_2 then
        L2_2 = FW
        L2_2 = L2_2.FirstItemOf
        L3_2 = Config
        L3_2 = L3_2.Devices
        if not L3_2 then
          L3_2 = {}
        end
        L2_2 = L2_2(L3_2)
        if L2_2 then
          goto lbl_41
        end
      end
      L2_2 = nil
      ::lbl_41::
      if L2_2 then
        L1_2 = true
      else
        L3_2 = pairs
        L4_2 = Config
        L4_2 = L4_2.Devices
        if not L4_2 then
          L4_2 = {}
        end
        L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
        for L7_2 in L3_2, L4_2, L5_2, L6_2 do
          L8_2 = FW
          L8_2 = L8_2.HasItem
          L9_2 = L7_2
          L8_2 = L8_2(L9_2)
          if not L8_2 then
            L8_2 = 0
          end
          if L8_2 > 0 then
            L1_2 = true
            break
          end
        end
        if not L1_2 then
          L3_2 = Config
          L3_2 = L3_2.PhoneItem
          if L3_2 then
            L3_2 = Config
            L3_2 = L3_2.PhoneItem
            if "" ~= L3_2 then
              L3_2 = FW
              L3_2 = L3_2.HasItem
              L4_2 = Config
              L4_2 = L4_2.PhoneItem
              L3_2 = L3_2(L4_2)
              if not L3_2 then
                L3_2 = 0
              end
              L1_2 = L3_2 > 0
            end
          end
        end
      end
    end
  end
  L8_1 = L1_2
  return L1_2
end
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L0_1
  L2_2 = L2_2()
  L3_2 = L2_2.enabled
  if false ~= L3_2 then
    L3_2 = L2_2.target
    if false ~= L3_2 then
      goto lbl_11
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_11::
  if A1_2 then
    L3_2 = L2_2.askForContact
    if false == L3_2 then
      L3_2 = false
      return L3_2
    end
  end
  if A0_2 and 0 ~= A0_2 then
    L3_2 = PlayerPedId
    L3_2 = L3_2()
    if A0_2 ~= L3_2 then
      goto lbl_28
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_28::
  L3_2 = L1_1
  L4_2 = IsPedAPlayer
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L2_2.requirePhoneOut
  if true == L3_2 then
    L3_2 = PhoneOpen
    if not L3_2 then
      L3_2 = false
      return L3_2
    end
  end
  L3_2 = L9_1
  return L3_2()
end
L11_1 = -10000
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L11_1
  L3_2 = L2_2 - L3_2
  L4_2 = 800
  if L3_2 < L4_2 then
    return
  end
  L11_1 = L2_2
  if A0_2 and 0 ~= A0_2 then
    L3_2 = L1_1
    L4_2 = DoesEntityExist
    L5_2 = A0_2
    L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    if L3_2 then
      goto lbl_23
    end
  end
  do return end
  ::lbl_23::
  L3_2 = NetworkGetPlayerIndexFromPed
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 or -1 == L3_2 then
    return
  end
  L4_2 = GetPlayerServerId
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 or L4_2 <= 0 then
    return
  end
  L5_2 = TriggerServerEvent
  L6_2 = "apex_phone:server:cshareTarget"
  L7_2 = L4_2
  L8_2 = A1_2
  L5_2(L6_2, L7_2, L8_2)
end
function L13_1()
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
  return L0_2
end
function L14_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L0_1
  L0_2 = L0_2()
  L1_2 = table
  L1_2 = L1_2.concat
  L2_2 = {}
  L3_2 = tostring
  L4_2 = L0_2.enabled
  L4_2 = false ~= L4_2
  L3_2 = L3_2(L4_2)
  L4_2 = tostring
  L5_2 = L0_2.target
  L5_2 = false ~= L5_2
  L4_2 = L4_2(L5_2)
  L5_2 = tostring
  L6_2 = L0_2.askForContact
  L6_2 = false ~= L6_2
  L5_2 = L5_2(L6_2)
  L6_2 = tostring
  L7_2 = L13_1
  L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2()
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = tostring
  L8_2 = L0_2.requirePhoneOut
  L8_2 = true == L8_2
  L7_2 = L7_2(L8_2)
  L8_2 = PhoneLangCode
  if L8_2 then
    L8_2 = PhoneLangCode
    L8_2 = L8_2()
    if L8_2 then
      goto lbl_47
    end
  end
  L8_2 = ""
  ::lbl_47::
  L9_2 = GetResourceState
  L10_2 = "ox_target"
  L9_2 = L9_2(L10_2)
  L10_2 = GetResourceState
  L11_2 = "qb-target"
  L10_2, L11_2 = L10_2(L11_2)
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L2_2[8] = L10_2
  L2_2[9] = L11_2
  L3_2 = "|"
  return L1_2(L2_2, L3_2)
end
function L15_1()
  local L0_2, L1_2, L2_2
  L0_2 = L4_1
  if "ox" == L0_2 then
    L0_2 = pcall
    function L1_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = exports
      L0_3 = L0_3.ox_target
      L1_3 = L0_3
      L0_3 = L0_3.removeGlobalPlayer
      L2_3 = {}
      L3_3 = L2_1
      L4_3 = L3_1
      L2_3[1] = L3_3
      L2_3[2] = L4_3
      L0_3(L1_3, L2_3)
    end
    L0_2(L1_2)
  else
    L0_2 = L4_1
    if "qb" == L0_2 then
      L0_2 = L5_1
      if L0_2 then
        L0_2 = L5_1
        L1_2 = pcall
        function L2_2()
          local L0_3, L1_3, L2_3
          L0_3 = exports
          L0_3 = L0_3["qb-target"]
          L1_3 = L0_3
          L0_3 = L0_3.RemoveGlobalPlayer
          L2_3 = L0_2
          L0_3(L1_3, L2_3)
        end
        L1_2(L2_2)
      end
    end
  end
  L0_2 = nil
  L1_2 = nil
  L5_1 = L1_2
  L4_1 = L0_2
end
function L16_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = L0_1
  L0_2 = L0_2()
  L1_2 = L15_1
  L1_2()
  L1_2 = L14_1
  L1_2 = L1_2()
  L6_1 = L1_2
  L1_2 = L0_2.enabled
  if false ~= L1_2 then
    L1_2 = L0_2.target
    if false ~= L1_2 then
      goto lbl_15
    end
  end
  do return end
  ::lbl_15::
  L1_2 = L13_1
  L1_2 = L1_2()
  L2_2 = Tr
  L3_2 = "Partilhar contacto"
  L2_2 = L2_2(L3_2)
  L3_2 = Tr
  L4_2 = "Pedir contacto"
  L3_2 = L3_2(L4_2)
  L4_2 = L0_2.askForContact
  L4_2 = false ~= L4_2
  L5_2 = GetResourceState
  L6_2 = "ox_target"
  L5_2 = L5_2(L6_2)
  if "started" == L5_2 then
    L5_2 = {}
    L6_2 = {}
    L7_2 = L2_1
    L6_2.name = L7_2
    L6_2.icon = "fa-solid fa-address-card"
    L6_2.label = L2_2
    L6_2.distance = L1_2
    function L7_2(A0_3)
      local L1_3, L2_3, L3_3
      L1_3 = L10_1
      L2_3 = A0_3
      L3_3 = false
      return L1_3(L2_3, L3_3)
    end
    L6_2.canInteract = L7_2
    function L7_2(A0_3)
      local L1_3, L2_3, L3_3
      L1_3 = L12_1
      L2_3 = A0_3 or L2_3
      if A0_3 then
        L2_3 = A0_3.entity
      end
      L3_3 = "share"
      L1_3(L2_3, L3_3)
    end
    L6_2.onSelect = L7_2
    L5_2[1] = L6_2
    if L4_2 then
      L6_2 = #L5_2
      L6_2 = L6_2 + 1
      L7_2 = {}
      L8_2 = L3_1
      L7_2.name = L8_2
      L7_2.icon = "fa-solid fa-user-plus"
      L7_2.label = L3_2
      L7_2.distance = L1_2
      function L8_2(A0_3)
        local L1_3, L2_3, L3_3
        L1_3 = L10_1
        L2_3 = A0_3
        L3_3 = true
        return L1_3(L2_3, L3_3)
      end
      L7_2.canInteract = L8_2
      function L8_2(A0_3)
        local L1_3, L2_3, L3_3
        L1_3 = L12_1
        L2_3 = A0_3 or L2_3
        if A0_3 then
          L2_3 = A0_3.entity
        end
        L3_3 = "ask"
        L1_3(L2_3, L3_3)
      end
      L7_2.onSelect = L8_2
      L5_2[L6_2] = L7_2
    end
    L6_2 = pcall
    function L7_2()
      local L0_3, L1_3, L2_3
      L0_3 = exports
      L0_3 = L0_3.ox_target
      L1_3 = L0_3
      L0_3 = L0_3.addGlobalPlayer
      L2_3 = L5_2
      L0_3(L1_3, L2_3)
    end
    L6_2, L7_2 = L6_2(L7_2)
    if L6_2 then
      L8_2 = "ox"
      L4_1 = L8_2
    else
      L8_2 = print
      L9_2 = "[unique_phone] contact sharing: ox_target: %s"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L12_2 = L7_2
      L11_2, L12_2, L13_2 = L11_2(L12_2)
      L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    end
  else
    L5_2 = GetResourceState
    L6_2 = "qb-target"
    L5_2 = L5_2(L6_2)
    if "started" == L5_2 then
      L5_2 = {}
      L6_2 = {}
      L6_2.type = "client"
      L6_2.icon = "fas fa-address-card"
      L6_2.label = L2_2
      function L7_2(A0_3)
        local L1_3, L2_3, L3_3
        L1_3 = L10_1
        L2_3 = A0_3
        L3_3 = false
        return L1_3(L2_3, L3_3)
      end
      L6_2.canInteract = L7_2
      function L7_2(A0_3)
        local L1_3, L2_3, L3_3
        L1_3 = L12_1
        L2_3 = A0_3
        L3_3 = "share"
        L1_3(L2_3, L3_3)
      end
      L6_2.action = L7_2
      L5_2[1] = L6_2
      L6_2 = {}
      L7_2 = L2_2
      L6_2[1] = L7_2
      if L4_2 then
        L7_2 = #L5_2
        L7_2 = L7_2 + 1
        L8_2 = {}
        L8_2.type = "client"
        L8_2.icon = "fas fa-user-plus"
        L8_2.label = L3_2
        function L9_2(A0_3)
          local L1_3, L2_3, L3_3
          L1_3 = L10_1
          L2_3 = A0_3
          L3_3 = true
          return L1_3(L2_3, L3_3)
        end
        L8_2.canInteract = L9_2
        function L9_2(A0_3)
          local L1_3, L2_3, L3_3
          L1_3 = L12_1
          L2_3 = A0_3
          L3_3 = "ask"
          L1_3(L2_3, L3_3)
        end
        L8_2.action = L9_2
        L5_2[L7_2] = L8_2
        L7_2 = #L6_2
        L7_2 = L7_2 + 1
        L6_2[L7_2] = L3_2
      end
      L7_2 = pcall
      function L8_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = exports
        L0_3 = L0_3["qb-target"]
        L1_3 = L0_3
        L0_3 = L0_3.AddGlobalPlayer
        L2_3 = {}
        L3_3 = L5_2
        L2_3.options = L3_3
        L3_3 = L1_2
        L2_3.distance = L3_3
        L0_3(L1_3, L2_3)
      end
      L7_2, L8_2 = L7_2(L8_2)
      if L7_2 then
        L9_2 = "qb"
        L5_1 = L6_2
        L4_1 = L9_2
      else
        L9_2 = print
        L10_2 = "[unique_phone] contact sharing: qb-target: %s"
        L11_2 = L10_2
        L10_2 = L10_2.format
        L12_2 = tostring
        L13_2 = L8_2
        L12_2, L13_2 = L12_2(L13_2)
        L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2)
        L9_2(L10_2, L11_2, L12_2, L13_2)
      end
    end
  end
end
function L17_1()
  local L0_2, L1_2
  L0_2 = L4_1
  return L0_2
end
CShareTargetProvider = L17_1
L17_1 = CreateThread
function L18_1()
  local L0_2, L1_2
  L0_2 = Wait
  L1_2 = 2000
  L0_2(L1_2)
  L0_2 = L16_1
  L0_2()
  while true do
    L0_2 = Wait
    L1_2 = 5000
    L0_2(L1_2)
    L0_2 = L14_1
    L0_2 = L0_2()
    L1_2 = L6_1
    if L0_2 ~= L1_2 then
      L0_2 = L16_1
      L0_2()
    end
  end
end
L17_1(L18_1)
L17_1 = AddEventHandler
L18_1 = "onClientResourceStart"
function L19_1(A0_2)
  local L1_2, L2_2, L3_2
  if "ox_target" ~= A0_2 and "qb-target" ~= A0_2 then
    return
  end
  L1_2 = SetTimeout
  L2_2 = 1000
  L3_2 = L16_1
  L1_2(L2_2, L3_2)
end
L17_1(L18_1, L19_1)
L17_1 = AddEventHandler
L18_1 = "onResourceStop"
function L19_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = L15_1
  L1_2()
end
L17_1(L18_1, L19_1)
