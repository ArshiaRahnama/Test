local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1
L0_1 = PhoneIntegrations
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if nil ~= A0_2 then
    L2_2 = tostring
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_9
      A0_2 = L2_2 or A0_2
    end
  end
  A0_2 = ""
  ::lbl_9::
  if A1_2 then
    L3_2 = A0_2
    L2_2 = A0_2.sub
    L4_2 = 1
    L5_2 = A1_2
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      goto lbl_18
    end
  end
  L2_2 = A0_2
  ::lbl_18::
  return L2_2
end
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "vector3" ~= L1_2 then
      L1_2 = nil
      return L1_2
    end
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
  if not L1_2 or not L2_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = vector3
  L5_2 = L1_2 + 0.0
  L6_2 = L2_2 + 0.0
  L7_2 = L3_2 or L7_2
  if not L3_2 then
    L7_2 = 0.0
  end
  L7_2 = L7_2 + 0.0
  return L4_2(L5_2, L6_2, L7_2)
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L6_2] = L7_2
  end
  return L1_2
end
L4_1 = {}
L4_1.police = true
L4_1.sheriff = true
L4_1.lspd = true
L4_1.bcso = true
L4_1.sasp = true
L4_1.sast = true
L4_1.state = true
L4_1.statepolice = true
L4_1.fib = true
L4_1.ranger = true
L4_1.trooper = true
L4_1.leo = true
L5_1 = {}
L5_1.ambulance = true
L5_1.ems = true
L5_1.doctor = true
L5_1.fire = true
L5_1.firefighter = true
L5_1.safd = true
L5_1.lsfd = true
L5_1.medic = true
L5_1.paramedic = true
L5_1.hospital = true
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = tostring
  L2_2 = A0_2.job
  if not L2_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L4_1
  L1_2 = L2_2[L1_2]
  if L1_2 then
    L1_2 = "police"
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2.job
  if not L2_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L5_1
  L1_2 = L2_2[L1_2]
  if L1_2 then
    L1_2 = "ems"
    return L1_2
  end
  L1_2 = ipairs
  L2_2 = A0_2.jobs
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L4_1
    L7_2 = L7_2[L6_2]
    if L7_2 then
      L7_2 = "police"
      return L7_2
    end
    L7_2 = L5_1
    L7_2 = L7_2[L6_2]
    if L7_2 then
      L7_2 = "ems"
      return L7_2
    end
  end
  L1_2 = nil
  return L1_2
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L1_1
  L2_2 = A0_2.caller
  L3_2 = 60
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = A0_2.phone
  if L2_2 then
    L2_2 = L1_1
    L3_2 = A0_2.phone
    L2_2 = L2_2(L3_2)
    if "" ~= L2_2 then
      if "" ~= L1_2 then
        L2_2 = L1_2
        L3_2 = " \194\183 "
        L2_2 = L2_2 .. L3_2
        if L2_2 then
          goto lbl_21
        end
      end
      L2_2 = ""
      ::lbl_21::
      L3_2 = L1_1
      L4_2 = A0_2.phone
      L5_2 = 20
      L3_2 = L3_2(L4_2, L5_2)
      L2_2 = L2_2 .. L3_2
      L1_2 = L2_2
    end
  end
  return L1_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L7_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_1
  L3_2 = A0_2.message
  L4_2 = 300
  L2_2 = L2_2(L3_2, L4_2)
  if "" == L2_2 then
    return L1_2
  end
  if "" ~= L1_2 then
    L3_2 = L2_2
    L4_2 = " ("
    L5_2 = L1_2
    L6_2 = ")"
    L3_2 = L3_2 .. L4_2 .. L5_2 .. L6_2
    if L3_2 then
      goto lbl_21
    end
  end
  L3_2 = L2_2
  ::lbl_21::
  return L3_2
