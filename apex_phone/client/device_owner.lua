local L0_1, L1_1, L2_1, L3_1, L4_1
L0_1 = type
L1_1 = Config
L1_1 = L1_1.StolenPhones
L0_1 = L0_1(L1_1)
if "table" == L0_1 then
  L0_1 = Config
  L0_1 = L0_1.StolenPhones
  if L0_1 then
    goto lbl_13
  end
end
L0_1 = nil
::lbl_13::
L1_1 = false
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = false
  L1_2 = false
  L2_2 = nil
  L3_2 = nil
  L4_2 = false
  L5_2 = {}
  L5_2.notsetup = "Este telem\195\179vel ainda n\195\163o foi configurado pelo dono."
  L5_2.nopin = "Este telem\195\179vel n\195\163o \195\169 teu."
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = pcall
    L1_3 = FW
    L1_3 = L1_3.GetPlayerData
    L0_3, L1_3 = L0_3(L1_3)
    if L0_3 then
      L2_3 = type
      L3_3 = L1_3
      L2_3 = L2_3(L3_3)
      if "table" == L2_3 then
        L2_3 = L1_3.cid
        if L2_3 then
          goto lbl_16
        end
      end
    end
    L2_3 = nil
    ::lbl_16::
    if nil ~= L2_3 then
      L3_3 = tostring
      L4_3 = L2_3
      L3_3 = L3_3(L4_3)
      if L3_3 then
        goto lbl_24
      end
    end
    L3_3 = nil
    ::lbl_24::
    return L3_3
  end
  function L7_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    if nil == A0_3 then
      L1_3 = false
      return L1_3
    end
    L1_3 = tostring
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    A0_3 = L1_3
    L1_3 = L3_2
    if not L1_3 then
      L1_3 = L6_2
      L1_3 = L1_3()
    end
    L3_2 = A0_3
    L2_3 = Push
    L3_3 = "session"
    L4_3 = {}
    L4_3.citizenid = A0_3
    L2_3(L3_3, L4_3)
    L2_3 = L1_3 ~= A0_3
    return L2_3
  end
  function L8_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = A0_3.mode
    L1_3 = "foreign" == L1_3
    L1_2 = L1_3
    L1_3 = math
    L1_3 = L1_3.tointeger
    L2_3 = tonumber
    L3_3 = A0_3.slot
    L2_3, L3_3 = L2_3(L3_3)
    L1_3 = L1_3(L2_3, L3_3)
    L2_2 = L1_3
    L1_3 = L7_2
    L2_3 = A0_3.cid
    return L1_3(L2_3)
  end
  function L9_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = ServerRpc
    L3_3 = "device.use"
    L4_3 = A0_3
    function L5_3(A0_4)
      local L1_4, L2_4
      L1_4 = CreateThread
      function L2_4()
        local L0_5, L1_5
        L0_5 = type
        L1_5 = A0_4
        L0_5 = L0_5(L1_5)
        if "table" == L0_5 then
          L0_5 = A0_4.ok
          if nil ~= L0_5 then
            goto lbl_16
          end
          L0_5 = A0_4.error
          if nil == L0_5 then
            goto lbl_16
          end
        end
        L0_5 = A1_3
        L1_5 = nil
        L0_5(L1_5)
        do return end
        ::lbl_16::
        L0_5 = A0_4.off
        if L0_5 then
          L0_5 = true
          L0_2 = L0_5
        end
        L0_5 = A1_3
        L1_5 = A0_4
        L0_5(L1_5)
      end
      L1_4(L2_4)
    end
    L2_3(L3_3, L4_3, L5_3)
  end
  function L10_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    if not A1_3 then
      L2_3 = FW
      L2_3 = L2_3.Notify
      L4_3 = A0_3.error
      L3_3 = L5_2
      L3_3 = L3_3[L4_3]
      if not L3_3 then
        L3_3 = "N\195\163o podes usar este telem\195\179vel."
      end
      L4_3 = "error"
      L2_3(L3_3, L4_3)
    end
  end
  function L11_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L2_3 = L0_2
    if L2_3 then
      L2_3 = false
      return L2_3
    end
    L2_3 = L4_2
    if L2_3 then
      L2_3 = true
      return L2_3
    end
    L2_3 = true
    L4_2 = L2_3
    L2_3 = {}
    L3_3 = pairs
    L4_3 = type
    L5_3 = A1_3
    L4_3 = L4_3(L5_3)
    L4_3 = A1_3 or L4_3
    if "table" ~= L4_3 or not A1_3 then
      L4_3 = {}
    end
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L2_3[L7_3] = L8_3
    end
    L2_3.devok = true
    L3_3 = L9_2
    L4_3 = {}
    L4_3.item = A0_3
    L5_3 = L2_3.slot
    L4_3.slot = L5_3
    L5_3 = L2_3.use
    L5_3 = true == L5_3
    L4_3.use = L5_3
    L5_3 = L2_3.force
    L5_3 = true == L5_3
    L4_3.force = L5_3
    function L5_3(A0_4)
      local L1_4, L2_4, L3_4, L4_4
      L1_4 = false
      L4_2 = L1_4
      if A0_4 then
        L1_4 = A0_4.ok
        if false == L1_4 then
          L1_4 = L10_2
          L2_4 = A0_4
          L3_4 = L2_3.silent
          L1_4(L2_4, L3_4)
          return
        end
      end
      L1_4 = A0_3
      if A0_4 then
        L2_4 = L8_2
        L3_4 = A0_4
        L2_4 = L2_4(L3_4)
        if L2_4 then
          L2_4 = Wait
          L3_4 = 250
          L2_4(L3_4)
        end
        L2_4 = A0_4.item
        L1_4 = L2_4 or L1_4
        if not L2_4 then
          L1_4 = A0_3
        end
      end
      L2_4 = OpenPhone
      L3_4 = L1_4
      L4_4 = L2_3
      L2_4(L3_4, L4_4)
    end
    L3_3(L4_3, L5_3)
    L3_3 = true
    return L3_3
  end
  DeviceOwnerOpen = L11_2
  function L11_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = L0_2
    if L2_3 then
      L2_3 = false
      return L2_3
    end
    L2_3 = math
    L2_3 = L2_3.tointeger
    L3_3 = tonumber
    L4_3 = A1_3
    L3_3, L4_3, L5_3 = L3_3(L4_3)
    L2_3 = L2_3(L3_3, L4_3, L5_3)
    A1_3 = L2_3
    L2_3 = PhoneOpen
    if not L2_3 then
      L2_3 = OpenPhone
      L3_3 = A0_3
      L4_3 = {}
      L4_3.slot = A1_3
      L4_3.use = true
      L2_3(L3_3, L4_3)
      L2_3 = true
      return L2_3
    end
    L2_3 = nil
    if A1_3 then
      L3_3 = L2_2
      if L3_3 then
        L3_3 = L2_2
        L2_3 = A1_3 == L3_3
    end
    else
      L3_3 = CurrentDevice
      L2_3 = L3_3 == A0_3
    end
    if L2_3 then
      L3_3 = ClosePhone
      L3_3()
      L3_3 = true
      return L3_3
    end
    L3_3 = L4_2
    if L3_3 then
      L3_3 = true
      return L3_3
    end
    L3_3 = true
    L4_2 = L3_3
    L3_3 = L9_2
    L4_3 = {}
    L4_3.item = A0_3
    L4_3.slot = A1_3
    L4_3.use = true
    function L5_3(A0_4)
      local L1_4, L2_4, L3_4, L4_4
      L1_4 = false
      L4_2 = L1_4
      if A0_4 then
        L1_4 = A0_4.ok
        if false == L1_4 then
          L1_4 = L10_2
          L2_4 = A0_4
          L1_4(L2_4)
          return
        end
      end
      if A0_4 then
        L1_4 = L8_2
        L2_4 = A0_4
        L1_4(L2_4)
      end
      if A0_4 then
        L1_4 = A0_4.item
        if L1_4 then
          goto lbl_23
        end
      end
      L1_4 = A0_3
      ::lbl_23::
      L2_4 = PhoneOpen
      if not L2_4 then
        L2_4 = OpenPhone
        L3_4 = L1_4
        L4_4 = {}
        L4_4.devok = true
        L2_4(L3_4, L4_4)
        return
      end
      L2_4 = SwitchDevice
      L3_4 = L1_4
      L4_4 = true
      L2_4 = L2_4(L3_4, L4_4)
      if L2_4 then
        L2_4 = Config
        L2_4 = L2_4.Devices
        L2_4 = L2_4[L1_4]
        if L2_4 then
          L2_4 = FW
          L2_4 = L2_4.Notify
          L3_4 = Config
          L3_4 = L3_4.Devices
          L3_4 = L3_4[L1_4]
          L3_4 = L3_4.label
          L4_4 = "success"
          L2_4(L3_4, L4_4)
        end
      end
    end
    L3_3(L4_3, L5_3)
    L3_3 = true
    return L3_3
  end
  DeviceOwnerUse = L11_2
  function L11_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L0_2
    if L1_3 or not A0_3 then
      L1_3 = false
      return L1_3
    end
    L1_3 = L4_2
    if L1_3 then
      L1_3 = true
      return L1_3
    end
    L1_3 = true
    L4_2 = L1_3
    L1_3 = L9_2
    L2_3 = {}
    L2_3.item = A0_3
    function L3_3(A0_4)
      local L1_4, L2_4, L3_4
      L1_4 = false
      L4_2 = L1_4
      if A0_4 then
        L1_4 = A0_4.ok
        if false == L1_4 then
          L1_4 = L10_2
          L2_4 = A0_4
          L1_4(L2_4)
          L1_4 = ClosePhone
          L1_4()
          return
        end
      end
      if A0_4 then
        L1_4 = L8_2
        L2_4 = A0_4
        L1_4(L2_4)
      end
      L1_4 = SwitchDevice
      if A0_4 then
        L2_4 = A0_4.item
        if L2_4 then
          goto lbl_26
        end
      end
      L2_4 = A0_3
      ::lbl_26::
      L3_4 = true
      L1_4(L2_4, L3_4)
    end
    L1_3(L2_3, L3_3)
    L1_3 = true
    return L1_3
  end
  DeviceOwnerSwitch = L11_2
  L11_2 = AddEventHandler
  L12_2 = "apex_phone:client:closed"
  function L13_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = L0_2
    if not L0_3 then
      L0_3 = L1_2
      if L0_3 then
        goto lbl_8
      end
    end
    do return end
    ::lbl_8::
    L0_3 = ServerRpc
    L1_3 = "device.end"
    L2_3 = {}
    function L3_3(A0_4)
      local L1_4, L2_4
      L1_4 = type
      L2_4 = A0_4
      L1_4 = L1_4(L2_4)
      if "table" == L1_4 then
        L1_4 = A0_4.deferred
        if not L1_4 then
          L1_4 = A0_4.kept
          if not L1_4 then
            goto lbl_13
          end
        end
      end
      do return end
      ::lbl_13::
      L1_4 = PhoneOpen
      if L1_4 then
        return
      end
      L1_4 = false
      L2_4 = nil
      L2_2 = L2_4
      L1_2 = L1_4
      L1_4 = L7_2
      L2_4 = A0_4.cid
      if not L2_4 then
        L2_4 = L6_2
        L2_4 = L2_4()
      end
      L1_4(L2_4)
    end
    L0_3(L1_3, L2_3, L3_3)
  end
  L11_2(L12_2, L13_2)
  L11_2 = RegisterNetEvent
  L12_2 = "apex_phone:client:deviceSession"
  function L13_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = A0_3.mode
      if "own" == L1_3 then
        goto lbl_10
      end
    end
    do return end
    ::lbl_10::
    L1_3 = L1_2
    L2_3 = false
    L3_3 = nil
    L2_2 = L3_3
    L1_2 = L2_3
    if L1_3 then
      L2_3 = PhoneOpen
      if L2_3 then
        L2_3 = ClosePhone
        L2_3()
      end
    end
    L2_3 = L7_2
    L3_3 = A0_3.cid
    if not L3_3 then
      L3_3 = L6_2
      L3_3 = L3_3()
    end
    L2_3(L3_3)
  end
  L11_2(L12_2, L13_2)
  L11_2 = exports
  L12_2 = "IsForeignPhone"
  function L13_2()
    local L0_3, L1_3
    L0_3 = L1_2
    return L0_3
  end
  L11_2(L12_2, L13_2)
  function L11_2()
    local L0_3, L1_3
    L0_3 = L4_2
    L1_3 = false
    L4_2 = L1_3
    return L0_3
  end
  DeviceOwnerReset = L11_2
end
L3_1 = false
function L4_1(A0_2)
  local L1_2
  if "psim" == A0_2 then
    L1_2 = true
    L1_1 = L1_2
  end
  L1_2 = L3_1
  if L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = true
  L3_1 = L1_2
  L1_2 = L0_1
  if not L1_2 then
    L1_2 = {}
  end
  L0_1 = L1_2
  L1_2 = L2_1
  L1_2()
  L1_2 = true
  return L1_2
end
DeviceOwnerActivate = L4_1
if L0_1 then
  L4_1 = L0_1.enabled
  if true == L4_1 then
    L4_1 = DeviceOwnerActivate
    L4_1()
  end
end
