local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1
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
L2_1 = {}
L2_1["calls.accept"] = true
L2_1["calls.decline"] = true
L2_1["calls.end"] = true
L2_1["calls.mute"] = true
function L3_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2, L43_2, L44_2, L45_2, L46_2, L47_2
  function L0_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = print
    L2_3 = "^3[unique_phone]^0 other person's phone: "
    L3_3 = A0_3
    L2_3 = L2_3 .. L3_3
    L1_3(L2_3)
  end
  function L1_2(A0_3, ...)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = L0_1.debug
    if L1_3 then
      L1_3 = pcall
      L2_3 = string
      L2_3 = L2_3.format
      L3_3 = A0_3
      L4_3, L5_3 = ...
      L1_3, L2_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
      L3_3 = print
      L4_3 = "^5[unique_phone] stolen^0 "
      L5_3 = L2_3 or L5_3
      if not L1_3 or not L2_3 then
        L5_3 = A0_3
      end
      L4_3 = L4_3 .. L5_3
      L3_3(L4_3)
    end
  end
  L2_2 = {}
  DeviceSessions = L2_2
  L2_2 = DeviceSessions
  L3_2 = {}
  L4_2 = {}
  L5_2 = nil
  function L6_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = FW
    L1_3 = L1_3.GetCidPhone
    L2_3 = A0_3
    L1_3, L2_3 = L1_3(L2_3)
    if L1_3 and nil ~= L2_3 and "" ~= L2_3 then
      L3_3 = tostring
      L4_3 = L2_3
      return L3_3(L4_3)
    end
    L3_3 = nil
    return L3_3
  end
  function L7_2(A0_3)
    local L1_3, L2_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L1_3 = "string" == L1_3
    return L1_3
  end
  function L8_2()
    local L0_3, L1_3
    L0_3 = type
    L1_3 = InvalidateOnlineIndex
    L0_3 = L0_3(L1_3)
    if "function" == L0_3 then
      L0_3 = pcall
      L1_3 = InvalidateOnlineIndex
      L0_3(L1_3)
    end
  end
  L9_2 = nil
  function L10_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = L9_2
    if not L1_3 then
      L1_3 = pcall
      function L2_3()
        local L0_4, L1_4
        L0_4 = exports
        L0_4 = L0_4["qb-core"]
        L1_4 = L0_4
        L0_4 = L0_4.GetCoreObject
        return L0_4(L1_4)
      end
      L1_3, L2_3 = L1_3(L2_3)
      if L1_3 then
        L3_3 = type
        L4_3 = L2_3
        L3_3 = L3_3(L4_3)
        if "table" == L3_3 then
          L9_2 = L2_3
        end
      end
    end
    L1_3 = L9_2
    if not L1_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = pcall
    L2_3 = L9_2.Functions
    L2_3 = L2_3.GetPlayer
    L3_3 = A0_3
    L1_3, L2_3 = L1_3(L2_3, L3_3)
    if L1_3 then
      L3_3 = type
      L4_3 = L2_3
      L3_3 = L3_3(L4_3)
      if "table" == L3_3 then
        L3_3 = L2_3.PlayerData
        if L3_3 and L2_3 then
          goto lbl_38
          L3_3 = L2_3 or L3_3
        end
      end
    end
    L3_3 = nil
    ::lbl_38::
    return L3_3
  end
  function L11_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L1_3 = {}
    L2_3 = type
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if "table" == L2_3 then
      L2_3 = pairs
      L3_3 = A0_3
      L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
      for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
        L1_3[L6_3] = L7_3
      end
    end
    return L1_3
  end
  function L12_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L1_3 = {}
    L2_3 = L5_2
    if "ox" == L2_3 then
      L2_3 = pcall
      function L3_3()
        local L0_4, L1_4, L2_4
        L0_4 = exports
        L0_4 = L0_4.ox_inventory
        L1_4 = L0_4
        L0_4 = L0_4.GetInventoryItems
        L2_4 = A0_3
        return L0_4(L1_4, L2_4)
      end
      L2_3, L3_3 = L2_3(L3_3)
      if not L2_3 then
        goto lbl_160
      end
      L4_3 = type
      L5_3 = L3_3
      L4_3 = L4_3(L5_3)
      if "table" ~= L4_3 then
        goto lbl_160
      end
      L4_3 = pairs
      L5_3 = L3_3
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
      for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
        L10_3 = type
        L11_3 = L9_3
        L10_3 = L10_3(L11_3)
        if "table" == L10_3 then
          L10_3 = L7_2
          L11_3 = L9_3.name
          L10_3 = L10_3(L11_3)
          if L10_3 then
            L10_3 = tonumber
            L11_3 = L9_3.count
            L10_3 = L10_3(L11_3)
            if not L10_3 then
              L10_3 = 0
            end
            if L10_3 > 0 then
              L10_3 = #L1_3
              L10_3 = L10_3 + 1
              L11_3 = {}
              L12_3 = math
              L12_3 = L12_3.tointeger
              L13_3 = tonumber
              L14_3 = L9_3.slot
              if not L14_3 then
                L14_3 = L8_3
              end
              L13_3, L14_3 = L13_3(L14_3)
              L12_3 = L12_3(L13_3, L14_3)
              L11_3.slot = L12_3
              L12_3 = L9_3.name
              L11_3.name = L12_3
              L12_3 = tonumber
              L13_3 = L9_3.count
              L12_3 = L12_3(L13_3)
              if not L12_3 then
                L12_3 = 1
              end
              L11_3.count = L12_3
              L12_3 = type
              L13_3 = L9_3.metadata
              L12_3 = L12_3(L13_3)
              if "table" == L12_3 then
                L12_3 = L9_3.metadata
                if L12_3 then
                  goto lbl_72
                end
              end
              L12_3 = {}
              ::lbl_72::
              L11_3.md = L12_3
              L1_3[L10_3] = L11_3
            end
          end
        end
      end
    else
      L2_3 = L5_2
      if "qb" == L2_3 then
        L2_3 = L10_2
        L3_3 = A0_3
        L2_3 = L2_3(L3_3)
        L3_3 = L2_3 or L3_3
        if L2_3 then
          L3_3 = L2_3.PlayerData
          L3_3 = L3_3.items
        end
        L4_3 = type
        L5_3 = L3_3
        L4_3 = L4_3(L5_3)
        if "table" == L4_3 then
          L4_3 = pairs
          L5_3 = L3_3
          L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
          for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
            L10_3 = type
            L11_3 = L9_3
            L10_3 = L10_3(L11_3)
            if "table" == L10_3 then
              L10_3 = L7_2
              L11_3 = L9_3.name
              L10_3 = L10_3(L11_3)
              if L10_3 then
                L10_3 = tonumber
                L11_3 = L9_3.amount
                if not L11_3 then
                  L11_3 = L9_3.count
                end
                L10_3 = L10_3(L11_3)
                if not L10_3 then
                  L10_3 = 0
                end
                if L10_3 > 0 then
                  L10_3 = #L1_3
                  L10_3 = L10_3 + 1
                  L11_3 = {}
                  L12_3 = math
                  L12_3 = L12_3.tointeger
                  L13_3 = tonumber
                  L14_3 = L9_3.slot
                  if not L14_3 then
                    L14_3 = L8_3
                  end
                  L13_3, L14_3 = L13_3(L14_3)
                  L12_3 = L12_3(L13_3, L14_3)
                  L11_3.slot = L12_3
                  L12_3 = L9_3.name
                  L11_3.name = L12_3
                  L12_3 = tonumber
                  L13_3 = L9_3.amount
                  if not L13_3 then
                    L13_3 = L9_3.count
                  end
                  L12_3 = L12_3(L13_3)
                  if not L12_3 then
                    L12_3 = 1
                  end
                  L11_3.count = L12_3
                  L12_3 = type
                  L13_3 = L9_3.info
                  L12_3 = L12_3(L13_3)
                  if "table" == L12_3 then
                    L12_3 = L9_3.info
                    if L12_3 then
                      goto lbl_155
                    end
                  end
                  L12_3 = {}
                  ::lbl_155::
                  L11_3.md = L12_3
                  L1_3[L10_3] = L11_3
                end
              end
            end
          end
        end
      end
    end
    ::lbl_160::
    L2_3 = table
    L2_3 = L2_3.sort
    L3_3 = L1_3
    function L4_3(A0_4, A1_4)
      local L2_4, L3_4
      L2_4 = A0_4.slot
      if not L2_4 then
        L2_4 = 9999
      end
      L3_4 = A1_4.slot
      if not L3_4 then
        L3_4 = 9999
      end
      L2_4 = L2_4 < L3_4
      return L2_4
    end
    L2_3(L3_3, L4_3)
    return L1_3
  end
  function L13_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = A0_3 or nil
    if A0_3 then
      L1_3 = A0_3.md
      if L1_3 then
        L1_3 = A0_3.md
        L1_3 = L1_3.apex_owner
      end
    end
    if nil == L1_3 or "" == L1_3 then
      L2_3 = nil
      return L2_3
    end
    L2_3 = tostring
    L3_3 = L1_3
    return L2_3(L3_3)
  end
  function L14_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = "APX-%04X-%04X-%04X"
    L1_3 = L0_3
    L0_3 = L0_3.format
    L2_3 = math
    L2_3 = L2_3.random
    L3_3 = 0
    L4_3 = 65535
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = math
    L3_3 = L3_3.random
    L4_3 = 0
    L5_3 = 65535
    L3_3 = L3_3(L4_3, L5_3)
    L4_3 = math
    L4_3 = L4_3.random
    L5_3 = 0
    L6_3 = 65535
    L4_3, L5_3, L6_3 = L4_3(L5_3, L6_3)
    return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
  end
  function L15_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L3_3 = L5_2
    if "ox" == L3_3 then
      L3_3 = pcall
      function L4_3()
        local L0_4, L1_4, L2_4, L3_4, L4_4
        L0_4 = exports
        L0_4 = L0_4.ox_inventory
        L1_4 = L0_4
        L0_4 = L0_4.SetMetadata
        L2_4 = A0_3
        L3_4 = A1_3.slot
        L4_4 = A2_3
        L0_4(L1_4, L2_4, L3_4, L4_4)
      end
      L3_3, L4_3 = L3_3(L4_3)
      if not L3_3 then
        L5_3 = L0_2
        L6_3 = "ox_inventory SetMetadata failed (%s)"
        L7_3 = L6_3
        L6_3 = L6_3.format
        L8_3 = tostring
        L9_3 = L4_3
        L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L8_3(L9_3)
        L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
        L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
        L5_3 = false
        return L5_3
      end
      A1_3.md = A2_3
      L5_3 = true
      return L5_3
    else
      L3_3 = L5_2
      if "qb" == L3_3 then
        L3_3 = L10_2
        L4_3 = A0_3
        L3_3 = L3_3(L4_3)
        L4_3 = L3_3 or L4_3
        if L3_3 then
          L4_3 = L3_3.PlayerData
          L4_3 = L4_3.items
        end
        L5_3 = type
        L6_3 = L4_3
        L5_3 = L5_3(L6_3)
        if "table" ~= L5_3 then
          L5_3 = false
          return L5_3
        end
        L5_3 = A1_3.slot
        L6_3 = A1_3.slot
        L6_3 = L4_3[L6_3]
        L7_3 = type
        L8_3 = L6_3
        L7_3 = L7_3(L8_3)
        if "table" == L7_3 then
          L7_3 = L6_3.name
          L8_3 = A1_3.name
          if L7_3 == L8_3 then
            goto lbl_86
          end
        end
        L6_3 = nil
        L7_3 = nil
        L5_3 = L7_3
        L7_3 = pairs
        L8_3 = L4_3
        L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
        for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
          L13_3 = type
          L14_3 = L12_3
          L13_3 = L13_3(L14_3)
          if "table" == L13_3 then
            L13_3 = L12_3.name
            L14_3 = A1_3.name
            if L13_3 == L14_3 then
              L13_3 = math
              L13_3 = L13_3.tointeger
              L14_3 = tonumber
              L15_3 = L12_3.slot
              if not L15_3 then
                L15_3 = L11_3
              end
              L14_3, L15_3 = L14_3(L15_3)
              L13_3 = L13_3(L14_3, L15_3)
              L14_3 = A1_3.slot
              if L13_3 == L14_3 then
                L13_3 = L11_3
                L6_3 = L12_3
                L5_3 = L13_3
                break
              end
            end
          end
        end
        ::lbl_86::
        if not L6_3 then
          L7_3 = false
          return L7_3
        end
        L6_3.info = A2_3
        L7_3 = pcall
        function L8_3()
          local L0_4, L1_4, L2_4
          L0_4 = L3_3.Functions
          L0_4 = L0_4.SetPlayerData
          if L0_4 then
            L0_4 = L3_3.Functions
            L0_4 = L0_4.SetPlayerData
            L1_4 = "items"
            L2_4 = L4_3
            L0_4(L1_4, L2_4)
          else
            L0_4 = L3_3.Functions
            L0_4 = L0_4.SetInventory
            if L0_4 then
              L0_4 = L3_3.Functions
              L0_4 = L0_4.SetInventory
              L1_4 = L4_3
              L0_4(L1_4)
            end
          end
        end
        L7_3, L8_3 = L7_3(L8_3)
        if not L7_3 then
          L9_3 = L0_2
          L10_3 = "qb-inventory: could not save the metadata (%s)"
          L11_3 = L10_3
          L10_3 = L10_3.format
          L12_3 = tostring
          L13_3 = L8_3
          L12_3, L13_3, L14_3, L15_3 = L12_3(L13_3)
          L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L10_3(L11_3, L12_3, L13_3, L14_3, L15_3)
          L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
          L9_3 = false
          return L9_3
        end
        A1_3.md = A2_3
        L9_3 = true
        return L9_3
      end
    end
    L3_3 = false
    return L3_3
  end
  function L16_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L3_3 = A1_3.count
    if not L3_3 then
      L3_3 = 1
    end
    if L3_3 > 1 then
      L3_3 = L1_2
      L4_3 = "slot %s holds %d devices: not stamping"
      L5_3 = tostring
      L6_3 = A1_3.slot
      L5_3 = L5_3(L6_3)
      L6_3 = A1_3.count
      L3_3(L4_3, L5_3, L6_3)
      L3_3 = false
      return L3_3
    end
    L3_3 = L11_2
    L4_3 = A1_3.md
    L3_3 = L3_3(L4_3)
    L3_3.apex_owner = A2_3
    L4_3 = GetNumberByCitizenId
    if L4_3 then
      L4_3 = GetNumberByCitizenId
      L5_3 = A2_3
      L4_3 = L4_3(L5_3)
      if L4_3 then
        goto lbl_29
      end
    end
    L4_3 = nil
    ::lbl_29::
    L3_3.apex_number = L4_3
    L4_3 = L3_3.apex_serial
    if not L4_3 then
      L4_3 = L14_2
      L4_3 = L4_3()
    end
    L3_3.apex_serial = L4_3
    L4_3 = L15_2
    L5_3 = A0_3
    L6_3 = A1_3
    L7_3 = L3_3
    L4_3 = L4_3(L5_3, L6_3, L7_3)
    L5_3 = L1_2
    L6_3 = "stamp %s slot %s -> %s (%s)"
    L7_3 = A1_3.name
    L8_3 = tostring
    L9_3 = A1_3.slot
    L8_3 = L8_3(L9_3)
    L9_3 = A2_3
    if L4_3 then
      L10_3 = "ok"
      if L10_3 then
        goto lbl_54
      end
    end
    L10_3 = "failed"
    ::lbl_54::
    L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
    return L4_3
  end
  function L17_2(A0_3, A1_3, A2_3, A3_3, A4_3)
    local L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L5_3 = L12_2
    L6_3 = A0_3
    L5_3 = L5_3(L6_3)
    L6_3 = #L5_3
    if 0 == L6_3 then
      L6_3 = nil
      return L6_3
    end
    if A3_3 then
      L6_3 = ipairs
      L7_3 = L5_3
      L6_3, L7_3, L8_3, L9_3 = L6_3(L7_3)
      for L10_3, L11_3 in L6_3, L7_3, L8_3, L9_3 do
        L12_3 = L11_3.slot
        if L12_3 == A3_3 then
          if A2_3 then
            L12_3 = L11_3.name
            if L12_3 ~= A2_3 then
              goto lbl_24
            end
          end
          return L11_3
        end
        ::lbl_24::
      end
    end
    function L6_3(A0_4)
      local L1_4, L2_4
      L1_4 = L13_2
      L2_4 = A0_4
      L1_4 = L1_4(L2_4)
      L2_4 = nil == L1_4
      return L2_4
    end
    L7_3 = ipairs
    L8_3 = L5_3
    L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
    for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
      if A2_3 then
        L13_3 = L12_3.name
        if L13_3 ~= A2_3 then
          goto lbl_43
        end
      end
      L13_3 = L6_3
      L14_3 = L12_3
      L13_3 = L13_3(L14_3)
      if L13_3 then
        return L12_3
      end
      ::lbl_43::
    end
    if not A4_3 then
      L7_3 = ipairs
      L8_3 = L5_3
      L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
      for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
        L13_3 = L6_3
        L14_3 = L12_3
        L13_3 = L13_3(L14_3)
        if L13_3 then
          return L12_3
        end
      end
    end
    L7_3 = ipairs
    L8_3 = L5_3
    L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
    for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
      if A2_3 then
        L13_3 = L12_3.name
        if L13_3 ~= A2_3 then
          goto lbl_71
        end
      end
      do return L12_3 end
      ::lbl_71::
    end
    if not A4_3 then
      L7_3 = L5_3[1]
      return L7_3
    end
    L7_3 = nil
    return L7_3
  end
  function L18_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A1_3.number
    if L2_3 then
      L3_3 = A1_3.number
      L2_3 = L3_2
      L2_3 = L2_3[L3_3]
      if L2_3 == A0_3 then
        L3_3 = A1_3.number
        L2_3 = L3_2
        L2_3[L3_3] = nil
      end
    end
    L3_3 = A1_3.cid
    L2_3 = L4_2
    L2_3 = L2_3[L3_3]
    if L2_3 == A0_3 then
      L3_3 = A1_3.cid
      L2_3 = L4_2
      L2_3[L3_3] = nil
    end
  end
  function L19_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L3_3 = L2_2
    L3_3 = L3_3[A0_3]
    if not L3_3 then
      L4_3 = false
      return L4_3
    end
    L4_3 = L2_2
    L4_3[A0_3] = nil
    L4_3 = L18_2
    L5_3 = A0_3
    L6_3 = L3_3
    L4_3(L5_3, L6_3)
    L4_3 = L8_2
    L4_3()
    L4_3 = L1_2
    L5_3 = "end of foreign session for %s (owner %s): %s"
    L6_3 = tostring
    L7_3 = A0_3
    L6_3 = L6_3(L7_3)
    L7_3 = L3_3.cid
    L8_3 = tostring
    L9_3 = A1_3
    L8_3, L9_3 = L8_3(L9_3)
    L4_3(L5_3, L6_3, L7_3, L8_3, L9_3)
    L4_3 = TriggerEvent
    L5_3 = "apex_phone:foreignSession"
    L6_3 = A0_3
    L7_3 = L3_3.cid
    L8_3 = false
    L4_3(L5_3, L6_3, L7_3, L8_3)
    if not A2_3 and "drop" ~= A1_3 then
      L4_3 = TriggerClientEvent
      L5_3 = "apex_phone:client:deviceSession"
      L6_3 = A0_3
      L7_3 = {}
      L7_3.mode = "own"
      L8_3 = L6_2
      L9_3 = A0_3
      L8_3 = L8_3(L9_3)
      L7_3.cid = L8_3
      L7_3.why = A1_3
      L4_3(L5_3, L6_3, L7_3)
    end
    L4_3 = true
    return L4_3
  end
  function L20_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L2_3 = L2_2
    L2_3 = L2_3[A0_3]
    if L2_3 then
      L3_3 = L18_2
      L4_3 = A0_3
      L5_3 = L2_3
      L3_3(L4_3, L5_3)
    end
    L3_3 = L2_2
    L3_3[A0_3] = A1_3
    L3_3 = A1_3.number
    if L3_3 then
      L4_3 = A1_3.number
      L3_3 = L3_2
      L3_3[L4_3] = A0_3
    end
    L4_3 = A1_3.cid
    L3_3 = L4_2
    L3_3[L4_3] = A0_3
    L3_3 = L8_2
    L3_3()
    L3_3 = L1_2
    L4_3 = "foreign session: %s opened the device of %s (%s, slot %s, PIN %s)"
    L5_3 = tostring
    L6_3 = A0_3
    L5_3 = L5_3(L6_3)
    L6_3 = A1_3.cid
    L7_3 = A1_3.item
    L8_3 = tostring
    L9_3 = A1_3.slot
    L8_3 = L8_3(L9_3)
    L9_3 = A1_3.locked
    if L9_3 then
      L9_3 = "required"
      if L9_3 then
        goto lbl_39
      end
    end
    L9_3 = "no"
    ::lbl_39::
    L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3)
    L3_3 = TriggerEvent
    L4_3 = "apex_phone:foreignSession"
    L5_3 = A0_3
    L6_3 = A1_3.cid
    L7_3 = true
    L3_3(L4_3, L5_3, L6_3, L7_3)
  end
  function L21_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = pcall
    function L2_3()
      local L0_4, L1_4
      L0_4 = Player
      L1_4 = A0_3
      L0_4 = L0_4(L1_4)
      L0_4 = L0_4.state
      L0_4 = L0_4.apex_inCall
      return L0_4
    end
    L1_3, L2_3 = L1_3(L2_3)
    L3_3 = L1_3 or L3_3
    L3_3 = L1_3 and nil ~= L2_3 and false ~= L2_3
    return L3_3
  end
  function L22_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L2_3 = A1_3.notified
    if L2_3 then
      return
    end
    A1_3.notified = true
    L2_3 = L0_1.notifyOwner
    if false ~= L2_3 then
      L2_3 = NotifyCitizen
      if L2_3 then
        L2_3 = pcall
        L3_3 = NotifyCitizen
        L4_3 = A1_3.cid
        L5_3 = "settings"
        L6_3 = "Telem\195\179vel desbloqueado"
        L7_3 = "O teu telem\195\179vel foi desbloqueado por outra pessoa."
        L8_3 = {}
        L8_3.kind = "device"
        L9_3 = A1_3.serial
        L8_3.serial = L9_3
        L9_3 = {}
        L9_3.__pending = true
        L9_3.throttle = false
        L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3)
      end
    end
    L2_3 = L0_1.notifyOwnerGame
    if L2_3 then
      L2_3 = FW
      L2_3 = L2_3.GetPlayerByCid
      L3_3 = A1_3.cid
      L2_3 = L2_3(L3_3)
      if L2_3 then
        L3_3 = L2_3.src
        if L3_3 then
          L3_3 = tonumber
          L4_3 = L2_3.src
          L3_3 = L3_3(L4_3)
          L4_3 = tonumber
          L5_3 = A0_3
          L4_3 = L4_3(L5_3)
          if L3_3 ~= L4_3 then
            L3_3 = FW
            L3_3 = L3_3.Notify
            L4_3 = L2_3.src
            L5_3 = "O teu telem\195\179vel foi desbloqueado por outra pessoa."
            L6_3 = "error"
            L3_3(L4_3, L5_3, L6_3)
          end
        end
      end
    end
    L2_3 = TriggerEvent
    L3_3 = "apex_phone:foreignUnlocked"
    L4_3 = A0_3
    L5_3 = A1_3.cid
    L2_3(L3_3, L4_3, L5_3)
  end
  function L23_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L2_3 = L6_2
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    L3_3 = A1_3.real
    if L2_3 ~= L3_3 then
      L2_3 = false
      L3_3 = "character"
      return L2_3, L3_3
    end
    L2_3 = ipairs
    L3_3 = L12_2
    L4_3 = A0_3
    L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3 = L3_3(L4_3)
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = L13_2
      L9_3 = L7_3
      L8_3 = L8_3(L9_3)
      L9_3 = A1_3.cid
      if L8_3 == L9_3 then
        L8_3 = A1_3.serial
        if L8_3 then
          L8_3 = L7_3.md
          L8_3 = L8_3.apex_serial
          if nil ~= L8_3 then
            L8_3 = L7_3.md
            L8_3 = L8_3.apex_serial
            L9_3 = A1_3.serial
            if L8_3 ~= L9_3 then
              goto lbl_40
            end
          end
        end
        L8_3 = L7_3.slot
        L9_3 = L7_3.name
        A1_3.item = L9_3
        A1_3.slot = L8_3
        L8_3 = true
        return L8_3
      end
      ::lbl_40::
    end
    L2_3 = false
    L3_3 = "lost"
    return L2_3, L3_3
  end
  function L24_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = Accounts
    if L1_3 then
      L1_3 = Accounts
      L1_3 = L1_3[A0_3]
    end
    if L1_3 then
      return L1_3
    end
    L2_3 = pcall
    L3_3 = MySQL
    L3_3 = L3_3.single
    L3_3 = L3_3.await
    L4_3 = "SELECT citizenid, username, phone, pin FROM apex_phone_accounts WHERE citizenid = ?"
    L5_3 = {}
    L6_3 = A0_3
    L5_3[1] = L6_3
    L2_3, L3_3 = L2_3(L3_3, L4_3, L5_3)
    L4_3 = L3_3 or L4_3
    if not L2_3 or not L3_3 then
      L4_3 = nil
    end
    return L4_3
  end
  L25_2 = {}
  L25_2["device.use"] = true
  L25_2["device.end"] = true
  L25_2["device.locate"] = true
  L25_2["account.get"] = true
  L25_2["player.get"] = true
  L26_2 = {}
  L26_2["account.verifyPin"] = true
  L26_2["notifs.list"] = true
  L26_2["earbuds.state"] = true
  L26_2["contacts.list"] = true
  L26_2["blocks.list"] = true
  L26_2["music.status"] = true
  L26_2["apps.grants"] = true
  L26_2["apps.registry"] = true
  L26_2["apps.installed"] = true
  L26_2["userdata.get"] = true
  L26_2["airdrop.set"] = true
  L26_2["messages.threads"] = true
  L26_2["mail.unread"] = true
  L26_2["calls.history"] = true
  L26_2["sim.lines"] = true
  L26_2["sim.config"] = true
  L26_2["presence.get"] = true
  L26_2["escrow.config"] = true
  L26_2["recado.extras.config"] = true
  L26_2["social.stories.config"] = true
  L27_2 = {}
  L28_2 = "bank."
  L29_2 = "bills."
  L30_2 = "crypto."
  L31_2 = "eats."
  L32_2 = "onion."
  L33_2 = "shop."
  L34_2 = "market."
  L35_2 = "services."
  L36_2 = "capps."
  L37_2 = "house."
  L27_2[1] = L28_2
  L27_2[2] = L29_2
  L27_2[3] = L30_2
  L27_2[4] = L31_2
  L27_2[5] = L32_2
  L27_2[6] = L33_2
  L27_2[7] = L34_2
  L27_2[8] = L35_2
  L27_2[9] = L36_2
  L27_2[10] = L37_2
  L28_2 = {}
  L29_2 = "account.update"
  L30_2 = "account.setPin"
  L31_2 = "account.setFace"
  L32_2 = "account.setAvatarPhoto"
  L33_2 = "account.swapSim"
  L34_2 = "account.reset"
  L35_2 = "account.create"
  L36_2 = "account.usernameFree"
  L37_2 = "apps.grant"
  L38_2 = "apps.revoke"
  L39_2 = "sim.preview"
  L40_2 = "sim.activate"
  L41_2 = "sim.switch"
  L42_2 = "sim.rename"
  L43_2 = "sim.remove"
  L44_2 = "recado.privacy.set"
  L45_2 = "match.deleteProfile"
  L46_2 = "findmy."
  L28_2[1] = L29_2
  L28_2[2] = L30_2
  L28_2[3] = L31_2
  L28_2[4] = L32_2
  L28_2[5] = L33_2
  L28_2[6] = L34_2
  L28_2[7] = L35_2
  L28_2[8] = L36_2
  L28_2[9] = L37_2
  L28_2[10] = L38_2
  L28_2[11] = L39_2
  L28_2[12] = L40_2
  L28_2[13] = L41_2
  L28_2[14] = L42_2
  L28_2[15] = L43_2
  L28_2[16] = L44_2
  L28_2[17] = L45_2
  L28_2[18] = L46_2
  L29_2 = {}
  L30_2 = "calls.start"
  L31_2 = "calls.accept"
  L32_2 = "recado.call.start"
  L33_2 = "recado.call.join"
  L34_2 = "recado.call.invite"
  L35_2 = "recado.call.schedule"
  L36_2 = "recado.call.link"
  L29_2[1] = L30_2
  L29_2[2] = L31_2
  L29_2[3] = L32_2
  L29_2[4] = L33_2
  L29_2[5] = L34_2
  L29_2[6] = L35_2
  L29_2[7] = L36_2
  L30_2 = {}
  L31_2 = "messages.send"
  L32_2 = "messages.edit"
  L33_2 = "messages.react"
  L34_2 = "recado.send"
  L35_2 = "recado.forward"
  L36_2 = "recado.status.reply"
  L37_2 = "recado.channel.post"
  L38_2 = "recado.group.create"
  L39_2 = "groups.create"
  L40_2 = "mail.send"
  L41_2 = "darkchat.send"
  L42_2 = "airdrop.send"
  L43_2 = "cshare.send"
  L30_2[1] = L31_2
  L30_2[2] = L32_2
  L30_2[3] = L33_2
  L30_2[4] = L34_2
  L30_2[5] = L35_2
  L30_2[6] = L36_2
  L30_2[7] = L37_2
  L30_2[8] = L38_2
  L30_2[9] = L39_2
  L30_2[10] = L40_2
  L30_2[11] = L41_2
  L30_2[12] = L42_2
  L30_2[13] = L43_2
  L31_2 = {}
  L32_2 = "social.post"
  L33_2 = "social.comment"
  L34_2 = "social.like"
  L35_2 = "social.follow"
  L36_2 = "social.story.add"
  L37_2 = "social.story.answer"
  L38_2 = "social.instant.add"
  L39_2 = "social.instant.react"
  L40_2 = "social.updateProfile"
  L41_2 = "social.createProfile"
  L42_2 = "social.deletePost"
  L43_2 = "recado.status.add"
  L44_2 = "recado.profile.set"
  L45_2 = "match.swipe"
  L46_2 = "match.updateProfile"
  L47_2 = "match.createProfile"
  L31_2[1] = L32_2
  L31_2[2] = L33_2
  L31_2[3] = L34_2
  L31_2[4] = L35_2
  L31_2[5] = L36_2
  L31_2[6] = L37_2
  L31_2[7] = L38_2
  L31_2[8] = L39_2
  L31_2[9] = L40_2
  L31_2[10] = L41_2
  L31_2[11] = L42_2
  L31_2[12] = L43_2
  L31_2[13] = L44_2
  L31_2[14] = L45_2
  L31_2[15] = L46_2
  L31_2[16] = L47_2
  L32_2 = {}
  L33_2 = {}
  L34_2 = {}
  function L35_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L1_3 = ipairs
    L2_3 = A0_3 or L2_3
    if not A0_3 then
      L2_3 = {}
    end
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = type
      L8_3 = L6_3
      L7_3 = L7_3(L8_3)
      if "string" == L7_3 and "" ~= L6_3 then
        L8_3 = L6_3
        L7_3 = L6_3.sub
        L9_3 = -1
        L7_3 = L7_3(L8_3, L9_3)
        if "." == L7_3 then
          L7_3 = L33_2
          L7_3 = #L7_3
          L8_3 = L7_3 + 1
          L7_3 = L33_2
          L7_3[L8_3] = L6_3
        else
          L7_3 = L32_2
          L7_3[L6_3] = true
        end
      end
    end
  end
  L36_2 = L0_1.blockMoney
  if false ~= L36_2 then
    L36_2 = L35_2
    L37_2 = L27_2
    L36_2(L37_2)
  end
  L36_2 = L35_2
  L37_2 = L28_2
  L36_2(L37_2)
  L36_2 = L0_1.allowCalls
  if false == L36_2 then
    L36_2 = L35_2
    L37_2 = L29_2
    L36_2(L37_2)
  end
  L36_2 = L0_1.allowSendMessages
  if false == L36_2 then
    L36_2 = L35_2
    L37_2 = L30_2
    L36_2(L37_2)
  end
  L36_2 = L0_1.allowSocial
  if false == L36_2 then
    L36_2 = L35_2
    L37_2 = L31_2
    L36_2(L37_2)
  end
  L36_2 = L35_2
  L37_2 = type
  L38_2 = L0_1.blocked
  L37_2 = L37_2(L38_2)
  if "table" == L37_2 then
    L37_2 = L0_1.blocked
    if L37_2 then
      goto lbl_183
    end
  end
  L37_2 = nil
  ::lbl_183::
  L36_2(L37_2)
  L36_2 = ipairs
  L37_2 = type
  L38_2 = L0_1.allowed
  L37_2 = L37_2(L38_2)
  if "table" == L37_2 then
    L37_2 = L0_1.allowed
    if L37_2 then
      goto lbl_195
    end
  end
  L37_2 = {}
  ::lbl_195::
  L36_2, L37_2, L38_2, L39_2 = L36_2(L37_2)
  for L40_2, L41_2 in L36_2, L37_2, L38_2, L39_2 do
    L42_2 = type
    L43_2 = L41_2
    L42_2 = L42_2(L43_2)
    if "string" == L42_2 then
      L34_2[L41_2] = true
    end
  end
  function L36_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L1_3 = L34_2
    L1_3 = L1_3[A0_3]
    if L1_3 then
      L1_3 = false
      return L1_3
    end
    L1_3 = L32_2
    L1_3 = L1_3[A0_3]
    if L1_3 then
      L1_3 = true
      return L1_3
    end
    L1_3 = 1
    L2_3 = L33_2
    L2_3 = #L2_3
    L3_3 = 1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = L33_2
      L5_3 = L5_3[L4_3]
      L7_3 = A0_3
      L6_3 = A0_3.sub
      L8_3 = 1
      L9_3 = #L5_3
      L6_3 = L6_3(L7_3, L8_3, L9_3)
      if L6_3 == L5_3 then
        L6_3 = true
        return L6_3
      end
    end
    L1_3 = false
    return L1_3
  end
  DeviceIsBlocked = L36_2
  L37_2 = {}
  function L38_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L2_3 = L2_2
    L2_3 = L2_3[A0_3]
    if L2_3 then
      L3_3 = L25_2
      L3_3 = L3_3[A1_3]
      if not L3_3 then
        goto lbl_11
      end
    end
    L3_3 = nil
    do return L3_3 end
    ::lbl_11::
    L3_3 = GetGameTimer
    L3_3 = L3_3()
    L4_3 = L37_2
    L4_3 = L4_3[A0_3]
    if L4_3 then
      L4_3 = L37_2
      L4_3 = L4_3[A0_3]
      L4_3 = L3_3 - L4_3
      L5_3 = 1000
      if not (L4_3 > L5_3) then
        goto lbl_41
      end
    end
    L4_3 = L37_2
    L4_3[A0_3] = L3_3
    L4_3 = L23_2
    L5_3 = A0_3
    L6_3 = L2_3
    L4_3, L5_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L6_3 = L19_2
      L7_3 = A0_3
      L8_3 = L5_3
      L6_3(L7_3, L8_3)
      L6_3 = {}
      L6_3.ok = false
      L6_3.error = "foreign"
      return L6_3
    end
    ::lbl_41::
    if "account.verifyPin" == A1_3 then
      L4_3 = L2_3.pinFree
      if L4_3 then
        L4_3 = L22_2
        L5_3 = A0_3
        L6_3 = L2_3
        L4_3(L5_3, L6_3)
        L4_3 = {}
        L4_3.ok = true
        return L4_3
      end
      L4_3 = nil
      return L4_3
    end
    L4_3 = L2_3.locked
    if L4_3 then
      L4_3 = L26_2
      L4_3 = L4_3[A1_3]
      if not L4_3 then
        L4_3 = L1_1
        if L4_3 then
          L4_3 = L2_1
          L4_3 = L4_3[A1_3]
          if L4_3 then
            goto lbl_75
          end
        end
        L4_3 = {}
        L4_3.ok = false
        L4_3.error = "locked"
        return L4_3
      end
    end
    ::lbl_75::
    L4_3 = L36_2
    L5_3 = A1_3
    L4_3 = L4_3(L5_3)
    if L4_3 then
      L4_3 = L1_2
      L5_3 = "%s blocked in the foreign session of %s"
      L6_3 = A1_3
      L7_3 = tostring
      L8_3 = A0_3
      L7_3, L8_3 = L7_3(L8_3)
      L4_3(L5_3, L6_3, L7_3, L8_3)
      L4_3 = {}
      L4_3.ok = false
      L4_3.error = "foreign"
      return L4_3
    end
    L4_3 = nil
    return L4_3
  end
  DeviceGuard = L38_2
  function L38_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3
    if "account.verifyPin" ~= A1_3 then
      return
    end
    L3_3 = L2_2
    L3_3 = L3_3[A0_3]
    if L3_3 then
      L4_3 = L3_3.locked
      if L4_3 then
        goto lbl_12
      end
    end
    do return end
    ::lbl_12::
    L4_3 = type
    L5_3 = A2_3
    L4_3 = L4_3(L5_3)
    if "table" == L4_3 then
      L4_3 = A2_3.ok
      if true == L4_3 then
        L3_3.locked = false
        L4_3 = L1_2
        L5_3 = "%s entered the correct PIN for the device of %s"
        L6_3 = tostring
        L7_3 = A0_3
        L6_3 = L6_3(L7_3)
        L7_3 = L3_3.cid
        L4_3(L5_3, L6_3, L7_3)
        L4_3 = L22_2
        L5_3 = A0_3
        L6_3 = L3_3
        L4_3(L5_3, L6_3)
      end
    end
  end
  DeviceAfterRpc = L38_2
  function L38_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = L2_2
    L2_3 = L2_3[A0_3]
    if L2_3 then
      L3_3 = type
      L4_3 = A1_3
      L3_3 = L3_3(L4_3)
      if "table" == L3_3 then
        goto lbl_11
      end
    end
    do return A1_3 end
    ::lbl_11::
    A1_3.foreign = true
    L3_3 = L2_3.pinFree
    if L3_3 then
      A1_3.hasPin = false
      A1_3.pinLen = 0
    end
    return A1_3
  end
  DeviceAccountView = L38_2
  function L38_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = L3_2
    L1_3 = L1_3[A0_3]
    if not L1_3 then
      L2_3 = nil
      return L2_3
    end
    L2_3 = L2_2
    L2_3 = L2_3[L1_3]
    if L2_3 then
      L3_3 = L2_3.number
      if L3_3 == A0_3 then
        goto lbl_18
      end
    end
    L3_3 = L3_2
    L3_3[A0_3] = nil
    L3_3 = nil
    do return L3_3 end
    ::lbl_18::
    L3_3 = L0_1.routeIncoming
    if false ~= L3_3 then
      return L1_3
    end
    L3_3 = FW
    L3_3 = L3_3.GetPlayerByCid
    L4_3 = L2_3.cid
    L3_3 = L3_3(L4_3)
    if L3_3 then
      L4_3 = tonumber
      L5_3 = L3_3.src
      L4_3 = L4_3(L5_3)
      if L4_3 then
        goto lbl_34
      end
    end
    L4_3 = false
    ::lbl_34::
    return L4_3
  end
  DeviceHolderByNumber = L38_2
  function L38_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = L0_1.routeIncoming
    if false == L1_3 or nil == A0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = tostring
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L2_3 = L4_2
    L1_3 = L2_3[L1_3]
    if L1_3 then
      L2_3 = L2_2
      L2_3 = L2_3[L1_3]
      if L2_3 then
        L2_3 = L2_2
        L2_3 = L2_3[L1_3]
        L2_3 = L2_3.cid
        L3_3 = tostring
        L4_3 = A0_3
        L3_3 = L3_3(L4_3)
        if L2_3 == L3_3 then
          return L1_3
        end
      end
    end
    L2_3 = nil
    return L2_3
  end
  DeviceHolderByCid = L38_2
  function L38_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = L2_2
    L2_3 = L2_3[A0_3]
    if not L2_3 then
      L3_3 = nil
      return L3_3
    end
    L3_3 = type
    L4_3 = A1_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = A1_3.__cid
      if nil ~= L3_3 then
        L3_3 = tostring
        L4_3 = A1_3.__cid
        L3_3 = L3_3(L4_3)
        if L3_3 then
          goto lbl_21
        end
      end
    end
    L3_3 = nil
    ::lbl_21::
    L4_3 = type
    L5_3 = A1_3
    L4_3 = L4_3(L5_3)
    if "table" == L4_3 then
      L4_3 = A1_3.__pending
      if L4_3 and L3_3 then
        return L3_3
      end
    end
    L4_3 = L2_3.cid
    if L3_3 == L4_3 then
      L4_3 = nil
      return L4_3
    end
    L4_3 = L3_3 or L4_3
    if not L3_3 then
      L4_3 = L2_3.real
    end
    return L4_3
  end
  DeviceNotifyTarget = L38_2
  L38_2 = "notsetup"
  L39_2 = "nopin"
  L40_2 = RPC
  function L41_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if "table" ~= L2_3 or not A1_3 then
      L2_3 = {}
      A1_3 = L2_3
    end
    L2_3 = L6_2
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L3_3 = {}
      L3_3.ok = false
      L3_3.error = "noplayer"
      return L3_3
    end
    L3_3 = L5_2
    if false == L3_3 then
      L3_3 = {}
      L3_3.ok = true
      L3_3.mode = "own"
      L3_3.cid = L2_3
      L3_3.off = true
      return L3_3
    end
    L3_3 = L5_2
    if not L3_3 then
      L3_3 = {}
      L3_3.ok = true
      L3_3.mode = "own"
      L3_3.cid = L2_3
      return L3_3
    end
    L3_3 = L7_2
    L4_3 = A1_3.item
    L3_3 = L3_3(L4_3)
    if L3_3 then
      L3_3 = A1_3.item
      if L3_3 then
        goto lbl_49
      end
    end
    L3_3 = nil
    ::lbl_49::
    L4_3 = math
    L4_3 = L4_3.tointeger
    L5_3 = tonumber
    L6_3 = A1_3.slot
    L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3 = L5_3(L6_3)
    L4_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
    L5_3 = A1_3.force
    if true == L5_3 then
      L5_3 = L19_2
      L6_3 = A0_3
      L7_3 = "force"
      L8_3 = true
      L5_3(L6_3, L7_3, L8_3)
      L5_3 = {}
      L5_3.ok = true
      L5_3.mode = "own"
      L5_3.cid = L2_3
      L5_3.item = L3_3
      return L5_3
    end
    L5_3 = L17_2
    L6_3 = A0_3
    L7_3 = L2_3
    L8_3 = L3_3
    L9_3 = L4_3
    L10_3 = A1_3.use
    L10_3 = true == L10_3
    L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
    if not L5_3 then
      L6_3 = L19_2
      L7_3 = A0_3
      L8_3 = "none"
      L9_3 = true
      L6_3(L7_3, L8_3, L9_3)
      L6_3 = {}
      L6_3.ok = true
      L6_3.mode = "own"
      L6_3.cid = L2_3
      L6_3.item = L3_3
      return L6_3
    end
    L6_3 = L13_2
    L7_3 = L5_3
    L6_3 = L6_3(L7_3)
    if not L6_3 then
      L7_3 = L16_2
      L8_3 = A0_3
      L9_3 = L5_3
      L10_3 = L2_3
      L7_3(L8_3, L9_3, L10_3)
      L6_3 = L2_3
    end
    if L6_3 == L2_3 then
      L7_3 = L19_2
      L8_3 = A0_3
      L9_3 = "own"
      L10_3 = true
      L7_3(L8_3, L9_3, L10_3)
      L7_3 = L1_1
      if not L7_3 then
        L7_3 = GetNumberByCitizenId
        if L7_3 then
          L7_3 = GetNumberByCitizenId
          L8_3 = L2_3
          L7_3 = L7_3(L8_3)
          if L7_3 then
            goto lbl_125
          end
        end
      end
      L7_3 = nil
      ::lbl_125::
      if L7_3 then
        L8_3 = L5_3.md
        L8_3 = L8_3.apex_number
        if L8_3 ~= L7_3 then
          L8_3 = L5_3.count
          if not L8_3 then
            L8_3 = 1
          end
          if 1 == L8_3 then
            L8_3 = L11_2
            L9_3 = L5_3.md
            L8_3 = L8_3(L9_3)
            L8_3.apex_number = L7_3
            L9_3 = L15_2
            L10_3 = A0_3
            L11_3 = L5_3
            L12_3 = L8_3
            L9_3(L10_3, L11_3, L12_3)
          end
        end
      end
      L8_3 = {}
      L8_3.ok = true
      L8_3.mode = "own"
      L8_3.cid = L2_3
      L9_3 = L5_3.name
      L8_3.item = L9_3
      L9_3 = L5_3.slot
      L8_3.slot = L9_3
      return L8_3
    end
    L7_3 = L2_2
    L7_3 = L7_3[A0_3]
    if L7_3 then
      L8_3 = L7_3.cid
      if L8_3 == L6_3 then
        L8_3 = L7_3.slot
        L9_3 = L5_3.slot
        if L8_3 == L9_3 then
          L7_3.endAfterCall = nil
          L8_3 = {}
          L8_3.ok = true
          L8_3.mode = "foreign"
          L8_3.cid = L6_3
          L9_3 = L5_3.name
          L8_3.item = L9_3
          L9_3 = L5_3.slot
          L8_3.slot = L9_3
          L9_3 = L7_3.locked
          L8_3.locked = L9_3
          return L8_3
        end
      end
    end
    L8_3 = L24_2
    L9_3 = L6_3
    L8_3 = L8_3(L9_3)
    if L8_3 then
      L9_3 = L8_3.username
      if L9_3 then
        L9_3 = L8_3.username
        if "" ~= L9_3 then
          goto lbl_204
        end
      end
    end
    L9_3 = L19_2
    L10_3 = A0_3
    L11_3 = "notsetup"
    L12_3 = true
    L9_3(L10_3, L11_3, L12_3)
    L9_3 = {}
    L9_3.ok = false
    L10_3 = L38_2
    L9_3.error = L10_3
    L10_3 = L5_3.name
    L9_3.item = L10_3
    do return L9_3 end
    ::lbl_204::
    L9_3 = L8_3.pin
    L9_3 = nil ~= L9_3
    if not L9_3 then
      L10_3 = L0_1.allowWhenNoPin
      if false == L10_3 then
        L10_3 = L19_2
        L11_3 = A0_3
        L12_3 = "nopin"
        L13_3 = true
        L10_3(L11_3, L12_3, L13_3)
        L10_3 = {}
        L10_3.ok = false
        L11_3 = L39_2
        L10_3.error = L11_3
        L11_3 = L5_3.name
        L10_3.item = L11_3
        return L10_3
      end
    end
    L10_3 = L9_3 or L10_3
    if L9_3 then
      L10_3 = L0_1.requirePin
      L10_3 = false ~= L10_3
    end
    L11_3 = {}
    L11_3.cid = L6_3
    L11_3.real = L2_3
    L12_3 = L8_3.phone
    if L12_3 then
      L12_3 = L8_3.phone
      if "" ~= L12_3 then
        L12_3 = tostring
        L13_3 = L8_3.phone
        L12_3 = L12_3(L13_3)
        if L12_3 then
          goto lbl_255
        end
      end
    end
    L12_3 = nil
    ::lbl_255::
    L11_3.number = L12_3
    L12_3 = L5_3.slot
    L11_3.slot = L12_3
    L12_3 = L5_3.name
    L11_3.item = L12_3
    L12_3 = L5_3.md
    L12_3 = L12_3.apex_serial
    L11_3.serial = L12_3
    L11_3.locked = L10_3
    L12_3 = not L10_3
    L11_3.pinFree = L12_3
    L12_3 = os
    L12_3 = L12_3.time
    L12_3 = L12_3()
    L11_3.at = L12_3
    L11_3.needPin = L10_3
    L12_3 = L20_2
    L13_3 = A0_3
    L14_3 = L11_3
    L12_3(L13_3, L14_3)
    L12_3 = L37_2
    L13_3 = GetGameTimer
    L13_3 = L13_3()
    L12_3[A0_3] = L13_3
    if not L10_3 then
      L12_3 = L22_2
      L13_3 = A0_3
      L14_3 = L11_3
      L12_3(L13_3, L14_3)
    end
    L12_3 = {}
    L12_3.ok = true
    L12_3.mode = "foreign"
    L12_3.cid = L6_3
    L13_3 = L5_3.name
    L12_3.item = L13_3
    L13_3 = L5_3.slot
    L12_3.slot = L13_3
    L12_3.locked = L10_3
    return L12_3
  end
  L40_2["device.use"] = L41_2
  function L40_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = Accounts
    if L1_3 then
      L1_3 = Accounts
      L2_3 = A0_3.cid
      L1_3 = L1_3[L2_3]
    end
    if L1_3 then
      L2_3 = type
      L3_3 = L1_3.settings
      L2_3 = L2_3(L3_3)
      if "table" == L2_3 then
        L2_3 = L1_3.settings
        if L2_3 then
          goto lbl_18
        end
      end
    end
    L2_3 = nil
    ::lbl_18::
    L3_3 = A0_3.needPin
    if L3_3 then
      if L2_3 then
        L3_3 = L2_3.lockOnClose
        if false == L3_3 then
          goto lbl_27
        end
      end
      A0_3.locked = true
    end
    ::lbl_27::
  end
  L41_2 = RPC
  function L42_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = L6_2
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L2_3 = L2_2
    L2_3 = L2_3[A0_3]
    if L2_3 then
      L3_3 = L1_1
      if L3_3 then
        L3_3 = L40_2
        L4_3 = L2_3
        L3_3(L4_3)
        L3_3 = {}
        L3_3.ok = true
        L3_3.mode = "foreign"
        L4_3 = L2_3.cid
        L3_3.cid = L4_3
        L3_3.kept = true
        return L3_3
      end
    end
    if L2_3 then
      L3_3 = L21_2
      L4_3 = A0_3
      L3_3 = L3_3(L4_3)
      if L3_3 then
        L2_3.endAfterCall = true
        L3_3 = {}
        L3_3.ok = true
        L3_3.deferred = true
        return L3_3
      end
    end
    L3_3 = L19_2
    L4_3 = A0_3
    L5_3 = "closed"
    L6_3 = true
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = {}
    L3_3.ok = true
    L3_3.mode = "own"
    L3_3.cid = L1_3
    return L3_3
  end
  L41_2["device.end"] = L42_2
  function L41_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3
    L2_3 = {}
    L3_3 = L5_2
    if not L3_3 or not A0_3 then
      return L2_3
    end
    L3_3 = tostring
    L4_3 = A0_3
    L3_3 = L3_3(L4_3)
    A0_3 = L3_3
    L3_3 = ipairs
    L4_3 = FW
    L4_3 = L4_3.GetPlayers
    L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3 = L4_3()
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      if L8_3 ~= A1_3 then
        L9_3 = ipairs
        L10_3 = L12_2
        L11_3 = L8_3
        L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3 = L10_3(L11_3)
        L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3)
        for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
          L15_3 = L13_2
          L16_3 = L14_3
          L15_3 = L15_3(L16_3)
          if L15_3 == A0_3 then
            L15_3 = nil
            L16_3 = pcall
            function L17_3()
              local L0_4, L1_4, L2_4, L3_4, L4_4
              L0_4 = GetPlayerPed
              L1_4 = L8_3
              L0_4 = L0_4(L1_4)
              if L0_4 and 0 ~= L0_4 then
                L1_4 = GetEntityCoords
                L2_4 = L0_4
                L1_4 = L1_4(L2_4)
                L2_4 = {}
                L3_4 = math
                L3_4 = L3_4.floor
                L4_4 = L1_4.x
                L4_4 = L4_4 * 10
                L4_4 = L4_4 + 0.5
                L3_4 = L3_4(L4_4)
                L3_4 = L3_4 / 10
                L2_4.x = L3_4
                L3_4 = math
                L3_4 = L3_4.floor
                L4_4 = L1_4.y
                L4_4 = L4_4 * 10
                L4_4 = L4_4 + 0.5
                L3_4 = L3_4(L4_4)
                L3_4 = L3_4 / 10
                L2_4.y = L3_4
                L3_4 = math
                L3_4 = L3_4.floor
                L4_4 = L1_4.z
                L4_4 = L4_4 * 10
                L4_4 = L4_4 + 0.5
                L3_4 = L3_4(L4_4)
                L3_4 = L3_4 / 10
                L2_4.z = L3_4
                L15_3 = L2_4
              end
            end
            L16_3(L17_3)
            L16_3 = Config
            L16_3 = L16_3.Devices
            L17_3 = L14_3.name
            L16_3 = L16_3[L17_3]
            if not L16_3 then
              L16_3 = {}
            end
            L17_3 = #L2_3
            L17_3 = L17_3 + 1
            L18_3 = {}
            L19_3 = L14_3.name
            L18_3.item = L19_3
            L19_3 = L16_3.label
            if not L19_3 then
              L19_3 = L14_3.name
            end
            L18_3.label = L19_3
            L19_3 = L14_3.md
            L19_3 = L19_3.apex_serial
            L18_3.serial = L19_3
            L19_3 = L15_3 or L19_3
            if L15_3 then
              L19_3 = L15_3.x
            end
            L18_3.x = L19_3
            L19_3 = L15_3 or L19_3
            if L15_3 then
              L19_3 = L15_3.y
            end
            L18_3.y = L19_3
            L19_3 = L15_3 or L19_3
            if L15_3 then
              L19_3 = L15_3.z
            end
            L18_3.z = L19_3
            L19_3 = L2_2
            L19_3 = L19_3[L8_3]
            L19_3 = nil ~= L19_3
            L18_3.open = L19_3
            L2_3[L17_3] = L18_3
          end
        end
      end
    end
    return L2_3
  end
  L42_2 = RPC
  function L43_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = GetCid
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L2_3 = {}
      L2_3.ok = false
      L2_3.error = "noplayer"
      return L2_3
    end
    L2_3 = {}
    L2_3.ok = true
    L3_3 = L41_2
    L4_3 = L1_3
    L5_3 = A0_3
    L3_3 = L3_3(L4_3, L5_3)
    L2_3.devices = L3_3
    return L2_3
  end
  L42_2["device.locate"] = L43_2
  L42_2 = exports
  L43_2 = "GetDeviceOwner"
  function L44_2(A0_3)
    local L1_3, L2_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = -1
    end
    L2_3 = L2_2
    L1_3 = L2_3[L1_3]
    if L1_3 then
      L2_3 = L1_3.cid
      if L2_3 then
        goto lbl_15
      end
    end
    L2_3 = nil
    ::lbl_15::
    return L2_3
  end
  L42_2(L43_2, L44_2)
  L42_2 = exports
  L43_2 = "GetDeviceLocations"
  function L44_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L41_2
    L2_3 = A0_3
    L3_3 = nil
    return L1_3(L2_3, L3_3)
  end
  L42_2(L43_2, L44_2)
  L42_2 = exports
  L43_2 = "GetDeviceSerial"
  function L44_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    A0_3 = L1_3
    if not A0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = L2_2
    L1_3 = L1_3[A0_3]
    if L1_3 then
      L2_3 = L1_3.serial
      if L2_3 then
        L2_3 = L1_3.serial
        return L2_3
      end
    end
    L2_3 = L5_2
    if not L2_3 then
      L2_3 = nil
      return L2_3
    end
    L2_3 = GetPhoneState
    if L2_3 then
      L2_3 = GetPhoneState
      L3_3 = A0_3
      L2_3 = L2_3(L3_3)
      if L2_3 then
        goto lbl_32
      end
    end
    L2_3 = nil
    ::lbl_32::
    if L2_3 then
      L3_3 = L2_3.device
      if L3_3 then
        goto lbl_45
      end
    end
    L3_3 = LastDevice
    if L3_3 then
      L3_3 = LastDevice
      L3_3 = L3_3[A0_3]
      if L3_3 then
        goto lbl_45
      end
    end
    L3_3 = nil
    ::lbl_45::
    L4_3 = nil
    L5_3 = ipairs
    L6_3 = L12_2
    L7_3 = A0_3
    L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L6_3(L7_3)
    L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
      L11_3 = L10_3.md
      if L11_3 then
        L11_3 = L10_3.md
        L11_3 = L11_3.apex_serial
      end
      if L11_3 then
        if L3_3 then
          L12_3 = L10_3.name
          if L12_3 == L3_3 then
            return L11_3
          end
        end
        if not L4_3 then
          L4_3 = L11_3
        end
      end
    end
    return L4_3
  end
  L42_2(L43_2, L44_2)
  L42_2 = AddEventHandler
  L43_2 = "apex_phone:phoneClosed"
  function L44_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    A0_3 = L1_3
    L1_3 = A0_3 or L1_3
    if A0_3 then
      L1_3 = L2_2
      L1_3 = L1_3[A0_3]
    end
    if not L1_3 then
      return
    end
    L2_3 = L1_1
    if L2_3 then
      L2_3 = L40_2
      L3_3 = L1_3
      L2_3(L3_3)
      return
    end
    L2_3 = L21_2
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if L2_3 then
      L1_3.endAfterCall = true
      return
    end
    L2_3 = L19_2
    L3_3 = A0_3
    L4_3 = "closed"
    L5_3 = true
    L2_3(L3_3, L4_3, L5_3)
  end
  L42_2(L43_2, L44_2)
  L42_2 = AddEventHandler
  L43_2 = "apex_phone:callEnded"
  function L44_2()
    local L0_3, L1_3, L2_3
    L0_3 = SetTimeout
    L1_3 = 500
    function L2_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4
      L0_4 = pairs
      L1_4 = L2_2
      L0_4, L1_4, L2_4, L3_4 = L0_4(L1_4)
      for L4_4, L5_4 in L0_4, L1_4, L2_4, L3_4 do
        L6_4 = L5_4.endAfterCall
        if L6_4 then
          L6_4 = L21_2
          L7_4 = L4_4
          L6_4 = L6_4(L7_4)
          if not L6_4 then
            L6_4 = L19_2
            L7_4 = L4_4
            L8_4 = "callended"
            L6_4(L7_4, L8_4)
          end
        end
      end
    end
    L0_3(L1_3, L2_3)
  end
  L42_2(L43_2, L44_2)
  L42_2 = AddEventHandler
  L43_2 = "playerDropped"
  function L44_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = tonumber
    L1_3 = source
    L0_3 = L0_3(L1_3)
    if L0_3 then
      L1_3 = L2_2
      L1_3 = L1_3[L0_3]
      if L1_3 then
        L1_3 = L19_2
        L2_3 = L0_3
        L3_3 = "drop"
        L4_3 = true
        L1_3(L2_3, L3_3, L4_3)
      end
    end
    if L0_3 then
      L1_3 = L37_2
      L1_3[L0_3] = nil
    end
  end
  L42_2(L43_2, L44_2)
  L42_2 = CreateThread
  function L43_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    while true do
      L0_3 = Wait
      L1_3 = 3000
      L0_3(L1_3)
      L0_3 = next
      L1_3 = L2_2
      L0_3 = L0_3(L1_3)
      if L0_3 then
        L0_3 = pairs
        L1_3 = L2_2
        L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
        for L4_3, L5_3 in L0_3, L1_3, L2_3, L3_3 do
          L6_3 = L23_2
          L7_3 = L4_3
          L8_3 = L5_3
          L6_3, L7_3 = L6_3(L7_3, L8_3)
          if not L6_3 then
            L8_3 = L19_2
            L9_3 = L4_3
            L10_3 = L7_3
            L8_3(L9_3, L10_3)
          end
        end
      end
    end
  end
  L42_2(L43_2)
  function L42_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = false
    L5_2 = L1_3
    L1_3 = L0_2
    L2_3 = A0_3
    L3_3 = " The feature stays OFF (the phone works as usual)."
    L2_3 = L2_3 .. L3_3
    L1_3(L2_3)
    L1_3 = nil
    L2_3 = nil
    L3_3 = nil
    DeviceAccountView = nil
    DeviceAfterRpc = L3_3
    DeviceGuard = L2_3
    DeviceSessions = L1_3
    L1_3 = nil
    L2_3 = nil
    DeviceNotifyTarget = nil
    DeviceHolderByCid = L2_3
    DeviceHolderByNumber = L1_3
  end
  L43_2 = CreateThread
  function L44_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = 0
    while true do
      L1_3 = FW
      L1_3 = L1_3.ready
      if not (not L1_3 and L0_3 < 120) then
        break
      end
      L1_3 = Wait
      L2_3 = 500
      L1_3(L2_3)
      L0_3 = L0_3 + 1
    end
    L1_3 = FW
    L1_3 = L1_3.ready
    if not L1_3 then
      L1_3 = L42_2
      L2_3 = "the framework did not start."
      L1_3(L2_3)
      return
    end
    L1_3 = FW
    L1_3 = L1_3.InventoryName
    L1_3 = L1_3()
    if "ox_inventory" == L1_3 then
      L2_3 = "ox"
      L5_2 = L2_3
    else
      if "qb" == L1_3 then
        L2_3 = FW
        L2_3 = L2_3.name
        if "qb" == L2_3 then
          L2_3 = ipairs
          L3_3 = {}
          L4_3 = "qb-inventory"
          L5_3 = "ps-inventory"
          L6_3 = "lj-inventory"
          L3_3[1] = L4_3
          L3_3[2] = L5_3
          L3_3[3] = L6_3
          L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
          for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
            L8_3 = GetResourceState
            L9_3 = L7_3
            L8_3 = L8_3(L9_3)
            if "started" == L8_3 then
              L8_3 = "qb"
              L5_2 = L8_3
              break
            end
          end
          L2_3 = L5_2
          if not L2_3 then
            L2_3 = L42_2
            L3_3 = "the QBCore inventory is not qb-inventory/ps-inventory/lj-inventory (no per-slot metadata)."
            L2_3(L3_3)
            return
          end
      end
      else
        L2_3 = L42_2
        L3_3 = "the inventory (%s) does not store per-slot metadata; it needs ox_inventory or qb-inventory."
        L4_3 = L3_3
        L3_3 = L3_3.format
        L5_3 = tostring
        L6_3 = L1_3 or L6_3
        if not L1_3 then
          L6_3 = "nenhum"
        end
        L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L5_3(L6_3)
        L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
        L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
        return
      end
    end
    L2_3 = print
    L3_3 = "^2[unique_phone]^0 other person's phone: ON (%s, PIN %s, no-PIN devices %s, messages %s, calls %s)"
    L4_3 = L3_3
    L3_3 = L3_3.format
    L5_3 = L5_2
    if "ox" == L5_3 then
      L5_3 = "ox_inventory"
      if L5_3 then
        goto lbl_85
      end
    end
    L5_3 = "qb-inventory"
    ::lbl_85::
    L6_3 = L0_1.requirePin
    if false ~= L6_3 then
      L6_3 = "required"
      if L6_3 then
        goto lbl_92
      end
    end
    L6_3 = "not required"
    ::lbl_92::
    L7_3 = L0_1.allowWhenNoPin
    if false ~= L7_3 then
      L7_3 = "open"
      if L7_3 then
        goto lbl_99
      end
    end
    L7_3 = "do not open"
    ::lbl_99::
    L8_3 = L0_1.allowSendMessages
    if false ~= L8_3 then
      L8_3 = "yes"
      if L8_3 then
        goto lbl_106
      end
    end
    L8_3 = "no"
    ::lbl_106::
    L9_3 = L0_1.allowCalls
    if false ~= L9_3 then
      L9_3 = "yes"
      if L9_3 then
        goto lbl_113
      end
    end
    L9_3 = "no"
    ::lbl_113::
    L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3)
    L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    L2_3 = L5_2
    if "qb" == L2_3 then
      L2_3 = Wait
      L3_3 = 1500
      L2_3(L3_3)
      L2_3 = L10_2
      L3_3 = -1
      L2_3 = L2_3(L3_3)
      if not L2_3 then
        L2_3 = L9_2
        if not L2_3 then
          return
        end
      end
      L2_3 = pairs
      L3_3 = Config
      L3_3 = L3_3.Devices
      if not L3_3 then
        L3_3 = {}
      end
      L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
      for L6_3 in L2_3, L3_3, L4_3, L5_3 do
        L7_3 = pcall
        L8_3 = L9_2.Functions
        L8_3 = L8_3.CreateUseableItem
        L9_3 = L6_3
        function L10_3(A0_4, A1_4)
          local L2_4, L3_4, L4_4, L5_4, L6_4, L7_4
          L2_4 = type
          L3_4 = A1_4
          L2_4 = L2_4(L3_4)
          if "table" == L2_4 then
            L2_4 = math
            L2_4 = L2_4.tointeger
            L3_4 = tonumber
            L4_4 = A1_4.slot
            L3_4, L4_4, L5_4, L6_4, L7_4 = L3_4(L4_4)
            L2_4 = L2_4(L3_4, L4_4, L5_4, L6_4, L7_4)
            if L2_4 then
              goto lbl_15
            end
          end
          L2_4 = nil
          ::lbl_15::
          L3_4 = TriggerClientEvent
          L4_4 = "apex_phone:client:useDevice"
          L5_4 = A0_4
          L6_4 = L6_3
          L7_4 = L2_4
          L3_4(L4_4, L5_4, L6_4, L7_4)
        end
        L7_3(L8_3, L9_3, L10_3)
      end
    end
  end
  L43_2(L44_2)
  L43_2 = {}
  function L44_2()
    local L0_3, L1_3
    L0_3 = L5_2
    return L0_3
  end
  L43_2.inv = L44_2
  function L44_2(A0_3)
    local L1_3, L2_3
    L1_3 = L12_2
    L2_3 = A0_3
    return L1_3(L2_3)
  end
  L43_2.slots = L44_2
  L43_2.ownerOf = L13_2
  L43_2.writeMeta = L15_2
  L43_2.stamp = L16_2
  L43_2.newSerial = L14_2
  L43_2.realCid = L6_2
  L43_2.copy = L11_2
  L43_2.qbPlayer = L10_2
  function L44_2(A0_3)
    local L1_3
    L1_3 = L2_2
    L1_3 = L1_3[A0_3]
    return L1_3
  end
  L43_2.session = L44_2
  L43_2.endSession = L19_2
  DeviceOwnerAPI = L43_2
end
L4_1 = false
function L5_1(A0_2)
  local L1_2
  if "psim" == A0_2 then
    L1_2 = true
    L1_1 = L1_2
  end
  L1_2 = L4_1
  if L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = true
  L4_1 = L1_2
  L1_2 = L0_1
  if not L1_2 then
    L1_2 = {}
  end
  L0_1 = L1_2
  L1_2 = L3_1
  L1_2()
  L1_2 = true
  return L1_2
end
DeviceOwnerActivate = L5_1
if L0_1 then
  L5_1 = L0_1.enabled
  if true == L5_1 then
    L5_1 = DeviceOwnerActivate
    L5_1()
  end
end