end
L0_1.dispatchBody = L8_1
function L9_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L1_1
  L2_2 = A0_2.label
  L3_2 = 60
  return L1_2(L2_2, L3_2)
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L1_1
  L2_2 = A0_2.street
  L3_2 = 80
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L1_2 or L2_2
  if "" == L1_2 or not L1_2 then
    L2_2 = nil
  end
  return L2_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2.jobs
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = pcall
    L10_2 = FW
    L10_2 = L10_2.GetJobPlayers
    L11_2 = L8_2
    L9_2, L10_2 = L9_2(L10_2, L11_2)
    L11_2 = ipairs
    if L9_2 then
      L12_2 = type
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 and L10_2 then
        goto lbl_30
        L12_2 = L10_2 or L12_2
      end
    end
    L12_2 = {}
    ::lbl_30::
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = L1_2[L16_2]
      if not L17_2 then
        L1_2[L16_2] = true
        L17_2 = #L2_2
        L17_2 = L17_2 + 1
        L2_2[L17_2] = L16_2
      end
    end
  end
  return L2_2
end
function L12_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = table
  L2_2 = L2_2.pack
  L3_2 = L0_1.callExport
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2, L7_2, L8_2, L9_2 = ...
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L3_2 = L2_2[1]
  if not L3_2 then
    L3_2 = error
    L4_2 = "%s:%s %s"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = tostring
    L9_2 = L2_2[2]
    L8_2, L9_2 = L8_2(L9_2)
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    L5_2 = 0
    L3_2(L4_2, L5_2)
  end
  L3_2 = table
  L3_2 = L3_2.unpack
  L4_2 = L2_2
  L5_2 = 2
  L6_2 = L2_2.n
  return L3_2(L4_2, L5_2, L6_2)
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L0_1.readResourceTable
  L2_2 = "apex_mdt"
  L3_2 = "shared/config.lua"
  L4_2 = "Config.jobs"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = tostring
    L3_2 = A0_2.job
    if not L3_2 then
      L3_2 = ""
    end
    L2_2 = L2_2(L3_2)
    L2_2 = L1_2[L2_2]
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L2_2.mode
      if "police" ~= L3_2 then
        L3_2 = L2_2.mode
        if "ems" ~= L3_2 then
          goto lbl_31
        end
      end
      L3_2 = L2_2.mode
      return L3_2
    end
    ::lbl_31::
    L3_2 = ipairs
    L4_2 = A0_2.jobs
    if not L4_2 then
      L4_2 = {}
    end
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L2_2 = L1_2[L8_2]
      L9_2 = type
      L10_2 = L2_2
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = L2_2.mode
        if "police" ~= L9_2 then
          L9_2 = L2_2.mode
          if "ems" ~= L9_2 then
            goto lbl_53
          end
        end
        L9_2 = L2_2.mode
        return L9_2
      end
      ::lbl_53::
    end
  end
  L2_2 = L6_1
  L3_2 = A0_2
  return L2_2(L3_2)
end
L14_1 = L0_1.define
L15_1 = "dispatch"
L16_1 = "apex_mdt"
L17_1 = {}
L17_1.label = "Apex MDT (CAD calls)"
L18_1 = {}
L19_1 = "apex_mdt"
L18_1[1] = L19_1
L17_1.resources = L18_1
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L13_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = "apex_mdt"
  L5_2 = "CreateCall"
  L6_2 = {}
  L6_2.mode = L2_2
  L6_2.type = "phone"
  L7_2 = L1_1
  L8_2 = A1_2.code
  L9_2 = 20
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.code = L7_2
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.label = L7_2
  L6_2.priority = "medium"
  L7_2 = L8_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.desc = L7_2
  L7_2 = L10_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = A1_2.phone
    if L7_2 then
      L7_2 = "Tel. "
      L8_2 = L1_1
      L9_2 = A1_2.phone
      L10_2 = 20
      L8_2 = L8_2(L9_2, L10_2)
      L7_2 = L7_2 .. L8_2
      if L7_2 then
        goto lbl_46
      end
    end
    L7_2 = "GPS"
  end
  ::lbl_46::
  L6_2.location = L7_2
  L7_2 = A1_2.coords
  L6_2.coords = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.caller
  L9_2 = 60
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.caller = L7_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = nil ~= L3_2
  return L4_2
