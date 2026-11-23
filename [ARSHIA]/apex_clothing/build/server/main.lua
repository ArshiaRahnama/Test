local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1
L0_1 = Apex
L0_1 = L0_1.RegisterCallback
L1_1 = "perm:check"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = Apex
  L2_2 = L2_2.IsAllowed
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = Access
    L3_2 = L3_2.PrintDenial
    L4_2 = A0_2
    L5_2 = "apex_clothing"
    L3_2(L4_2, L5_2)
  end
  L3_2 = A1_2
  L4_2 = L2_2
  L3_2(L4_2)
end
L0_1(L1_1, L2_1)
L0_1 = exports
L1_1 = "OpenFor"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if A0_2 then
    L1_2 = Apex
    L1_2 = L1_2.IsAllowed
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_15
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_15::
  L1_2 = TriggerClientEvent
  L2_2 = "apex_clothing:open"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
  L1_2 = true
  return L1_2
end
L0_1(L1_1, L2_1)
L0_1 = exports
L1_1 = "IsAllowed"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = Apex
  L1_2 = L1_2.IsAllowed
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  return L1_2(L2_2)
end
L0_1(L1_1, L2_1)
L0_1 = CreateThread
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = Wait
  L1_2 = 500
  L0_2(L1_2)
  L0_2 = GetCurrentResourceName
  L0_2 = L0_2()
  L1_2 = GetResourceMetadata
  L2_2 = L0_2
  L3_2 = "version"
  L4_2 = 0
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L1_2 = "?"
  end
  L2_2 = print
  L3_2 = "^5[apex_clothing]^7 Apex Clothing Studio ^5v%s^7 - framework: ^5%s^7"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L1_2
  L6_2 = Bridge
  L6_2 = L6_2.framework
  if not L6_2 then
    L6_2 = "unknown"
  end
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L2_2 = Config
  L2_2 = L2_2.ai
  if L2_2 then
    L2_2 = Config
    L2_2 = L2_2.ai
    L2_2 = L2_2.enabled
    if L2_2 then
      L2_2 = GetConvar
      L3_2 = "apex_clothing_ai_key"
      L4_2 = ""
      L2_2 = L2_2(L3_2, L4_2)
      if "" == L2_2 then
        L3_2 = Config
        L3_2 = L3_2.ai
        L3_2 = L3_2.apiKey
        L2_2 = L3_2 or L2_2
        if not L3_2 then
          L2_2 = ""
        end
      end
      if "" == L2_2 then
        L3_2 = Utils
        L3_2 = L3_2.Warn
        L4_2 = "AI texture generation is enabled but no API key is set - "
        L5_2 = "set the apex_clothing_ai_key convar or Config.ai.apiKey"
        L4_2 = L4_2 .. L5_2
        L3_2(L4_2)
      else
        L3_2 = Utils
        L3_2 = L3_2.Log
        L4_2 = "AI provider \"%s\" configured"
        L5_2 = L4_2
        L4_2 = L4_2.format
        L6_2 = Config
        L6_2 = L6_2.ai
        L6_2 = L6_2.provider
        if not L6_2 then
          L6_2 = "?"
        end
        L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2, L6_2)
        L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
      end
    end
  end
  L2_2 = ipairs
  L3_2 = Access
  L3_2 = L3_2.Summary
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2()
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = print
    L9_2 = "^5[apex_clothing]^7 %s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L7_2
    L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2)
    L8_2(L9_2, L10_2, L11_2)
  end
  L2_2 = print
  L3_2 = "^5[apex_clothing]^7 locked out? run /%s_access in-game"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = Config
  L5_2 = L5_2.command
  if not L5_2 then
    L5_2 = "clothingstudio"
  end
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2(L4_2, L5_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
end
L0_1(L1_1)
L0_1 = Config
L0_1 = L0_1.command
if not L0_1 then
  L0_1 = "clothingstudio"
end
L1_1 = "_access"
L0_1 = L0_1 .. L1_1
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = GetPlayerName
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = "id "
    L2_2 = tostring
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    L1_2 = L1_2 .. L2_2
  end
  L2_2 = print
  L3_2 = "^5[apex_clothing]^7 \226\149\144\226\149\144 access report for ^5"
  L4_2 = L1_2
  L5_2 = "^7 (id "
  L6_2 = A0_2
  L7_2 = ") \226\149\144\226\149\144"
  L3_2 = L3_2 .. L4_2 .. L5_2 .. L6_2 .. L7_2
  L2_2(L3_2)
  L2_2 = Access
  L2_2 = L2_2.Check
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = print
  L4_2 = "^5[apex_clothing]^7 verdict: %s"
  L5_2 = L4_2
  L4_2 = L4_2.format
  if L2_2 then
    L6_2 = "^2ALLOWED^7"
    if L6_2 then
      goto lbl_32
    end
  end
  L6_2 = "^1DENIED^7"
  ::lbl_32::
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L3_2 = ipairs
  L4_2 = Access
  L4_2 = L4_2.Explain
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = nil
    L10_2 = L8_2.enabled
    if not L10_2 then
      L9_2 = "^8off^7"
    else
      L10_2 = L8_2.pass
      if L10_2 then
        L10_2 = "^2PASS^7"
        L11_2 = L8_2.detail
        if L11_2 then
          L11_2 = " - "
          L12_2 = L8_2.detail
          L11_2 = L11_2 .. L12_2
          if L11_2 then
            goto lbl_60
          end
        end
        L11_2 = ""
        ::lbl_60::
        L10_2 = L10_2 .. L11_2
        L9_2 = L10_2
      else
        L9_2 = "^1no^7"
      end
    end
    L10_2 = print
    L11_2 = "^5[apex_clothing]^7   %-12s %s"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L8_2.method
    L14_2 = L9_2
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2)
    L10_2(L11_2, L12_2, L13_2, L14_2)
  end
  L3_2 = print
  L4_2 = "^5[apex_clothing]^7 your identifiers (paste into identifiers.list):"
  L3_2(L4_2)
  L3_2 = ipairs
  L4_2 = Access
  L4_2 = L4_2.Identifiers
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = print
    L10_2 = "^5[apex_clothing]^7     '%s',"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L8_2
    L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
  end
  L3_2 = print
  L4_2 = "^5[apex_clothing]^7 \226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144"
  L3_2(L4_2)
  return L2_2
end
L2_1 = RegisterCommand
L3_1 = L0_1
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = A0_2
  if 0 == A0_2 then
    L3_2 = tonumber
    L4_2 = A1_2[1]
    if not L4_2 then
      L4_2 = ""
    end
    L3_2 = L3_2(L4_2)
    L2_2 = L3_2
    if not L2_2 then
      L3_2 = print
      L4_2 = "^1[apex_clothing]^7 usage: %s <server id>"
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = L0_1
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
      return L3_2(L4_2, L5_2, L6_2, L7_2)
    end
  end
  L3_2 = L1_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if 0 ~= A0_2 then
    L4_2 = Apex
    L4_2 = L4_2.Notify
    L5_2 = A0_2
    if L3_2 then
      L6_2 = "#access_report_allowed"
      if L6_2 then
        goto lbl_34
      end
    end
    L6_2 = "#access_report_denied"
    ::lbl_34::
    if L3_2 then
      L7_2 = "success"
      if L7_2 then
        goto lbl_40
      end
    end
    L7_2 = "error"
    ::lbl_40::
    L4_2(L5_2, L6_2, L7_2)
  end
end
L5_1 = false
L2_1(L3_1, L4_1, L5_1)
