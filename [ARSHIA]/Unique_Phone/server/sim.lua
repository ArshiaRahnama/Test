local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1
SimReady = false
L0_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_lines` (
    `number` VARCHAR(20) NOT NULL, `cid` VARCHAR(64) NOT NULL, `slot` TINYINT NOT NULL DEFAULT 1, `label` VARCHAR(24) NULL,
    `iccid` VARCHAR(24) NULL, `source` VARCHAR(12) NOT NULL DEFAULT 'esim', `color` VARCHAR(7) NULL, `created` BIGINT NOT NULL,
    PRIMARY KEY (`number`), KEY `cid` (`cid`))]]
L1_1 = "apex_phone:sim:legacyBefore"
L2_1 = nil
L3_1 = {}
L4_1 = "Principal"
L5_1 = "Pessoal"
L6_1 = "Trabalho"
L3_1[1] = L4_1
L3_1[2] = L5_1
L3_1[3] = L6_1
L4_1 = {}
L5_1 = "#1F5EFF"
L6_1 = "#34C759"
L7_1 = "#FF9F0A"
L4_1[1] = L5_1
L4_1[2] = L6_1
L4_1[3] = L7_1
L5_1 = 300000
L6_1 = {}
L7_1 = {}
L8_1 = {}
L9_1 = {}
L10_1 = type
L11_1 = Config
L11_1 = L11_1.RateLimit
L10_1 = L10_1(L11_1)
if "table" == L10_1 then
  L10_1 = Config
  L10_1 = L10_1.RateLimit
  if L10_1 then
    goto lbl_38
  end
end
L10_1 = nil
::lbl_38::
if L10_1 then
  L11_1 = type
  L12_1 = L10_1.costs
  L11_1 = L11_1(L12_1)
  if "table" == L11_1 then
    L11_1 = L10_1.costs
    if L11_1 then
      goto lbl_50
    end
  end
  L11_1 = {}
  ::lbl_50::
  L10_1.costs = L11_1
  L11_1 = L10_1.costs
  L12_1 = L11_1["sim.activate"]
  if nil == L12_1 then
    L11_1["sim.activate"] = 5
  end
  L12_1 = L11_1["sim.preview"]
  if nil == L12_1 then
    L11_1["sim.preview"] = 2
  end
  L12_1 = L11_1["sim.switch"]
  if nil == L12_1 then
    L11_1["sim.switch"] = 3
  end
  L12_1 = L11_1["sim.remove"]
  if nil == L12_1 then
    L11_1["sim.remove"] = 4
  end
  L12_1 = L11_1["sim.rename"]
  if nil == L12_1 then
    L11_1["sim.rename"] = 2
  end
end
function L10_1(A0_2, A1_2, A2_2)
  if A0_2 < A1_2 then
    return A1_2
  elseif A2_2 < A0_2 then
    return A2_2
  end
  return A0_2
end
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Sim
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Sim
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = type
  L2_2 = L0_2.labels
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = L0_2.labels
    if L1_2 then
      goto lbl_22
    end
  end
  L1_2 = L3_1
  ::lbl_22::
  L2_2 = type
  L3_2 = L0_2.colors
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L0_2.colors
    if L2_2 then
      goto lbl_31
    end
  end
  L2_2 = L4_1
  ::lbl_31::
  L3_2 = {}
  L4_2 = L0_2.required
  L4_2 = true == L4_2
  L3_2.required = L4_2
  L4_2 = L10_1
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = tonumber
  L8_2 = L0_2.maxLines
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 3
  end
  L6_2, L7_2, L8_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L5_2 = 3
  end
  L6_2 = 1
  L7_2 = 3
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.max = L4_2
  L4_2 = type
  L5_2 = L0_2.item
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L0_2.item
    if "" ~= L4_2 then
      L4_2 = L0_2.item
      if L4_2 then
        goto lbl_71
      end
    end
  end
  L4_2 = "esim"
  ::lbl_71::
  L3_2.item = L4_2
  L4_2 = L0_2.allowRemove
  L4_2 = false ~= L4_2
  L3_2.allowRemove = L4_2
  L4_2 = L10_1
  L5_2 = tonumber
  L6_2 = L0_2.scanSeconds
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 1.6
  end
  L6_2 = 0.8
  L7_2 = 5.0
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2.scanSeconds = L4_2
  L4_2 = type
  L5_2 = L0_2.carrier
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L0_2.carrier
    if "" ~= L4_2 then
      L4_2 = L0_2.carrier
      if L4_2 then
        goto lbl_101
      end
    end
  end
  L4_2 = "Apex Mobile"
  ::lbl_101::
  L3_2.carrier = L4_2
  L3_2.labels = L1_2
  L3_2.colors = L2_2
  return L3_2
end
SimConfig = L11_1
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L2_1
  if L0_2 then
    L0_2 = L2_1
    return L0_2
  end
  L0_2 = tonumber
  L1_2 = GetResourceKvpString
  L2_2 = L1_1
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = ""
  end
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L1_2 = Now
    L1_2 = L1_2()
    L0_2 = L1_2
    L1_2 = SetResourceKvp
    L2_2 = L1_1
    L3_2 = tostring
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L0_2
    L4_2, L5_2 = L4_2(L5_2)
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
  L2_1 = L0_2
  return L0_2
end
L13_1 = L12_1
L13_1()
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%D"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.find
  L3_2 = "Duplicate entry"
  L4_2 = 1
  L5_2 = true
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = nil ~= L1_2
  return L1_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "number" ~= L1_2 then
      L1_2 = nil
      return L1_2
    end
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.sub
  L3_2 = 1
  L4_2 = 20
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if "" ~= L1_2 then
    L3_2 = L1_2
    L2_2 = L1_2.match
    L4_2 = "^[%d %-%+%(%)%.]+$"
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L2_2 = L13_1
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      L2_2 = #L2_2
      if not (L2_2 < 3) then
        goto lbl_35
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_35::
  return L1_2
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "%c"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
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
  L2_2 = #L1_2
  if L2_2 > 24 then
    L3_2 = L1_2
    L2_2 = L1_2.sub
    L4_2 = 1
    L5_2 = 24
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L1_2 = L2_2
    L2_2 = 1
    L3_2 = 3
    L4_2 = 1
    for L5_2 = L2_2, L3_2, L4_2 do
      L6_2 = utf8
      L6_2 = L6_2.len
      L7_2 = L1_2
      L6_2 = L6_2(L7_2)
      if L6_2 then
        break
      end
      L7_2 = L1_2
      L6_2 = L1_2.sub
      L8_2 = 1
      L9_2 = -2
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      L1_2 = L6_2
    end
  end
  if "" ~= L1_2 then
    L2_2 = utf8
    L2_2 = L2_2.len
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_54
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_54::
  return L1_2
end
function L18_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = "8935100000"
  L0_2[1] = L1_2
  L1_2 = 1
  L2_2 = 9
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = #L0_2
    L5_2 = L5_2 + 1
    L6_2 = tostring
    L7_2 = math
    L7_2 = L7_2.random
    L8_2 = 0
    L9_2 = 9
    L7_2, L8_2, L9_2 = L7_2(L8_2, L9_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L0_2[L5_2] = L6_2
  end
  L1_2 = table
  L1_2 = L1_2.concat
  L2_2 = L0_2
  return L1_2(L2_2)
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "number" ~= L1_2 then
      L1_2 = nil
      return L1_2
    end
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L3_2 = L1_2
  L2_2 = L1_2.match
  L4_2 = "^%d+$"
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = #L1_2
    if not (L2_2 < 18) then
      L2_2 = #L1_2
      if not (L2_2 > 22) then
        goto lbl_29
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_29::
  return L1_2
end
function L20_1(A0_2, A1_2)
  local L2_2
  L2_2 = A0_2.labels
  L2_2 = L2_2[A1_2]
  if not L2_2 then
    L2_2 = L3_1
    L2_2 = L2_2[A1_2]
    if not L2_2 then
      L2_2 = L3_1
      L2_2 = L2_2[1]
    end
  end
  return L2_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2.colors
  L2_2 = L2_2[A1_2]
  if not L2_2 then
    L2_2 = L4_1
    L2_2 = L2_2[A1_2]
  end
  L3_2 = L15_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L2_2 or L3_2
  if not L3_2 or not L2_2 then
    L3_2 = L4_1
    L3_2 = L3_2[1]
  end
  return L3_2
end
function L22_1()
  local L0_2, L1_2, L2_2
  L0_2 = SimReady
  if L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = SimReady
    if L1_2 then
      break
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 7000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 200
    L1_2(L2_2)
  end
  L1_2 = SimReady
  return L1_2
end
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L7_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = ipairs
    L4_2 = L2_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L10_2 = L8_2.number
      L9_2 = L6_1
      L9_2 = L9_2[L10_2]
      if L9_2 == L8_2 then
        L10_2 = L8_2.number
        L9_2 = L6_1
        L9_2[L10_2] = nil
      end
    end
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = A1_2
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.slot
    if not L2_3 then
      L2_3 = 9
    end
    L3_3 = A1_3.slot
    if not L3_3 then
      L3_3 = 9
    end
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L3_2(L4_2, L5_2)
  L3_2 = L7_1
  L3_2[A0_2] = A1_2
  L3_2 = ipairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L10_2 = L8_2.number
    L9_2 = L6_1
    L9_2[L10_2] = L8_2
  end
  return A1_2
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tostring
  L2_2 = A0_2.number
  L1_2 = L1_2(L2_2)
  A0_2.number = L1_2
  L1_2 = tostring
  L2_2 = A0_2.cid
  L1_2 = L1_2(L2_2)
  A0_2.cid = L1_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2.slot
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = 1
  end
  A0_2.slot = L1_2
  L1_2 = tonumber
  L2_2 = A0_2.created
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  A0_2.created = L1_2
  L1_2 = A0_2.label
  if "" == L1_2 then
    A0_2.label = nil
  end
  L1_2 = L15_1
  L2_2 = A0_2.color
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    A0_2.color = nil
  end
  return A0_2
end
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if not A0_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = L7_1
  L2_2 = L2_2[A0_2]
  if L2_2 and not A1_2 then
    L2_2 = L7_1
    L2_2 = L2_2[A0_2]
    return L2_2
  end
  L2_2 = L22_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = L7_1
    L2_2 = L2_2[A0_2]
    if not L2_2 then
      L2_2 = {}
    end
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT number, cid, slot, label, iccid, source, color, created FROM apex_phone_lines WHERE cid = ? ORDER BY slot ASC"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L24_1
    L10_2 = L8_2
    L9_2(L10_2)
  end
  L3_2 = L23_1
  L4_2 = A0_2
  L5_2 = L2_2
  return L3_2(L4_2, L5_2)
end
SimLoad = L25_1
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L7_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = ipairs
    L3_2 = L1_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L9_2 = L7_2.number
      L8_2 = L6_1
      L8_2 = L8_2[L9_2]
      if L8_2 == L7_2 then
        L9_2 = L7_2.number
        L8_2 = L6_1
        L8_2[L9_2] = nil
      end
    end
  end
  L2_2 = L7_1
  L2_2[A0_2] = nil
  L2_2 = L9_1
  L2_2[A0_2] = nil
end
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = Accounts
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return L1_2
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT phone, created FROM apex_phone_accounts WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L3_2 or L4_2
  if not L2_2 or not L3_2 then
    L4_2 = nil
  end
  return L4_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L27_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L2_2 = L1_2.phone
  end
  if nil == L2_2 or "" == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = L2_2
  return L3_2(L4_2)
end
function L29_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT cid FROM apex_phone_lines WHERE number = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 and L2_2 then
    L3_2 = tostring
    L4_2 = L2_2.cid
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_21
    end
  end
  L3_2 = nil
  ::lbl_21::
  return L3_2
end
function L30_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if not A0_2 or A0_2 <= 0 then
    return
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L1_3 = L0_3
    L0_3 = L0_3.set
    L2_3 = "apex_phoneNumber"
    L3_3 = A1_2
    L4_3 = true
    L0_3(L1_3, L2_3, L3_3, L4_3)
  end
  L2_2(L3_2)
end
L31_1 = "apex_phone:sim:optout:"
L32_1 = {}
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if not A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = L32_1
  L1_2 = L1_2[A0_2]
  if nil == L1_2 then
    L2_2 = GetResourceKvpString
    L3_2 = L31_1
    L4_2 = A0_2
    L3_2 = L3_2 .. L4_2
    L2_2 = L2_2(L3_2)
    L1_2 = "1" == L2_2
    L2_2 = L32_1
    L2_2[A0_2] = L1_2
  end
  return L1_2
end
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if not A0_2 then
    return
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if A1_2 then
    L2_2 = SetResourceKvp
    L3_2 = L31_1
    L4_2 = A0_2
    L3_2 = L3_2 .. L4_2
    L4_2 = "1"
    L2_2(L3_2, L4_2)
  else
    L2_2 = DeleteResourceKvp
    L3_2 = L31_1
    L4_2 = A0_2
    L3_2 = L3_2 .. L4_2
    L2_2(L3_2)
  end
  L2_2 = L32_1
  if A1_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_29
    end
  end
  L3_2 = false
  ::lbl_29::
  L2_2[A0_2] = L3_2
end
SimSetOptOut = L34_1
SimOptedOut = L33_1
function L34_1(A0_2)
  local L1_2, L2_2
  L1_2 = L11_1
  L1_2 = L1_2()
  L1_2 = L1_2.required
  if not L1_2 then
    L1_2 = L33_1
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  return L1_2
end
function L35_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  if not A0_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = L25_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = #L3_2
  if not (L4_2 > 0) then
    L4_2 = SimReady
    if L4_2 then
      goto lbl_20
    end
  end
  do return L3_2 end
  ::lbl_20::
  if not A1_2 then
    L4_2 = L27_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    A1_2 = L4_2
  end
  if not A1_2 then
    return L3_2
  end
  L4_2 = tostring
  L5_2 = A1_2.phone
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  if "" == L4_2 then
    return L3_2
  end
  L5_2 = L11_1
  L5_2 = L5_2()
  L6_2 = tonumber
  L7_2 = A1_2.created
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L7_2 = L5_2.required
  if L7_2 then
    L7_2 = L12_1
    L7_2 = L7_2()
    if L6_2 >= L7_2 then
      goto lbl_58
    end
  end
  L7_2 = L33_1
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  ::lbl_58::
  if L7_2 then
    if A2_2 then
      L7_2 = L30_1
      L8_2 = A2_2
      L9_2 = nil
      L7_2(L8_2, L9_2)
    end
    return L3_2
  end
  L7_2 = L6_1
  L7_2 = L7_2[L4_2]
  if L7_2 then
    L7_2 = L6_1
    L7_2 = L7_2[L4_2]
    L7_2 = L7_2.cid
    if L7_2 then
      goto lbl_77
    end
  end
  L7_2 = L29_1
  L8_2 = L4_2
  L7_2 = L7_2(L8_2)
  ::lbl_77::
  if L7_2 and L7_2 ~= A0_2 then
    L8_2 = print
    L9_2 = "^3[unique_phone]^0 eSIM: number %s of account %s is already a line of %s (not migrated)"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L4_2
    L12_2 = A0_2
    L13_2 = L7_2
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    return L3_2
  end
  if not L7_2 then
    L8_2 = pcall
    L9_2 = MySQL
    L9_2 = L9_2.insert
    L9_2 = L9_2.await
    L10_2 = "INSERT INTO apex_phone_lines (number, cid, slot, label, iccid, source, color, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    L11_2 = {}
    L12_2 = L4_2
    L13_2 = A0_2
    L14_2 = 1
    L15_2 = nil
    L16_2 = L18_1
    L16_2 = L16_2()
    L17_2 = "legacy"
    L18_2 = nil
    L19_2 = Now
    L19_2 = L19_2()
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L11_2[3] = L14_2
    L11_2[4] = L15_2
    L11_2[5] = L16_2
    L11_2[6] = L17_2
    L11_2[7] = L18_2
    L11_2[8] = L19_2
    L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
    if not L8_2 then
      L10_2 = L14_1
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if not L10_2 then
        L10_2 = print
        L11_2 = "^1[unique_phone]^0 eSIM: migration of account %s failed (%s)"
        L12_2 = L11_2
        L11_2 = L11_2.format
        L13_2 = A0_2
        L14_2 = tostring
        L15_2 = L9_2
        L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L14_2(L15_2)
        L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
        L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      end
    end
  end
  L8_2 = L25_1
  L9_2 = A0_2
  L10_2 = true
  return L8_2(L9_2, L10_2)
end
SimEnsure = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L6_1
  L1_2 = L2_2[L1_2]
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = FW
  L2_2 = L2_2.GetPlayerByCid
  L3_2 = L1_2.cid
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = tonumber
    L4_2 = L2_2.src
    L3_2 = L3_2(L4_2)
  end
  if L3_2 then
    L4_2 = GetCid
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L5_2 = L1_2.cid
    if L4_2 == L5_2 then
      return L3_2
    end
  end
  L4_2 = nil
  return L4_2
end
SimSrcByLine = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil == A0_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = L6_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = L1_2.cid
    return L2_2
  end
  L2_2 = SimReady
  if not L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L29_1
  L3_2 = A0_2
  return L2_2(L3_2)
end
SimLineOwner = L35_1
function L35_1(A0_2)
  local L1_2, L2_2
  L1_2 = SimLineOwner
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = nil ~= L1_2
  return L1_2
end
SimNumberTaken = L35_1
function L35_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = SimReady
    if L2_2 then
      L2_2 = L34_1
      L3_2 = A0_2
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_13
      end
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_13::
  L2_2 = SimEnsure
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = #L2_2
  L3_2 = 0 == L3_2
  return L3_2
end
SimDormantCid = L35_1
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = SimDormantCid
  L4_2 = L2_2
  L5_2 = A1_2
  return L3_2(L4_2, L5_2)
end
SimDormant = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = L11_1
    L2_2 = L2_2()
    L2_2 = L2_2.required
    L2_2 = not L2_2
    return L2_2
  end
  L2_2 = L34_1
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = SimEnsure
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L2_2 = #L2_2
  L2_2 = L2_2 > 0
  return L2_2
end
SimHasLine = L35_1
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if A0_2 then
    L2_2 = tostring
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    L3_2 = L6_1
    L2_2 = L3_2[L2_2]
    if L2_2 then
      L2_2 = tostring
      L3_2 = A0_2
      return L2_2(L3_2)
    end
  end
  if A1_2 then
    L2_2 = #A1_2
    if not (L2_2 < 3) then
      goto lbl_21
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_21::
  L2_2 = pairs
  L3_2 = L6_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = L13_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 == A1_2 then
      return L6_2
    end
  end
  L2_2 = SimReady
  if not L2_2 then
    L2_2 = nil
    return L2_2
  end
  if A0_2 and "" ~= A0_2 then
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.single
    L3_2 = L3_2.await
    L4_2 = "SELECT number FROM apex_phone_lines WHERE number = ? LIMIT 1"
    L5_2 = {}
    L6_2 = tostring
    L7_2 = A0_2
    L6_2, L7_2, L8_2 = L6_2(L7_2)
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L5_2[3] = L8_2
    L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 and L3_2 then
      L4_2 = L3_2.number
      if L4_2 then
        L4_2 = tostring
        L5_2 = L3_2.number
        return L4_2(L5_2)
      end
    end
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = [[
SELECT number FROM apex_phone_lines
        WHERE REPLACE(REPLACE(REPLACE(REPLACE(number, '-', ''), ' ', ''), '+', ''), '.', '') = ? LIMIT 1]]
  L5_2 = {}
  L6_2 = A1_2
  L5_2[1] = L6_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 and L3_2 then
    L4_2 = L3_2.number
    if L4_2 then
      L4_2 = tostring
      L5_2 = L3_2.number
      return L4_2(L5_2)
    end
  end
  L4_2 = nil
  return L4_2
end
SimCanon = L35_1
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A1_2 then
    L2_2 = L11_1
    L2_2 = L2_2()
    A1_2 = L2_2
  end
  L2_2 = {}
  L3_2 = A0_2.number
  L2_2.number = L3_2
  L3_2 = A0_2.label
  if not L3_2 then
    L3_2 = L20_1
    L4_2 = A1_2
    L5_2 = A0_2.slot
    L3_2 = L3_2(L4_2, L5_2)
  end
  L2_2.label = L3_2
  L3_2 = A0_2.label
  L3_2 = nil ~= L3_2
  L2_2.custom = L3_2
  L3_2 = A0_2.color
  if not L3_2 then
    L3_2 = L21_1
    L4_2 = A1_2
    L5_2 = A0_2.slot
    L3_2 = L3_2(L4_2, L5_2)
  end
  L2_2.color = L3_2
  L3_2 = A0_2.slot
  L2_2.slot = L3_2
  return L2_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if not A0_2 or nil == A1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = tostring
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  A1_2 = L3_2
  A0_2 = L2_2
  L2_2 = L6_1
  L2_2 = L2_2[A1_2]
  if not L2_2 then
    L3_2 = L7_1
    L3_2 = L3_2[A0_2]
    if not L3_2 then
      L3_2 = SimReady
      if L3_2 then
        L3_2 = L25_1
        L4_2 = A0_2
        L3_2(L4_2)
        L3_2 = L6_1
        L2_2 = L3_2[A1_2]
      end
    end
  end
  if L2_2 then
    L3_2 = L2_2.cid
    if L3_2 == A0_2 then
      goto lbl_38
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_38::
  L3_2 = L28_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if A1_2 == L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L35_1
  L4_2 = L2_2
  return L3_2(L4_2)
end
SimLineTagCid = L36_1
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = A0_2 or nil
  if A0_2 then
    L2_2 = GetCid
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = SimLineTagCid
  L4_2 = L2_2
  L5_2 = A1_2
  return L3_2(L4_2, L5_2)
end
SimLineTag = L36_1
function L36_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  if A0_2 and A2_2 and A1_2 ~= A2_2 then
    L4_2 = SimReady
    if L4_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L4_2 = tostring
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = tostring
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  A2_2 = L5_2
  A0_2 = L4_2
  L4_2 = L25_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.number
    if L11_2 == A2_2 then
      return
    end
  end
  L5_2 = 0
  if A1_2 and "" ~= A1_2 then
    L6_2 = pcall
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "UPDATE apex_phone_lines SET number = ? WHERE number = ? AND cid = ?"
    L9_2 = {}
    L10_2 = A2_2
    L11_2 = tostring
    L12_2 = A1_2
    L11_2 = L11_2(L12_2)
    L12_2 = A0_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L9_2[3] = L12_2
    L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      L8_2 = tonumber
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if L8_2 then
        goto lbl_63
        L5_2 = L8_2 or L5_2
      end
      L8_2 = 0
      if L8_2 then
        goto lbl_63
        L5_2 = L8_2 or L5_2
      end
    end
    L5_2 = 0
    ::lbl_63::
    if not L6_2 then
      L8_2 = print
      L9_2 = "^1[unique_phone]^0 eSIM: line %s -> %s not updated (%s)"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L12_2 = A1_2
      L11_2 = L11_2(L12_2)
      L12_2 = A2_2
      L13_2 = tostring
      L14_2 = L7_2
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L13_2(L14_2)
      L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    end
  end
  if 0 == L5_2 then
    L6_2 = type
    L7_2 = A3_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = A3_2.grant
      if L6_2 then
        L6_2 = L25_1
        L7_2 = A0_2
        L8_2 = true
        L6_2 = L6_2(L7_2, L8_2)
        L7_2 = L11_1
        L7_2 = L7_2()
        L8_2 = {}
        L9_2 = ipairs
        L10_2 = L6_2
        L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
        for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
          L15_2 = L14_2.slot
          L8_2[L15_2] = true
        end
        L9_2 = nil
        L10_2 = 1
        L11_2 = L7_2.max
        L12_2 = 1
        for L13_2 = L10_2, L11_2, L12_2 do
          L14_2 = L8_2[L13_2]
          if not L14_2 then
            L9_2 = L13_2
            break
          end
        end
        if L9_2 then
          L10_2 = pcall
          L11_2 = MySQL
          L11_2 = L11_2.insert
          L11_2 = L11_2.await
          L12_2 = "INSERT INTO apex_phone_lines (number, cid, slot, label, iccid, source, color, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
          L13_2 = {}
          L14_2 = A2_2
          L15_2 = A0_2
          L16_2 = L9_2
          L17_2 = nil
          L18_2 = L18_1
          L18_2 = L18_2()
          L19_2 = "legacy"
          L20_2 = nil
          L21_2 = Now
          L21_2 = L21_2()
          L13_2[1] = L14_2
          L13_2[2] = L15_2
          L13_2[3] = L16_2
          L13_2[4] = L17_2
          L13_2[5] = L18_2
          L13_2[6] = L19_2
          L13_2[7] = L20_2
          L13_2[8] = L21_2
          L10_2(L11_2, L12_2, L13_2)
        end
      end
    end
  end
  L6_2 = L25_1
  L7_2 = A0_2
  L8_2 = true
  L6_2(L7_2, L8_2)
end
SimOnNumberChanged = L36_1
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if not A0_2 then
    return
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = L26_1
  L2_2 = A0_2
  L1_2(L2_2)
  L1_2 = SimReady
  if L1_2 then
    L1_2 = pcall
    L2_2 = MySQL
    L2_2 = L2_2.query
    L2_2 = L2_2.await
    L3_2 = "DELETE FROM apex_phone_lines WHERE cid = ?"
    L4_2 = {}
    L5_2 = A0_2
    L4_2[1] = L5_2
    L1_2(L2_2, L3_2, L4_2)
  end
end
SimForget = L36_1
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = {}
  L2_2 = #A0_2
  if 0 == L2_2 then
    return L1_2
  end
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.number
    L2_2[L8_2] = L10_2
    L3_2[L8_2] = "?"
  end
  L4_2 = #L2_2
  L4_2 = L4_2 + 1
  L2_2[L4_2] = "sms"
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT receiver, COUNT(*) AS n FROM apex_phone_messages WHERE receiver IN (%s) AND app = ? AND `read` = 0 AND deleted_receiver = 0 AND conversation_id IS NULL GROUP BY receiver"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = table
  L8_2 = L8_2.concat
  L9_2 = L3_2
  L10_2 = ", "
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L8_2(L9_2, L10_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L7_2 = L2_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = ipairs
      L7_2 = L5_2
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = tostring
        L13_2 = L11_2.receiver
        L12_2 = L12_2(L13_2)
        L13_2 = math
        L13_2 = L13_2.tointeger
        L14_2 = tonumber
        L15_2 = L11_2.n
        L14_2, L15_2 = L14_2(L15_2)
        L13_2 = L13_2(L14_2, L15_2)
        if not L13_2 then
          L13_2 = 0
        end
        L1_2[L12_2] = L13_2
      end
    end
  end
  return L1_2
end
function L37_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = A3_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = A0_2.iccid
  L4_2.iccid = L5_2
  L5_2 = A0_2.source
  if not L5_2 then
    L5_2 = "esim"
  end
  L4_2.source = L5_2
  L5_2 = A0_2.number
  L5_2 = L5_2 == A1_2
  L4_2.active = L5_2
  L5_2 = A2_2 or L5_2
  if not A2_2 then
    L5_2 = 0
  end
  L4_2.unread = L5_2
  return L4_2
end
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L11_1
  L2_2 = L2_2()
  L3_2 = SimEnsure
  L4_2 = A1_2
  L5_2 = nil
  L6_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L28_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  L5_2 = L36_1
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L6_2 = {}
  L7_2 = false
  L8_2 = ipairs
  L9_2 = L3_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L37_1
    L15_2 = L13_2
    L16_2 = L4_2
    L17_2 = L13_2.number
    L17_2 = L5_2[L17_2]
    L18_2 = L2_2
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
    L6_2[L12_2] = L14_2
    L14_2 = L6_2[L12_2]
    L14_2 = L14_2.active
    if L14_2 then
      L7_2 = true
    end
  end
  L8_2 = {}
  L8_2.ok = true
  L9_2 = L34_1
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L8_2.required = L9_2
  L9_2 = L2_2.max
  L8_2.max = L9_2
  L9_2 = L2_2.allowRemove
  L8_2.allowRemove = L9_2
  L9_2 = L4_2 or L9_2
  if not L7_2 or not L4_2 then
    L9_2 = nil
  end
  L8_2.active = L9_2
  L9_2 = #L3_2
  L9_2 = 0 == L9_2
  L8_2.nosim = L9_2
  L9_2 = #L3_2
  L10_2 = L2_2.max
  L9_2 = L9_2 < L10_2
  L8_2.canAdd = L9_2
  L8_2.lines = L6_2
  L9_2 = L2_2.item
  L8_2.item = L9_2
  L9_2 = FW
  L9_2 = L9_2.HasItem
  L10_2 = A0_2
  L11_2 = L2_2.item
  L9_2 = L9_2(L10_2, L11_2)
  if not L9_2 then
    L9_2 = 0
  end
  L8_2.cards = L9_2
  L9_2 = L2_2.scanSeconds
  L8_2.scanSeconds = L9_2
  L9_2 = L2_2.carrier
  L8_2.carrier = L9_2
  return L8_2
end
SimState = L38_1
function L39_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = {}
  L2_2.ok = false
  L2_2.error = A0_2
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = pairs
    L4_2 = A1_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L2_2[L7_2] = L8_2
    end
  end
  return L2_2
end
function L40_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = L38_1
  L5_2 = A0_2
  L6_2 = A2_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = {}
  L5_2.reason = A1_2
  L6_2 = L4_2.active
  L5_2.active = L6_2
  L5_2.state = L4_2
  L6_2 = type
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = pairs
    L7_2 = A3_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L5_2[L10_2] = L11_2
    end
  end
  L6_2 = Push
  L7_2 = A0_2
  L8_2 = "sim:changed"
  L9_2 = L5_2
  L6_2(L7_2, L8_2, L9_2)
  return L4_2
end
function L41_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_accounts SET phone = ? WHERE citizenid = ?"
  L7_2 = {}
  L8_2 = A2_2
  L9_2 = A1_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L6_2 = false
    L7_2 = L14_1
    L8_2 = L5_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L7_2 = "taken"
      if L7_2 then
        goto lbl_24
      end
    end
    L7_2 = "db"
    ::lbl_24::
    return L6_2, L7_2
  end
  L6_2 = Accounts
  L6_2 = L6_2[A1_2]
  L7_2 = L6_2 or L7_2
  if L6_2 then
    L7_2 = L6_2.phone
  end
  if L6_2 then
    L6_2.phone = A2_2
  end
  L8_2 = Config
  L8_2 = L8_2.SyncNumberToCharInfo
  if L8_2 then
    L8_2 = pcall
    L9_2 = FW
    L9_2 = L9_2.SetPhone
    L10_2 = A0_2
    L11_2 = A2_2
    L8_2(L9_2, L10_2, L11_2)
  end
  if A3_2 then
    L8_2 = L30_1
    L9_2 = A0_2
    L10_2 = nil
    L8_2(L9_2, L10_2)
  else
    L8_2 = SyncPhoneNumberState
    L9_2 = A0_2
    L10_2 = A2_2
    L8_2(L9_2, L10_2)
  end
  L8_2 = BuildPlayer
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  if L8_2 then
    L9_2 = Push
    L10_2 = A0_2
    L11_2 = "player"
    L12_2 = L8_2
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = TriggerEvent
  L10_2 = "apex_phone:lineChanged"
  L11_2 = A0_2
  L12_2 = L7_2
  L13_2 = A2_2
  L9_2(L10_2, L11_2, L12_2, L13_2)
  L9_2 = true
  return L9_2
end
function L42_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L0_3 = L0_3.apex_inCall
    return L0_3
  end
  L1_2, L2_2 = L1_2(L2_2)
  L3_2 = L1_2 or L3_2
  L3_2 = L1_2 and nil ~= L2_2 and false ~= L2_2
  return L3_2
end
function L43_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = RPC
  function L3_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if "table" ~= L2_3 or not A1_3 then
      L2_3 = {}
      A1_3 = L2_3
    end
    L2_3 = L22_1
    L2_3 = L2_3()
    if not L2_3 then
      L2_3 = L39_1
      L3_3 = "db"
      return L2_3(L3_3)
    end
    L2_3 = GetCid
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L3_3 = L39_1
      L4_3 = "noplayer"
      return L3_3(L4_3)
    end
    L3_3 = L8_1
    L3_3 = L3_3[L2_3]
    if L3_3 then
      L3_3 = L39_1
      L4_3 = "busy"
      return L3_3(L4_3)
    end
    L3_3 = L8_1
    L3_3[L2_3] = true
    L3_3 = pcall
    L4_3 = A1_2
    L5_3 = A0_3
    L6_3 = L2_3
    L7_3 = A1_3
    L3_3, L4_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
    L5_3 = L8_1
    L5_3[L2_3] = nil
    if not L3_3 then
      L5_3 = print
      L6_3 = "^1[unique_phone]^0 %s: %s"
      L7_3 = L6_3
      L6_3 = L6_3.format
      L8_3 = A0_2
      L9_3 = tostring
      L10_3 = L4_3
      L9_3, L10_3 = L9_3(L10_3)
      L6_3, L7_3, L8_3, L9_3, L10_3 = L6_3(L7_3, L8_3, L9_3, L10_3)
      L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
      L5_3 = L39_1
      L6_3 = "internal"
      return L5_3(L6_3)
    end
    return L4_3
  end
  L2_2[A0_2] = L3_2
end
function L44_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L4_2 = FW
  L4_2 = L4_2.InventoryName
  L4_2 = L4_2()
  if "ox_inventory" == L4_2 then
    L4_2 = math
    L4_2 = L4_2.tointeger
    L5_2 = tonumber
    L6_2 = A2_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L5_2(L6_2)
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    A2_2 = L4_2
    if A2_2 then
      L4_2 = pcall
      function L5_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = exports
        L0_3 = L0_3.ox_inventory
        L1_3 = L0_3
        L0_3 = L0_3.GetSlot
        L2_3 = A0_2
        L3_3 = A2_2
        return L0_3(L1_3, L2_3, L3_3)
      end
      L4_2, L5_2 = L4_2(L5_2)
      if L4_2 then
        L6_2 = type
        L7_2 = L5_2
        L6_2 = L6_2(L7_2)
        if "table" == L6_2 then
          L6_2 = L5_2.name
          if L6_2 == A1_2 then
            L6_2 = tonumber
            L7_2 = L5_2.count
            L6_2 = L6_2(L7_2)
            if not L6_2 then
              L6_2 = 0
            end
            if L6_2 > 0 then
              L6_2 = {}
              L6_2.slot = A2_2
              L7_2 = type
              L8_2 = L5_2.metadata
              L7_2 = L7_2(L8_2)
              if "table" == L7_2 then
                L7_2 = L5_2.metadata
                if L7_2 then
                  goto lbl_49
                end
              end
              L7_2 = {}
              ::lbl_49::
              L6_2.metadata = L7_2
              return L6_2
            end
          end
        end
      end
    end
    L4_2 = pcall
    function L5_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.GetSlotsWithItem
      L2_3 = A0_2
      L3_3 = A1_2
      return L0_3(L1_3, L2_3, L3_3)
    end
    L4_2, L5_2 = L4_2(L5_2)
    if L4_2 then
      L6_2 = type
      L7_2 = L5_2
      L6_2 = L6_2(L7_2)
      if "table" == L6_2 then
        L6_2 = nil
        L7_2 = pairs
        L8_2 = L5_2
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
          L13_2 = type
          L14_2 = L12_2
          L13_2 = L13_2(L14_2)
          if "table" == L13_2 then
            L13_2 = tonumber
            L14_2 = L12_2.count
            L13_2 = L13_2(L14_2)
            if not L13_2 then
              L13_2 = 0
            end
            if L13_2 > 0 then
              L13_2 = type
              L14_2 = L12_2.metadata
              L13_2 = L13_2(L14_2)
              if "table" == L13_2 then
                L13_2 = L12_2.metadata
                if L13_2 then
                  goto lbl_89
                end
              end
              L13_2 = {}
              ::lbl_89::
              if A3_2 then
                L14_2 = L13_2.iccid
                if nil ~= L14_2 then
                  L14_2 = tostring
                  L15_2 = L13_2.iccid
                  L14_2 = L14_2(L15_2)
                  if L14_2 == A3_2 then
                    L6_2 = L12_2
                    break
                  end
                end
              end
              if L6_2 then
                L14_2 = tonumber
                L15_2 = L12_2.slot
                L14_2 = L14_2(L15_2)
                if not L14_2 then
                  L14_2 = 999
                end
                L15_2 = tonumber
                L16_2 = L6_2.slot
                L15_2 = L15_2(L16_2)
                if not L15_2 then
                  L15_2 = 999
                end
                if not (L14_2 < L15_2) then
                  goto lbl_118
                end
              end
              L6_2 = L12_2
            end
          end
          ::lbl_118::
        end
        if L6_2 then
          L7_2 = {}
          L8_2 = math
          L8_2 = L8_2.tointeger
          L9_2 = tonumber
          L10_2 = L6_2.slot
          L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L9_2(L10_2)
          L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
          L7_2.slot = L8_2
          L8_2 = type
          L9_2 = L6_2.metadata
          L8_2 = L8_2(L9_2)
          if "table" == L8_2 then
            L8_2 = L6_2.metadata
            if L8_2 then
              goto lbl_142
            end
          end
          L8_2 = {}
          ::lbl_142::
          L7_2.metadata = L8_2
          return L7_2
        end
      end
    end
    L6_2 = nil
    return L6_2
  end
  L4_2 = FW
  L4_2 = L4_2.HasItem
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = 0
  end
  if L4_2 > 0 then
    L4_2 = {}
    L5_2 = {}
    L4_2.metadata = L5_2
    return L4_2
  end
  L4_2 = nil
  return L4_2
end
function L45_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = FW
  L3_2 = L3_2.InventoryName
  L3_2 = L3_2()
  if "ox_inventory" == L3_2 then
    L3_2 = A2_2.slot
    if L3_2 then
      L3_2 = pcall
      function L4_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
        L0_3 = exports
        L0_3 = L0_3.ox_inventory
        L1_3 = L0_3
        L0_3 = L0_3.RemoveItem
        L2_3 = A0_2
        L3_3 = A1_2
        L4_3 = 1
        L5_3 = A2_2.metadata
        L6_3 = A2_2.slot
        return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
      end
      L3_2, L4_2 = L3_2(L4_2)
      if L3_2 and L4_2 then
        L5_2 = true
        return L5_2
      end
    end
    L3_2 = pcall
    function L4_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.RemoveItem
      L2_3 = A0_2
      L3_3 = A1_2
      L4_3 = 1
      return L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L3_2, L4_2 = L3_2(L4_2)
    if L3_2 and L4_2 then
      L5_2 = true
      if L5_2 then
        goto lbl_29
      end
    end
    L5_2 = false
    ::lbl_29::
    return L5_2
  end
  L3_2 = FW
  L3_2 = L3_2.RemoveItem
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = 1
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = true == L3_2
  return L3_2
end
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = SimLineOwner
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT citizenid FROM apex_phone_accounts WHERE phone = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 and L3_2 then
    L4_2 = tostring
    L5_2 = L3_2.citizenid
    L4_2 = L4_2(L5_2)
    if L4_2 ~= A1_2 then
      L4_2 = false
      return L4_2
    end
  end
  L4_2 = FW
  L4_2 = L4_2.FindCidByPhone
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = tostring
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if L5_2 ~= A1_2 then
      L5_2 = false
      return L5_2
    end
  end
  L5_2 = GetSrcByNumber
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = GetCid
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if L6_2 ~= A1_2 then
      L6_2 = false
      return L6_2
    end
  end
  L6_2 = true
  return L6_2
end
function L47_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = type
  L1_2 = GenPhoneNumber
  L0_2 = L0_2(L1_2)
  if "function" == L0_2 then
    L0_2 = GenPhoneNumber
    return L0_2()
  end
  L0_2 = 1
  L1_2 = 50
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = tostring
    L5_2 = Config
    L5_2 = L5_2.NumberFormat
    if not L5_2 then
      L5_2 = "555-####"
    end
    L4_2 = L4_2(L5_2)
    L5_2 = L4_2
    L4_2 = L4_2.gsub
    L6_2 = "#"
    function L7_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = tostring
      L1_3 = math
      L1_3 = L1_3.random
      L2_3 = 0
      L3_3 = 9
      L1_3, L2_3, L3_3 = L1_3(L2_3, L3_3)
      return L0_3(L1_3, L2_3, L3_3)
    end
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L4_2 = UniqueNumberFix(L4_2)
    L5_2 = L46_1
    L6_2 = L4_2
    L7_2 = ""
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      return L4_2
    end
  end
  L0_2 = tostring
  L1_2 = math
  L1_2 = L1_2.random
  L2_2 = 1000000
  L3_2 = 9999999
  L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L1_2(L2_2, L3_2)
  return L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
end
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.slot
    L2_2[L9_2] = true
  end
  L3_2 = 1
  L4_2 = A1_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = L2_2[L6_2]
    if not L7_2 then
      return L6_2
    end
  end
  L3_2 = nil
  return L3_2
end
L49_1 = RPC
function L50_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L11_1
  L1_2 = L1_2()
  L2_2 = false
  L3_2 = pcall
  L4_2 = L44_1
  L5_2 = A0_2
  L6_2 = L1_2.item
  L7_2 = nil
  L8_2 = nil
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  if L3_2 and L4_2 then
    L2_2 = true
  end
  L5_2 = {}
  L5_2.ok = true
  L6_2 = L1_2.required
  L5_2.required = L6_2
  L6_2 = L1_2.carrier
  L5_2.carrier = L6_2
  L6_2 = L1_2.max
  L5_2.max = L6_2
  L5_2.hasCard = L2_2
  return L5_2
end
L49_1["sim.config"] = L50_1
L49_1 = RPC
function L50_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L22_1
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = L39_1
    L2_2 = "db"
    return L1_2(L2_2)
  end
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = L39_1
    L3_2 = "noplayer"
    return L2_2(L3_2)
  end
  L2_2 = L38_1
  L3_2 = A0_2
  L4_2 = L1_2
  return L2_2(L3_2, L4_2)
end
L49_1["sim.lines"] = L50_1
L49_1 = L43_1
L50_1 = "sim.preview"
function L51_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L11_1
  L3_2 = L3_2()
  L4_2 = SimEnsure
  L5_2 = A1_2
  L6_2 = nil
  L7_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = #L4_2
  L6_2 = L3_2.max
  if L5_2 >= L6_2 then
    L5_2 = L39_1
    L6_2 = "maxlines"
    L7_2 = {}
    L8_2 = L3_2.max
    L7_2.max = L8_2
    return L5_2(L6_2, L7_2)
  end
  L5_2 = L44_1
  L6_2 = A0_2
  L7_2 = L3_2.item
  L8_2 = A2_2.slot
  L9_2 = L19_1
  L10_2 = A2_2.iccid
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L5_2 then
    L6_2 = L39_1
    L7_2 = "noitem"
    return L6_2(L7_2)
  end
  L6_2 = L5_2.metadata
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = L48_1
  L8_2 = L4_2
  L9_2 = L3_2.max
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = #L4_2
    L7_2 = L7_2 + 1
  end
  L8_2 = L16_1
  L9_2 = L6_2.number
  L8_2 = L8_2(L9_2)
  L9_2 = false
  if L8_2 then
    L10_2 = L46_1
    L11_2 = L8_2
    L12_2 = A1_2
    L10_2 = L10_2(L11_2, L12_2)
    if not L10_2 then
      L10_2 = L39_1
      L11_2 = "taken"
      L12_2 = {}
      L12_2.number = L8_2
      return L10_2(L11_2, L12_2)
    end
    L9_2 = true
  else
    L10_2 = L9_1
    L10_2 = L10_2[A1_2]
    if L10_2 then
      L11_2 = Now
      L11_2 = L11_2()
      L12_2 = L10_2.t
      L11_2 = L11_2 - L12_2
      L12_2 = L5_1
      if L11_2 < L12_2 then
        L11_2 = L46_1
        L12_2 = L10_2.number
        L13_2 = A1_2
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          L8_2 = L10_2.number
      end
    end
    else
      L11_2 = L47_1
      L11_2 = L11_2()
      L8_2 = L11_2
    end
  end
  L10_2 = L19_1
  L11_2 = L6_2.iccid
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = L9_1
    L10_2 = L10_2[A1_2]
    if L10_2 then
      L10_2 = L9_1
      L10_2 = L10_2[A1_2]
      L10_2 = L10_2.iccid
      if L10_2 then
        goto lbl_108
      end
    end
    L10_2 = L18_1
    L10_2 = L10_2()
  end
  ::lbl_108::
  if not L9_2 then
    L11_2 = L9_1
    L12_2 = {}
    L12_2.number = L8_2
    L12_2.iccid = L10_2
    L13_2 = Now
    L13_2 = L13_2()
    L12_2.t = L13_2
    L11_2[A1_2] = L12_2
  end
  L11_2 = {}
  L11_2.ok = true
  L11_2.number = L8_2
  L11_2.preset = L9_2
  L11_2.iccid = L10_2
  L12_2 = L3_2.carrier
  L11_2.carrier = L12_2
  L11_2.slot = L7_2
  L12_2 = L20_1
  L13_2 = L3_2
  L14_2 = L7_2
  L12_2 = L12_2(L13_2, L14_2)
  L11_2.label = L12_2
  L12_2 = L21_1
  L13_2 = L3_2
  L14_2 = L7_2
  L12_2 = L12_2(L13_2, L14_2)
  L11_2.color = L12_2
  L12_2 = L5_2.slot
  L11_2.cardSlot = L12_2
  L12_2 = #L4_2
  L11_2.count = L12_2
  L12_2 = L3_2.max
  L11_2.max = L12_2
  L12_2 = L34_1
  L13_2 = A1_2
  L12_2 = L12_2(L13_2)
  L11_2.required = L12_2
  L12_2 = #L4_2
  L12_2 = 0 == L12_2
  L11_2.nosim = L12_2
  return L11_2
end
L49_1(L50_1, L51_1)
L49_1 = L43_1
L50_1 = "sim.activate"
function L51_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2
  L3_2 = L11_1
  L3_2 = L3_2()
  L4_2 = L27_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L39_1
    L6_2 = "noaccount"
    return L5_2(L6_2)
  end
  L5_2 = SimEnsure
  L6_2 = A1_2
  L7_2 = L4_2
  L8_2 = A0_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = #L5_2
  L7_2 = L3_2.max
  if L6_2 >= L7_2 then
    L6_2 = L39_1
    L7_2 = "maxlines"
    L8_2 = {}
    L9_2 = L3_2.max
    L8_2.max = L9_2
    return L6_2(L7_2, L8_2)
  end
  L6_2 = L44_1
  L7_2 = A0_2
  L8_2 = L3_2.item
  L9_2 = A2_2.slot
  L10_2 = L19_1
  L11_2 = A2_2.iccid
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L10_2(L11_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
  if not L6_2 then
    L7_2 = L39_1
    L8_2 = "noitem"
    return L7_2(L8_2)
  end
  L7_2 = L6_2.metadata
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = L16_1
  L9_2 = L7_2.number
  L8_2 = L8_2(L9_2)
  L9_2 = nil
  if L8_2 then
    L10_2 = L46_1
    L11_2 = L8_2
    L12_2 = A1_2
    L10_2 = L10_2(L11_2, L12_2)
    if not L10_2 then
      L10_2 = L39_1
      L11_2 = "taken"
      L12_2 = {}
      L12_2.number = L8_2
      return L10_2(L11_2, L12_2)
    end
    L9_2 = L8_2
  else
    L10_2 = L9_1
    L10_2 = L10_2[A1_2]
    if L10_2 then
      L11_2 = Now
      L11_2 = L11_2()
      L12_2 = L10_2.t
      L11_2 = L11_2 - L12_2
      L12_2 = L5_1
      if L11_2 < L12_2 then
        L11_2 = L46_1
        L12_2 = L10_2.number
        L13_2 = A1_2
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          L9_2 = L10_2.number
      end
    end
    else
      L11_2 = L47_1
      L11_2 = L11_2()
      L9_2 = L11_2
    end
  end
  L10_2 = L19_1
  L11_2 = L7_2.iccid
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    if not L8_2 then
      L10_2 = L9_1
      L10_2 = L10_2[A1_2]
      if L10_2 then
        L10_2 = L9_1
        L10_2 = L10_2[A1_2]
        L10_2 = L10_2.iccid
        if L10_2 then
          goto lbl_110
        end
      end
    end
    L10_2 = L18_1
    L10_2 = L10_2()
  end
  ::lbl_110::
  L11_2 = L48_1
  L12_2 = L5_2
  L13_2 = L3_2.max
  L11_2 = L11_2(L12_2, L13_2)
  if not L11_2 then
    L12_2 = L39_1
    L13_2 = "maxlines"
    L14_2 = {}
    L15_2 = L3_2.max
    L14_2.max = L15_2
    return L12_2(L13_2, L14_2)
  end
  L12_2 = L17_1
  L13_2 = A2_2.label
  L12_2 = L12_2(L13_2)
  L13_2 = L20_1
  L14_2 = L3_2
  L15_2 = L11_2
  L13_2 = L13_2(L14_2, L15_2)
  if L12_2 == L13_2 then
    L12_2 = nil
  end
  L13_2 = L15_1
  L14_2 = A2_2.color
  L13_2 = L13_2(L14_2)
  if L13_2 then
    L13_2 = A2_2.color
    L14_2 = L13_2
    L13_2 = L13_2.upper
    L13_2 = L13_2(L14_2)
    if L13_2 then
      goto lbl_145
    end
  end
  L13_2 = nil
  ::lbl_145::
  L14_2 = false
  L15_2 = 1
  L16_2 = 4
  L17_2 = 1
  for L18_2 = L15_2, L16_2, L17_2 do
    L19_2 = pcall
    L20_2 = MySQL
    L20_2 = L20_2.insert
    L20_2 = L20_2.await
    L21_2 = "INSERT INTO apex_phone_lines (number, cid, slot, label, iccid, source, color, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    L22_2 = {}
    L23_2 = L9_2
    L24_2 = A1_2
    L25_2 = L11_2
    L26_2 = L12_2
    L27_2 = L10_2
    L28_2 = "esim"
    L29_2 = L13_2
    L30_2 = Now
    L30_2 = L30_2()
    L22_2[1] = L23_2
    L22_2[2] = L24_2
    L22_2[3] = L25_2
    L22_2[4] = L26_2
    L22_2[5] = L27_2
    L22_2[6] = L28_2
    L22_2[7] = L29_2
    L22_2[8] = L30_2
    L19_2, L20_2 = L19_2(L20_2, L21_2, L22_2)
    if L19_2 then
      L14_2 = true
      break
    end
    L21_2 = L14_1
    L22_2 = L20_2
    L21_2 = L21_2(L22_2)
    if not L21_2 then
      L21_2 = error
      L22_2 = L20_2
      L23_2 = 0
      L21_2(L22_2, L23_2)
    end
    if L8_2 then
      L21_2 = L39_1
      L22_2 = "taken"
      L23_2 = {}
      L23_2.number = L8_2
      return L21_2(L22_2, L23_2)
    end
    L21_2 = L47_1
    L21_2 = L21_2()
    L9_2 = L21_2
  end
  if not L14_2 then
    L15_2 = L39_1
    L16_2 = "busy"
    return L15_2(L16_2)
  end
  L15_2 = L9_1
  L15_2[A1_2] = nil
  L15_2 = L45_1
  L16_2 = A0_2
  L17_2 = L3_2.item
  L18_2 = L6_2
  L15_2 = L15_2(L16_2, L17_2, L18_2)
  if not L15_2 then
    L15_2 = pcall
    L16_2 = MySQL
    L16_2 = L16_2.query
    L16_2 = L16_2.await
    L17_2 = "DELETE FROM apex_phone_lines WHERE number = ? AND cid = ?"
    L18_2 = {}
    L19_2 = L9_2
    L20_2 = A1_2
    L18_2[1] = L19_2
    L18_2[2] = L20_2
    L15_2(L16_2, L17_2, L18_2)
    L15_2 = L25_1
    L16_2 = A1_2
    L17_2 = true
    L15_2(L16_2, L17_2)
    L15_2 = L39_1
    L16_2 = "noitem"
    return L15_2(L16_2)
  end
  L15_2 = L25_1
  L16_2 = A1_2
  L17_2 = true
  L15_2(L16_2, L17_2)
  L15_2 = SimSetOptOut
  L16_2 = A1_2
  L17_2 = false
  L15_2(L16_2, L17_2)
  L15_2 = false
  L16_2 = #L5_2
  if 0 ~= L16_2 then
    L16_2 = A2_2.activate
    if true ~= L16_2 then
      goto lbl_261
    end
  end
  L16_2 = L41_1
  L17_2 = A0_2
  L18_2 = A1_2
  L19_2 = L9_2
  L20_2 = false
  L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
  L15_2 = L16_2
  if not L16_2 then
    L18_2 = print
    L19_2 = "^3[unique_phone]^0 eSIM: line %s activated but did not become the primary (%s)"
    L20_2 = L19_2
    L19_2 = L19_2.format
    L21_2 = L9_2
    L22_2 = tostring
    L23_2 = L17_2
    L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L22_2(L23_2)
    L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
    L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
  end
  ::lbl_261::
  L16_2 = Dbg
  L17_2 = "sim"
  L18_2 = "eSIM activated: %s -> %s (slot %d%s)"
  L19_2 = A1_2
  L20_2 = L9_2
  L21_2 = L11_2
  if L15_2 then
    L22_2 = ", active"
    if L22_2 then
      goto lbl_273
    end
  end
  L22_2 = ""
  ::lbl_273::
  L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L16_2 = TriggerEvent
  L17_2 = "apex_phone:esimActivated"
  L18_2 = A0_2
  L19_2 = L9_2
  L20_2 = L10_2
  L16_2(L17_2, L18_2, L19_2, L20_2)
  L16_2 = L6_1
  L16_2 = L16_2[L9_2]
  if L16_2 then
    L17_2 = L37_1
    L18_2 = L16_2
    L19_2 = L28_1
    L20_2 = A1_2
    L19_2 = L19_2(L20_2)
    L20_2 = 0
    L21_2 = L3_2
    L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
    if L17_2 then
      goto lbl_298
    end
  end
  L17_2 = {}
  L17_2.number = L9_2
  L17_2.slot = L11_2
  ::lbl_298::
  L18_2 = L40_1
  L19_2 = A0_2
  L20_2 = "activate"
  L21_2 = A1_2
  L22_2 = {}
  L22_2.line = L17_2
  L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
  L18_2.line = L17_2
  return L18_2
end
L49_1(L50_1, L51_1)
L49_1 = L43_1
L50_1 = "sim.switch"
function L51_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L16_1
  L4_2 = A2_2.number
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L39_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = SimEnsure
  L5_2 = A1_2
  L6_2 = nil
  L7_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = L6_1
  L5_2 = L5_2[L3_2]
  if L5_2 then
    L6_2 = L5_2.cid
    if L6_2 == A1_2 then
      goto lbl_26
    end
  end
  L6_2 = L39_1
  L7_2 = "notfound"
  do return L6_2(L7_2) end
  ::lbl_26::
  L6_2 = L28_1
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  if L6_2 == L3_2 then
    L6_2 = L38_1
    L7_2 = A0_2
    L8_2 = A1_2
    return L6_2(L7_2, L8_2)
  end
  L6_2 = L42_1
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L6_2 = L39_1
    L7_2 = "incall"
    return L6_2(L7_2)
  end
  L6_2 = L41_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = L3_2
  L10_2 = false
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  if not L6_2 then
    L8_2 = L39_1
    L9_2 = L7_2
    return L8_2(L9_2)
  end
  L8_2 = L40_1
  L9_2 = A0_2
  L10_2 = "switch"
  L11_2 = A1_2
  return L8_2(L9_2, L10_2, L11_2)
end
L49_1(L50_1, L51_1)
L49_1 = L43_1
L50_1 = "sim.rename"
function L51_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = L16_1
  L4_2 = A2_2.number
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L39_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = SimEnsure
  L5_2 = A1_2
  L6_2 = nil
  L7_2 = A0_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = L6_1
  L4_2 = L4_2[L3_2]
  if L4_2 then
    L5_2 = L4_2.cid
    if L5_2 == A1_2 then
      goto lbl_26
    end
  end
  L5_2 = L39_1
  L6_2 = "notfound"
  do return L5_2(L6_2) end
  ::lbl_26::
  L5_2 = L11_1
  L5_2 = L5_2()
  L6_2 = L4_2.label
  L7_2 = L4_2.color
  L8_2 = A2_2.label
  if nil ~= L8_2 then
    L8_2 = L17_1
    L9_2 = A2_2.label
    L8_2 = L8_2(L9_2)
    L6_2 = L8_2
    L8_2 = L20_1
    L9_2 = L5_2
    L10_2 = L4_2.slot
    L8_2 = L8_2(L9_2, L10_2)
    if L6_2 == L8_2 then
      L6_2 = nil
    end
  end
  L8_2 = A2_2.color
  if nil ~= L8_2 then
    L8_2 = A2_2.color
    if "" ~= L8_2 then
      L8_2 = A2_2.color
      if false ~= L8_2 then
        goto lbl_55
      end
    end
    L7_2 = nil
    goto lbl_69
    ::lbl_55::
    L8_2 = L15_1
    L9_2 = A2_2.color
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L8_2 = A2_2.color
      L9_2 = L8_2
      L8_2 = L8_2.upper
      L8_2 = L8_2(L9_2)
      L7_2 = L8_2
    else
      L8_2 = L39_1
      L9_2 = "badcolor"
      return L8_2(L9_2)
    end
  end
  ::lbl_69::
  L8_2 = pcall
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = "UPDATE apex_phone_lines SET label = ?, color = ? WHERE number = ? AND cid = ?"
  L11_2 = {}
  L12_2 = L6_2
  L13_2 = L7_2
  L14_2 = L3_2
  L15_2 = A1_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  if not L8_2 then
    L9_2 = L39_1
    L10_2 = "db"
    return L9_2(L10_2)
  end
  L9_2 = L6_2
  L4_2.color = L7_2
  L4_2.label = L9_2
  L9_2 = L40_1
  L10_2 = A0_2
  L11_2 = "rename"
  L12_2 = A1_2
  L13_2 = {}
  L13_2.number = L3_2
  return L9_2(L10_2, L11_2, L12_2, L13_2)
end
L49_1(L50_1, L51_1)
L49_1 = L43_1
L50_1 = "sim.remove"
function L51_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L11_1
  L3_2 = L3_2()
  L4_2 = L3_2.allowRemove
  if not L4_2 then
    L4_2 = L39_1
    L5_2 = "disabled"
    return L4_2(L5_2)
  end
  L4_2 = L16_1
  L5_2 = A2_2.number
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L39_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = SimEnsure
  L6_2 = A1_2
  L7_2 = nil
  L8_2 = A0_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = L6_1
  L6_2 = L6_2[L4_2]
  if L6_2 then
    L7_2 = L6_2.cid
    if L7_2 == A1_2 then
      goto lbl_35
    end
  end
  L7_2 = L39_1
  L8_2 = "notfound"
  do return L7_2(L8_2) end
  ::lbl_35::
  L7_2 = #L5_2
  if L7_2 <= 1 then
    L7_2 = L3_2.required
    if not L7_2 then
      L7_2 = L39_1
      L8_2 = "lastline"
      return L7_2(L8_2)
    end
  end
  L7_2 = L28_1
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  if L7_2 == L4_2 then
    L7_2 = L42_1
    L8_2 = A0_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L7_2 = L39_1
      L8_2 = "incall"
      return L7_2(L8_2)
    end
    L7_2 = nil
    L8_2 = ipairs
    L9_2 = L5_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = L13_2.number
      if L14_2 ~= L4_2 then
        L7_2 = L13_2
        break
      end
    end
    L8_2 = nil
    L9_2 = nil
    if L7_2 then
      L10_2 = L41_1
      L11_2 = A0_2
      L12_2 = A1_2
      L13_2 = L7_2.number
      L14_2 = false
      L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      L9_2 = L11_2
      L8_2 = L10_2
    else
      L10_2 = L41_1
      L11_2 = A0_2
      L12_2 = A1_2
      L13_2 = L47_1
      L13_2 = L13_2()
      L14_2 = true
      L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      L9_2 = L11_2
      L8_2 = L10_2
    end
    if not L8_2 then
      L10_2 = L39_1
      L11_2 = L9_2
      return L10_2(L11_2)
    end
  end
  L7_2 = pcall
  L8_2 = MySQL
  L8_2 = L8_2.query
  L8_2 = L8_2.await
  L9_2 = "DELETE FROM apex_phone_lines WHERE number = ? AND cid = ?"
  L10_2 = {}
  L11_2 = L4_2
  L12_2 = A1_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L8_2 = L39_1
    L9_2 = "db"
    return L8_2(L9_2)
  end
  L8_2 = L25_1
  L9_2 = A1_2
  L10_2 = true
  L8_2(L9_2, L10_2)
  L8_2 = TriggerEvent
  L9_2 = "apex_phone:lineRemoved"
  L10_2 = A0_2
  L11_2 = L4_2
  L8_2(L9_2, L10_2, L11_2)
  L8_2 = L40_1
  L9_2 = A0_2
  L10_2 = "remove"
  L11_2 = A1_2
  L12_2 = {}
  L12_2.number = L4_2
  return L8_2(L9_2, L10_2, L11_2, L12_2)
end
L49_1(L50_1, L51_1)
L49_1 = {}
function L50_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Sim
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = type
    L1_2 = Config
    L1_2 = L1_2.Sim
    L1_2 = L1_2.scan
    L0_2 = L0_2(L1_2)
    if "table" == L0_2 then
      L0_2 = Config
      L0_2 = L0_2.Sim
      L0_2 = L0_2.scan
      L0_2 = L0_2.prop
      if L0_2 then
        goto lbl_21
      end
    end
  end
  L0_2 = nil
  ::lbl_21::
  L1_2 = GetHashKey
  L2_2 = type
  L3_2 = L0_2
  L2_2 = L2_2(L3_2)
  L2_2 = L0_2 or L2_2
  if "string" ~= L2_2 or "" == L0_2 or not L0_2 then
    L2_2 = "apex_esim_card"
  end
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 % 4294967296
  return L1_2
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    return
  end
  L1_2 = NetworkGetEntityFromNetworkId
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 and 0 ~= L1_2 then
    L2_2 = DoesEntityExist
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = GetEntityModel
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      L2_2 = L2_2 % 4294967296
      L3_2 = L50_1
      L3_2 = L3_2()
      if L2_2 == L3_2 then
        L2_2 = DeleteEntity
        L3_2 = L1_2
        L2_2(L3_2)
      end
    end
  end
end
L52_1 = RegisterNetEvent
L53_1 = "apex_phone:server:simCard"
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = source
  L2_2 = RateLimitAllow
  if L2_2 then
    L2_2 = RateLimitAllow
    L3_2 = L1_2
    L4_2 = "event.simCard"
    L2_2 = L2_2(L3_2, L4_2)
    if not L2_2 then
      return
    end
  end
  if nil == A0_2 then
    L2_2 = L49_1
    L2_2[L1_2] = nil
    return
  end
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2)
  A0_2 = L2_2
  if not A0_2 then
    return
  end
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = 1
    L1_3 = 10
    L2_3 = 1
    for L3_3 = L0_3, L1_3, L2_3 do
      L4_3 = NetworkGetEntityFromNetworkId
      L5_3 = A0_2
      L4_3 = L4_3(L5_3)
      if L4_3 and 0 ~= L4_3 then
        L5_3 = DoesEntityExist
        L6_3 = L4_3
        L5_3 = L5_3(L6_3)
        if L5_3 then
          L5_3 = NetworkGetEntityOwner
          L6_3 = L4_3
          L5_3 = L5_3(L6_3)
          L6_3 = L1_2
          if L5_3 == L6_3 then
            L5_3 = GetEntityModel
            L6_3 = L4_3
            L5_3 = L5_3(L6_3)
            L5_3 = L5_3 % 4294967296
            L6_3 = L50_1
            L6_3 = L6_3()
            if L5_3 == L6_3 then
              L6_3 = L1_2
              L5_3 = L49_1
              L7_3 = A0_2
              L5_3[L6_3] = L7_3
            end
          end
          return
        end
      end
      L5_3 = Wait
      L6_3 = 200
      L5_3(L6_3)
    end
  end
  L2_2(L3_2)
end
L52_1(L53_1, L54_1)
L52_1 = AddEventHandler
L53_1 = "playerDropped"
function L54_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = source
  end
  L1_2 = L49_1
  L1_2 = L1_2[L0_2]
  L2_2 = L49_1
  L2_2[L0_2] = nil
  if L1_2 then
    L2_2 = pcall
    L3_2 = L51_1
    L4_2 = L1_2
    L2_2(L3_2, L4_2)
  end
end
L52_1(L53_1, L54_1)
L52_1 = AddEventHandler
L53_1 = "onResourceStop"
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L49_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = pcall
    L8_2 = L51_1
    L9_2 = L6_2
    L7_2(L8_2, L9_2)
  end
end
L52_1(L53_1, L54_1)
L52_1 = CreateThread
function L53_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = Wait
  L1_2 = 1000
  L0_2(L1_2)
  L0_2 = L11_1
  L0_2 = L0_2()
  L0_2 = L0_2.item
  L1_2 = FW
  L1_2 = L1_2.CreateUseableItem
  if L1_2 then
    L1_2 = FW
    L1_2 = L1_2.CreateUseableItem
    L2_2 = L0_2
    function L3_2(A0_3)
      local L1_3, L2_3, L3_3
      L1_3 = TriggerClientEvent
      L2_3 = "apex_phone:client:useEsim"
      L3_3 = A0_3
      L1_3(L2_3, L3_3)
    end
    L1_2(L2_2, L3_2)
  end
end
L52_1(L53_1)
function L52_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    return
  end
  L2_2 = L26_1
  L3_2 = L1_2
  L2_2(L3_2)
  L2_2 = SimEnsure
  L3_2 = L1_2
  L4_2 = nil
  L5_2 = A0_2
  L2_2(L3_2, L4_2, L5_2)
end
L53_1 = CreateThread
function L54_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = DBReady
    if L1_2 then
      break
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 120000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 250
    L1_2(L2_2)
  end
  L1_2 = L0_1
  L2_2 = " DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
  L1_2 = L1_2 .. L2_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L1_2
    L0_3(L1_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = print
    L5_2 = "^1[unique_phone]^0 could not create apex_phone_lines (%s)"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L4_2 = MigrateTable
  if L4_2 then
    L4_2 = pcall
    L5_2 = MigrateTable
    L6_2 = L1_2
    L4_2(L5_2, L6_2)
  end
  SimReady = true
  L4_2 = ipairs
  L5_2 = FW
  L5_2 = L5_2.GetPlayers
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2()
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = pcall
    L11_2 = L52_1
    L12_2 = L9_2
    L10_2(L11_2, L12_2)
  end
end
L53_1(L54_1)
L53_1 = FW
L53_1 = L53_1.OnPlayerLoaded
function L54_1(A0_2)
  local L1_2, L2_2
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = pcall
    L1_3 = L52_1
    L2_3 = A0_2
    L0_3(L1_3, L2_3)
  end
  L1_2(L2_2)
end
L53_1(L54_1)
L53_1 = CreateThread
function L54_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = AdminStore
    if L1_2 then
      L1_2 = AdminStore
      L1_2 = L1_2.OnChange
      if L1_2 then
        break
      end
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 60000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 500
    L1_2(L2_2)
  end
  L1_2 = AdminStore
  if L1_2 then
    L1_2 = AdminStore
    L1_2 = L1_2.OnChange
    if L1_2 then
      goto lbl_29
    end
  end
  do return end
  ::lbl_29::
  L1_2 = true
  L2_2 = AdminStore
  L2_2 = L2_2.OnChange
  L3_2 = "settings"
  function L4_2()
    local L0_3, L1_3, L2_3
    L0_3 = L1_2
    if L0_3 then
      L0_3 = false
      L1_2 = L0_3
      return
    end
    L0_3 = SetTimeout
    L1_3 = 500
    function L2_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4
      L0_4 = SimReady
      if not L0_4 then
        return
      end
      L0_4 = ipairs
      L1_4 = FW
      L1_4 = L1_4.GetPlayers
      L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4 = L1_4()
      L0_4, L1_4, L2_4, L3_4 = L0_4(L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4)
      for L4_4, L5_4 in L0_4, L1_4, L2_4, L3_4 do
        L6_4 = GetCid
        L7_4 = L5_4
        L6_4 = L6_4(L7_4)
        if L6_4 then
          L7_4 = pcall
          L8_4 = L40_1
          L9_4 = L5_4
          L10_4 = "config"
          L11_4 = L6_4
          L7_4(L8_4, L9_4, L10_4, L11_4)
        end
      end
    end
    L0_3(L1_3, L2_3)
  end
  L2_2(L3_2, L4_2)
end
L53_1(L54_1)
L53_1 = exports
L54_1 = "GetPlayerLines"
function L55_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L38_1
  L3_2 = A0_2
  L4_2 = L1_2
  return L2_2(L3_2, L4_2)
end
L53_1(L54_1, L55_1)