end
L17_1.alert = L18_1
L14_1(L15_1, L16_1, L17_1)
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = {}
  L2_2 = L9_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2.message = L2_2
  L1_2.codeName = "911call"
  L2_2 = L1_1
  L3_2 = A0_2.code
  L4_2 = 10
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.code = L2_2
  L1_2.icon = "fas fa-phone"
  L1_2.priority = 2
  L2_2 = L2_1
  L3_2 = A0_2.coords
  L2_2 = L2_2(L3_2)
  L1_2.coords = L2_2
  L2_2 = L10_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = ""
  end
  L1_2.street = L2_2
  L2_2 = L1_1
  L3_2 = A0_2.caller
  L4_2 = 60
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.name = L2_2
  L2_2 = L1_1
  L3_2 = A0_2.phone
  L4_2 = 20
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.number = L2_2
  L2_2 = L1_1
  L3_2 = A0_2.message
  L4_2 = 256
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.information = L2_2
  L2_2 = L3_1
  L3_2 = A0_2.jobs
  L2_2 = L2_2(L3_2)
  L1_2.jobs = L2_2
  L2_2 = {}
  L2_2.radius = 0
  L2_2.sprite = 480
  L2_2.color = 1
  L2_2.scale = 1.2
  L2_2.length = 2
  L2_2.sound = "Lose_1st"
  L2_2.sound2 = "GTAO_FM_Events_Soundset"
  L2_2.offset = false
  L2_2.flash = false
  L1_2.alert = L2_2
  return L1_2
end
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "ps-dispatch"
L18_1 = {}
L18_1.label = "ps-dispatch"
L19_1 = {}
L20_1 = "ps-dispatch"
L19_1[1] = L20_1
L18_1.resources = L19_1
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = L14_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2.coords
  if not L3_2 then
    L3_2 = false
    return L3_2
  end
  L2_2.addToList = true
  L3_2 = L11_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = ipairs
    L5_2 = GetPlayers
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2()
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = #L3_2
      L10_2 = L10_2 + 1
      L11_2 = tonumber
      L12_2 = L9_2
      L11_2 = L11_2(L12_2)
      L3_2[L10_2] = L11_2
    end
  end
  L4_2 = L0_1.callExport
  L5_2 = "ps-dispatch"
  L6_2 = "SendTargetedAlert"
  L7_2 = L3_2
  L8_2 = L2_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if L4_2 then
    L6_2 = false ~= L5_2
    return L6_2
  end
  L6_2 = tostring
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.find
  L8_2 = "No such export"
  L9_2 = 1
  L10_2 = true
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  if L6_2 then
    L2_2.addToList = nil
    L6_2 = TriggerEvent
    L7_2 = "ps-dispatch:server:notify"
    L8_2 = L2_2
    L6_2(L7_2, L8_2)
    L6_2 = true
    return L6_2
  end
  L6_2 = error
  L7_2 = tostring
  L8_2 = L5_2
  L7_2 = L7_2(L8_2)
  L8_2 = 0
  L6_2(L7_2, L8_2)
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "cd_dispatch"
L18_1 = {}
L18_1.label = "cd_dispatch"
L19_1 = {}
L20_1 = "cd_dispatch"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = TriggerClientEvent
  L4_2 = "cd_dispatch:AddNotification"
  L5_2 = -1
  L6_2 = {}
  L7_2 = L3_1
  L8_2 = A1_2.jobs
  L7_2 = L7_2(L8_2)
  L6_2.job_table = L7_2
  L6_2.coords = L2_2
  L7_2 = L1_1
  L8_2 = A1_2.code
  L9_2 = 10
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = " - "
  L9_2 = L9_1
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L7_2 = L7_2 .. L8_2 .. L9_2
  L6_2.title = L7_2
  L7_2 = L8_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.message = L7_2
  L6_2.flash = 0
  L7_2 = "apexphone"
  L8_2 = tostring
  L9_2 = A1_2.id
  if not L9_2 then
    L9_2 = math
    L9_2 = L9_2.random
    L10_2 = 1000000
    L11_2 = 9999999
    L9_2 = L9_2(L10_2, L11_2)
  end
  L8_2 = L8_2(L9_2)
  L7_2 = L7_2 .. L8_2
  L6_2.unique_id = L7_2
  L6_2.sound = 1
  L7_2 = {}
  L7_2.sprite = 480
  L7_2.scale = 1.2
  L7_2.colour = 3
  L7_2.flashes = false
  L8_2 = L1_1
  L9_2 = A1_2.code
  L10_2 = 10
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = " - "
  L10_2 = L9_1
  L11_2 = A1_2
  L10_2 = L10_2(L11_2)
  L8_2 = L8_2 .. L9_2 .. L10_2
  L7_2.text = L8_2
  L7_2.time = 5
  L7_2.radius = 0
  L6_2.blip = L7_2
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = true
  return L3_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "qs-dispatch"
