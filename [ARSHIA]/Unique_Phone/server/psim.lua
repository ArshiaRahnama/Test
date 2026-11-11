local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1, L87_1, L88_1, L89_1, L90_1, L91_1, L92_1, L93_1, L94_1, L95_1, L96_1, L97_1, L98_1
L0_1 = type
L1_1 = Config
L1_1 = L1_1.PhysicalSim
L0_1 = L0_1(L1_1)
if "table" == L0_1 then
  L0_1 = Config
  L0_1 = L0_1.PhysicalSim
  if L0_1 then
    goto lbl_13
  end
end
L0_1 = nil
::lbl_13::
if not L0_1 then
  return
end
function L1_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = print
  L2_2 = "^3[unique_phone]^0 Physical SIM: "
  L3_2 = A0_2
  L2_2 = L2_2 .. L3_2
  L1_2(L2_2)
end
function L2_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L0_1.debug
  if L1_2 then
    L1_2 = pcall
    L2_2 = string
    L2_2 = L2_2.format
    L3_2 = A0_2
    L4_2, L5_2 = ...
    L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
    L3_2 = print
    L4_2 = "^5[unique_phone] psim^0 "
    L5_2 = L2_2 or L5_2
    if not L1_2 or not L2_2 then
      L5_2 = A0_2
    end
    L4_2 = L4_2 .. L5_2
    L3_2(L4_2)
  end
end
L3_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_sims` (
    `iccid` VARCHAR(24) NOT NULL, `number` VARCHAR(20) NOT NULL, `device` VARCHAR(24) NULL, `account` VARCHAR(64) NULL,
    `label` VARCHAR(24) NULL, `home` VARCHAR(64) NULL, `origin` VARCHAR(12) NOT NULL DEFAULT 'shop', `pending` VARCHAR(64) NULL,
    `created` BIGINT NOT NULL, `updated` BIGINT NULL,
    PRIMARY KEY (`iccid`), UNIQUE KEY `ux_number` (`number`), KEY `device` (`device`), KEY `pending` (`pending`))]]
L4_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_sims_blocked` (
    `iccid` VARCHAR(24) NOT NULL, `number` VARCHAR(20) NOT NULL, `replaced_by` VARCHAR(24) NULL, `cid` VARCHAR(64) NULL,
    `blocked` BIGINT NOT NULL, PRIMARY KEY (`iccid`), KEY `number` (`number`))]]
L5_1 = "apex_phone:psim:mig:"
L6_1 = "apex_phone:psim:last:"
L7_1 = "apex_phone:psim:contacts:"
L8_1 = nil
L9_1 = nil
L10_1 = "sim_card"
L11_1 = {}
L12_1 = {}
L13_1 = {}
L14_1 = {}
L15_1 = {}
L16_1 = {}
L17_1 = {}
L18_1 = {}
L19_1 = {}
L20_1 = {}
L21_1 = {}
L22_1 = {}
L23_1 = {}
L24_1 = {}
L25_1 = {}
L26_1 = {}
L27_1 = {}
function L28_1()
  local L0_2, L1_2
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L0_2 = L0_2 * 1000
  return L0_2
end
function L29_1(A0_2)
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
function L30_1()
  local L0_2, L1_2
  L0_2 = L29_1
  L1_2 = Config
  L1_2 = L1_2.NumberPrefix
  return L0_2(L1_2)
end
function L31_1(A0_2)
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
      L2_2 = L29_1
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
function L32_1(A0_2)
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
function L33_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = "8935100"
  L0_2[1] = L1_2
  L1_2 = 1
  L2_2 = 12
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
function L34_1(A0_2)
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
function L35_1(A0_2)
  local L1_2
  L1_2 = L26_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L26_1
  L1_2[A0_2] = true
  L1_2 = true
  return L1_2
end
function L36_1(A0_2)
  local L1_2
  L1_2 = L26_1
  L1_2[A0_2] = nil
end
function L37_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = L0_1.carrier
  L0_2 = L0_2(L1_2)
  if "string" == L0_2 then
    L0_2 = L0_1.carrier
    if "" ~= L0_2 then
      L0_2 = L0_1.carrier
      return L0_2
    end
  end
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Sim
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = type
    L1_2 = Config
    L1_2 = L1_2.Sim
    L1_2 = L1_2.carrier
    L0_2 = L0_2(L1_2)
    if "string" == L0_2 then
      L0_2 = Config
      L0_2 = L0_2.Sim
      L0_2 = L0_2.carrier
      if "" ~= L0_2 then
        L0_2 = Config
        L0_2 = L0_2.Sim
        L0_2 = L0_2.carrier
        if L0_2 then
          goto lbl_35
        end
      end
    end
  end
  L0_2 = "Apex Mobile"
  ::lbl_35::
  return L0_2
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    return
  end
  L2_2 = A0_2.iccid
  L1_2 = L11_1
  L1_2 = L1_2[L2_2]
  if L1_2 == A0_2 then
    L2_2 = A0_2.iccid
    L1_2 = L11_1
    L1_2[L2_2] = nil
  end
  L2_2 = A0_2.number
  L1_2 = L12_1
  L1_2 = L1_2[L2_2]
  if L1_2 == A0_2 then
    L2_2 = A0_2.number
    L1_2 = L12_1
    L1_2[L2_2] = nil
  end
  L1_2 = L29_1
  L2_2 = A0_2.number
  L1_2 = L1_2(L2_2)
  L2_2 = L14_1
  L2_2 = L2_2[L1_2]
  L3_2 = A0_2.number
  if L2_2 == L3_2 then
    L2_2 = L14_1
    L2_2[L1_2] = nil
  end
  L2_2 = A0_2.device
  if L2_2 then
    L3_2 = A0_2.device
    L2_2 = L13_1
    L2_2 = L2_2[L3_2]
    if L2_2 == A0_2 then
      L3_2 = A0_2.device
      L2_2 = L13_1
      L2_2[L3_2] = nil
    end
  end
  L2_2 = A0_2.account
  if L2_2 then
    L3_2 = A0_2.account
    L2_2 = L15_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      L3_2 = A0_2.account
      L2_2 = L15_1
      L2_2 = L2_2[L3_2]
      L3_2 = A0_2.iccid
      L2_2[L3_2] = nil
    end
  end
  L2_2 = A0_2.pending
  if L2_2 then
    L3_2 = A0_2.pending
    L2_2 = L16_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      L3_2 = A0_2.pending
      L2_2 = L16_1
      L2_2 = L2_2[L3_2]
      L3_2 = A0_2.iccid
      L2_2[L3_2] = nil
    end
  end
  L2_2 = A0_2.home
  if L2_2 then
    L3_2 = A0_2.home
    L2_2 = L17_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      L3_2 = A0_2.home
      L2_2 = L17_1
      L2_2 = L2_2[L3_2]
      L3_2 = A0_2.iccid
      L2_2[L3_2] = nil
    end
  end
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L2_2 = A0_2.iccid
  L1_2 = L11_1
  L1_2[L2_2] = A0_2
  L2_2 = A0_2.number
  L1_2 = L12_1
  L1_2[L2_2] = A0_2
  L1_2 = L29_1
  L2_2 = A0_2.number
  L1_2 = L1_2(L2_2)
  L2_2 = L14_1
  L3_2 = A0_2.number
  L2_2[L1_2] = L3_2
  L1_2 = A0_2.device
  if L1_2 then
    L2_2 = A0_2.device
    L1_2 = L13_1
    L1_2[L2_2] = A0_2
  end
  L1_2 = A0_2.account
  if L1_2 then
    L2_2 = A0_2.account
    L1_2 = L15_1
    L4_2 = A0_2.account
    L3_2 = L15_1
    L3_2 = L3_2[L4_2]
    if not L3_2 then
      L3_2 = {}
    end
    L1_2[L2_2] = L3_2
    L2_2 = A0_2.account
    L1_2 = L15_1
    L1_2 = L1_2[L2_2]
    L2_2 = A0_2.iccid
    L1_2[L2_2] = A0_2
  end
  L1_2 = A0_2.pending
  if L1_2 then
    L2_2 = A0_2.pending
    L1_2 = L16_1
    L4_2 = A0_2.pending
    L3_2 = L16_1
    L3_2 = L3_2[L4_2]
    if not L3_2 then
      L3_2 = {}
    end
    L1_2[L2_2] = L3_2
    L2_2 = A0_2.pending
    L1_2 = L16_1
    L1_2 = L1_2[L2_2]
    L2_2 = A0_2.iccid
    L1_2[L2_2] = A0_2
  end
  L1_2 = A0_2.home
  if L1_2 then
    L2_2 = A0_2.home
    L1_2 = L17_1
    L4_2 = A0_2.home
    L3_2 = L17_1
    L3_2 = L3_2[L4_2]
    if not L3_2 then
      L3_2 = {}
    end
    L1_2[L2_2] = L3_2
    L2_2 = A0_2.home
    L1_2 = L17_1
    L1_2 = L1_2[L2_2]
    L2_2 = A0_2.iccid
    L1_2[L2_2] = A0_2
  end
end
function L40_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A0_2.pending
  if L2_2 == A1_2 then
    return
  end
  L2_2 = L38_1
  L3_2 = A0_2
  L2_2(L3_2)
  A0_2.pending = A1_2
  L2_2 = L39_1
  L3_2 = A0_2
  L2_2(L3_2)
end
function L41_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = tostring
  L3_2 = A0_2.iccid
  L2_2 = L2_2(L3_2)
  L1_2.iccid = L2_2
  L2_2 = tostring
  L3_2 = A0_2.number
  L2_2 = L2_2(L3_2)
  L1_2.number = L2_2
  L2_2 = A0_2.device
  if nil ~= L2_2 then
    L2_2 = A0_2.device
    if "" ~= L2_2 then
      L2_2 = tostring
      L3_2 = A0_2.device
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_23
      end
    end
  end
  L2_2 = nil
  ::lbl_23::
  L1_2.device = L2_2
  L2_2 = A0_2.account
  if nil ~= L2_2 then
    L2_2 = A0_2.account
    if "" ~= L2_2 then
      L2_2 = tostring
      L3_2 = A0_2.account
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_36
      end
    end
  end
  L2_2 = nil
  ::lbl_36::
  L1_2.account = L2_2
  L2_2 = A0_2.label
  if nil ~= L2_2 then
    L2_2 = A0_2.label
    if "" ~= L2_2 then
      L2_2 = tostring
      L3_2 = A0_2.label
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_49
      end
    end
  end
  L2_2 = nil
  ::lbl_49::
  L1_2.label = L2_2
  L2_2 = A0_2.home
  if nil ~= L2_2 then
    L2_2 = A0_2.home
    if "" ~= L2_2 then
      L2_2 = tostring
      L3_2 = A0_2.home
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_62
      end
    end
  end
  L2_2 = nil
  ::lbl_62::
  L1_2.home = L2_2
  L2_2 = tostring
  L3_2 = A0_2.origin
  if not L3_2 then
    L3_2 = "shop"
  end
  L2_2 = L2_2(L3_2)
  L1_2.origin = L2_2
  L2_2 = A0_2.pending
  if nil ~= L2_2 then
    L2_2 = A0_2.pending
    if "" ~= L2_2 then
      L2_2 = tostring
      L3_2 = A0_2.pending
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_82
      end
    end
  end
  L2_2 = nil
  ::lbl_82::
  L1_2.pending = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.created
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.created = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.updated
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.updated = L2_2
  return L1_2
end
function L42_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L38_1
  L4_2 = A0_2
  L3_2(L4_2)
  L3_2 = A1_2
  L4_2 = A2_2
  L5_2 = L28_1
  L5_2 = L5_2()
  A0_2.updated = L5_2
  A0_2.account = L4_2
  A0_2.device = L3_2
  L3_2 = L39_1
  L4_2 = A0_2
  L3_2(L4_2)
end
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L12_1
  L2_2 = L2_2[A0_2]
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
    L5_2 = tostring
    L6_2 = A1_2 or L6_2
    if not A1_2 then
      L6_2 = ""
    end
    L5_2 = L5_2(L6_2)
    if L4_2 ~= L5_2 then
      L4_2 = false
      return L4_2
    end
  end
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT cid FROM apex_phone_lines WHERE number = ?"
  L7_2 = {}
  L8_2 = A0_2
  L7_2[1] = L8_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 and L5_2 then
    L6_2 = tostring
    L7_2 = L5_2.cid
    L6_2 = L6_2(L7_2)
    L7_2 = tostring
    L8_2 = A1_2 or L8_2
    if not A1_2 then
      L8_2 = ""
    end
    L7_2 = L7_2(L8_2)
    if L6_2 ~= L7_2 then
      L6_2 = false
      return L6_2
    end
  end
  L6_2 = FW
  L6_2 = L6_2.FindCidByPhone
  if L6_2 then
    L6_2 = FW
    L6_2 = L6_2.FindCidByPhone
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
  end
  if L6_2 then
    L7_2 = tostring
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    L8_2 = tostring
    L9_2 = A1_2 or L9_2
    if not A1_2 then
      L9_2 = ""
    end
    L8_2 = L8_2(L9_2)
    if L7_2 ~= L8_2 then
      L7_2 = false
      return L7_2
    end
  end
  L7_2 = true
  return L7_2
end
function L44_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L4_2 = nil ~= A0_2
  L5_2 = 1
  L6_2 = 6
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = A0_2 or L9_2
    if not A0_2 then
      L9_2 = GenPhoneNumber
      if L9_2 then
        L9_2 = GenPhoneNumber
        L9_2 = L9_2()
        if L9_2 then
          goto lbl_25
        end
      end
      L9_2 = tostring
      L10_2 = math
      L10_2 = L10_2.random
      L11_2 = 1000000
      L12_2 = 9999999
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L10_2(L11_2, L12_2)
      L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    end
    ::lbl_25::
    L10_2 = L12_1
    L10_2 = L10_2[L9_2]
    if L10_2 then
      if L4_2 then
        L10_2 = nil
        L11_2 = "taken"
        return L10_2, L11_2
      end
    else
      L10_2 = A3_2 or L10_2
      if not A3_2 then
        L10_2 = L33_1
        L10_2 = L10_2()
      end
      L11_2 = {}
      L11_2.iccid = L10_2
      L11_2.number = L9_2
      L12_2 = A1_2 or L12_2
      if not A1_2 then
        L12_2 = "shop"
      end
      L11_2.origin = L12_2
      L11_2.home = A2_2
      L12_2 = L28_1
      L12_2 = L12_2()
      L11_2.created = L12_2
      L12_2 = L28_1
      L12_2 = L12_2()
      L11_2.updated = L12_2
      L12_2 = pcall
      L13_2 = MySQL
      L13_2 = L13_2.insert
      L13_2 = L13_2.await
      L14_2 = "INSERT INTO apex_phone_sims (iccid, number, device, account, label, home, origin, pending, created, updated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      L15_2 = {}
      L16_2 = L10_2
      L17_2 = L9_2
      L18_2 = nil
      L19_2 = nil
      L20_2 = nil
      L21_2 = A2_2
      L22_2 = L11_2.origin
      L23_2 = nil
      L24_2 = L11_2.created
      L25_2 = L11_2.updated
      L15_2[1] = L16_2
      L15_2[2] = L17_2
      L15_2[3] = L18_2
      L15_2[4] = L19_2
      L15_2[5] = L20_2
      L15_2[6] = L21_2
      L15_2[7] = L22_2
      L15_2[8] = L23_2
      L15_2[9] = L24_2
      L15_2[10] = L25_2
      L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
      if L12_2 then
        L14_2 = L39_1
        L15_2 = L11_2
        L14_2(L15_2)
        L14_2 = L2_1
        L15_2 = "new SIM %s (%s) origin %s"
        L16_2 = L9_2
        L17_2 = L10_2
        L18_2 = L11_2.origin
        L14_2(L15_2, L16_2, L17_2, L18_2)
        return L11_2
      end
      L14_2 = L34_1
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      if not L14_2 then
        L14_2 = nil
        L15_2 = "db"
        return L14_2, L15_2
      end
      L14_2 = pcall
      L15_2 = MySQL
      L15_2 = L15_2.single
      L15_2 = L15_2.await
      L16_2 = "SELECT * FROM apex_phone_sims WHERE (number = ? OR iccid = ?)"
      L17_2 = {}
      L18_2 = L9_2
      L19_2 = L10_2
      L17_2[1] = L18_2
      L17_2[2] = L19_2
      L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
      if L14_2 and L15_2 then
        L16_2 = L39_1
        L17_2 = L41_1
        L18_2 = L15_2
        L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L17_2(L18_2)
        L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
      end
      if L4_2 and L14_2 and L15_2 then
        L16_2 = tostring
        L17_2 = L15_2.number
        L16_2 = L16_2(L17_2)
        if L16_2 == L9_2 then
          L16_2 = nil
          L17_2 = "taken"
          return L16_2, L17_2
        end
      end
      A3_2 = nil
    end
  end
  L5_2 = nil
  L6_2 = "busy"
  return L5_2, L6_2
end
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = type
  L2_2 = L0_1.cardDescription
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L0_1.cardDescription
    if "" ~= L1_2 then
      L1_2 = L0_1.cardDescription
      if L1_2 then
        goto lbl_13
      end
    end
  end
  L1_2 = "Number: %s"
  ::lbl_13::
  L2_2 = pcall
  L3_2 = string
  L3_2 = L3_2.format
  L4_2 = L1_2
  L5_2 = A0_2.number
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = type
  L5_2 = L0_1.cardLabel
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L0_1.cardLabel
    if "" ~= L4_2 then
      L4_2 = L0_1.cardLabel
      if L4_2 then
        goto lbl_31
      end
    end
  end
  L4_2 = nil
  ::lbl_31::
  L5_2 = {}
  L6_2 = A0_2.iccid
  L5_2.iccid = L6_2
  L6_2 = A0_2.number
  L5_2.number = L6_2
  L5_2.label = L4_2
  L6_2 = L3_2 or L6_2
  if not L2_2 or not L3_2 then
    L6_2 = A0_2.number
  end
  L5_2.description = L6_2
  return L5_2
end
function L46_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = exports
    L0_3 = L0_3["qb-core"]
    L1_3 = L0_3
    L0_3 = L0_3.GetCoreObject
    return L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 then
    L2_2 = type
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 and L1_2 then
      goto lbl_14
      L2_2 = L1_2 or L2_2
    end
  end
  L2_2 = nil
  ::lbl_14::
  return L2_2
end
function L47_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = {}
  L2_2 = L9_1
  if "ox" == L2_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.GetSlotsWithItem
      L2_3 = A0_2
      L3_3 = L10_1
      return L0_3(L1_3, L2_3, L3_3)
    end
    L2_2, L3_2 = L2_2(L3_2)
    if not L2_2 then
      goto lbl_147
    end
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" ~= L4_2 then
      goto lbl_147
    end
    L4_2 = pairs
    L5_2 = L3_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = tonumber
        L11_2 = L9_2.count
        L10_2 = L10_2(L11_2)
        if not L10_2 then
          L10_2 = 0
        end
        if L10_2 > 0 then
          L10_2 = #L1_2
          L10_2 = L10_2 + 1
          L11_2 = {}
          L12_2 = math
          L12_2 = L12_2.tointeger
          L13_2 = tonumber
          L14_2 = L9_2.slot
          L13_2, L14_2 = L13_2(L14_2)
          L12_2 = L12_2(L13_2, L14_2)
          L11_2.slot = L12_2
          L12_2 = type
          L13_2 = L9_2.metadata
          L12_2 = L12_2(L13_2)
          if "table" == L12_2 then
            L12_2 = L9_2.metadata
            if L12_2 then
              goto lbl_55
            end
          end
          L12_2 = {}
          ::lbl_55::
          L11_2.md = L12_2
          L12_2 = tonumber
          L13_2 = L9_2.count
          L12_2 = L12_2(L13_2)
          if not L12_2 then
            L12_2 = 1
          end
          L11_2.count = L12_2
          L1_2[L10_2] = L11_2
        end
      end
    end
  else
    L2_2 = L9_1
    if "qb" == L2_2 then
      L2_2 = L8_1.qbPlayer
      L3_2 = A0_2
      L2_2 = L2_2(L3_2)
      L3_2 = L2_2
      if L2_2 then
        L3_2 = L2_2.PlayerData
        L3_2 = L3_2.items
      end
      L4_2 = type
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      if "table" == L4_2 then
        L4_2 = pairs
        L5_2 = L3_2
        L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
        for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
          L10_2 = type
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          if "table" == L10_2 then
            L10_2 = L9_2.name
            L11_2 = L10_1
            if L10_2 == L11_2 then
              L10_2 = tonumber
              L11_2 = L9_2.amount
              if not L11_2 then
                L11_2 = L9_2.count
              end
              L10_2 = L10_2(L11_2)
              if not L10_2 then
                L10_2 = 0
              end
              if L10_2 > 0 then
                L10_2 = #L1_2
                L10_2 = L10_2 + 1
                L11_2 = {}
                L12_2 = math
                L12_2 = L12_2.tointeger
                L13_2 = tonumber
                L14_2 = L9_2.slot
                if not L14_2 then
                  L14_2 = L8_2
                end
                L13_2, L14_2 = L13_2(L14_2)
                L12_2 = L12_2(L13_2, L14_2)
                L11_2.slot = L12_2
                L12_2 = type
                L13_2 = L9_2.info
                L12_2 = L12_2(L13_2)
                if "table" == L12_2 then
                  L12_2 = L9_2.info
                  if L12_2 then
                    goto lbl_132
                  end
                end
                L12_2 = {}
                ::lbl_132::
                L11_2.md = L12_2
                L12_2 = tonumber
                L13_2 = L9_2.amount
                if not L13_2 then
                  L13_2 = L9_2.count
                end
                L12_2 = L12_2(L13_2)
                if not L12_2 then
                  L12_2 = 1
                end
                L11_2.count = L12_2
                L1_2[L10_2] = L11_2
              end
            end
          end
        end
      end
    end
  end
  ::lbl_147::
  L2_2 = table
  L2_2 = L2_2.sort
  L3_2 = L1_2
  function L4_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.slot
    if not L2_3 then
      L2_3 = 9999
    end
    L3_3 = A1_3.slot
    if not L3_3 then
      L3_3 = 9999
    end
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L2_2(L3_2, L4_2)
  return L1_2