L18_1 = {}
L18_1.label = "qs-dispatch"
L19_1 = {}
L20_1 = "qs-dispatch"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = L7_1
  L6_2 = A1_2
  L5_2 = L5_2(L6_2)
  L4_2.text = L5_2
  L4_2.icon = "fas fa-phone"
  L3_2[1] = L4_2
  L4_2 = L10_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = #L3_2
    L4_2 = L4_2 + 1
    L5_2 = {}
    L6_2 = L10_1
    L7_2 = A1_2
    L6_2 = L6_2(L7_2)
    L5_2.text = L6_2
    L5_2.icon = "fas fa-location-dot"
    L3_2[L4_2] = L5_2
  end
  L4_2 = TriggerEvent
  L5_2 = "qs-dispatch:server:CreateDispatchCall"
  L6_2 = {}
  L7_2 = L3_1
  L8_2 = A1_2.jobs
  L7_2 = L7_2(L8_2)
  L6_2.job = L7_2
  L6_2.callLocation = L2_2
  L7_2 = {}
  L8_2 = L1_1
  L9_2 = A1_2.code
  L10_2 = 10
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.code = L8_2
  L8_2 = L9_1
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L7_2.snippet = L8_2
  L6_2.callCode = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.message
  L9_2 = 300
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.message = L7_2
  L6_2.flashes = false
  L6_2.image = nil
  L7_2 = {}
  L7_2.sprite = 480
  L7_2.scale = 1.2
  L7_2.colour = 3
  L7_2.flashes = false
  L8_2 = L9_1
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L7_2.text = L8_2
  L7_2.time = 300000
  L6_2.blip = L7_2
  L6_2.otherData = L3_2
  L4_2(L5_2, L6_2)
  L4_2 = true
  return L4_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "rcore_dispatch"
L18_1 = {}
L18_1.label = "rcore_dispatch"
L19_1 = {}
L20_1 = "rcore_dispatch"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = TriggerEvent
  L4_2 = "rcore_dispatch:server:sendAlert"
  L5_2 = {}
  L6_2 = L1_1
  L7_2 = A1_2.code
  L8_2 = 10
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.code = L6_2
  L5_2.default_priority = "medium"
  L5_2.coords = L2_2
  L6_2 = L3_1
  L7_2 = A1_2.jobs
  L6_2 = L6_2(L7_2)
  L5_2.job = L6_2
  L6_2 = L9_1
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  L7_2 = ": "
  L8_2 = L8_1
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L6_2 = L6_2 .. L7_2 .. L8_2
  L5_2.text = L6_2
  L5_2.type = "alerts"
  L5_2.blip_time = 300
  L6_2 = {}
  L6_2.sprite = 480
  L6_2.colour = 3
  L6_2.scale = 1.0
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.text = L7_2
  L6_2.flashes = false
  L6_2.radius = 0
  L5_2.blip = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "core_dispatch"
L18_1 = {}
L18_1.label = "core_dispatch"
L19_1 = {}
L20_1 = "core_dispatch"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L4_2.icon = "fa-user"
  L5_2 = L1_1
  L6_2 = A1_2.caller
  L7_2 = 60
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.info = L5_2
  L5_2 = {}
  L5_2.icon = "fa-phone"
  L6_2 = L1_1
  L7_2 = A1_2.phone
  L8_2 = 20
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.info = L6_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L4_2 = L10_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = #L3_2
    L4_2 = L4_2 + 1
    L5_2 = {}
    L5_2.icon = "fa-location-dot"
    L6_2 = L10_1
    L7_2 = A1_2
    L6_2 = L6_2(L7_2)
    L5_2.info = L6_2
    L3_2[L4_2] = L5_2
  end
  L4_2 = L12_1
  L5_2 = "core_dispatch"
  L6_2 = "sendAlert"
  L7_2 = {}
  L8_2 = L1_1
  L9_2 = A1_2.code
  L10_2 = 10
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.code = L8_2
  L8_2 = L9_1
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L9_2 = ": "
  L10_2 = L1_1
  L11_2 = A1_2.message
  L12_2 = 300
  L10_2 = L10_2(L11_2, L12_2)
  L8_2 = L8_2 .. L9_2 .. L10_2
  L7_2.message = L8_2
  L7_2.extraInfo = L3_2
  L7_2.coords = L2_2
  L7_2.priority = false
  L8_2 = L3_1
  L9_2 = A1_2.jobs
  L8_2 = L8_2(L9_2)
  L7_2.job = L8_2
  L7_2.time = 8000
  L7_2.blip = 480
  L7_2.color = 3
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = true
  return L4_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "tk_dispatch"
L18_1 = {}
L18_1.label = "tk_dispatch"
L19_1 = {}
L20_1 = "tk_dispatch"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = "tk_dispatch"
  L5_2 = "addCall"
  L6_2 = {}
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.title = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.code
  L9_2 = 10
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.code = L7_2
  L6_2.priority = "Priority 2"
  L7_2 = L1_1
  L8_2 = A1_2.message
  L9_2 = 300
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.message = L7_2
  L6_2.coords = L2_2
  L7_2 = L10_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.location = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.caller
  L9_2 = 60
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.person = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.phone
  L9_2 = 20
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.phoneNumber = L7_2
  L6_2.removeTime = 600000
  L6_2.showTime = 8000
  L6_2.playSound = true
  L7_2 = L3_1
  L8_2 = A1_2.jobs
  L7_2 = L7_2(L8_2)
  L6_2.jobs = L7_2
  L7_2 = {}
  L7_2.sprite = 480
  L7_2.scale = 1.0
  L7_2.color = 3
  L7_2.flash = false
  L7_2.display = 4
  L7_2.shortRange = false
  L7_2.radius = 0
  L6_2.blip = L7_2
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = true
  return L3_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "linden_outlawalert"
L18_1 = {}
L18_1.label = "linden_outlawalert"
L19_1 = {}
L20_1 = "linden_outlawalert"
L19_1[1] = L20_1
L18_1.resources = L19_1
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = TriggerEvent
  L4_2 = "wf-alerts:svNotify"
  L5_2 = {}
  L6_2 = {}
  L7_2 = L1_1
  L8_2 = A1_2.code
  L9_2 = 10
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.displayCode = L7_2
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.description = L7_2
  L6_2.isImportant = 0
  L7_2 = L3_1
  L8_2 = A1_2.jobs
  L7_2 = L7_2(L8_2)
  L6_2.recipientList = L7_2
  L6_2.length = "13000"
  L6_2.infoM = "fa-phone"
  L7_2 = L1_1
  L8_2 = A1_2.message
  L9_2 = 300
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.info = L7_2
  L6_2.infoM2 = "fa-user"
  L7_2 = L7_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.info2 = L7_2
  L6_2.blipSprite = 480
  L6_2.blipColour = 84
  L6_2.blipScale = 1.5
  L5_2.dispatchData = L6_2
  L6_2 = L7_1
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  L5_2.caller = L6_2
  L5_2.coords = L2_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "lb-tablet"