end
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  A1_2 = L2_2
  if not A1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L9_1
  if "ox" == L2_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.GetSlot
      L2_3 = A0_2
      L3_3 = A1_2
      return L0_3(L1_3, L2_3, L3_3)
    end
    L2_2, L3_2 = L2_2(L3_2)
    if L2_2 then
      L4_2 = type
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      if "table" == L4_2 then
        L4_2 = L3_2.name
        L5_2 = L10_1
        if L4_2 == L5_2 then
          L4_2 = tonumber
          L5_2 = L3_2.count
          L4_2 = L4_2(L5_2)
          if not L4_2 then
            L4_2 = 0
          end
          if L4_2 > 0 then
            L4_2 = {}
            L4_2.slot = A1_2
            L5_2 = type
            L6_2 = L3_2.metadata
            L5_2 = L5_2(L6_2)
            if "table" == L5_2 then
              L5_2 = L3_2.metadata
              if L5_2 then
                goto lbl_50
              end
            end
            L5_2 = {}
            ::lbl_50::
            L4_2.md = L5_2
            L5_2 = tonumber
            L6_2 = L3_2.count
            L5_2 = L5_2(L6_2)
            if not L5_2 then
              L5_2 = 1
            end
            L4_2.count = L5_2
            return L4_2
          end
        end
      end
    end
    L4_2 = nil
    return L4_2
  end
  L2_2 = ipairs
  L3_2 = L47_1
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.slot
    if L8_2 == A1_2 then
      return L7_2
    end
  end
  L2_2 = nil
  return L2_2
end
function L49_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L9_1
  if "ox" == L2_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.RemoveItem
      L2_3 = A0_2
      L3_3 = L10_1
      L4_3 = 1
      L5_3 = nil
      L6_3 = A1_2.slot
      return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
    end
    L2_2, L3_2 = L2_2(L3_2)
    if L2_2 and L3_2 then
      L4_2 = true
      if L4_2 then
        goto lbl_15
      end
    end
    L4_2 = false
    ::lbl_15::
    return L4_2
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = exports
    L0_3 = L0_3["qb-inventory"]
    L1_3 = L0_3
    L0_3 = L0_3.RemoveItem
    L2_3 = A0_2
    L3_3 = L10_1
    L4_3 = 1
    L5_3 = A1_2.slot
    L6_3 = "Unique_Phone sim"
    return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 and L3_2 then
    L4_2 = true
    return L4_2
  end
  L4_2 = L8_1.qbPlayer
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L4_2.Functions
    if L5_2 then
      L5_2 = L4_2.Functions
      L5_2 = L5_2.RemoveItem
      if L5_2 then
        L5_2 = pcall
        L6_2 = L4_2.Functions
        L6_2 = L6_2.RemoveItem
        L7_2 = L10_1
        L8_2 = 1
        L9_2 = A1_2.slot
        L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
        L7_2 = L5_2 or L7_2
        L7_2 = L5_2 and false ~= L6_2 and nil ~= L6_2
        return L7_2
      end
    end
  end
  L5_2 = false
  return L5_2