L18_1 = {}
L18_1.label = "lb-tablet"
L19_1 = {}
L20_1 = "lb-tablet"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = "lb-tablet"
  L5_2 = "AddDispatch"
  L6_2 = {}
  L6_2.priority = "medium"
  L7_2 = L1_1
  L8_2 = A1_2.code
  L9_2 = 10
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.code = L7_2
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.title = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.message
  L9_2 = 300
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.description = L7_2
  L7_2 = {}
  L8_2 = L10_1
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = "GPS"
  end
  L7_2.label = L8_2
  L8_2 = vector2
  L9_2 = L2_2.x
  L10_2 = L2_2.y
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.coords = L8_2
  L6_2.location = L7_2
  L6_2.time = 300
  L7_2 = L3_1
  L8_2 = A1_2.jobs
  L7_2 = L7_2(L8_2)
  L6_2.job = L7_2
  L7_2 = {}
  L8_2 = {}
  L8_2.icon = "fa-solid fa-user"
  L8_2.label = "Caller"
  L9_2 = L1_1
  L10_2 = A1_2.caller
  L11_2 = 60
  L9_2 = L9_2(L10_2, L11_2)
  L8_2.value = L9_2
  L9_2 = {}
  L9_2.icon = "fa-solid fa-phone"
  L9_2.label = "Phone"
  L10_2 = L1_1
  L11_2 = A1_2.phone
  L12_2 = 20
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.value = L10_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L6_2.fields = L7_2
  L7_2 = {}
  L7_2.sprite = 480
  L7_2.color = 3
  L7_2.size = 1.0
  L8_2 = L9_1
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L7_2.label = L8_2
  L7_2.shortRange = false
  L6_2.blip = L7_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = false ~= L3_2 and nil ~= L3_2
  return L4_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "kartik-mdt"
L18_1 = {}
L18_1.label = "kartik-mdt (V2)"
L19_1 = {}
L20_1 = "kartik-mdt"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = "kartik-mdt"
  L5_2 = "CreateCall"
  L6_2 = {}
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.title = L7_2
  L7_2 = L8_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.description = L7_2
  L6_2.coords = L2_2
  L6_2.isPanic = false
  L7_2 = L3_1
  L8_2 = A1_2.jobs
  L7_2 = L7_2(L8_2)
  L6_2.job = L7_2
  L7_2 = L10_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.street = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.caller
  L9_2 = 60
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.person = L7_2
  L7_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = nil ~= L3_2 and false ~= L3_2
  return L4_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "origen_police"
L18_1 = {}
L18_1.label = "origen_police"
L19_1 = {}
L20_1 = "origen_police"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = "origen_police"
  L5_2 = "SendAlert"
  L6_2 = {}
  L6_2.coords = L2_2
  L7_2 = L1_1
  L8_2 = A1_2.code
  L9_2 = 10
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = " - "
  L9_2 = L9_1
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L7_2 = L7_2 .. L8_2 .. L9_2
  L6_2.title = L7_2
  L6_2.type = "GENERAL"
  L7_2 = L8_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.message = L7_2
  L7_2 = A1_2.jobs
  if not L7_2 then
    L7_2 = {}
  end
  L7_2 = L7_2[1]
  if not L7_2 then
    L7_2 = A1_2.job
  end
  L6_2.job = L7_2
  L7_2 = {}
  L8_2 = L1_1
  L9_2 = A1_2.caller
  L10_2 = 60
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.name = L8_2
  L6_2.metadata = L7_2
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = true
  return L3_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "wasabi_mdt"
L18_1 = {}
L18_1.label = "wasabi_mdt (police)"
L19_1 = {}
L20_1 = "wasabi_mdt"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "police" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = "wasabi_mdt"
  L5_2 = "CreateDispatch"
  L6_2 = {}
  L6_2.type = "disturbance"
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.title = L7_2
  L7_2 = L8_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.description = L7_2
  L7_2 = L10_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = "GPS"
  end
  L6_2.location = L7_2
  L6_2.coords = L2_2
  L6_2.priority = 1
  L7_2 = L1_1
  L8_2 = A1_2.code
  L9_2 = 10
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.code = L7_2
  L7_2 = L1_1
  L8_2 = A1_2.caller
  L9_2 = 60
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.senderName = L7_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = false ~= L3_2 and nil ~= L3_2
  return L4_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "redutzu-mdt"
L18_1 = {}
L18_1.label = "redutzu-mdt (police)"
L19_1 = {}
L20_1 = "redutzu-mdt"
L19_1[1] = L20_1
L18_1.resources = L19_1
L18_1.verified = false
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "police" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = TriggerEvent
  L4_2 = "redutzu-mdt:server:addDispatchToMDT"
  L5_2 = {}
  L6_2 = L1_1
  L7_2 = A1_2.code
  L8_2 = 10
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.code = L6_2
  L6_2 = L9_1
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  L7_2 = ": "
  L8_2 = L8_1
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L6_2 = L6_2 .. L7_2 .. L8_2
  L5_2.title = L6_2
  L6_2 = L10_1
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = L7_1
    L7_2 = A1_2
    L6_2 = L6_2(L7_2)
  end
  L5_2.street = L6_2
  L5_2.duration = 300000
  L6_2 = {}
  L7_2 = L2_2.x
  L6_2.x = L7_2
  L7_2 = L2_2.y
  L6_2.y = L7_2
  L7_2 = L2_2.z
  L6_2.z = L7_2
  L5_2.coords = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.define
L16_1 = "dispatch"
L17_1 = "ND_MDT"
L18_1 = {}
L18_1.label = "ND_MDT (police)"
L19_1 = {}
L20_1 = "ND_MDT"
L19_1[1] = L20_1
L18_1.resources = L19_1
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "police" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L2_1
  L3_2 = A1_2.coords
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = "ND_MDT"
  L5_2 = "createDispatch"
  L6_2 = {}
  L7_2 = L7_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L6_2.caller = L7_2
  L7_2 = L10_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = "GPS"
  end
  L6_2.location = L7_2
  L7_2 = L9_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L8_2 = ": "
  L9_2 = L1_1
  L10_2 = A1_2.message
  L11_2 = 300
  L9_2 = L9_2(L10_2, L11_2)
  L7_2 = L7_2 .. L8_2 .. L9_2
  L6_2.callDescription = L7_2
  L6_2.coords = L2_2
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = true
  return L3_2
end
L18_1.alert = L19_1
L15_1(L16_1, L17_1, L18_1)
L15_1 = L0_1.order
L16_1 = {}
L17_1 = "apex_mdt"
L18_1 = "ps-dispatch"
L19_1 = "cd_dispatch"
L20_1 = "qs-dispatch"
L21_1 = "rcore_dispatch"
L22_1 = "core_dispatch"
L23_1 = "tk_dispatch"
L24_1 = "linden_outlawalert"
L25_1 = "lb-tablet"
L26_1 = "kartik-mdt"
L27_1 = "origen_police"
L28_1 = "wasabi_mdt"
L29_1 = "redutzu-mdt"
L30_1 = "ND_MDT"
L16_1[1] = L17_1
L16_1[2] = L18_1
L16_1[3] = L19_1
L16_1[4] = L20_1
L16_1[5] = L21_1
L16_1[6] = L22_1
L16_1[7] = L23_1
L16_1[8] = L24_1
L16_1[9] = L25_1
L16_1[10] = L26_1
L16_1[11] = L27_1
L16_1[12] = L28_1
L16_1[13] = L29_1
L16_1[14] = L30_1
L15_1.dispatch = L16_1