end
function L50_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L9_1
  if "ox" == L2_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.CanCarryItem
      L2_3 = A0_2
      L3_3 = L10_1
      L4_3 = 1
      L5_3 = A1_2
      return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
    end
    L2_2, L3_2 = L2_2(L3_2)
    L4_2 = L2_2 or L4_2
    L4_2 = L2_2 and (true == L3_2 or 1 == L3_2)
    return L4_2
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = exports
    L0_3 = L0_3["qb-inventory"]
    L1_3 = L0_3
    L0_3 = L0_3.CanAddItem
    L2_3 = A0_2
    L3_3 = L10_1
    L4_3 = 1
    return L0_3(L1_3, L2_3, L3_3, L4_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 and nil ~= L3_2 then
    L4_2 = true == L3_2
    return L4_2
  end
  L4_2 = true
  return L4_2
end
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L9_1
  if "ox" == L2_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.AddItem
      L2_3 = A0_2
      L3_3 = L10_1
      L4_3 = 1
      L5_3 = A1_2
      return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
    end
    L2_2, L3_2 = L2_2(L3_2)
    if L2_2 then
      L4_2 = type
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
    end
    L4_2 = true == L3_2 or L4_2
    return L4_2
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = exports
    L0_3 = L0_3["qb-inventory"]
    L1_3 = L0_3
    L0_3 = L0_3.AddItem
    L2_3 = A0_2
    L3_3 = L10_1
    L4_3 = 1
    L5_3 = false
    L6_3 = A1_2
    L7_3 = "Unique_Phone sim"
    return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 and L3_2 then
    L4_2 = true
    return L4_2
  end
  L4_2 = L8_1.qbPlayer
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L4_2.Functions
    if L5_2 then
      L5_2 = L4_2.Functions
      L5_2 = L5_2.AddItem
      if L5_2 then
        L5_2 = pcall
        L6_2 = L4_2.Functions
        L6_2 = L6_2.AddItem
        L7_2 = L10_1
        L8_2 = 1
        L9_2 = false
        L10_2 = A1_2
        L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
        L7_2 = L5_2 or L7_2
        L7_2 = L5_2 and false ~= L6_2 and nil ~= L6_2
        return L7_2
      end
    end
  end
  L5_2 = false
  return L5_2
end
function L52_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if A1_2 then
    L3_2 = A1_2.count
    if not L3_2 then
      L3_2 = 1
    end
    if 1 == L3_2 then
      goto lbl_10
    end
  end
  do return end
  ::lbl_10::
  L3_2 = L8_1.copy
  L4_2 = A1_2.md
  L3_2 = L3_2(L4_2)
  if A2_2 then
    L4_2 = A2_2.iccid
    if L4_2 then
      goto lbl_19
    end
  end
  L4_2 = nil
  ::lbl_19::
  if A2_2 then
    L5_2 = A2_2.number
    if L5_2 then
      goto lbl_25
    end
  end
  L5_2 = nil
  ::lbl_25::
  L6_2 = L3_2.apex_sim
  if L6_2 == L4_2 then
    L6_2 = L3_2.apex_simnum
    if L6_2 == L5_2 then
      return
    end
  end
  L6_2 = L4_2
  L3_2.apex_simnum = L5_2
  L3_2.apex_sim = L6_2
  L6_2 = L8_1.writeMeta
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = L3_2
  L6_2(L7_2, L8_2, L9_2)
end
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = L8_1.slots
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.md
    L8_2 = L8_2.apex_serial
    if L8_2 == A1_2 then
      return L7_2
    end
  end
  L2_2 = nil
  return L2_2
end
function L54_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = Config
  L2_2 = L2_2.Devices
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = Config
    L1_2 = L1_2.Devices
    L1_2 = L1_2[A0_2]
    if L1_2 then
      goto lbl_13
    end
  end
  L1_2 = nil
  ::lbl_13::
  if L1_2 then
    L2_2 = L1_2.label
    if L2_2 then
      goto lbl_19
    end
  end
  L2_2 = A0_2
  ::lbl_19::
  return L2_2
end
function L55_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = L24_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = GetResourceKvpString
  L2_2 = L5_1
  L3_2 = A0_2
  L2_2 = L2_2 .. L3_2
  L1_2 = L1_2(L2_2)
  if "1" == L1_2 then
    L1_2 = L24_1
    L1_2[A0_2] = true
    L1_2 = true
    return L1_2
  end
  L1_2 = false
  return L1_2
end
function L56_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L24_1
  L1_2[A0_2] = true
  L1_2 = SetResourceKvp
  L2_2 = L5_1
  L3_2 = A0_2
  L2_2 = L2_2 .. L3_2
  L3_2 = "1"
  L1_2(L2_2, L3_2)
end
function L57_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if A0_2 then
    L3_2 = L50_1
    L4_2 = A0_2
    L5_2 = L45_1
    L6_2 = A2_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    if L3_2 then
      L3_2 = L51_1
      L4_2 = A0_2
      L5_2 = L45_1
      L6_2 = A2_2
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
      L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
      if L3_2 then
        L3_2 = A2_2.pending
        if L3_2 then
          L3_2 = pcall
          L4_2 = MySQL
          L4_2 = L4_2.update
          L4_2 = L4_2.await
          L5_2 = "UPDATE apex_phone_sims SET pending = NULL WHERE iccid = ?"
          L6_2 = {}
          L7_2 = A2_2.iccid
          L6_2[1] = L7_2
          L3_2(L4_2, L5_2, L6_2)
          L3_2 = L40_1
          L4_2 = A2_2
          L5_2 = nil
          L3_2(L4_2, L5_2)
        end
        L3_2 = true
        return L3_2
      end
    end
  end
  L3_2 = A2_2.pending
  if L3_2 ~= A1_2 then
    L3_2 = pcall
    L4_2 = MySQL
    L4_2 = L4_2.update
    L4_2 = L4_2.await
    L5_2 = "UPDATE apex_phone_sims SET pending = ? WHERE iccid = ?"
    L6_2 = {}
    L7_2 = A1_2
    L8_2 = A2_2.iccid
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L3_2(L4_2, L5_2, L6_2)
    L3_2 = L40_1
    L4_2 = A2_2
    L5_2 = A1_2
    L3_2(L4_2, L5_2)
  end
  L3_2 = false
  return L3_2
end
function L58_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L16_1
  L2_2 = L2_2[A1_2]
  if L2_2 then
    L3_2 = next
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L3_2 = {}
  L4_2 = pairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L3_2[L10_2] = L9_2
  end
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.device
    if not L10_2 then
      L10_2 = L57_1
      L11_2 = A0_2
      L12_2 = A1_2
      L13_2 = L9_2
      L10_2(L11_2, L12_2, L13_2)
    end
  end
end
function L59_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = A1_2.md
  L4_2 = L4_2.apex_serial
  if L4_2 then
    L5_2 = L13_1
    L5_2 = L5_2[L4_2]
    if not L5_2 then
      goto lbl_11
    end
  end
  L5_2 = false
  do return L5_2 end
  ::lbl_11::
  L5_2 = pcall
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_sims SET device = ?, account = ?, pending = NULL, updated = ? WHERE iccid = ? AND device IS NULL"
  L8_2 = {}
  L9_2 = L4_2
  L10_2 = A3_2
  L11_2 = L28_1
  L11_2 = L11_2()
  L12_2 = A2_2.iccid
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L7_2 = tonumber
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      L7_2 = 0
    end
    if 1 == L7_2 then
      goto lbl_37
    end
  end
  L7_2 = false
  do return L7_2 end
  ::lbl_37::
  L7_2 = L40_1
  L8_2 = A2_2
  L9_2 = nil
  L7_2(L8_2, L9_2)
  L7_2 = L42_1
  L8_2 = A2_2
  L9_2 = L4_2
  L10_2 = A3_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = L52_1
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = A2_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = true
  return L7_2
end
function L60_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L1_2 = A0_2.device
    if not L1_2 then
      goto lbl_7
    end
  end
  do return end
  ::lbl_7::
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_sims WHERE iccid = ? AND device IS NULL"
  L4_2 = {}
  L5_2 = A0_2.iccid
  L4_2[1] = L5_2
  L1_2(L2_2, L3_2, L4_2)
  L1_2 = L38_1
  L2_2 = A0_2
  L1_2(L2_2)
end
function L61_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = L8_1.ownerOf
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = nil == L2_2 or L2_2 == A1_2
  return L3_2
end
L62_1 = {}
L63_1 = {}
function L64_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if A0_2 then
    L3_2 = L55_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = L25_1
      L3_2 = L3_2[A0_2]
      if not L3_2 then
        L3_2 = L62_1
        L3_2 = L3_2[A0_2]
        if not L3_2 then
          goto lbl_17
        end
      end
    end
  end
  do return end
  ::lbl_17::
  L3_2 = L63_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L4_2 = L63_1
    L4_2 = L4_2[A0_2]
    L3_2 = L3_2 - L4_2
    L4_2 = 30000
    if L3_2 < L4_2 then
      return
    end
  end
  L3_2 = L62_1
  L3_2[A0_2] = true
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3
    L0_3 = Accounts
    L1_3 = A0_2
    L0_3 = L0_3[L1_3]
    if not L0_3 then
      L1_3 = pcall
      L2_3 = MySQL
      L2_3 = L2_3.single
      L2_3 = L2_3.await
      L3_3 = "SELECT phone, created FROM apex_phone_accounts WHERE citizenid = ?"
      L4_3 = {}
      L5_3 = A0_2
      L4_3[1] = L5_3
      L1_3, L2_3 = L1_3(L2_3, L3_3, L4_3)
      L0_3 = L2_3 or L0_3
      if not L1_3 or not L2_3 then
        L0_3 = nil
      end
    end
    if not L0_3 then
      L2_3 = A0_2
      L1_3 = L63_1
      L3_3 = GetGameTimer
      L3_3 = L3_3()
      L1_3[L2_3] = L3_3
      return
    end
    L2_3 = A0_2
    L1_3 = L63_1
    L1_3[L2_3] = nil
    L1_3 = pcall
    L2_3 = MySQL
    L2_3 = L2_3.query
    L2_3 = L2_3.await
    L3_3 = "SELECT number FROM apex_phone_lines WHERE cid = ? ORDER BY slot ASC"
    L4_3 = {}
    L5_3 = A0_2
    L4_3[1] = L5_3
    L1_3, L2_3 = L1_3(L2_3, L3_3, L4_3)
    if L1_3 then
      L3_3 = type
      L4_3 = L2_3
      L3_3 = L3_3(L4_3)
      if "table" == L3_3 and L2_3 then
        goto lbl_54
      end
    end
    L3_3 = {}
    L2_3 = L3_3
    ::lbl_54::
    L3_3 = {}
    L4_3 = {}
    L5_3 = L0_3.phone
    if nil ~= L5_3 then
      L5_3 = tostring
      L6_3 = L0_3.phone
      L5_3 = L5_3(L6_3)
      if L5_3 then
        goto lbl_67
      end
    end
    L5_3 = ""
    ::lbl_67::
    L6_3 = SimConfig
    if L6_3 then
      L6_3 = SimConfig
      L6_3 = L6_3()
      L6_3 = L6_3.required
      if L6_3 then
        goto lbl_81
      end
    end
    L6_3 = SimOptedOut
    if L6_3 then
      L6_3 = SimOptedOut
      L7_3 = A0_2
      L6_3 = L6_3(L7_3)
    end
    ::lbl_81::
    if "" ~= L5_3 then
      if L6_3 then
        L7_3 = #L2_3
        if not (L7_3 > 0) then
          goto lbl_93
        end
      end
      L7_3 = #L3_3
      L7_3 = L7_3 + 1
      L3_3[L7_3] = L5_3
      L4_3[L5_3] = true
    end
    ::lbl_93::
    L7_3 = ipairs
    L8_3 = L2_3
    L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
    for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
      L13_3 = tostring
      L14_3 = L12_3.number
      L13_3 = L13_3(L14_3)
      L14_3 = L4_3[L13_3]
      if not L14_3 then
        L4_3[L13_3] = true
        L14_3 = #L3_3
        L14_3 = L14_3 + 1
        L3_3[L14_3] = L13_3
      end
    end
    L7_3 = true
    L8_3 = ipairs
    L9_3 = L3_3
    L8_3, L9_3, L10_3, L11_3 = L8_3(L9_3)
    for L12_3, L13_3 in L8_3, L9_3, L10_3, L11_3 do
      L14_3 = L12_1
      L14_3 = L14_3[L13_3]
      if not L14_3 then
        L15_3 = L44_1
        L16_3 = L13_3
        L17_3 = "migrated"
        L18_3 = A0_2
        L15_3 = L15_3(L16_3, L17_3, L18_3)
        L14_3 = L15_3
        if L14_3 and L7_3 then
          L15_3 = A2_2
          if L15_3 then
            L15_3 = A1_2
            if L15_3 then
              L15_3 = L61_1
              L16_3 = A2_2
              L17_3 = A0_2
              L15_3 = L15_3(L16_3, L17_3)
              if L15_3 then
                L15_3 = A2_2.md
                L15_3 = L15_3.apex_serial
                if L15_3 then
                  L15_3 = A2_2.md
                  L16_3 = L15_3.apex_serial
                  L15_3 = L13_1
                  L15_3 = L15_3[L16_3]
                  if not L15_3 then
                    L15_3 = L59_1
                    L16_3 = A1_2
                    L17_3 = A2_2
                    L18_3 = L14_3
                    L19_3 = L8_1.ownerOf
                    L20_3 = A2_2
                    L19_3 = L19_3(L20_3)
                    if not L19_3 then
                      L19_3 = A0_2
                    end
                    L15_3(L16_3, L17_3, L18_3, L19_3)
                end
              end
            end
          end
        end
        elseif L14_3 then
          L15_3 = L57_1
          L16_3 = A1_2
          L17_3 = A0_2
          L18_3 = L14_3
          L15_3(L16_3, L17_3, L18_3)
        end
        if L14_3 then
          L15_3 = L2_1
          L16_3 = "migration: %s -> SIM %s"
          L17_3 = A0_2
          L18_3 = L13_3
          L15_3(L16_3, L17_3, L18_3)
        end
      end
      L7_3 = false
    end
    L8_3 = L56_1
    L9_3 = A0_2
    L8_3(L9_3)
  end
  L3_2, L4_2 = L3_2(L4_2)
  L5_2 = L62_1
  L5_2[A0_2] = nil
  if not L3_2 then
    L5_2 = L1_1
    L6_2 = "migration of account %s failed: %s"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = tostring
    L9_2 = A0_2
    L8_2 = L8_2(L9_2)
    L9_2 = tostring
    L10_2 = L4_2
    L9_2, L10_2 = L9_2(L10_2)
    L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  end
end
function L65_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L20_1
  L1_2 = L1_2[A0_2]
  L2_2 = L1_2
  if L1_2 then
    L3_2 = L1_2.serial
    L2_2 = L13_1
    L2_2 = L2_2[L3_2]
  end
  if L2_2 then
    L3_2 = L2_2.number
    if L3_2 then
      goto lbl_14
    end
  end
  L3_2 = nil
  ::lbl_14::
  return L3_2
end
L66_1 = nil
L67_1 = nil
L68_1 = nil
function L69_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L23_1
  L4_2[A0_2] = A2_2
  L4_2 = InvalidateOnlineIndex
  if L4_2 then
    L4_2 = InvalidateOnlineIndex
    L4_2()
  end
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L1_3 = L0_3
    L0_3 = L0_3.set
    L2_3 = "apex_phoneNumber"
    L3_3 = A2_2
    L4_3 = true
    L0_3(L1_3, L2_3, L3_3, L4_3)
  end
  L4_2(L5_2)
  L4_2 = MessagesPresenceSet
  if L4_2 then
    L4_2 = pcall
    L5_2 = MessagesPresenceSet
    L6_2 = A0_2
    L4_2(L5_2, L6_2)
  end
  if A2_2 then
    L4_2 = Config
    L4_2 = L4_2.SyncNumberToCharInfo
    if L4_2 then
      L4_2 = pcall
      L5_2 = FW
      L5_2 = L5_2.SetPhone
      L6_2 = A0_2
      L7_2 = A2_2
      L4_2(L5_2, L6_2, L7_2)
    end
  end
  if nil ~= A1_2 then
    L4_2 = EndCallsOf
    if L4_2 then
      L4_2 = pcall
      L5_2 = EndCallsOf
      L6_2 = A0_2
      L4_2(L5_2, L6_2)
    end
    L4_2 = RecadoCallsLeave
    if L4_2 then
      L4_2 = pcall
      L5_2 = RecadoCallsLeave
      L6_2 = A0_2
      L4_2(L5_2, L6_2)
    end
  end
  L4_2 = BuildPlayer
  if L4_2 then
    L4_2 = BuildPlayer
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L5_2 = Push
      L6_2 = A0_2
      L7_2 = "player"
      L8_2 = L4_2
      L5_2(L6_2, L7_2, L8_2)
    end
  end
  L4_2 = L66_1
  if L4_2 then
    L4_2 = Push
    L5_2 = A0_2
    L6_2 = "sim:changed"
    L7_2 = L66_1
    L8_2 = A0_2
    L9_2 = A3_2 or L9_2
    if not A3_2 then
      L9_2 = "change"
    end
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  end
  L4_2 = TriggerEvent
  L5_2 = "apex_phone:simNumberChanged"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = L2_1
  L5_2 = "number of %s: %s -> %s (%s)"
  L6_2 = tostring
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = tostring
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L8_2 = tostring
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  L9_2 = tostring
  L10_2 = A3_2
  L9_2, L10_2 = L9_2(L10_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L22_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L3_2 = L2_2.cid
    if L3_2 == A1_2 then
      L3_2 = L2_2.serial
      return L3_2
    end
  end
  L3_2 = GetResourceKvpString
  L4_2 = L6_1
  L5_2 = A1_2
  L4_2 = L4_2 .. L5_2
  L3_2 = L3_2(L4_2)
  L4_2 = L22_1
  L5_2 = {}
  L5_2.cid = A1_2
  L6_2 = L3_2 or L6_2
  if nil == L3_2 or "" == L3_2 or not L3_2 then
    L6_2 = nil
  end
  L5_2.serial = L6_2
  L4_2[A0_2] = L5_2
  L4_2 = L22_1
  L4_2 = L4_2[A0_2]
  L4_2 = L4_2.serial
  return L4_2
end
function L71_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  if not A1_2 or not A2_2 then
    return
  end
  L3_2 = L22_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L4_2 = L3_2.cid
    if L4_2 == A1_2 then
      L4_2 = L3_2.serial
      if L4_2 == A2_2 then
        return
      end
    end
  end
  L4_2 = L22_1
  L5_2 = {}
  L5_2.cid = A1_2
  L5_2.serial = A2_2
  L4_2[A0_2] = L5_2
  L4_2 = SetResourceKvp
  L5_2 = L6_1
  L6_2 = A1_2
  L5_2 = L5_2 .. L6_2
  L6_2 = A2_2
  L4_2(L5_2, L6_2)
end
function L72_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L32_1
  L3_2 = A1_2.md
  L3_2 = L3_2.apex_sim
  L2_2 = L2_2(L3_2)
  L3_2 = L31_1
  L4_2 = A1_2.md
  L4_2 = L4_2.apex_simnum
  L3_2 = L3_2(L4_2)
  if L2_2 and L3_2 then
    L4_2 = L11_1
    L4_2 = L4_2[L2_2]
    if not L4_2 then
      L4_2 = L12_1
      L4_2 = L4_2[L3_2]
      if not L4_2 then
        goto lbl_35
      end
    end
  end
  L4_2 = A1_2.md
  L4_2 = L4_2.apex_sim
  if not L4_2 then
    L4_2 = A1_2.md
    L4_2 = L4_2.apex_simnum
    if not L4_2 then
      goto lbl_34
    end
  end
  L4_2 = L52_1
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = nil
  L4_2(L5_2, L6_2, L7_2)
  ::lbl_34::
  do return end
  ::lbl_35::
  L4_2 = L44_1
  L5_2 = L3_2
  L6_2 = "adopted"
  L7_2 = nil
  L8_2 = L2_2
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if L4_2 then
    L5_2 = L59_1
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = L4_2
    L9_2 = L8_1.ownerOf
    L10_2 = A1_2
    L9_2, L10_2 = L9_2(L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  end
end
function L73_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if A0_2 then
    L2_2 = L8_1
    if L2_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L2_2 = L20_1
  L2_2 = L2_2[A0_2]
  L3_2 = L8_1.realCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = nil
  if L3_2 then
    L5_2 = L8_1.slots
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_26
    end
  end
  L5_2 = {}
  ::lbl_26::
  if L3_2 then
    L6_2 = L8_1.session
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L7_2 = L6_2.serial
      if L7_2 then
        L7_2 = ipairs
        L8_2 = L5_2
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
          L13_2 = L12_2.md
          L13_2 = L13_2.apex_serial
          L14_2 = L6_2.serial
          if L13_2 == L14_2 then
            L4_2 = L12_2
            break
          end
        end
      end
    end
    if not L4_2 then
      L7_2 = L70_1
      L8_2 = A0_2
      L9_2 = L3_2
      L7_2 = L7_2(L8_2, L9_2)
      if L7_2 then
        L8_2 = ipairs
        L9_2 = L5_2
        L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
        for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
          L14_2 = L13_2.md
          L14_2 = L14_2.apex_serial
          if L14_2 == L7_2 then
            L14_2 = L61_1
            L15_2 = L13_2
            L16_2 = L3_2
            L14_2 = L14_2(L15_2, L16_2)
            if L14_2 then
              L4_2 = L13_2
              break
            end
          end
        end
      end
    end
    if not L4_2 then
      L7_2 = ipairs
      L8_2 = L5_2
      L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
      for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
        L13_2 = L61_1
        L14_2 = L12_2
        L15_2 = L3_2
        L13_2 = L13_2(L14_2, L15_2)
        if L13_2 then
          L13_2 = L12_2.md
          L13_2 = L13_2.apex_serial
          if L13_2 then
            L13_2 = L12_2.md
            L14_2 = L13_2.apex_serial
            L13_2 = L13_1
            L13_2 = L13_2[L14_2]
            if L13_2 then
              L4_2 = L12_2
              break
            end
          end
        end
      end
    end
    if not L4_2 then
      L7_2 = ipairs
      L8_2 = L5_2
      L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
      for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
        L13_2 = L61_1
        L14_2 = L12_2
        L15_2 = L3_2
        L13_2 = L13_2(L14_2, L15_2)
        if L13_2 then
          L13_2 = L12_2.count
          if not L13_2 then
            L13_2 = 1
          end
          if 1 == L13_2 then
            L4_2 = L12_2
            break
          end
        end
      end
    end
    if L4_2 then
      L7_2 = L4_2.md
      L7_2 = L7_2.apex_serial
      if not L7_2 then
        L7_2 = L4_2.count
        if not L7_2 then
          L7_2 = 1
        end
        if 1 == L7_2 then
          L7_2 = L8_1.stamp
          L8_2 = A0_2
          L9_2 = L4_2
          L10_2 = L3_2
          L7_2 = L7_2(L8_2, L9_2, L10_2)
          if L7_2 then
            goto lbl_147
          end
        end
        L4_2 = nil
      end
    end
  end
  ::lbl_147::
  if L4_2 then
    L6_2 = {}
    L7_2 = L4_2.md
    L7_2 = L7_2.apex_serial
    L6_2.serial = L7_2
    L7_2 = L4_2.slot
    L6_2.slot = L7_2
    L7_2 = L4_2.name
    L6_2.item = L7_2
    L7_2 = L8_1.ownerOf
    L8_2 = L4_2
    L7_2 = L7_2(L8_2)
    L6_2.owner = L7_2
    L6_2.cid = L3_2
    if L6_2 then
      goto lbl_166
    end
  end
  L6_2 = nil
  ::lbl_166::
  if L2_2 then
    L8_2 = L2_2.serial
    L7_2 = L21_1
    L7_2 = L7_2[L8_2]
    if L7_2 == A0_2 then
      if L6_2 then
        L7_2 = L6_2.serial
        L8_2 = L2_2.serial
        if L7_2 == L8_2 then
          goto lbl_182
        end
      end
      L8_2 = L2_2.serial
      L7_2 = L21_1
      L7_2[L8_2] = nil
    end
  end
  ::lbl_182::
  if L6_2 then
    L8_2 = L6_2.serial
    L7_2 = L21_1
    L7_2[L8_2] = A0_2
  end
  L7_2 = L20_1
  L7_2[A0_2] = L6_2
  if L4_2 then
    L8_2 = L6_2.serial
    L7_2 = L13_1
    L7_2 = L7_2[L8_2]
    if not L7_2 then
      L8_2 = L4_2.md
      L8_2 = L8_2.apex_sim
      if not L8_2 then
        L8_2 = L4_2.md
        L8_2 = L8_2.apex_simnum
        if not L8_2 then
          goto lbl_209
        end
      end
      L8_2 = L72_1
      L9_2 = A0_2
      L10_2 = L4_2
      L8_2(L9_2, L10_2)
    ::lbl_209::
    elseif L7_2 then
      L8_2 = L4_2.md
      L8_2 = L8_2.apex_sim
      L9_2 = L7_2.iccid
      if L8_2 == L9_2 then
        L8_2 = L4_2.md
        L8_2 = L8_2.apex_simnum
        L9_2 = L7_2.number
        if L8_2 == L9_2 then
          goto lbl_226
        end
      end
      L8_2 = L52_1
      L9_2 = A0_2
      L10_2 = L4_2
      L11_2 = L7_2
      L8_2(L9_2, L10_2, L11_2)
    end
    ::lbl_226::
    L8_2 = L64_1
    L9_2 = L3_2
    L10_2 = A0_2
    L11_2 = L4_2
    L8_2(L9_2, L10_2, L11_2)
  end
  if L3_2 then
    L7_2 = L58_1
    L8_2 = A0_2
    L9_2 = L3_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = L65_1
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = L23_1
  L8_2 = L8_2[A0_2]
  if L7_2 ~= L8_2 then
    L8_2 = L69_1
    L9_2 = A0_2
    L10_2 = L23_1
    L10_2 = L10_2[A0_2]
    L11_2 = L7_2
    L12_2 = A1_2
    L8_2(L9_2, L10_2, L11_2, L12_2)
  else
    L8_2 = L2_2
    if L2_2 then
      L8_2 = L2_2.serial
    end
    L9_2 = L6_2
    if L6_2 then
      L9_2 = L6_2.serial
    end
    if L8_2 ~= L9_2 then
      L8_2 = L66_1
      if L8_2 then
        L8_2 = Push
        L9_2 = A0_2
        L10_2 = "sim:changed"
        L11_2 = L66_1
        L12_2 = A0_2
        L13_2 = A1_2 or L13_2
        if not A1_2 then
          L13_2 = "device"
        end
        L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L11_2(L12_2, L13_2)
        L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      end
    end
  end
  return L6_2
end
function L74_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L20_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L4_2 = L2_2.serial
    L3_2 = L13_1
    L3_2 = L3_2[L4_2]
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L47_1
  L7_2 = A0_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L31_1
    L12_2 = L10_2.md
    L12_2 = L12_2.number
    L11_2 = L11_2(L12_2)
    L12_2 = L32_1
    L13_2 = L10_2.md
    L13_2 = L13_2.iccid
    L12_2 = L12_2(L13_2)
    L13_2 = #L4_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L15_2 = L10_2.slot
    L14_2.slot = L15_2
    L14_2.number = L11_2
    L14_2.iccid = L12_2
    L15_2 = L10_2.count
    L14_2.count = L15_2
    L4_2[L13_2] = L14_2
  end
  L5_2 = L8_1
  if L5_2 then
    L5_2 = L8_1.session
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
  end
  L6_2 = SimConfig
  if L6_2 then
    L6_2 = SimConfig
    L6_2 = L6_2()
    if L6_2 then
      goto lbl_57
    end
  end
  L6_2 = {}
  ::lbl_57::
  L7_2 = L67_1
  L7_2 = L7_2()
  L8_2 = L8_1
  if L8_2 then
    L8_2 = L8_1.realCid
    L9_2 = A0_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      goto lbl_68
    end
  end
  L8_2 = nil
  ::lbl_68::
  L9_2 = {}
  L9_2.ok = true
  L9_2.physical = true
  L9_2.reason = A1_2
  L10_2 = {}
  L11_2 = L7_2.enabled
  L10_2.enabled = L11_2
  L11_2 = L7_2.price
  L10_2.price = L11_2
  L11_2 = L7_2.enabled
  if L11_2 then
    L11_2 = L68_1
    L12_2 = A0_2
    L13_2 = L8_2
    L11_2 = L11_2(L12_2, L13_2)
    if L11_2 then
      goto lbl_90
    end
  end
  L11_2 = {}
  ::lbl_90::
  L10_2.numbers = L11_2
  L9_2.recover = L10_2
  L10_2 = L0_1.contactsOnSim
  L10_2 = false ~= L10_2
  L9_2.contactsOnSim = L10_2
  L9_2.required = true
  L9_2.max = 1
  L9_2.allowRemove = false
  L9_2.canAdd = false
  if L3_2 then
    L10_2 = L3_2.number
    if L10_2 then
      goto lbl_108
    end
  end
  L10_2 = nil
  ::lbl_108::
  L9_2.active = L10_2
  L10_2 = nil == L3_2
  L9_2.nosim = L10_2
  if L3_2 then
    L10_2 = {}
    L11_2 = {}
    L12_2 = L3_2.number
    L11_2.number = L12_2
    L11_2.slot = 1
    L12_2 = L3_2.label
    if not L12_2 then
      L12_2 = "Principal"
    end
    L11_2.label = L12_2
    L12_2 = L3_2.iccid
    L11_2.iccid = L12_2
    L11_2.source = "sim"
    L11_2.color = "#1F5EFF"
    L11_2.active = true
    L11_2.unread = 0
    L12_2 = L3_2.updated
    L11_2.created = L12_2
    L10_2[1] = L11_2
    if L10_2 then
      goto lbl_141
    end
  end
  L10_2 = {}
  ::lbl_141::
  L9_2.lines = L10_2
  L10_2 = {}
  L11_2 = nil ~= L2_2
  L10_2.device = L11_2
  if L2_2 then
    L11_2 = L2_2.item
    if L11_2 then
      goto lbl_155
    end
  end
  L11_2 = nil
  ::lbl_155::
  L10_2.item = L11_2
  if L2_2 then
    L11_2 = L54_1
    L12_2 = L2_2.item
    L11_2 = L11_2(L12_2)
    if L11_2 then
      goto lbl_164
    end
  end
  L11_2 = nil
  ::lbl_164::
  L10_2.label = L11_2
  if L2_2 then
    L11_2 = L2_2.serial
    if L11_2 then
      goto lbl_171
    end
  end
  L11_2 = nil
  ::lbl_171::
  L10_2.serial = L11_2
  L11_2 = nil ~= L5_2
  L10_2.foreign = L11_2
  L11_2 = nil ~= L3_2
  L10_2.inserted = L11_2
  if L3_2 then
    L11_2 = L3_2.number
    if L11_2 then
      goto lbl_188
    end
  end
  L11_2 = nil
  ::lbl_188::
  L10_2.number = L11_2
  if L3_2 then
    L11_2 = L3_2.iccid
    if L11_2 then
      goto lbl_195
    end
  end
  L11_2 = nil
  ::lbl_195::
  L10_2.iccid = L11_2
  L9_2.tray = L10_2
  L9_2.cards = L4_2
  L10_2 = L0_1.esimCards
  if "off" == L10_2 then
    L10_2 = "off"
    if L10_2 then
      goto lbl_205
    end
  end
  L10_2 = "slot"
  ::lbl_205::
  L9_2.esim = L10_2
  L10_2 = L10_1
  L9_2.item = L10_2
  L10_2 = L37_1
  L10_2 = L10_2()
  L9_2.carrier = L10_2
  L10_2 = L6_2.scanSeconds
  if not L10_2 then
    L10_2 = 1.6
  end
  L9_2.scanSeconds = L10_2
  return L9_2
end
L66_1 = L74_1
function L74_1(A0_2, A1_2)
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
function L75_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = A0_2.md
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = L32_1
  L4_2 = L2_2.iccid
  L3_2 = L3_2(L4_2)
  L4_2 = L31_1
  L5_2 = L2_2.number
  L4_2 = L4_2(L5_2)
  if L3_2 then
    L5_2 = L18_1
    L5_2 = L5_2[L3_2]
    if L5_2 then
      L5_2 = nil
      L6_2 = "blocked"
      return L5_2, L6_2
    end
  end
  if L3_2 then
    L5_2 = L11_1
    L5_2 = L5_2[L3_2]
    if L5_2 then
      L5_2 = L11_1
      L5_2 = L5_2[L3_2]
      return L5_2
    end
  end
  if L3_2 and L4_2 then
    L5_2 = L12_1
    L5_2 = L5_2[L4_2]
    if not L5_2 then
      L5_2 = L43_1
      L6_2 = L4_2
      L7_2 = nil
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L5_2 = L44_1
        L6_2 = L4_2
        L7_2 = "adopted"
        L8_2 = nil
        L9_2 = L3_2
        L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
        L7_2 = L5_2
        L8_2 = L6_2
        L9_2 = true
        return L7_2, L8_2, L9_2
      end
    end
  end
  if L3_2 and L4_2 then
    L5_2 = nil
    L6_2 = "taken"
    return L5_2, L6_2
  end
  L5_2 = L44_1
  L6_2 = nil
  L7_2 = "blank"
  L8_2 = A1_2
  L9_2 = L3_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L7_2 = L5_2
  L8_2 = L6_2
  L9_2 = true
  return L7_2, L8_2, L9_2
end
function L76_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = A1_2.md
  L3_2 = L3_2.apex_serial
  if not L3_2 then
    L4_2 = L74_1
    L5_2 = "nodevice"
    return L4_2(L5_2)
  end
  L4_2 = A1_2.count
  if not L4_2 then
    L4_2 = 1
  end
  if 1 ~= L4_2 then
    L4_2 = L74_1
    L5_2 = "nodevice"
    return L4_2(L5_2)
  end
  L4_2 = L13_1
  L4_2 = L4_2[L3_2]
  if L4_2 then
    L4_2 = L74_1
    L5_2 = "slotfull"
    return L4_2(L5_2)
  end
  L4_2 = L8_1.realCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = L75_1
  L6_2 = A2_2
  L7_2 = L4_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L8_2 = L74_1
    L9_2 = L6_2 or L9_2
    if not L6_2 then
      L9_2 = "invalid"
    end
    return L8_2(L9_2)
  end
  L8_2 = L5_2.device
  if L8_2 then
    L8_2 = L1_1
    L9_2 = "SIM card %s (%s) used by %s but the DB says it is in device %s: refused"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L5_2.number
    L12_2 = L5_2.iccid
    L13_2 = tostring
    L14_2 = A0_2
    L13_2 = L13_2(L14_2)
    L14_2 = L5_2.device
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L8_2 = L74_1
    L9_2 = "dupe"
    return L8_2(L9_2)
  end
  L8_2 = L35_1
  L9_2 = "sim:"
  L10_2 = L5_2.iccid
  L9_2 = L9_2 .. L10_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = L74_1
    L9_2 = "busy"
    return L8_2(L9_2)
  end
  L8_2 = nil
  L9_2 = pcall
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = L8_1.ownerOf
    L1_3 = A1_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L0_3 = L4_2
    end
    L1_3 = pcall
    L2_3 = MySQL
    L2_3 = L2_3.update
    L2_3 = L2_3.await
    L3_3 = "UPDATE apex_phone_sims SET device = ?, account = ?, pending = NULL, updated = ? WHERE iccid = ? AND device IS NULL"
    L4_3 = {}
    L5_3 = L3_2
    L6_3 = L0_3
    L7_3 = L28_1
    L7_3 = L7_3()
    L8_3 = L5_2.iccid
    L4_3[1] = L5_3
    L4_3[2] = L6_3
    L4_3[3] = L7_3
    L4_3[4] = L8_3
    L1_3, L2_3 = L1_3(L2_3, L3_3, L4_3)
    if L1_3 then
      L3_3 = tonumber
      L4_3 = L2_3
      L3_3 = L3_3(L4_3)
      if not L3_3 then
        L3_3 = 0
      end
      if 1 == L3_3 then
        goto lbl_42
      end
    end
    L3_3 = L7_2
    if L3_3 then
      L3_3 = L60_1
      L4_3 = L5_2
      L3_3(L4_3)
    end
    L3_3 = L74_1
    L4_3 = "busy"
    L3_3 = L3_3(L4_3)
    L8_2 = L3_3
    do return end
    ::lbl_42::
    L3_3 = L48_1
    L4_3 = A0_2
    L5_3 = A2_2.slot
    L3_3 = L3_3(L4_3, L5_3)
    L4_3 = L3_3
    if L3_3 then
      L4_3 = L32_1
      L5_3 = L3_3.md
      L5_3 = L5_3.iccid
      L4_3 = L4_3(L5_3)
      L5_3 = L5_2.iccid
      L4_3 = L4_3 == L5_3
    end
    if L4_3 then
      L5_3 = L49_1
      L6_3 = A0_2
      L7_3 = A2_2
      L5_3 = L5_3(L6_3, L7_3)
      if L5_3 then
        goto lbl_97
      end
    end
    L5_3 = pcall
    L6_3 = MySQL
    L6_3 = L6_3.update
    L6_3 = L6_3.await
    L7_3 = "UPDATE apex_phone_sims SET device = NULL, account = NULL, updated = ? WHERE iccid = ? AND device = ?"
    L8_3 = {}
    L9_3 = L28_1
    L9_3 = L9_3()
    L10_3 = L5_2.iccid
    L11_3 = L3_2
    L8_3[1] = L9_3
    L8_3[2] = L10_3
    L8_3[3] = L11_3
    L5_3(L6_3, L7_3, L8_3)
    L5_3 = L7_2
    if L5_3 then
      L5_3 = L60_1
      L6_3 = L5_2
      L5_3(L6_3)
    end
    L5_3 = L74_1
    L6_3 = "noitem"
    L5_3 = L5_3(L6_3)
    L8_2 = L5_3
    do return end
    ::lbl_97::
    L5_3 = L40_1
    L6_3 = L5_2
    L7_3 = nil
    L5_3(L6_3, L7_3)
    L5_3 = L42_1
    L6_3 = L5_2
    L7_3 = L3_2
    L8_3 = L0_3
    L5_3(L6_3, L7_3, L8_3)
    L5_3 = L52_1
    L6_3 = A0_2
    L7_3 = A1_2
    L8_3 = L5_2
    L5_3(L6_3, L7_3, L8_3)
    L5_3 = TriggerEvent
    L6_3 = "apex_phone:simInserted"
    L7_3 = A0_2
    L8_3 = L3_2
    L9_3 = L5_2.number
    L10_3 = L5_2.iccid
    L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
    L5_3 = L2_1
    L6_3 = "%s inserted SIM %s into device %s"
    L7_3 = tostring
    L8_3 = A0_2
    L7_3 = L7_3(L8_3)
    L8_3 = L5_2.number
    L9_3 = L3_2
    L5_3(L6_3, L7_3, L8_3, L9_3)
    L5_3 = {}
    L5_3.ok = true
    L6_3 = L5_2.number
    L5_3.number = L6_3
    L6_3 = L5_2.iccid
    L5_3.iccid = L6_3
    L6_3 = L3_2
    L5_3.serial = L6_3
    L8_2 = L5_3
  end
  L9_2, L10_2 = L9_2(L10_2)
  L11_2 = L36_1
  L12_2 = "sim:"
  L13_2 = L5_2.iccid
  L12_2 = L12_2 .. L13_2
  L11_2(L12_2)
  if not L9_2 then
    L11_2 = L1_1
    L12_2 = "insert: "
    L13_2 = tostring
    L14_2 = L10_2
    L13_2 = L13_2(L14_2)
    L12_2 = L12_2 .. L13_2
    L11_2(L12_2)
    L11_2 = L74_1
    L12_2 = "internal"
    return L11_2(L12_2)
  end
  return L8_2
end
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = A1_2 or nil
  if A1_2 then
    L2_2 = A1_2.md
    L2_2 = L2_2.apex_serial
  end
  if not L2_2 then
    L3_2 = L74_1
    L4_2 = "nodevice"
    return L3_2(L4_2)
  end
  L3_2 = L13_1
  L3_2 = L3_2[L2_2]
  if not L3_2 then
    L4_2 = A1_2.md
    L4_2 = L4_2.apex_sim
    if not L4_2 then
      L4_2 = A1_2.md
      L4_2 = L4_2.apex_simnum
      if not L4_2 then
        goto lbl_28
      end
    end
    L4_2 = L52_1
    L5_2 = A0_2
    L6_2 = A1_2
    L7_2 = nil
    L4_2(L5_2, L6_2, L7_2)
    ::lbl_28::
    L4_2 = L74_1
    L5_2 = "empty"
    return L4_2(L5_2)
  end
  L4_2 = L45_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = L50_1
  L6_2 = A0_2
  L7_2 = L4_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = L74_1
    L6_2 = "full"
    return L5_2(L6_2)
  end
  L5_2 = L35_1
  L6_2 = "sim:"
  L7_2 = L3_2.iccid
  L6_2 = L6_2 .. L7_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L74_1
    L6_2 = "busy"
    return L5_2(L6_2)
  end
  L5_2 = nil
  L6_2 = pcall
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L0_3 = pcall
    L1_3 = MySQL
    L1_3 = L1_3.update
    L1_3 = L1_3.await
    L2_3 = "UPDATE apex_phone_sims SET device = NULL, account = NULL, updated = ? WHERE iccid = ? AND device = ?"
    L3_3 = {}
    L4_3 = L28_1
    L4_3 = L4_3()
    L5_3 = L3_2.iccid
    L6_3 = L2_2
    L3_3[1] = L4_3
    L3_3[2] = L5_3
    L3_3[3] = L6_3
    L0_3, L1_3 = L0_3(L1_3, L2_3, L3_3)
    if L0_3 then
      L2_3 = tonumber
      L3_3 = L1_3
      L2_3 = L2_3(L3_3)
      if not L2_3 then
        L2_3 = 0
      end
      if 1 == L2_3 then
        goto lbl_29
      end
    end
    L2_3 = L74_1
    L3_3 = "busy"
    L2_3 = L2_3(L3_3)
    L5_2 = L2_3
    do return end
    ::lbl_29::
    L2_3 = L51_1
    L3_3 = A0_2
    L4_3 = L4_2
    L2_3 = L2_3(L3_3, L4_3)
    if not L2_3 then
      L2_3 = pcall
      L3_3 = MySQL
      L3_3 = L3_3.update
      L3_3 = L3_3.await
      L4_3 = "UPDATE apex_phone_sims SET device = ?, account = ?, updated = ? WHERE iccid = ? AND device IS NULL"
      L5_3 = {}
      L6_3 = L2_2
      L7_3 = L3_2.account
      L8_3 = L28_1
      L8_3 = L8_3()
      L9_3 = L3_2.iccid
      L5_3[1] = L6_3
      L5_3[2] = L7_3
      L5_3[3] = L8_3
      L5_3[4] = L9_3
      L2_3(L3_3, L4_3, L5_3)
      L2_3 = L74_1
      L3_3 = "full"
      L2_3 = L2_3(L3_3)
      L5_2 = L2_3
      return
    end
    L2_3 = L42_1
    L3_3 = L3_2
    L4_3 = nil
    L5_3 = nil
    L2_3(L3_3, L4_3, L5_3)
    L2_3 = L52_1
    L3_3 = A0_2
    L4_3 = A1_2
    L5_3 = nil
    L2_3(L3_3, L4_3, L5_3)
    L2_3 = TriggerEvent
    L3_3 = "apex_phone:simEjected"
    L4_3 = A0_2
    L5_3 = L2_2
    L6_3 = L3_2.number
    L7_3 = L3_2.iccid
    L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
    L2_3 = L2_1
    L3_3 = "%s removed SIM %s from device %s"
    L4_3 = tostring
    L5_3 = A0_2
    L4_3 = L4_3(L5_3)
    L5_3 = L3_2.number
    L6_3 = L2_2
    L2_3(L3_3, L4_3, L5_3, L6_3)
    L2_3 = {}
    L2_3.ok = true
    L3_3 = L3_2.number
    L2_3.number = L3_3
    L3_3 = L3_2.iccid
    L2_3.iccid = L3_3
    L3_3 = L2_2
    L2_3.serial = L3_3
    L5_2 = L2_3
  end
  L6_2, L7_2 = L6_2(L7_2)
  L8_2 = L36_1
  L9_2 = "sim:"
  L10_2 = L3_2.iccid
  L9_2 = L9_2 .. L10_2
  L8_2(L9_2)
  if not L6_2 then
    L8_2 = L1_1
    L9_2 = "remove: "
    L10_2 = tostring
    L11_2 = L7_2
    L10_2 = L10_2(L11_2)
    L9_2 = L9_2 .. L10_2
    L8_2(L9_2)
    L8_2 = L74_1
    L9_2 = "internal"
    return L8_2(L9_2)
  end
  return L5_2
end
function L78_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L73_1
  L3_2 = A0_2
  L4_2 = "tray"
  L2_2(L3_2, L4_2)
  L2_2 = A1_2 or L2_2
  if A1_2 then
    L2_2 = L21_1
    L2_2 = L2_2[A1_2]
  end
  if L2_2 and L2_2 ~= A0_2 then
    L3_2 = L73_1
    L4_2 = L2_2
    L5_2 = "tray"
    L3_2(L4_2, L5_2)
  end
end
function L79_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L35_1
  L3_2 = "src:"
  L4_2 = A0_2
  L3_2 = L3_2 .. L4_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = L74_1
    L3_2 = "busy"
    return L2_2(L3_2)
  end
  L2_2 = pcall
  L3_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L36_1
  L5_2 = "src:"
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  L4_2(L5_2)
  if not L2_2 then
    L4_2 = L1_1
    L5_2 = tostring
    L6_2 = L3_2
    L5_2, L6_2 = L5_2(L6_2)
    L4_2(L5_2, L6_2)
    L4_2 = L74_1
    L5_2 = "internal"
    return L4_2(L5_2)
  end
  return L3_2
end
function L80_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L73_1
  L2_2 = A0_2
  L3_2 = "check"
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L53_1
  L3_2 = A0_2
  L4_2 = L1_2.serial
  return L2_2(L3_2, L4_2)
end
L81_1 = {}
L81_1.inserted = "SIM inserido: %s"
L81_1.ejected = "SIM retirado: %s"
L81_1.swapped = "SIM trocado: %s"
L81_1.nophone = "Precisas de um telem\195\179vel para p\195\180r o SIM."
L81_1.slotfull = "Este telem\195\179vel j\195\161 tem um SIM. Tira-o primeiro."
L81_1.full = "N\195\163o tens espa\195\167o para o cart\195\163o SIM."
L81_1.dupe = "Este cart\195\163o SIM n\195\163o funciona."
L81_1.taken = "O n\195\186mero deste cart\195\163o j\195\161 est\195\161 a ser usado."
L81_1.empty = "Este telem\195\179vel n\195\163o tem SIM."
L81_1.busy = "Espera um instante e tenta outra vez."
L81_1.noitem = "O cart\195\163o SIM j\195\161 n\195\163o est\195\161 no invent\195\161rio."
L81_1.locked = "Desbloqueia o telem\195\179vel primeiro."
L81_1.internal = "Erro no servidor."
L81_1.noplayer = "Sess\195\163o do jogador n\195\163o encontrada"
L81_1.physical = "Isto n\195\163o est\195\161 dispon\195\173vel com cart\195\181es SIM f\195\173sicos."
L81_1.blocked = "Este cart\195\163o SIM foi cancelado pela operadora."
L81_1.notmine = "Esse n\195\186mero n\195\163o \195\169 teu."
L81_1.funds = "N\195\163o tens saldo para recuperar o n\195\186mero."
L81_1.disabled = "A recupera\195\167\195\163o de n\195\186meros est\195\161 desligada."
L81_1.recovered = "N\195\186mero recuperado: %s"
L81_1.invalid = "N\195\186mero inv\195\161lido."
L81_1.db = "Erro na base de dados."
L81_1.notlost = "Esse n\195\186mero j\195\161 est\195\161 com o jogador."
function L82_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L81_1
  L4_2 = L4_2[A1_2]
  if not L4_2 then
    L4_2 = L81_1.busy
  end
  if A2_2 then
    L6_2 = L4_2
    L5_2 = L4_2.format
    L7_2 = A2_2
    L5_2 = L5_2(L6_2, L7_2)
    L4_2 = L5_2
  end
  L5_2 = FW
  L5_2 = L5_2.Notify
  L6_2 = A0_2
  L7_2 = L4_2
  L8_2 = A3_2 or L8_2
  if not A3_2 then
    L8_2 = "error"
  end
  L5_2(L6_2, L7_2, L8_2)
end
function L83_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = type
  L1_2 = L0_1.recover
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L0_1.recover
    if L0_2 then
      goto lbl_11
    end
  end
  L0_2 = {}
  ::lbl_11::
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = tonumber
  L3_2 = L0_2.price
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 100
  end
  L1_2 = L1_2(L2_2)
  L2_2 = {}
  L3_2 = L0_2.enabled
  L3_2 = false ~= L3_2
  L2_2.enabled = L3_2
  L3_2 = L0_2.free
  if true == L3_2 or L1_2 < 0 then
    L3_2 = 0
    if L3_2 then
      goto lbl_37
    end
  end
  L3_2 = L1_2
  ::lbl_37::
  L2_2.price = L3_2
  L3_2 = L0_2.blockOld
  L3_2 = false ~= L3_2
  L2_2.blockOld = L3_2
  return L2_2
end
L67_1 = L83_1
function L83_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = {}
  L3_2 = L67_1
  L3_2 = L3_2()
  L4_2 = L3_2.enabled
  if L4_2 and A1_2 then
    L4_2 = L17_1
    L4_2 = L4_2[A1_2]
    if L4_2 then
      goto lbl_15
    end
  end
  do return L2_2 end
  ::lbl_15::
  L4_2 = {}
  L5_2 = L20_1
  L5_2 = L5_2[A0_2]
  L6_2 = L5_2
  if L5_2 then
    L7_2 = L5_2.serial
    L6_2 = L13_1
    L6_2 = L6_2[L7_2]
  end
  if L6_2 then
    L7_2 = L6_2.iccid
    L4_2[L7_2] = true
  end
  L7_2 = ipairs
  L8_2 = L47_1
  L9_2 = A0_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L32_1
    L14_2 = L12_2.md
    L14_2 = L14_2.iccid
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L4_2[L13_2] = true
    end
  end
  L7_2 = pairs
  L8_2 = L17_1
  L8_2 = L8_2[A1_2]
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.iccid
    L13_2 = L4_2[L13_2]
    if not L13_2 then
      L13_2 = L12_2.pending
      if L13_2 ~= A1_2 then
        L13_2 = #L2_2
        L13_2 = L13_2 + 1
        L14_2 = {}
        L15_2 = L12_2.number
        L14_2.number = L15_2
        L15_2 = L12_2.label
        L14_2.label = L15_2
        L15_2 = L12_2.device
        if L15_2 then
          L15_2 = "device"
          if L15_2 then
            goto lbl_72
          end
        end
        L15_2 = "card"
        ::lbl_72::
        L14_2.where = L15_2
        L2_2[L13_2] = L14_2
      end
    end
  end
  L7_2 = table
  L7_2 = L7_2.sort
  L8_2 = L2_2
  function L9_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.number
    L3_3 = A1_3.number
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L7_2(L8_2, L9_2)
  return L2_2
end
L68_1 = L83_1
function L83_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = L67_1
  L4_2 = L4_2()
  L5_2 = "sim:"
  L6_2 = A2_2.iccid
  L5_2 = L5_2 .. L6_2
  L6_2 = L35_1
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = L74_1
    L7_2 = "busy"
    return L6_2(L7_2)
  end
  L6_2 = nil
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3
    L0_3 = FW
    L0_3 = L0_3.GetPlayer
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L1_3 = L74_1
      L2_3 = "noplayer"
      L1_3 = L1_3(L2_3)
      L6_2 = L1_3
      return
    end
    L1_3 = A3_2
    if L1_3 > 0 then
      L1_3 = tonumber
      L2_3 = L0_3.GetMoney
      L3_3 = "bank"
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3 = L2_3(L3_3)
      L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
      if not L1_3 then
        L1_3 = 0
      end
      L2_3 = A3_2
      if L1_3 < L2_3 then
        L1_3 = L74_1
        L2_3 = "funds"
        L3_3 = {}
        L4_3 = A3_2
        L3_3.price = L4_3
        L1_3 = L1_3(L2_3, L3_3)
        L6_2 = L1_3
        return
      end
      L1_3 = L0_3.RemoveMoney
      L2_3 = "bank"
      L3_3 = A3_2
      L4_3 = "Unique_Phone sim recovery"
      L1_3 = L1_3(L2_3, L3_3, L4_3)
      if not L1_3 then
        L1_3 = L74_1
        L2_3 = "funds"
        L3_3 = {}
        L4_3 = A3_2
        L3_3.price = L4_3
        L1_3 = L1_3(L2_3, L3_3)
        L6_2 = L1_3
        return
      end
    end
    L1_3 = A2_2.iccid
    L2_3 = A2_2.device
    L3_3 = L33_1
    L3_3 = L3_3()
    L4_3 = pcall
    L5_3 = MySQL
    L5_3 = L5_3.update
    L5_3 = L5_3.await
    L6_3 = "UPDATE apex_phone_sims SET iccid = ?, device = NULL, account = NULL, pending = NULL, updated = ? WHERE iccid = ?"
    L7_3 = {}
    L8_3 = L3_3
    L9_3 = L28_1
    L9_3 = L9_3()
    L10_3 = L1_3
    L7_3[1] = L8_3
    L7_3[2] = L9_3
    L7_3[3] = L10_3
    L4_3, L5_3 = L4_3(L5_3, L6_3, L7_3)
    if L4_3 then
      L6_3 = tonumber
      L7_3 = L5_3
      L6_3 = L6_3(L7_3)
      if not L6_3 then
        L6_3 = 0
      end
      if 1 == L6_3 then
        goto lbl_92
      end
    end
    L6_3 = A3_2
    if L6_3 > 0 then
      L6_3 = pcall
      L7_3 = L0_3.AddMoney
      L8_3 = "bank"
      L9_3 = A3_2
      L10_3 = "Unique_Phone sim recovery refund"
      L6_3(L7_3, L8_3, L9_3, L10_3)
    end
    L6_3 = L74_1
    L7_3 = "db"
    L6_3 = L6_3(L7_3)
    L6_2 = L6_3
    do return end
    ::lbl_92::
    L6_3 = L4_2.blockOld
    if L6_3 then
      L6_3 = pcall
      L7_3 = MySQL
      L7_3 = L7_3.insert
      L7_3 = L7_3.await
      L8_3 = "INSERT IGNORE INTO apex_phone_sims_blocked (iccid, number, replaced_by, cid, blocked) VALUES (?, ?, ?, ?, ?)"
      L9_3 = {}
      L10_3 = L1_3
      L11_3 = A2_2.number
      L12_3 = L3_3
      L13_3 = A1_2
      L14_3 = L28_1
      L14_3, L15_3, L16_3 = L14_3()
      L9_3[1] = L10_3
      L9_3[2] = L11_3
      L9_3[3] = L12_3
      L9_3[4] = L13_3
      L9_3[5] = L14_3
      L9_3[6] = L15_3
      L9_3[7] = L16_3
      L6_3(L7_3, L8_3, L9_3)
      L6_3 = L18_1
      L6_3[L1_3] = true
    end
    L6_3 = L38_1
    L7_3 = A2_2
    L6_3(L7_3)
    L6_3 = L3_3
    L7_3 = nil
    L8_3 = nil
    L9_3 = nil
    L10_3 = L28_1
    L10_3 = L10_3()
    A2_2.updated = L10_3
    A2_2.pending = L9_3
    A2_2.account = L8_3
    A2_2.device = L7_3
    A2_2.iccid = L6_3
    L6_3 = L39_1
    L7_3 = A2_2
    L6_3(L7_3)
    L6_3 = L2_3
    if L2_3 then
      L6_3 = L21_1
      L6_3 = L6_3[L2_3]
    end
    if L6_3 then
      L7_3 = A0_2
      if L6_3 ~= L7_3 then
        L7_3 = pcall
        L8_3 = L73_1
        L9_3 = L6_3
        L10_3 = "recover"
        L7_3(L8_3, L9_3, L10_3)
      end
    end
    L7_3 = L57_1
    L8_3 = A0_2
    L9_3 = A1_2
    L10_3 = A2_2
    L7_3 = L7_3(L8_3, L9_3, L10_3)
    L8_3 = TriggerEvent
    L9_3 = "apex_phone:simRecovered"
    L10_3 = A0_2
    L11_3 = A2_2.number
    L12_3 = L1_3
    L13_3 = L3_3
    L8_3(L9_3, L10_3, L11_3, L12_3, L13_3)
    L8_3 = L2_1
    L9_3 = "%s recovered %s: %s -> %s (%s, charged %s)"
    L10_3 = tostring
    L11_3 = A0_2
    L10_3 = L10_3(L11_3)
    L11_3 = A2_2.number
    L12_3 = L1_3
    L13_3 = L3_3
    if L7_3 then
      L14_3 = "card delivered"
      if L14_3 then
        goto lbl_167
      end
    end
    L14_3 = "card pending"
    ::lbl_167::
    L15_3 = tostring
    L16_3 = A3_2
    L15_3, L16_3 = L15_3(L16_3)
    L8_3(L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
    L8_3 = {}
    L8_3.ok = true
    L9_3 = A2_2.number
    L8_3.number = L9_3
    L8_3.iccid = L3_3
    L8_3.old = L1_3
    L9_3 = A3_2
    L8_3.charged = L9_3
    L8_3.delivered = L7_3
    L6_2 = L8_3
  end
  L7_2, L8_2 = L7_2(L8_2)
  L9_2 = L36_1
  L10_2 = L5_2
  L9_2(L10_2)
  if not L7_2 then
    L9_2 = L1_1
    L10_2 = "recover: "
    L11_2 = tostring
    L12_2 = L8_2
    L11_2 = L11_2(L12_2)
    L10_2 = L10_2 .. L11_2
    L9_2(L10_2)
    L9_2 = L74_1
    L10_2 = "internal"
    return L9_2(L10_2)
  end
  return L6_2
end
function L84_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L79_1
  L3_2 = A0_2
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L0_3 = L67_1
    L0_3 = L0_3()
    L1_3 = L0_3.enabled
    if not L1_3 then
      L1_3 = L74_1
      L2_3 = "disabled"
      return L1_3(L2_3)
    end
    L1_3 = L8_1.realCid
    L2_3 = A0_2
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L2_3 = L74_1
      L3_3 = "noplayer"
      return L2_3(L3_3)
    end
    L2_3 = L31_1
    L3_3 = A1_2.number
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L3_3 = L74_1
      L4_3 = "invalid"
      return L3_3(L4_3)
    end
    L3_3 = L12_1
    L3_3 = L3_3[L2_3]
    if L3_3 then
      L4_3 = L3_3.home
      if L4_3 == L1_3 then
        goto lbl_39
      end
    end
    L4_3 = L74_1
    L5_3 = "notmine"
    do return L4_3(L5_3) end
    ::lbl_39::
    L4_3 = false
    L5_3 = ipairs
    L6_3 = L68_1
    L7_3 = A0_2
    L8_3 = L1_3
    L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L6_3(L7_3, L8_3)
    L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
    for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
      L11_3 = L10_3.number
      if L11_3 == L2_3 then
        L4_3 = true
        break
      end
    end
    if not L4_3 then
      L5_3 = L74_1
      L6_3 = "notlost"
      return L5_3(L6_3)
    end
    L5_3 = L83_1
    L6_3 = A0_2
    L7_3 = L1_3
    L8_3 = L3_3
    L9_3 = L0_3.price
    L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3)
    L6_3 = L5_3.ok
    if not L6_3 then
      return L5_3
    end
    L6_3 = A1_2.insert
    if false ~= L6_3 then
      L6_3 = L5_3.delivered
      if L6_3 then
        L6_3 = L80_1
        L7_3 = A0_2
        L6_3 = L6_3(L7_3)
        if L6_3 then
          L7_3 = L6_3.md
          L8_3 = L7_3.apex_serial
          L7_3 = L13_1
          L7_3 = L7_3[L8_3]
          if not L7_3 then
            L7_3 = nil
            L8_3 = ipairs
            L9_3 = L47_1
            L10_3 = A0_2
            L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L9_3(L10_3)
            L8_3, L9_3, L10_3, L11_3 = L8_3(L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
            for L12_3, L13_3 in L8_3, L9_3, L10_3, L11_3 do
              L14_3 = L32_1
              L15_3 = L13_3.md
              L15_3 = L15_3.iccid
              L14_3 = L14_3(L15_3)
              L15_3 = L5_3.iccid
              if L14_3 == L15_3 then
                L7_3 = L13_3
                break
              end
            end
            if L7_3 then
              L8_3 = L76_1
              L9_3 = A0_2
              L10_3 = L6_3
              L11_3 = L7_3
              L8_3 = L8_3(L9_3, L10_3, L11_3)
              L9_3 = L8_3.ok
              if L9_3 then
                L5_3.inserted = true
                L9_3 = L78_1
                L10_3 = A0_2
                L11_3 = L6_3.md
                L11_3 = L11_3.apex_serial
                L9_3(L10_3, L11_3)
              end
            end
          end
        end
      end
    end
    L6_3 = L73_1
    L7_3 = A0_2
    L8_3 = "recover"
    L6_3(L7_3, L8_3)
    return L5_3
  end
  return L2_2(L3_2, L4_2)
end
function L85_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = "sim:"
  L2_2 = A0_2.number
  L1_2 = L1_2 .. L2_2
  L3_2 = A0_2.number
  L2_2 = L19_1
  L2_2 = L2_2[L3_2]
  if L2_2 then
    return L1_2
  end
  L2_2 = GetResourceKvpString
  L3_2 = L7_1
  L4_2 = A0_2.number
  L3_2 = L3_2 .. L4_2
  L2_2 = L2_2(L3_2)
  if "1" == L2_2 then
    L3_2 = A0_2.number
    L2_2 = L19_1
    L2_2[L3_2] = true
    return L1_2
  end
  L2_2 = A0_2.account
  if not L2_2 then
    L2_2 = A0_2.home
  end
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = tonumber
    L1_3 = MySQL
    L1_3 = L1_3.scalar
    L1_3 = L1_3.await
    L2_3 = "SELECT COUNT(*) FROM apex_phone_contacts WHERE owner = ?"
    L3_3 = {}
    L4_3 = L1_2
    L3_3[1] = L4_3
    L1_3, L2_3, L3_3, L4_3, L5_3 = L1_3(L2_3, L3_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
    if not L0_3 then
      L0_3 = 0
    end
    if 0 == L0_3 then
      L1_3 = L2_2
      if L1_3 then
        L1_3 = MySQL
        L1_3 = L1_3.query
        L1_3 = L1_3.await
        L2_3 = "INSERT INTO apex_phone_contacts (owner, name, number, avatar, notes, avatar_photo, favorite) SELECT ?, name, number, avatar, notes, avatar_photo, favorite FROM apex_phone_contacts WHERE owner = ?"
        L3_3 = {}
        L4_3 = L1_2
        L5_3 = L2_2
        L3_3[1] = L4_3
        L3_3[2] = L5_3
        L1_3(L2_3, L3_3)
        L1_3 = L2_1
        L2_3 = "contacts of %s copied to the SIM %s"
        L3_3 = L2_2
        L4_3 = A0_2.number
        L1_3(L2_3, L3_3, L4_3)
      end
    end
  end
  L3_2(L4_2)
  L4_2 = A0_2.number
  L3_2 = L19_1
  L3_2[L4_2] = true
  L3_2 = SetResourceKvp
  L4_2 = L7_1
  L5_2 = A0_2.number
  L4_2 = L4_2 .. L5_2
  L5_2 = "1"
  L3_2(L4_2, L5_2)
  return L1_2
end
function L86_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L79_1
  L3_2 = A0_2
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3
    L0_3 = nil
    L1_3 = A1_2
    if nil ~= L1_3 then
      L1_3 = L48_1
      L2_3 = A0_2
      L3_3 = A1_2
      L1_3 = L1_3(L2_3, L3_3)
      L0_3 = L1_3
    else
      L1_3 = L47_1
      L2_3 = A0_2
      L1_3 = L1_3(L2_3)
      L0_3 = L1_3[1]
    end
    if not L0_3 then
      L1_3 = L74_1
      L2_3 = "noitem"
      return L1_3(L2_3)
    end
    L1_3 = L8_1.realCid
    L2_3 = A0_2
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L2_3 = L74_1
      L3_3 = "noplayer"
      return L2_3(L3_3)
    end
    L2_3 = L80_1
    L3_3 = A0_2
    L2_3 = L2_3(L3_3)
    L3_3 = nil
    if L2_3 then
      L4_3 = L2_3.md
      L5_3 = L4_3.apex_serial
      L4_3 = L13_1
      L4_3 = L4_3[L5_3]
      if L4_3 then
        L4_3 = L77_1
        L5_3 = A0_2
        L6_3 = L2_3
        L4_3 = L4_3(L5_3, L6_3)
        L5_3 = L4_3.ok
        if not L5_3 then
          return L4_3
        end
        L3_3 = L4_3.number
        L5_3 = L53_1
        L6_3 = A0_2
        L7_3 = L2_3.md
        L7_3 = L7_3.apex_serial
        L5_3 = L5_3(L6_3, L7_3)
        L2_3 = L5_3
        L5_3 = L48_1
        L6_3 = A0_2
        L7_3 = L0_3.slot
        L5_3 = L5_3(L6_3, L7_3)
        L0_3 = L5_3 or L0_3
        if not L5_3 then
        end
      end
    end
    if not L2_3 then
      L4_3 = ipairs
      L5_3 = L8_1.slots
      L6_3 = A0_2
      L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3 = L5_3(L6_3)
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3)
      for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
        L10_3 = L9_3.count
        if not L10_3 then
          L10_3 = 1
        end
        if 1 == L10_3 then
          L10_3 = L9_3.md
          L10_3 = L10_3.apex_serial
          if L10_3 then
            L10_3 = L9_3.md
            L11_3 = L10_3.apex_serial
            L10_3 = L13_1
            L10_3 = L10_3[L11_3]
            if L10_3 then
              goto lbl_108
            end
          end
          L10_3 = L9_3.md
          L10_3 = L10_3.apex_serial
          if not L10_3 then
            L10_3 = L61_1
            L11_3 = L9_3
            L12_3 = L1_3
            L10_3 = L10_3(L11_3, L12_3)
            if L10_3 then
              L10_3 = L8_1.stamp
              L11_3 = A0_2
              L12_3 = L9_3
              L13_3 = L1_3
              L10_3(L11_3, L12_3, L13_3)
            end
          end
          L10_3 = L9_3.md
          L10_3 = L10_3.apex_serial
          if L10_3 then
            L2_3 = L9_3
            break
          end
        end
        ::lbl_108::
      end
    end
    if not L2_3 then
      L4_3 = L74_1
      L5_3 = "nophone"
      return L4_3(L5_3)
    end
    L4_3 = L76_1
    L5_3 = A0_2
    L6_3 = L2_3
    L7_3 = L0_3
    L4_3 = L4_3(L5_3, L6_3, L7_3)
    L5_3 = L4_3.ok
    if L5_3 then
      L4_3.swapped = L3_3
    end
    L5_3 = L78_1
    L6_3 = A0_2
    L7_3 = L2_3.md
    L7_3 = L7_3.apex_serial
    L5_3(L6_3, L7_3)
    return L4_3
  end
  return L2_2(L3_2, L4_2)
end
L87_1 = {}
function L88_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = SimConfig
  if L3_2 then
    L3_2 = SimConfig
    L3_2 = L3_2()
    L3_2 = L3_2.item
    if L3_2 then
      goto lbl_10
    end
  end
  L3_2 = "esim"
  ::lbl_10::
  L4_2 = L9_1
  if "ox" == L4_2 then
    L4_2 = math
    L4_2 = L4_2.tointeger
    L5_2 = tonumber
    L6_2 = A1_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L5_2(L6_2)
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    A1_2 = L4_2
    if A1_2 then
      L4_2 = pcall
      function L5_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = exports
        L0_3 = L0_3.ox_inventory
        L1_3 = L0_3
        L0_3 = L0_3.GetSlot
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
          L6_2 = L5_2.name
          if L6_2 == L3_2 then
            L6_2 = tonumber
            L7_2 = L5_2.count
            L6_2 = L6_2(L7_2)
            if not L6_2 then
              L6_2 = 0
            end
            if L6_2 > 0 then
              L6_2 = {}
              L6_2.slot = A1_2
              L7_2 = type
              L8_2 = L5_2.metadata
              L7_2 = L7_2(L8_2)
              if "table" == L7_2 then
                L7_2 = L5_2.metadata
                if L7_2 then
                  goto lbl_56
                end
              end
              L7_2 = {}
              ::lbl_56::
              L6_2.md = L7_2
              L6_2.item = L3_2
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
      L3_3 = L3_2
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
                  goto lbl_97
                end
              end
              L13_2 = {}
              ::lbl_97::
              if A2_2 then
                L14_2 = L13_2.iccid
                if nil ~= L14_2 then
                  L14_2 = tostring
                  L15_2 = L13_2.iccid
                  L14_2 = L14_2(L15_2)
                  if L14_2 == A2_2 then
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
                  goto lbl_126
                end
              end
              L6_2 = L12_2
            end
          end
          ::lbl_126::
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
              goto lbl_150
            end
          end
          L8_2 = {}
          ::lbl_150::
          L7_2.md = L8_2
          L7_2.item = L3_2
          return L7_2
        end
      end
    end
    L6_2 = nil
    return L6_2
  end
  L4_2 = L8_1.qbPlayer
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = pairs
  if L4_2 then
    L6_2 = L4_2.PlayerData
    L6_2 = L6_2.items
    if L6_2 then
      goto lbl_167
    end
  end
  L6_2 = {}
  ::lbl_167::
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L10_2.name
      if L11_2 == L3_2 then
        L11_2 = tonumber
        L12_2 = L10_2.amount
        if not L12_2 then
          L12_2 = L10_2.count
        end
        L11_2 = L11_2(L12_2)
        if not L11_2 then
          L11_2 = 0
        end
        if L11_2 > 0 then
          L11_2 = {}
          L12_2 = math
          L12_2 = L12_2.tointeger
          L13_2 = tonumber
          L14_2 = L10_2.slot
          if not L14_2 then
            L14_2 = L9_2
          end
          L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
          L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
          L11_2.slot = L12_2
          L12_2 = type
          L13_2 = L10_2.info
          L12_2 = L12_2(L13_2)
          if "table" == L12_2 then
            L12_2 = L10_2.info
            if L12_2 then
              goto lbl_210
            end
          end
          L12_2 = {}
          ::lbl_210::
          L11_2.md = L12_2
          L11_2.item = L3_2
          return L11_2
        end
      end
    end
  end
  L5_2 = nil
  return L5_2
end
function L89_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L9_1
  if "ox" == L2_2 then
    L2_2 = pcall
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.RemoveItem
      L2_3 = A0_2
      L3_3 = A1_2.item
      L4_3 = 1
      L5_3 = nil
      L6_3 = A1_2.slot
      return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
    end
    L2_2, L3_2 = L2_2(L3_2)
    if L2_2 and L3_2 then
      L4_2 = true
      if L4_2 then
        goto lbl_15
      end
    end
    L4_2 = false
    ::lbl_15::
    return L4_2
  end
  L2_2 = FW
  L2_2 = L2_2.RemoveItem
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.RemoveItem
    L3_2 = A0_2
    L4_2 = A1_2.item
    L5_2 = 1
    L2_2 = L2_2(L3_2, L4_2, L5_2)
  end
  L2_2 = true == L2_2 or L2_2
  return L2_2
end
function L90_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L0_1.esimCards
  if "off" == L2_2 then
    L2_2 = L74_1
    L3_2 = "physical"
    return L2_2(L3_2)
  end
  L2_2 = L80_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L74_1
    L4_2 = "nophone"
    return L3_2(L4_2)
  end
  L3_2 = L2_2.md
  L4_2 = L3_2.apex_serial
  L3_2 = L13_1
  L3_2 = L3_2[L4_2]
  if L3_2 then
    L3_2 = L74_1
    L4_2 = "slotfull"
    return L3_2(L4_2)
  end
  L3_2 = L88_1
  L4_2 = A0_2
  L5_2 = A1_2.slot
  L6_2 = L32_1
  L7_2 = A1_2.iccid
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  if not L3_2 then
    L4_2 = L74_1
    L5_2 = "noitem"
    return L4_2(L5_2)
  end
  L4_2 = L31_1
  L5_2 = L3_2.md
  L5_2 = L5_2.number
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  if L4_2 then
    L6_2 = L43_1
    L7_2 = L4_2
    L8_2 = nil
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = L74_1
      L7_2 = "taken"
      L8_2 = {}
      L8_2.number = L4_2
      return L6_2(L7_2, L8_2)
    end
  else
    L6_2 = L87_1
    L6_2 = L6_2[A0_2]
    if L6_2 then
      L7_2 = L28_1
      L7_2 = L7_2()
      L8_2 = L6_2.t
      L7_2 = L7_2 - L8_2
      L8_2 = 300000
      if L7_2 < L8_2 then
        L8_2 = L6_2.number
        L7_2 = L12_1
        L7_2 = L7_2[L8_2]
        if not L7_2 then
          L5_2 = L6_2.number
      end
    end
    else
      L7_2 = GenPhoneNumber
      if L7_2 then
        L7_2 = GenPhoneNumber
        L7_2 = L7_2()
        if L7_2 then
          goto lbl_95
          L5_2 = L7_2 or L5_2
        end
      end
      L7_2 = tostring
      L8_2 = math
      L8_2 = L8_2.random
      L9_2 = 1000000
      L10_2 = 9999999
      L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2)
      L7_2 = L7_2(L8_2, L9_2, L10_2)
      L5_2 = L7_2
    end
  end
  ::lbl_95::
  L6_2 = L32_1
  L7_2 = L3_2.md
  L7_2 = L7_2.iccid
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = L87_1
    L6_2 = L6_2[A0_2]
    if L6_2 then
      L6_2 = L87_1
      L6_2 = L6_2[A0_2]
      L6_2 = L6_2.iccid
      if L6_2 then
        goto lbl_112
      end
    end
    L6_2 = L33_1
    L6_2 = L6_2()
  end
  ::lbl_112::
  if not L4_2 then
    L7_2 = L87_1
    L8_2 = {}
    L8_2.number = L5_2
    L8_2.iccid = L6_2
    L9_2 = L28_1
    L9_2 = L9_2()
    L8_2.t = L9_2
    L7_2[A0_2] = L8_2
  end
  L7_2 = {}
  L7_2.ok = true
  L7_2.number = L5_2
  L8_2 = nil ~= L4_2
  L7_2.preset = L8_2
  L7_2.iccid = L6_2
  L8_2 = L37_1
  L8_2 = L8_2()
  L7_2.carrier = L8_2
  L7_2.slot = 1
  L7_2.label = "Principal"
  L7_2.color = "#1F5EFF"
  L8_2 = L3_2.slot
  L7_2.cardSlot = L8_2
  L7_2.count = 0
  L7_2.max = 1
  L7_2.required = true
  L7_2.nosim = true
  L7_2.physical = true
  return L7_2
end
function L91_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L0_1.esimCards
  if "off" == L2_2 then
    L2_2 = L74_1
    L3_2 = "physical"
    return L2_2(L3_2)
  end
  L2_2 = L80_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L74_1
    L4_2 = "nophone"
    return L3_2(L4_2)
  end
  L3_2 = L2_2.md
  L3_2 = L3_2.apex_serial
  L4_2 = L13_1
  L4_2 = L4_2[L3_2]
  if L4_2 then
    L4_2 = L74_1
    L5_2 = "slotfull"
    return L4_2(L5_2)
  end
  L4_2 = L88_1
  L5_2 = A0_2
  L6_2 = A1_2.slot
  L7_2 = L32_1
  L8_2 = A1_2.iccid
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L7_2(L8_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  if not L4_2 then
    L5_2 = L74_1
    L6_2 = "noitem"
    return L5_2(L6_2)
  end
  L5_2 = L31_1
  L6_2 = L4_2.md
  L6_2 = L6_2.number
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  if L5_2 then
    L7_2 = L43_1
    L8_2 = L5_2
    L9_2 = nil
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = L74_1
      L8_2 = "taken"
      L9_2 = {}
      L9_2.number = L5_2
      return L7_2(L8_2, L9_2)
    end
  else
    L7_2 = L87_1
    L7_2 = L7_2[A0_2]
    if L7_2 then
      L8_2 = L28_1
      L8_2 = L8_2()
      L9_2 = L7_2.t
      L8_2 = L8_2 - L9_2
      L9_2 = 300000
      if L8_2 < L9_2 then
        L9_2 = L7_2.number
        L8_2 = L12_1
        L8_2 = L8_2[L9_2]
        if not L8_2 then
          L6_2 = L7_2.number
        end
      end
    end
  end
  L7_2 = L32_1
  L8_2 = L4_2.md
  L8_2 = L8_2.iccid
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    if not L5_2 then
      L7_2 = L87_1
      L7_2 = L7_2[A0_2]
      if L7_2 then
        L7_2 = L87_1
        L7_2 = L7_2[A0_2]
        L7_2 = L7_2.iccid
        if L7_2 then
          goto lbl_97
        end
      end
    end
    L7_2 = nil
  end
  ::lbl_97::
  if L7_2 then
    L8_2 = L11_1
    L8_2 = L8_2[L7_2]
    if L8_2 then
      L7_2 = nil
    end
  end
  L8_2 = L44_1
  L9_2 = L6_2
  L10_2 = "esim"
  L11_2 = L8_1.realCid
  L12_2 = A0_2
  L11_2 = L11_2(L12_2)
  L12_2 = L7_2
  L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  if not L8_2 then
    L10_2 = L74_1
    L11_2 = L9_2 or L11_2
    if not L9_2 then
      L11_2 = "busy"
    end
    return L10_2(L11_2)
  end
  L10_2 = L87_1
  L10_2[A0_2] = nil
  L10_2 = L59_1
  L11_2 = A0_2
  L12_2 = L2_2
  L13_2 = L8_2
  L14_2 = L8_1.ownerOf
  L15_2 = L2_2
  L14_2 = L14_2(L15_2)
  if not L14_2 then
    L14_2 = L8_1.realCid
    L15_2 = A0_2
    L14_2 = L14_2(L15_2)
  end
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  if not L10_2 then
    L10_2 = pcall
    L11_2 = MySQL
    L11_2 = L11_2.query
    L11_2 = L11_2.await
    L12_2 = "DELETE FROM apex_phone_sims WHERE iccid = ? AND device IS NULL"
    L13_2 = {}
    L14_2 = L8_2.iccid
    L13_2[1] = L14_2
    L10_2(L11_2, L12_2, L13_2)
    L10_2 = L38_1
    L11_2 = L8_2
    L10_2(L11_2)
    L10_2 = L74_1
    L11_2 = "busy"
    return L10_2(L11_2)
  end
  L10_2 = L89_1
  L11_2 = A0_2
  L12_2 = L4_2
  L10_2 = L10_2(L11_2, L12_2)
  if not L10_2 then
    L10_2 = pcall
    L11_2 = MySQL
    L11_2 = L11_2.update
    L11_2 = L11_2.await
    L12_2 = "UPDATE apex_phone_sims SET device = NULL, account = NULL WHERE iccid = ?"
    L13_2 = {}
    L14_2 = L8_2.iccid
    L13_2[1] = L14_2
    L10_2(L11_2, L12_2, L13_2)
    L10_2 = pcall
    L11_2 = MySQL
    L11_2 = L11_2.query
    L11_2 = L11_2.await
    L12_2 = "DELETE FROM apex_phone_sims WHERE iccid = ? AND device IS NULL"
    L13_2 = {}
    L14_2 = L8_2.iccid
    L13_2[1] = L14_2
    L10_2(L11_2, L12_2, L13_2)
    L10_2 = L38_1
    L11_2 = L8_2
    L10_2(L11_2)
    L10_2 = L52_1
    L11_2 = A0_2
    L12_2 = L2_2
    L13_2 = nil
    L10_2(L11_2, L12_2, L13_2)
    L10_2 = L74_1
    L11_2 = "noitem"
    return L10_2(L11_2)
  end
  L10_2 = TriggerEvent
  L11_2 = "apex_phone:esimActivated"
  L12_2 = A0_2
  L13_2 = L8_2.number
  L14_2 = L8_2.iccid
  L10_2(L11_2, L12_2, L13_2, L14_2)
  L10_2 = TriggerEvent
  L11_2 = "apex_phone:simInserted"
  L12_2 = A0_2
  L13_2 = L3_2
  L14_2 = L8_2.number
  L15_2 = L8_2.iccid
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = L73_1
  L11_2 = A0_2
  L12_2 = "esim"
  L10_2(L11_2, L12_2)
  L10_2 = L66_1
  L11_2 = A0_2
  L12_2 = "activate"
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = L10_2.lines
  L11_2 = L11_2[1]
  L10_2.line = L11_2
  return L10_2
end
function L92_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = {}
  L1_2 = GetPlayerNumber
  L0_2.GetPlayerNumber = L1_2
  L1_2 = GetSrcByNumber
  L0_2.GetSrcByNumber = L1_2
  L1_2 = GetCitizenIdByNumber
  L0_2.GetCitizenIdByNumber = L1_2
  L1_2 = GetNumberByCitizenId
  L0_2.GetNumberByCitizenId = L1_2
  L1_2 = CanonNumber
  L0_2.CanonNumber = L1_2
  L1_2 = SyncPhoneNumberState
  L0_2.SyncPhoneNumberState = L1_2
  L1_2 = ResetAccount
  L0_2.ResetAccount = L1_2
  L1_2 = SimLineOwner
  L0_2.SimLineOwner = L1_2
  L1_2 = SimNumberTaken
  L0_2.SimNumberTaken = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L65_1
    L2_3 = tonumber
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = -1
    end
    return L1_3(L2_3)
  end
  GetPlayerNumber = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    if nil == A0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = tostring
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L2_3 = L12_1
    L1_3 = L2_3[L1_3]
    if L1_3 then
      L2_3 = L1_3.device
      if L2_3 then
        goto lbl_17
      end
    end
    L2_3 = nil
    do return L2_3 end
    ::lbl_17::
    L3_3 = L1_3.device
    L2_3 = L21_1
    L2_3 = L2_3[L3_3]
    if L2_3 then
      L3_3 = L20_1
      L3_3 = L3_3[L2_3]
      if L3_3 then
        L3_3 = L20_1
        L3_3 = L3_3[L2_3]
        L3_3 = L3_3.serial
        L4_3 = L1_3.device
        if L3_3 == L4_3 then
          return L2_3
        end
      end
    end
    L3_3 = nil
    return L3_3
  end
  GetSrcByNumber = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "string" ~= L1_3 then
      L1_3 = type
      L2_3 = A0_3
      L1_3 = L1_3(L2_3)
      if "number" ~= L1_3 then
        return A0_3
      end
    end
    L1_3 = tostring
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "" ~= L1_3 then
      L2_3 = L12_1
      L2_3 = L2_3[L1_3]
      if not L2_3 then
        goto lbl_22
      end
    end
    do return L1_3 end
    ::lbl_22::
    L2_3 = L29_1
    L3_3 = L1_3
    L2_3 = L2_3(L3_3)
    L3_3 = L30_1
    L3_3 = L3_3()
    L4_3 = L14_1
    L4_3 = L4_3[L2_3]
    if not L4_3 and "" ~= L3_3 then
      L5_3 = #L2_3
      L6_3 = #L3_3
      if L5_3 > L6_3 then
        L6_3 = L2_3
        L5_3 = L2_3.sub
        L7_3 = 1
        L8_3 = #L3_3
        L5_3 = L5_3(L6_3, L7_3, L8_3)
        if L5_3 == L3_3 then
          L6_3 = L2_3
          L5_3 = L2_3.sub
          L7_3 = #L3_3
          L7_3 = L7_3 + 1
          L5_3 = L5_3(L6_3, L7_3)
          L6_3 = L14_1
          L4_3 = L6_3[L5_3]
        end
      end
    end
    if L4_3 then
      return L4_3
    end
    L5_3 = L0_2.CanonNumber
    L6_3 = A0_3
    return L5_3(L6_3)
  end
  CanonNumber = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    if not A0_3 or "" == A0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = tostring
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L2_3 = L12_1
    L1_3 = L2_3[L1_3]
    if L1_3 then
      L2_3 = GetSrcByNumber
      L3_3 = A0_3
      L2_3 = L2_3(L3_3)
      if L2_3 then
        L3_3 = GetCid
        L4_3 = L2_3
        return L3_3(L4_3)
      end
      L3_3 = L1_3.device
      if L3_3 then
        L3_3 = L1_3.account
        if L3_3 then
          goto lbl_30
        end
      end
      L3_3 = nil
      ::lbl_30::
      return L3_3
    end
    L2_3 = L0_2.GetCitizenIdByNumber
    L3_3 = A0_3
    return L2_3(L3_3)
  end
  GetCitizenIdByNumber = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    if not A0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = tostring
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    A0_3 = L1_3
    L1_3 = FW
    L1_3 = L1_3.GetPlayerByCid
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if L1_3 then
      L2_3 = L1_3.src
      if L2_3 then
        L2_3 = L65_1
        L3_3 = tonumber
        L4_3 = L1_3.src
        L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3)
        L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
        if L2_3 then
          return L2_3
        end
      end
    end
    L2_3 = nil
    L3_3 = pairs
    L4_3 = L15_1
    L4_3 = L4_3[A0_3]
    if not L4_3 then
      L4_3 = {}
    end
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = L8_3.device
      if L9_3 then
        if L2_3 then
          L9_3 = L8_3.updated
          if not L9_3 then
            L9_3 = 0
          end
          L10_3 = L2_3.updated
          if not L10_3 then
            L10_3 = 0
          end
          if not (L9_3 > L10_3) then
            goto lbl_52
          end
        end
        L2_3 = L8_3
      end
      ::lbl_52::
    end
    if L2_3 then
      L3_3 = L2_3.number
      return L3_3
    end
    L3_3 = L55_1
    L4_3 = A0_3
    L3_3 = L3_3(L4_3)
    if L3_3 then
      L3_3 = nil
      return L3_3
    end
    L3_3 = L0_2.GetNumberByCitizenId
    L4_3 = A0_3
    return L3_3(L4_3)
  end
  GetNumberByCitizenId = L1_2
  function L1_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = tonumber
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    A0_3 = L2_3
    if not A0_3 or A0_3 <= 0 then
      return
    end
    L2_3 = InvalidateOnlineIndex
    if L2_3 then
      L2_3 = InvalidateOnlineIndex
      L2_3()
    end
    L2_3 = L65_1
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    L3_3 = pcall
    function L4_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4
      L0_4 = Player
      L1_4 = A0_3
      L0_4 = L0_4(L1_4)
      L0_4 = L0_4.state
      L1_4 = L0_4
      L0_4 = L0_4.set
      L2_4 = "apex_phoneNumber"
      L3_4 = L2_3
      L4_4 = true
      L0_4(L1_4, L2_4, L3_4, L4_4)
    end
    L3_3(L4_3)
  end
  SyncPhoneNumberState = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    if A0_3 then
      L1_3 = Accounts
      L1_3 = L1_3[A0_3]
      if not L1_3 then
        L2_3 = pcall
        L3_3 = MySQL
        L3_3 = L3_3.single
        L3_3 = L3_3.await
        L4_3 = "SELECT citizenid, phone FROM apex_phone_accounts WHERE citizenid = ?"
        L5_3 = {}
        L6_3 = A0_3
        L5_3[1] = L6_3
        L2_3, L3_3 = L2_3(L3_3, L4_3, L5_3)
        L1_3 = L3_3 or L1_3
        if not L2_3 or not L3_3 then
          L1_3 = nil
        end
      end
      if L1_3 then
        L2_3 = {}
        L3_3 = pairs
        L4_3 = L1_3
        L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
        for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
          L2_3[L7_3] = L8_3
        end
        L2_3.phone = nil
        L3_3 = Accounts
        L3_3[A0_3] = L2_3
      end
    end
    L1_3 = L0_2.ResetAccount
    L2_3 = A0_3
    return L1_3(L2_3)
  end
  ResetAccount = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L65_1
    L2_3 = tonumber
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = -1
    end
    L1_3 = L1_3(L2_3)
    L1_3 = nil ~= L1_3
    return L1_3
  end
  SimHasLine = L1_2
  function L1_2()
    local L0_3, L1_3
    L0_3 = false
    return L0_3
  end
  SimDormant = L1_2
  function L1_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = L55_1
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if L2_3 then
      L2_3 = tostring
      L3_3 = A1_3 or L3_3
      if not A1_3 then
        L3_3 = ""
      end
      L2_3 = L2_3(L3_3)
      L3_3 = L12_1
      L2_3 = L3_3[L2_3]
      L2_3 = not L2_3
    end
    return L2_3
  end
  SimDormantCid = L1_2
  function L1_2()
    local L0_3, L1_3
    L0_3 = nil
    return L0_3
  end
  SimSrcByLine = L1_2
  function L1_2()
    local L0_3, L1_3
    L0_3 = nil
    return L0_3
  end
  SimLineTag = L1_2
  function L1_2()
    local L0_3, L1_3
    L0_3 = nil
    return L0_3
  end
  SimLineTagCid = L1_2
  function L1_2()
    local L0_3, L1_3
    L0_3 = {}
    return L0_3
  end
  SimEnsure = L1_2
  function L1_2(A0_3, A1_3)
    local L2_3, L3_3
    if A0_3 then
      L2_3 = tostring
      L3_3 = A0_3
      L2_3 = L2_3(L3_3)
      L3_3 = L12_1
      L2_3 = L3_3[L2_3]
      if L2_3 then
        L2_3 = tostring
        L3_3 = A0_3
        return L2_3(L3_3)
      end
    end
    if A1_3 then
      L2_3 = L14_1
      L2_3 = L2_3[A1_3]
      if L2_3 then
        goto lbl_21
      end
    end
    L2_3 = nil
    ::lbl_21::
    return L2_3
  end
  SimCanon = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    if nil == A0_3 or "" == A0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = tostring
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L2_3 = L12_1
    L1_3 = L2_3[L1_3]
    if L1_3 then
      L2_3 = L1_3.device
      if L2_3 then
        L2_3 = L1_3.account
        if L2_3 then
          goto lbl_21
        end
      end
      L2_3 = nil
      ::lbl_21::
      return L2_3
    end
    L2_3 = L0_2.SimLineOwner
    if L2_3 then
      L2_3 = L0_2.SimLineOwner
      L3_3 = A0_3
      L2_3 = L2_3(L3_3)
      if L2_3 then
        goto lbl_31
      end
    end
    L2_3 = nil
    ::lbl_31::
    if L2_3 then
      L3_3 = L55_1
      L4_3 = L2_3
      L3_3 = L3_3(L4_3)
      if L3_3 then
        L3_3 = nil
        return L3_3
      end
    end
    return L2_3
  end
  SimLineOwner = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3
    L1_3 = tostring
    L2_3 = A0_3 or L2_3
    if not A0_3 then
      L2_3 = ""
    end
    L1_3 = L1_3(L2_3)
    L2_3 = L12_1
    L1_3 = L2_3[L1_3]
    if L1_3 then
      L1_3 = true
      return L1_3
    end
    L1_3 = L0_2.SimNumberTaken
    if L1_3 then
      L1_3 = L0_2.SimNumberTaken
      L2_3 = A0_3
      L1_3 = L1_3(L2_3)
      if L1_3 then
        goto lbl_21
      end
    end
    L1_3 = false
    ::lbl_21::
    return L1_3
  end
  SimNumberTaken = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L66_1
    L2_3 = A0_3
    L3_3 = "state"
    return L1_3(L2_3, L3_3)
  end
  SimState = L1_2
  L1_2 = RPC
  L1_2 = L1_2["device.use"]
  L2_2 = RPC
  L2_2 = L2_2["account.get"]
  L3_2 = RPC
  L3_2 = L3_2["account.create"]
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if "table" ~= L2_3 or not A1_3 then
      L2_3 = {}
      A1_3 = L2_3
    end
    L2_3 = L8_1.realCid
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    L3_3 = A1_3.slot
    if nil == L3_3 then
      L3_3 = A1_3.use
      if true ~= L3_3 then
        L3_3 = A1_3.force
        if true ~= L3_3 and L2_3 then
          L3_3 = L70_1
          L4_3 = A0_3
          L5_3 = L2_3
          L3_3 = L3_3(L4_3, L5_3)
          L4_3 = L8_1.session
          L5_3 = A0_3
          L4_3 = L4_3(L5_3)
          if L4_3 then
            L5_3 = L4_3.serial
          end
          L5_3 = L3_3 or L5_3
          if not L5_3 and not L3_3 then
            L5_3 = L20_1
            L5_3 = L5_3[A0_3]
            if L5_3 then
              L5_3 = L20_1
              L5_3 = L5_3[A0_3]
              L5_3 = L5_3.serial
            end
          end
          if L5_3 then
            L6_3 = L53_1
            L7_3 = A0_3
            L8_3 = L5_3
            L6_3 = L6_3(L7_3, L8_3)
            if L6_3 then
              if not L4_3 then
                L7_3 = L61_1
                L8_3 = L6_3
                L9_3 = L2_3
                L7_3 = L7_3(L8_3, L9_3)
                if not L7_3 then
                  goto lbl_66
                end
              end
              L7_3 = L6_3.slot
              L8_3 = L6_3.name
              A1_3.item = L8_3
              A1_3.slot = L7_3
            end
          end
        end
      end
    end
    ::lbl_66::
    L3_3 = L27_1
    L3_3[A0_3] = true
    L3_3 = pcall
    L4_3 = L1_2
    L5_3 = A0_3
    L6_3 = A1_3
    L3_3, L4_3 = L3_3(L4_3, L5_3, L6_3)
    L5_3 = L27_1
    L5_3[A0_3] = nil
    if not L3_3 then
      L5_3 = error
      L6_3 = L4_3
      L7_3 = 0
      L5_3(L6_3, L7_3)
    end
    L5_3 = type
    L6_3 = L4_3
    L5_3 = L5_3(L6_3)
    if "table" == L5_3 then
      L5_3 = L4_3.ok
      if L5_3 then
        L5_3 = L4_3.slot
        if L5_3 then
          L5_3 = ipairs
          L6_3 = L8_1.slots
          L7_3 = A0_3
          L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3 = L6_3(L7_3)
          L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
          for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
            L11_3 = L10_3.slot
            L12_3 = L4_3.slot
            if L11_3 == L12_3 then
              L11_3 = L10_3.md
              L11_3 = L11_3.apex_serial
              if L11_3 then
                L11_3 = L4_3.mode
                if "foreign" ~= L11_3 then
                  L11_3 = L71_1
                  L12_3 = A0_3
                  L13_3 = L2_3
                  L14_3 = L10_3.md
                  L14_3 = L14_3.apex_serial
                  L11_3(L12_3, L13_3, L14_3)
                end
                break
              end
            end
          end
        end
      end
    end
    L5_3 = L73_1
    L6_3 = A0_3
    L7_3 = "use"
    L5_3(L6_3, L7_3)
    return L4_3
  end
  L4_2["device.use"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L2_3 = L2_2
    L3_3 = A0_3
    L4_3 = A1_3
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = type
    L4_3 = L2_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = L8_1.realCid
      L4_3 = A0_3
      L3_3 = L3_3(L4_3)
      if L3_3 then
        L4_3 = L55_1
        L5_3 = L3_3
        L4_3 = L4_3(L5_3)
        if not L4_3 then
          L4_3 = L20_1
          L4_3 = L4_3[A0_3]
          L5_3 = L64_1
          L6_3 = L3_3
          L7_3 = A0_3
          if L4_3 then
            L8_3 = L53_1
            L9_3 = A0_3
            L10_3 = L4_3.serial
            L8_3 = L8_3(L9_3, L10_3)
            if L8_3 then
              goto lbl_34
            end
          end
          L8_3 = nil
          ::lbl_34::
          L5_3(L6_3, L7_3, L8_3)
          L5_3 = L73_1
          L6_3 = A0_3
          L7_3 = "migrate"
          L5_3(L6_3, L7_3)
        end
      end
      L4_3 = L65_1
      L5_3 = A0_3
      L4_3 = L4_3(L5_3)
      L5_3 = L4_3 or L5_3
      if not L4_3 then
        L5_3 = ""
      end
      L2_3.phone = L5_3
      L5_3 = nil == L4_3 or L5_3
      L2_3.nosim = L5_3
      L5_3 = SyncPhoneNumberState
      L6_3 = A0_3
      L5_3(L6_3)
    end
    return L2_3
  end
  L4_2["account.get"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L2_3 = L8_1.realCid
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if L2_3 then
      L3_3 = L25_1
      L3_3[L2_3] = true
    end
    L3_3 = pcall
    L4_3 = L3_2
    L5_3 = A0_3
    L6_3 = A1_3
    L3_3, L4_3 = L3_3(L4_3, L5_3, L6_3)
    if not L3_3 then
      if L2_3 then
        L5_3 = L25_1
        L5_3[L2_3] = nil
      end
      L5_3 = error
      L6_3 = L4_3
      L7_3 = 0
      L5_3(L6_3, L7_3)
    end
    L5_3 = type
    L6_3 = L4_3
    L5_3 = L5_3(L6_3)
    if "table" == L5_3 then
      L5_3 = L4_3.error
      if not L5_3 and L2_3 then
        L5_3 = L0_1.starterSim
        L6_3 = L31_1
        L7_3 = L4_3.phone
        L6_3 = L6_3(L7_3)
        L7_3 = pcall
        function L8_3()
          local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4
          L0_4 = L5_3
          if "none" ~= L0_4 then
            L0_4 = L5_3
            if false ~= L0_4 then
              L0_4 = L6_3
              if L0_4 then
                L1_4 = L6_3
                L0_4 = L12_1
                L0_4 = L0_4[L1_4]
                if not L0_4 then
                  L0_4 = L44_1
                  L1_4 = L6_3
                  L2_4 = "starter"
                  L3_4 = L2_3
                  L0_4 = L0_4(L1_4, L2_4, L3_4)
                  if L0_4 then
                    L1_4 = nil
                    L2_4 = L73_1
                    L3_4 = A0_3
                    L4_4 = "create"
                    L2_4 = L2_4(L3_4, L4_4)
                    if L2_4 then
                      L3_4 = L53_1
                      L4_4 = A0_3
                      L5_4 = L2_4.serial
                      L3_4 = L3_4(L4_4, L5_4)
                      L1_4 = L3_4
                    end
                    L3_4 = L5_3
                    if "item" ~= L3_4 and L1_4 then
                      L3_4 = L61_1
                      L4_4 = L1_4
                      L5_4 = L2_3
                      L3_4 = L3_4(L4_4, L5_4)
                      if L3_4 then
                        L3_4 = L59_1
                        L4_4 = A0_3
                        L5_4 = L1_4
                        L6_4 = L0_4
                        L7_4 = L8_1.ownerOf
                        L8_4 = L1_4
                        L7_4 = L7_4(L8_4)
                        if not L7_4 then
                          L7_4 = L2_3
                        end
                        L3_4 = L3_4(L4_4, L5_4, L6_4, L7_4)
                        if L3_4 then
                          goto lbl_63
                        end
                      end
                    end
                    L3_4 = L57_1
                    L4_4 = A0_3
                    L5_4 = L2_3
                    L6_4 = L0_4
                    L3_4(L4_4, L5_4, L6_4)
                  end
                end
              end
            end
          end
          ::lbl_63::
        end
        L7_3, L8_3 = L7_3(L8_3)
        if not L7_3 then
          L9_3 = L1_1
          L10_3 = "starter SIM of "
          L11_3 = tostring
          L12_3 = L2_3
          L11_3 = L11_3(L12_3)
          L12_3 = ": "
          L13_3 = tostring
          L14_3 = L8_3
          L13_3 = L13_3(L14_3)
          L10_3 = L10_3 .. L11_3 .. L12_3 .. L13_3
          L9_3(L10_3)
        end
        L9_3 = L56_1
        L10_3 = L2_3
        L9_3(L10_3)
        L9_3 = L25_1
        L9_3[L2_3] = nil
        L9_3 = L73_1
        L10_3 = A0_3
        L11_3 = "create"
        L9_3(L10_3, L11_3)
        L9_3 = L65_1
        L10_3 = A0_3
        L9_3 = L9_3(L10_3)
        L10_3 = L9_3 or L10_3
        if not L9_3 then
          L10_3 = ""
        end
        L4_3.phone = L10_3
        L10_3 = nil == L9_3 or L10_3
        L4_3.nosim = L10_3
        L10_3 = SyncPhoneNumberState
        L11_3 = A0_3
        L10_3(L11_3)
      end
    end
    if L2_3 then
      L5_3 = L25_1
      L5_3[L2_3] = nil
    end
    return L4_3
  end
  L4_2["account.create"] = L5_2
  L4_2 = RPC
  function L5_2()
    local L0_3, L1_3
    L0_3 = {}
    L0_3.ok = false
    L0_3.error = "physical"
    return L0_3
  end
  L4_2["account.swapSim"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L73_1
    L2_3 = A0_3
    L3_3 = "state"
    L1_3(L2_3, L3_3)
    L1_3 = L66_1
    L2_3 = A0_3
    L3_3 = "state"
    return L1_3(L2_3, L3_3)
  end
  L4_2["sim.lines"] = L5_2
  L4_2 = RPC
  L5_2 = RPC
  L5_2 = L5_2["sim.lines"]
  L4_2["psim.state"] = L5_2
  L4_2 = RPC
  function L5_2()
    local L0_3, L1_3
    L0_3 = {}
    L0_3.ok = true
    L0_3.required = false
    L1_3 = L37_1
    L1_3 = L1_3()
    L0_3.carrier = L1_3
    L0_3.max = 1
    L0_3.hasCard = false
    L0_3.physical = true
    return L0_3
  end
  L4_2["sim.config"] = L5_2
  L4_2 = RPC
  function L5_2()
    local L0_3, L1_3
    L0_3 = L74_1
    L1_3 = "physical"
    return L0_3(L1_3)
  end
  L4_2["sim.switch"] = L5_2
  L4_2 = RPC
  function L5_2()
    local L0_3, L1_3
    L0_3 = L74_1
    L1_3 = "physical"
    return L0_3(L1_3)
  end
  L4_2["sim.remove"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if "table" ~= L2_3 or not A1_3 then
      L2_3 = {}
      A1_3 = L2_3
    end
    L2_3 = L20_1
    L2_3 = L2_3[A0_3]
    L3_3 = L2_3
    if L2_3 then
      L4_3 = L2_3.serial
      L3_3 = L13_1
      L3_3 = L3_3[L4_3]
    end
    if L3_3 then
      L4_3 = A1_3.number
      if nil == L4_3 then
        goto lbl_33
      end
      L4_3 = tostring
      L5_3 = A1_3.number
      L4_3 = L4_3(L5_3)
      L5_3 = L3_3.number
      if L4_3 == L5_3 then
        goto lbl_33
      end
    end
    L4_3 = L74_1
    L5_3 = "notfound"
    do return L4_3(L5_3) end
    ::lbl_33::
    L4_3 = type
    L5_3 = A1_3.label
    L4_3 = L4_3(L5_3)
    if "string" == L4_3 then
      L4_3 = A1_3.label
      L5_3 = L4_3
      L4_3 = L4_3.gsub
      L6_3 = "%c"
      L7_3 = " "
      L4_3 = L4_3(L5_3, L6_3, L7_3)
      L5_3 = L4_3
      L4_3 = L4_3.sub
      L6_3 = 1
      L7_3 = 24
      L4_3 = L4_3(L5_3, L6_3, L7_3)
      if L4_3 then
        goto lbl_50
      end
    end
    L4_3 = nil
    ::lbl_50::
    if "" == L4_3 or "Principal" == L4_3 then
      L4_3 = nil
    end
    L5_3 = pcall
    L6_3 = MySQL
    L6_3 = L6_3.update
    L6_3 = L6_3.await
    L7_3 = "UPDATE apex_phone_sims SET label = ? WHERE iccid = ?"
    L8_3 = {}
    L9_3 = L4_3
    L10_3 = L3_3.iccid
    L8_3[1] = L9_3
    L8_3[2] = L10_3
    L5_3(L6_3, L7_3, L8_3)
    L3_3.label = L4_3
    L5_3 = L66_1
    L6_3 = A0_3
    L7_3 = "rename"
    return L5_3(L6_3, L7_3)
  end
  L4_2["sim.rename"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = L79_1
    L3_3 = A0_3
    function L4_3()
      local L0_4, L1_4, L2_4, L3_4
      L0_4 = L90_1
      L1_4 = A0_3
      L2_4 = type
      L3_4 = A1_3
      L2_4 = L2_4(L3_4)
      if "table" == L2_4 then
        L2_4 = A1_3
        if L2_4 then
          goto lbl_13
        end
      end
      L2_4 = {}
      ::lbl_13::
      return L0_4(L1_4, L2_4)
    end
    return L2_3(L3_3, L4_3)
  end
  L4_2["sim.preview"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = L79_1
    L3_3 = A0_3
    function L4_3()
      local L0_4, L1_4, L2_4, L3_4
      L0_4 = L91_1
      L1_4 = A0_3
      L2_4 = type
      L3_4 = A1_3
      L2_4 = L2_4(L3_4)
      if "table" == L2_4 then
        L2_4 = A1_3
        if L2_4 then
          goto lbl_13
        end
      end
      L2_4 = {}
      ::lbl_13::
      return L0_4(L1_4, L2_4)
    end
    return L2_3(L3_3, L4_3)
  end
  L4_2["sim.activate"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if "table" ~= L2_3 or not A1_3 then
      L2_3 = {}
      A1_3 = L2_3
    end
    L2_3 = L79_1
    L3_3 = A0_3
    function L4_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4
      L0_4 = L80_1
      L1_4 = A0_3
      L0_4 = L0_4(L1_4)
      if not L0_4 then
        L1_4 = L74_1
        L2_4 = "nophone"
        return L1_4(L2_4)
      end
      L1_4 = L0_4.md
      L2_4 = L1_4.apex_serial
      L1_4 = L13_1
      L1_4 = L1_4[L2_4]
      if L1_4 then
        L1_4 = L74_1
        L2_4 = "slotfull"
        return L1_4(L2_4)
      end
      L1_4 = L48_1
      L2_4 = A0_3
      L3_4 = A1_3.slot
      L1_4 = L1_4(L2_4, L3_4)
      L2_4 = L32_1
      L3_4 = A1_3.iccid
      L2_4 = L2_4(L3_4)
      if L1_4 and L2_4 then
        L3_4 = L32_1
        L4_4 = L1_4.md
        L4_4 = L4_4.iccid
        L3_4 = L3_4(L4_4)
        if L3_4 ~= L2_4 then
          L1_4 = nil
        end
      end
      if not L1_4 and L2_4 then
        L3_4 = ipairs
        L4_4 = L47_1
        L5_4 = A0_3
        L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4 = L4_4(L5_4)
        L3_4, L4_4, L5_4, L6_4 = L3_4(L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4)
        for L7_4, L8_4 in L3_4, L4_4, L5_4, L6_4 do
          L9_4 = L32_1
          L10_4 = L8_4.md
          L10_4 = L10_4.iccid
          L9_4 = L9_4(L10_4)
          if L9_4 == L2_4 then
            L1_4 = L8_4
            break
          end
        end
      end
      if not L1_4 then
        L3_4 = L74_1
        L4_4 = "noitem"
        return L3_4(L4_4)
      end
      L3_4 = L76_1
      L4_4 = A0_3
      L5_4 = L0_4
      L6_4 = L1_4
      L3_4 = L3_4(L4_4, L5_4, L6_4)
      L4_4 = L78_1
      L5_4 = A0_3
      L6_4 = L0_4.md
      L6_4 = L6_4.apex_serial
      L4_4(L5_4, L6_4)
      return L3_4
    end
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = type
    L4_3 = L2_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = L2_3.ok
      if L3_3 then
        L3_3 = L66_1
        L4_3 = A0_3
        L5_3 = "insert"
        L3_3 = L3_3(L4_3, L5_3)
        L4_3 = L2_3.number
        L3_3.inserted = L4_3
        return L3_3
      end
    end
    return L2_3
  end
  L4_2["psim.insert"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = L79_1
    L2_3 = A0_3
    function L3_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4
      L0_4 = L80_1
      L1_4 = A0_3
      L0_4 = L0_4(L1_4)
      if not L0_4 then
        L1_4 = L74_1
        L2_4 = "nophone"
        return L1_4(L2_4)
      end
      L1_4 = L77_1
      L2_4 = A0_3
      L3_4 = L0_4
      L1_4 = L1_4(L2_4, L3_4)
      L2_4 = L78_1
      L3_4 = A0_3
      L4_4 = L0_4.md
      L4_4 = L4_4.apex_serial
      L2_4(L3_4, L4_4)
      return L1_4
    end
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = type
    L3_3 = L1_3
    L2_3 = L2_3(L3_3)
    if "table" == L2_3 then
      L2_3 = L1_3.ok
      if L2_3 then
        L2_3 = L66_1
        L3_3 = A0_3
        L4_3 = "eject"
        L2_3 = L2_3(L3_3, L4_3)
        L3_3 = L1_3.number
        L2_3.ejected = L3_3
        return L2_3
      end
    end
    return L1_3
  end
  L4_2["psim.eject"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = L8_1.realCid
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L2_3 = L74_1
      L3_3 = "noplayer"
      return L2_3(L3_3)
    end
    L2_3 = L67_1
    L2_3 = L2_3()
    L3_3 = {}
    L3_3.ok = true
    L4_3 = L2_3.enabled
    L3_3.enabled = L4_3
    L4_3 = L2_3.price
    L3_3.price = L4_3
    L4_3 = L68_1
    L5_3 = A0_3
    L6_3 = L1_3
    L4_3 = L4_3(L5_3, L6_3)
    L3_3.numbers = L4_3
    return L3_3
  end
  L4_2["psim.recoverable"] = L5_2
  L4_2 = RPC
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L2_3 = L84_1
    L3_3 = A0_3
    L4_3 = type
    L5_3 = A1_3
    L4_3 = L4_3(L5_3)
    L4_3 = A1_3 or L4_3
    if "table" ~= L4_3 or not A1_3 then
      L4_3 = {}
    end
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = type
    L4_3 = L2_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = L2_3.ok
      if L3_3 then
        L3_3 = L66_1
        L4_3 = A0_3
        L5_3 = "recover"
        L3_3 = L3_3(L4_3, L5_3)
        L4_3 = L2_3.number
        L5_3 = L2_3.charged
        L6_3 = L2_3.inserted
        L6_3 = true == L6_3
        L7_3 = L2_3.delivered
        L3_3.delivered = L7_3
        L3_3.inserted = L6_3
        L3_3.charged = L5_3
        L3_3.recovered = L4_3
        return L3_3
      end
    end
    return L2_3
  end
  L4_2["psim.recover"] = L5_2
  L4_2 = L0_1.contactsOnSim
  if false ~= L4_2 then
    function L4_2(A0_3)
      local L1_3, L2_3, L3_3, L4_3
      L1_3 = tonumber
      L2_3 = A0_3
      L1_3 = L1_3(L2_3)
      A0_3 = L1_3
      L1_3 = A0_3 or L1_3
      if A0_3 then
        L1_3 = L20_1
        L1_3 = L1_3[A0_3]
      end
      L2_3 = L1_3
      if L1_3 then
        L3_3 = L1_3.serial
        L2_3 = L13_1
        L2_3 = L2_3[L3_3]
      end
      if not L2_3 then
        L3_3 = nil
        return L3_3
      end
      L3_3 = L85_1
      L4_3 = L2_3
      return L3_3(L4_3)
    end
    ContactsOwner = L4_2
  end
  L4_2 = type
  L5_2 = Config
  L5_2 = L5_2.RateLimit
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = Config
    L4_2 = L4_2.RateLimit
    if L4_2 then
      goto lbl_128
    end
  end
  L4_2 = nil
  ::lbl_128::
  if L4_2 then
    L5_2 = type
    L6_2 = L4_2.costs
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L5_2 = L4_2.costs
      if L5_2 then
        goto lbl_140
      end
    end
    L5_2 = {}
    ::lbl_140::
    L4_2.costs = L5_2
    L5_2 = L4_2.costs
    L5_2 = L5_2["psim.insert"]
    if nil == L5_2 then
      L5_2 = L4_2.costs
      L5_2["psim.insert"] = 4
    end
    L5_2 = L4_2.costs
    L5_2 = L5_2["psim.eject"]
    if nil == L5_2 then
      L5_2 = L4_2.costs
      L5_2["psim.eject"] = 4
    end
    L5_2 = L4_2.costs
    L5_2 = L5_2["psim.recover"]
    if nil == L5_2 then
      L5_2 = L4_2.costs
      L5_2["psim.recover"] = 5
    end
    L5_2 = L4_2.costs
    L5_2 = L5_2["psim.recoverable"]
    if nil == L5_2 then
      L5_2 = L4_2.costs
      L5_2["psim.recoverable"] = 2
    end
  end
end
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = A0_2 or L2_2
  if A0_2 then
    L2_2 = L8_1.realCid
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  if not L2_2 then
    L3_2 = nil
    L4_2 = "noplayer"
    return L3_2, L4_2
  end
  L3_2 = L31_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L12_1
    L4_2 = L4_2[L3_2]
    if L4_2 then
      L4_2 = L12_1
      L4_2 = L4_2[L3_2]
      L5_2 = L4_2.home
      if L5_2 ~= L2_2 then
        L5_2 = nil
        L6_2 = "taken"
        return L5_2, L6_2
      end
      L5_2 = L73_1
      L6_2 = A0_2
      L7_2 = "check"
      L5_2(L6_2, L7_2)
      L5_2 = false
      L6_2 = ipairs
      L7_2 = L68_1
      L8_2 = A0_2
      L9_2 = L2_2
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2, L9_2)
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = L11_2.number
        if L12_2 == L3_2 then
          L5_2 = true
          break
        end
      end
      if not L5_2 then
        L6_2 = nil
        L7_2 = "notlost"
        return L6_2, L7_2
      end
      L6_2 = L83_1
      L7_2 = A0_2
      L8_2 = L2_2
      L9_2 = L4_2
      L10_2 = 0
      L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
      L7_2 = L6_2.ok
      if not L7_2 then
        L7_2 = nil
        L8_2 = L6_2.error
        return L7_2, L8_2
      end
      L7_2 = L73_1
      L8_2 = A0_2
      L9_2 = "recover"
      L7_2(L8_2, L9_2)
      L7_2 = L4_2.number
      return L7_2
    end
  end
  if L3_2 then
    L4_2 = L43_1
    L5_2 = L3_2
    L6_2 = nil
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = nil
      L5_2 = "taken"
      return L4_2, L5_2
    end
  end
  L4_2 = L44_1
  L5_2 = L3_2
  L6_2 = "admin"
  L7_2 = L8_1.realCid
  L8_2 = A0_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2)
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  if not L4_2 then
    L6_2 = nil
    L7_2 = L5_2
    return L6_2, L7_2
  end
  L6_2 = L50_1
  L7_2 = A0_2
  L8_2 = L45_1
  L9_2 = L4_2
  L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  if L6_2 then
    L6_2 = L51_1
    L7_2 = A0_2
    L8_2 = L45_1
    L9_2 = L4_2
    L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    if L6_2 then
      goto lbl_120
    end
  end
  L6_2 = L60_1
  L7_2 = L4_2
  L6_2(L7_2)
  L6_2 = nil
  L7_2 = "full"
  do return L6_2, L7_2 end
  ::lbl_120::
  L6_2 = L4_2.number
  return L6_2
end
function L94_1()
  local L0_2, L1_2, L2_2
  L0_2 = exports
  L1_2 = "GetSimInDevice"
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = tostring
    L2_3 = A0_3 or L2_3
    if not A0_3 then
      L2_3 = ""
    end
    L1_3 = L1_3(L2_3)
    L2_3 = L13_1
    L1_3 = L2_3[L1_3]
    if L1_3 then
      L2_3 = {}
      L3_3 = L1_3.iccid
      L2_3.iccid = L3_3
      L3_3 = L1_3.number
      L2_3.number = L3_3
      if L2_3 then
        goto lbl_19
      end
    end
    L2_3 = nil
    ::lbl_19::
    return L2_3
  end
  L0_2(L1_2, L2_2)
  L0_2 = exports
  L1_2 = "GetPlayerSim"
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = -1
    end
    L2_3 = L20_1
    L1_3 = L2_3[L1_3]
    if not L1_3 then
      L2_3 = nil
      return L2_3
    end
    L3_3 = L1_3.serial
    L2_3 = L13_1
    L2_3 = L2_3[L3_3]
    L3_3 = {}
    L4_3 = L1_3.serial
    L3_3.serial = L4_3
    L4_3 = L1_3.item
    L3_3.item = L4_3
    if L2_3 then
      L4_3 = L2_3.iccid
      if L4_3 then
        goto lbl_28
      end
    end
    L4_3 = nil
    ::lbl_28::
    L3_3.iccid = L4_3
    if L2_3 then
      L4_3 = L2_3.number
      if L4_3 then
        goto lbl_35
      end
    end
    L4_3 = nil
    ::lbl_35::
    L3_3.number = L4_3
    return L3_3
  end
  L0_2(L1_2, L2_2)
  L0_2 = exports
  L1_2 = "GiveSimCard"
  function L2_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = L93_1
    L3_3 = A0_3
    L4_3 = A1_3
    return L2_3(L3_3, L4_3)
  end
  L0_2(L1_2, L2_2)
  L0_2 = exports
  L1_2 = "RecoverSimCard"
  function L2_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = L84_1
    L3_3 = tonumber
    L4_3 = A0_3
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = -1
    end
    L4_3 = {}
    L4_3.number = A1_3
    L4_3.insert = true
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = type
    L4_3 = L2_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = L2_3.ok
      if L3_3 then
        L3_3 = L2_3.number
        return L3_3
      end
    end
    L3_3 = nil
    L4_3 = type
    L5_3 = L2_3
    L4_3 = L4_3(L5_3)
    if "table" == L4_3 then
      L4_3 = L2_3.error
      if L4_3 then
        goto lbl_33
      end
    end
    L4_3 = "internal"
    ::lbl_33::
    return L3_3, L4_3
  end
  L0_2(L1_2, L2_2)
end
function L95_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = RegisterNetEvent
  L1_2 = "apex_phone:server:psimUse"
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = source
    L2_3 = RateLimitAllow
    if L2_3 then
      L2_3 = RateLimitAllow
      L3_3 = L1_3
      L4_3 = "event.psimUse"
      L2_3 = L2_3(L3_3, L4_3)
      if not L2_3 then
        return
      end
    end
    L2_3 = CreateThread
    function L3_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4
      L0_4 = L86_1
      L1_4 = L1_3
      L2_4 = A0_3
      L0_4 = L0_4(L1_4, L2_4)
      L1_4 = L0_4.ok
      if L1_4 then
        L1_4 = L82_1
        L2_4 = L1_3
        L3_4 = L0_4.swapped
        if L3_4 then
          L3_4 = "swapped"
          if L3_4 then
            goto lbl_17
          end
        end
        L3_4 = "inserted"
        ::lbl_17::
        L4_4 = L0_4.number
        L5_4 = "success"
        L1_4(L2_4, L3_4, L4_4, L5_4)
      else
        L1_4 = L82_1
        L2_4 = L1_3
        L3_4 = L0_4.error
        L1_4(L2_4, L3_4)
      end
    end
    L2_3(L3_3)
  end
  L0_2(L1_2, L2_2)
  L0_2 = RegisterNetEvent
  L1_2 = "apex_phone:server:psimEject"
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = source
    L2_3 = RateLimitAllow
    if L2_3 then
      L2_3 = RateLimitAllow
      L3_3 = L1_3
      L4_3 = "event.psimEject"
      L2_3 = L2_3(L3_3, L4_3)
      if not L2_3 then
        return
      end
    end
    L2_3 = CreateThread
    function L3_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4
      L0_4 = L79_1
      L1_4 = L1_3
      function L2_4()
        local L0_5, L1_5, L2_5, L3_5, L4_5, L5_5, L6_5, L7_5, L8_5
        L0_5 = math
        L0_5 = L0_5.tointeger
        L1_5 = tonumber
        L2_5 = A0_3
        L1_5, L2_5, L3_5, L4_5, L5_5, L6_5, L7_5, L8_5 = L1_5(L2_5)
        L0_5 = L0_5(L1_5, L2_5, L3_5, L4_5, L5_5, L6_5, L7_5, L8_5)
        A0_3 = L0_5
        L0_5 = nil
        L1_5 = ipairs
        L2_5 = L8_1.slots
        L3_5 = L1_3
        L2_5, L3_5, L4_5, L5_5, L6_5, L7_5, L8_5 = L2_5(L3_5)
        L1_5, L2_5, L3_5, L4_5 = L1_5(L2_5, L3_5, L4_5, L5_5, L6_5, L7_5, L8_5)
        for L5_5, L6_5 in L1_5, L2_5, L3_5, L4_5 do
          L7_5 = L6_5.slot
          L8_5 = A0_3
          if L7_5 == L8_5 then
            L0_5 = L6_5
            break
          end
        end
        if not L0_5 then
          L1_5 = L80_1
          L2_5 = L1_3
          L1_5 = L1_5(L2_5)
          L0_5 = L1_5
        end
        if not L0_5 then
          L1_5 = L74_1
          L2_5 = "nophone"
          return L1_5(L2_5)
        end
        L1_5 = L77_1
        L2_5 = L1_3
        L3_5 = L0_5
        L1_5 = L1_5(L2_5, L3_5)
        L2_5 = L78_1
        L3_5 = L1_3
        L4_5 = L0_5.md
        L4_5 = L4_5.apex_serial
        L2_5(L3_5, L4_5)
        return L1_5
      end
      L0_4 = L0_4(L1_4, L2_4)
      L1_4 = L0_4.ok
      if L1_4 then
        L1_4 = L82_1
        L2_4 = L1_3
        L3_4 = "ejected"
        L4_4 = L0_4.number
        L5_4 = "success"
        L1_4(L2_4, L3_4, L4_4, L5_4)
      else
        L1_4 = L82_1
        L2_4 = L1_3
        L3_4 = L0_4.error
        L1_4(L2_4, L3_4)
      end
    end
    L2_3(L3_3)
  end
  L0_2(L1_2, L2_2)
  L0_2 = AddEventHandler
  L1_2 = "apex_phone:foreignSession"
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    A0_3 = L1_3
    if A0_3 then
      L1_3 = L27_1
      L1_3 = L1_3[A0_3]
      if not L1_3 then
        goto lbl_12
      end
    end
    do return end
    ::lbl_12::
    L1_3 = SetTimeout
    L2_3 = 0
    function L3_3()
      local L0_4, L1_4, L2_4
      L0_4 = L73_1
      L1_4 = A0_3
      L2_4 = "session"
      L0_4(L1_4, L2_4)
    end
    L1_3(L2_3, L3_3)
  end
  L0_2(L1_2, L2_2)
  L0_2 = AddEventHandler
  L1_2 = "playerDropped"
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = tonumber
    L1_3 = source
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      return
    end
    L1_3 = L20_1
    L1_3 = L1_3[L0_3]
    if L1_3 then
      L3_3 = L1_3.serial
      L2_3 = L21_1
      L2_3 = L2_3[L3_3]
      if L2_3 == L0_3 then
        L3_3 = L1_3.serial
        L2_3 = L21_1
        L2_3[L3_3] = nil
      end
    end
    L2_3 = L20_1
    L3_3 = L23_1
    L4_3 = L22_1
    L5_3 = L87_1
    L6_3 = nil
    L7_3 = nil
    L8_3 = nil
    L5_3[L0_3] = nil
    L4_3[L0_3] = L8_3
    L3_3[L0_3] = L7_3
    L2_3[L0_3] = L6_3
    L2_3 = InvalidateOnlineIndex
    if L2_3 then
      L2_3 = InvalidateOnlineIndex
      L2_3()
    end
  end
  L0_2(L1_2, L2_2)
  L0_2 = FW
  L0_2 = L0_2.OnPlayerLoaded
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = SetTimeout
    L2_3 = 1500
    function L3_3()
      local L0_4, L1_4
      L0_4 = CreateThread
      function L1_4()
        local L0_5, L1_5, L2_5
        L0_5 = L73_1
        L1_5 = A0_3
        L2_5 = "loaded"
        L0_5(L1_5, L2_5)
      end
      L0_4(L1_4)
    end
    L1_3(L2_3, L3_3)
  end
  L0_2(L1_2)
  L0_2 = L9_1
  if "qb" == L0_2 then
    L0_2 = L46_1
    L0_2 = L0_2()
    if L0_2 then
      L1_2 = L0_2.Functions
      if L1_2 then
        L1_2 = L0_2.Functions
        L1_2 = L1_2.CreateUseableItem
        if L1_2 then
          L1_2 = pcall
          L2_2 = L0_2.Functions
          L2_2 = L2_2.CreateUseableItem
          L3_2 = L10_1
          function L4_2(A0_3, A1_3)
            local L2_3, L3_3, L4_3, L5_3
            L2_3 = type
            L3_3 = A1_3
            L2_3 = L2_3(L3_3)
            if "table" == L2_3 then
              L2_3 = math
              L2_3 = L2_3.tointeger
              L3_3 = tonumber
              L4_3 = A1_3.slot
              L3_3, L4_3, L5_3 = L3_3(L4_3)
              L2_3 = L2_3(L3_3, L4_3, L5_3)
              if L2_3 then
                goto lbl_15
              end
            end
            L2_3 = nil
            ::lbl_15::
            L3_3 = A0_3
            L4_3 = CreateThread
            function L5_3()
              local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4
              L0_4 = L86_1
              L1_4 = L3_3
              L2_4 = L2_3
              L0_4 = L0_4(L1_4, L2_4)
              L1_4 = L0_4.ok
              if L1_4 then
                L1_4 = L82_1
                L2_4 = L3_3
                L3_4 = L0_4.swapped
                if L3_4 then
                  L3_4 = "swapped"
                  if L3_4 then
                    goto lbl_17
                  end
                end
                L3_4 = "inserted"
                ::lbl_17::
                L4_4 = L0_4.number
                L5_4 = "success"
                L1_4(L2_4, L3_4, L4_4, L5_4)
              else
                L1_4 = L82_1
                L2_4 = L3_3
                L3_4 = L0_4.error
                L1_4(L2_4, L3_4)
              end
            end
            L4_3(L5_3)
          end
          L1_2(L2_2, L3_2, L4_2)
        end
      end
    end
  end
  L0_2 = L9_1
  if "ox" == L0_2 then
    L0_2 = {}
    L1_2 = L10_1
    L0_2[L1_2] = true
    L1_2 = pairs
    L2_2 = Config
    L2_2 = L2_2.Devices
    if not L2_2 then
      L2_2 = {}
    end
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2 in L1_2, L2_2, L3_2, L4_2 do
      L0_2[L5_2] = true
    end
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
      L0_3 = exports
      L0_3 = L0_3.ox_inventory
      L1_3 = L0_3
      L0_3 = L0_3.registerHook
      L2_3 = "swapItems"
      function L3_3(A0_4)
        local L1_4, L2_4, L3_4, L4_4, L5_4
        L1_4 = type
        L2_4 = A0_4
        L1_4 = L1_4(L2_4)
        if "table" ~= L1_4 then
          return
        end
        L1_4 = tonumber
        L2_4 = A0_4.fromInventory
        L1_4 = L1_4(L2_4)
        L2_4 = tonumber
        L3_4 = A0_4.toInventory
        L2_4 = L2_4(L3_4)
        L3_4 = SetTimeout
        L4_4 = 250
        function L5_4()
          local L0_5, L1_5
          L0_5 = L1_4
          if L0_5 then
            L0_5 = CreateThread
            function L1_5()
              local L0_6, L1_6, L2_6
              L0_6 = L73_1
              L1_6 = L1_4
              L2_6 = "swap"
              L0_6(L1_6, L2_6)
            end
            L0_5(L1_5)
          end
          L0_5 = L2_4
          if L0_5 then
            L0_5 = L2_4
            L1_5 = L1_4
            if L0_5 ~= L1_5 then
              L0_5 = CreateThread
              function L1_5()
                local L0_6, L1_6, L2_6
                L0_6 = L73_1
                L1_6 = L2_4
                L2_6 = "swap"
                L0_6(L1_6, L2_6)
              end
              L0_5(L1_5)
            end
          end
        end
        L3_4(L4_4, L5_4)
      end
      L4_3 = {}
      L5_3 = L0_2
      L4_3.itemFilter = L5_3
      L0_3(L1_3, L2_3, L3_3, L4_3)
    end
    L1_2(L2_2)
  end
  L0_2 = type
  L1_2 = L0_1.giveCommand
  L0_2 = L0_2(L1_2)
  if "string" == L0_2 then
    L0_2 = L0_1.giveCommand
    if "" ~= L0_2 then
      L0_2 = L0_1.giveCommand
      if L0_2 then
        goto lbl_77
      end
    end
  end
  L0_2 = nil
  ::lbl_77::
  if L0_2 then
    L1_2 = RegisterCommand
    L2_2 = L0_2
    function L3_2(A0_3, A1_3)
      local L2_3, L3_3, L4_3, L5_3
      if 0 ~= A0_3 then
        L2_3 = IsPhoneAdmin
        if L2_3 then
          L2_3 = IsPhoneAdmin
          L3_3 = A0_3
          L2_3 = L2_3(L3_3)
          if L2_3 then
            goto lbl_12
          end
        end
        return
      end
      ::lbl_12::
      L2_3 = tonumber
      L3_3 = A1_3[1]
      L2_3 = L2_3(L3_3)
      if not L2_3 then
        L2_3 = A0_3
      end
      L3_3 = L31_1
      L4_3 = A1_3[2]
      L3_3 = L3_3(L4_3)
      L4_3 = CreateThread
      function L5_3()
        local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4
        L0_4 = L93_1
        L1_4 = L2_3
        L2_4 = L3_3
        L0_4, L1_4 = L0_4(L1_4, L2_4)
        if L0_4 then
          L2_4 = "SIM %s entregue a %s"
          L3_4 = L2_4
          L2_4 = L2_4.format
          L4_4 = L0_4
          L5_4 = tostring
          L6_4 = L2_3
          L5_4, L6_4 = L5_4(L6_4)
          L2_4 = L2_4(L3_4, L4_4, L5_4, L6_4)
          if L2_4 then
            goto lbl_22
          end
        end
        L2_4 = "SIM not delivered (%s)"
        L3_4 = L2_4
        L2_4 = L2_4.format
        L4_4 = tostring
        L5_4 = L1_4
        L4_4, L5_4, L6_4 = L4_4(L5_4)
        L2_4 = L2_4(L3_4, L4_4, L5_4, L6_4)
        ::lbl_22::
        L3_4 = A0_3
        if 0 == L3_4 then
          L3_4 = print
          L4_4 = "[unique_phone] "
          L5_4 = L2_4
          L4_4 = L4_4 .. L5_4
          L3_4(L4_4)
        elseif L0_4 then
          L3_4 = FW
          L3_4 = L3_4.Notify
          L4_4 = A0_3
          L5_4 = L2_4
          L6_4 = "success"
          L3_4(L4_4, L5_4, L6_4)
        else
          L3_4 = FW
          L3_4 = L3_4.Notify
          L4_4 = A0_3
          L5_4 = L81_1
          L5_4 = L5_4[L1_4]
          if not L5_4 then
            L5_4 = "N\195\163o foi poss\195\173vel entregar o SIM."
          end
          L6_4 = "error"
          L3_4(L4_4, L5_4, L6_4)
        end
      end
      L4_3(L5_3)
    end
    L4_2 = false
    L1_2(L2_2, L3_2, L4_2)
  end
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 2
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 60
  L5_2 = tonumber
  L6_2 = L0_1.checkSeconds
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 5
  end
  L3_2 = L3_2(L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2)
  L1_2 = L1_2 * 1000
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    while true do
      L0_3 = Wait
      L1_3 = L1_2
      L0_3(L1_3)
      L0_3 = FW
      L0_3 = L0_3.GetPlayers
      L0_3 = L0_3()
      L1_3 = ipairs
      L2_3 = L0_3
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
      for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
        L7_3 = pcall
        L8_3 = L73_1
        L9_3 = L6_3
        L10_3 = "check"
        L7_3(L8_3, L9_3, L10_3)
        L7_3 = L5_3 % 8
        if 0 == L7_3 then
          L7_3 = Wait
          L8_3 = 0
          L7_3(L8_3)
        end
      end
    end
  end
  L2_2(L3_2)
  L2_2 = AddEventHandler
  L3_2 = "onResourceStop"
  function L4_2(A0_3)
    local L1_3
    L1_3 = GetCurrentResourceName
    L1_3 = L1_3()
    if A0_3 ~= L1_3 then
      return
    end
    L1_3 = GlobalState
    L1_3["apex_phone:psim"] = nil
  end
  L2_2(L3_2, L4_2)
end
function L96_1()
  local L0_2, L1_2, L2_2
  L0_2 = type
  L1_2 = ShopBridge
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = type
    L1_2 = ShopBridge
    L1_2 = L1_2.AddItem
    L0_2 = L0_2(L1_2)
    if "function" == L0_2 then
      goto lbl_13
    end
  end
  do return end
  ::lbl_13::
  L0_2 = ShopBridge
  L0_2 = L0_2.AddItem
  L1_2 = ShopBridge
  function L2_2(A0_3, A1_3, A2_3, A3_3)
    local L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L4_3 = L10_1
    if A1_3 == L4_3 then
      L4_3 = type
      L5_3 = A3_3
      L4_3 = L4_3(L5_3)
      if "table" ~= L4_3 then
        goto lbl_16
      end
    end
    L4_3 = L0_2
    L5_3 = A0_3
    L6_3 = A1_3
    L7_3 = A2_3
    L8_3 = A3_3
    do return L4_3(L5_3, L6_3, L7_3, L8_3) end
    ::lbl_16::
    L4_3 = math
    L4_3 = L4_3.max
    L5_3 = 1
    L6_3 = math
    L6_3 = L6_3.floor
    L7_3 = tonumber
    L8_3 = A2_3
    L7_3 = L7_3(L8_3)
    if not L7_3 then
      L7_3 = 1
    end
    L6_3 = L6_3(L7_3)
    L4_3 = L4_3(L5_3, L6_3)
    A2_3 = L4_3
    L4_3 = L8_1.realCid
    L5_3 = A0_3
    L4_3 = L4_3(L5_3)
    L5_3 = 1
    L6_3 = A2_3
    L7_3 = 1
    for L8_3 = L5_3, L6_3, L7_3 do
      L9_3 = L44_1
      L10_3 = nil
      L11_3 = "shop"
      L12_3 = L4_3
      L9_3 = L9_3(L10_3, L11_3, L12_3)
      if not L9_3 then
        L10_3 = L8_3 > 1
        return L10_3
      end
      L10_3 = L0_2
      L11_3 = A0_3
      L12_3 = A1_3
      L13_3 = 1
      L14_3 = L45_1
      L15_3 = L9_3
      L14_3, L15_3 = L14_3(L15_3)
      L10_3 = L10_3(L11_3, L12_3, L13_3, L14_3, L15_3)
      if not L10_3 then
        L10_3 = L60_1
        L11_3 = L9_3
        L10_3(L11_3)
        L10_3 = false
        return L10_3
      end
    end
    L5_3 = true
    return L5_3
  end
  L1_2.AddItem = L2_2
end
L97_1 = CreateThread
function L98_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = AdminStore
    if L1_2 then
      L1_2 = AdminStore
      L1_2 = L1_2.ready
      if L1_2 then
        break
      end
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 20000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 250
    L1_2(L2_2)
  end
  L1_2 = L0_1.enabled
  if true ~= L1_2 then
    return
  end
  L1_2 = Config
  L1_2 = L1_2.RequireItem
  if false == L1_2 then
    L1_2 = L1_1
    L2_2 = "requires Config.RequireItem = true (the number lives on the phone). Staying OFF."
    L1_2(L2_2)
    return
  end
  L1_2 = type
  L2_2 = L0_1.item
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L0_1.item
    if "" ~= L1_2 then
      L1_2 = L0_1.item
      if L1_2 then
        goto lbl_45
      end
    end
  end
  L1_2 = "sim_card"
  ::lbl_45::
  L10_1 = L1_2
  L1_2 = DeviceOwnerActivate
  if not L1_2 then
    L1_2 = L1_1
    L2_2 = "server/device_owner.lua is missing. Staying OFF."
    L1_2(L2_2)
    return
  end
  L1_2 = DeviceOwnerActivate
  L2_2 = "psim"
  L1_2(L2_2)
  L1_2 = DeviceOwnerAPI
  L8_1 = L1_2
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  while true do
    L2_2 = L8_1
    if L2_2 then
      L2_2 = L8_1.inv
      L2_2 = L2_2()
      if nil ~= L2_2 then
        break
      end
    end
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L2_2 = L2_2 - L1_2
    L3_2 = 90000
    if not (L2_2 < L3_2) then
      break
    end
    L2_2 = Wait
    L3_2 = 250
    L2_2(L3_2)
    L2_2 = DeviceOwnerAPI
    L8_1 = L2_2
  end
  L2_2 = L8_1
  if L2_2 then
    L2_2 = L8_1.inv
    L2_2 = L2_2()
    if L2_2 then
      goto lbl_91
    end
  end
  L2_2 = L1_1
  L3_2 = "the inventory does not store per-slot metadata (needs ox_inventory, or qb-inventory/ps-inventory/lj-inventory on QBCore). Staying OFF."
  L2_2(L3_2)
  do return end
  ::lbl_91::
  L2_2 = L8_1.inv
  L2_2 = L2_2()
  L9_1 = L2_2
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  while true do
    L3_2 = DBReady
    if L3_2 then
      break
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L3_2 = L3_2 - L2_2
    L4_2 = 120000
    if not (L3_2 < L4_2) then
      break
    end
    L3_2 = Wait
    L4_2 = 250
    L3_2(L4_2)
  end
  L3_2 = L3_1
  L4_2 = " DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
  L3_2 = L3_2 .. L4_2
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L3_2
    L0_3(L1_3)
  end
  L4_2, L5_2 = L4_2(L5_2)
  if not L4_2 then
    L6_2 = L1_1
    L7_2 = "could not create apex_phone_sims ("
    L8_2 = tostring
    L9_2 = L5_2
    L8_2 = L8_2(L9_2)
    L9_2 = "). Staying OFF."
    L7_2 = L7_2 .. L8_2 .. L9_2
    L6_2(L7_2)
    return
  end
  L6_2 = MigrateTable
  if L6_2 then
    L6_2 = pcall
    L7_2 = MigrateTable
    L8_2 = L3_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT * FROM apex_phone_sims"
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = ipairs
      L9_2 = L7_2
      L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
      for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
        L14_2 = L39_1
        L15_2 = L41_1
        L16_2 = L13_2
        L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L15_2(L16_2)
        L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
      end
    end
  end
  L8_2 = pcall
  function L9_2()
    local L0_3, L1_3, L2_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L4_1
    L2_3 = " DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    L1_3 = L1_3 .. L2_3
    L0_3(L1_3)
  end
  L8_2, L9_2 = L8_2(L9_2)
  if not L8_2 then
    L10_2 = L1_1
    L11_2 = "could not create apex_phone_sims_blocked ("
    L12_2 = tostring
    L13_2 = L9_2
    L12_2 = L12_2(L13_2)
    L13_2 = ")"
    L11_2 = L11_2 .. L12_2 .. L13_2
    L10_2(L11_2)
  end
  L10_2 = pcall
  L11_2 = MySQL
  L11_2 = L11_2.query
  L11_2 = L11_2.await
  L12_2 = "SELECT iccid FROM apex_phone_sims_blocked"
  L10_2, L11_2 = L10_2(L11_2, L12_2)
  if L10_2 then
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "table" == L12_2 then
      L12_2 = ipairs
      L13_2 = L11_2
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
      for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
        L18_2 = L17_2.iccid
        if L18_2 then
          L18_2 = tostring
          L19_2 = L17_2.iccid
          L18_2 = L18_2(L19_2)
          L19_2 = L18_1
          L19_2[L18_2] = true
        end
      end
    end
  end
  L12_2 = L92_1
  L12_2()
  L12_2 = L95_1
  L12_2()
  L12_2 = L96_1
  L12_2()
  L12_2 = L94_1
  L12_2()
  PsimOn = true
  L12_2 = GlobalState
  L13_2 = {}
  L13_2.on = true
  L14_2 = L10_1
  L13_2.item = L14_2
  L12_2["apex_phone:psim"] = L13_2
  L12_2 = print
  L13_2 = "^2[unique_phone]^0 Physical SIM: ON (%s, item %s, %d SIMs registered, starter SIM %s, eSIM %s)"
  L14_2 = L13_2
  L13_2 = L13_2.format
  L15_2 = L9_1
  if "ox" == L15_2 then
    L15_2 = "ox_inventory"
    if L15_2 then
      goto lbl_226
    end
  end
  L15_2 = "qb-inventory"
  ::lbl_226::
  L16_2 = L10_1
  L17_2 = L7_2 or L17_2
  if not L6_2 or not L7_2 then
    L17_2 = {}
  end
  L17_2 = #L17_2
  L18_2 = tostring
  L19_2 = L0_1.starterSim
  if not L19_2 then
    L19_2 = "auto"
  end
  L18_2 = L18_2(L19_2)
  L19_2 = L0_1.esimCards
  if "off" == L19_2 then
    L19_2 = "disabled"
    if L19_2 then
      goto lbl_247
    end
  end
  L19_2 = "in slot"
  ::lbl_247::
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L12_2 = ipairs
  L13_2 = FW
  L13_2 = L13_2.GetPlayers
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L13_2()
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = pcall
    L19_2 = L73_1
    L20_2 = L17_2
    L21_2 = "start"
    L18_2(L19_2, L20_2, L21_2)
  end
end
L97_1(L98_1)
