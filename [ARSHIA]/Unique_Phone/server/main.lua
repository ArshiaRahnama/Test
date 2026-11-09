local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1, L87_1, L88_1, L89_1, L90_1, L91_1, L92_1, L93_1, L94_1, L95_1, L96_1, L97_1, L98_1, L99_1, L100_1, L101_1, L102_1, L103_1, L104_1, L105_1, L106_1, L107_1, L108_1, L109_1, L110_1, L111_1, L112_1, L113_1, L114_1, L115_1, L116_1, L117_1, L118_1, L119_1, L120_1, L121_1, L122_1, L123_1, L124_1, L125_1, L126_1, L127_1
L0_1 = {}
RPC = L0_1
L0_1 = {}
Accounts = L0_1
L0_1 = {}
ServerApps = L0_1
DBReady = false
L0_1 = {}
L1_1 = {}
L2_1 = {}
L3_1 = false
function L4_1()
  local L0_2, L1_2
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L0_2 = L0_2 * 1000
  return L0_2
end
Now = L4_1
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "CREATE TABLE IF NOT EXISTS%s+`([%w_]+)`"
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L3_2 = A0_2
  L2_2 = A0_2.find
  L4_2 = "%("
  L6_2 = A0_2
  L5_2 = A0_2.find
  L7_2 = "`"
  L8_2 = L1_2
  L9_2 = "`"
  L7_2 = L7_2 .. L8_2 .. L9_2
  L8_2 = 1
  L9_2 = true
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L5_2 = 1
  end
  L6_2 = #L1_2
  L5_2 = L5_2 + L6_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = nil
  L4_2 = #A0_2
  L5_2 = 1
  L6_2 = -1
  for L7_2 = L4_2, L5_2, L6_2 do
    L9_2 = A0_2
    L8_2 = A0_2.sub
    L10_2 = L7_2
    L11_2 = L7_2
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if ")" == L8_2 then
      L3_2 = L7_2
      break
    end
  end
  if not (L2_2 and L3_2) or L2_2 >= L3_2 then
    L4_2 = L1_2
    L5_2 = {}
    return L4_2, L5_2
  end
  L5_2 = A0_2
  L4_2 = A0_2.sub
  L6_2 = L2_2 + 1
  L7_2 = L3_2 - 1
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = {}
  L6_2 = 0
  L7_2 = {}
  L8_2 = 1
  L9_2 = #L4_2
  L10_2 = 1
  for L11_2 = L8_2, L9_2, L10_2 do
    L13_2 = L4_2
    L12_2 = L4_2.sub
    L14_2 = L11_2
    L15_2 = L11_2
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    if "(" == L12_2 then
      L6_2 = L6_2 + 1
      L13_2 = #L7_2
      L13_2 = L13_2 + 1
      L7_2[L13_2] = L12_2
    elseif ")" == L12_2 then
      L6_2 = L6_2 - 1
      L13_2 = #L7_2
      L13_2 = L13_2 + 1
      L7_2[L13_2] = L12_2
    elseif "," == L12_2 and 0 == L6_2 then
      L13_2 = #L5_2
      L13_2 = L13_2 + 1
      L14_2 = table
      L14_2 = L14_2.concat
      L15_2 = L7_2
      L14_2 = L14_2(L15_2)
      L5_2[L13_2] = L14_2
      L13_2 = {}
      L7_2 = L13_2
    else
      L13_2 = #L7_2
      L13_2 = L13_2 + 1
      L7_2[L13_2] = L12_2
    end
  end
  L8_2 = #L5_2
  L8_2 = L8_2 + 1
  L9_2 = table
  L9_2 = L9_2.concat
  L10_2 = L7_2
  L9_2 = L9_2(L10_2)
  L5_2[L8_2] = L9_2
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L5_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L16_2 = L14_2
    L15_2 = L14_2.match
    L17_2 = "^%s*`([%w_]+)`%s+(.-)%s*$"
    L15_2, L16_2 = L15_2(L16_2, L17_2)
    if L15_2 and L16_2 and "" ~= L16_2 then
      L17_2 = #L8_2
      L17_2 = L17_2 + 1
      L18_2 = {}
      L18_2.name = L15_2
      L18_2.def = L16_2
      L8_2[L17_2] = L18_2
    end
  end
  L9_2 = L1_2
  L10_2 = L8_2
  return L9_2, L10_2
end
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L2_2 = A0_2
  L1_2 = A0_2.upper
  L1_2 = L1_2(L2_2)
  L3_2 = L1_2
  L2_2 = L1_2.find
  L4_2 = "AUTO_INCREMENT"
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = L1_2
    L2_2 = L1_2.find
    L4_2 = "PRIMARY KEY"
    L2_2 = L2_2(L3_2, L4_2)
    if not L2_2 then
      goto lbl_15
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_15::
  L3_2 = L1_2
  L2_2 = L1_2.find
  L4_2 = "DEFAULT"
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = A0_2
    L2_2 = A0_2.gsub
    L4_2 = "[Nn][Oo][Tt]%s+[Nn][Uu][Ll][Ll]"
    L5_2 = "NULL"
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    A0_2 = L2_2
  end
  return A0_2
end
L7_1 = {}
L7_1.varchar = -1
L7_1.tinytext = 255
L7_1.text = 65535
L7_1.mediumtext = 16777215
L7_1.longtext = 4294967295
L7_1.tinyblob = 255
L7_1.blob = 65535
L7_1.mediumblob = 16777215
L7_1.longblob = 4294967295
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = A0_2
  L1_2 = A0_2.lower
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.match
  L3_2 = "^%s*(%a+)%s*%((%d+)%)"
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if "varchar" == L1_2 and L2_2 then
    L3_2 = tonumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    L4_2 = "VARCHAR(%s)"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = L2_2
    L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
    return L3_2, L4_2, L5_2, L6_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.lower
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.match
  L5_2 = "^%s*(%a+)"
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L7_1
    L4_2 = L4_2[L3_2]
    if L4_2 then
      L4_2 = L7_1
      L4_2 = L4_2[L3_2]
      if L4_2 > 0 then
        L4_2 = L7_1
        L4_2 = L4_2[L3_2]
        L6_2 = L3_2
        L5_2 = L3_2.upper
        L5_2, L6_2 = L5_2(L6_2)
        return L4_2, L5_2, L6_2
      end
    end
  end
  L4_2 = nil
  return L4_2
end
function L9_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = tostring
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if "varchar" == A0_2 or "char" == A0_2 then
    L2_2 = tonumber
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0
    end
    return L2_2
  end
  L2_2 = L7_1
  L2_2 = L2_2[A0_2]
  return L2_2
end
L10_1 = nil
L11_1 = nil
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
function L13_1()
  local L0_2, L1_2
  L0_2 = nil
  L1_2 = nil
  L11_1 = L1_2
  L10_1 = L0_2
end
SchemaInvalidate = L13_1
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2
  L4_2 = L10_1
  if L4_2 then
    L4_2 = L12_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_10
    end
  end
  do return end
  ::lbl_10::
  L5_2 = A0_2
  L4_2 = A0_2.lower
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  L4_2 = L10_1
  L5_2 = L10_1
  L5_2 = L5_2[A0_2]
  if not L5_2 then
    L5_2 = {}
  end
  L4_2[A0_2] = L5_2
  L4_2 = L10_1
  L4_2 = L4_2[A0_2]
  L5_2 = tostring
  L6_2 = A1_2
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  L5_2 = L5_2.lower
  L5_2 = L5_2(L6_2)
  L6_2 = {}
  L6_2.type = A2_2
  L6_2.max = A3_2
  L4_2[L5_2] = L6_2
end
SchemaColumnSet = L13_1
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = L11_1
  if L4_2 then
    L4_2 = L12_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_10
    end
  end
  do return end
  ::lbl_10::
  L5_2 = A0_2
  L4_2 = A0_2.lower
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  L4_2 = L11_1
  L5_2 = L11_1
  L5_2 = L5_2[A0_2]
  if not L5_2 then
    L5_2 = {}
  end
  L4_2[A0_2] = L5_2
  L4_2 = ipairs
  L5_2 = A2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L11_1
    L10_2 = L10_2[A0_2]
    L11_2 = L11_1
    L11_2 = L11_2[A0_2]
    L11_2 = #L11_2
    L11_2 = L11_2 + 1
    L12_2 = {}
    L12_2.idx = A1_2
    L12_2.seq = L8_2
    L12_2.col = L9_2
    if A3_2 then
      L13_2 = 0
      if L13_2 then
        goto lbl_43
      end
    end
    L13_2 = 1
    ::lbl_43::
    L12_2.nu = L13_2
    L10_2[L11_2] = L12_2
  end
end
SchemaIndexSet = L13_1
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3
    L1_3 = {}
    L2_3 = ipairs
    L3_3 = A0_3 or L3_3
    if not A0_3 then
      L3_3 = {}
    end
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = tostring
      L9_3 = L7_3.TABLE_NAME
      if not L9_3 then
        L9_3 = L7_3.table_name
        if not L9_3 then
          L9_3 = A0_2
        end
      end
      L8_3 = L8_3(L9_3)
      L9_3 = L8_3
      L8_3 = L8_3.lower
      L8_3 = L8_3(L9_3)
      L9_3 = L7_3.COLUMN_NAME
      if not L9_3 then
        L9_3 = L7_3.column_name
      end
      if L9_3 then
        L10_3 = L1_3[L8_3]
        if not L10_3 then
          L10_3 = {}
        end
        L1_3[L8_3] = L10_3
        L10_3 = L1_3[L8_3]
        L11_3 = tostring
        L12_3 = L9_3
        L11_3 = L11_3(L12_3)
        L12_3 = L11_3
        L11_3 = L11_3.lower
        L11_3 = L11_3(L12_3)
        L12_3 = {}
        L13_3 = L7_3.DATA_TYPE
        if not L13_3 then
          L13_3 = L7_3.data_type
        end
        L12_3.type = L13_3
        L13_3 = L7_3.CHARACTER_MAXIMUM_LENGTH
        if not L13_3 then
          L13_3 = L7_3.character_maximum_length
        end
        L12_3.max = L13_3
        L10_3[L11_3] = L12_3
      end
    end
    return L1_3
  end
  L2_2 = L12_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = MySQL
    L2_2 = L2_2.query
    L2_2 = L2_2.await
    L3_2 = "SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?"
    L4_2 = {}
    L5_2 = A0_2
    L4_2[1] = L5_2
    L2_2 = L2_2(L3_2, L4_2)
    L3_2 = L1_2
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    L5_2 = A0_2
    L4_2 = A0_2.lower
    L4_2 = L4_2(L5_2)
    L3_2 = L3_2[L4_2]
    if not L3_2 then
      L3_2 = {}
    end
    return L3_2
  end
  L2_2 = L10_1
  if not L2_2 then
    L2_2 = L1_2
    L3_2 = MySQL
    L3_2 = L3_2.query
    L3_2 = L3_2.await
    L4_2 = [[
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME LIKE 'apex\_phone\_%']]
    L3_2, L4_2, L5_2 = L3_2(L4_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L10_1 = L2_2
  end
  L3_2 = A0_2
  L2_2 = A0_2.lower
  L2_2 = L2_2(L3_2)
  L3_2 = L10_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L2_2 = {}
  end
  return L2_2
end
SchemaColumns = L13_1
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = L12_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = MySQL
    L1_2 = L1_2.query
    L1_2 = L1_2.await
    L2_2 = [[
SELECT INDEX_NAME AS idx, SEQ_IN_INDEX AS seq, COLUMN_NAME AS col, NON_UNIQUE AS nu FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? ORDER BY INDEX_NAME, SEQ_IN_INDEX]]
    L3_2 = {}
    L4_2 = A0_2
    L3_2[1] = L4_2
    L1_2 = L1_2(L2_2, L3_2)
    if not L1_2 then
      L1_2 = {}
    end
    return L1_2
  end
  L1_2 = L11_1
  if not L1_2 then
    L1_2 = MySQL
    L1_2 = L1_2.query
    L1_2 = L1_2.await
    L2_2 = [[
SELECT TABLE_NAME AS tname, INDEX_NAME AS idx, SEQ_IN_INDEX AS seq, COLUMN_NAME AS col, NON_UNIQUE AS nu FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME LIKE 'apex\_phone\_%' ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX]]
    L1_2 = L1_2(L2_2)
    if not L1_2 then
      L1_2 = {}
    end
    L2_2 = {}
    L3_2 = ipairs
    L4_2 = L1_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = tostring
      L10_2 = L8_2.tname
      if not L10_2 then
        L10_2 = L8_2.TNAME
        if not L10_2 then
          L10_2 = ""
        end
      end
      L9_2 = L9_2(L10_2)
      L10_2 = L9_2
      L9_2 = L9_2.lower
      L9_2 = L9_2(L10_2)
      L10_2 = L2_2[L9_2]
      if not L10_2 then
        L10_2 = {}
      end
      L2_2[L9_2] = L10_2
      L10_2 = L2_2[L9_2]
      L11_2 = L2_2[L9_2]
      L11_2 = #L11_2
      L11_2 = L11_2 + 1
      L10_2[L11_2] = L8_2
    end
    L11_1 = L2_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.lower
  L1_2 = L1_2(L2_2)
  L2_2 = L11_1
  L1_2 = L2_2[L1_2]
  if not L1_2 then
    L1_2 = {}
  end
  return L1_2
end
SchemaIndexes = L13_1
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L1_2 = L5_1
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 and L2_2 then
    L3_2 = #L2_2
    if 0 ~= L3_2 then
      goto lbl_13
    end
  end
  L3_2 = 0
  do return L3_2 end
  ::lbl_13::
  L3_2 = SchemaColumns
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L4_2 = next
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if nil == L4_2 then
    L4_2 = 0
    return L4_2
  end
  L4_2 = 0
  L5_2 = ipairs
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.name
    L12_2 = L11_2
    L11_2 = L11_2.lower
    L11_2 = L11_2(L12_2)
    L11_2 = L3_2[L11_2]
    if not L11_2 then
      L12_2 = L6_1
      L13_2 = L10_2.def
      L12_2 = L12_2(L13_2)
      if L12_2 then
        L13_2 = pcall
        function L14_2()
          local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
          L0_3 = MySQL
          L0_3 = L0_3.query
          L0_3 = L0_3.await
          L1_3 = "ALTER TABLE `%s` ADD COLUMN `%s` %s"
          L2_3 = L1_3
          L1_3 = L1_3.format
          L3_3 = L1_2
          L4_3 = L10_2.name
          L5_3 = L12_2
          L1_3, L2_3, L3_3, L4_3, L5_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
          L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
        end
        L13_2, L14_2 = L13_2(L14_2)
        if L13_2 then
          L4_2 = L4_2 + 1
          L15_2 = print
          L16_2 = "^2[unique_phone]^0 missing column added: %s.%s"
          L17_2 = L16_2
          L16_2 = L16_2.format
          L18_2 = L1_2
          L19_2 = L10_2.name
          L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L16_2(L17_2, L18_2, L19_2)
          L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
          L15_2 = L8_1
          L16_2 = L10_2.def
          L15_2, L16_2 = L15_2(L16_2)
          L17_2 = SchemaColumnSet
          L18_2 = L1_2
          L19_2 = L10_2.name
          if L16_2 then
            L21_2 = L16_2
            L20_2 = L16_2.lower
            L20_2 = L20_2(L21_2)
            L21_2 = L20_2
            L20_2 = L20_2.match
            L22_2 = "^%a+"
            L20_2 = L20_2(L21_2, L22_2)
            if L20_2 then
              goto lbl_73
            end
          end
          L21_2 = L12_2
          L20_2 = L12_2.lower
          L20_2 = L20_2(L21_2)
          L21_2 = L20_2
          L20_2 = L20_2.match
          L22_2 = "^%s*(%a+)"
          L20_2 = L20_2(L21_2, L22_2)
          ::lbl_73::
          L21_2 = L15_2
          L17_2(L18_2, L19_2, L20_2, L21_2)
        else
          L15_2 = print
          L16_2 = "^1[unique_phone]^0 could not add %s.%s (%s)"
          L17_2 = L16_2
          L16_2 = L16_2.format
          L18_2 = L1_2
          L19_2 = L10_2.name
          L20_2 = tostring
          L21_2 = L14_2
          L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L20_2(L21_2)
          L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
          L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
        end
      end
    else
      L12_2 = L8_1
      L13_2 = L10_2.def
      L12_2, L13_2 = L12_2(L13_2)
      L14_2 = L9_1
      L15_2 = L11_2.type
      L16_2 = L11_2.max
      L14_2 = L14_2(L15_2, L16_2)
      if L12_2 and L14_2 and L12_2 > L14_2 then
        L15_2 = L6_1
        L16_2 = L10_2.def
        L15_2 = L15_2(L16_2)
        if not L15_2 then
          L15_2 = L13_2
          L16_2 = " NULL"
          L15_2 = L15_2 .. L16_2
        end
        L16_2 = pcall
        function L17_2()
          local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
          L0_3 = MySQL
          L0_3 = L0_3.query
          L0_3 = L0_3.await
          L1_3 = "ALTER TABLE `%s` MODIFY `%s` %s"
          L2_3 = L1_3
          L1_3 = L1_3.format
          L3_3 = L1_2
          L4_3 = L10_2.name
          L5_3 = L15_2
          L1_3, L2_3, L3_3, L4_3, L5_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
          L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
        end
        L16_2, L17_2 = L16_2(L17_2)
        if L16_2 then
          L4_2 = L4_2 + 1
          L18_2 = SchemaColumnSet
          L19_2 = L1_2
          L20_2 = L10_2.name
          L22_2 = L13_2
          L21_2 = L13_2.lower
          L21_2 = L21_2(L22_2)
          L22_2 = L21_2
          L21_2 = L21_2.match
          L23_2 = "^%a+"
          L21_2 = L21_2(L22_2, L23_2)
          L22_2 = L12_2
          L18_2(L19_2, L20_2, L21_2, L22_2)
          L18_2 = print
          L19_2 = "^2[unique_phone]^0 column widened: %s.%s (%s %s -> %s) \226\128\148 data was being silently truncated"
          L20_2 = L19_2
          L19_2 = L19_2.format
          L21_2 = L1_2
          L22_2 = L10_2.name
          L23_2 = tostring
          L24_2 = L11_2.type
          L23_2 = L23_2(L24_2)
          L24_2 = tostring
          L25_2 = L14_2
          L24_2 = L24_2(L25_2)
          L25_2 = L13_2
          L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
          L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
        else
          L18_2 = print
          L19_2 = "^1[unique_phone]^0 could not widen %s.%s (%s)"
          L20_2 = L19_2
          L19_2 = L19_2.format
          L21_2 = L1_2
          L22_2 = L10_2.name
          L23_2 = tostring
          L24_2 = L17_2
          L23_2, L24_2, L25_2 = L23_2(L24_2)
          L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
          L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
        end
      end
    end
  end
  return L4_2
end
MigrateTable = L13_1
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L5_2 = A0_2
    L4_2 = A0_2.match
    L6_2 = "^[%w_]+$"
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = type
      L5_2 = A1_2
      L4_2 = L4_2(L5_2)
      if "string" == L4_2 then
        L5_2 = A1_2
        L4_2 = A1_2.match
        L6_2 = "^[%w_]+$"
        L4_2 = L4_2(L5_2, L6_2)
        if L4_2 then
          goto lbl_23
        end
      end
    end
  end
  L4_2 = false
  do return L4_2 end
  ::lbl_23::
  L4_2 = {}
  L5_2 = type
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L6_2 = A2_2
    L5_2 = A2_2.gmatch
    L7_2 = "[^,%s`]+"
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2)
    for L9_2 in L5_2, L6_2, L7_2, L8_2 do
      L10_2 = #L4_2
      L10_2 = L10_2 + 1
      L4_2[L10_2] = L9_2
    end
  else
    L5_2 = type
    L6_2 = A2_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L5_2 = ipairs
      L6_2 = A2_2
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
      for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
        L11_2 = #L4_2
        L11_2 = L11_2 + 1
        L12_2 = tostring
        L13_2 = L10_2
        L12_2 = L12_2(L13_2)
        L4_2[L11_2] = L12_2
      end
    end
  end
  L5_2 = #L4_2
  if 0 == L5_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L12_2 = L10_2
    L11_2 = L10_2.match
    L13_2 = "^[%w_]+$"
    L11_2 = L11_2(L12_2, L13_2)
    if not L11_2 then
      L11_2 = false
      return L11_2
    end
  end
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3
    L0_3 = next
    L1_3 = SchemaColumns
    L2_3 = A0_2
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3 = L1_3(L2_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3)
    if nil == L0_3 then
      L0_3 = false
      return L0_3
    end
    L0_3 = SchemaIndexes
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L1_3 = {}
    L2_3 = ipairs
    L3_3 = L0_3
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = tostring
      L9_3 = L7_3.idx
      L8_3 = L8_3(L9_3)
      L9_3 = L8_3
      L8_3 = L8_3.lower
      L8_3 = L8_3(L9_3)
      L9_3 = L1_3[L8_3]
      if not L9_3 then
        L9_3 = {}
        L10_3 = {}
        L9_3.cols = L10_3
        L10_3 = tonumber
        L11_3 = L7_3.nu
        L10_3 = L10_3(L11_3)
        if not L10_3 then
          L10_3 = 1
        end
        L10_3 = 0 == L10_3
        L9_3.unique = L10_3
      end
      L1_3[L8_3] = L9_3
      L9_3 = L1_3[L8_3]
      L9_3 = L9_3.cols
      L10_3 = math
      L10_3 = L10_3.tointeger
      L11_3 = tonumber
      L12_3 = L7_3.seq
      L11_3 = L11_3(L12_3)
      if not L11_3 then
        L11_3 = 0
      end
      L10_3 = L10_3(L11_3)
      if not L10_3 then
        L10_3 = 0
      end
      L11_3 = tostring
      L12_3 = L7_3.col
      L11_3 = L11_3(L12_3)
      L12_3 = L11_3
      L11_3 = L11_3.lower
      L11_3 = L11_3(L12_3)
      L9_3[L10_3] = L11_3
    end
    L2_3 = pairs
    L3_3 = L1_3
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = A1_2
      L9_3 = L8_3
      L8_3 = L8_3.lower
      L8_3 = L8_3(L9_3)
      if L6_3 == L8_3 then
        L8_3 = true
        return L8_3
      end
      L8_3 = true
      L9_3 = ipairs
      L10_3 = L4_2
      L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
      for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
        L15_3 = L7_3.cols
        L15_3 = L15_3[L13_3]
        L17_3 = L14_3
        L16_3 = L14_3.lower
        L16_3 = L16_3(L17_3)
        if L15_3 ~= L16_3 then
          L8_3 = false
          break
        end
      end
      if L8_3 then
        L9_3 = A3_2
        if L9_3 then
          L9_3 = L7_3.unique
          if not L9_3 then
            goto lbl_110
          end
          L9_3 = L7_3.cols
          L9_3 = #L9_3
          L10_3 = L4_2
          L10_3 = #L10_3
          if L9_3 ~= L10_3 then
            goto lbl_110
          end
        end
        L9_3 = true
        return L9_3
      end
      ::lbl_110::
    end
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L4_2
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = "`"
      L10_3 = L8_3
      L11_3 = "`"
      L9_3 = L9_3 .. L10_3 .. L11_3
      L2_3[L7_3] = L9_3
    end
    L3_3 = MySQL
    L3_3 = L3_3.query
    L3_3 = L3_3.await
    L4_3 = "ALTER TABLE `%s` ADD %sKEY `%s` (%s)"
    L5_3 = L4_3
    L4_3 = L4_3.format
    L6_3 = A0_2
    L7_3 = A3_2
    if L7_3 then
      L7_3 = "UNIQUE "
      if L7_3 then
        goto lbl_140
      end
    end
    L7_3 = ""
    ::lbl_140::
    L8_3 = A1_2
    L9_3 = table
    L9_3 = L9_3.concat
    L10_3 = L2_3
    L11_3 = ", "
    L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3 = L9_3(L10_3, L11_3)
    L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3)
    L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3)
    L3_3 = SchemaIndexSet
    L4_3 = A0_2
    L5_3 = A1_2
    L6_3 = L4_2
    L7_3 = A3_2
    L3_3(L4_3, L5_3, L6_3, L7_3)
    L3_3 = print
    L4_3 = "^2[unique_phone]^0 index created: %s.%s"
    L5_3 = L4_3
    L4_3 = L4_3.format
    L6_3 = A0_2
    L7_3 = A1_2
    L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3 = L4_3(L5_3, L6_3, L7_3)
    L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3)
    L3_3 = "created"
    return L3_3
  end
  L5_2, L6_2 = L5_2(L6_2)
  if not L5_2 then
    L7_2 = print
    L8_2 = "^3[unique_phone]^0 could not create index %s.%s (%s)"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = A0_2
    L11_2 = A1_2
    L12_2 = tostring
    L13_2 = L6_2
    L12_2, L13_2 = L12_2(L13_2)
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    L7_2 = false
    return L7_2
  end
  return L6_2
end
EnsureIndex = L13_1
L13_1 = {}
L14_1 = {}
L15_1 = "apex_phone_photos"
L16_1 = "ax_owner_created"
L17_1 = {}
L18_1 = "owner"
L19_1 = "created"
L17_1[1] = L18_1
L17_1[2] = L19_1
L14_1[1] = L15_1
L14_1[2] = L16_1
L14_1[3] = L17_1
L15_1 = {}
L16_1 = "apex_phone_calls"
L17_1 = "ax_owner_created"
L18_1 = {}
L19_1 = "owner"
L20_1 = "created"
L18_1[1] = L19_1
L18_1[2] = L20_1
L15_1[1] = L16_1
L15_1[2] = L17_1
L15_1[3] = L18_1
L16_1 = {}
L17_1 = "apex_phone_transactions"
L18_1 = "ax_owner_created"
L19_1 = {}
L20_1 = "owner"
L21_1 = "created"
L19_1[1] = L20_1
L19_1[2] = L21_1
L16_1[1] = L17_1
L16_1[2] = L18_1
L16_1[3] = L19_1
L17_1 = {}
L18_1 = "apex_phone_bills"
L19_1 = "ax_owner_created"
L20_1 = {}
L21_1 = "owner"
L22_1 = "created"
L20_1[1] = L21_1
L20_1[2] = L22_1
L17_1[1] = L18_1
L17_1[2] = L19_1
L17_1[3] = L20_1
L18_1 = {}
L19_1 = "apex_phone_messages"
L20_1 = "ax_sender"
L21_1 = {}
L22_1 = "sender"
L23_1 = "created"
L21_1[1] = L22_1
L21_1[2] = L23_1
L18_1[1] = L19_1
L18_1[2] = L20_1
L18_1[3] = L21_1
L19_1 = {}
L20_1 = "apex_phone_messages"
L21_1 = "ax_receiver"
L22_1 = {}
L23_1 = "receiver"
L24_1 = "read"
L22_1[1] = L23_1
L22_1[2] = L24_1
L19_1[1] = L20_1
L19_1[2] = L21_1
L19_1[3] = L22_1
L20_1 = {}
L21_1 = "apex_phone_mail"
L22_1 = "ax_owner_created"
L23_1 = {}
L24_1 = "owner"
L25_1 = "created"
L23_1[1] = L24_1
L23_1[2] = L25_1
L20_1[1] = L21_1
L20_1[2] = L22_1
L20_1[3] = L23_1
L21_1 = {}
L22_1 = "apex_phone_mail"
L23_1 = "ax_owner_folder"
L24_1 = {}
L25_1 = "owner"
L26_1 = "folder"
L27_1 = "read"
L24_1[1] = L25_1
L24_1[2] = L26_1
L24_1[3] = L27_1
L21_1[1] = L22_1
L21_1[2] = L23_1
L21_1[3] = L24_1
L22_1 = {}
L23_1 = "apex_phone_contacts"
L24_1 = "ax_owner_number"
L25_1 = {}
L26_1 = "owner"
L27_1 = "number"
L25_1[1] = L26_1
L25_1[2] = L27_1
L22_1[1] = L23_1
L22_1[2] = L24_1
L22_1[3] = L25_1
L23_1 = {}
L24_1 = "apex_phone_darkchat_members"
L25_1 = "ax_room"
L26_1 = {}
L27_1 = "room"
L26_1[1] = L27_1
L23_1[1] = L24_1
L23_1[2] = L25_1
L23_1[3] = L26_1
L24_1 = {}
L25_1 = "apex_phone_comments"
L26_1 = "ax_username"
L27_1 = {}
L28_1 = "username"
L27_1[1] = L28_1
L24_1[1] = L25_1
L24_1[2] = L26_1
L24_1[3] = L27_1
L25_1 = {}
L26_1 = "apex_phone_likes"
L27_1 = "ax_username"
L28_1 = {}
L29_1 = "username"
L28_1[1] = L29_1
L25_1[1] = L26_1
L25_1[2] = L27_1
L25_1[3] = L28_1
L26_1 = {}
L27_1 = "apex_phone_services"
L28_1 = "ax_accepted"
L29_1 = {}
L30_1 = "accepted_cid"
L29_1[1] = L30_1
L26_1[1] = L27_1
L26_1[2] = L28_1
L26_1[3] = L29_1
L27_1 = {}
L28_1 = "apex_phone_notifications"
L29_1 = "ax_owner_delivered"
L30_1 = {}
L31_1 = "owner"
L32_1 = "delivered"
L30_1[1] = L31_1
L30_1[2] = L32_1
L27_1[1] = L28_1
L27_1[2] = L29_1
L27_1[3] = L30_1
L28_1 = {}
L29_1 = "apex_phone_messages"
L30_1 = "ax_conversation"
L31_1 = {}
L32_1 = "conversation_id"
L33_1 = "id"
L31_1[1] = L32_1
L31_1[2] = L33_1
L28_1[1] = L29_1
L28_1[2] = L30_1
L28_1[3] = L31_1
L29_1 = {}
L30_1 = "apex_phone_messages"
L31_1 = "ax_reply"
L32_1 = {}
L33_1 = "reply_to"
L32_1[1] = L33_1
L29_1[1] = L30_1
L29_1[2] = L31_1
L29_1[3] = L32_1
L30_1 = {}
L31_1 = "apex_phone_media"
L32_1 = "ax_owner_created"
L33_1 = {}
L34_1 = "owner"
L35_1 = "created"
L33_1[1] = L34_1
L33_1[2] = L35_1
L30_1[1] = L31_1
L30_1[2] = L32_1
L30_1[3] = L33_1
L31_1 = {}
L32_1 = "apex_phone_contacts"
L33_1 = "ax_number"
L34_1 = {}
L35_1 = "number"
L34_1[1] = L35_1
L31_1[1] = L32_1
L31_1[2] = L33_1
L31_1[3] = L34_1
L32_1 = {}
L33_1 = "apex_phone_social_accounts"
L34_1 = "ax_sa_owner"
L35_1 = {}
L36_1 = "owner"
L35_1[1] = L36_1
L32_1[1] = L33_1
L32_1[2] = L34_1
L32_1[3] = L35_1
L33_1 = {}
L34_1 = "apex_phone_services"
L35_1 = "req"
L36_1 = {}
L37_1 = "requester"
L36_1[1] = L37_1
L33_1[1] = L34_1
L33_1[2] = L35_1
L33_1[3] = L36_1
L34_1 = {}
L35_1 = "apex_phone_bills"
L36_1 = "ax_sender_cid"
L37_1 = {}
L38_1 = "sender_cid"
L39_1 = "created"
L37_1[1] = L38_1
L37_1[2] = L39_1
L34_1[1] = L35_1
L34_1[2] = L36_1
L34_1[3] = L37_1
L35_1 = {}
L36_1 = "apex_phone_posts"
L37_1 = "ax_reply_to"
L38_1 = {}
L39_1 = "reply_to"
L38_1[1] = L39_1
L35_1[1] = L36_1
L35_1[2] = L37_1
L35_1[3] = L38_1
L36_1 = {}
L37_1 = "apex_phone_onion_id"
L38_1 = "ax_handle"
L39_1 = {}
L40_1 = "handle"
L39_1[1] = L40_1
L36_1[1] = L37_1
L36_1[2] = L38_1
L36_1[3] = L39_1
L13_1[1] = L14_1
L13_1[2] = L15_1
L13_1[3] = L16_1
L13_1[4] = L17_1
L13_1[5] = L18_1
L13_1[6] = L19_1
L13_1[7] = L20_1
L13_1[8] = L21_1
L13_1[9] = L22_1
L13_1[10] = L23_1
L13_1[11] = L24_1
L13_1[12] = L25_1
L13_1[13] = L26_1
L13_1[14] = L27_1
L13_1[15] = L28_1
L13_1[16] = L29_1
L13_1[17] = L30_1
L13_1[18] = L31_1
L13_1[19] = L32_1
L13_1[20] = L33_1
L13_1[21] = L34_1
L13_1[22] = L35_1
L13_1[23] = L36_1
L14_1 = CreateThread
function L15_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2
  L0_2 = {}
  L1_2 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_accounts` (
            `citizenid` VARCHAR(64) NOT NULL, `account_id` VARCHAR(20) NOT NULL, `username` VARCHAR(32) NOT NULL, `phone` VARCHAR(20) NOT NULL,
            `pin` VARCHAR(100) NOT NULL DEFAULT '1225', `avatar` INT NOT NULL DEFAULT 1, `device_id` VARCHAR(32) NULL, `sim_id` VARCHAR(32) NULL,
            `settings` LONGTEXT NULL, `layout` LONGTEXT NULL, `face` LONGTEXT NULL, `created` BIGINT NOT NULL, `last_seen` BIGINT NULL, `pin_len` TINYINT NULL,
            `avatar_photo` LONGTEXT NULL,
            PRIMARY KEY (`citizenid`), UNIQUE KEY `username` (`username`), UNIQUE KEY `ux_phone` (`phone`))]]
  L2_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_contacts` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `name` VARCHAR(64) NOT NULL, `number` VARCHAR(20) NOT NULL, `avatar` VARCHAR(255) NULL, `favorite` TINYINT NOT NULL DEFAULT 0, `notes` VARCHAR(500) NULL, `avatar_photo` INT NULL, KEY `owner` (`owner`))"
  L3_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_messages` (`id` INT AUTO_INCREMENT PRIMARY KEY, `app` VARCHAR(20) NOT NULL DEFAULT 'sms', `sender` VARCHAR(40) NOT NULL, `receiver` VARCHAR(40) NOT NULL, `type` VARCHAR(16) NOT NULL DEFAULT 'text', `content` TEXT NULL, `payload` LONGTEXT NULL, `read` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, `delivered_at` BIGINT NULL, `read_at` BIGINT NULL, `edited_at` BIGINT NULL, `reply_to` INT NULL, `deleted_sender` TINYINT NOT NULL DEFAULT 0, `deleted_receiver` TINYINT NOT NULL DEFAULT 0, `deleted_all` BIGINT NULL, `conversation_id` INT NULL, KEY `pair` (`app`,`sender`,`receiver`), KEY `recv` (`app`,`receiver`))"
  L4_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_calls` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `number` VARCHAR(20) NOT NULL, `name` VARCHAR(64) NULL, `outgoing` TINYINT NOT NULL DEFAULT 1, `answered` TINYINT NOT NULL DEFAULT 0, `video` TINYINT NOT NULL DEFAULT 0, `duration` INT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, `status` VARCHAR(12) NULL, KEY `owner` (`owner`))"
  L5_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_photos` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `url` LONGTEXT NULL, `seed` INT NULL, `favorite` TINYINT NOT NULL DEFAULT 0, `video` TINYINT NOT NULL DEFAULT 0, `duration` INT NULL, `poster` MEDIUMTEXT NULL, `created` BIGINT NOT NULL, KEY `owner` (`owner`))"
  L6_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_mail` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `sender` VARCHAR(64) NOT NULL, `email` VARCHAR(96) NULL, `subject` VARCHAR(160) NOT NULL, `body` TEXT NULL, `read` TINYINT NOT NULL DEFAULT 0, `folder` VARCHAR(10) NOT NULL DEFAULT 'inbox', `created` BIGINT NOT NULL, `recipient` VARCHAR(64) NULL, `attachments` TEXT NULL, `flagged` TINYINT NOT NULL DEFAULT 0, KEY `owner` (`owner`))"
  L7_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_bills` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `sender` VARCHAR(64) NULL, `sender_name` VARCHAR(64) NOT NULL, `sender_cid` VARCHAR(64) NULL, `society` VARCHAR(50) NULL, `amount` INT NOT NULL, `reason` VARCHAR(160) NULL, `status` VARCHAR(10) NOT NULL DEFAULT 'pending', `created` BIGINT NOT NULL, `paid_at` BIGINT NULL, KEY `owner` (`owner`))"
  L8_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_transactions` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `description` VARCHAR(160) NOT NULL, `amount` INT NOT NULL, `created` BIGINT NOT NULL, KEY `owner` (`owner`))"
  L9_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_social_accounts` (`id` INT AUTO_INCREMENT PRIMARY KEY, `app` VARCHAR(20) NOT NULL, `owner` VARCHAR(64) NOT NULL, `username` VARCHAR(32) NOT NULL, `bio` VARCHAR(160) NULL, `avatar` VARCHAR(255) NULL, `created` BIGINT NOT NULL, `name` VARCHAR(40) NULL, `website` VARCHAR(90) NULL, `private` TINYINT NOT NULL DEFAULT 0, `avatar_url` LONGTEXT NULL, UNIQUE KEY `app_user` (`app`,`username`), KEY `owner` (`app`,`owner`))"
  L10_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_posts` (`id` INT AUTO_INCREMENT PRIMARY KEY, `app` VARCHAR(20) NOT NULL, `author` VARCHAR(32) NOT NULL, `content` TEXT NULL, `image` LONGTEXT NULL, `reply_to` INT NULL, `repost_of` INT NULL, `created` BIGINT NOT NULL, KEY `app` (`app`,`created`), KEY `author` (`author`))"
  L11_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_likes` (`post_id` INT NOT NULL, `username` VARCHAR(32) NOT NULL, PRIMARY KEY (`post_id`,`username`))"
  L12_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_comments` (`id` INT AUTO_INCREMENT PRIMARY KEY, `post_id` INT NOT NULL, `username` VARCHAR(32) NOT NULL, `content` VARCHAR(300) NOT NULL, `created` BIGINT NOT NULL, `parent` INT NULL, KEY `post` (`post_id`))"
  L13_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_follows` (`app` VARCHAR(20) NOT NULL, `follower` VARCHAR(32) NOT NULL, `followed` VARCHAR(32) NOT NULL, PRIMARY KEY (`app`,`follower`,`followed`))"
  L14_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_stories` (`id` INT AUTO_INCREMENT PRIMARY KEY, `app` VARCHAR(20) NOT NULL, `author` VARCHAR(32) NOT NULL, `image` LONGTEXT NULL, `text` VARCHAR(160) NULL, `tx` FLOAT NOT NULL DEFAULT 0.5, `ty` FLOAT NOT NULL DEFAULT 0.5, `tsize` INT NOT NULL DEFAULT 28, `tcolor` VARCHAR(10) NULL, `loc` VARCHAR(40) NULL, `created` BIGINT NOT NULL, `expires` BIGINT NOT NULL, `layers` LONGTEXT NULL, `bg` VARCHAR(20) NULL, `draw` LONGTEXT NULL, `duration` INT NOT NULL DEFAULT 5, `close_friends` TINYINT NOT NULL DEFAULT 0, KEY `live` (`app`,`expires`), KEY `author` (`author`))"
  L15_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_story_views` (`story_id` INT NOT NULL, `username` VARCHAR(32) NOT NULL, `liked` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, PRIMARY KEY (`story_id`,`username`))"
  L16_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_instants` (`id` INT AUTO_INCREMENT PRIMARY KEY, `app` VARCHAR(20) NOT NULL, `author` VARCHAR(32) NOT NULL, `image` LONGTEXT NULL, `text` VARCHAR(160) NULL, `ty` FLOAT NOT NULL DEFAULT 0.8, `tsize` INT NOT NULL DEFAULT 30, `audience` VARCHAR(8) NOT NULL DEFAULT 'close', `ready` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, `expires` BIGINT NOT NULL, KEY `live` (`app`,`expires`), KEY `author` (`author`))"
  L17_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_instant_views` (`instant_id` INT NOT NULL, `username` VARCHAR(32) NOT NULL, `reaction` VARCHAR(16) NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`instant_id`,`username`))"
  L18_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_music` (`citizenid` VARCHAR(64) NOT NULL PRIMARY KEY, `data` LONGTEXT NULL, `updated` BIGINT NULL)"
  L19_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_close_friends` (`app` VARCHAR(20) NOT NULL, `owner` VARCHAR(32) NOT NULL, `friend` VARCHAR(32) NOT NULL, PRIMARY KEY (`app`,`owner`,`friend`))"
  L20_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_comment_likes` (`comment_id` INT NOT NULL, `username` VARCHAR(32) NOT NULL, PRIMARY KEY (`comment_id`,`username`))"
  L21_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_story_answers` (`story_id` INT NOT NULL, `layer` VARCHAR(16) NOT NULL, `username` VARCHAR(32) NOT NULL, `choice` TINYINT NULL, `answer` VARCHAR(200) NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`story_id`,`layer`,`username`))"
  L22_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_saves` (`app` VARCHAR(20) NOT NULL, `username` VARCHAR(32) NOT NULL, `post_id` INT NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`app`,`username`,`post_id`))"
  L23_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_darkchat` (`id` INT AUTO_INCREMENT PRIMARY KEY, `room` VARCHAR(40) NOT NULL, `username` VARCHAR(32) NOT NULL, `content` TEXT NULL, `image` LONGTEXT NULL, `ttl` INT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, KEY `room` (`room`,`created`))"
  L24_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_darkchat_members` (`citizenid` VARCHAR(64) NOT NULL, `room` VARCHAR(40) NOT NULL, `username` VARCHAR(32) NOT NULL, PRIMARY KEY (`citizenid`,`room`))"
  L25_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_onion` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `seller_handle` VARCHAR(32) NOT NULL, `title` VARCHAR(80) NOT NULL, `description` TEXT NULL, `price` DECIMAL(16,6) NOT NULL DEFAULT 0, `stock` INT NOT NULL DEFAULT 1, `category` VARCHAR(30) NOT NULL, `image` LONGTEXT NULL, `created` BIGINT NOT NULL, `kind` VARCHAR(10) NOT NULL DEFAULT 'other', `item_name` VARCHAR(64) NULL, KEY `cat` (`category`,`created`), KEY `owner` (`owner`))"
  L26_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_onion_orders` (`id` INT AUTO_INCREMENT PRIMARY KEY, `listing` INT NULL, `buyer` VARCHAR(64) NOT NULL, `buyer_handle` VARCHAR(32) NOT NULL, `seller` VARCHAR(64) NOT NULL, `seller_handle` VARCHAR(32) NOT NULL, `title` VARCHAR(80) NOT NULL, `price` DECIMAL(16,6) NOT NULL DEFAULT 0, `status` VARCHAR(12) NOT NULL DEFAULT 'pago', `rating` INT NULL, `created` BIGINT NOT NULL, KEY `b` (`buyer`,`created`), KEY `s` (`seller`,`created`))"
  L27_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_onion_id` (`citizenid` VARCHAR(64) NOT NULL PRIMARY KEY, `handle` VARCHAR(32) NOT NULL, `rep` DECIMAL(10,2) NOT NULL DEFAULT 0, `votes` INT NOT NULL DEFAULT 0, `sales` INT NOT NULL DEFAULT 0, `since` BIGINT NOT NULL)"
  L28_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_crypto` (`citizenid` VARCHAR(64) NOT NULL PRIMARY KEY, `bal` DECIMAL(20,8) NOT NULL DEFAULT 0)"
  L29_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_crypto_hist` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `label` VARCHAR(80) NOT NULL, `amount` DECIMAL(20,8) NOT NULL, `created` BIGINT NOT NULL, KEY `o` (`owner`,`created`))"
  L30_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_services` (`id` INT AUTO_INCREMENT PRIMARY KEY, `requester` VARCHAR(64) NOT NULL, `requester_name` VARCHAR(64) NULL, `requester_phone` VARCHAR(20) NULL, `service` VARCHAR(30) NOT NULL, `description` VARCHAR(300) NULL, `coords` VARCHAR(120) NULL, `status` VARCHAR(12) NOT NULL DEFAULT 'pending', `accepted_by` VARCHAR(64) NULL, `accepted_cid` VARCHAR(64) NULL, `created` BIGINT NOT NULL, KEY `svc` (`service`,`status`), KEY `req` (`requester`))"
  L31_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_notifications` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `app` VARCHAR(32) NOT NULL, `title` VARCHAR(80) NOT NULL, `body` VARCHAR(255) NULL, `data` TEXT NULL, `icon` VARCHAR(255) NULL, `image` VARCHAR(255) NULL, `read` TINYINT NOT NULL DEFAULT 0, `delivered` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, `actions` TEXT NULL, `type` VARCHAR(12) NULL, `duration` INT NULL, KEY `owner_created` (`owner`,`created`))"
  L32_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_app_grants` (`owner` VARCHAR(64) NOT NULL, `app` VARCHAR(64) NOT NULL, `perm` VARCHAR(16) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`owner`,`app`,`perm`))"
  L33_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_message_reactions` (`message_id` INT NOT NULL, `who` VARCHAR(40) NOT NULL, `emoji` VARCHAR(16) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`message_id`,`who`))"
  L34_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_thread_meta` (`owner` VARCHAR(40) NOT NULL, `app` VARCHAR(20) NOT NULL, `other` VARCHAR(40) NOT NULL, `pinned` TINYINT NOT NULL DEFAULT 0, `muted_until` BIGINT NULL, `pinned_msg` INT NULL, `cleared_before` INT NULL, PRIMARY KEY (`owner`,`app`,`other`))"
  L35_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_conversations` (`id` INT AUTO_INCREMENT PRIMARY KEY, `app` VARCHAR(20) NOT NULL DEFAULT 'sms', `title` VARCHAR(40) NOT NULL, `avatar` INT NULL, `created_by` VARCHAR(40) NOT NULL, `created` BIGINT NOT NULL, `last_id` INT NULL)"
  L36_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_conversation_members` (`conversation_id` INT NOT NULL, `member` VARCHAR(40) NOT NULL, `role` VARCHAR(8) NOT NULL DEFAULT 'member', `joined` BIGINT NOT NULL, `last_read_id` INT NULL, `left_at` BIGINT NULL, PRIMARY KEY (`conversation_id`,`member`), KEY `member` (`member`))"
  L37_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_media` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `kind` VARCHAR(8) NOT NULL, `mime` VARCHAR(40) NOT NULL, `data` LONGTEXT NULL, `size` INT NOT NULL DEFAULT 0, `duration` INT NULL, `meta` TEXT NULL, `complete` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, KEY `owner` (`owner`))"
  L38_2 = "CREATE TABLE IF NOT EXISTS `apex_phone_blocks` (`owner` VARCHAR(64) NOT NULL, `number` VARCHAR(20) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`owner`,`number`))"
  L0_2[1] = L1_2
  L0_2[2] = L2_2
  L0_2[3] = L3_2
  L0_2[4] = L4_2
  L0_2[5] = L5_2
  L0_2[6] = L6_2
  L0_2[7] = L7_2
  L0_2[8] = L8_2
  L0_2[9] = L9_2
  L0_2[10] = L10_2
  L0_2[11] = L11_2
  L0_2[12] = L12_2
  L0_2[13] = L13_2
  L0_2[14] = L14_2
  L0_2[15] = L15_2
  L0_2[16] = L16_2
  L0_2[17] = L17_2
  L0_2[18] = L18_2
  L0_2[19] = L19_2
  L0_2[20] = L20_2
  L0_2[21] = L21_2
  L0_2[22] = L22_2
  L0_2[23] = L23_2
  L0_2[24] = L24_2
  L0_2[25] = L25_2
  L0_2[26] = L26_2
  L0_2[27] = L27_2
  L0_2[28] = L28_2
  L0_2[29] = L29_2
  L0_2[30] = L30_2
  L0_2[31] = L31_2
  L0_2[32] = L32_2
  L0_2[33] = L33_2
  L0_2[34] = L34_2
  L0_2[35] = L35_2
  L0_2[36] = L36_2
  L0_2[37] = L37_2
  L0_2[38] = L38_2
  L1_2 = 1
  L2_2 = #L0_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = L0_2[L4_2]
    L6_2 = " DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    L5_2 = L5_2 .. L6_2
    L0_2[L4_2] = L5_2
  end
  L1_2 = ipairs
  L2_2 = L0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = pcall
    function L8_2()
      local L0_3, L1_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = L6_2
      L0_3(L1_3)
    end
    L7_2, L8_2 = L7_2(L8_2)
    if not L7_2 then
      L9_2 = print
      L10_2 = "^1[unique_phone]^0 could not create %s (%s)"
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = tostring
      L14_2 = L6_2
      L13_2 = L6_2.match
      L15_2 = "`([%w_]+)`"
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2 = L13_2(L14_2, L15_2)
      L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2)
      L13_2 = tostring
      L14_2 = L8_2
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2 = L13_2(L14_2)
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2)
    end
  end
  L1_2 = SchemaInvalidate
  L1_2()
  L1_2 = 0
  L2_2 = ipairs
  L3_2 = L0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = pcall
    L9_2 = MigrateTable
    L10_2 = L7_2
    L8_2, L9_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L10_2 = L9_2 or L10_2
      if not L9_2 then
        L10_2 = 0
      end
      L1_2 = L1_2 + L10_2
    else
      L10_2 = print
      L11_2 = "^1[unique_phone]^0 migration: "
      L12_2 = tostring
      L13_2 = L9_2
      L12_2 = L12_2(L13_2)
      L11_2 = L11_2 .. L12_2
      L10_2(L11_2)
    end
  end
  if L1_2 > 0 then
    L2_2 = print
    L3_2 = "^2[unique_phone]^0 %d column(s) fixed (database from an earlier version)"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = L1_2
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2 = L3_2(L4_2, L5_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2)
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = MySQL
    L0_3 = L0_3.scalar
    L0_3 = L0_3.await
    L1_3 = "SELECT COUNT(*) FROM apex_phone_photos WHERE url LIKE 'data:%' AND CHAR_LENGTH(url) < 2000"
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L0_3 = 0
    end
    if L0_3 > 0 then
      L1_3 = MySQL
      L1_3 = L1_3.query
      L1_3 = L1_3.await
      L2_3 = "DELETE FROM apex_phone_photos WHERE url LIKE 'data:%' AND CHAR_LENGTH(url) < 2000"
      L1_3(L2_3)
      L1_3 = print
      L2_3 = "^3[unique_phone]^0 %d truncated photo(s) deleted (the url column was too short and cut them off)"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = L0_3
      L2_3, L3_3, L4_3 = L2_3(L3_3, L4_3)
      L1_3(L2_3, L3_3, L4_3)
    end
  end
  L2_2(L3_2)
  L2_2 = pcall
  L3_2 = FW
  L3_2 = L3_2.WidenColumns
  L4_2 = {}
  L5_2 = {}
  L6_2 = "apex_phone_accounts"
  L7_2 = "citizenid"
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L6_2 = {}
  L7_2 = "apex_phone_contacts"
  L8_2 = "owner"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L7_2 = {}
  L8_2 = "apex_phone_calls"
  L9_2 = "owner"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L8_2 = {}
  L9_2 = "apex_phone_photos"
  L10_2 = "owner"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L9_2 = {}
  L10_2 = "apex_phone_mail"
  L11_2 = "owner"
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = {}
  L11_2 = "apex_phone_bills"
  L12_2 = "owner"
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L11_2 = {}
  L12_2 = "apex_phone_bills"
  L13_2 = "sender"
  L14_2 = true
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L12_2 = {}
  L13_2 = "apex_phone_bills"
  L14_2 = "sender_cid"
  L15_2 = true
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L13_2 = {}
  L14_2 = "apex_phone_transactions"
  L15_2 = "owner"
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L14_2 = {}
  L15_2 = "apex_phone_social_accounts"
  L16_2 = "owner"
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L15_2 = {}
  L16_2 = "apex_phone_darkchat_members"
  L17_2 = "citizenid"
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L16_2 = {}
  L17_2 = "apex_phone_services"
  L18_2 = "requester"
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L17_2 = {}
  L18_2 = "apex_phone_services"
  L19_2 = "accepted_cid"
  L20_2 = true
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L18_2 = {}
  L19_2 = "apex_phone_onion"
  L20_2 = "owner"
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L19_2 = {}
  L20_2 = "apex_phone_onion_orders"
  L21_2 = "buyer"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L20_2 = {}
  L21_2 = "apex_phone_onion_orders"
  L22_2 = "seller"
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L21_2 = {}
  L22_2 = "apex_phone_onion_id"
  L23_2 = "citizenid"
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L22_2 = {}
  L23_2 = "apex_phone_crypto"
  L24_2 = "citizenid"
  L22_2[1] = L23_2
  L22_2[2] = L24_2
  L23_2 = {}
  L24_2 = "apex_phone_crypto_hist"
  L25_2 = "owner"
  L23_2[1] = L24_2
  L23_2[2] = L25_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L4_2[6] = L10_2
  L4_2[7] = L11_2
  L4_2[8] = L12_2
  L4_2[9] = L13_2
  L4_2[10] = L14_2
  L4_2[11] = L15_2
  L4_2[12] = L16_2
  L4_2[13] = L17_2
  L4_2[14] = L18_2
  L4_2[15] = L19_2
  L4_2[16] = L20_2
  L4_2[17] = L21_2
  L4_2[18] = L22_2
  L4_2[19] = L23_2
  L2_2(L3_2, L4_2)
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = SchemaColumns
    L1_3 = "apex_phone_accounts"
    L0_3 = L0_3(L1_3)
    L1_3 = L0_3.pin
    L2_3 = nil ~= L1_3
    L3_3 = L0_3.pin_len
    L3_3 = nil ~= L3_3
    return L2_3, L3_3
  end
  L3_2 = pcall
  L4_2 = L2_2
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  if L3_2 and not L4_2 then
    L6_2 = pcall
    function L7_2()
      local L0_3, L1_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "ALTER TABLE `apex_phone_accounts` MODIFY `pin` VARCHAR(100) NOT NULL DEFAULT '1225'"
      L0_3(L1_3)
    end
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L6_2 = SchemaColumnSet
      L7_2 = "apex_phone_accounts"
      L8_2 = "pin"
      L9_2 = "varchar"
      L10_2 = 100
      L6_2(L7_2, L8_2, L9_2, L10_2)
    end
  end
  if L3_2 and not L5_2 then
    L6_2 = pcall
    function L7_2()
      local L0_3, L1_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "ALTER TABLE `apex_phone_accounts` ADD COLUMN `pin_len` TINYINT NULL"
      L0_3(L1_3)
    end
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L6_2 = SchemaColumnSet
      L7_2 = "apex_phone_accounts"
      L8_2 = "pin_len"
      L9_2 = "tinyint"
      L10_2 = nil
      L6_2(L7_2, L8_2, L9_2, L10_2)
    end
  end
  if L3_2 and (not L4_2 or not L5_2) then
    L6_2 = pcall
    L7_2 = L2_2
    L6_2, L7_2, L8_2 = L6_2(L7_2)
    L5_2 = L8_2
    L4_2 = L7_2
    L3_2 = L6_2
  end
  L6_2 = L3_2 or L6_2
  L6_2 = L3_2 and true == L4_2 and true == L5_2
  L3_1 = L6_2
  L6_2 = L3_1
  if not L6_2 then
    L6_2 = print
    L7_2 = "^1[unique_phone]^0 the apex_phone_accounts.pin column does not accept the hash (needs VARCHAR(100) and the pin_len column): codes stay in PLAIN TEXT until this is fixed in the database"
    L6_2(L7_2)
  end
  DBReady = true
  L6_2 = print
  L7_2 = "^2[unique_phone]^0 database ready"
  L6_2(L7_2)
  L6_2 = 0
  L7_2 = ipairs
  L8_2 = L13_1
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = pcall
    L14_2 = EnsureIndex
    L15_2 = L12_2[1]
    L16_2 = L12_2[2]
    L17_2 = L12_2[3]
    L18_2 = L12_2[4]
    L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
    if L13_2 and "created" == L14_2 then
      L6_2 = L6_2 + 1
    end
  end
  if L6_2 > 0 then
    L7_2 = print
    L8_2 = "^2[unique_phone]^0 %d index(es) created (database from an earlier version)"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2 = L8_2(L9_2, L10_2)
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2)
  end
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = [[
SELECT TABLE_NAME AS tname, TABLE_COLLATION AS tcoll, TABLE_ROWS AS trows FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME LIKE 'apex\_phone\_%'
              AND TABLE_COLLATION IS NOT NULL AND TABLE_COLLATION NOT LIKE 'utf8mb4%' ORDER BY TABLE_NAME]]
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = #L0_3
    if 0 == L1_3 then
      return
    end
    L1_3 = 0
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L0_3
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = tostring
      L10_3 = L8_3.tname
      if not L10_3 then
        L10_3 = L8_3.TNAME
        if not L10_3 then
          L10_3 = ""
        end
      end
      L9_3 = L9_3(L10_3)
      L10_3 = tonumber
      L11_3 = L8_3.trows
      if not L11_3 then
        L11_3 = L8_3.TROWS
      end
      L10_3 = L10_3(L11_3)
      if not L10_3 then
        L10_3 = 0
      end
      L11_3 = false
      L13_3 = L9_3
      L12_3 = L9_3.match
      L14_3 = "^apex_phone_[%w_]+$"
      L12_3 = L12_3(L13_3, L14_3)
      if L12_3 then
        L12_3 = 5000
        if L10_3 <= L12_3 then
          L12_3 = pcall
          function L13_3()
            local L0_4, L1_4, L2_4, L3_4
            L0_4 = MySQL
            L0_4 = L0_4.query
            L0_4 = L0_4.await
            L1_4 = "ALTER TABLE `%s` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
            L2_4 = L1_4
            L1_4 = L1_4.format
            L3_4 = L9_3
            L1_4, L2_4, L3_4 = L1_4(L2_4, L3_4)
            L0_4(L1_4, L2_4, L3_4)
          end
          L12_3 = L12_3(L13_3)
          L11_3 = L12_3
        end
      end
      if L11_3 then
        L1_3 = L1_3 + 1
      else
        L12_3 = #L2_3
        L12_3 = L12_3 + 1
        L2_3[L12_3] = L8_3
      end
    end
    if L1_3 > 0 then
      L3_3 = print
      L4_3 = "^2[unique_phone]^0 %d table(s) converted to utf8mb4 (they were created by an earlier version in another charset: accents and emojis are saved again)"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = L1_3
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3 = L4_3(L5_3, L6_3)
      L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
    end
    L3_3 = #L2_3
    if 0 == L3_3 then
      return
    end
    L3_3 = print
    L4_3 = "^3[unique_phone]^0 %d phone table(s) are NOT in utf8mb4: accented characters get mangled and emojis are rejected or stored as garbage."
    L5_3 = L4_3
    L4_3 = L4_3.format
    L6_3 = #L2_3
    L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3 = L4_3(L5_3, L6_3)
    L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
    L3_3 = print
    L4_3 = "^3[unique_phone]^0 convert them while the server is empty (each statement REWRITES the whole table and can take minutes on a large table, so we do not do it automatically):"
    L3_3(L4_3)
    L3_3 = ipairs
    L4_3 = L2_3
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = print
      L10_3 = "^3[unique_phone]^0   ALTER TABLE `%s` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;   -- currently %s"
      L11_3 = L10_3
      L10_3 = L10_3.format
      L12_3 = tostring
      L13_3 = L8_3.tname
      if not L13_3 then
        L13_3 = L8_3.TNAME
        if not L13_3 then
          L13_3 = "?"
        end
      end
      L12_3 = L12_3(L13_3)
      L13_3 = tostring
      L14_3 = L8_3.tcoll
      if not L14_3 then
        L14_3 = L8_3.TCOLL
        if not L14_3 then
          L14_3 = "?"
        end
      end
      L13_3, L14_3 = L13_3(L14_3)
      L10_3, L11_3, L12_3, L13_3, L14_3 = L10_3(L11_3, L12_3, L13_3, L14_3)
      L9_3(L10_3, L11_3, L12_3, L13_3, L14_3)
    end
  end
  L7_2(L8_2)
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = [[
SELECT TABLE_NAME AS tname, TABLE_COLLATION AS tcoll, TABLE_ROWS AS trows FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME LIKE 'apex\_phone\_%'
              AND TABLE_COLLATION LIKE 'utf8mb4%' AND TABLE_COLLATION <> 'utf8mb4_unicode_ci' ORDER BY TABLE_NAME]]
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = #L0_3
    if 0 == L1_3 then
      return
    end
    L1_3 = 0
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L0_3
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = tostring
      L10_3 = L8_3.tname
      if not L10_3 then
        L10_3 = L8_3.TNAME
        if not L10_3 then
          L10_3 = ""
        end
      end
      L9_3 = L9_3(L10_3)
      L10_3 = tonumber
      L11_3 = L8_3.trows
      if not L11_3 then
        L11_3 = L8_3.TROWS
      end
      L10_3 = L10_3(L11_3)
      if not L10_3 then
        L10_3 = 0
      end
      L12_3 = L9_3
      L11_3 = L9_3.match
      L13_3 = "^apex_phone_[%w_]+$"
      L11_3 = L11_3(L12_3, L13_3)
      if L11_3 then
        L11_3 = 5000
        if L10_3 <= L11_3 then
          L11_3 = pcall
          function L12_3()
            local L0_4, L1_4, L2_4, L3_4
            L0_4 = MySQL
            L0_4 = L0_4.query
            L0_4 = L0_4.await
            L1_4 = "ALTER TABLE `%s` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
            L2_4 = L1_4
            L1_4 = L1_4.format
            L3_4 = L9_3
            L1_4, L2_4, L3_4 = L1_4(L2_4, L3_4)
            L0_4(L1_4, L2_4, L3_4)
          end
          L11_3 = L11_3(L12_3)
          if L11_3 then
            L1_3 = L1_3 + 1
          else
            L12_3 = #L2_3
            L12_3 = L12_3 + 1
            L2_3[L12_3] = L8_3
          end
      end
      else
        L11_3 = #L2_3
        L11_3 = L11_3 + 1
        L2_3[L11_3] = L8_3
      end
    end
    if L1_3 > 0 then
      L3_3 = print
      L4_3 = "^2[unique_phone]^0 %d table(s) converted to utf8mb4_unicode_ci (collation from an earlier version; JOINs between tables work again)"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = L1_3
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L4_3(L5_3, L6_3)
      L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
    end
    L3_3 = #L2_3
    if L3_3 > 0 then
      L3_3 = print
      L4_3 = "^3[unique_phone]^0 %d large table(s) with a different collation (JOINs between tables may fail with \"Illegal mix of collations\"); convert them while the server is empty:"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = #L2_3
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L4_3(L5_3, L6_3)
      L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
      L3_3 = ipairs
      L4_3 = L2_3
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
      for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
        L9_3 = print
        L10_3 = "^3[unique_phone]^0   ALTER TABLE `%s` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;   -- currently %s, ~%s rows"
        L11_3 = L10_3
        L10_3 = L10_3.format
        L12_3 = tostring
        L13_3 = L8_3.tname
        if not L13_3 then
          L13_3 = L8_3.TNAME
          if not L13_3 then
            L13_3 = "?"
          end
        end
        L12_3 = L12_3(L13_3)
        L13_3 = tostring
        L14_3 = L8_3.tcoll
        if not L14_3 then
          L14_3 = L8_3.TCOLL
          if not L14_3 then
            L14_3 = "?"
          end
        end
        L13_3 = L13_3(L14_3)
        L14_3 = tostring
        L15_3 = L8_3.trows
        if not L15_3 then
          L15_3 = L8_3.TROWS
          if not L15_3 then
            L15_3 = "?"
          end
        end
        L14_3, L15_3 = L14_3(L15_3)
        L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L10_3(L11_3, L12_3, L13_3, L14_3, L15_3)
        L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
      end
    end
  end
  L7_2(L8_2)
end
L14_1(L15_1)
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = TriggerClientEvent
  L4_2 = "apex_phone:client:push"
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = A2_2
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
Push = L14_1
L14_1 = {}
L14_1.banner = true
L14_1.silent = true
L14_1.island = true
L14_1.lock = true
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if nil == A0_2 then
    L2_2 = nil
    return L2_2
  end
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
  L3_2 = #A0_2
  if A1_2 >= L3_2 then
    return A0_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.sub
  L5_2 = 1
  L6_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L3_2 = 1
  L4_2 = 3
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = utf8
    L7_2 = L7_2.len
    L8_2 = A0_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      break
    end
    L8_2 = A0_2
    L7_2 = A0_2.sub
    L9_2 = 1
    L10_2 = -2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    A0_2 = L7_2
  end
  return A0_2
end
function L16_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L5_2 = type
  L6_2 = A4_2
  L5_2 = L5_2(L6_2)
  if "table" ~= L5_2 or not A4_2 then
    L5_2 = {}
    A4_2 = L5_2
  end
  L5_2 = {}
  L6_2 = L15_1
  L7_2 = A0_2
  L8_2 = 32
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = "settings"
  end
  L5_2.app = L6_2
  L6_2 = L15_1
  L7_2 = A1_2
  L8_2 = 80
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = ""
  end
  L5_2.title = L6_2
  L6_2 = L15_1
  L7_2 = A2_2
  L8_2 = 255
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = ""
  end
  L5_2.msg = L6_2
  L6_2 = L15_1
  L7_2 = A4_2.description
  L8_2 = 255
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.description = L6_2
  if nil ~= A3_2 then
    L6_2 = type
    L7_2 = A3_2
    L6_2 = L6_2(L7_2)
    if "function" ~= L6_2 and A3_2 then
      goto lbl_52
      L6_2 = A3_2 or L6_2
    end
  end
  L6_2 = nil
  ::lbl_52::
  L5_2.data = L6_2
  L6_2 = L15_1
  L7_2 = A4_2.icon
  L8_2 = 2048
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.icon = L6_2
  L6_2 = L15_1
  L7_2 = A4_2.image
  L8_2 = 2048
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.image = L6_2
  L7_2 = A4_2.type
  L6_2 = L14_1
  L6_2 = L6_2[L7_2]
  if L6_2 then
    L6_2 = A4_2.type
    if L6_2 then
      goto lbl_72
    end
  end
  L6_2 = nil
  ::lbl_72::
  L5_2.type = L6_2
  L6_2 = tonumber
  L7_2 = A4_2.duration
  L6_2 = L6_2(L7_2)
  if L6_2 and L6_2 > 0 then
    L7_2 = math
    L7_2 = L7_2.floor
    L8_2 = math
    L8_2 = L8_2.min
    L9_2 = L6_2
    L10_2 = 120000
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L8_2(L9_2, L10_2)
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    L5_2.duration = L7_2
  end
  L7_2 = type
  L8_2 = A4_2.actions
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = {}
    L8_2 = ipairs
    L9_2 = A4_2.actions
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = type
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      L14_2 = L15_1
      L15_2 = L13_2.id
      L16_2 = 32
      L14_2 = "table" == L14_2 and L14_2
      L15_2 = type
      L16_2 = L13_2
      L15_2 = L15_2(L16_2)
      L15_2 = L15_1
      L16_2 = L13_2.label
      L17_2 = 40
      L15_2 = "table" == L15_2 and L15_2
      if L14_2 and L15_2 then
        L16_2 = #L7_2
        L16_2 = L16_2 + 1
        L17_2 = {}
        L17_2.id = L14_2
        L17_2.label = L15_2
        L7_2[L16_2] = L17_2
      end
      L16_2 = #L7_2
      if L16_2 >= 3 then
        break
      end
    end
    L8_2 = #L7_2
    if L8_2 > 0 then
      L5_2.actions = L7_2
    end
  end
  return L5_2
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_24
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_24::
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    L10_2 = L15_1
    L11_2 = L9_2.id
    L12_2 = 32
    L10_2 = "table" == L10_2 and L10_2
    L11_2 = type
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    L11_2 = L15_1
    L12_2 = L9_2.label
    L13_2 = 40
    L11_2 = "table" == L11_2 and L11_2
    if L10_2 and L11_2 then
      L12_2 = #L3_2
      L12_2 = L12_2 + 1
      L13_2 = {}
      L13_2.id = L10_2
      L13_2.label = L11_2
      L3_2[L12_2] = L13_2
    end
    L12_2 = #L3_2
    if L12_2 >= 3 then
      break
    end
  end
  L4_2 = #L3_2
  L4_2 = L3_2 or L4_2
  if not (L4_2 > 0) or not L3_2 then
    L4_2 = nil
  end
  return L4_2
end
function L18_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = nil
  L4_2 = A1_2.data
  if L4_2 then
    L4_2 = pcall
    L5_2 = json
    L5_2 = L5_2.encode
    L6_2 = A1_2.data
    L4_2, L5_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L6_2 = type
      L7_2 = L5_2
      L6_2 = L6_2(L7_2)
      if "string" == L6_2 then
        L6_2 = #L5_2
        L7_2 = 2000
        if L6_2 <= L7_2 then
          L3_2 = L5_2
        end
      end
    end
  end
  L4_2 = nil
  L5_2 = A1_2.actions
  if L5_2 then
    L5_2 = pcall
    L6_2 = json
    L6_2 = L6_2.encode
    L7_2 = A1_2.actions
    L5_2, L6_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      L7_2 = type
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      if "string" == L7_2 then
        L7_2 = #L6_2
        L8_2 = 1000
        if L7_2 <= L8_2 then
          L4_2 = L6_2
        end
      end
    end
  end
  L5_2 = Now
  L5_2 = L5_2()
  A1_2.created = L5_2
  L5_2 = A1_2.icon
  if L5_2 then
    L5_2 = A1_2.icon
    L5_2 = #L5_2
    L6_2 = 255
    if L5_2 <= L6_2 then
      L5_2 = A1_2.icon
      if L5_2 then
        goto lbl_58
      end
    end
  end
  L5_2 = nil
  ::lbl_58::
  L6_2 = A1_2.image
  if L6_2 then
    L6_2 = A1_2.image
    L6_2 = #L6_2
    L7_2 = 255
    if L6_2 <= L7_2 then
      L6_2 = A1_2.image
      if L6_2 then
        goto lbl_70
      end
    end
  end
  L6_2 = nil
  ::lbl_70::
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L0_3 = MySQL
    L0_3 = L0_3.insert
    L0_3 = L0_3.await
    L1_3 = "INSERT INTO apex_phone_notifications (owner, app, title, body, data, icon, image, actions, `type`, duration, `read`, delivered, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, ?)"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = A1_2.app
    L5_3 = A1_2.title
    L6_3 = A1_2.msg
    if "" ~= L6_3 then
      L6_3 = A1_2.msg
      if L6_3 then
        goto lbl_17
      end
    end
    L6_3 = A1_2.description
    ::lbl_17::
    L7_3 = L3_2
    L8_3 = L5_2
    L9_3 = L6_2
    L10_3 = L4_2
    L11_3 = A1_2.type
    L12_3 = A1_2.duration
    L13_3 = A2_2
    L14_3 = A1_2.created
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L2_3[5] = L7_3
    L2_3[6] = L8_3
    L2_3[7] = L9_3
    L2_3[8] = L10_3
    L2_3[9] = L11_3
    L2_3[10] = L12_3
    L2_3[11] = L13_3
    L2_3[12] = L14_3
    return L0_3(L1_3, L2_3)
  end
  L7_2, L8_2 = L7_2(L8_2)
  if not L7_2 then
    L9_2 = print
    L10_2 = "^1[unique_phone]^0 notification not saved (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = tostring
    L13_2 = L8_2
    L12_2, L13_2 = L12_2(L13_2)
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2)
    L9_2(L10_2, L11_2, L12_2, L13_2)
    L9_2 = nil
    return L9_2
  end
  L9_2 = tonumber
  L10_2 = L8_2
  return L9_2(L10_2)
end
function L19_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L5_2 = type
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = A0_2
    L6_2 = L5_2.app
    L7_2 = L5_2.title
    L8_2 = L5_2.msg
    if not L8_2 then
      L8_2 = L5_2.description
    end
    L9_2 = L5_2.data
    L10_2 = L5_2
    return L6_2, L7_2, L8_2, L9_2, L10_2
  end
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = A2_2
  L8_2 = A3_2
  L9_2 = A4_2
  return L5_2, L6_2, L7_2, L8_2, L9_2
end
function L20_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L6_2 = L19_1
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L10_2 = A4_2
  L11_2 = A5_2
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  A5_2 = L10_2
  A4_2 = L9_2
  A3_2 = L8_2
  A2_2 = L7_2
  A1_2 = L6_2
  L6_2 = tonumber
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  A0_2 = L6_2
  if not A0_2 or A0_2 <= 0 then
    return
  end
  L6_2 = L16_1
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L10_2 = A4_2
  L11_2 = A5_2
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = type
  L8_2 = A5_2
  L7_2 = L7_2(L8_2)
  L7_2 = "table" ~= L7_2
  if L7_2 then
    L8_2 = GetCid
    L9_2 = A0_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      goto lbl_47
    end
  end
  L8_2 = nil
  ::lbl_47::
  if L8_2 then
    L9_2 = DeviceNotifyTarget
    if L9_2 then
      L9_2 = DeviceNotifyTarget
      L10_2 = A0_2
      L11_2 = A5_2
      L9_2 = L9_2(L10_2, L11_2)
      if L9_2 then
        L10_2 = Dbg
        L11_2 = "notif"
        L12_2 = "src=%s in another session: \"%s\" stays pending for %s"
        L13_2 = A0_2
        L14_2 = L6_2.title
        L15_2 = L9_2
        L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
        L10_2 = DBReady
        if L10_2 then
          L10_2 = CreateThread
          function L11_2()
            local L0_3, L1_3, L2_3, L3_3
            L0_3 = L18_1
            L1_3 = L9_2
            L2_3 = L6_2
            L3_3 = 0
            L0_3(L1_3, L2_3, L3_3)
          end
          L10_2(L11_2)
        end
        return
      end
    end
  end
  L9_2 = Dbg
  L10_2 = "notif"
  L11_2 = "src=%s app=%s \"%s\"%s"
  L12_2 = A0_2
  L13_2 = L6_2.app
  L14_2 = L6_2.title
  if L8_2 then
    L15_2 = ""
    if L15_2 then
      goto lbl_85
    end
  end
  L15_2 = " (not saved)"
  ::lbl_85::
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  if L8_2 then
    L9_2 = DBReady
    if L9_2 then
      goto lbl_97
    end
  end
  L9_2 = Push
  L10_2 = A0_2
  L11_2 = "notification"
  L12_2 = L6_2
  L9_2(L10_2, L11_2, L12_2)
  do return end
  ::lbl_97::
  L9_2 = CreateThread
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = L18_1
    L1_3 = L8_2
    L2_3 = L6_2
    L3_3 = 1
    L0_3 = L0_3(L1_3, L2_3, L3_3)
    L6_2.id = L0_3
    L0_3 = Push
    L1_3 = A0_2
    L2_3 = "notification"
    L3_3 = L6_2
    L0_3(L1_3, L2_3, L3_3)
  end
  L9_2(L10_2)
end
NotifyPlayer = L20_1
L20_1 = {}
L21_1 = 0
L22_1 = {}
L22_1.billing = true
L22_1.marketplace = true
L22_1.onion = true
L22_1.crypto = true
L22_1.eats = true
L23_1 = nil
function L24_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = L23_1
  if L0_2 then
    L0_2 = L23_1
    return L0_2
  end
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.NotifyThrottle
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.NotifyThrottle
    L0_2 = L0_2.noThrottleApps
    if L0_2 then
      goto lbl_18
    end
  end
  L0_2 = nil
  ::lbl_18::
  if nil == L0_2 then
    L1_2 = L22_1
    L23_1 = L1_2
    L1_2 = L23_1
    return L1_2
  end
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = print
    L2_2 = "^3[unique_phone]^0 Config.NotifyThrottle.noThrottleApps must be a list or a map \226\128\148 using the default list"
    L1_2(L2_2)
    L1_2 = L22_1
    L23_1 = L1_2
    L1_2 = L23_1
    return L1_2
  end
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L6_2
    L8_2 = L8_2(L9_2)
    if "string" == L8_2 and L7_2 then
      L1_2[L6_2] = true
    end
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "string" == L8_2 then
      L1_2[L7_2] = true
    end
  end
  L23_1 = L1_2
  return L1_2
end
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = Config
  L3_2 = L3_2.NotifyThrottle
  if false == L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 or not L3_2 then
    L4_2 = {}
    L3_2 = L4_2
  end
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A2_2.throttle
    if false == L4_2 then
      L4_2 = false
      return L4_2
    end
  end
  L4_2 = L24_1
  L4_2 = L4_2()
  L5_2 = A1_2.app
  L4_2 = L4_2[L5_2]
  if L4_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.max
  L5_2 = 0
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = tonumber
  L8_2 = L3_2.seconds
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 60
  end
  L6_2 = L6_2(L7_2)
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = math
  L5_2 = L5_2.max
  L6_2 = 0
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = tonumber
  L9_2 = L3_2.max
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 4
  end
  L7_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2)
  if L4_2 <= 0 or L5_2 <= 0 then
    L6_2 = false
    return L6_2
  end
  L6_2 = os
  L6_2 = L6_2.time
  L6_2 = L6_2()
  L7_2 = L21_1
  L7_2 = L6_2 - L7_2
  if L7_2 > 120 then
    L21_1 = L6_2
    L7_2 = pairs
    L8_2 = L20_1
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = L12_2.t
      L13_2 = L6_2 - L13_2
      if L4_2 <= L13_2 then
        L13_2 = L20_1
        L13_2[L11_2] = nil
      end
    end
  end
  L7_2 = A0_2
  L8_2 = "|"
  L9_2 = tostring
  L10_2 = A1_2.app
  L9_2 = L9_2(L10_2)
  L10_2 = "|"
  L11_2 = tostring
  L12_2 = type
  L13_2 = A2_2
  L12_2 = L12_2(L13_2)
  if "table" == L12_2 then
    L12_2 = A2_2.throttleKey
    if L12_2 then
      goto lbl_106
    end
  end
  L12_2 = A1_2.title
  ::lbl_106::
  L11_2 = L11_2(L12_2)
  L7_2 = L7_2 .. L8_2 .. L9_2 .. L10_2 .. L11_2
  L8_2 = L20_1
  L8_2 = L8_2[L7_2]
  if L8_2 then
    L9_2 = L8_2.t
    L9_2 = L6_2 - L9_2
    if not (L4_2 <= L9_2) then
      goto lbl_125
    end
  end
  L9_2 = L20_1
  L10_2 = {}
  L10_2.n = 1
  L10_2.t = L6_2
  L9_2[L7_2] = L10_2
  L9_2 = false
  do return L9_2 end
  ::lbl_125::
  L9_2 = L8_2.n
  L9_2 = L9_2 + 1
  L8_2.n = L9_2
  L9_2 = L8_2.n
  if L5_2 >= L9_2 then
    L9_2 = false
    return L9_2
  end
  L9_2 = Dbg
  L10_2 = "notif"
  L11_2 = "throttle: %s \"%s\" for %s (%d in the %ds window)"
  L12_2 = tostring
  L13_2 = A1_2.app
  L12_2 = L12_2(L13_2)
  L13_2 = tostring
  L14_2 = A1_2.title
  L13_2 = L13_2(L14_2)
  L14_2 = A0_2
  L15_2 = L8_2.n
  L16_2 = L4_2
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L9_2 = true
  return L9_2
end
function L26_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L6_2 = L19_1
  L7_2 = A1_2
  L8_2 = A2_2
  L9_2 = A3_2
  L10_2 = A4_2
  L11_2 = A5_2
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  A5_2 = L10_2
  A4_2 = L9_2
  A3_2 = L8_2
  A2_2 = L7_2
  A1_2 = L6_2
  if not A0_2 or "" == A0_2 then
    return
  end
  L6_2 = tostring
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  A0_2 = L6_2
  L6_2 = L25_1
  L7_2 = A0_2
  L8_2 = L16_1
  L9_2 = A1_2
  L10_2 = A2_2
  L11_2 = A3_2
  L12_2 = A4_2
  L13_2 = A5_2
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  L9_2 = A5_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if L6_2 then
    return
  end
  L6_2 = FW
  L6_2 = L6_2.GetPlayerByCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = DeviceHolderByCid
  if L7_2 then
    L7_2 = DeviceHolderByCid
    L8_2 = A0_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L8_2 = {}
      L8_2.src = L7_2
      L6_2 = L8_2
    end
  end
  if L6_2 then
    L7_2 = L6_2.src
    if L7_2 then
      L7_2 = {}
      L8_2 = type
      L9_2 = A5_2
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L8_2 = pairs
        L9_2 = A5_2
        L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
        for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
          L7_2[L12_2] = L13_2
        end
      end
      L7_2.persist = true
      L8_2 = DeviceNotifyTarget
      if L8_2 then
        L7_2.__cid = A0_2
      end
      L8_2 = NotifyPlayer
      L9_2 = L6_2.src
      L10_2 = A1_2
      L11_2 = A2_2
      L12_2 = A3_2
      L13_2 = A4_2
      L14_2 = L7_2
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      return
    end
  end
  L7_2 = L16_1
  L8_2 = A1_2
  L9_2 = A2_2
  L10_2 = A3_2
  L11_2 = A4_2
  L12_2 = A5_2
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L8_2 = Dbg
  L9_2 = "notif"
  L10_2 = "offline cid=%s app=%s \"%s\" (kept for when they join)"
  L11_2 = A0_2
  L12_2 = L7_2.app
  L13_2 = L7_2.title
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  L8_2 = CreateThread
  function L9_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = 0
    while true do
      L1_3 = DBReady
      if not (not L1_3 and L0_3 < 60) then
        break
      end
      L1_3 = Wait
      L2_3 = 1000
      L1_3(L2_3)
      L0_3 = L0_3 + 1
    end
    L1_3 = DBReady
    if L1_3 then
      L1_3 = L18_1
      L2_3 = A0_2
      L3_3 = L7_2
      L4_3 = 0
      L1_3(L2_3, L3_3, L4_3)
    end
  end
  L8_2(L9_2)
end
NotifyCitizen = L26_1
L26_1 = {}
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = A0_2 or L1_2
  if A0_2 then
    L1_2 = GetCid
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
  end
  if L1_2 then
    L2_2 = L26_1
    L2_2 = L2_2[L1_2]
    if not L2_2 then
      L2_2 = DBReady
      if L2_2 then
        goto lbl_20
      end
    end
  end
  do return end
  ::lbl_20::
  L2_2 = L26_1
  L2_2[L1_2] = true
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT id, app, title, body, data, icon, image, actions, `type`, duration, created FROM apex_phone_notifications WHERE owner = ? AND delivered = 0 ORDER BY id DESC LIMIT 50"
    L2_3 = {}
    L3_3 = L1_2
    L2_3[1] = L3_3
    L0_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = #L0_3
    if 0 == L1_3 then
      return
    end
    L1_3 = MySQL
    L1_3 = L1_3.update
    L1_3 = L1_3.await
    L2_3 = "UPDATE apex_phone_notifications SET delivered = 1 WHERE owner = ? AND delivered = 0 AND id <= ?"
    L3_3 = {}
    L4_3 = L1_2
    L5_3 = L0_3[1]
    L5_3 = L5_3.id
    L3_3[1] = L4_3
    L3_3[2] = L5_3
    L1_3(L2_3, L3_3)
    L1_3 = #L0_3
    L2_3 = 1
    L3_3 = -1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = L0_3[L4_3]
      L6_3 = pcall
      L7_3 = json
      L7_3 = L7_3.decode
      L8_3 = L5_3.data
      if not L8_3 then
        L8_3 = "null"
      end
      L6_3, L7_3 = L6_3(L7_3, L8_3)
      L8_3 = math
      L8_3 = L8_3.tointeger
      L9_3 = tonumber
      L10_3 = L5_3.duration
      L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L9_3(L10_3)
      L8_3 = L8_3(L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
      L9_3 = Push
      L10_3 = A0_2
      L11_3 = "notification"
      L12_3 = {}
      L13_3 = tonumber
      L14_3 = L5_3.id
      L13_3 = L13_3(L14_3)
      L12_3.id = L13_3
      L13_3 = L5_3.app
      L12_3.app = L13_3
      L13_3 = L5_3.title
      L12_3.title = L13_3
      L13_3 = L5_3.body
      if not L13_3 then
        L13_3 = ""
      end
      L12_3.msg = L13_3
      L13_3 = L5_3.icon
      L12_3.icon = L13_3
      L13_3 = L5_3.image
      L12_3.image = L13_3
      L13_3 = L7_3 or L13_3
      if not L6_3 or not L7_3 then
        L13_3 = nil
      end
      L12_3.data = L13_3
      L13_3 = tonumber
      L14_3 = L5_3.created
      L13_3 = L13_3(L14_3)
      L12_3.created = L13_3
      L13_3 = L17_1
      L14_3 = L5_3.actions
      L13_3 = L13_3(L14_3)
      L12_3.actions = L13_3
      if L8_3 and L8_3 > 0 then
        L13_3 = math
        L13_3 = L13_3.min
        L14_3 = L8_3
        L15_3 = 120000
        L13_3 = L13_3(L14_3, L15_3)
        if L13_3 then
          goto lbl_96
        end
      end
      L13_3 = nil
      ::lbl_96::
      L12_3.duration = L13_3
      if L4_3 > 3 then
        L13_3 = "silent"
        if L13_3 then
          goto lbl_111
        end
      end
      L14_3 = L5_3.type
      L13_3 = L14_1
      L13_3 = L13_3[L14_3]
      if L13_3 then
        L13_3 = L5_3.type
        if L13_3 then
          goto lbl_111
        end
      end
      L13_3 = nil
      ::lbl_111::
      L12_3.type = L13_3
      L9_3(L10_3, L11_3, L12_3)
    end
    L1_3 = Dbg
    L2_3 = "notif"
    L3_3 = "%d pending notification(s) delivered to %s"
    L4_3 = #L0_3
    L5_3 = L1_2
    L1_3(L2_3, L3_3, L4_3, L5_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L26_1
  L4_2[L1_2] = nil
  if not L2_2 then
    L4_2 = print
    L5_2 = "^1[unique_phone]^0 delivery of pending notifications: %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
end
DeliverPendingNotifications = L27_1
function L27_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  if not A0_2 or A0_2 <= 0 then
    return
  end
  L2_2 = InvalidateOnlineIndex
  if L2_2 then
    L2_2 = InvalidateOnlineIndex
    L2_2()
  end
  if not A1_2 then
    L2_2 = GetPlayerNumber
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    A1_2 = L2_2
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
SyncPhoneNumberState = L27_1
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = Config
  L1_2 = L1_2.RequireItem
  if not L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 or A0_2 <= 0 then
    L1_2 = false
    return L1_2
  end
  L1_2 = FW
  L1_2 = L1_2.InventoryName
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = {}
  L2_2 = pairs
  L3_2 = Config
  L3_2 = L3_2.Devices
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = L6_2
  end
  L2_2 = Config
  L2_2 = L2_2.PhoneItem
  if L2_2 then
    L2_2 = Config
    L2_2 = L2_2.PhoneItem
    if "" ~= L2_2 then
      L2_2 = #L1_2
      L2_2 = L2_2 + 1
      L3_2 = Config
      L3_2 = L3_2.PhoneItem
      L1_2[L2_2] = L3_2
    end
  end
  L2_2 = FW
  L2_2 = L2_2.HasAnyItem
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.HasAnyItem
    L3_2 = A0_2
    L4_2 = L1_2
    return L2_2(L3_2, L4_2)
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = FW
    L8_2 = L8_2.HasItem
    L9_2 = A0_2
    L10_2 = L7_2
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = 0
    end
    if L8_2 > 0 then
      L8_2 = true
      return L8_2
    end
  end
  L2_2 = false
  return L2_2
end
HasPhoneItem = L27_1
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = DeviceSessions
  if L1_2 and A0_2 then
    L2_2 = L1_2[A0_2]
    if not L2_2 then
      L2_2 = tonumber
      L3_2 = A0_2
      L2_2 = L2_2(L3_2)
      L2_2 = L1_2[L2_2]
    end
    if L2_2 then
      L3_2 = L2_2.cid
      return L3_2
    end
  end
  L2_2 = FW
  L2_2 = L2_2.GetCidPhone
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L3_2 or L4_2
  if not L2_2 or not L3_2 then
    L4_2 = nil
  end
  return L4_2
end
GetCid = L27_1
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = DeviceSessions
  if L1_2 and A0_2 then
    L2_2 = L1_2[A0_2]
    if not L2_2 then
      L2_2 = tonumber
      L3_2 = A0_2
      L2_2 = L2_2(L3_2)
      L2_2 = L1_2[L2_2]
    end
    if L2_2 then
      L3_2 = Accounts
      L4_2 = L2_2.cid
      L3_2 = L3_2[L4_2]
      if L3_2 then
        L4_2 = L3_2.phone
        if L4_2 then
          goto lbl_24
        end
      end
      L4_2 = L2_2.number
      ::lbl_24::
      return L4_2
    end
  end
  L2_2 = FW
  L2_2 = L2_2.GetCidPhone
  L3_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2)
  if not L2_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L3_2 or L5_2
  if L3_2 then
    L5_2 = Accounts
    L5_2 = L5_2[L3_2]
  end
  if L5_2 then
    L6_2 = L5_2.phone
    if L6_2 then
      goto lbl_43
    end
  end
  L6_2 = L4_2
  ::lbl_43::
  return L6_2
end
GetPlayerNumber = L27_1
L27_1 = 2000
L28_1 = nil
L29_1 = 0
L30_1 = nil
L31_1 = 0
L32_1 = 0
function L33_1()
  local L0_2, L1_2
  L0_2 = nil
  L1_2 = nil
  L30_1 = L1_2
  L28_1 = L0_2
  L0_2 = L32_1
  L0_2 = L0_2 + 1
  L32_1 = L0_2
end
InvalidateOnlineIndex = L33_1
function L33_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L1_2 = L28_1
  if L1_2 then
    L1_2 = L29_1
    L1_2 = L0_2 - L1_2
    L2_2 = L27_1
    if L1_2 < L2_2 then
      L1_2 = L28_1
      return L1_2
    end
  end
  L1_2 = L32_1
  L2_2 = {}
  L3_2 = {}
  L2_2.byNumber = L3_2
  L3_2 = {}
  L2_2.byStr = L3_2
  L3_2 = {}
  L2_2.list = L3_2
  L3_2 = FW
  L3_2 = L3_2.GetPlayers
  L3_2 = L3_2()
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = GetPlayerNumber
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if nil ~= L10_2 and "" ~= L10_2 then
      L11_2 = L2_2.byNumber
      L11_2 = L11_2[L10_2]
      if L11_2 then
        L12_2 = #L11_2
        L12_2 = L12_2 + 1
        L11_2[L12_2] = L9_2
      else
        L12_2 = L2_2.byNumber
        L13_2 = {}
        L14_2 = L9_2
        L13_2[1] = L14_2
        L12_2[L10_2] = L13_2
      end
      L12_2 = L2_2.byStr
      L13_2 = tostring
      L14_2 = L10_2
      L13_2 = L13_2(L14_2)
      L14_2 = tonumber
      L15_2 = L9_2
      L14_2 = L14_2(L15_2)
      L12_2[L13_2] = L14_2
      L12_2 = L2_2.list
      L13_2 = L2_2.list
      L13_2 = #L13_2
      L13_2 = L13_2 + 1
      L14_2 = {}
      L15_2 = L9_2
      L16_2 = L10_2
      L17_2 = tostring
      L18_2 = L10_2
      L17_2 = L17_2(L18_2)
      L18_2 = L17_2
      L17_2 = L17_2.gsub
      L19_2 = "%D"
      L20_2 = ""
      L17_2 = L17_2(L18_2, L19_2, L20_2)
      L14_2[1] = L15_2
      L14_2[2] = L16_2
      L14_2[3] = L17_2
      L12_2[L13_2] = L14_2
    end
  end
  L4_2 = #L3_2
  if L4_2 > 0 then
    L4_2 = L32_1
    if L1_2 == L4_2 then
      L4_2 = L2_2
      L5_2 = GetGameTimer
      L5_2 = L5_2()
      L29_1 = L5_2
      L28_1 = L4_2
    end
  end
  return L2_2
end
OnlineNumberIndex = L33_1
function L33_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L1_2 = L30_1
  if L1_2 then
    L1_2 = L31_1
    L1_2 = L0_2 - L1_2
    L2_2 = L27_1
    if L1_2 < L2_2 then
      L1_2 = L30_1
      return L1_2
    end
  end
  L1_2 = L32_1
  L2_2 = {}
  L3_2 = FW
  L3_2 = L3_2.GetPlayers
  L3_2 = L3_2()
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = FW
    L10_2 = L10_2.GetCidPhone
    L11_2 = L9_2
    L10_2, L11_2 = L10_2(L11_2)
    if L10_2 and nil ~= L11_2 then
      L12_2 = L2_2[L11_2]
      if nil == L12_2 then
        L2_2[L11_2] = L9_2
      end
    end
  end
  L4_2 = #L3_2
  if L4_2 > 0 then
    L4_2 = L32_1
    if L1_2 == L4_2 then
      L4_2 = L2_2
      L5_2 = GetGameTimer
      L5_2 = L5_2()
      L31_1 = L5_2
      L30_1 = L4_2
    end
  end
  return L2_2
end
OnlineCidIndex = L33_1
L33_1 = AddEventHandler
L34_1 = "playerDropped"
function L35_1()
  local L0_2, L1_2
  L0_2 = InvalidateOnlineIndex
  L0_2()
end
L33_1(L34_1, L35_1)
L33_1 = FW
L33_1 = L33_1.OnPlayerLoaded
function L34_1()
  local L0_2, L1_2
  L0_2 = InvalidateOnlineIndex
  L0_2()
end
L33_1(L34_1)
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = ipairs
  L2_2 = FW
  L2_2 = L2_2.GetPlayers
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L2_2()
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = GetPlayerNumber
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 == A0_2 then
      L7_2 = SimDormant
      if L7_2 then
        L7_2 = SimDormant
        L8_2 = L6_2
        L9_2 = A0_2
        L7_2 = L7_2(L8_2, L9_2)
        if L7_2 then
          goto lbl_22
        end
      end
      return L6_2
    end
    ::lbl_22::
  end
  L1_2 = nil
  return L1_2
end
function L34_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = DeviceHolderByNumber
  if L1_2 then
    L1_2 = DeviceHolderByNumber
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if nil ~= L1_2 then
      L2_2 = L1_2 or L2_2
      if not L1_2 then
        L2_2 = nil
      end
      return L2_2
    end
  end
  L1_2 = OnlineNumberIndex
  L1_2 = L1_2()
  L1_2 = L1_2.byNumber
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = false
    L3_2 = ipairs
    L4_2 = L1_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = GetPlayerNumber
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if L9_2 == A0_2 then
        L9_2 = SimDormant
        if L9_2 then
          L9_2 = SimDormant
          L10_2 = L8_2
          L11_2 = A0_2
          L9_2 = L9_2(L10_2, L11_2)
        end
        if not L9_2 then
          return L8_2
        end
      else
        L2_2 = true
      end
    end
    if L2_2 then
      L3_2 = InvalidateOnlineIndex
      L3_2()
      L3_2 = L33_1
      L4_2 = A0_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        return L3_2
      end
    end
  end
  L2_2 = SimSrcByLine
  if L2_2 then
    L2_2 = SimSrcByLine
    L3_2 = A0_2
    return L2_2(L3_2)
  end
  L2_2 = nil
  return L2_2
end
GetSrcByNumber = L34_1
function L34_1(A0_2)
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
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "number" ~= L1_2 then
      return A0_2
    end
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "" == L1_2 then
    return L1_2
  end
  L2_2 = OnlineNumberIndex
  L2_2 = L2_2()
  L3_2 = L2_2.byNumber
  L3_2 = L3_2[L1_2]
  if L3_2 then
    L4_2 = ipairs
    L5_2 = L3_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = GetPlayerNumber
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if L10_2 == L1_2 then
        return L1_2
      end
    end
  end
  L4_2 = L34_1
  L5_2 = L1_2
  L4_2 = L4_2(L5_2)
  L5_2 = L34_1
  L6_2 = Config
  L6_2 = L6_2.NumberPrefix
  L5_2 = L5_2(L6_2)
  if "" ~= L5_2 then
    L6_2 = #L4_2
    L7_2 = #L5_2
    if L6_2 > L7_2 then
      L7_2 = L4_2
      L6_2 = L4_2.sub
      L8_2 = 1
      L9_2 = #L5_2
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      if L6_2 == L5_2 then
        L7_2 = L4_2
        L6_2 = L4_2.sub
        L8_2 = #L5_2
        L8_2 = L8_2 + 1
        L6_2 = L6_2(L7_2, L8_2)
        L4_2 = L6_2
      end
    end
  end
  L6_2 = #L4_2
  if L6_2 < 3 then
    if L3_2 then
      L6_2 = InvalidateOnlineIndex
      L6_2()
      L6_2 = ipairs
      L7_2 = FW
      L7_2 = L7_2.GetPlayers
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L7_2()
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = GetPlayerNumber
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        if L12_2 == L1_2 then
          return L1_2
        end
      end
    end
    return L1_2
  end
  L6_2 = nil ~= L3_2
  L7_2 = ipairs
  L8_2 = L2_2.list
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2[3]
    if L13_2 == L4_2 then
      L13_2 = GetPlayerNumber
      L14_2 = L12_2[1]
      L13_2 = L13_2(L14_2)
      L14_2 = L12_2[2]
      if L13_2 == L14_2 then
        return L13_2
      end
      L6_2 = true
      break
    end
  end
  if L6_2 then
    L7_2 = InvalidateOnlineIndex
    L7_2()
    L7_2 = FW
    L7_2 = L7_2.GetPlayers
    L7_2 = L7_2()
    L8_2 = ipairs
    L9_2 = L7_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = GetPlayerNumber
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      if L14_2 == L1_2 then
        return L1_2
      end
    end
    L8_2 = ipairs
    L9_2 = L7_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = GetPlayerNumber
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      if L14_2 then
        L15_2 = L34_1
        L16_2 = L14_2
        L15_2 = L15_2(L16_2)
        if L15_2 == L4_2 then
          return L14_2
        end
      end
    end
  end
  L7_2 = SimCanon
  if L7_2 then
    L7_2 = SimCanon
    L8_2 = L1_2
    L9_2 = L4_2
    L7_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      return L7_2
    end
  end
  L7_2 = pcall
  L8_2 = MySQL
  L8_2 = L8_2.single
  L8_2 = L8_2.await
  L9_2 = "SELECT phone FROM apex_phone_accounts WHERE phone = ? LIMIT 1"
  L10_2 = {}
  L11_2 = L1_2
  L10_2[1] = L11_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
  if L7_2 and L8_2 then
    L9_2 = L8_2.phone
    if L9_2 then
      L9_2 = L8_2.phone
      if "" ~= L9_2 then
        L9_2 = L8_2.phone
        return L9_2
      end
    end
  end
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.single
  L10_2 = L10_2.await
  L11_2 = [[
SELECT phone FROM apex_phone_accounts
        WHERE REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '+', ''), '.', '') = ? LIMIT 1]]
  L12_2 = {}
  L13_2 = L4_2
  L12_2[1] = L13_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  if L9_2 and L10_2 then
    L11_2 = L10_2.phone
    if L11_2 then
      L11_2 = L10_2.phone
      if "" ~= L11_2 then
        L11_2 = L10_2.phone
        return L11_2
      end
    end
  end
  return L1_2
end
CanonNumber = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if not A0_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = GetSrcByNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = GetCid
    L3_2 = L1_2
    return L2_2(L3_2)
  end
  L2_2 = SimLineOwner
  if L2_2 then
    L2_2 = SimLineOwner
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      return L2_2
    end
  end
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT citizenid FROM apex_phone_accounts WHERE phone = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = SimDormantCid
    if L3_2 then
      L3_2 = SimDormantCid
      L4_2 = L2_2.citizenid
      L5_2 = A0_2
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        L3_2 = nil
        return L3_2
      end
    end
    L3_2 = L2_2.citizenid
    return L3_2
  end
  L3_2 = SimConfig
  if L3_2 then
    L3_2 = SimConfig
    L3_2 = L3_2()
    L3_2 = L3_2.required
    if L3_2 then
      L3_2 = nil
      return L3_2
    end
  end
  L3_2 = FW
  L3_2 = L3_2.FindCidByPhone
  L4_2 = A0_2
  return L3_2(L4_2)
end
GetCitizenIdByNumber = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = Accounts
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = L1_2.phone
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT phone FROM apex_phone_accounts WHERE citizenid = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = L2_2.phone
    return L3_2
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayerByCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.phone
    return L4_2
  end
  L4_2 = FW
  L4_2 = L4_2.GetPhoneFromDB
  L5_2 = A0_2
  return L4_2(L5_2)
end
GetNumberByCitizenId = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = {}
  L3_2 = L1_2.cid
  L2_2.citizenid = L3_2
  L3_2 = L1_2.firstname
  L2_2.firstname = L3_2
  L3_2 = L1_2.lastname
  L2_2.lastname = L3_2
  L3_2 = GetPlayerNumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L2_2.phone = L3_2
  L3_2 = L1_2.birthdate
  L2_2.birthdate = L3_2
  L3_2 = L1_2.gender
  L2_2.gender = L3_2
  L3_2 = {}
  L4_2 = L1_2.job
  L4_2 = L4_2.name
  L3_2.name = L4_2
  L4_2 = L1_2.job
  L4_2 = L4_2.label
  L3_2.label = L4_2
  L4_2 = L1_2.job
  L4_2 = L4_2.grade
  L3_2.grade = L4_2
  L4_2 = tonumber
  L5_2 = L1_2.job
  L5_2 = L5_2.gradeLevel
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.gradeLevel = L4_2
  L4_2 = L1_2.job
  L4_2 = L4_2.onduty
  L3_2.onduty = L4_2
  L2_2.job = L3_2
  L3_2 = {}
  L4_2 = L1_2.GetMoney
  L5_2 = "cash"
  L4_2 = L4_2(L5_2)
  L3_2.cash = L4_2
  L4_2 = L1_2.GetMoney
  L5_2 = "bank"
  L4_2 = L4_2(L5_2)
  L3_2.bank = L4_2
  L2_2.money = L3_2
  L3_2 = FW
  L3_2 = L3_2.name
  L2_2.framework = L3_2
  return L2_2
end
BuildPlayer = L35_1
function L35_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = 1
  L1_2 = 50
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = Config
    L4_2 = L4_2.NumberFormat
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
    L5_2 = MySQL
    L5_2 = L5_2.scalar
    L5_2 = L5_2.await
    L6_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE phone = ?"
    L7_2 = {}
    L8_2 = L4_2
    L7_2[1] = L8_2
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = L5_2 or L6_2
    if not L5_2 then
      L6_2 = 0
    end
    if 0 == L6_2 then
      L6_2 = FW
      L6_2 = L6_2.PhoneTaken
      L7_2 = L4_2
      L6_2 = L6_2(L7_2)
      if not L6_2 then
        L6_2 = SimNumberTaken
        if L6_2 then
          L6_2 = SimNumberTaken
          L7_2 = L4_2
          L6_2 = L6_2(L7_2)
          if L6_2 then
            goto lbl_40
          end
        end
        return L4_2
      end
    end
    ::lbl_40::
  end
  L0_2 = tostring
  L1_2 = math
  L1_2 = L1_2.random
  L2_2 = 1000000
  L3_2 = 9999999
  L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L1_2(L2_2, L3_2)
  return L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
end
GenPhoneNumber = L35_1
function L36_1(A0_2)
  local L1_2, L2_2
  L1_2 = SimHasLine
  if L1_2 then
    L1_2 = SimHasLine
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if not L1_2 then
      L1_2 = {}
      L1_2.ok = false
      L1_2.error = "nosim"
      L1_2.status = "nosim"
      return L1_2
    end
  end
  L1_2 = nil
  return L1_2
end
RequireLine = L36_1
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = Config
  L2_2 = L2_2.SyncNumberToCharInfo
  if not (L2_2 and A0_2) or not A1_2 then
    return
  end
  L2_2 = FW
  L2_2 = L2_2.SetPhone
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2(L3_2, L4_2)
end
L37_1 = {}
L38_1 = 1116352408
L39_1 = 1899447441
L40_1 = 3049323471
L41_1 = 3921009573
L42_1 = 961987163
L43_1 = 1508970993
L44_1 = 2453635748
L45_1 = 2870763221
L46_1 = 3624381080
L47_1 = 310598401
L48_1 = 607225278
L49_1 = 1426881987
L50_1 = 1925078388
L51_1 = 2162078206
L52_1 = 2614888103
L53_1 = 3248222580
L54_1 = 3835390401
L55_1 = 4022224774
L56_1 = 264347078
L57_1 = 604807628
L58_1 = 770255983
L59_1 = 1249150122
L60_1 = 1555081692
L61_1 = 1996064986
L62_1 = 2554220882
L63_1 = 2821834349
L64_1 = 2952996808
L65_1 = 3210313671
L66_1 = 3336571891
L67_1 = 3584528711
L68_1 = 113926993
L69_1 = 338241895
L70_1 = 666307205
L71_1 = 773529912
L72_1 = 1294757372
L73_1 = 1396182291
L74_1 = 1695183700
L75_1 = 1986661051
L76_1 = 2177026350
L77_1 = 2456956037
L78_1 = 2730485921
L79_1 = 2820302411
L80_1 = 3259730800
L81_1 = 3345764771
L82_1 = 3516065817
L83_1 = 3600352804
L84_1 = 4094571909
L85_1 = 275423344
L86_1 = 430227734
L87_1 = 506948616
L37_1[1] = L38_1
L37_1[2] = L39_1
L37_1[3] = L40_1
L37_1[4] = L41_1
L37_1[5] = L42_1
L37_1[6] = L43_1
L37_1[7] = L44_1
L37_1[8] = L45_1
L37_1[9] = L46_1
L37_1[10] = L47_1
L37_1[11] = L48_1
L37_1[12] = L49_1
L37_1[13] = L50_1
L37_1[14] = L51_1
L37_1[15] = L52_1
L37_1[16] = L53_1
L37_1[17] = L54_1
L37_1[18] = L55_1
L37_1[19] = L56_1
L37_1[20] = L57_1
L37_1[21] = L58_1
L37_1[22] = L59_1
L37_1[23] = L60_1
L37_1[24] = L61_1
L37_1[25] = L62_1
L37_1[26] = L63_1
L37_1[27] = L64_1
L37_1[28] = L65_1
L37_1[29] = L66_1
L37_1[30] = L67_1
L37_1[31] = L68_1
L37_1[32] = L69_1
L37_1[33] = L70_1
L37_1[34] = L71_1
L37_1[35] = L72_1
L37_1[36] = L73_1
L37_1[37] = L74_1
L37_1[38] = L75_1
L37_1[39] = L76_1
L37_1[40] = L77_1
L37_1[41] = L78_1
L37_1[42] = L79_1
L37_1[43] = L80_1
L37_1[44] = L81_1
L37_1[45] = L82_1
L37_1[46] = L83_1
L37_1[47] = L84_1
L37_1[48] = L85_1
L37_1[49] = L86_1
L37_1[50] = L87_1
L38_1 = 659060556
L39_1 = 883997877
L40_1 = 958139571
L41_1 = 1322822218
L42_1 = 1537002063
L43_1 = 1747873779
L44_1 = 1955562222
L45_1 = 2024104815
L46_1 = 2227730452
L47_1 = 2361852424
L48_1 = 2428436474
L49_1 = 2756734187
L50_1 = 3204031479
L51_1 = 3329325298
L37_1[51] = L38_1
L37_1[52] = L39_1
L37_1[53] = L40_1
L37_1[54] = L41_1
L37_1[55] = L42_1
L37_1[56] = L43_1
L37_1[57] = L44_1
L37_1[58] = L45_1
L37_1[59] = L46_1
L37_1[60] = L47_1
L37_1[61] = L48_1
L37_1[62] = L49_1
L37_1[63] = L50_1
L37_1[64] = L51_1
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2
  L1_2 = 4294967295
  L2_2 = 1779033703
  L3_2 = 3144134277
  L4_2 = 1013904242
  L5_2 = 2773480762
  L6_2 = 1359893119
  L7_2 = 2600822924
  L8_2 = 528734635
  L9_2 = 1541459225
  L10_2 = #A0_2
  L11_2 = A0_2
  L12_2 = "\128"
  L13_2 = string
  L13_2 = L13_2.rep
  L14_2 = "\000"
  L15_2 = 55
  L15_2 = L15_2 - L10_2
  L15_2 = L15_2 % 64
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = string
  L14_2 = L14_2.pack
  L15_2 = ">I8"
  L16_2 = L10_2 * 8
  L14_2 = L14_2(L15_2, L16_2)
  L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2
  A0_2 = L11_2
  L11_2 = {}
  L12_2 = L37_1
  L13_2 = 1
  L14_2 = #A0_2
  L15_2 = 64
  for L16_2 = L13_2, L14_2, L15_2 do
    L17_2 = string
    L17_2 = L17_2.unpack
    L18_2 = ">I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4"
    L19_2 = A0_2
    L20_2 = L16_2
    L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2 = L17_2(L18_2, L19_2, L20_2)
    L11_2[16] = L32_2
    L11_2[15] = L31_2
    L11_2[14] = L30_2
    L11_2[13] = L29_2
    L11_2[12] = L28_2
    L11_2[11] = L27_2
    L11_2[10] = L26_2
    L11_2[9] = L25_2
    L11_2[8] = L24_2
    L11_2[7] = L23_2
    L11_2[6] = L22_2
    L11_2[5] = L21_2
    L11_2[4] = L20_2
    L11_2[3] = L19_2
    L11_2[2] = L18_2
    L11_2[1] = L17_2
    L17_2 = 17
    L18_2 = 64
    L19_2 = 1
    for L20_2 = L17_2, L18_2, L19_2 do
      L21_2 = L20_2 - 15
      L21_2 = L11_2[L21_2]
      L22_2 = L20_2 - 2
      L22_2 = L11_2[L22_2]
      L23_2 = L21_2 >> 7
      L24_2 = L21_2 << 25
      L23_2 = L23_2 | L24_2
      L24_2 = L21_2 >> 18
      L25_2 = L21_2 << 14
      L24_2 = L24_2 | L25_2
      L23_2 = L23_2 ~ L24_2
      L24_2 = L21_2 >> 3
      L23_2 = L23_2 ~ L24_2
      L24_2 = L22_2 >> 17
      L25_2 = L22_2 << 15
      L24_2 = L24_2 | L25_2
      L25_2 = L22_2 >> 19
      L26_2 = L22_2 << 13
      L25_2 = L25_2 | L26_2
      L24_2 = L24_2 ~ L25_2
      L25_2 = L22_2 >> 10
      L24_2 = L24_2 ~ L25_2
      L25_2 = L20_2 - 16
      L25_2 = L11_2[L25_2]
      L25_2 = L25_2 + L23_2
      L26_2 = L20_2 - 7
      L26_2 = L11_2[L26_2]
      L25_2 = L25_2 + L26_2
      L25_2 = L25_2 + L24_2
      L25_2 = L25_2 & L1_2
      L11_2[L20_2] = L25_2
    end
    L17_2 = L2_2
    L18_2 = L3_2
    L19_2 = L4_2
    L20_2 = L5_2
    L21_2 = L6_2
    L22_2 = L7_2
    L23_2 = L8_2
    L24_2 = L9_2
    L25_2 = 1
    L26_2 = 64
    L27_2 = 1
    for L28_2 = L25_2, L26_2, L27_2 do
      L29_2 = L21_2 >> 6
      L30_2 = L21_2 << 26
      L29_2 = L29_2 | L30_2
      L30_2 = L21_2 >> 11
      L31_2 = L21_2 << 21
      L30_2 = L30_2 | L31_2
      L29_2 = L29_2 ~ L30_2
      L30_2 = L21_2 >> 25
      L31_2 = L21_2 << 7
      L30_2 = L30_2 | L31_2
      L29_2 = L29_2 ~ L30_2
      L30_2 = L29_2 & L1_2
      L30_2 = L24_2 + L30_2
      L31_2 = L21_2 & L22_2
      L32_2 = ~L21_2
      L32_2 = L32_2 & L23_2
      L31_2 = L31_2 ~ L32_2
      L30_2 = L30_2 + L31_2
      L31_2 = L12_2[L28_2]
      L30_2 = L30_2 + L31_2
      L31_2 = L11_2[L28_2]
      L30_2 = L30_2 + L31_2
      L30_2 = L30_2 & L1_2
      L31_2 = L17_2 >> 2
      L32_2 = L17_2 << 30
      L31_2 = L31_2 | L32_2
      L32_2 = L17_2 >> 13
      L33_2 = L17_2 << 19
      L32_2 = L32_2 | L33_2
      L31_2 = L31_2 ~ L32_2
      L32_2 = L17_2 >> 22
      L33_2 = L17_2 << 10
      L32_2 = L32_2 | L33_2
      L31_2 = L31_2 ~ L32_2
      L32_2 = L31_2 & L1_2
      L33_2 = L17_2 & L18_2
      L34_2 = L17_2 & L19_2
      L33_2 = L33_2 ~ L34_2
      L34_2 = L18_2 & L19_2
      L33_2 = L33_2 ~ L34_2
      L32_2 = L32_2 + L33_2
      L32_2 = L32_2 & L1_2
      L33_2 = L23_2
      L34_2 = L22_2
      L35_2 = L21_2
      L36_2 = L20_2 + L30_2
      L36_2 = L36_2 & L1_2
      L37_2 = L19_2
      L38_2 = L18_2
      L39_2 = L17_2
      L40_2 = L30_2 + L32_2
      L17_2 = L40_2 & L1_2
      L18_2 = L39_2
      L19_2 = L38_2
      L20_2 = L37_2
      L21_2 = L36_2
      L22_2 = L35_2
      L23_2 = L34_2
      L24_2 = L33_2
    end
    L25_2 = L2_2 + L17_2
    L25_2 = L25_2 & L1_2
    L26_2 = L3_2 + L18_2
    L26_2 = L26_2 & L1_2
    L27_2 = L4_2 + L19_2
    L27_2 = L27_2 & L1_2
    L28_2 = L5_2 + L20_2
    L5_2 = L28_2 & L1_2
    L4_2 = L27_2
    L3_2 = L26_2
    L2_2 = L25_2
    L25_2 = L6_2 + L21_2
    L25_2 = L25_2 & L1_2
    L26_2 = L7_2 + L22_2
    L26_2 = L26_2 & L1_2
    L27_2 = L8_2 + L23_2
    L27_2 = L27_2 & L1_2
    L28_2 = L9_2 + L24_2
    L9_2 = L28_2 & L1_2
    L8_2 = L27_2
    L7_2 = L26_2
    L6_2 = L25_2
  end
  L13_2 = string
  L13_2 = L13_2.pack
  L14_2 = ">I4I4I4I4I4I4I4I4"
  L15_2 = L2_2
  L16_2 = L3_2
  L17_2 = L4_2
  L18_2 = L5_2
  L19_2 = L6_2
  L20_2 = L7_2
  L21_2 = L8_2
  L22_2 = L9_2
  return L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "."
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = "%02x"
    L2_3 = L1_3
    L1_3 = L1_3.format
    L4_3 = A0_3
    L3_3 = A0_3.byte
    L3_3, L4_3 = L3_3(L4_3)
    return L1_3(L2_3, L3_3, L4_3)
  end
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
L40_1 = 96
L41_1 = 10000
function L42_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.PinHash
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.PinHash
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = L0_2.rounds
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = L40_1
  end
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = L40_1
  end
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 1
  L4_2 = math
  L4_2 = L4_2.min
  L5_2 = L1_2
  L6_2 = L41_1
  L4_2 = L4_2(L5_2, L6_2)
  return L2_2(L3_2, L4_2)
end
function L43_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L38_1
  L4_2 = "apex_phone:pin:"
  L5_2 = A1_2
  L6_2 = ":"
  L7_2 = A0_2
  L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2
  L3_2 = L3_2(L4_2)
  L4_2 = 2
  L5_2 = A2_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L38_1
    L9_2 = L3_2
    L10_2 = A1_2
    L9_2 = L9_2 .. L10_2
    L8_2 = L8_2(L9_2)
    L3_2 = L8_2
  end
  L4_2 = L39_1
  L5_2 = L3_2
  return L4_2(L5_2)
end
function L44_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = "%08x%08x"
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = math
  L3_2 = L3_2.random
  L4_2 = 0
  L5_2 = 4294967295
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = math
  L4_2 = L4_2.random
  L5_2 = 0
  L6_2 = 4294967295
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2, L6_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L2_2 = L42_1
  L2_2 = L2_2()
  L3_2 = "h1$%s$%d$%s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L1_2
  L6_2 = L2_2
  L7_2 = L43_1
  L8_2 = tostring
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  L9_2 = L1_2
  L10_2 = L2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2)
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
function L46_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L45_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^h1%$(%x+)%$(%d+)%$(%x+)$"
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = L2_2
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L2_2 = L4_2
  if L1_2 then
    L4_2 = #L1_2
    if 16 == L4_2 and L2_2 and not (L2_2 < 1) then
      L4_2 = L41_1
      if not (L2_2 > L4_2) then
        L4_2 = #L3_2
        if 64 == L4_2 then
          goto lbl_35
        end
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_35::
  L5_2 = L1_2
  L4_2 = L1_2.lower
  L4_2 = L4_2(L5_2)
  L5_2 = L2_2
  L7_2 = L3_2
  L6_2 = L3_2.lower
  L6_2, L7_2 = L6_2(L7_2)
  return L4_2, L5_2, L6_2, L7_2
end
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = #A0_2
  L3_2 = #A1_2
  if L2_2 ~= L3_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = 0
  L3_2 = 1
  L4_2 = #A0_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L8_2 = A0_2
    L7_2 = A0_2.byte
    L9_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2)
    L9_2 = A1_2
    L8_2 = A1_2.byte
    L10_2 = L6_2
    L8_2 = L8_2(L9_2, L10_2)
    L7_2 = L7_2 ~ L8_2
    L2_2 = L2_2 | L7_2
  end
  L3_2 = 0 == L2_2
  return L3_2
end
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
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
  L2_2 = tostring
  L3_2 = A1_2 or L3_2
  if not A1_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = 10
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  A1_2 = L2_2
  L2_2 = L45_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L2_2 = L46_1
    L3_2 = A0_2
    L2_2, L3_2, L4_2 = L2_2(L3_2)
    if not L2_2 then
      L5_2 = false
      return L5_2
    end
    L5_2 = L47_1
    L6_2 = L43_1
    L7_2 = A1_2
    L8_2 = L2_2
    L9_2 = L3_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L7_2 = L4_2
    return L5_2(L6_2, L7_2)
  end
  L2_2 = L47_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = "" ~= A0_2 and L2_2
  return L2_2
end
function L49_1(A0_2)
  local L1_2, L2_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L1_2 = #L1_2
  if 0 == L1_2 then
    L2_2 = 0
    return L2_2
  end
  if L1_2 >= 6 then
    L2_2 = 6
    if L2_2 then
      goto lbl_17
    end
  end
  L2_2 = 4
  ::lbl_17::
  return L2_2
end
function L50_1(A0_2)
  local L1_2, L2_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if "" ~= A0_2 then
    L1_2 = L3_1
    if L1_2 then
      goto lbl_13
    end
  end
  do return A0_2 end
  ::lbl_13::
  L1_2 = L44_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = L3_1
    if L1_2 then
      goto lbl_10
    end
  end
  do return A0_2 end
  ::lbl_10::
  L1_2 = A0_2.pin
  if nil ~= L1_2 then
    L1_2 = tostring
    L2_2 = A0_2.pin
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_19
    end
  end
  L1_2 = ""
  ::lbl_19::
  if "" ~= L1_2 then
    L2_2 = L45_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      goto lbl_27
    end
  end
  do return A0_2 end
  ::lbl_27::
  L2_2 = L44_1
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L49_1
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L4_2 = L2_2
  A0_2.pin_len = L3_2
  A0_2.pin = L4_2
  L4_2 = A0_2.citizenid
  if L4_2 then
    L4_2 = MySQL
    L4_2 = L4_2.update
    L5_2 = "UPDATE apex_phone_accounts SET pin = ?, pin_len = ? WHERE citizenid = ? AND pin = ?"
    L6_2 = {}
    L7_2 = L2_2
    L8_2 = L3_2
    L9_2 = A0_2.citizenid
    L10_2 = L1_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L6_2[4] = L10_2
    L4_2(L5_2, L6_2)
  end
  return A0_2
end
L52_1 = {}
function L53_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = A0_2.settings
  if L1_2 then
    L1_2 = json
    L1_2 = L1_2.decode
    L2_2 = A0_2.settings
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_15
    end
  end
  L1_2 = nil
  ::lbl_15::
  A0_2.settings = L1_2
  L1_2 = A0_2.layout
  if L1_2 then
    L1_2 = json
    L1_2 = L1_2.decode
    L2_2 = A0_2.layout
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_26
    end
  end
  L1_2 = nil
  ::lbl_26::
  A0_2.layout = L1_2
  L1_2 = A0_2.avatar_photo
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L2_2 = L1_2 or L2_2
  if "string" ~= L2_2 or "" == L1_2 or not L1_2 then
    L2_2 = nil
  end
  A0_2.avatarPhoto = L2_2
  A0_2.avatar_photo = nil
  L2_2 = A0_2.citizenid
  if L2_2 then
    L3_2 = A0_2.citizenid
    L2_2 = L52_1
    L2_2 = L2_2[L3_2]
  end
  if L2_2 then
    L3_2 = A0_2.phone
    L4_2 = L2_2.old
    if L3_2 == L4_2 then
      L3_2 = L2_2.new
      A0_2.phone = L3_2
    end
  end
  L3_2 = L51_1
  L4_2 = A0_2
  return L3_2(L4_2)
end
L54_1 = {}
L54_1["account.verifyPin"] = 4
L54_1["account.setPin"] = 4
L54_1["account.create"] = 5
L54_1["account.reset"] = 10
L54_1["account.swapSim"] = 10
L54_1["account.usernameFree"] = 2
L54_1["account.setFace"] = 3
L54_1["account.setAvatarPhoto"] = 3
L54_1["messages.send"] = 2
L54_1["mail.send"] = 4
L54_1["calls.start"] = 4
L54_1["services.request"] = 8
L54_1["bank.transfer"] = 3
L54_1["bills.create"] = 5
L54_1["bills.pay"] = 3
L54_1["crypto.buy"] = 3
L54_1["crypto.sell"] = 3
L54_1["crypto.send"] = 3
L54_1["onion.buy"] = 3
L54_1["onion.create"] = 4
L54_1["market.buy"] = 3
L54_1["market.create"] = 4
L54_1["eats.order"] = 5
L54_1["eats.pro"] = 3
L54_1["eats.cancel"] = 2
L54_1["eats.search"] = 2
L54_1["social.post"] = 4
L54_1["social.comment"] = 2
L54_1["social.follow"] = 2
L54_1["social.story.add"] = 4
L54_1["social.instant.add"] = 4
L54_1["darkchat.send"] = 2
L54_1["match.swipe"] = 1
L54_1["market.list"] = 3
L54_1["onion.list"] = 3
L54_1["social.feed"] = 2
L54_1["social.search"] = 3
L54_1["match.cards"] = 3
L54_1["match.createProfile"] = 3
L54_1["match.updateProfile"] = 3
L54_1["music.save"] = 3
L54_1["social.comments"] = 2
L54_1["social.likers"] = 2
L54_1["social.replies"] = 2
L54_1["social.followers"] = 2
L54_1["apps.grant"] = 3
L54_1["apps.revoke"] = 2
L54_1["apps.grants"] = 2
L54_1["groups.create"] = 5
L54_1["groups.add"] = 3
L54_1["groups.rename"] = 2
L54_1["groups.setAvatar"] = 2
L54_1["groups.remove"] = 2
L54_1["groups.role"] = 2
L54_1["groups.leave"] = 2
L54_1["media.begin"] = 2
L54_1["blocks.add"] = 2
L54_1["mail.saveDraft"] = 2
L54_1["recado.send"] = 2
L54_1["recado.forward"] = 4
L54_1["recado.thread.set"] = 2
L54_1["recado.pin"] = 2
L54_1["recado.star"] = 1
L54_1["recado.viewOnce"] = 2
L54_1["recado.unlock"] = 4
L54_1["recado.search"] = 2
L54_1["recado.recording"] = 1
L54_1["recado.group.create"] = 5
L54_1["recado.group.add"] = 3
L54_1["recado.group.join"] = 3
L54_1["recado.group.invite"] = 2
L54_1["recado.group.update"] = 2
L54_1["recado.group.member"] = 2
L54_1["recado.group.leave"] = 2
L54_1["recado.group.search"] = 2
L55_1 = "recado.profile.set"
L54_1[L55_1] = 2
L55_1 = "recado.privacy.set"
L54_1[L55_1] = 1
L55_1 = "recado.status.add"
L54_1[L55_1] = 4
L55_1 = "recado.status.reply"
L54_1[L55_1] = 2
L55_1 = "recado.status.reshare"
L54_1[L55_1] = 3
L55_1 = "recado.channel.create"
L54_1[L55_1] = 5
L55_1 = "recado.channel.post"
L54_1[L55_1] = 3
L55_1 = "recado.channel.join"
L54_1[L55_1] = 3
L55_1 = "recado.channel.react"
L54_1[L55_1] = 1
L55_1 = "recado.community.create"
L54_1[L55_1] = 5
L55_1 = "recado.community.addGroup"
L54_1[L55_1] = 3
L55_1 = "recado.call.start"
L54_1[L55_1] = 4
L55_1 = "recado.call.invite"
L54_1[L55_1] = 3
L55_1 = "recado.call.join"
L54_1[L55_1] = 2
L55_1 = "recado.call.schedule"
L54_1[L55_1] = 3
L55_1 = "recado.call.link"
L54_1[L55_1] = 3
L55_1 = "recado.call.react"
L54_1[L55_1] = 1
L55_1 = "recado.call.revokeLink"
L54_1[L55_1] = 2
L55_1 = "recado.call.cancelScheduled"
L54_1[L55_1] = 2
L55_1 = "recado.call.clearHistory"
L54_1[L55_1] = 3
L55_1 = "recado.call.history"
L54_1[L55_1] = 2
L55_1 = "recado.call.state"
L54_1[L55_1] = 1
L55_1 = "recado.call.decline"
L54_1[L55_1] = 1
L55_1 = "recado.call.mute"
L54_1[L55_1] = 1
L55_1 = "recado.call.hand"
L54_1[L55_1] = 1
L55_1 = "recado.call.video"
L54_1[L55_1] = 1
L55_1 = "recado.channel.follow"
L54_1[L55_1] = 2
L55_1 = "recado.channel.admins"
L54_1[L55_1] = 2
L55_1 = "recado.channel.update"
L54_1[L55_1] = 2
L55_1 = "recado.community.update"
L54_1[L55_1] = 2
L55_1 = "recado.community.leave"
L54_1[L55_1] = 3
L55_1 = "recado.community.admin"
L54_1[L55_1] = 2
L55_1 = {}
L56_1 = "photos.upload"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "photos.data"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "photos.poster"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "social.story.upload"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "social.story.media"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "social.post.media"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "social.instant.upload"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "social.instant.media"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "media.upload"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "media.get"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "mail.attachment"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = "recado.social.media"
L57_1 = true
L55_1[L56_1] = L57_1
L56_1 = {}
L57_1 = {}
L58_1 = nil
function L59_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L58_1
  if not L1_2 then
    L1_2 = {}
    L58_1 = L1_2
    L1_2 = type
    L2_2 = Config
    L2_2 = L2_2.RateLimit
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = Config
      L1_2 = L1_2.RateLimit
      L1_2 = L1_2.exempt
      if L1_2 then
        goto lbl_19
      end
    end
    L1_2 = nil
    ::lbl_19::
    L2_2 = type
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = pairs
      L3_2 = L1_2
      L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
      for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
        L8_2 = type
        L9_2 = L6_2
        L8_2 = L8_2(L9_2)
        if "string" == L8_2 and L7_2 then
          L8_2 = L58_1
          L8_2[L6_2] = true
        end
        L8_2 = type
        L9_2 = L7_2
        L8_2 = L8_2(L9_2)
        if "string" == L8_2 then
          L8_2 = L58_1
          L8_2[L7_2] = true
        end
      end
    end
  end
  L1_2 = L55_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = L58_1
    L1_2 = L1_2[A0_2]
    if not L1_2 then
      L2_2 = A0_2
      L1_2 = A0_2.sub
      L3_2 = -7
      L1_2 = L1_2(L2_2, L3_2)
      L1_2 = ".upload" == L1_2
    end
  end
  return L1_2
end
function L60_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L5_2 = L56_1
  L5_2 = L5_2[A0_2]
  if not L5_2 then
    L6_2 = {}
    L5_2 = L6_2
    L6_2 = L56_1
    L6_2[A0_2] = L5_2
  end
  L6_2 = GetGameTimer
  L6_2 = L6_2()
  L7_2 = L5_2[A1_2]
  if not L7_2 then
    L8_2 = {}
    L8_2.tokens = A3_2
    L8_2.t = L6_2
    L7_2 = L8_2
    L5_2[A1_2] = L7_2
  end
  L8_2 = math
  L8_2 = L8_2.min
  L9_2 = A3_2
  L10_2 = L7_2.tokens
  L11_2 = L7_2.t
  L11_2 = L6_2 - L11_2
  L11_2 = L11_2 * A2_2
  L11_2 = L11_2 / 1000
  L10_2 = L10_2 + L11_2
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.tokens = L8_2
  L7_2.t = L6_2
  L8_2 = math
  L8_2 = L8_2.min
  L9_2 = A4_2
  L10_2 = A3_2
  L8_2 = L8_2(L9_2, L10_2)
  A4_2 = L8_2
  L8_2 = L7_2.tokens
  if A4_2 > L8_2 then
    L8_2 = false
    return L8_2
  end
  L8_2 = L7_2.tokens
  L8_2 = L8_2 - A4_2
  L7_2.tokens = L8_2
  L8_2 = true
  return L8_2
end
L61_1 = _ENV
L62_1 = "RateLimitAllow"
function L63_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = Config
  L2_2 = L2_2.RateLimit
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L2_2.enabled
    if false ~= L3_2 then
      goto lbl_13
    end
  end
  L3_2 = true
  do return L3_2 end
  ::lbl_13::
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  if not A0_2 or A0_2 <= 0 then
    L3_2 = true
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A1_2 or L4_2
  if not A1_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  A1_2 = L3_2
  L3_2 = nil
  L5_2 = A1_2
  L4_2 = A1_2.sub
  L6_2 = 1
  L7_2 = 6
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if "event." == L4_2 then
    L4_2 = L60_1
    L5_2 = A0_2
    L6_2 = "event"
    L7_2 = math
    L7_2 = L7_2.max
    L8_2 = 0.1
    L9_2 = tonumber
    L10_2 = L2_2.perSecond
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = 12
    end
    L7_2 = L7_2(L8_2, L9_2)
    L8_2 = math
    L8_2 = L8_2.max
    L9_2 = 1
    L10_2 = tonumber
    L11_2 = L2_2.burst
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 40
    end
    L8_2 = L8_2(L9_2, L10_2)
    L9_2 = 1
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    L3_2 = L4_2
  else
    L4_2 = L59_1
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L4_2 = tonumber
      L5_2 = L2_2.chunkPerSecond
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = 60
      end
      L5_2 = tonumber
      L6_2 = L2_2.chunkBurst
      L5_2 = L5_2(L6_2)
      if not L5_2 then
        L5_2 = 300
      end
      if L4_2 <= 0 or L5_2 <= 0 then
        L6_2 = true
        return L6_2
      end
      L6_2 = L60_1
      L7_2 = A0_2
      L8_2 = "chunk"
      L9_2 = L4_2
      L10_2 = L5_2
      L11_2 = 1
      L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
      L3_2 = L6_2
    else
      L4_2 = type
      L5_2 = L2_2.costs
      L4_2 = L4_2(L5_2)
      if "table" == L4_2 then
        L4_2 = tonumber
        L5_2 = L2_2.costs
        L5_2 = L5_2[A1_2]
        L4_2 = L4_2(L5_2)
        if L4_2 then
          goto lbl_107
        end
      end
      L4_2 = nil
      ::lbl_107::
      if not L4_2 then
        L5_2 = L54_1
        L5_2 = L5_2[A1_2]
        L4_2 = L5_2 or L4_2
        if not L5_2 then
          L4_2 = 1
        end
      end
      if L4_2 <= 0 then
        L5_2 = true
        return L5_2
      end
      L5_2 = L60_1
      L6_2 = A0_2
      L7_2 = "main"
      L8_2 = math
      L8_2 = L8_2.max
      L9_2 = 0.1
      L10_2 = tonumber
      L11_2 = L2_2.perSecond
      L10_2 = L10_2(L11_2)
      if not L10_2 then
        L10_2 = 12
      end
      L8_2 = L8_2(L9_2, L10_2)
      L9_2 = math
      L9_2 = L9_2.max
      L10_2 = 1
      L11_2 = tonumber
      L12_2 = L2_2.burst
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 40
      end
      L9_2 = L9_2(L10_2, L11_2)
      L10_2 = L4_2
      L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
      L3_2 = L5_2
    end
  end
  if not L3_2 then
    L4_2 = GetGameTimer
    L4_2 = L4_2()
    L5_2 = L57_1
    L5_2 = L5_2[A0_2]
    if L5_2 then
      L5_2 = L57_1
      L5_2 = L5_2[A0_2]
      L5_2 = L4_2 - L5_2
      L6_2 = 30000
      if not (L5_2 > L6_2) then
        goto lbl_173
      end
    end
    L5_2 = L57_1
    L5_2[A0_2] = L4_2
    L5_2 = print
    L6_2 = "^3[unique_phone]^0 rate limit: %s (id %s) exceeded it on \"%s\""
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = tostring
    L9_2 = GetPlayerName
    L10_2 = A0_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
    L9_2 = A0_2
    L10_2 = A1_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  ::lbl_173::
  return L3_2
end
L61_1[L62_1] = L63_1
L61_1 = 7000
function L62_1()
  local L0_2, L1_2, L2_2
  L0_2 = DBReady
  if L0_2 then
    L0_2 = true
    return L0_2
  end
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
    L2_2 = L61_1
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 250
    L1_2(L2_2)
  end
  L1_2 = DBReady
  L1_2 = true == L1_2
  return L1_2
end
L63_1 = {}
L64_1 = "contacts.list"
L65_1 = "photos.list"
L66_1 = "messages.send"
L67_1 = "bank.info"
L68_1 = "player.get"
L69_1 = "services.list"
L63_1[1] = L64_1
L63_1[2] = L65_1
L63_1[3] = L66_1
L63_1[4] = L67_1
L63_1[5] = L68_1
L63_1[6] = L69_1
L64_1 = {}
L65_1 = "sms"
L64_1["messages.send"] = L65_1
L65_1 = "contacts.list"
L66_1 = "contacts"
L64_1[L65_1] = L66_1
L65_1 = "photos.list"
L66_1 = "photos"
L64_1[L65_1] = L66_1
L65_1 = "bank.info"
L66_1 = "bank"
L64_1[L65_1] = L66_1
L65_1 = nil
function L66_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = L65_1
  if L0_2 then
    L0_2 = L65_1
    return L0_2
  end
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.ExternalApps
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.ExternalApps
    if L0_2 then
      goto lbl_18
    end
  end
  L0_2 = {}
  ::lbl_18::
  L1_2 = {}
  L2_2 = {}
  L3_2 = {}
  L4_2 = pairs
  L5_2 = type
  L6_2 = L0_2.rpc
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = L0_2.rpc
    if L5_2 then
      goto lbl_34
    end
  end
  L5_2 = L63_1
  ::lbl_34::
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L1_2[L9_2] = true
    else
      L10_2 = type
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      if "string" == L10_2 and L9_2 then
        L1_2[L8_2] = true
      end
    end
  end
  L4_2 = pairs
  L5_2 = L64_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L2_2[L8_2] = L9_2
    L3_2[L9_2] = true
  end
  L4_2 = type
  L5_2 = L0_2.sensitive
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = pairs
    L5_2 = L0_2.sensitive
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = type
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      if "string" == L10_2 then
        if false == L9_2 then
          L2_2[L8_2] = nil
        else
          L10_2 = type
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          if "string" == L10_2 then
            L10_2 = #L9_2
            if L10_2 <= 16 then
              L11_2 = L9_2
              L10_2 = L9_2.match
              L12_2 = "^[%w_]+$"
              L10_2 = L10_2(L11_2, L12_2)
              if L10_2 then
                L2_2[L8_2] = L9_2
                L3_2[L9_2] = true
              end
            end
          end
        end
      end
    end
  end
  L4_2 = type
  L5_2 = L0_2.rateLimit
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L0_2.rateLimit
    if L4_2 then
      goto lbl_109
    end
  end
  L4_2 = {}
  ::lbl_109::
  L5_2 = {}
  L5_2.rpc = L1_2
  L5_2.perms = L2_2
  L5_2.known = L3_2
  L6_2 = math
  L6_2 = L6_2.max
  L7_2 = 0.1
  L8_2 = tonumber
  L9_2 = L4_2.perSecond
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 1
  end
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.perSecond = L6_2
  L6_2 = math
  L6_2 = L6_2.max
  L7_2 = 1
  L8_2 = tonumber
  L9_2 = L4_2.burst
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 10
  end
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.burst = L6_2
  L6_2 = type
  L7_2 = L4_2.costs
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = L4_2.costs
    if L6_2 then
      goto lbl_147
    end
  end
  L6_2 = {}
  L6_2["messages.send"] = 3
  ::lbl_147::
  L5_2.costs = L6_2
  L6_2 = math
  L6_2 = L6_2.max
  L7_2 = 1
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = L0_2.maxGrants
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = 200
  end
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 200
  end
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.maxGrants = L6_2
  L65_1 = L5_2
  L5_2 = L65_1
  return L5_2
end
function L67_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 < 1) then
      L1_2 = #A0_2
      if not (L1_2 > 64) then
        L2_2 = A0_2
        L1_2 = A0_2.match
        L3_2 = "^[%w_%-%.:]+$"
        L1_2 = L1_2(L2_2, L3_2)
        if L1_2 then
          goto lbl_19
        end
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_19::
  return A0_2
end
L68_1 = {}
L69_1 = {}
L70_1 = {}
function L71_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2
  L3_2 = "\n"
  L4_2 = A1_2
  L2_2 = L2_2 .. L3_2 .. L4_2
  return L2_2
end
function L72_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L69_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return L1_2
  end
  L2_2 = {}
  L1_2 = L2_2
  L2_2 = ipairs
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT app, perm FROM apex_phone_app_grants WHERE owner = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L71_1
    L9_2 = tostring
    L10_2 = L7_2.app
    L9_2 = L9_2(L10_2)
    L10_2 = tostring
    L11_2 = L7_2.perm
    L10_2, L11_2 = L10_2(L11_2)
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L1_2[L8_2] = true
  end
  L2_2 = L69_1
  L2_2[A0_2] = L1_2
  return L1_2
end
function L73_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = L71_1
  L5_2 = A1_2
  L6_2 = A2_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L68_1
  L5_2 = L5_2[A0_2]
  if L5_2 then
    L6_2 = L5_2.cid
    if L6_2 == L3_2 then
      L6_2 = L5_2[L4_2]
      if L6_2 then
        L6_2 = true
        return L6_2
      end
    end
  end
  L6_2 = L72_1
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L6_2 = L6_2[L4_2]
  L6_2 = true == L6_2
  return L6_2
end
function L74_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = Config
  L3_2 = L3_2.RateLimit
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L3_2.enabled
    if false == L4_2 then
      L4_2 = true
      return L4_2
    end
  end
  L4_2 = L66_1
  L4_2 = L4_2()
  L5_2 = tonumber
  L6_2 = L4_2.costs
  L6_2 = L6_2[A2_2]
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 1
  end
  if L5_2 <= 0 then
    L6_2 = true
    return L6_2
  end
  L6_2 = "ext:"
  L7_2 = A1_2
  L6_2 = L6_2 .. L7_2
  L7_2 = L56_1
  L7_2 = L7_2[A0_2]
  if L7_2 then
    L7_2 = L56_1
    L7_2 = L7_2[A0_2]
    L7_2 = L7_2[L6_2]
    if L7_2 then
      goto lbl_51
    end
  end
  L7_2 = L70_1
  L7_2 = L7_2[A0_2]
  if not L7_2 then
    L7_2 = 0
  end
  L7_2 = L7_2 + 1
  if L7_2 > 16 then
    L8_2 = false
    return L8_2
  end
  L8_2 = L70_1
  L8_2[A0_2] = L7_2
  ::lbl_51::
  L7_2 = L60_1
  L8_2 = A0_2
  L9_2 = L6_2
  L10_2 = L4_2.perSecond
  L11_2 = L4_2.burst
  L12_2 = L5_2
  return L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
end
function L75_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = A0_2.type
  if "location" ~= L1_2 then
    L1_2 = A0_2.type
    if "contact" ~= L1_2 then
      goto lbl_10
    end
  end
  L1_2 = A0_2.type
  ::lbl_10::
  if not L1_2 then
    L1_2 = "text"
  end
  L2_2 = nil
  if "text" ~= L1_2 then
    L3_2 = type
    L4_2 = A0_2.payload
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = {}
      L2_2 = L3_2
      L3_2 = 0
      L4_2 = pairs
      L5_2 = A0_2.payload
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        if L3_2 >= 8 then
          break
        end
        L10_2 = type
        L11_2 = L8_2
        L10_2 = L10_2(L11_2)
        if "string" == L10_2 then
          L10_2 = #L8_2
          if L10_2 <= 16 then
            L10_2 = type
            L11_2 = L9_2
            L10_2 = L10_2(L11_2)
            if "number" == L10_2 and L9_2 == L9_2 then
              L10_2 = math
              L10_2 = L10_2.huge
              if L9_2 ~= L10_2 then
                L10_2 = math
                L10_2 = L10_2.huge
                L10_2 = -L10_2
                if L9_2 ~= L10_2 then
                  L2_2[L8_2] = L9_2
                  L3_2 = L3_2 + 1
              end
            end
            else
              L10_2 = type
              L11_2 = L9_2
              L10_2 = L10_2(L11_2)
              if "string" == L10_2 then
                L10_2 = L15_1
                L11_2 = L9_2
                L12_2 = 120
                L10_2 = L10_2(L11_2, L12_2)
                if not L10_2 then
                  L10_2 = ""
                end
                L2_2[L8_2] = L10_2
                L3_2 = L3_2 + 1
              end
            end
          end
        end
      end
    end
  end
  L3_2 = L15_1
  L4_2 = A0_2.to
  L5_2 = 40
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L5_2 = L3_2
    L4_2 = L3_2.match
    L6_2 = "^[%w %-%+%(%)%.]+$"
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L3_2 = nil
    end
  end
  L4_2 = {}
  L4_2.app = "sms"
  L4_2.to = L3_2
  L4_2.type = L1_2
  L5_2 = L15_1
  L6_2 = A0_2.content
  L7_2 = 1000
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = ""
  end
  L4_2.content = L5_2
  L4_2.payload = L2_2
  return L4_2
end
L76_1 = _ENV
L77_1 = "RegisterNetEvent"
L76_1 = L76_1[L77_1]
L77_1 = "apex_phone:server:rpc"
function L78_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L3_2 = source
  L4_2 = nil
  L5_2 = type
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  if "table" ~= L5_2 then
    L5_2 = {}
    A2_2 = L5_2
  end
  L5_2 = A2_2.__ext
  A2_2.__ext = nil
  L6_2 = type
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L6_2 = #A1_2
    if not (L6_2 > 64) then
      goto lbl_26
    end
  end
  L6_2 = {}
  L6_2.error = "unknown"
  L4_2 = L6_2
  goto lbl_297
  ::lbl_26::
  if nil ~= L5_2 then
    L6_2 = L67_1
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "forbidden"
      L4_2 = L6_2
  end
  else
    L6_2 = RateLimitAllow
    L7_2 = L3_2
    L8_2 = A1_2
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "ratelimit"
      L4_2 = L6_2
      L6_2 = Dbg
      L7_2 = "rpc"
      L8_2 = "%s <- %s rejected (ratelimit)"
      L9_2 = A1_2
      L10_2 = L3_2
      L6_2(L7_2, L8_2, L9_2, L10_2)
    else
      if nil ~= L5_2 then
        L6_2 = L74_1
        L7_2 = L3_2
        L8_2 = L5_2
        L9_2 = A1_2
        L6_2 = L6_2(L7_2, L8_2, L9_2)
        if not L6_2 then
          L6_2 = {}
          L6_2.error = "ratelimit"
          L4_2 = L6_2
          L6_2 = Dbg
          L7_2 = "rpc"
          L8_2 = "%s <- %s rejected (ratelimit of external app %s)"
          L9_2 = A1_2
          L10_2 = L3_2
          L11_2 = L5_2
          L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
      end
      else
        L6_2 = L62_1
        L6_2 = L6_2()
        if not L6_2 then
          L6_2 = {}
          L6_2.error = "db"
          L4_2 = L6_2
        else
          L6_2 = RPC
          L6_2 = L6_2[A1_2]
          L7_2 = nil == L5_2
          if nil ~= L5_2 and L7_2 and L6_2 then
            L8_2 = L66_1
            L8_2 = L8_2()
            L8_2 = L8_2.perms
            L8_2 = L8_2[A1_2]
            if L8_2 then
              goto lbl_110
            end
          end
          L8_2 = nil
          ::lbl_110::
          L9_2 = true
          if L8_2 then
            L10_2 = pcall
            L11_2 = L73_1
            L12_2 = L3_2
            L13_2 = L5_2
            L14_2 = L8_2
            L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
            L9_2 = L10_2 or L9_2
            L9_2 = L10_2 and true == L11_2
          end
          L10_2 = DeviceGuard
          if L10_2 and L6_2 and L7_2 and L9_2 then
            L10_2 = DeviceGuard
            L11_2 = L3_2
            L12_2 = A1_2
            L10_2 = L10_2(L11_2, L12_2)
            if L10_2 then
              goto lbl_141
            end
          end
          L10_2 = nil
          ::lbl_141::
          if not L7_2 then
            L11_2 = {}
            L11_2.error = "forbidden"
            L4_2 = L11_2
            L11_2 = Dbg
            L12_2 = "rpc"
            L13_2 = "%s <- %s rejected (external app %s not in the list)"
            L14_2 = A1_2
            L15_2 = L3_2
            L16_2 = L5_2
            L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
          elseif not L6_2 then
            L11_2 = {}
            L12_2 = "unknown:"
            L13_2 = A1_2
            L12_2 = L12_2 .. L13_2
            L11_2.error = L12_2
            L4_2 = L11_2
          elseif not L9_2 then
            L11_2 = {}
            L11_2.error = "nogrant"
            L4_2 = L11_2
            L11_2 = Dbg
            L12_2 = "rpc"
            L13_2 = "%s <- %s rejected (external app %s without permission \"%s\")"
            L14_2 = A1_2
            L15_2 = L3_2
            L16_2 = L5_2
            L17_2 = L8_2
            L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
          elseif L10_2 then
            L4_2 = L10_2
            L11_2 = Dbg
            L12_2 = "rpc"
            L13_2 = "%s <- %s rejected (another session: %s)"
            L14_2 = A1_2
            L15_2 = L3_2
            L16_2 = tostring
            L17_2 = L10_2.error
            if not L17_2 then
              L17_2 = "ok"
            end
            L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2)
            L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
          else
            if nil ~= L5_2 and "messages.send" == A1_2 then
              L11_2 = L75_1
              L12_2 = A2_2
              L11_2 = L11_2(L12_2)
              A2_2 = L11_2
            end
            L11_2 = GetGameTimer
            L11_2 = L11_2()
            L12_2 = pcall
            L13_2 = L6_2
            L14_2 = L3_2
            L15_2 = A2_2
            L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
            if not L12_2 then
              L14_2 = print
              L15_2 = "^1[unique_phone] rpc %s error: %s^0"
              L16_2 = L15_2
              L15_2 = L15_2.format
              L17_2 = A1_2
              L18_2 = tostring
              L19_2 = L13_2
              L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2)
              L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
              L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
              L14_2 = {}
              L14_2.error = "internal"
              L4_2 = L14_2
            elseif nil == L13_2 then
              L4_2 = false
            else
              L4_2 = L13_2
            end
            if nil ~= L5_2 and "player.get" == A1_2 then
              L14_2 = type
              L15_2 = L4_2
              L14_2 = L14_2(L15_2)
              if "table" == L14_2 then
                L14_2 = L4_2.money
                if nil ~= L14_2 then
                  L14_2 = pcall
                  L15_2 = L73_1
                  L16_2 = L3_2
                  L17_2 = L5_2
                  L18_2 = "bank"
                  L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
                  if not L14_2 or not L15_2 then
                    L4_2.money = nil
                  end
                end
              end
            end
            L14_2 = Dbg
            L15_2 = "rpc"
            L16_2 = "%s <- %s %d ms%s%s"
            L17_2 = A1_2
            L18_2 = L3_2
            L19_2 = GetGameTimer
            L19_2 = L19_2()
            L19_2 = L19_2 - L11_2
            if L5_2 then
              L20_2 = " ext="
              L21_2 = L5_2
              L20_2 = L20_2 .. L21_2
              if L20_2 then
                goto lbl_272
              end
            end
            L20_2 = ""
            ::lbl_272::
            L21_2 = type
            L22_2 = L4_2
            L21_2 = L21_2(L22_2)
            if "table" == L21_2 then
              L21_2 = L4_2.error
              if L21_2 then
                L21_2 = " erro="
                L22_2 = tostring
                L23_2 = L4_2.error
                L22_2 = L22_2(L23_2)
                L21_2 = L21_2 .. L22_2
                if L21_2 then
                  goto lbl_288
                end
              end
            end
            L21_2 = ""
            ::lbl_288::
            L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
            L14_2 = DeviceAfterRpc
            if L14_2 then
              L14_2 = DeviceAfterRpc
              L15_2 = L3_2
              L16_2 = A1_2
              L17_2 = L4_2
              L14_2(L15_2, L16_2, L17_2)
            end
          end
        end
      end
    end
  end
  ::lbl_297::
  L6_2 = TriggerClientEvent
  L7_2 = "apex_phone:client:rpcResult"
  L8_2 = L3_2
  L9_2 = A0_2
  L10_2 = L4_2
  L6_2(L7_2, L8_2, L9_2, L10_2)
end
L76_1(L77_1, L78_1)
L76_1 = _ENV
L77_1 = "RPC"
L76_1 = L76_1[L77_1]
L77_1 = "player.get"
function L78_1(A0_2)
  local L1_2, L2_2
  L1_2 = BuildPlayer
  L2_2 = A0_2
  return L1_2(L2_2)
end
L76_1[L77_1] = L78_1
function L76_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = Accounts
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return L1_2
  end
  L2_2 = L53_1
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_accounts WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L1_2 = L2_2
  if L1_2 then
    L2_2 = Accounts
    L2_2[A0_2] = L1_2
  end
  return L1_2
end
function L77_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    return A0_2
  end
  L1_2 = {}
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    if "pin" ~= L6_2 and "pin_len" ~= L6_2 then
      L1_2[L6_2] = L7_2
    end
  end
  L2_2 = A0_2.pin
  if nil ~= L2_2 then
    L2_2 = tostring
    L3_2 = A0_2.pin
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_30
    end
  end
  L2_2 = ""
  ::lbl_30::
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A0_2.pin_len
  L4_2, L5_2, L6_2, L7_2, L8_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L4_2 = "" ~= L2_2
  L1_2.hasPin = L4_2
  if "" == L2_2 then
    L1_2.pinLen = 0
  elseif 4 == L3_2 or 6 == L3_2 then
    L1_2.pinLen = L3_2
  else
    L4_2 = L45_1
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L1_2.pinLen = 4
    else
      L4_2 = L49_1
      L5_2 = L2_2
      L4_2 = L4_2(L5_2)
      L1_2.pinLen = L4_2
    end
  end
  return L1_2
end
L78_1 = _ENV
L79_1 = "RPC"
L78_1 = L78_1[L79_1]
L79_1 = "account.get"
function L80_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = L53_1
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_accounts WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = DeviceSessions
  if L3_2 then
    L3_2 = DeviceSessions
    L3_2 = L3_2[A0_2]
    if L3_2 then
      goto lbl_29
    end
  end
  L3_2 = nil
  ::lbl_29::
  if L2_2 then
    L4_2 = Accounts
    L4_2[L1_2] = L2_2
    if not L3_2 then
      L4_2 = SyncPhoneNumberState
      L5_2 = A0_2
      L6_2 = L2_2.phone
      L4_2(L5_2, L6_2)
    end
    L4_2 = SimEnsure
    if L4_2 then
      L4_2 = pcall
      L5_2 = SimEnsure
      L6_2 = L1_2
      L7_2 = L2_2
      L8_2 = A0_2 or L8_2
      if L3_2 or not A0_2 then
        L8_2 = nil
      end
      L4_2(L5_2, L6_2, L7_2, L8_2)
    end
  end
  if not L3_2 then
    L4_2 = FW
    L4_2 = L4_2.name
    if "standalone" == L4_2 then
      L4_2 = L2_1
      L4_2 = L4_2[A0_2]
      if L4_2 ~= L1_2 then
        L4_2 = L2_1
        L4_2[A0_2] = L1_2
        L4_2 = Push
        L5_2 = A0_2
        L6_2 = "session"
        L7_2 = {}
        L7_2.citizenid = L1_2
        L4_2(L5_2, L6_2, L7_2)
      end
    end
  end
  if not L3_2 then
    L4_2 = CreateThread
    function L5_2()
      local L0_3, L1_3
      L0_3 = Wait
      L1_3 = 1500
      L0_3(L1_3)
      L0_3 = DeliverPendingNotifications
      L1_3 = A0_2
      L0_3(L1_3)
    end
    L4_2(L5_2)
  end
  L4_2 = L77_1
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  if L3_2 then
    L5_2 = DeviceAccountView
    if L5_2 then
      L5_2 = DeviceAccountView
      L6_2 = A0_2
      L7_2 = L4_2
      L5_2 = L5_2(L6_2, L7_2)
      L4_2 = L5_2
    end
  end
  L5_2 = type
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if "table" ~= L5_2 then
    L5_2 = {}
    L5_2.none = true
    return L5_2
  end
  return L4_2
end
L78_1[L79_1] = L80_1
L78_1 = _ENV
L79_1 = "RPC"
L78_1 = L78_1[L79_1]
function L79_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = tostring
  L3_2 = A1_2.username
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE username = ? AND citizenid <> ?"
  L5_2 = {}
  L6_2 = L2_2
  L7_2 = GetCid
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = ""
  end
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = {}
  L5_2 = L3_2 or L5_2
  if not L3_2 then
    L5_2 = 0
  end
  L5_2 = 0 == L5_2
  L4_2.ok = L5_2
  return L4_2
end
L78_1["account.usernameFree"] = L79_1
function L78_1(A0_2)
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
L79_1 = _ENV
L80_1 = "RPC"
L79_1 = L79_1[L80_1]
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L2_2.cid
  L4_2 = tostring
  L5_2 = A1_2.username
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.lower
  L4_2 = L4_2(L5_2)
  L6_2 = L4_2
  L5_2 = L4_2.match
  L7_2 = "^[a-z0-9_%.]+$"
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L5_2 = #L4_2
    if not (L5_2 < 3) then
      L5_2 = #L4_2
      if not (L5_2 > 16) then
        goto lbl_35
      end
    end
  end
  L5_2 = {}
  L5_2.error = "invalid"
  do return L5_2 end
  ::lbl_35::
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT username FROM apex_phone_accounts WHERE citizenid = ?"
  L7_2 = {}
  L8_2 = L3_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L6_2 = tostring
    L7_2 = L5_2.username
    if not L7_2 then
      L7_2 = ""
    end
    L6_2 = L6_2(L7_2)
    if "" ~= L6_2 then
      L6_2 = {}
      L6_2.error = "exists"
      return L6_2
    end
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = "DELETE FROM apex_phone_accounts WHERE citizenid = ? AND username = ''"
    L8_2 = {}
    L9_2 = L3_2
    L8_2[1] = L9_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE username = ? AND citizenid <> ?"
  L8_2 = {}
  L9_2 = L4_2
  L10_2 = L3_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L6_2 or L7_2
  if not L6_2 then
    L7_2 = 0
  end
  if L7_2 > 0 then
    L7_2 = {}
    L7_2.error = "taken"
    return L7_2
  end
  L7_2 = nil
  L8_2 = A1_2.pin
  if nil == L8_2 then
    L8_2 = tostring
    L9_2 = Config
    L9_2 = L9_2.DefaultPin
    if not L9_2 then
      L9_2 = ""
    end
    L8_2 = L8_2(L9_2)
    L9_2 = L8_2
    L8_2 = L8_2.sub
    L10_2 = 1
    L11_2 = 10
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L7_2 = L8_2
  else
    L8_2 = tostring
    L9_2 = A1_2.pin
    L8_2 = L8_2(L9_2)
    L9_2 = L8_2
    L8_2 = L8_2.sub
    L10_2 = 1
    L11_2 = 10
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L7_2 = L8_2
    if "" ~= L7_2 then
      L9_2 = L7_2
      L8_2 = L7_2.match
      L10_2 = "^%d%d%d%d$"
      L8_2 = L8_2(L9_2, L10_2)
      if not L8_2 then
        L9_2 = L7_2
        L8_2 = L7_2.match
        L10_2 = "^%d%d%d%d%d%d$"
        L8_2 = L8_2(L9_2, L10_2)
        if not L8_2 then
          L8_2 = {}
          L8_2.error = "badpin"
          return L8_2
        end
      end
    end
  end
  L8_2 = L2_2.phone
  L9_2 = IntegrationCall
  if L9_2 then
    L9_2 = pcall
    L10_2 = IntegrationCall
    L11_2 = "number"
    L12_2 = "assign"
    L13_2 = L3_2
    L14_2 = A0_2
    L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    if L9_2 then
      L11_2 = type
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if "string" ~= L11_2 then
        L11_2 = type
        L12_2 = L10_2
        L11_2 = L11_2(L12_2)
        if "number" ~= L11_2 then
          goto lbl_204
        end
      end
      L11_2 = tostring
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if "" ~= L11_2 then
        L11_2 = tostring
        L12_2 = L10_2
        L11_2 = L11_2(L12_2)
        L12_2 = L11_2
        L11_2 = L11_2.sub
        L13_2 = 1
        L14_2 = 20
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        L12_2 = MySQL
        L12_2 = L12_2.scalar
        L12_2 = L12_2.await
        L13_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE phone = ? AND citizenid <> ?"
        L14_2 = {}
        L15_2 = L11_2
        L16_2 = L3_2
        L14_2[1] = L15_2
        L14_2[2] = L16_2
        L12_2 = L12_2(L13_2, L14_2)
        L13_2 = SimLineOwner
        if L13_2 then
          L13_2 = SimLineOwner
          L14_2 = L11_2
          L13_2 = L13_2(L14_2)
          if L13_2 then
            goto lbl_181
          end
        end
        L13_2 = nil
        ::lbl_181::
        L14_2 = tonumber
        L15_2 = L12_2
        L14_2 = L14_2(L15_2)
        if not L14_2 then
          L14_2 = 0
        end
        if L14_2 > 0 or L13_2 and L13_2 ~= L3_2 then
          L14_2 = print
          L15_2 = "^3[unique_phone]^0 number integration gave %s to %s but another account already has it: using the phone's own choice"
          L16_2 = L15_2
          L15_2 = L15_2.format
          L17_2 = L11_2
          L18_2 = tostring
          L19_2 = L3_2
          L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L18_2(L19_2)
          L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
          L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
        else
          L8_2 = L11_2
        end
      end
    end
  end
  ::lbl_204::
  if not L8_2 or "" == L8_2 then
    L9_2 = L35_1
    L9_2 = L9_2()
    L8_2 = L9_2
  end
  L9_2 = MySQL
  L9_2 = L9_2.scalar
  L9_2 = L9_2.await
  L10_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE phone = ? AND citizenid <> ?"
  L11_2 = {}
  L12_2 = L8_2
  L13_2 = L3_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = L9_2 or L10_2
  if not L9_2 then
    L10_2 = 0
  end
  if L10_2 > 0 then
    L10_2 = L35_1
    L10_2 = L10_2()
    L8_2 = L10_2
  end
  L10_2 = L49_1
  L11_2 = L7_2
  L10_2 = L10_2(L11_2)
  L11_2 = {}
  L11_2.citizenid = L3_2
  L12_2 = "RK-"
  L13_2 = tostring
  L14_2 = math
  L14_2 = L14_2.random
  L15_2 = 100000
  L16_2 = 999999
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L14_2(L15_2, L16_2)
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  L12_2 = L12_2 .. L13_2
  L11_2.account_id = L12_2
  L11_2.username = L4_2
  L11_2.phone = L8_2
  L12_2 = L50_1
  L13_2 = L7_2
  L12_2 = L12_2(L13_2)
  L11_2.pin = L12_2
  L11_2.pin_len = L10_2
  L12_2 = tonumber
  L13_2 = A1_2.avatar
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 1
  end
  L11_2.avatar = L12_2
  L12_2 = "IP18PM-%06d"
  L13_2 = L12_2
  L12_2 = L12_2.format
  L14_2 = math
  L14_2 = L14_2.random
  L15_2 = 0
  L16_2 = 999999
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L14_2(L15_2, L16_2)
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  L11_2.device_id = L12_2
  L12_2 = "SIM-%08d"
  L13_2 = L12_2
  L12_2 = L12_2.format
  L14_2 = math
  L14_2 = L14_2.random
  L15_2 = 0
  L16_2 = 99999999
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L14_2(L15_2, L16_2)
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  L11_2.sim_id = L12_2
  L12_2 = A1_2.settings
  L11_2.settings = L12_2
  L11_2.layout = nil
  L12_2 = L4_1
  L12_2 = L12_2()
  L11_2.created = L12_2
  L12_2 = type
  L13_2 = A1_2.face
  L12_2 = L12_2(L13_2)
  if "string" == L12_2 then
    L12_2 = A1_2.face
    if "" ~= L12_2 then
      L12_2 = A1_2.face
      L12_2 = #L12_2
      L13_2 = 120000
      if L12_2 <= L13_2 then
        L12_2 = A1_2.face
        L13_2 = L12_2
        L12_2 = L12_2.match
        L14_2 = "^data:image/"
        L12_2 = L12_2(L13_2, L14_2)
        if L12_2 then
          L12_2 = A1_2.face
          if L12_2 then
            goto lbl_306
          end
        end
      end
    end
  end
  L12_2 = nil
  ::lbl_306::
  L11_2.face = L12_2
  L13_2 = A1_2.settings
  if L13_2 then
    L13_2 = json
    L13_2 = L13_2.encode
    L14_2 = A1_2.settings
    L13_2 = L13_2(L14_2)
    if L13_2 then
      goto lbl_317
    end
  end
  L13_2 = nil
  ::lbl_317::
  L14_2 = false
  L15_2 = 1
  L16_2 = 5
  L17_2 = 1
  for L18_2 = L15_2, L16_2, L17_2 do
    L11_2.phone = L8_2
    L19_2 = pcall
    function L20_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
      L0_3 = L3_1
      if L0_3 then
        L0_3 = MySQL
        L0_3 = L0_3.insert
        L0_3 = L0_3.await
        L1_3 = [[
INSERT INTO apex_phone_accounts (citizenid, account_id, username, phone, pin, pin_len, avatar, device_id, sim_id, settings, layout, face, created)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL, ?, ?)]]
        L2_3 = {}
        L3_3 = L3_2
        L4_3 = L11_2.account_id
        L5_3 = L4_2
        L6_3 = L8_2
        L7_3 = L11_2.pin
        L8_3 = L10_2
        L9_3 = L11_2.avatar
        L10_3 = L11_2.device_id
        L11_3 = L11_2.sim_id
        L12_3 = L13_2
        L13_3 = L12_2
        L14_3 = L11_2.created
        L2_3[1] = L3_3
        L2_3[2] = L4_3
        L2_3[3] = L5_3
        L2_3[4] = L6_3
        L2_3[5] = L7_3
        L2_3[6] = L8_3
        L2_3[7] = L9_3
        L2_3[8] = L10_3
        L2_3[9] = L11_3
        L2_3[10] = L12_3
        L2_3[11] = L13_3
        L2_3[12] = L14_3
        L0_3(L1_3, L2_3)
      else
        L0_3 = MySQL
        L0_3 = L0_3.insert
        L0_3 = L0_3.await
        L1_3 = [[
INSERT INTO apex_phone_accounts (citizenid, account_id, username, phone, pin, avatar, device_id, sim_id, settings, layout, face, created)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NULL, ?, ?)]]
        L2_3 = {}
        L3_3 = L3_2
        L4_3 = L11_2.account_id
        L5_3 = L4_2
        L6_3 = L8_2
        L7_3 = L11_2.pin
        L8_3 = L11_2.avatar
        L9_3 = L11_2.device_id
        L10_3 = L11_2.sim_id
        L11_3 = L13_2
        L12_3 = L12_2
        L13_3 = L11_2.created
        L2_3[1] = L3_3
        L2_3[2] = L4_3
        L2_3[3] = L5_3
        L2_3[4] = L6_3
        L2_3[5] = L7_3
        L2_3[6] = L8_3
        L2_3[7] = L9_3
        L2_3[8] = L10_3
        L2_3[9] = L11_3
        L2_3[10] = L12_3
        L2_3[11] = L13_3
        L0_3(L1_3, L2_3)
      end
    end
    L19_2, L20_2 = L19_2(L20_2)
    if L19_2 then
      L14_2 = true
      break
    end
    L21_2 = L78_1
    L22_2 = L20_2
    L21_2 = L21_2(L22_2)
    if not L21_2 then
      L21_2 = error
      L22_2 = L20_2
      L23_2 = 0
      L21_2(L22_2, L23_2)
    end
    L21_2 = tonumber
    L22_2 = MySQL
    L22_2 = L22_2.scalar
    L22_2 = L22_2.await
    L23_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE citizenid = ?"
    L24_2 = {}
    L25_2 = L3_2
    L24_2[1] = L25_2
    L22_2, L23_2, L24_2, L25_2 = L22_2(L23_2, L24_2)
    L21_2 = L21_2(L22_2, L23_2, L24_2, L25_2)
    if not L21_2 then
      L21_2 = 0
    end
    if L21_2 > 0 then
      L21_2 = {}
      L21_2.error = "exists"
      return L21_2
    end
    L21_2 = tonumber
    L22_2 = MySQL
    L22_2 = L22_2.scalar
    L22_2 = L22_2.await
    L23_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE username = ?"
    L24_2 = {}
    L25_2 = L4_2
    L24_2[1] = L25_2
    L22_2, L23_2, L24_2, L25_2 = L22_2(L23_2, L24_2)
    L21_2 = L21_2(L22_2, L23_2, L24_2, L25_2)
    if not L21_2 then
      L21_2 = 0
    end
    if L21_2 > 0 then
      L21_2 = {}
      L21_2.error = "taken"
      return L21_2
    end
    L21_2 = Dbg
    L22_2 = "account"
    L23_2 = "number %s taken in the meantime by another account: trying another one"
    L24_2 = L8_2
    L21_2(L22_2, L23_2, L24_2)
    L21_2 = L35_1
    L21_2 = L21_2()
    L8_2 = L21_2
  end
  if not L14_2 then
    L15_2 = {}
    L15_2.error = "busy"
    return L15_2
  end
  L15_2 = Accounts
  L15_2[L3_2] = L11_2
  L15_2 = L1_1
  L15_2[L3_2] = nil
  L15_2 = L36_1
  L16_2 = A0_2
  L17_2 = L8_2
  L15_2(L16_2, L17_2)
  L15_2 = SyncPhoneNumberState
  L16_2 = A0_2
  L17_2 = L8_2
  L15_2(L16_2, L17_2)
  L15_2 = TriggerEvent
  L16_2 = "apex_phone:accountCreated"
  L17_2 = L3_2
  L18_2 = L8_2
  L19_2 = A0_2
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = SimSetOptOut
  if L15_2 then
    L15_2 = pcall
    L16_2 = SimSetOptOut
    L17_2 = L3_2
    L18_2 = type
    L19_2 = A1_2
    L18_2 = L18_2(L19_2)
    L18_2 = "table" == L18_2
    L15_2(L16_2, L17_2, L18_2)
  end
  L15_2 = SimEnsure
  if L15_2 then
    L15_2 = pcall
    L16_2 = SimEnsure
    L17_2 = L3_2
    L18_2 = L11_2
    L19_2 = A0_2
    L15_2(L16_2, L17_2, L18_2, L19_2)
  end
  L15_2 = Config
  L15_2 = L15_2.AutoMails
  if L15_2 then
    L15_2 = Config
    L15_2 = L15_2.WelcomeMail
    if L15_2 then
      L15_2 = MySQL
      L15_2 = L15_2.insert
      L16_2 = "INSERT INTO apex_phone_mail (owner, sender, email, subject, body, `read`, folder, created) VALUES (?, ?, ?, ?, ?, 0, \"inbox\", ?)"
      L17_2 = {}
      L18_2 = L3_2
      L19_2 = Config
      L19_2 = L19_2.WelcomeMail
      L19_2 = L19_2.sender
      L20_2 = "hello@arshiahub.ir"
      L21_2 = Config
      L21_2 = L21_2.WelcomeMail
      L21_2 = L21_2.subject
      L22_2 = Config
      L22_2 = L22_2.WelcomeMail
      L22_2 = L22_2.body
      if not L22_2 then
        L22_2 = ""
      end
      L23_2 = L22_2
      L22_2 = L22_2.gsub
      L24_2 = "%%s"
      L25_2 = L8_2
      L22_2 = L22_2(L23_2, L24_2, L25_2)
      L23_2 = L4_1
      L23_2, L24_2, L25_2 = L23_2()
      L17_2[1] = L18_2
      L17_2[2] = L19_2
      L17_2[3] = L20_2
      L17_2[4] = L21_2
      L17_2[5] = L22_2
      L17_2[6] = L23_2
      L17_2[7] = L24_2
      L17_2[8] = L25_2
      L15_2(L16_2, L17_2)
    end
  end
  L15_2 = L77_1
  L16_2 = L11_2
  return L15_2(L16_2)
end
L79_1["account.create"] = L80_1
function L79_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = Config
  L0_2 = L0_2.AccountMaxBytes
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L1_2 = math
    L1_2 = L1_2.max
    L2_2 = 0
    L3_2 = math
    L3_2 = L3_2.floor
    L4_2 = L0_2
    L3_2 = L3_2(L4_2)
    L1_2 = L1_2(L2_2, L3_2)
    L2_2 = L1_2
    L3_2 = L1_2
    return L2_2, L3_2
  end
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
    L0_2 = L1_2
  end
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 0
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = tonumber
  L5_2 = L0_2.settings
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 400000
  end
  L3_2 = L3_2(L4_2)
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 0
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = tonumber
  L6_2 = L0_2.layout
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 64000
  end
  L4_2 = L4_2(L5_2)
  L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2, L4_2)
  return L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
end
L80_1 = _ENV
L81_1 = "RPC"
L80_1 = L80_1[L81_1]
L81_1 = "account.update"
function L82_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = Accounts
  L3_2 = L3_2[L2_2]
  if not L3_2 then
    L3_2 = L53_1
    L4_2 = MySQL
    L4_2 = L4_2.single
    L4_2 = L4_2.await
    L5_2 = "SELECT * FROM apex_phone_accounts WHERE citizenid = ?"
    L6_2 = {}
    L7_2 = L2_2
    L6_2[1] = L7_2
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2(L5_2, L6_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  end
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "noacc"
    return L4_2
  end
  L4_2 = L79_1
  L4_2, L5_2 = L4_2()
  L6_2 = nil
  L7_2 = nil
  L8_2 = A1_2.settings
  if nil ~= L8_2 then
    L8_2 = pcall
    L9_2 = json
    L9_2 = L9_2.encode
    L10_2 = A1_2.settings
    L8_2, L9_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "string" == L10_2 then
        goto lbl_53
      end
    end
    L10_2 = {}
    L10_2.error = "invalid"
    do return L10_2 end
    ::lbl_53::
    if L4_2 > 0 then
      L10_2 = #L9_2
      if L4_2 < L10_2 then
        L10_2 = Dbg
        L11_2 = "account"
        L12_2 = "account.update rejected for %s: settings with %d characters (limit %d)"
        L13_2 = tostring
        L14_2 = L2_2
        L13_2 = L13_2(L14_2)
        L14_2 = #L9_2
        L15_2 = L4_2
        L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
        L10_2 = {}
        L10_2.error = "toolarge"
        return L10_2
      end
    end
    L6_2 = L9_2
  end
  L8_2 = A1_2.layout
  if nil ~= L8_2 then
    L8_2 = pcall
    L9_2 = json
    L9_2 = L9_2.encode
    L10_2 = A1_2.layout
    L8_2, L9_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "string" == L10_2 then
        goto lbl_91
      end
    end
    L10_2 = {}
    L10_2.error = "invalid"
    do return L10_2 end
    ::lbl_91::
    if L5_2 > 0 then
      L10_2 = #L9_2
      if L5_2 < L10_2 then
        L10_2 = Dbg
        L11_2 = "account"
        L12_2 = "account.update rejected for %s: layout with %d characters (limit %d)"
        L13_2 = tostring
        L14_2 = L2_2
        L13_2 = L13_2(L14_2)
        L14_2 = #L9_2
        L15_2 = L5_2
        L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
        L10_2 = {}
        L10_2.error = "toolarge"
        return L10_2
      end
    end
    L7_2 = L9_2
  end
  L8_2 = A1_2.username
  if L8_2 then
    L8_2 = tostring
    L9_2 = A1_2.username
    L8_2 = L8_2(L9_2)
    L9_2 = L8_2
    L8_2 = L8_2.lower
    L8_2 = L8_2(L9_2)
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE username = ? AND citizenid <> ?"
    L11_2 = {}
    L12_2 = L8_2
    L13_2 = L2_2
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = L9_2 or L10_2
    if not L9_2 then
      L10_2 = 0
    end
    if L10_2 > 0 then
      L10_2 = {}
      L10_2.error = "taken"
      return L10_2
    end
    L3_2.username = L8_2
  end
  L8_2 = A1_2.avatar
  if nil ~= L8_2 then
    L8_2 = tonumber
    L9_2 = A1_2.avatar
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L8_2 = L3_2.avatar
    end
    L3_2.avatar = L8_2
  end
  L8_2 = A1_2.settings
  if nil ~= L8_2 then
    L8_2 = A1_2.settings
    L3_2.settings = L8_2
  end
  L8_2 = A1_2.layout
  if nil ~= L8_2 then
    L8_2 = A1_2.layout
    L3_2.layout = L8_2
  end
  L8_2 = {}
  L9_2 = {}
  L10_2 = A1_2.username
  if L10_2 then
    L10_2 = #L8_2
    L10_2 = L10_2 + 1
    L8_2[L10_2] = "username = ?"
    L10_2 = #L9_2
    L10_2 = L10_2 + 1
    L11_2 = L3_2.username
    L9_2[L10_2] = L11_2
  end
  L10_2 = A1_2.avatar
  if nil ~= L10_2 then
    L10_2 = #L8_2
    L10_2 = L10_2 + 1
    L8_2[L10_2] = "avatar = ?"
    L10_2 = #L9_2
    L10_2 = L10_2 + 1
    L11_2 = L3_2.avatar
    L9_2[L10_2] = L11_2
  end
  if L6_2 then
    L10_2 = #L8_2
    L10_2 = L10_2 + 1
    L8_2[L10_2] = "settings = ?"
    L10_2 = #L9_2
    L10_2 = L10_2 + 1
    L9_2[L10_2] = L6_2
  end
  if L7_2 then
    L10_2 = #L8_2
    L10_2 = L10_2 + 1
    L8_2[L10_2] = "layout = ?"
    L10_2 = #L9_2
    L10_2 = L10_2 + 1
    L9_2[L10_2] = L7_2
  end
  L10_2 = #L8_2
  if L10_2 > 0 then
    L10_2 = #L9_2
    L10_2 = L10_2 + 1
    L9_2[L10_2] = L2_2
    L10_2 = MySQL
    L10_2 = L10_2.update
    L11_2 = "UPDATE apex_phone_accounts SET "
    L12_2 = table
    L12_2 = L12_2.concat
    L13_2 = L8_2
    L14_2 = ", "
    L12_2 = L12_2(L13_2, L14_2)
    L13_2 = " WHERE citizenid = ?"
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = L9_2
    L10_2(L11_2, L12_2)
  end
  L10_2 = Accounts
  L10_2[L2_2] = L3_2
  L10_2 = {}
  L10_2.ok = true
  return L10_2
end
L80_1[L81_1] = L82_1
L80_1 = _ENV
L81_1 = "RPC"
L80_1 = L80_1[L81_1]
function L81_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2.face
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.face
    if L3_2 then
      goto lbl_19
    end
  end
  L3_2 = nil
  ::lbl_19::
  if "" == L3_2 then
    L3_2 = nil
  end
  if L3_2 then
    L4_2 = #L3_2
    L5_2 = 120000
    if not (L4_2 > L5_2) then
      L5_2 = L3_2
      L4_2 = L3_2.match
      L6_2 = "^data:image/"
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        goto lbl_38
      end
    end
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "badimage"
    return L4_2
  end
  ::lbl_38::
  L4_2 = MySQL
  L4_2 = L4_2.update
  L5_2 = "UPDATE apex_phone_accounts SET face = ? WHERE citizenid = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = Accounts
  L4_2 = L4_2[L2_2]
  if L4_2 then
    L4_2.face = L3_2
  end
  L5_2 = {}
  L5_2.ok = true
  L6_2 = nil ~= L3_2
  L5_2.has = L6_2
  return L5_2
end
L80_1["account.setFace"] = L81_1
L80_1 = _ENV
L81_1 = "RPC"
L80_1 = L80_1[L81_1]
function L81_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = type
    L4_2 = A1_2.photo
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L3_2 = A1_2.photo
      if L3_2 then
        goto lbl_24
      end
    end
  end
  L3_2 = nil
  ::lbl_24::
  if "" == L3_2 then
    L3_2 = nil
  end
  if L3_2 then
    L4_2 = #L3_2
    L5_2 = 120000
    if not (L4_2 > L5_2) then
      L5_2 = L3_2
      L4_2 = L3_2.match
      L6_2 = "^data:image/"
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        goto lbl_43
      end
    end
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "badimage"
    return L4_2
  end
  ::lbl_43::
  L4_2 = MySQL
  L4_2 = L4_2.update
  L5_2 = "UPDATE apex_phone_accounts SET avatar_photo = ? WHERE citizenid = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = Accounts
  L4_2 = L4_2[L2_2]
  if L4_2 then
    L4_2.avatarPhoto = L3_2
  end
  L5_2 = {}
  L5_2.ok = true
  L6_2 = nil ~= L3_2
  L5_2.has = L6_2
  return L5_2
end
L80_1["account.setAvatarPhoto"] = L81_1
function L80_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = Config
  L0_2 = L0_2.PinLock
  if false == L0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
    L0_2 = L1_2
  end
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 1
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = L0_2.attempts
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 5
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 5
  end
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L0_2.seconds
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L0_2.seconds
    L2_2 = #L2_2
    if L2_2 > 0 then
      L2_2 = L0_2.seconds
      if L2_2 then
        goto lbl_52
      end
    end
  end
  L2_2 = {}
  L3_2 = 30
  L4_2 = 60
  L5_2 = 300
  L6_2 = 900
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  ::lbl_52::
  L3_2 = L1_2
  L4_2 = L2_2
  return L3_2, L4_2
end
function L81_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L1_1
  L1_2 = L1_2[A0_2]
  L2_2 = L4_1
  L2_2 = L2_2()
  if L1_2 then
    L3_2 = L1_2.lockedUntil
    if not L3_2 then
      L3_2 = 0
    end
    if L2_2 < L3_2 then
      L3_2 = L1_2.lockedUntil
      L4_2 = math
      L4_2 = L4_2.ceil
      L5_2 = L1_2.lockedUntil
      L5_2 = L5_2 - L2_2
      L5_2 = L5_2 / 1000
      L4_2, L5_2 = L4_2(L5_2)
      return L3_2, L4_2, L5_2
    end
  end
  L3_2 = nil
  return L3_2
end
function L82_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L80_1
  L1_2, L2_2 = L1_2()
  if not L1_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L1_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = {}
    L3_2.fails = 0
    L3_2.lockedUntil = 0
  end
  L4_2 = L1_1
  L4_2[A0_2] = L3_2
  L4_2 = L3_2.fails
  L4_2 = L4_2 + 1
  L3_2.fails = L4_2
  L4_2 = L3_2.fails
  if L1_2 > L4_2 then
    L4_2 = L3_2.fails
    L4_2 = L1_2 - L4_2
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.min
  L5_2 = L3_2.fails
  L5_2 = L5_2 - L1_2
  L5_2 = L5_2 + 1
  L6_2 = #L2_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = math
  L5_2 = L5_2.max
  L6_2 = 1
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = tonumber
  L9_2 = L2_2[L4_2]
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 60
  end
  L7_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L4_1
  L6_2 = L6_2()
  L7_2 = L5_2 * 1000
  L6_2 = L6_2 + L7_2
  L3_2.lockedUntil = L6_2
  L6_2 = Dbg
  L7_2 = "pin"
  L8_2 = "cid=%s locked for %d s (%d failures)"
  L9_2 = A0_2
  L10_2 = L5_2
  L11_2 = L3_2.fails
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = 0
  L7_2 = L3_2.lockedUntil
  L8_2 = L5_2
  return L6_2, L7_2, L8_2
end
function L83_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L3_1
  if L3_2 then
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "UPDATE apex_phone_accounts SET pin = ?, pin_len = ? WHERE citizenid = ?"
    L5_2 = {}
    L6_2 = A1_2
    L7_2 = A2_2
    L8_2 = A0_2
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L5_2[3] = L8_2
    L3_2(L4_2, L5_2)
  else
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "UPDATE apex_phone_accounts SET pin = ? WHERE citizenid = ?"
    L5_2 = {}
    L6_2 = A1_2
    L7_2 = A0_2
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L3_2(L4_2, L5_2)
  end
end
function L84_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L3_1
  if not L3_2 then
    return
  end
  L3_2 = tostring
  L4_2 = A1_2.pin
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L46_1
  L5_2 = L3_2
  L4_2, L5_2 = L4_2(L5_2)
  L6_2 = L45_1
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  if L6_2 and L5_2 then
    L6_2 = L42_1
    L6_2 = L6_2()
    if L5_2 ~= L6_2 then
      goto lbl_26
    end
  end
  do return end
  ::lbl_26::
  L6_2 = L44_1
  L7_2 = A2_2
  L6_2 = L6_2(L7_2)
  L7_2 = L49_1
  L8_2 = A2_2
  L7_2 = L7_2(L8_2)
  L8_2 = L6_2
  A1_2.pin_len = L7_2
  A1_2.pin = L8_2
  L8_2 = MySQL
  L8_2 = L8_2.update
  L9_2 = "UPDATE apex_phone_accounts SET pin = ?, pin_len = ? WHERE citizenid = ? AND pin = ?"
  L10_2 = {}
  L11_2 = L6_2
  L12_2 = L7_2
  L13_2 = A0_2
  L14_2 = L3_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L8_2(L9_2, L10_2)
end
L85_1 = _ENV
L86_1 = "RPC"
L85_1 = L85_1[L86_1]
function L86_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = L76_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = L3_2.pin
  if nil ~= L4_2 then
    L4_2 = tostring
    L5_2 = L3_2.pin
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_28
    end
  end
  L4_2 = ""
  ::lbl_28::
  if "" == L4_2 then
    L5_2 = {}
    L5_2.ok = true
    return L5_2
  end
  L5_2 = L81_1
  L6_2 = L2_2
  L5_2, L6_2 = L5_2(L6_2)
  if L5_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.attempts = 0
    L7_2.lockedUntil = L5_2
    L7_2.wait = L6_2
    return L7_2
  end
  L7_2 = tostring
  L8_2 = A1_2.pin
  if not L8_2 then
    L8_2 = ""
  end
  L7_2 = L7_2(L8_2)
  L8_2 = L7_2
  L7_2 = L7_2.sub
  L9_2 = 1
  L10_2 = 10
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = L48_1
  L9_2 = L4_2
  L10_2 = L7_2
  L8_2 = L8_2(L9_2, L10_2)
  if L8_2 then
    L8_2 = L1_1
    L8_2[L2_2] = nil
    L8_2 = L84_1
    L9_2 = L2_2
    L10_2 = L3_2
    L11_2 = L7_2
    L8_2(L9_2, L10_2, L11_2)
    L8_2 = {}
    L8_2.ok = true
    return L8_2
  end
  L8_2 = L82_1
  L9_2 = L2_2
  L8_2, L9_2, L10_2 = L8_2(L9_2)
  L11_2 = {}
  L11_2.ok = false
  L11_2.attempts = L8_2
  L11_2.lockedUntil = L9_2
  L11_2.wait = L10_2
  return L11_2
end
L85_1["account.verifyPin"] = L86_1
L85_1 = _ENV
L86_1 = "RPC"
L85_1 = L85_1[L86_1]
function L86_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L76_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "noacc"
    return L4_2
  end
  L4_2 = L3_2.pin
  if nil ~= L4_2 then
    L4_2 = tostring
    L5_2 = L3_2.pin
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_30
    end
  end
  L4_2 = ""
  ::lbl_30::
  if "" ~= L4_2 then
    L5_2 = L81_1
    L6_2 = L2_2
    L5_2, L6_2 = L5_2(L6_2)
    if L5_2 then
      L7_2 = {}
      L7_2.ok = false
      L7_2.error = "locked"
      L7_2.attempts = 0
      L7_2.lockedUntil = L5_2
      L7_2.wait = L6_2
      return L7_2
    end
    L7_2 = L48_1
    L8_2 = L4_2
    L9_2 = A1_2.old
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = L82_1
      L8_2 = L2_2
      L7_2, L8_2, L9_2 = L7_2(L8_2)
      L10_2 = {}
      L10_2.ok = false
      if L8_2 then
        L11_2 = "locked"
        if L11_2 then
          goto lbl_63
        end
      end
      L11_2 = "badpin"
      ::lbl_63::
      L10_2.error = L11_2
      L10_2.attempts = L7_2
      L10_2.lockedUntil = L8_2
      L10_2.wait = L9_2
      return L10_2
    end
    L7_2 = L1_1
    L7_2[L2_2] = nil
  end
  L5_2 = A1_2.new
  if nil == L5_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = tostring
  L6_2 = A1_2.new
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  L5_2 = L5_2.sub
  L7_2 = 1
  L8_2 = 10
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if "" ~= L5_2 then
    L7_2 = L5_2
    L6_2 = L5_2.match
    L8_2 = "^%d%d%d%d$"
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L7_2 = L5_2
      L6_2 = L5_2.match
      L8_2 = "^%d%d%d%d%d%d$"
      L6_2 = L6_2(L7_2, L8_2)
      if not L6_2 then
        L6_2 = {}
        L6_2.ok = false
        L6_2.error = "invalid"
        return L6_2
      end
    end
  end
  L6_2 = L50_1
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L7_2 = L49_1
  L8_2 = L5_2
  L7_2 = L7_2(L8_2)
  L8_2 = L83_1
  L9_2 = L2_2
  L10_2 = L6_2
  L11_2 = L7_2
  L8_2(L9_2, L10_2, L11_2)
  L8_2 = L6_2
  L3_2.pin_len = L7_2
  L3_2.pin = L8_2
  L8_2 = Accounts
  L8_2 = L8_2[L2_2]
  if L8_2 then
    L8_2 = Accounts
    L8_2 = L8_2[L2_2]
    if L8_2 ~= L3_2 then
      L8_2 = Accounts
      L8_2 = L8_2[L2_2]
      L9_2 = Accounts
      L9_2 = L9_2[L2_2]
      L10_2 = L6_2
      L9_2.pin_len = L7_2
      L8_2.pin = L10_2
    end
  end
  L8_2 = {}
  L8_2.ok = true
  L9_2 = "" ~= L5_2
  L8_2.hasPin = L9_2
  L8_2.pinLen = L7_2
  return L8_2
end
L85_1["account.setPin"] = L86_1
L85_1 = _ENV
L86_1 = "RPC"
L85_1 = L85_1[L86_1]
function L86_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = Config
  L1_2 = L1_2.AllowSimSwap
  if not L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = Accounts
  L2_2 = L2_2[L1_2]
  if not L2_2 then
    L2_2 = L53_1
    L3_2 = MySQL
    L3_2 = L3_2.single
    L3_2 = L3_2.await
    L4_2 = "SELECT * FROM apex_phone_accounts WHERE citizenid = ?"
    L5_2 = {}
    L6_2 = L1_2
    L5_2[1] = L6_2
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L3_2(L4_2, L5_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  end
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = "SIM-%08d"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = math
  L5_2 = L5_2.random
  L6_2 = 0
  L7_2 = 99999999
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L5_2(L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L4_2 = L2_2.phone
  L5_2 = 1
  L6_2 = 5
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = L35_1
    L9_2 = L9_2()
    L10_2 = pcall
    L11_2 = MySQL
    L11_2 = L11_2.update
    L11_2 = L11_2.await
    L12_2 = "UPDATE apex_phone_accounts SET phone = ?, sim_id = ? WHERE citizenid = ?"
    L13_2 = {}
    L14_2 = L9_2
    L15_2 = L3_2
    L16_2 = L1_2
    L13_2[1] = L14_2
    L13_2[2] = L15_2
    L13_2[3] = L16_2
    L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2)
    if L10_2 then
      L12_2 = L9_2
      L2_2.sim_id = L3_2
      L2_2.phone = L12_2
      L12_2 = Accounts
      L12_2[L1_2] = L2_2
      L12_2 = SimOnNumberChanged
      if L12_2 then
        L12_2 = pcall
        L13_2 = SimOnNumberChanged
        L14_2 = L1_2
        L15_2 = L4_2
        L16_2 = L9_2
        L12_2(L13_2, L14_2, L15_2, L16_2)
      end
      L12_2 = L36_1
      L13_2 = A0_2
      L14_2 = L9_2
      L12_2(L13_2, L14_2)
      L12_2 = SyncPhoneNumberState
      L13_2 = A0_2
      L14_2 = L9_2
      L12_2(L13_2, L14_2)
      L12_2 = {}
      L12_2.phone = L9_2
      L12_2.sim_id = L3_2
      return L12_2
    end
    L12_2 = L78_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = error
      L13_2 = L11_2
      L14_2 = 0
      L12_2(L13_2, L14_2)
    end
  end
  L5_2 = {}
  L5_2.error = "busy"
  return L5_2
end
L85_1["account.swapSim"] = L86_1
L85_1 = _ENV
L86_1 = "ResetAccount"
function L87_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  if not A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = SimSetOptOut
  if L1_2 then
    L1_2 = pcall
    L2_2 = SimSetOptOut
    L3_2 = A0_2
    L4_2 = false
    L1_2(L2_2, L3_2, L4_2)
  end
  L1_2 = Accounts
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = L53_1
    L2_2 = MySQL
    L2_2 = L2_2.single
    L2_2 = L2_2.await
    L3_2 = "SELECT * FROM apex_phone_accounts WHERE citizenid = ?"
    L4_2 = {}
    L5_2 = A0_2
    L4_2[1] = L5_2
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L2_2(L3_2, L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  end
  L2_2 = 50
  L3_2 = {}
  L4_2 = {}
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT app, username FROM apex_phone_social_accounts WHERE owner = ? ORDER BY id ASC LIMIT %d"
    L2_3 = L1_3
    L1_3 = L1_3.format
    L3_3 = L2_2
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    L0_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = ipairs
    L2_3 = L0_3
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = L6_3.app
      if L7_3 then
        L7_3 = L6_3.username
        if L7_3 then
          L7_3 = L6_3.app
          if "" ~= L7_3 then
            L7_3 = L6_3.username
            if "" ~= L7_3 then
              L7_3 = L3_2
              L7_3 = #L7_3
              L8_3 = L7_3 + 1
              L7_3 = L3_2
              L9_3 = {}
              L10_3 = L6_3.app
              L9_3.app = L10_3
              L10_3 = L6_3.username
              L9_3.u = L10_3
              L7_3[L8_3] = L9_3
            end
          end
        end
      end
    end
    L1_3 = #L0_3
    L2_3 = L2_2
    if L1_3 >= L2_3 then
      L1_3 = print
      L2_3 = "^3[unique_phone]^0 reset %s: %d+ social accounts (cap %d) \226\128\148 the content of those beyond the cap is left undeleted. With the whitelist in server/social.lua a character has at most 3 accounts, so this should not happen: check which `app` values are in apex_phone_social_accounts for this owner"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = tostring
      L5_3 = A0_2
      L4_3 = L4_3(L5_3)
      L5_3 = #L0_3
      L6_3 = L2_2
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L2_3(L3_3, L4_3, L5_3, L6_3)
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    end
  end
  L5_2(L6_2)
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L0_3 = ipairs
    L1_3 = MySQL
    L1_3 = L1_3.query
    L1_3 = L1_3.await
    L2_3 = "SELECT room, username FROM apex_phone_darkchat_members WHERE citizenid = ?"
    L3_3 = {}
    L4_3 = A0_2
    L3_3[1] = L4_3
    L1_3 = L1_3(L2_3, L3_3)
    if not L1_3 then
      L1_3 = {}
    end
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
    for L4_3, L5_3 in L0_3, L1_3, L2_3, L3_3 do
      L6_3 = L5_3.room
      if L6_3 then
        L6_3 = L5_3.username
        if L6_3 then
          L6_3 = L5_3.room
          if "" ~= L6_3 then
            L6_3 = L5_3.username
            if "" ~= L6_3 then
              L6_3 = L4_2
              L6_3 = #L6_3
              L7_3 = L6_3 + 1
              L6_3 = L4_2
              L8_3 = {}
              L9_3 = L5_3.room
              L8_3.room = L9_3
              L9_3 = L5_3.username
              L8_3.u = L9_3
              L6_3[L7_3] = L8_3
            end
          end
        end
      end
    end
  end
  L5_2(L6_2)
  L5_2 = type
  L6_2 = ItemEscrow
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = ItemEscrow
    L5_2 = L5_2.ready
    if L5_2 then
      L5_2 = type
      L6_2 = ItemEscrow
      L6_2 = L6_2.withLock
      L5_2 = L5_2(L6_2)
      if "function" == L5_2 then
        L5_2 = ipairs
        L6_2 = MySQL
        L6_2 = L6_2.query
        L6_2 = L6_2.await
        L7_2 = "SELECT id FROM apex_phone_market WHERE owner = ?"
        L8_2 = {}
        L9_2 = A0_2
        L8_2[1] = L9_2
        L6_2 = L6_2(L7_2, L8_2)
        if not L6_2 then
          L6_2 = {}
        end
        L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
        for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
          L11_2 = math
          L11_2 = L11_2.tointeger
          L12_2 = tonumber
          L13_2 = L10_2.id
          L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L12_2(L13_2)
          L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
          if L11_2 then
            L12_2 = pcall
            L13_2 = ItemEscrow
            L13_2 = L13_2.withLock
            L14_2 = "market:"
            L15_2 = ItemEscrow
            L15_2 = L15_2.key
            L16_2 = L11_2
            L15_2 = L15_2(L16_2)
            L14_2 = L14_2 .. L15_2
            function L15_2()
              local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
              L0_3 = MySQL
              L0_3 = L0_3.single
              L0_3 = L0_3.await
              L1_3 = "SELECT id, sold, buyer FROM apex_phone_market WHERE id = ? AND owner = ?"
              L2_3 = {}
              L3_3 = L11_2
              L4_3 = A0_2
              L2_3[1] = L3_3
              L2_3[2] = L4_3
              L0_3 = L0_3(L1_3, L2_3)
              if not L0_3 then
                return
              end
              L1_3 = tonumber
              L2_3 = MySQL
              L2_3 = L2_3.update
              L2_3 = L2_3.await
              L3_3 = "DELETE FROM apex_phone_market WHERE id = ? AND owner = ?"
              L4_3 = {}
              L5_3 = L11_2
              L6_3 = A0_2
              L4_3[1] = L5_3
              L4_3[2] = L6_3
              L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L2_3(L3_3, L4_3)
              L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
              if not L1_3 then
                L1_3 = 0
              end
              if 1 ~= L1_3 then
                return
              end
              L1_3 = ItemEscrow
              L1_3 = L1_3.heldRows
              L2_3 = "market"
              L3_3 = L11_2
              L1_3 = L1_3(L2_3, L3_3)
              L2_3 = L0_3.sold
              if true ~= L2_3 then
                L2_3 = tonumber
                L3_3 = L0_3.sold
                L2_3 = L2_3(L3_3)
              end
              L2_3 = 1 == L2_3
              if L2_3 then
                L3_3 = ipairs
                L4_3 = L1_3
                L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
                for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
                  L9_3 = ItemEscrow
                  L9_3 = L9_3.giveTo
                  L10_3 = L8_3.id
                  L11_3 = tostring
                  L12_3 = L0_3.buyer
                  L11_3, L12_3 = L11_3(L12_3)
                  L9_3(L10_3, L11_3, L12_3)
                end
              else
                L3_3 = ItemEscrow
                L3_3 = L3_3.returnRows
                L4_3 = L1_3
                L3_3(L4_3)
              end
            end
            L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
            if not L12_2 then
              L14_2 = print
              L15_2 = "^1[unique_phone]^0 reset %s: escrow of ad %d is left for the periodic cleanup (%s)"
              L16_2 = L15_2
              L15_2 = L15_2.format
              L17_2 = tostring
              L18_2 = A0_2
              L17_2 = L17_2(L18_2)
              L18_2 = L11_2
              L19_2 = tostring
              L20_2 = L13_2
              L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L19_2(L20_2)
              L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
              L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
            end
          end
        end
      end
    end
  end
  L5_2 = ipairs
  L6_2 = {}
  L7_2 = "apex_phone_contacts"
  L8_2 = "apex_phone_calls"
  L9_2 = "apex_phone_photos"
  L10_2 = "apex_phone_mail"
  L11_2 = "apex_phone_transactions"
  L12_2 = "apex_phone_bills"
  L13_2 = "apex_phone_social_accounts"
  L14_2 = "apex_phone_market"
  L15_2 = "apex_phone_garage_meta"
  L16_2 = "apex_phone_match_profiles"
  L17_2 = "apex_phone_match_swipes"
  L18_2 = "apex_phone_notifications"
  L19_2 = "apex_phone_media"
  L20_2 = "apex_phone_blocks"
  L21_2 = "apex_phone_app_grants"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L6_2[7] = L13_2
  L6_2[8] = L14_2
  L6_2[9] = L15_2
  L6_2[10] = L16_2
  L6_2[11] = L17_2
  L6_2[12] = L18_2
  L6_2[13] = L19_2
  L6_2[14] = L20_2
  L6_2[15] = L21_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = pcall
    function L12_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "DELETE FROM "
      L2_3 = L10_2
      L3_3 = " WHERE owner = ?"
      L1_3 = L1_3 .. L2_3 .. L3_3
      L2_3 = {}
      L3_3 = A0_2
      L2_3[1] = L3_3
      L0_3(L1_3, L2_3)
    end
    L11_2(L12_2)
  end
  L5_2 = L69_1
  L5_2[A0_2] = nil
  L5_2 = pairs
  L6_2 = L68_1
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.cid
    if L11_2 == A0_2 then
      L11_2 = L68_1
      L11_2[L9_2] = nil
    end
  end
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_matches WHERE a = ? OR b = ?"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = A0_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L0_3(L1_3, L2_3)
  end
  L5_2(L6_2)
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_darkchat_members WHERE citizenid = ?"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
  end
  L5_2(L6_2)
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_services WHERE requester = ?"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
  end
  L5_2(L6_2)
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = pcall
    function L3_3()
      local L0_4, L1_4, L2_4
      L0_4 = MySQL
      L0_4 = L0_4.query
      L0_4 = L0_4.await
      L1_4 = A0_3
      L2_4 = A1_3
      L0_4(L1_4, L2_4)
    end
    L2_3(L3_3)
  end
  L6_2 = ipairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.app
    L13_2 = L11_2.u
    L14_2 = L5_2
    L15_2 = "DELETE cl FROM apex_phone_comment_likes cl JOIN apex_phone_comments c ON c.id = cl.comment_id JOIN apex_phone_posts p ON p.id = c.post_id WHERE p.app = ? AND p.author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE cl FROM apex_phone_comment_likes cl JOIN apex_phone_comments c ON c.id = cl.comment_id JOIN apex_phone_posts p ON p.id = c.post_id WHERE p.app = ? AND cl.username = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE c FROM apex_phone_comments c JOIN apex_phone_posts p ON p.id = c.post_id WHERE p.app = ? AND p.author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE c FROM apex_phone_comments c JOIN apex_phone_posts p ON p.id = c.post_id WHERE p.app = ? AND c.username = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE l FROM apex_phone_likes l JOIN apex_phone_posts p ON p.id = l.post_id WHERE p.app = ? AND p.author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE l FROM apex_phone_likes l JOIN apex_phone_posts p ON p.id = l.post_id WHERE p.app = ? AND l.username = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE sv FROM apex_phone_saves sv JOIN apex_phone_posts p ON p.id = sv.post_id WHERE p.app = ? AND p.author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE FROM apex_phone_saves WHERE app = ? AND username = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE FROM apex_phone_posts WHERE app = ? AND author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE v FROM apex_phone_story_views v JOIN apex_phone_stories st ON st.id = v.story_id WHERE st.app = ? AND st.author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE v FROM apex_phone_story_views v JOIN apex_phone_stories st ON st.id = v.story_id WHERE st.app = ? AND v.username = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE a FROM apex_phone_story_answers a JOIN apex_phone_stories st ON st.id = a.story_id WHERE st.app = ? AND st.author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE a FROM apex_phone_story_answers a JOIN apex_phone_stories st ON st.id = a.story_id WHERE st.app = ? AND a.username = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE FROM apex_phone_stories WHERE app = ? AND author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE v FROM apex_phone_instant_views v JOIN apex_phone_instants i ON i.id = v.instant_id WHERE i.app = ? AND i.author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE v FROM apex_phone_instant_views v JOIN apex_phone_instants i ON i.id = v.instant_id WHERE i.app = ? AND v.username = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE FROM apex_phone_instants WHERE app = ? AND author = ?"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE FROM apex_phone_follows WHERE app = ? AND (follower = ? OR followed = ?)"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L19_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L16_2[3] = L19_2
    L14_2(L15_2, L16_2)
    L14_2 = L5_2
    L15_2 = "DELETE FROM apex_phone_close_friends WHERE app = ? AND (owner = ? OR friend = ?)"
    L16_2 = {}
    L17_2 = L12_2
    L18_2 = L13_2
    L19_2 = L13_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L16_2[3] = L19_2
    L14_2(L15_2, L16_2)
  end
  L6_2 = ipairs
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L5_2
    L13_2 = "DELETE FROM apex_phone_darkchat WHERE room = ? AND username = ?"
    L14_2 = {}
    L15_2 = L11_2.room
    L16_2 = L11_2.u
    L14_2[1] = L15_2
    L14_2[2] = L16_2
    L12_2(L13_2, L14_2)
  end
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_eats_orders WHERE owner = ? AND status IN ('delivered', 'cancelled')"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_eats_addresses WHERE owner = ?"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_eats_meta WHERE owner = ?"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_music WHERE citizenid = ?"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_userdata WHERE owner = ?"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_app_ratings WHERE owner = ?"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_findmy WHERE owner = ? OR target = ?"
  L8_2 = {}
  L9_2 = A0_2
  L10_2 = A0_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2(L7_2, L8_2)
  L6_2 = L5_2
  L7_2 = "DELETE FROM apex_phone_crypto_hist WHERE owner = ?"
  L8_2 = {}
  L9_2 = A0_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = type
  L7_2 = ItemEscrow
  L6_2 = L6_2(L7_2)
  L6_2 = "table" == L6_2
  L7_2 = pcall
  L8_2 = MySQL
  L8_2 = L8_2.query
  L8_2 = L8_2.await
  L9_2 = "SELECT id FROM apex_phone_onion WHERE owner = ?"
  L10_2 = {}
  L11_2 = A0_2
  L10_2[1] = L11_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
  L9_2 = ipairs
  L10_2 = L8_2 or L10_2
  if not L7_2 or not L8_2 then
    L10_2 = {}
  end
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = math
    L15_2 = L15_2.tointeger
    L16_2 = tonumber
    L17_2 = L14_2.id
    L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L16_2(L17_2)
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    if L15_2 then
      function L16_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
        L0_3 = tonumber
        L1_3 = MySQL
        L1_3 = L1_3.update
        L1_3 = L1_3.await
        L2_3 = "DELETE FROM apex_phone_onion WHERE id = ? AND owner = ?"
        L3_3 = {}
        L4_3 = L15_2
        L5_3 = A0_2
        L3_3[1] = L4_3
        L3_3[2] = L5_3
        L1_3, L2_3, L3_3, L4_3, L5_3 = L1_3(L2_3, L3_3)
        L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
        if not L0_3 then
          L0_3 = 0
        end
        if 1 == L0_3 then
          L0_3 = L6_2
          if L0_3 then
            L0_3 = ItemEscrow
            L0_3 = L0_3.returnRows
            L1_3 = ItemEscrow
            L1_3 = L1_3.heldRows
            L2_3 = "onion"
            L3_3 = L15_2
            L1_3, L2_3, L3_3, L4_3, L5_3 = L1_3(L2_3, L3_3)
            L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
          end
        end
      end
      L17_2 = pcall
      function L18_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = L6_2
        if L0_3 then
          L0_3 = ItemEscrow
          L0_3 = L0_3.withLock
          L1_3 = "onion:"
          L2_3 = ItemEscrow
          L2_3 = L2_3.key
          L3_3 = L15_2
          L2_3 = L2_3(L3_3)
          L1_3 = L1_3 .. L2_3
          L2_3 = L16_2
          return L0_3(L1_3, L2_3)
        end
        L0_3 = L16_2
        return L0_3()
      end
      L17_2, L18_2 = L17_2(L18_2)
      if not L17_2 then
        L19_2 = print
        L20_2 = "^1[unique_phone]^0 reset %s: escrow of onion ad %d is left for the periodic cleanup (%s)"
        L21_2 = L20_2
        L20_2 = L20_2.format
        L22_2 = tostring
        L23_2 = A0_2
        L22_2 = L22_2(L23_2)
        L23_2 = L15_2
        L24_2 = tostring
        L25_2 = L18_2
        L24_2, L25_2 = L24_2(L25_2)
        L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L20_2(L21_2, L22_2, L23_2, L24_2, L25_2)
        L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
      end
    end
  end
  L9_2 = L5_2
  L10_2 = "DELETE FROM apex_phone_onion WHERE owner = ?"
  L11_2 = {}
  L12_2 = A0_2
  L11_2[1] = L12_2
  L9_2(L10_2, L11_2)
  L9_2 = L5_2
  L10_2 = "DELETE FROM apex_phone_onion_id WHERE citizenid = ?"
  L11_2 = {}
  L12_2 = A0_2
  L11_2[1] = L12_2
  L9_2(L10_2, L11_2)
  L9_2 = L5_2
  L10_2 = [[
DELETE FROM apex_phone_onion_orders WHERE (buyer = ? OR seller = ?) AND status IN ('concluido', 'cancelado')
        AND NOT EXISTS (SELECT 1 FROM apex_phone_item_escrow e WHERE e.`source` = 'onion' AND e.ref_id = apex_phone_onion_orders.id AND e.status = 'held')]]
  L11_2 = {}
  L12_2 = A0_2
  L13_2 = A0_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L9_2(L10_2, L11_2)
  if L1_2 then
    L9_2 = L1_2.phone
    if L9_2 then
      L9_2 = pcall
      function L10_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM apex_phone_messages WHERE sender = ? OR receiver = ?"
        L2_3 = {}
        L3_3 = L1_2.phone
        L4_3 = L1_2.phone
        L2_3[1] = L3_3
        L2_3[2] = L4_3
        L0_3(L1_3, L2_3)
      end
      L9_2(L10_2)
      L9_2 = pcall
      function L10_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM apex_phone_thread_meta WHERE owner = ?"
        L2_3 = {}
        L3_3 = L1_2.phone
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L9_2(L10_2)
      L9_2 = pcall
      function L10_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM apex_phone_message_reactions WHERE who = ?"
        L2_3 = {}
        L3_3 = L1_2.phone
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L9_2(L10_2)
      L9_2 = type
      L10_2 = GroupForget
      L9_2 = L9_2(L10_2)
      if "function" == L9_2 then
        L9_2 = pcall
        L10_2 = GroupForget
        L11_2 = L1_2.phone
        L9_2(L10_2, L11_2)
      end
    end
  end
  L9_2 = type
  L10_2 = MessagesForget
  L9_2 = L9_2(L10_2)
  if "function" == L9_2 then
    L9_2 = pcall
    L10_2 = MessagesForget
    L11_2 = A0_2
    L12_2 = L1_2 or L12_2
    if L1_2 then
      L12_2 = L1_2.phone
    end
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = type
  L10_2 = MediaForget
  L9_2 = L9_2(L10_2)
  if "function" == L9_2 then
    L9_2 = pcall
    L10_2 = MediaForget
    L11_2 = A0_2
    L9_2(L10_2, L11_2)
  end
  L9_2 = type
  L10_2 = RecadoCoreForget
  L9_2 = L9_2(L10_2)
  if "function" == L9_2 then
    L9_2 = pcall
    L10_2 = RecadoCoreForget
    L11_2 = A0_2
    L12_2 = L1_2 or L12_2
    if L1_2 then
      L12_2 = L1_2.phone
    end
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = type
  L10_2 = RecadoForget
  L9_2 = L9_2(L10_2)
  if "function" == L9_2 then
    L9_2 = pcall
    L10_2 = RecadoForget
    L11_2 = A0_2
    L12_2 = L1_2 or L12_2
    if L1_2 then
      L12_2 = L1_2.phone
    end
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = type
  L10_2 = RecadoSocialForget
  L9_2 = L9_2(L10_2)
  if "function" == L9_2 then
    L9_2 = pcall
    L10_2 = RecadoSocialForget
    L11_2 = A0_2
    L12_2 = L1_2 or L12_2
    if L1_2 then
      L12_2 = L1_2.phone
    end
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = pcall
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_recado_call_history WHERE owner = ?"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
  end
  L9_2(L10_2)
  L9_2 = pcall
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_recado_call_links WHERE owner = ?"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
  end
  L9_2(L10_2)
  L9_2 = pcall
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_recado_call_scheduled WHERE owner = ?"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
  end
  L9_2(L10_2)
  if L1_2 then
    L9_2 = L1_2.phone
    if L9_2 then
      L9_2 = L1_2.phone
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE v FROM apex_phone_recado_poll_votes v JOIN apex_phone_recado_polls p ON p.id = v.poll_id WHERE p.creator = ?"
        L2_3 = {}
        L3_3 = L9_2
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L10_2(L11_2)
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM apex_phone_recado_polls WHERE creator = ?"
        L2_3 = {}
        L3_3 = L9_2
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L10_2(L11_2)
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM apex_phone_recado_poll_votes WHERE voter = ?"
        L2_3 = {}
        L3_3 = L9_2
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L10_2(L11_2)
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE r FROM apex_phone_recado_rsvp r JOIN apex_phone_recado_events e ON e.id = r.event_id WHERE e.creator = ?"
        L2_3 = {}
        L3_3 = L9_2
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L10_2(L11_2)
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM apex_phone_recado_events WHERE creator = ?"
        L2_3 = {}
        L3_3 = L9_2
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L10_2(L11_2)
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM apex_phone_recado_rsvp WHERE who = ?"
        L2_3 = {}
        L3_3 = L9_2
        L2_3[1] = L3_3
        L0_3(L1_3, L2_3)
      end
      L10_2(L11_2)
    end
  end
  L9_2 = MySQL
  L9_2 = L9_2.query
  L9_2 = L9_2.await
  L10_2 = "DELETE FROM apex_phone_accounts WHERE citizenid = ?"
  L11_2 = {}
  L12_2 = A0_2
  L11_2[1] = L12_2
  L9_2(L10_2, L11_2)
  L9_2 = SimForget
  if L9_2 then
    L9_2 = pcall
    L10_2 = SimForget
    L11_2 = A0_2
    L9_2(L10_2, L11_2)
  end
  L9_2 = Accounts
  L9_2[A0_2] = nil
  L9_2 = L1_1
  L9_2[A0_2] = nil
  L9_2 = InvalidateOnlineIndex
  L9_2()
  L9_2 = true
  return L9_2
end
L85_1[L86_1] = L87_1
L85_1 = _ENV
L86_1 = "RPC"
L85_1 = L85_1[L86_1]
function L86_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.ok = false
    return L2_2
  end
  L2_2 = {}
  L3_2 = ResetAccount
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L2_2.ok = L3_2
  return L2_2
end
L85_1["account.reset"] = L86_1
function L85_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = 1
  L3_2 = 5
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = L35_1
    L6_2 = L6_2()
    L7_2 = pcall
    L8_2 = MySQL
    L8_2 = L8_2.update
    L8_2 = L8_2.await
    L9_2 = "UPDATE apex_phone_accounts SET phone = ? WHERE citizenid = ? AND phone = ?"
    L10_2 = {}
    L11_2 = L6_2
    L12_2 = A0_2
    L13_2 = A1_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 then
      L9_2 = tonumber
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if not L9_2 then
        L9_2 = 0
      end
      if 0 == L9_2 then
        L9_2 = nil
        return L9_2
      end
      L9_2 = print
      L10_2 = "^3[unique_phone]^0 duplicate number %s: account %s now has number %s (the older account kept %s)"
      L11_2 = L10_2
      L10_2 = L10_2.format
      if "" == A1_2 then
        L12_2 = "(empty)"
        if L12_2 then
          goto lbl_40
        end
      end
      L12_2 = A1_2
      ::lbl_40::
      L13_2 = A0_2
      L14_2 = L6_2
      if "" == A1_2 then
        L15_2 = "its own"
        if L15_2 then
          goto lbl_48
        end
      end
      L15_2 = A1_2
      ::lbl_48::
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
      L9_2 = L52_1
      L10_2 = {}
      L10_2.old = A1_2
      L10_2.new = L6_2
      L9_2[A0_2] = L10_2
      L9_2 = SetTimeout
      L10_2 = 30000
      function L11_2()
        local L0_3, L1_3
        L1_3 = A0_2
        L0_3 = L52_1
        L0_3 = L0_3[L1_3]
        if L0_3 then
          L1_3 = A0_2
          L0_3 = L52_1
          L0_3 = L0_3[L1_3]
          L0_3 = L0_3.new
          L1_3 = L6_2
          if L0_3 == L1_3 then
            L1_3 = A0_2
            L0_3 = L52_1
            L0_3[L1_3] = nil
          end
        end
      end
      L9_2(L10_2, L11_2)
      L9_2 = Accounts
      L9_2 = L9_2[A0_2]
      if L9_2 then
        L9_2.phone = L6_2
      end
      L10_2 = SimOnNumberChanged
      if L10_2 then
        L10_2 = pcall
        L11_2 = SimOnNumberChanged
        L12_2 = A0_2
        L13_2 = A1_2
        L14_2 = L6_2
        L10_2(L11_2, L12_2, L13_2, L14_2)
      end
      L10_2 = FW
      L10_2 = L10_2.GetPlayerByCid
      L11_2 = A0_2
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L11_2 = L10_2.src
        if L11_2 then
          L11_2 = L36_1
          L12_2 = L10_2.src
          L13_2 = L6_2
          L11_2(L12_2, L13_2)
          L11_2 = SyncPhoneNumberState
          L12_2 = L10_2.src
          L13_2 = L6_2
          L11_2(L12_2, L13_2)
          L11_2 = BuildPlayer
          L12_2 = L10_2.src
          L11_2 = L11_2(L12_2)
          if L11_2 then
            L12_2 = Push
            L13_2 = L10_2.src
            L14_2 = "player"
            L15_2 = L11_2
            L12_2(L13_2, L14_2, L15_2)
          end
        end
      end
      L11_2 = NotifyCitizen
      L12_2 = A0_2
      L13_2 = "settings"
      L14_2 = "N\195\186mero alterado"
      L15_2 = "O teu n\195\186mero passou a ser %s (estava repetido noutra conta)."
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L6_2
      L15_2, L16_2, L17_2 = L15_2(L16_2, L17_2)
      L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
      return L6_2
    end
    L9_2 = L78_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = error
      L10_2 = L8_2
      L11_2 = 0
      L9_2(L10_2, L11_2)
    end
  end
  L2_2 = nil
  return L2_2
end
function L86_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L0_2 = 0
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT phone FROM apex_phone_accounts GROUP BY phone HAVING COUNT(*) > 1 OR phone = '' LIMIT 500"
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = tostring
    L9_2 = L7_2.phone
    if not L9_2 then
      L9_2 = ""
    end
    L8_2 = L8_2(L9_2)
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "SELECT citizenid FROM apex_phone_accounts WHERE phone = ? ORDER BY created ASC, citizenid ASC"
    L11_2 = {}
    L12_2 = L8_2
    L11_2[1] = L12_2
    L9_2 = L9_2(L10_2, L11_2)
    if not L9_2 then
      L9_2 = {}
    end
    L10_2 = ipairs
    L11_2 = L9_2
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      if L14_2 > 1 or "" == L8_2 then
        L16_2 = L85_1
        L17_2 = tostring
        L18_2 = L15_2.citizenid
        L17_2 = L17_2(L18_2)
        L18_2 = L8_2
        L16_2 = L16_2(L17_2, L18_2)
        if L16_2 then
          L0_2 = L0_2 + 1
        end
      end
    end
  end
  if L0_2 > 0 then
    L2_2 = print
    L3_2 = "^3[unique_phone]^0 %d account(s) with a duplicate number received a new number"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = L0_2
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L3_2(L4_2, L5_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  end
  return L0_2
end
function L87_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L0_2 = L3_1
  if not L0_2 then
    L0_2 = 0
    return L0_2
  end
  L0_2 = 0
  L1_2 = 1
  L2_2 = 1000
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = MySQL
    L5_2 = L5_2.query
    L5_2 = L5_2.await
    L6_2 = "SELECT citizenid, pin FROM apex_phone_accounts WHERE pin <> '' AND pin NOT LIKE 'h1$%' LIMIT 200"
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = {}
    end
    L6_2 = #L5_2
    if 0 == L6_2 then
      break
    end
    L6_2 = 0
    L7_2 = ipairs
    L8_2 = L5_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = tostring
      L14_2 = L12_2.pin
      L13_2 = L13_2(L14_2)
      L14_2 = L44_1
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      L15_2 = L49_1
      L16_2 = L13_2
      L15_2 = L15_2(L16_2)
      L16_2 = MySQL
      L16_2 = L16_2.update
      L16_2 = L16_2.await
      L17_2 = "UPDATE apex_phone_accounts SET pin = ?, pin_len = ? WHERE citizenid = ? AND pin = ?"
      L18_2 = {}
      L19_2 = L14_2
      L20_2 = L15_2
      L21_2 = L12_2.citizenid
      L22_2 = L13_2
      L18_2[1] = L19_2
      L18_2[2] = L20_2
      L18_2[3] = L21_2
      L18_2[4] = L22_2
      L16_2 = L16_2(L17_2, L18_2)
      if not L16_2 then
        L16_2 = 0
      end
      L17_2 = tonumber
      L18_2 = L16_2
      L17_2 = L17_2(L18_2)
      if not L17_2 then
        L17_2 = 0
      end
      if L17_2 > 0 then
        L17_2 = L6_2 + 1
        L0_2 = L0_2 + 1
        L6_2 = L17_2
        L17_2 = Accounts
        L18_2 = L12_2.citizenid
        L17_2 = L17_2[L18_2]
        if L17_2 then
          L18_2 = tostring
          L19_2 = L17_2.pin
          if not L19_2 then
            L19_2 = ""
          end
          L18_2 = L18_2(L19_2)
          if L18_2 == L13_2 then
            L18_2 = L14_2
            L17_2.pin_len = L15_2
            L17_2.pin = L18_2
          end
        end
      end
      L17_2 = Wait
      L18_2 = 0
      L17_2(L18_2)
    end
    if 0 == L6_2 then
      break
    end
  end
  if L0_2 > 0 then
    L1_2 = print
    L2_2 = "^2[unique_phone]^0 %d plain-text unlock code(s) converted to hash"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = L0_2
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L2_2(L3_2, L4_2)
    L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  end
  return L0_2
end
L88_1 = _ENV
L89_1 = "CreateThread"
L88_1 = L88_1[L89_1]
function L89_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  while true do
    L0_2 = DBReady
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 500
    L0_2(L1_2)
  end
  L0_2 = pcall
  L1_2 = L86_1
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 duplicate numbers: %s"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  end
  L2_2 = EnsureIndex
  L3_2 = "apex_phone_accounts"
  L4_2 = "ux_phone"
  L5_2 = {}
  L6_2 = "phone"
  L5_2[1] = L6_2
  L6_2 = true
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = L3_1
  if L2_2 then
    L2_2 = L42_1
    L2_2 = L2_2()
    L3_2 = 256
    if L2_2 > L3_2 then
      L2_2 = print
      L3_2 = "^3[unique_phone]^0 Config.PinHash.rounds = %d: about %d ms per code check on the server thread (recommended up to 128)"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = L42_1
      L5_2 = L5_2()
      L6_2 = math
      L6_2 = L6_2.floor
      L7_2 = L42_1
      L7_2 = L7_2()
      L7_2 = L7_2 * 0.04
      L7_2 = L7_2 + 0.5
      L6_2, L7_2, L8_2 = L6_2(L7_2)
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
      L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
    end
  end
  L2_2 = pcall
  L3_2 = L87_1
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = print
    L5_2 = "^1[unique_phone]^0 conversion of codes to hash: %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
end
L88_1(L89_1)
function L88_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 then
    return L2_2
  end
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = math
    L10_2 = L10_2.tointeger
    L11_2 = tonumber
    L12_2 = L9_2
    L11_2, L12_2 = L11_2(L12_2)
    L10_2 = L10_2(L11_2, L12_2)
    if L10_2 and L10_2 > 0 then
      L11_2 = L3_2[L10_2]
      if not L11_2 then
        L3_2[L10_2] = true
        L11_2 = #L2_2
        L11_2 = L11_2 + 1
        L2_2[L11_2] = L10_2
        L11_2 = #L2_2
        if A1_2 <= L11_2 then
          break
        end
      end
    end
  end
  return L2_2
end
function L89_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.rep
  L2_2 = "?"
  L3_2 = A0_2
  L4_2 = ", "
  return L1_2(L2_2, L3_2, L4_2)
end
function L90_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    return L2_2
  end
  L3_2 = nil
  return L3_2
end
L91_1 = _ENV
L92_1 = "RPC"
L91_1 = L91_1[L92_1]
L92_1 = "notifs.list"
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L4_2 = {}
    L3_2.items = L4_2
    L3_2.more = false
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.limit
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 30
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 30
  end
  L4_2 = math
  L4_2 = L4_2.max
  L5_2 = 1
  L6_2 = math
  L6_2 = L6_2.min
  L7_2 = L3_2
  L8_2 = 100
  L6_2 = L6_2(L7_2, L8_2)
  L4_2 = L4_2(L5_2, L6_2)
  L3_2 = L4_2
  L4_2 = "owner = ?"
  L5_2 = {}
  L6_2 = L2_2
  L5_2[1] = L6_2
  L6_2 = tonumber
  L7_2 = A1_2.before
  L6_2 = L6_2(L7_2)
  if L6_2 and L6_2 > 0 then
    L7_2 = 1.0E11
    if L6_2 >= L7_2 then
      L7_2 = L4_2
      L8_2 = " AND created < ?"
      L7_2 = L7_2 .. L8_2
      L4_2 = L7_2
    else
      L7_2 = L4_2
      L8_2 = " AND id < ?"
      L7_2 = L7_2 .. L8_2
      L4_2 = L7_2
    end
    L7_2 = #L5_2
    L7_2 = L7_2 + 1
    L8_2 = math
    L8_2 = L8_2.floor
    L9_2 = L6_2
    L8_2 = L8_2(L9_2)
    L5_2[L7_2] = L8_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT id, app, title, body, data, icon, image, `read`, created, actions, `type`, duration FROM apex_phone_notifications WHERE %s ORDER BY id DESC LIMIT %d"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = L4_2
  L11_2 = L3_2 + 1
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L9_2 = L5_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = {}
  L9_2 = 1
  L10_2 = math
  L10_2 = L10_2.min
  L11_2 = #L7_2
  L12_2 = L3_2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = 1
  for L12_2 = L9_2, L10_2, L11_2 do
    L13_2 = L7_2[L12_2]
    L14_2 = math
    L14_2 = L14_2.tointeger
    L15_2 = tonumber
    L16_2 = L13_2.duration
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
    L15_2 = {}
    L16_2 = tonumber
    L17_2 = L13_2.id
    L16_2 = L16_2(L17_2)
    L15_2.id = L16_2
    L16_2 = L13_2.app
    L15_2.app = L16_2
    L16_2 = L13_2.title
    L15_2.title = L16_2
    L16_2 = L13_2.body
    if not L16_2 then
      L16_2 = ""
    end
    L15_2.msg = L16_2
    L16_2 = L90_1
    L17_2 = L13_2.data
    L16_2 = L16_2(L17_2)
    L15_2.data = L16_2
    L16_2 = L13_2.icon
    L15_2.icon = L16_2
    L16_2 = L13_2.image
    L15_2.image = L16_2
    L16_2 = tonumber
    L17_2 = L13_2.read
    L16_2 = L16_2(L17_2)
    if not L16_2 then
      L16_2 = 0
    end
    L16_2 = 1 == L16_2
    L15_2.read = L16_2
    L16_2 = tonumber
    L17_2 = L13_2.created
    L16_2 = L16_2(L17_2)
    L15_2.created = L16_2
    L16_2 = L17_1
    L17_2 = L13_2.actions
    L16_2 = L16_2(L17_2)
    L15_2.actions = L16_2
    L17_2 = L13_2.type
    L16_2 = L14_1
    L16_2 = L16_2[L17_2]
    if L16_2 then
      L16_2 = L13_2.type
      if L16_2 then
        goto lbl_150
      end
    end
    L16_2 = nil
    ::lbl_150::
    L15_2.type = L16_2
    if L14_2 and L14_2 > 0 then
      L16_2 = math
      L16_2 = L16_2.min
      L17_2 = L14_2
      L18_2 = 120000
      L16_2 = L16_2(L17_2, L18_2)
      if L16_2 then
        goto lbl_163
      end
    end
    L16_2 = nil
    ::lbl_163::
    L15_2.duration = L16_2
    L8_2[L12_2] = L15_2
  end
  L9_2 = {}
  L9_2.items = L8_2
  L10_2 = #L7_2
  L10_2 = L3_2 < L10_2
  L9_2.more = L10_2
  return L9_2
end
L91_1[L92_1] = L93_1
L91_1 = _ENV
L92_1 = "RPC"
L91_1 = L91_1[L92_1]
L92_1 = "notifs.read"
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = A1_2.all
  if L3_2 then
    L3_2 = L15_1
    L4_2 = A1_2.app
    L5_2 = 32
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L4_2 = MySQL
      L4_2 = L4_2.update
      L4_2 = L4_2.await
      L5_2 = "UPDATE apex_phone_notifications SET `read` = 1 WHERE owner = ? AND app = ? AND `read` = 0"
      L6_2 = {}
      L7_2 = L2_2
      L8_2 = L3_2
      L6_2[1] = L7_2
      L6_2[2] = L8_2
      L4_2(L5_2, L6_2)
    else
      L4_2 = MySQL
      L4_2 = L4_2.update
      L4_2 = L4_2.await
      L5_2 = "UPDATE apex_phone_notifications SET `read` = 1 WHERE owner = ? AND `read` = 0"
      L6_2 = {}
      L7_2 = L2_2
      L6_2[1] = L7_2
      L4_2(L5_2, L6_2)
    end
    L4_2 = {}
    L4_2.ok = true
    return L4_2
  end
  L3_2 = L88_1
  L4_2 = A1_2.ids
  L5_2 = 200
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = {}
  L5_2 = L2_2
  L4_2[1] = L5_2
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L4_2[L11_2] = L10_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_notifications SET `read` = 1 WHERE owner = ? AND id IN (%s)"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L89_1
  L9_2 = #L3_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = L4_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L91_1[L92_1] = L93_1
L91_1 = _ENV
L92_1 = "RPC"
L91_1 = L91_1[L92_1]
L92_1 = "notifs.remove"
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = L88_1
  L4_2 = A1_2.ids
  L5_2 = 200
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = {}
  L5_2 = L2_2
  L4_2[1] = L5_2
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L4_2[L11_2] = L10_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM apex_phone_notifications WHERE owner = ? AND id IN (%s)"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L89_1
  L9_2 = #L3_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = L4_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L91_1[L92_1] = L93_1
L91_1 = _ENV
L92_1 = "RPC"
L91_1 = L91_1[L92_1]
L92_1 = "notifs.clear"
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = L15_1
  L4_2 = A1_2.app
  L5_2 = 32
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "DELETE FROM apex_phone_notifications WHERE owner = ? AND app = ?"
    L6_2 = {}
    L7_2 = L2_2
    L8_2 = L3_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L4_2(L5_2, L6_2)
  else
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "DELETE FROM apex_phone_notifications WHERE owner = ?"
    L6_2 = {}
    L7_2 = L2_2
    L6_2[1] = L7_2
    L4_2(L5_2, L6_2)
  end
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L91_1[L92_1] = L93_1
function L91_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  A1_2 = L3_2
  if not (L2_2 and A1_2) or A1_2 < 1 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT id, app, data, `read` FROM apex_phone_notifications WHERE id = ? AND owner = ?"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = tonumber
    L5_2 = L3_2.read
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = 0
    end
    if 0 == L4_2 then
      L4_2 = MySQL
      L4_2 = L4_2.update
      L5_2 = "UPDATE apex_phone_notifications SET `read` = 1 WHERE id = ?"
      L6_2 = {}
      L7_2 = A1_2
      L6_2[1] = L7_2
      L4_2(L5_2, L6_2)
    end
  end
  return L3_2
end
L92_1 = _ENV
L93_1 = "RPC"
L92_1 = L92_1[L93_1]
L93_1 = "notifs.open"
function L94_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L91_1
  L3_2 = A0_2
  L4_2 = A1_2.id
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = Dbg
  L4_2 = "notif"
  L5_2 = "opened #%s (%s) by %s"
  L6_2 = L2_2.id
  L7_2 = L2_2.app
  L8_2 = A0_2
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = TriggerEvent
  L4_2 = "apex_phone:notificationOpened"
  L5_2 = A0_2
  L6_2 = tonumber
  L7_2 = L2_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = L2_2.app
  L8_2 = L90_1
  L9_2 = L2_2.data
  L8_2, L9_2 = L8_2(L9_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L92_1[L93_1] = L94_1
L92_1 = _ENV
L93_1 = "RPC"
L92_1 = L92_1[L93_1]
L93_1 = "notifs.action"
function L94_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L15_1
  L3_2 = A1_2.action
  L4_2 = 32
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "invalid"
    return L3_2
  end
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A1_2.id
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  if not (L3_2 and L4_2) or L4_2 < 1 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "notfound"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT id, app, data, actions, `read` FROM apex_phone_notifications WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "notfound"
    return L6_2
  end
  L6_2 = false
  L7_2 = ipairs
  L8_2 = L17_1
  L9_2 = L5_2.actions
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = {}
  end
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.id
    if L13_2 == L2_2 then
      L6_2 = true
      break
    end
  end
  if not L6_2 then
    L7_2 = Dbg
    L8_2 = "notif"
    L9_2 = "action \"%s\" rejected on #%s (not one of the saved actions)"
    L10_2 = L2_2
    L11_2 = L5_2.id
    L7_2(L8_2, L9_2, L10_2, L11_2)
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "invalid"
    return L7_2
  end
  L7_2 = tonumber
  L8_2 = L5_2.read
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  if 0 == L7_2 then
    L7_2 = MySQL
    L7_2 = L7_2.update
    L8_2 = "UPDATE apex_phone_notifications SET `read` = 1 WHERE id = ?"
    L9_2 = {}
    L10_2 = L4_2
    L9_2[1] = L10_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = Dbg
  L8_2 = "notif"
  L9_2 = "action \"%s\" on #%s (%s) by %s"
  L10_2 = L2_2
  L11_2 = L5_2.id
  L12_2 = L5_2.app
  L13_2 = A0_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L7_2 = TriggerEvent
  L8_2 = "apex_phone:notificationAction"
  L9_2 = A0_2
  L10_2 = tonumber
  L11_2 = L5_2.id
  L10_2 = L10_2(L11_2)
  L11_2 = L2_2
  L12_2 = L90_1
  L13_2 = L5_2.data
  L12_2, L13_2 = L12_2(L13_2)
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L7_2 = {}
  L7_2.ok = true
  return L7_2
end
L92_1[L93_1] = L94_1
function L92_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Notifications
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Notifications
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = tonumber
  L2_2 = L0_2.keepDays
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 14
  end
  L2_2 = 0
  if L1_2 > 0 then
    L3_2 = L4_1
    L3_2 = L3_2()
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L1_2 * 86400000
    L4_2 = L4_2(L5_2)
    L3_2 = L3_2 - L4_2
    L4_2 = 1
    L5_2 = 40
    L6_2 = 1
    for L7_2 = L4_2, L5_2, L6_2 do
      L8_2 = MySQL
      L8_2 = L8_2.update
      L8_2 = L8_2.await
      L9_2 = "DELETE FROM apex_phone_notifications WHERE created < ? LIMIT 5000"
      L10_2 = {}
      L11_2 = L3_2
      L10_2[1] = L11_2
      L8_2 = L8_2(L9_2, L10_2)
      if not L8_2 then
        L8_2 = 0
      end
      L9_2 = tonumber
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if not L9_2 then
        L9_2 = 0
      end
      L2_2 = L2_2 + L9_2
      L9_2 = tonumber
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if not L9_2 then
        L9_2 = 0
      end
      L10_2 = 5000
      if L9_2 < L10_2 then
        break
      end
      L9_2 = Wait
      L10_2 = 100
      L9_2(L10_2)
    end
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = L0_2.maxPerPlayer
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 200
  end
  L3_2 = L3_2(L4_2)
  if L3_2 and L3_2 > 0 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "SELECT owner FROM apex_phone_notifications GROUP BY owner HAVING COUNT(*) > ? LIMIT 500"
    L6_2 = {}
    L7_2 = L3_2
    L6_2[1] = L7_2
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = {}
    end
    L5_2 = ipairs
    L6_2 = L4_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = MySQL
      L11_2 = L11_2.scalar
      L11_2 = L11_2.await
      L12_2 = "SELECT id FROM apex_phone_notifications WHERE owner = ? ORDER BY id DESC LIMIT 1 OFFSET %d"
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = L3_2 - 1
      L12_2 = L12_2(L13_2, L14_2)
      L13_2 = {}
      L14_2 = L10_2.owner
      L13_2[1] = L14_2
      L11_2 = L11_2(L12_2, L13_2)
      if L11_2 then
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "DELETE FROM apex_phone_notifications WHERE owner = ? AND id < ?"
        L14_2 = {}
        L15_2 = L10_2.owner
        L16_2 = L11_2
        L14_2[1] = L15_2
        L14_2[2] = L16_2
        L12_2 = L12_2(L13_2, L14_2)
        if not L12_2 then
          L12_2 = 0
        end
        L13_2 = tonumber
        L14_2 = L12_2
        L13_2 = L13_2(L14_2)
        if not L13_2 then
          L13_2 = 0
        end
        L2_2 = L2_2 + L13_2
      end
    end
  end
  if L2_2 > 0 then
    L4_2 = Dbg
    L5_2 = "notif"
    L6_2 = "cleanup: %d notification(s) deleted"
    L7_2 = L2_2
    L4_2(L5_2, L6_2, L7_2)
  end
end
L93_1 = {}
L94_1 = {}
L95_1 = "key"
L96_1 = "calls"
L94_1[L95_1] = L96_1
L95_1 = "tbl"
L96_1 = "apex_phone_calls"
L94_1[L95_1] = L96_1
L95_1 = {}
L96_1 = "key"
L97_1 = "transactions"
L95_1[L96_1] = L97_1
L96_1 = "tbl"
L97_1 = "apex_phone_transactions"
L95_1[L96_1] = L97_1
L96_1 = {}
L97_1 = "key"
L98_1 = "bills"
L96_1[L97_1] = L98_1
L97_1 = "tbl"
L98_1 = "apex_phone_bills"
L96_1[L97_1] = L98_1
L97_1 = "extra"
L98_1 = "status <> 'pending'"
L96_1[L97_1] = L98_1
L97_1 = {}
L98_1 = "key"
L99_1 = "posts"
L97_1[L98_1] = L99_1
L98_1 = "tbl"
L97_1[L98_1] = "apex_phone_posts"
L98_1 = {}
L99_1 = "key"
L100_1 = "messages"
L98_1[L99_1] = L100_1
L99_1 = "tbl"
L98_1[L99_1] = "apex_phone_messages"
L99_1 = {}
L100_1 = "key"
L101_1 = "services"
L99_1[L100_1] = L101_1
L100_1 = "tbl"
L101_1 = "apex_phone_services"
L99_1[L100_1] = L101_1
L100_1 = {}
L101_1 = "key"
L102_1 = "eatsOrders"
L100_1[L101_1] = L102_1
L101_1 = "tbl"
L102_1 = "apex_phone_eats_orders"
L100_1[L101_1] = L102_1
L101_1 = "extra"
L102_1 = "status IN ('delivered', 'cancelled')"
L100_1[L101_1] = L102_1
L101_1 = {}
L102_1 = "key"
L103_1 = "onionOrders"
L101_1[L102_1] = L103_1
L102_1 = "tbl"
L103_1 = "apex_phone_onion_orders"
L101_1[L102_1] = L103_1
L102_1 = "extra"
L103_1 = "status IN ('concluido', 'cancelado') AND NOT EXISTS (SELECT 1 FROM apex_phone_item_escrow e WHERE e.`source` = 'onion' AND e.ref_id = apex_phone_onion_orders.id AND e.status = 'held')"
L101_1[L102_1] = L103_1
L93_1[1] = L94_1
L93_1[2] = L95_1
L93_1[3] = L96_1
L93_1[4] = L97_1
L93_1[5] = L98_1
L93_1[6] = L99_1
L93_1[7] = L100_1
L93_1[8] = L101_1
L94_1 = {}
L95_1 = {}
L96_1 = "apex_phone_likes"
L97_1 = "post_id"
L98_1 = "apex_phone_posts"
L95_1[1] = L96_1
L95_1[2] = L97_1
L95_1[3] = L98_1
L96_1 = {}
L97_1 = "apex_phone_saves"
L98_1 = "post_id"
L99_1 = "apex_phone_posts"
L96_1[1] = L97_1
L96_1[2] = L98_1
L96_1[3] = L99_1
L97_1 = {}
L98_1 = "apex_phone_comments"
L99_1 = "post_id"
L100_1 = "apex_phone_posts"
L97_1[1] = L98_1
L97_1[2] = L99_1
L97_1[3] = L100_1
L98_1 = {}
L99_1 = "apex_phone_comment_likes"
L100_1 = "comment_id"
L101_1 = "apex_phone_comments"
L98_1[1] = L99_1
L98_1[2] = L100_1
L98_1[3] = L101_1
L94_1[1] = L95_1
L94_1[2] = L96_1
L94_1[3] = L97_1
L94_1[4] = L98_1
L95_1 = {}
L96_1 = {}
L97_1 = "apex_phone_message_reactions"
L98_1 = "message_id"
L99_1 = "apex_phone_messages"
L96_1[1] = L97_1
L96_1[2] = L98_1
L96_1[3] = L99_1
L97_1 = {}
L98_1 = "apex_phone_recado_stars"
L99_1 = "message_id"
L100_1 = "apex_phone_messages"
L97_1[1] = L98_1
L97_1[2] = L99_1
L97_1[3] = L100_1
L98_1 = {}
L99_1 = "apex_phone_recado_pins"
L100_1 = "message_id"
L101_1 = "apex_phone_messages"
L98_1[1] = L99_1
L98_1[2] = L100_1
L98_1[3] = L101_1
L99_1 = {}
L100_1 = "apex_phone_recado_views"
L101_1 = "message_id"
L102_1 = "apex_phone_messages"
L99_1[1] = L100_1
L99_1[2] = L101_1
L99_1[3] = L102_1
L95_1[1] = L96_1
L95_1[2] = L97_1
L95_1[3] = L98_1
L95_1[4] = L99_1
function L96_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = "DELETE FROM %s WHERE NOT EXISTS (SELECT 1 FROM %s p WHERE p.id = %s.%s) LIMIT %d"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L7_2[1]
    L11_2 = L7_2[3]
    L12_2 = L7_2[1]
    L13_2 = L7_2[2]
    L14_2 = A1_2
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L9_2 = pcall
    function L10_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
      L0_3 = 1
      L1_3 = 20
      L2_3 = 1
      for L3_3 = L0_3, L1_3, L2_3 do
        L4_3 = tonumber
        L5_3 = MySQL
        L5_3 = L5_3.update
        L5_3 = L5_3.await
        L6_3 = L8_2
        L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L5_3(L6_3)
        L4_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
        if not L4_3 then
          L4_3 = 0
        end
        if L4_3 > 0 then
          L5_3 = Dbg
          L6_3 = "prune"
          L7_3 = "orphans: %d row(s) of %s without %s"
          L8_3 = L4_3
          L9_3 = L7_2
          L9_3 = L9_3[1]
          L10_3 = L7_2
          L10_3 = L10_3[3]
          L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
        end
        L5_3 = A1_2
        if L4_3 < L5_3 then
          break
        end
        L5_3 = Wait
        L6_3 = 100
        L5_3(L6_3)
      end
    end
    L9_2, L10_2 = L9_2(L10_2)
    if not L9_2 then
      L11_2 = print
      L12_2 = "^3[unique_phone]^0 orphans of %s: %s"
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = L7_2[1]
      L15_2 = tostring
      L16_2 = L10_2
      L15_2, L16_2 = L15_2(L16_2)
      L12_2, L13_2, L14_2, L15_2, L16_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
      L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
    end
  end
end
function L97_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = [[
DELETE FROM apex_phone_posts WHERE id IN (
        SELECT id FROM (SELECT r.id FROM apex_phone_posts r
            LEFT JOIN apex_phone_posts p ON p.id = r.reply_to
            WHERE r.reply_to IS NOT NULL AND p.id IS NULL LIMIT %d) x)]]
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = 1
    L1_3 = 20
    L2_3 = 1
    for L3_3 = L0_3, L1_3, L2_3 do
      L4_3 = tonumber
      L5_3 = MySQL
      L5_3 = L5_3.update
      L5_3 = L5_3.await
      L6_3 = L1_2
      L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
      L4_3 = L4_3(L5_3, L6_3, L7_3, L8_3)
      if not L4_3 then
        L4_3 = 0
      end
      if L4_3 > 0 then
        L5_3 = Dbg
        L6_3 = "prune"
        L7_3 = "orphans: %d repl(ies) without a post"
        L8_3 = L4_3
        L5_3(L6_3, L7_3, L8_3)
      end
      if 0 == L4_3 then
        break
      end
      L5_3 = Wait
      L6_3 = 100
      L5_3(L6_3)
    end
  end
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = print
    L5_2 = "^3[unique_phone]^0 orphans of apex_phone_posts (replies): %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
end
function L98_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = [[
UPDATE apex_phone_conversations
        SET last_id = (SELECT MAX(m.id) FROM apex_phone_messages m WHERE m.conversation_id = apex_phone_conversations.id)
        WHERE last_id IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM apex_phone_messages m2 WHERE m2.id = apex_phone_conversations.last_id)
        LIMIT %d]]
  L2_2 = L1_2
  L1_2 = L1_2.format
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = 1
    L1_3 = 20
    L2_3 = 1
    for L3_3 = L0_3, L1_3, L2_3 do
      L4_3 = tonumber
      L5_3 = MySQL
      L5_3 = L5_3.update
      L5_3 = L5_3.await
      L6_3 = L1_2
      L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
      L4_3 = L4_3(L5_3, L6_3, L7_3, L8_3)
      if not L4_3 then
        L4_3 = 0
      end
      if L4_3 > 0 then
        L5_3 = Dbg
        L6_3 = "prune"
        L7_3 = "%d conversation(s) with the last message deleted: last_id corrected"
        L8_3 = L4_3
        L5_3(L6_3, L7_3, L8_3)
      end
      if 0 == L4_3 then
        break
      end
      L5_3 = Wait
      L6_3 = 100
      L5_3(L6_3)
    end
  end
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = print
    L5_2 = "^3[unique_phone]^0 conversations last_id: %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
end
function L99_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Retention
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Retention
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = tonumber
  L3_2 = L0_2.batch
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 2000
  end
  L1_2 = L1_2(L2_2)
  if L1_2 < 100 then
    L1_2 = 100
  else
    L2_2 = 20000
    if L1_2 > L2_2 then
      L1_2 = 20000
    end
  end
  L2_2 = L0_2
  L3_2 = L1_2
  return L2_2, L3_2
end
function L100_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L4_2 = "DELETE FROM %s WHERE created < ?%s LIMIT %d"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = A0_2
  if A2_2 then
    L7_2 = " AND "
    L8_2 = A2_2
    L7_2 = L7_2 .. L8_2
    if L7_2 then
      goto lbl_12
    end
  end
  L7_2 = ""
  ::lbl_12::
  L8_2 = A3_2
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L5_2 = 0
  L6_2 = 1
  L7_2 = 40
  L8_2 = 1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = tonumber
    L11_2 = MySQL
    L11_2 = L11_2.update
    L11_2 = L11_2.await
    L12_2 = L4_2
    L13_2 = {}
    L14_2 = A1_2
    L13_2[1] = L14_2
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
    if not L10_2 then
      L10_2 = 0
    end
    L5_2 = L5_2 + L10_2
    if A3_2 > L10_2 then
      break
    end
    L11_2 = Wait
    L12_2 = 100
    L11_2(L12_2)
  end
  return L5_2
end
function L101_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = L99_1
  L0_2, L1_2 = L0_2()
  L2_2 = false
  L3_2 = false
  L4_2 = ipairs
  L5_2 = L93_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = tonumber
    L11_2 = L9_2.key
    L11_2 = L0_2[L11_2]
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    if L10_2 > 0 then
      L11_2 = L4_1
      L11_2 = L11_2()
      L12_2 = math
      L12_2 = L12_2.floor
      L13_2 = L10_2 * 86400000
      L12_2 = L12_2(L13_2)
      L11_2 = L11_2 - L12_2
      L12_2 = pcall
      L13_2 = L100_1
      L14_2 = L9_2.tbl
      L15_2 = L11_2
      L16_2 = L9_2.extra
      L17_2 = L1_2
      L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
      if not L12_2 then
        L14_2 = print
        L15_2 = "^3[unique_phone]^0 retention of %s: %s"
        L16_2 = L15_2
        L15_2 = L15_2.format
        L17_2 = L9_2.tbl
        L18_2 = tostring
        L19_2 = L13_2
        L18_2, L19_2, L20_2 = L18_2(L19_2)
        L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
        L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      else
        L14_2 = L13_2 or L14_2
        if not L13_2 then
          L14_2 = 0
        end
        if L14_2 > 0 then
          L14_2 = Dbg
          L15_2 = "prune"
          L16_2 = "%s: %d row(s) older than %s day(s) deleted"
          L17_2 = L9_2.tbl
          L18_2 = L13_2
          L19_2 = tostring
          L20_2 = L10_2
          L19_2, L20_2 = L19_2(L20_2)
          L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
          L14_2 = L9_2.key
          if "posts" == L14_2 then
            L2_2 = true
          end
          L14_2 = L9_2.key
          if "messages" == L14_2 then
            L3_2 = true
          end
        end
      end
    end
  end
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = tonumber
  L6_2 = L0_2.maxPostsPerAccount
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  if L4_2 > 0 then
    L5_2 = pcall
    function L6_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "SELECT app, author FROM apex_phone_posts GROUP BY app, author HAVING COUNT(*) > ? LIMIT 500"
      L2_3 = {}
      L3_3 = L4_2
      L2_3[1] = L3_3
      L0_3 = L0_3(L1_3, L2_3)
      if not L0_3 then
        L0_3 = {}
      end
      L1_3 = ipairs
      L2_3 = L0_3
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
      for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
        L7_3 = MySQL
        L7_3 = L7_3.scalar
        L7_3 = L7_3.await
        L8_3 = "SELECT id FROM apex_phone_posts WHERE app = ? AND author = ? ORDER BY id DESC LIMIT 1 OFFSET %d"
        L9_3 = L8_3
        L8_3 = L8_3.format
        L10_3 = L4_2
        L10_3 = L10_3 - 1
        L8_3 = L8_3(L9_3, L10_3)
        L9_3 = {}
        L10_3 = L6_3.app
        L11_3 = L6_3.author
        L9_3[1] = L10_3
        L9_3[2] = L11_3
        L7_3 = L7_3(L8_3, L9_3)
        if L7_3 then
          L8_3 = tonumber
          L9_3 = MySQL
          L9_3 = L9_3.update
          L9_3 = L9_3.await
          L10_3 = "DELETE FROM apex_phone_posts WHERE app = ? AND author = ? AND id < ?"
          L11_3 = {}
          L12_3 = L6_3.app
          L13_3 = L6_3.author
          L14_3 = L7_3
          L11_3[1] = L12_3
          L11_3[2] = L13_3
          L11_3[3] = L14_3
          L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L9_3(L10_3, L11_3)
          L8_3 = L8_3(L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
          if not L8_3 then
            L8_3 = 0
          end
          if L8_3 > 0 then
            L9_3 = true
            L2_2 = L9_3
            L9_3 = Dbg
            L10_3 = "prune"
            L11_3 = "post cap: %d deleted from @%s (%s)"
            L12_3 = L8_3
            L13_3 = tostring
            L14_3 = L6_3.author
            L13_3 = L13_3(L14_3)
            L14_3 = tostring
            L15_3 = L6_3.app
            L14_3, L15_3 = L14_3(L15_3)
            L9_3(L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
          end
        end
        L8_3 = Wait
        L9_3 = 50
        L8_3(L9_3)
      end
    end
    L5_2, L6_2 = L5_2(L6_2)
    if not L5_2 then
      L7_2 = print
      L8_2 = "^3[unique_phone]^0 post cap: %s"
      L9_2 = L8_2
      L8_2 = L8_2.format
      L10_2 = tostring
      L11_2 = L6_2
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L10_2(L11_2)
      L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    end
  end
  if L2_2 then
    L5_2 = L97_1
    L6_2 = L1_2
    L5_2(L6_2)
    L5_2 = L96_1
    L6_2 = L94_1
    L7_2 = L1_2
    L5_2(L6_2, L7_2)
  end
  if L3_2 then
    L5_2 = L96_1
    L6_2 = L95_1
    L7_2 = L1_2
    L5_2(L6_2, L7_2)
    L5_2 = L98_1
    L6_2 = L1_2
    L5_2(L6_2)
  end
end
L102_1 = _ENV
L103_1 = "CreateThread"
L102_1 = L102_1[L103_1]
function L103_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  while true do
    L0_2 = DBReady
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 120000
  L0_2(L1_2)
  L0_2 = L99_1
  L0_2 = L0_2()
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 15
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = tonumber
  L5_2 = L0_2.minutes
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 60
  end
  L3_2 = L3_2(L4_2)
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = 0
  while true do
    L3_2 = pcall
    L4_2 = L92_1
    L3_2, L4_2 = L3_2(L4_2)
    if not L3_2 then
      L5_2 = print
      L6_2 = "^3[unique_phone]^0 notification cleanup: %s"
      L7_2 = L6_2
      L6_2 = L6_2.format
      L8_2 = tostring
      L9_2 = L4_2
      L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2)
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    end
    L5_2 = os
    L5_2 = L5_2.time
    L5_2 = L5_2()
    L6_2 = L5_2 - L2_2
    L7_2 = L1_2 * 60
    if L6_2 >= L7_2 then
      L2_2 = L5_2
      L6_2 = pcall
      L7_2 = L101_1
      L6_2, L7_2 = L6_2(L7_2)
      if not L6_2 then
        L8_2 = print
        L9_2 = "^3[unique_phone]^0 retention: %s"
        L10_2 = L9_2
        L9_2 = L9_2.format
        L11_2 = tostring
        L12_2 = L7_2
        L11_2, L12_2 = L11_2(L12_2)
        L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2)
        L8_2(L9_2, L10_2, L11_2, L12_2)
      end
    end
    L6_2 = Wait
    L7_2 = 900000
    L6_2(L7_2)
  end
end
L102_1(L103_1)
function L102_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  if 0 == A0_2 then
    L3_2 = print
    L4_2 = "[unique_phone] "
    L5_2 = ConsoleText
    if L5_2 then
      L5_2 = ConsoleText
      L6_2 = A1_2
      L5_2 = L5_2(L6_2)
      if L5_2 then
        goto lbl_14
      end
    end
    L5_2 = A1_2
    ::lbl_14::
    L4_2 = L4_2 .. L5_2
    L3_2(L4_2)
  else
    L3_2 = FW
    L3_2 = L3_2.Notify
    L4_2 = A0_2
    L5_2 = A1_2
    L6_2 = A2_2
    L3_2(L4_2, L5_2, L6_2)
  end
end
L103_1 = _ENV
L104_1 = "FW"
L103_1 = L103_1[L104_1]
L104_1 = "AddCommand"
L103_1 = L103_1[L104_1]
L104_1 = "phonereset"
L105_1 = "Repor telem\195\179vel de um jogador (admin)"
L106_1 = {}
L107_1 = {}
L108_1 = "name"
L109_1 = "id"
L107_1[L108_1] = L109_1
L108_1 = "help"
L109_1 = "ID do jogador (opcional, vazio = tu)"
L107_1[L108_1] = L109_1
L106_1[1] = L107_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = tonumber
  L3_2 = A1_2 or L3_2
  if A1_2 then
    L3_2 = A1_2[1]
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A0_2
  end
  if 0 == L2_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "uso: phonereset <id>"
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayer
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L102_1
    L5_2 = A0_2
    L6_2 = "Jogador n\195\163o encontrado."
    L7_2 = "error"
    L4_2(L5_2, L6_2, L7_2)
    return
  end
  L4_2 = ResetAccount
  L5_2 = L3_2.cid
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = TriggerClientEvent
    L5_2 = "apex_phone:client:reset"
    L6_2 = L2_2
    L4_2(L5_2, L6_2)
    L4_2 = L102_1
    L5_2 = A0_2
    L6_2 = "Telem\195\179vel de %s reposto."
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = L3_2.firstname
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = "success"
    L4_2(L5_2, L6_2, L7_2)
    if L2_2 ~= A0_2 then
      L4_2 = FW
      L4_2 = L4_2.Notify
      L5_2 = L2_2
      L6_2 = "O teu telem\195\179vel foi reposto de f\195\161brica."
      L7_2 = "primary"
      L4_2(L5_2, L6_2, L7_2)
    end
  else
    L4_2 = L102_1
    L5_2 = A0_2
    L6_2 = "N\195\163o foi poss\195\173vel repor."
    L7_2 = "error"
    L4_2(L5_2, L6_2, L7_2)
  end
end
L108_1 = "admin"
L103_1(L104_1, L105_1, L106_1, L107_1, L108_1)
L103_1 = _ENV
L104_1 = "FW"
L103_1 = L103_1[L104_1]
L104_1 = "AddCommand"
L103_1 = L103_1[L104_1]
L104_1 = "testnotif"
L105_1 = "Simular uma notifica\195\167\195\163o no telem\195\179vel (admin)"
L106_1 = {}
L107_1 = {}
L108_1 = "name"
L109_1 = "id"
L107_1[L108_1] = L109_1
L108_1 = "help"
L109_1 = "ID do jogador (vazio = tu)"
L107_1[L108_1] = L109_1
L108_1 = {}
L109_1 = "name"
L110_1 = "app"
L108_1[L109_1] = L110_1
L109_1 = "help"
L110_1 = "app: messages, mail, eats, marketplace\226\128\166 (por omiss\195\163o messages)"
L108_1[L109_1] = L110_1
L109_1 = {}
L110_1 = "name"
L111_1 = "titulo"
L109_1[L110_1] = L111_1
L110_1 = "help"
L111_1 = "t\195\173tulo da notifica\195\167\195\163o"
L109_1[L110_1] = L111_1
L110_1 = {}
L111_1 = "name"
L112_1 = "mensagem"
L110_1[L111_1] = L112_1
L111_1 = "help"
L112_1 = "texto da notifica\195\167\195\163o"
L110_1[L111_1] = L112_1
L106_1[1] = L107_1
L106_1[2] = L108_1
L106_1[3] = L109_1
L106_1[4] = L110_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = tonumber
  L3_2 = A1_2[1]
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A0_2
  end
  if 0 == L2_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "uso: testnotif <id> [app] [titulo] [mensagem]"
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayer
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L102_1
    L5_2 = A0_2
    L6_2 = "Jogador n\195\163o encontrado."
    L7_2 = "error"
    L4_2(L5_2, L6_2, L7_2)
    return
  end
  L4_2 = tostring
  L5_2 = A1_2[2]
  if not L5_2 then
    L5_2 = "messages"
  end
  L4_2 = L4_2(L5_2)
  L5_2 = tostring
  L6_2 = A1_2[3]
  if not L6_2 then
    L6_2 = "Notifica\195\167\195\163o de teste"
  end
  L5_2 = L5_2(L6_2)
  L6_2 = ""
  L7_2 = 4
  L8_2 = #A1_2
  L9_2 = 1
  for L10_2 = L7_2, L8_2, L9_2 do
    L11_2 = L6_2
    if L10_2 > 4 then
      L12_2 = " "
      if L12_2 then
        goto lbl_56
      end
    end
    L12_2 = ""
    ::lbl_56::
    L13_2 = tostring
    L14_2 = A1_2[L10_2]
    L13_2 = L13_2(L14_2)
    L11_2 = L11_2 .. L12_2 .. L13_2
    L6_2 = L11_2
  end
  if "" == L6_2 then
    L6_2 = "Se est\195\161s a ler isto, as notifica\195\167\195\181es funcionam."
  end
  L7_2 = NotifyPlayer
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = L5_2
  L11_2 = L6_2
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = L102_1
  L8_2 = A0_2
  L9_2 = "Notifica\195\167\195\163o enviada a %s (app \"%s\")."
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L3_2.firstname
  if not L11_2 then
    L11_2 = L2_2
  end
  L12_2 = L4_2
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L10_2 = "success"
  L7_2(L8_2, L9_2, L10_2)
end
L108_1 = "admin"
L103_1(L104_1, L105_1, L106_1, L107_1, L108_1)
L103_1 = _ENV
L104_1 = "exports"
L103_1 = L103_1[L104_1]
L104_1 = "TestNotification"
function L105_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  if not A0_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = NotifyPlayer
  L5_2 = A0_2
  L6_2 = A1_2 or L6_2
  if not A1_2 then
    L6_2 = "messages"
  end
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = "Notifica\195\167\195\163o"
  end
  L8_2 = A3_2 or L8_2
  if not A3_2 then
    L8_2 = ""
  end
  L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = true
  return L4_2
end
L103_1(L104_1, L105_1)
L103_1 = _ENV
L104_1 = "FW"
L103_1 = L103_1[L104_1]
L104_1 = "AddCommand"
L103_1 = L103_1[L104_1]
L104_1 = "phonegive"
L105_1 = "Dar um telem\195\179vel a um jogador (admin)"
L106_1 = {}
L107_1 = {}
L108_1 = "name"
L109_1 = "id"
L107_1[L108_1] = L109_1
L108_1 = "help"
L109_1 = "ID do jogador (vazio = tu)"
L107_1[L108_1] = L109_1
L108_1 = {}
L109_1 = "name"
L110_1 = "item"
L108_1[L109_1] = L110_1
L109_1 = "help"
L110_1 = "item: %s"
L112_1 = "format"
L111_1 = L110_1
L110_1 = L110_1[L112_1]
L112_1 = _ENV
L113_1 = "table"
L112_1 = L112_1[L113_1]
L113_1 = "concat"
L112_1 = L112_1[L113_1]
L113_1 = _ENV
L114_1 = "Config"
L113_1 = L113_1[L114_1]
L114_1 = "DeviceOrder"
L113_1 = L113_1[L114_1]
if not L113_1 then
  L113_1 = {}
end
L114_1 = ", "
L112_1 = L112_1(L113_1, L114_1)
L113_1 = _ENV
L114_1 = "Config"
L113_1 = L113_1[L114_1]
L114_1 = "PhoneItem"
L113_1 = L113_1[L114_1]
if L113_1 then
  L113_1 = _ENV
  L114_1 = "Config"
  L113_1 = L113_1[L114_1]
  L114_1 = "PhoneItem"
  L113_1 = L113_1[L114_1]
  L114_1 = ""
  if L113_1 ~= L114_1 then
    L113_1 = ", "
    L114_1 = _ENV
    L115_1 = "Config"
    L114_1 = L114_1[L115_1]
    L115_1 = "PhoneItem"
    L114_1 = L114_1[L115_1]
    L113_1 = L113_1 .. L114_1
    if L113_1 then
      goto lbl_1076
    end
  end
end
L113_1 = ""
::lbl_1076::
L112_1 = L112_1 .. L113_1
L110_1 = L110_1(L111_1, L112_1)
L108_1[L109_1] = L110_1
L106_1[1] = L107_1
L106_1[2] = L108_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = tonumber
  L3_2 = A1_2[1]
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A0_2
  end
  if 0 == L2_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "uso: phonegive <id> [item]"
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = GetPlayerName
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "Jogador n\195\163o encontrado."
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = A1_2[2]
  if L3_2 then
    L3_2 = tostring
    L4_2 = A1_2[2]
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_45
    end
  end
  L3_2 = Config
  L3_2 = L3_2.DeviceOrder
  if L3_2 then
    L3_2 = Config
    L3_2 = L3_2.DeviceOrder
    L3_2 = L3_2[1]
    if L3_2 then
      goto lbl_45
    end
  end
  L3_2 = Config
  L3_2 = L3_2.PhoneItem
  ::lbl_45::
  L4_2 = L3_2 or L4_2
  if L3_2 then
    L4_2 = Config
    L4_2 = L4_2.Devices
    if L4_2 then
      L4_2 = Config
      L4_2 = L4_2.Devices
      L4_2 = L4_2[L3_2]
      if L4_2 then
        goto lbl_62
      end
    end
    L4_2 = Config
    L4_2 = L4_2.PhoneItem
    L4_2 = L3_2 == L4_2
  end
  ::lbl_62::
  if not L4_2 then
    L5_2 = L102_1
    L6_2 = A0_2
    L7_2 = "Item inv\195\161lido: %s"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = tostring
    L10_2 = L3_2
    L9_2, L10_2, L11_2 = L9_2(L10_2)
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
    L8_2 = "error"
    L5_2(L6_2, L7_2, L8_2)
    return
  end
  L5_2 = FW
  L5_2 = L5_2.InventoryName
  L5_2 = L5_2()
  if not L5_2 then
    L5_2 = L102_1
    L6_2 = A0_2
    L7_2 = "N\195\163o h\195\161 invent\195\161rio (ox_inventory / qb / esx) para dar o item."
    L8_2 = "error"
    L5_2(L6_2, L7_2, L8_2)
    return
  end
  L5_2 = FW
  L5_2 = L5_2.AddItem
  L6_2 = L2_2
  L7_2 = L3_2
  L8_2 = 1
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L5_2 = L102_1
    L6_2 = A0_2
    L7_2 = "%s entregue a %s."
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = L3_2
    L10_2 = GetPlayerName
    L11_2 = L2_2
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = L2_2
    end
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L8_2 = "success"
    L5_2(L6_2, L7_2, L8_2)
  else
    L5_2 = L102_1
    L6_2 = A0_2
    L7_2 = "N\195\163o foi poss\195\173vel dar %s (item registado no invent\195\161rio? espa\195\167o livre?)."
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = L3_2
    L7_2 = L7_2(L8_2, L9_2)
    L8_2 = "error"
    L5_2(L6_2, L7_2, L8_2)
  end
end
L108_1 = "admin"
L103_1(L104_1, L105_1, L106_1, L107_1, L108_1)
L103_1 = _ENV
L104_1 = "FW"
L103_1 = L103_1[L104_1]
L104_1 = "AddCommand"
L103_1 = L103_1[L104_1]
L104_1 = "phoneopen"
L105_1 = "Abrir o telem\195\179vel de um jogador (admin)"
L106_1 = {}
L107_1 = {}
L108_1 = "name"
L109_1 = "id"
L107_1[L108_1] = L109_1
L108_1 = "help"
L109_1 = "ID do jogador (vazio = tu)"
L107_1[L108_1] = L109_1
L108_1 = {}
L109_1 = "name"
L110_1 = "app"
L108_1[L109_1] = L110_1
L109_1 = "help"
L110_1 = "app a abrir (opcional): messages, phone, settings\226\128\166"
L108_1[L109_1] = L110_1
L106_1[1] = L107_1
L106_1[2] = L108_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = tonumber
  L3_2 = A1_2[1]
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A0_2
  end
  if 0 == L2_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "uso: phoneopen <id> [app]"
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = GetPlayerName
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "Jogador n\195\163o encontrado."
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = A1_2[2]
  if L3_2 then
    L3_2 = tostring
    L4_2 = A1_2[2]
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 32
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_39
    end
  end
  L3_2 = nil
  ::lbl_39::
  if L3_2 then
    L5_2 = L3_2
    L4_2 = L3_2.match
    L6_2 = "^[%w_%-%.]+$"
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = L102_1
      L5_2 = A0_2
      L6_2 = "Nome de app inv\195\161lido."
      L7_2 = "error"
      L4_2(L5_2, L6_2, L7_2)
      return
    end
  end
  L4_2 = TriggerClientEvent
  L5_2 = "apex_phone:client:forceOpen"
  L6_2 = L2_2
  L7_2 = L3_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = L102_1
  L5_2 = A0_2
  if L3_2 then
    L6_2 = "Telem\195\179vel de %s aberto em %s."
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = GetPlayerName
    L9_2 = L2_2
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L8_2 = L2_2
    end
    L9_2 = L3_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_82
    end
  end
  L6_2 = "Telem\195\179vel de %s aberto."
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = GetPlayerName
  L9_2 = L2_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = L2_2
  end
  L6_2 = L6_2(L7_2, L8_2)
  ::lbl_82::
  L7_2 = "success"
  L4_2(L5_2, L6_2, L7_2)
end
L108_1 = "admin"
L103_1(L104_1, L105_1, L106_1, L107_1, L108_1)
L103_1 = {}
L104_1 = "mensagem"
function L105_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = "messages"
  L2_2 = "M\195\163e"
  L3_2 = "J\195\161 jantaste? Liga-me quando puderes, tenho novidades."
  L4_2 = {}
  return L1_2, L2_2, L3_2, L4_2
end
L103_1[L104_1] = L105_1
L104_1 = "email"
function L105_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = "mail"
  L2_2 = "Apex Mobile"
  L3_2 = "Bem-vindo! A tua conta est\195\161 ativa e o cart\195\163o SIM foi registado."
  L4_2 = {}
  return L1_2, L2_2, L3_2, L4_2
end
L103_1[L104_1] = L105_1
L104_1 = "banco"
function L105_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = "wallet"
  L2_2 = "Pagamento recebido"
  L3_2 = "Recebeste %s de %s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = FormatMoney
  L6_2 = 250
  L5_2 = L5_2(L6_2)
  L6_2 = "M\195\163e"
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = {}
  return L1_2, L2_2, L3_2, L4_2
end
L103_1[L104_1] = L105_1
L104_1 = "sistema"
function L105_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = "settings"
  L2_2 = "Teste de notifica\195\167\195\163o"
  L3_2 = "Isto \195\169 uma notifica\195\167\195\163o de teste no teu %s."
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = {}
  return L1_2, L2_2, L3_2, L4_2
end
L103_1[L104_1] = L105_1
L104_1 = "acoes"
function L105_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = "messages"
  L2_2 = "Garagem Central"
  L3_2 = "O teu carro est\195\161 pronto. Queres que o tragamos?"
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  L6_2.id = "sim"
  L6_2.label = "Sim"
  L7_2 = {}
  L7_2.id = "nao"
  L7_2.label = "N\195\163o"
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L4_2.actions = L5_2
  return L1_2, L2_2, L3_2, L4_2
end
L103_1[L104_1] = L105_1
L104_1 = _ENV
L105_1 = "FW"
L104_1 = L104_1[L105_1]
L105_1 = "AddCommand"
L104_1 = L104_1[L105_1]
L105_1 = "testnotif"
L106_1 = "Testar uma notifica\195\167\195\163o no telem\195\179vel (admin)"
L107_1 = {}
L108_1 = {}
L109_1 = "name"
L110_1 = "id"
L108_1[L109_1] = L110_1
L109_1 = "help"
L110_1 = "ID do jogador (vazio = tu)"
L108_1[L109_1] = L110_1
L109_1 = {}
L110_1 = "name"
L111_1 = "tipo"
L109_1[L110_1] = L111_1
L110_1 = "help"
L111_1 = "%s (vazio = %s)"
L113_1 = "format"
L112_1 = L111_1
L111_1 = L111_1[L113_1]
L113_1 = "mensagem | email | banco | sistema | acoes | todas"
L114_1 = "mensagem"
L111_1 = L111_1(L112_1, L113_1, L114_1)
L109_1[L110_1] = L111_1
L107_1[1] = L108_1
L107_1[2] = L109_1
function L108_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = tonumber
  L3_2 = A1_2[1]
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A0_2
  end
  if 0 == L2_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "uso: testnotif <id> [tipo]"
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = GetPlayerName
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "Jogador n\195\163o encontrado."
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = A1_2[2]
  if L3_2 then
    L3_2 = tostring
    L4_2 = A1_2[2]
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.lower
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_37
    end
  end
  L3_2 = "mensagem"
  ::lbl_37::
  L4_2 = DeviceModelOf
  if L4_2 then
    L4_2 = DeviceModelOf
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_46
    end
  end
  L4_2 = "telem\195\179vel"
  ::lbl_46::
  L5_2 = {}
  if "todas" == L3_2 then
    L6_2 = {}
    L7_2 = "mensagem"
    L8_2 = "email"
    L9_2 = "banco"
    L10_2 = "acoes"
    L11_2 = "sistema"
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L6_2[4] = L10_2
    L6_2[5] = L11_2
    L5_2 = L6_2
  else
    L6_2 = L103_1
    L6_2 = L6_2[L3_2]
    if L6_2 then
      L6_2 = {}
      L7_2 = L3_2
      L6_2[1] = L7_2
      L5_2 = L6_2
    else
      L6_2 = L102_1
      L7_2 = A0_2
      L8_2 = "Tipo inv\195\161lido. Usa um destes: %s."
      L9_2 = L8_2
      L8_2 = L8_2.format
      L10_2 = "mensagem, email, banco, sistema, acoes, todas"
      L8_2 = L8_2(L9_2, L10_2)
      L9_2 = "error"
      L6_2(L7_2, L8_2, L9_2)
      return
    end
  end
  L6_2 = ipairs
  L7_2 = L5_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = SetTimeout
    L13_2 = L10_2 - 1
    L13_2 = L13_2 * 2500
    function L14_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
      L0_3 = GetPlayerName
      L1_3 = L2_2
      L0_3 = L0_3(L1_3)
      if not L0_3 then
        return
      end
      L1_3 = L11_2
      L0_3 = L103_1
      L0_3 = L0_3[L1_3]
      L1_3 = L4_2
      L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
      L4_3 = L11_2
      L4_3 = "acoes" == L4_3
      L3_3.persist = L4_3
      L4_3 = NotifyPlayer
      L5_3 = L2_2
      L6_3 = L0_3
      L7_3 = L1_3
      L8_3 = L2_3
      L9_3 = {}
      L9_3.test = true
      L10_3 = L3_3
      L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    end
    L12_2(L13_2, L14_2)
  end
  L6_2 = L102_1
  L7_2 = A0_2
  L8_2 = "Notifica\195\167\195\163o de teste (%s) enviada para %s (%s)."
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = L3_2
  L11_2 = GetPlayerName
  L12_2 = L2_2
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = L2_2
  end
  L12_2 = L4_2
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  L9_2 = "success"
  L6_2(L7_2, L8_2, L9_2)
end
L109_1 = "admin"
L104_1(L105_1, L106_1, L107_1, L108_1, L109_1)
function L104_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = tostring
  L1_2 = Config
  L1_2 = L1_2.NumberFormat
  if not L1_2 then
    L1_2 = "###-####"
  end
  L0_2 = L0_2(L1_2)
  L1_2 = "^"
  L3_2 = L0_2
  L2_2 = L0_2.gsub
  L4_2 = "[%^%$%(%)%%%.%[%]%*%+%-%?]"
  L5_2 = "%%%0"
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "#"
  L5_2 = "%%d"
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = "$"
  L1_2 = L1_2 .. L2_2 .. L3_2
  return L1_2
end
L105_1 = _ENV
L106_1 = "ChangePhoneNumber"
function L107_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  if nil ~= A0_2 and "" ~= A0_2 then
    L3_2 = tostring
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_11
      A0_2 = L3_2 or A0_2
    end
  end
  A0_2 = nil
  ::lbl_11::
  if not A0_2 then
    L3_2 = false
    L4_2 = "noaccount"
    return L3_2, L4_2
  end
  L3_2 = tostring
  L4_2 = A1_2 or L4_2
  if not A1_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 20
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A1_2 = L3_2
  L4_2 = A1_2
  L3_2 = A1_2.match
  L5_2 = L104_1
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L5_2()
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  if not L3_2 then
    L3_2 = false
    L4_2 = "format"
    return L3_2, L4_2
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayerByCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = tonumber
    L5_2 = L3_2.src
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_47
    end
  end
  L4_2 = nil
  ::lbl_47::
  L5_2 = L76_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = false
    L7_2 = "noaccount"
    return L6_2, L7_2
  end
  if L4_2 then
    L6_2 = GetPlayerNumber
    L7_2 = L4_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      goto lbl_63
    end
  end
  L6_2 = L5_2.phone
  ::lbl_63::
  if A1_2 == L6_2 then
    L7_2 = false
    L8_2 = "same"
    L9_2 = L6_2
    return L7_2, L8_2, L9_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.scalar
  L7_2 = L7_2.await
  L8_2 = "SELECT COUNT(*) FROM apex_phone_accounts WHERE phone = ? AND citizenid <> ?"
  L9_2 = {}
  L10_2 = A1_2
  L11_2 = A0_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = FW
  L8_2 = L8_2.FindCidByPhone
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L9_2 = GetSrcByNumber
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L10_2 = SimLineOwner
  if L10_2 then
    L10_2 = SimLineOwner
    L11_2 = A1_2
    L10_2 = L10_2(L11_2)
    if L10_2 then
      goto lbl_98
    end
  end
  L10_2 = nil
  ::lbl_98::
  L11_2 = tonumber
  L12_2 = L7_2
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = 0
  end
  if L11_2 > 0 or L8_2 and L8_2 ~= A0_2 or L9_2 and L9_2 ~= L4_2 or L10_2 and L10_2 ~= A0_2 then
    L11_2 = false
    L12_2 = "taken"
    L13_2 = L6_2
    return L11_2, L12_2, L13_2
  end
  L11_2 = pcall
  L12_2 = MySQL
  L12_2 = L12_2.update
  L12_2 = L12_2.await
  L13_2 = "UPDATE apex_phone_accounts SET phone = ? WHERE citizenid = ?"
  L14_2 = {}
  L15_2 = A1_2
  L16_2 = A0_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
  if not L11_2 then
    L13_2 = L78_1
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L13_2 = false
      L14_2 = "taken"
      L15_2 = L6_2
      return L13_2, L14_2, L15_2
    end
    L13_2 = print
    L14_2 = "^1[unique_phone]^0 ChangePhoneNumber (%s): %s"
    L15_2 = L14_2
    L14_2 = L14_2.format
    L16_2 = tostring
    L17_2 = A2_2
    L16_2 = L16_2(L17_2)
    L17_2 = tostring
    L18_2 = L12_2
    L17_2, L18_2 = L17_2(L18_2)
    L14_2, L15_2, L16_2, L17_2, L18_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
    L13_2 = false
    L14_2 = "db"
    L15_2 = L6_2
    return L13_2, L14_2, L15_2
  end
  L5_2.phone = A1_2
  L13_2 = SimOnNumberChanged
  if L13_2 then
    L13_2 = pcall
    L14_2 = SimOnNumberChanged
    L15_2 = A0_2
    L16_2 = L6_2
    L17_2 = A1_2
    L18_2 = {}
    L18_2.grant = true
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  end
  if L4_2 then
    L13_2 = L36_1
    L14_2 = L4_2
    L15_2 = A1_2
    L13_2(L14_2, L15_2)
    L13_2 = SyncPhoneNumberState
    L14_2 = L4_2
    L15_2 = A1_2
    L13_2(L14_2, L15_2)
    L13_2 = BuildPlayer
    L14_2 = L4_2
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L14_2 = Push
      L15_2 = L4_2
      L16_2 = "player"
      L17_2 = L13_2
      L14_2(L15_2, L16_2, L17_2)
    end
  else
    L13_2 = InvalidateOnlineIndex
    if L13_2 then
      L13_2 = InvalidateOnlineIndex
      L13_2()
    end
  end
  L13_2 = TriggerEvent
  L14_2 = "apex_phone:numberChanged"
  L15_2 = A0_2
  L16_2 = L6_2
  L17_2 = A1_2
  L18_2 = A2_2 or L18_2
  if not A2_2 then
    L18_2 = "unknown"
  end
  L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  L13_2 = true
  L14_2 = nil
  L15_2 = L6_2
  return L13_2, L14_2, L15_2
end
L105_1[L106_1] = L107_1
L105_1 = _ENV
L106_1 = "FW"
L105_1 = L105_1[L106_1]
L106_1 = "AddCommand"
L105_1 = L105_1[L106_1]
L106_1 = "phonenumber"
L107_1 = "Ver ou mudar o n\195\186mero de um jogador (admin)"
L108_1 = {}
L109_1 = {}
L110_1 = "name"
L111_1 = "id"
L109_1[L110_1] = L111_1
L110_1 = "help"
L111_1 = "ID do jogador (vazio = tu)"
L109_1[L110_1] = L111_1
L110_1 = {}
L111_1 = "name"
L112_1 = "novo"
L110_1[L111_1] = L112_1
L111_1 = "help"
L112_1 = "n\195\186mero novo no formato %s (vazio = s\195\179 mostrar)"
L114_1 = "format"
L113_1 = L112_1
L112_1 = L112_1[L114_1]
L114_1 = _ENV
L115_1 = "tostring"
L114_1 = L114_1[L115_1]
L115_1 = _ENV
L116_1 = "Config"
L115_1 = L115_1[L116_1]
L116_1 = "NumberFormat"
L115_1 = L115_1[L116_1]
L114_1, L115_1, L116_1, L117_1, L118_1, L119_1, L120_1, L121_1, L122_1, L123_1, L124_1, L125_1, L126_1, L127_1 = L114_1(L115_1)
L112_1 = L112_1(L113_1, L114_1, L115_1, L116_1, L117_1, L118_1, L119_1, L120_1, L121_1, L122_1, L123_1, L124_1, L125_1, L126_1, L127_1)
L110_1[L111_1] = L112_1
L108_1[1] = L109_1
L108_1[2] = L110_1
function L109_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = tonumber
  L3_2 = A1_2[1]
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = A0_2
  end
  if 0 == L2_2 then
    L3_2 = L102_1
    L4_2 = A0_2
    L5_2 = "uso: phonenumber <id> [novo]"
    L6_2 = "error"
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L3_2 = GetCid
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L102_1
    L5_2 = A0_2
    L6_2 = "Jogador n\195\163o encontrado."
    L7_2 = "error"
    L4_2(L5_2, L6_2, L7_2)
    return
  end
  L4_2 = GetPlayerNumber
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L5_2 = A1_2[2]
  if not L5_2 then
    L5_2 = L102_1
    L6_2 = A0_2
    L7_2 = "N\195\186mero de %s: %s"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = GetPlayerName
    L10_2 = L2_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = L2_2
    end
    L10_2 = tostring
    L11_2 = L4_2 or L11_2
    if not L4_2 then
      L11_2 = "-"
    end
    L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2)
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L8_2 = "primary"
    L5_2(L6_2, L7_2, L8_2)
    return
  end
  L5_2 = tostring
  L6_2 = A1_2[2]
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  L5_2 = L5_2.sub
  L7_2 = 1
  L8_2 = 20
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = ChangePhoneNumber
  L7_2 = L3_2
  L8_2 = L5_2
  L9_2 = "admin"
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    if "format" == L7_2 then
      L8_2 = L102_1
      L9_2 = A0_2
      L10_2 = "Formato inv\195\161lido (usa %s)."
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = tostring
      L13_2 = Config
      L13_2 = L13_2.NumberFormat
      L12_2, L13_2, L14_2 = L12_2(L13_2)
      L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      L11_2 = "error"
      L8_2(L9_2, L10_2, L11_2)
    elseif "same" == L7_2 then
      L8_2 = L102_1
      L9_2 = A0_2
      L10_2 = "O jogador j\195\161 tem esse n\195\186mero."
      L11_2 = "error"
      L8_2(L9_2, L10_2, L11_2)
    elseif "noaccount" == L7_2 then
      L8_2 = L102_1
      L9_2 = A0_2
      L10_2 = "O jogador ainda n\195\163o configurou o telem\195\179vel."
      L11_2 = "error"
      L8_2(L9_2, L10_2, L11_2)
    elseif "taken" == L7_2 then
      L8_2 = L102_1
      L9_2 = A0_2
      L10_2 = "O n\195\186mero %s j\195\161 pertence a outra pessoa."
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = L5_2
      L10_2 = L10_2(L11_2, L12_2)
      L11_2 = "error"
      L8_2(L9_2, L10_2, L11_2)
    else
      L8_2 = L102_1
      L9_2 = A0_2
      L10_2 = "N\195\163o foi poss\195\173vel mudar o n\195\186mero (erro na base de dados)."
      L11_2 = "error"
      L8_2(L9_2, L10_2, L11_2)
    end
    return
  end
  L8_2 = L102_1
  L9_2 = A0_2
  L10_2 = "N\195\186mero de %s: %s \226\134\146 %s"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = GetPlayerName
  L13_2 = L2_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = L2_2
  end
  L13_2 = tostring
  L14_2 = L4_2 or L14_2
  if not L4_2 then
    L14_2 = "-"
  end
  L13_2 = L13_2(L14_2)
  L14_2 = L5_2
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L11_2 = "success"
  L8_2(L9_2, L10_2, L11_2)
  if L2_2 ~= A0_2 then
    L8_2 = FW
    L8_2 = L8_2.Notify
    L9_2 = L2_2
    L10_2 = "O teu n\195\186mero passou a ser %s."
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L5_2
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = "primary"
    L8_2(L9_2, L10_2, L11_2)
  end
end
L110_1 = "admin"
L105_1(L106_1, L107_1, L108_1, L109_1, L110_1)
L105_1 = _ENV
L106_1 = "RPC"
L105_1 = L105_1[L106_1]
L106_1 = "apps.installed"
function L107_1()
  local L0_2, L1_2
  L0_2 = nil
  return L0_2
end
L105_1[L106_1] = L107_1
L105_1 = _ENV
L106_1 = "RPC"
L105_1 = L105_1[L106_1]
L106_1 = "apps.install"
function L107_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.ok = true
  return L0_2
end
L105_1[L106_1] = L107_1
L105_1 = _ENV
L106_1 = "RPC"
L105_1 = L105_1[L106_1]
L106_1 = "apps.uninstall"
function L107_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.ok = true
  return L0_2
end
L105_1[L106_1] = L107_1
L105_1 = _ENV
L106_1 = "RPC"
L105_1 = L105_1[L106_1]
L106_1 = "apps.registry"
function L107_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = {}
  L1_2 = pairs
  L2_2 = ServerApps
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = #L0_2
    L7_2 = L7_2 + 1
    L0_2[L7_2] = L6_2
  end
  return L0_2
end
L105_1[L106_1] = L107_1
L105_1 = _ENV
L106_1 = "RPC"
L105_1 = L105_1[L106_1]
function L106_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L66_1
  L3_2 = L3_2()
  L4_2 = L67_1
  L5_2 = A1_2.app
  L4_2 = L4_2(L5_2)
  L5_2 = A1_2.perm
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "string" == L6_2 then
      L6_2 = L3_2.known
      L6_2 = L6_2[L5_2]
      if L6_2 then
        goto lbl_33
      end
    end
  end
  L6_2 = {}
  L6_2.ok = false
  L6_2.error = "invalid"
  do return L6_2 end
  ::lbl_33::
  L6_2 = L71_1
  L7_2 = L4_2
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = A1_2.once
  if true == L7_2 then
    L7_2 = L68_1
    L7_2 = L7_2[A0_2]
    if L7_2 then
      L8_2 = L7_2.cid
      if L8_2 == L2_2 then
        goto lbl_54
      end
    end
    L8_2 = {}
    L8_2.cid = L2_2
    L8_2.n = 0
    L7_2 = L8_2
    L8_2 = L68_1
    L8_2[A0_2] = L7_2
    ::lbl_54::
    L8_2 = L7_2[L6_2]
    if not L8_2 then
      L8_2 = L7_2.n
      L9_2 = L3_2.maxGrants
      if L8_2 >= L9_2 then
        L8_2 = {}
        L8_2.ok = false
        L8_2.error = "limit"
        return L8_2
      end
      L7_2[L6_2] = true
      L8_2 = L7_2.n
      L8_2 = L8_2 + 1
      L7_2.n = L8_2
    end
    L8_2 = {}
    L8_2.ok = true
    L8_2.once = true
    return L8_2
  end
  L7_2 = L72_1
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  L8_2 = L7_2[L6_2]
  if not L8_2 then
    L8_2 = MySQL
    L8_2 = L8_2.scalar
    L8_2 = L8_2.await
    L9_2 = "SELECT COUNT(*) FROM apex_phone_app_grants WHERE owner = ?"
    L10_2 = {}
    L11_2 = L2_2
    L10_2[1] = L11_2
    L8_2 = L8_2(L9_2, L10_2)
    L9_2 = tonumber
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = 0
    end
    L10_2 = L3_2.maxGrants
    if L9_2 >= L10_2 then
      L9_2 = {}
      L9_2.ok = false
      L9_2.error = "limit"
      return L9_2
    end
    L9_2 = MySQL
    L9_2 = L9_2.insert
    L9_2 = L9_2.await
    L10_2 = "INSERT IGNORE INTO apex_phone_app_grants (owner, app, perm, created) VALUES (?, ?, ?, ?)"
    L11_2 = {}
    L12_2 = L2_2
    L13_2 = L4_2
    L14_2 = L5_2
    L15_2 = L4_1
    L15_2 = L15_2()
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L11_2[3] = L14_2
    L11_2[4] = L15_2
    L9_2(L10_2, L11_2)
    L7_2[L6_2] = true
    L9_2 = Dbg
    L10_2 = "apps"
    L11_2 = "%s granted \"%s\" to %s"
    L12_2 = L2_2
    L13_2 = L5_2
    L14_2 = L4_2
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
  end
  L8_2 = {}
  L8_2.ok = true
  return L8_2
end
L105_1["apps.grant"] = L106_1
L105_1 = _ENV
L106_1 = "RPC"
L105_1 = L105_1[L106_1]
function L106_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L67_1
  L4_2 = A1_2.app
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2.perm
  if L3_2 then
    if nil == L4_2 then
      goto lbl_35
    end
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "string" == L5_2 then
      L5_2 = L66_1
      L5_2 = L5_2()
      L5_2 = L5_2.known
      L5_2 = L5_2[L4_2]
      if L5_2 then
        goto lbl_35
      end
    end
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "invalid"
  do return L5_2 end
  ::lbl_35::
  L5_2 = L3_2
  L6_2 = "\n"
  L5_2 = L5_2 .. L6_2
  function L6_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = L4_2
    if L1_3 then
      L1_3 = L71_1
      L2_3 = L3_2
      L3_3 = L4_2
      L1_3 = L1_3(L2_3, L3_3)
    end
    L1_3 = A0_3 == L1_3
    return L1_3
  end
  L7_2 = L68_1
  L7_2 = L7_2[A0_2]
  if L7_2 then
    L8_2 = L7_2.cid
    if L8_2 == L2_2 then
      L8_2 = pairs
      L9_2 = L7_2
      L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
      for L12_2 in L8_2, L9_2, L10_2, L11_2 do
        if "cid" ~= L12_2 and "n" ~= L12_2 then
          L13_2 = L6_2
          L14_2 = L12_2
          L13_2 = L13_2(L14_2)
          if L13_2 then
            L7_2[L12_2] = nil
            L13_2 = math
            L13_2 = L13_2.max
            L14_2 = 0
            L15_2 = L7_2.n
            L15_2 = L15_2 - 1
            L13_2 = L13_2(L14_2, L15_2)
            L7_2.n = L13_2
          end
        end
      end
    end
  end
  L8_2 = A1_2.once
  if true ~= L8_2 then
    if L4_2 then
      L8_2 = MySQL
      L8_2 = L8_2.query
      L8_2 = L8_2.await
      L9_2 = "DELETE FROM apex_phone_app_grants WHERE owner = ? AND app = ? AND perm = ?"
      L10_2 = {}
      L11_2 = L2_2
      L12_2 = L3_2
      L13_2 = L4_2
      L10_2[1] = L11_2
      L10_2[2] = L12_2
      L10_2[3] = L13_2
      L8_2(L9_2, L10_2)
    else
      L8_2 = MySQL
      L8_2 = L8_2.query
      L8_2 = L8_2.await
      L9_2 = "DELETE FROM apex_phone_app_grants WHERE owner = ? AND app = ?"
      L10_2 = {}
      L11_2 = L2_2
      L12_2 = L3_2
      L10_2[1] = L11_2
      L10_2[2] = L12_2
      L8_2(L9_2, L10_2)
    end
    L8_2 = L69_1
    L8_2 = L8_2[L2_2]
    if L8_2 then
      L9_2 = pairs
      L10_2 = L8_2
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
      for L13_2 in L9_2, L10_2, L11_2, L12_2 do
        L14_2 = L6_2
        L15_2 = L13_2
        L14_2 = L14_2(L15_2)
        if L14_2 then
          L8_2[L13_2] = nil
        end
      end
    end
    L9_2 = Dbg
    L10_2 = "apps"
    L11_2 = "%s revoked %s from %s"
    L12_2 = L2_2
    L13_2 = L4_2 or L13_2
    if not L4_2 then
      L13_2 = "everything"
    end
    L14_2 = L3_2
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
  end
  L8_2 = {}
  L8_2.ok = true
  return L8_2
end
L105_1["apps.revoke"] = L106_1
L105_1 = _ENV
L106_1 = "RPC"
L105_1 = L105_1[L106_1]
function L106_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L3_2 = {}
    L2_2.items = L3_2
    L3_2 = {}
    L2_2.once = L3_2
    return L2_2
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT app, perm, created FROM apex_phone_app_grants WHERE owner = ? ORDER BY app, perm LIMIT 500"
  L6_2 = {}
  L7_2 = L1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L10_2 = L8_2.app
    L9_2.app = L10_2
    L10_2 = L8_2.perm
    L9_2.perm = L10_2
    L10_2 = tonumber
    L11_2 = L8_2.created
    L10_2 = L10_2(L11_2)
    L9_2.created = L10_2
    L2_2[L7_2] = L9_2
  end
  L3_2 = {}
  L4_2 = L68_1
  L4_2 = L4_2[A0_2]
  if L4_2 then
    L5_2 = L4_2.cid
    if L5_2 == L1_2 then
      L5_2 = pairs
      L6_2 = L4_2
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
      for L9_2 in L5_2, L6_2, L7_2, L8_2 do
        L11_2 = L9_2
        L10_2 = L9_2.match
        L12_2 = [[
^(.-)
(.+)$]]
        L10_2, L11_2 = L10_2(L11_2, L12_2)
        if L10_2 then
          L12_2 = #L3_2
          L12_2 = L12_2 + 1
          L13_2 = {}
          L13_2.app = L10_2
          L13_2.perm = L11_2
          L3_2[L12_2] = L13_2
        end
      end
    end
  end
  L5_2 = {}
  L5_2.items = L2_2
  L5_2.once = L3_2
  return L5_2
end
L105_1["apps.grants"] = L106_1
L105_1 = "apex_phone:airpods:"
function L106_1(A0_2)
  local L1_2, L2_2
  if "slate" == A0_2 then
    L1_2 = type
    L2_2 = Config
    L2_2 = L2_2.SlateBuds
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = Config
      L1_2 = L1_2.SlateBuds
      L1_2 = L1_2.name
      if L1_2 then
        goto lbl_15
      end
    end
    L1_2 = "Slate Buds"
    ::lbl_15::
    return L1_2
  end
  L1_2 = Config
  L1_2 = L1_2.AirPods
  if L1_2 then
    L1_2 = Config
    L1_2 = L1_2.AirPods
    L1_2 = L1_2.name
    if L1_2 then
      goto lbl_26
    end
  end
  L1_2 = "AirBuds"
  ::lbl_26::
  return L1_2
end
function L107_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = Config
  L2_2 = L2_2.SlateBuds
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = Config
    L1_2 = L1_2.SlateBuds
    if L1_2 then
      goto lbl_12
    end
  end
  L1_2 = nil
  ::lbl_12::
  if A0_2 and L1_2 then
    L2_2 = L1_2.item
    if L2_2 then
      L2_2 = L1_2.item
      if "" ~= L2_2 then
        L2_2 = L1_2.item
        if A0_2 == L2_2 then
          L2_2 = "slate"
          return L2_2
        end
      end
    end
  end
  L2_2 = "airbuds"
  return L2_2
end
function L108_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L2_2 = {}
    L2_2.connected = false
    L2_2.worn = false
    L2_2.kind = "airbuds"
    L3_2 = {}
    L3_2.l = 84
    L3_2.r = 79
    L3_2.c = 62
    L2_2.battery = L3_2
    L1_2 = L2_2
    L2_2 = L0_1
    L2_2[A0_2] = L1_2
  end
  L2_2 = L1_2.kind
  if "slate" == L2_2 then
    L2_2 = "slate"
    if L2_2 then
      goto lbl_26
    end
  end
  L2_2 = "airbuds"
  ::lbl_26::
  L1_2.kind = L2_2
  L2_2 = L106_1
  L3_2 = L1_2.kind
  L2_2 = L2_2(L3_2)
  L1_2.name = L2_2
  return L1_2
end
function L109_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L1_3 = L0_3
    L0_3 = L0_3.set
    L2_3 = "apex_airpods"
    L3_3 = A1_2.worn
    if L3_3 then
      L3_3 = A1_2.connected
      if L3_3 then
        L3_3 = true
        if L3_3 then
          goto lbl_17
        end
      end
    end
    L3_3 = false
    ::lbl_17::
    L4_3 = true
    L0_3(L1_3, L2_3, L3_3, L4_3)
  end
  L2_2(L3_2)
end
function L110_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L108_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if A1_2 then
    L4_2 = true
    if L4_2 then
      goto lbl_10
    end
  end
  L4_2 = false
  ::lbl_10::
  L3_2.worn = L4_2
  if A2_2 then
    if "slate" == A2_2 then
      L4_2 = "slate"
      if L4_2 then
        goto lbl_19
      end
    end
    L4_2 = "airbuds"
    ::lbl_19::
    L3_2.kind = L4_2
    L4_2 = L106_1
    L5_2 = L3_2.kind
    L4_2 = L4_2(L5_2)
    L3_2.name = L4_2
  end
  L4_2 = L3_2.worn
  if not L4_2 then
    L3_2.connected = false
  end
  L4_2 = GlobalState
  L5_2 = L105_1
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  L6_2 = L3_2.worn
  if L6_2 then
    L6_2 = L3_2.kind
    if "slate" == L6_2 then
      L6_2 = "slate"
      if L6_2 then
        goto lbl_45
      end
    end
    L6_2 = true
    if L6_2 then
      goto lbl_45
    end
  end
  L6_2 = nil
  ::lbl_45::
  L4_2[L5_2] = L6_2
  L4_2 = L109_1
  L5_2 = A0_2
  L6_2 = L3_2
  L4_2(L5_2, L6_2)
  return L3_2
end
L111_1 = _ENV
L112_1 = "RPC"
L111_1 = L111_1[L112_1]
L112_1 = "earbuds.state"
function L113_1(A0_2)
  local L1_2, L2_2
  L1_2 = L108_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
L111_1[L112_1] = L113_1
L111_1 = _ENV
L112_1 = "RPC"
L111_1 = L111_1[L112_1]
L112_1 = "earbuds.toggle"
function L113_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L108_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2.worn
  if not L2_2 then
    L1_2.connected = false
    L2_2 = L109_1
    L3_2 = A0_2
    L4_2 = L1_2
    L2_2(L3_2, L4_2)
    L2_2 = {}
    L2_2.error = "notworn"
    L2_2.connected = false
    L2_2.worn = false
    L3_2 = L1_2.battery
    L2_2.battery = L3_2
    L3_2 = L1_2.name
    L2_2.name = L3_2
    return L2_2
  end
  L2_2 = L1_2.connected
  L2_2 = not L2_2
  L1_2.connected = L2_2
  L2_2 = L109_1
  L3_2 = A0_2
  L4_2 = L1_2
  L2_2(L3_2, L4_2)
  return L1_2
end
L111_1[L112_1] = L113_1
L111_1 = _ENV
L112_1 = "RPC"
L111_1 = L111_1[L112_1]
L112_1 = "airpods.wear"
function L113_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L108_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = type
    L4_2 = A1_2.item
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L3_2 = A1_2.item
      if L3_2 then
        goto lbl_18
      end
    end
  end
  L3_2 = nil
  ::lbl_18::
  L4_2 = L107_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = L2_2.worn
  L5_2 = not L5_2
  if "slate" == L4_2 then
    L6_2 = type
    L7_2 = Config
    L7_2 = L7_2.SlateBuds
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = Config
      L6_2 = L6_2.SlateBuds
      L6_2 = L6_2.item
      if L6_2 then
        goto lbl_44
      end
    end
  end
  L6_2 = Config
  L6_2 = L6_2.EarbudsItem
  ::lbl_44::
  if L5_2 then
    L7_2 = FW
    L7_2 = L7_2.InventoryName
    if L7_2 then
      L7_2 = FW
      L7_2 = L7_2.InventoryName
      L7_2 = L7_2()
      if L7_2 then
        L7_2 = type
        L8_2 = L6_2
        L7_2 = L7_2(L8_2)
        if "string" == L7_2 and "" ~= L6_2 then
          L7_2 = tonumber
          L8_2 = FW
          L8_2 = L8_2.HasItem
          L9_2 = A0_2
          L10_2 = L6_2
          L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2)
          L7_2 = L7_2(L8_2, L9_2, L10_2)
          if not L7_2 then
            L7_2 = 0
          end
          if L7_2 < 1 then
            L7_2 = {}
            L7_2.error = "noitem"
            L8_2 = L2_2.worn
            L7_2.worn = L8_2
            L8_2 = L2_2.connected
            L7_2.connected = L8_2
            L8_2 = L2_2.kind
            L7_2.kind = L8_2
            L8_2 = L2_2.name
            L7_2.name = L8_2
            L8_2 = L2_2.battery
            L7_2.battery = L8_2
            return L7_2
          end
        end
      end
    end
  end
  L7_2 = L2_2.worn
  if L7_2 then
    L7_2 = L2_2.kind
    if L7_2 ~= L4_2 then
      L2_2.connected = false
      L7_2 = L110_1
      L8_2 = A0_2
      L9_2 = true
      L10_2 = L4_2
      return L7_2(L8_2, L9_2, L10_2)
    end
  end
  L7_2 = L110_1
  L8_2 = A0_2
  L9_2 = L2_2.worn
  L9_2 = not L9_2
  L10_2 = L4_2
  return L7_2(L8_2, L9_2, L10_2)
end
L111_1[L112_1] = L113_1
function L111_1(A0_2)
  local L1_2, L2_2
  L1_2 = L105_1
  L2_2 = A0_2
  L1_2 = L1_2 .. L2_2
  L2_2 = GlobalState
  L2_2 = L2_2[L1_2]
  if nil ~= L2_2 then
    L2_2 = GlobalState
    L2_2[L1_2] = nil
  end
end
function L112_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = ipairs
  L1_2 = GetPlayers
  L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L1_2()
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = tonumber
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L7_2 = L111_1
      L8_2 = L6_2
      L7_2(L8_2)
      L7_2 = pcall
      function L8_2()
        local L0_3, L1_3, L2_3, L3_3, L4_3
        L0_3 = Player
        L1_3 = L6_2
        L0_3 = L0_3(L1_3)
        L0_3 = L0_3.state
        L1_3 = L0_3
        L0_3 = L0_3.set
        L2_3 = "apex_airpods"
        L3_3 = false
        L4_3 = true
        L0_3(L1_3, L2_3, L3_3, L4_3)
      end
      L7_2(L8_2)
    end
  end
end
L113_1 = L112_1
L113_1()
L113_1 = AddEventHandler
L114_1 = "onResourceStop"
function L115_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = L112_1
    L1_2()
  end
end
L113_1(L114_1, L115_1)
L113_1 = AddEventHandler
L114_1 = "playerJoining"
function L115_1()
  local L0_2, L1_2, L2_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L111_1
    L2_2 = L0_2
    L1_2(L2_2)
  end
end
L113_1(L114_1, L115_1)
L113_1 = {}
L114_1 = "out"
L115_1 = 0
L113_1[L114_1] = L115_1
L114_1 = "garage"
L113_1[L114_1] = 1
L114_1 = "impound"
L113_1[L114_1] = 2
L114_1 = _ENV
L115_1 = "RPC"
L114_1 = L114_1[L115_1]
L115_1 = "garage.vehicles"
function L116_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = FW
  L4_2 = L4_2.GetVehicles
  L5_2 = L1_2
  L6_2 = true
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.garage
    if L9_2 then
      L9_2 = Config
      L9_2 = L9_2.Garages
      L10_2 = L8_2.garage
      L9_2 = L9_2[L10_2]
    end
    L10_2 = L8_2.model
    if not L10_2 then
      L10_2 = L8_2.hash
      if L10_2 then
        L10_2 = tostring
        L11_2 = L8_2.hash
        L10_2 = L10_2(L11_2)
        if L10_2 then
          goto lbl_38
        end
      end
      L10_2 = "veiculo"
    end
    ::lbl_38::
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L12_2 = {}
    L13_2 = L8_2.plate
    L12_2.plate = L13_2
    L12_2.model = L10_2
    L13_2 = L8_2.hash
    L12_2.hash = L13_2
    L13_2 = L8_2.label
    if not L13_2 then
      L13_2 = L8_2.model
      if L13_2 then
        L13_2 = L8_2.model
        if L13_2 then
          goto lbl_58
        end
      end
      L13_2 = nil
    end
    ::lbl_58::
    L12_2.label = L13_2
    L13_2 = L8_2.garage
    L12_2.garage = L13_2
    L14_2 = L8_2.state
    L13_2 = L113_1
    L13_2 = L13_2[L14_2]
    if not L13_2 then
      L13_2 = 0
    end
    L12_2.state = L13_2
    L13_2 = L8_2.fuel
    L12_2.fuel = L13_2
    L13_2 = L8_2.engine
    L12_2.engine = L13_2
    L13_2 = L8_2.body
    L12_2.body = L13_2
    if L9_2 then
      L13_2 = {}
      L14_2 = L9_2.x
      L13_2.x = L14_2
      L14_2 = L9_2.y
      L13_2.y = L14_2
      if L13_2 then
        goto lbl_85
      end
    end
    L13_2 = nil
    ::lbl_85::
    L12_2.coords = L13_2
    L2_2[L11_2] = L12_2
  end
  return L2_2
end
L114_1[L115_1] = L116_1
L114_1 = _ENV
L115_1 = "RegisterNetEvent"
L114_1 = L114_1[L115_1]
L115_1 = "apex_phone:server:homeToggle"
function L116_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = source
  L2_2 = RateLimitAllow
  L3_2 = L1_2
  L4_2 = "event.homeToggle"
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = TriggerEvent
    L3_2 = "apex_phone:homeToggle"
    L4_2 = L1_2
    L5_2 = A0_2
    L2_2(L3_2, L4_2, L5_2)
  end
end
L114_1(L115_1, L116_1)
L114_1 = _ENV
L115_1 = "RegisterNetEvent"
L114_1 = L114_1[L115_1]
L115_1 = "apex_phone:server:homeAccess"
function L116_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = source
  L2_2 = RateLimitAllow
  L3_2 = L1_2
  L4_2 = "event.homeAccess"
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = TriggerEvent
    L3_2 = "apex_phone:homeAccess"
    L4_2 = L1_2
    L5_2 = A0_2
    L2_2(L3_2, L4_2, L5_2)
  end
end
L114_1(L115_1, L116_1)
L114_1 = _ENV
L115_1 = "CreateThread"
L114_1 = L114_1[L115_1]
function L115_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = Wait
  L1_2 = 1000
  L0_2(L1_2)
  L0_2 = Config
  L0_2 = L0_2.EarbudsItem
  if L0_2 then
    L0_2 = Config
    L0_2 = L0_2.EarbudsItem
    if "" ~= L0_2 then
      L0_2 = FW
      L0_2 = L0_2.CreateUseableItem
      L1_2 = Config
      L1_2 = L1_2.EarbudsItem
      function L2_2(A0_3)
        local L1_3, L2_3, L3_3, L4_3
        L1_3 = TriggerClientEvent
        L2_3 = "apex_phone:client:earbuds"
        L3_3 = A0_3
        L4_3 = Config
        L4_3 = L4_3.EarbudsItem
        L1_3(L2_3, L3_3, L4_3)
      end
      L0_2(L1_2, L2_2)
    end
  end
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.SlateBuds
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.SlateBuds
    if L0_2 then
      goto lbl_29
    end
  end
  L0_2 = nil
  ::lbl_29::
  if L0_2 then
    L1_2 = L0_2.item
    if L1_2 then
      L1_2 = L0_2.item
      if "" ~= L1_2 then
        L1_2 = FW
        L1_2 = L1_2.CreateUseableItem
        L2_2 = L0_2.item
        function L3_2(A0_3)
          local L1_3, L2_3, L3_3, L4_3
          L1_3 = TriggerClientEvent
          L2_3 = "apex_phone:client:earbuds"
          L3_3 = A0_3
          L4_3 = L0_2.item
          L1_3(L2_3, L3_3, L4_3)
        end
        L1_2(L2_2, L3_2)
      end
    end
  end
  L1_2 = pairs
  L2_2 = Config
  L2_2 = L2_2.Devices
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = FW
    L6_2 = L6_2.CreateUseableItem
    L7_2 = L5_2
    function L8_2(A0_3)
      local L1_3, L2_3, L3_3, L4_3
      L1_3 = TriggerClientEvent
      L2_3 = "apex_phone:client:useDevice"
      L3_3 = A0_3
      L4_3 = L5_2
      L1_3(L2_3, L3_3, L4_3)
    end
    L6_2(L7_2, L8_2)
  end
end
L114_1(L115_1)
L114_1 = 0
L115_1 = _ENV
L116_1 = "RegisterNetEvent"
L115_1 = L115_1[L116_1]
L116_1 = "apex_phone:server:camfix"
function L117_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = source
  L1_2 = IsPlayerAceAllowed
  L2_2 = L0_2
  L3_2 = "command"
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = IsPlayerAceAllowed
    L2_2 = L0_2
    L3_2 = "Unique_Phone.camfix"
    L1_2 = L1_2(L2_2, L3_2)
  end
  if not L1_2 then
    L2_2 = TriggerClientEvent
    L3_2 = "apex_phone:client:camfixed"
    L4_2 = L0_2
    L5_2 = false
    L2_2(L3_2, L4_2, L5_2)
    return
  end
  L2_2 = os
  L2_2 = L2_2.time
  L2_2 = L2_2()
  L3_2 = L114_1
  L3_2 = L2_2 - L3_2
  if L3_2 < 60 then
    L3_2 = TriggerClientEvent
    L4_2 = "apex_phone:client:camfixed"
    L5_2 = L0_2
    L6_2 = true
    L3_2(L4_2, L5_2, L6_2)
    return
  end
  L114_1 = L2_2
  L3_2 = print
  L4_2 = "^3[unique_phone]^0 %s requested /camfix \226\128\148 restarting screenshot-basic"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = GetPlayerName
  L7_2 = L0_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = L0_2
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
  L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = ExecuteCommand
  L4_2 = "restart screenshot-basic"
  L3_2(L4_2)
  L3_2 = SetTimeout
  L4_2 = 1500
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = TriggerClientEvent
    L1_3 = "apex_phone:client:camfixed"
    L2_3 = L0_2
    L3_3 = true
    L0_3(L1_3, L2_3, L3_3)
  end
  L3_2(L4_2, L5_2)
end
L115_1(L116_1, L117_1)
L115_1 = _ENV
L116_1 = "Config"
L115_1 = L115_1[L116_1]
L116_1 = "DeviceGrantCommand"
L115_1 = L115_1[L116_1]
if L115_1 then
  L115_1 = _ENV
  L116_1 = "Config"
  L115_1 = L115_1[L116_1]
  L116_1 = "DeviceGrantCommand"
  L115_1 = L115_1[L116_1]
  L116_1 = ""
  if L115_1 ~= L116_1 then
    L115_1 = _ENV
    L116_1 = "FW"
    L115_1 = L115_1[L116_1]
    L116_1 = "AddCommand"
    L115_1 = L115_1[L116_1]
    L116_1 = _ENV
    L117_1 = "Config"
    L116_1 = L116_1[L117_1]
    L117_1 = "DeviceGrantCommand"
    L116_1 = L116_1[L117_1]
    L117_1 = "Receber todos os telem\195\179veis Apex (PearPhone e NOVA S26) e os auriculares (admin)"
    L118_1 = {}
    L119_1 = {}
    L120_1 = "name"
    L121_1 = "id"
    L119_1[L120_1] = L121_1
    L120_1 = "help"
    L121_1 = "ID do jogador (vazio = tu)"
    L119_1[L120_1] = L121_1
    L118_1[1] = L119_1
    function L119_1(A0_2, A1_2)
      local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
      L2_2 = tonumber
      L3_2 = A1_2 or L3_2
      if A1_2 then
        L3_2 = A1_2[1]
      end
      L2_2 = L2_2(L3_2)
      if not L2_2 then
        L2_2 = A0_2
      end
      if 0 == L2_2 then
        L3_2 = print
        L4_2 = "[unique_phone] usage: "
        L5_2 = Config
        L5_2 = L5_2.DeviceGrantCommand
        L6_2 = " <id>"
        L4_2 = L4_2 .. L5_2 .. L6_2
        L3_2(L4_2)
        return
      end
      L3_2 = FW
      L3_2 = L3_2.InventoryName
      L3_2 = L3_2()
      if not L3_2 then
        if A0_2 > 0 then
          L4_2 = FW
          L4_2 = L4_2.Notify
          L5_2 = A0_2
          L6_2 = "Este comando precisa de um invent\195\161rio (ox_inventory, qb ou esx)."
          L7_2 = "error"
          L4_2(L5_2, L6_2, L7_2)
        else
          L4_2 = print
          L5_2 = "[unique_phone] needs an inventory (ox_inventory, qb or esx)"
          L4_2(L5_2)
        end
        return
      end
      L4_2 = 0
      L5_2 = nil
      L6_2 = ipairs
      L7_2 = Config
      L7_2 = L7_2.DeviceOrder
      if not L7_2 then
        L7_2 = {}
      end
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = Config
        L12_2 = L12_2.Devices
        if L12_2 then
          L12_2 = Config
          L12_2 = L12_2.Devices
          L12_2 = L12_2[L11_2]
        end
        if L12_2 then
          L13_2 = L12_2.legacy
          if L13_2 then
            goto lbl_74
          end
        end
        L13_2 = FW
        L13_2 = L13_2.AddItem
        L14_2 = L2_2
        L15_2 = L11_2
        L16_2 = 1
        L13_2 = L13_2(L14_2, L15_2, L16_2)
        if L13_2 then
          L4_2 = L4_2 + 1
        elseif not L5_2 then
          L5_2 = L11_2
        end
        ::lbl_74::
      end
      L6_2 = 0
      L7_2 = ipairs
      L8_2 = {}
      L9_2 = Config
      L9_2 = L9_2.EarbudsItem
      L10_2 = type
      L11_2 = Config
      L11_2 = L11_2.SlateBuds
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = Config
        L10_2 = L10_2.SlateBuds
        L10_2 = L10_2.item
        if L10_2 then
          goto lbl_95
        end
      end
      L10_2 = nil
      ::lbl_95::
      L8_2[1] = L9_2
      L8_2[2] = L10_2
      L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
      for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
        L13_2 = type
        L14_2 = L12_2
        L13_2 = L13_2(L14_2)
        if "string" == L13_2 and "" ~= L12_2 then
          L13_2 = FW
          L13_2 = L13_2.AddItem
          L14_2 = L2_2
          L15_2 = L12_2
          L16_2 = 1
          L13_2 = L13_2(L14_2, L15_2, L16_2)
          if L13_2 then
            L6_2 = L6_2 + 1
          elseif not L5_2 then
            L5_2 = L12_2
          end
        end
      end
      if L4_2 > 0 then
        if L6_2 > 0 then
          L7_2 = "Recebeste %d telem\195\179vel(is) Apex e %d par(es) de auriculares."
          L8_2 = L7_2
          L7_2 = L7_2.format
          L9_2 = L4_2
          L10_2 = L6_2
          L7_2 = L7_2(L8_2, L9_2, L10_2)
          if L7_2 then
            goto lbl_146
          end
        end
        L7_2 = "Recebeste %d telem\195\179vel(is) Apex."
        L8_2 = L7_2
        L7_2 = L7_2.format
        L9_2 = L4_2
        L7_2 = L7_2(L8_2, L9_2)
        if L7_2 then
          goto lbl_146
        end
      end
      L7_2 = "Falta registar os itens no invent\195\161rio %s (%s)."
      L8_2 = L7_2
      L7_2 = L7_2.format
      L9_2 = L3_2
      L10_2 = tostring
      L11_2 = L5_2
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L10_2(L11_2)
      L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      ::lbl_146::
      if L2_2 > 0 then
        L8_2 = FW
        L8_2 = L8_2.Notify
        L9_2 = L2_2
        L10_2 = L7_2
        if L4_2 > 0 then
          L11_2 = "success"
          if L11_2 then
            goto lbl_158
          end
        end
        L11_2 = "error"
        ::lbl_158::
        L8_2(L9_2, L10_2, L11_2)
      end
      if A0_2 > 0 and A0_2 ~= L2_2 then
        L8_2 = FW
        L8_2 = L8_2.Notify
        L9_2 = A0_2
        L10_2 = L7_2
        if L4_2 > 0 then
          L11_2 = "success"
          if L11_2 then
            goto lbl_173
          end
        end
        L11_2 = "error"
        ::lbl_173::
        L8_2(L9_2, L10_2, L11_2)
      end
      if 0 == A0_2 then
        L8_2 = print
        L9_2 = "[unique_phone] "
        L10_2 = ConsoleText
        if L10_2 then
          L10_2 = ConsoleText
          L11_2 = L7_2
          L10_2 = L10_2(L11_2)
          if L10_2 then
            goto lbl_187
          end
        end
        L10_2 = L7_2
        ::lbl_187::
        L9_2 = L9_2 .. L10_2
        L8_2(L9_2)
      end
    end
    L120_1 = "admin"
    L115_1(L116_1, L117_1, L118_1, L119_1, L120_1)
  end
end
L115_1 = {}
L116_1 = {}
L117_1 = {}
L118_1 = {}
L119_1 = _ENV
L120_1 = "GetPhoneState"
function L121_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = -1
  end
  L2_2 = L115_1
  L1_2 = L2_2[L1_2]
  return L1_2
end
L119_1[L120_1] = L121_1
L119_1 = _ENV
L120_1 = "LastDevice"
L121_1 = {}
L119_1[L120_1] = L121_1
L119_1 = _ENV
L120_1 = "DeviceOSOf"
function L121_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2 or A0_2
  if not L1_2 then
    A0_2 = -1
  end
  L1_2 = L115_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = L1_2.device
    if L2_2 then
      goto lbl_16
    end
  end
  L2_2 = LastDevice
  L2_2 = L2_2[A0_2]
  ::lbl_16::
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = Config
    L3_2 = L3_2.Devices
    if L3_2 then
      L3_2 = Config
      L3_2 = L3_2.Devices
      L3_2 = L3_2[L2_2]
    end
  end
  if L3_2 then
    L4_2 = L3_2.os
    if "android" == L4_2 then
      L4_2 = "android"
      if L4_2 then
        goto lbl_34
      end
    end
  end
  L4_2 = "ios"
  ::lbl_34::
  return L4_2
end
L119_1[L120_1] = L121_1
L119_1 = _ENV
L120_1 = "DeviceModelOf"
function L121_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2 or A0_2
  if not L1_2 then
    A0_2 = -1
  end
  L1_2 = L115_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = L1_2.device
    if L2_2 then
      goto lbl_16
    end
  end
  L2_2 = LastDevice
  L2_2 = L2_2[A0_2]
  ::lbl_16::
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = Config
    L3_2 = L3_2.Devices
    if L3_2 then
      L3_2 = Config
      L3_2 = L3_2.Devices
      L3_2 = L3_2[L2_2]
    end
  end
  if L3_2 then
    L4_2 = type
    L5_2 = L3_2.model
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 then
      L4_2 = L3_2.model
      if "" ~= L4_2 then
        L4_2 = L3_2.model
        return L4_2
      end
    end
  end
  L4_2 = DeviceOSOf
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "android" == L4_2 then
    L4_2 = type
    L5_2 = Config
    L5_2 = L5_2.Android
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = Config
      L4_2 = L4_2.Android
      if L4_2 then
        goto lbl_54
      end
    end
    L4_2 = {}
    ::lbl_54::
    L5_2 = type
    L6_2 = L4_2.model
    L5_2 = L5_2(L6_2)
    if "string" == L5_2 then
      L5_2 = L4_2.model
      if "" ~= L5_2 then
        L5_2 = L4_2.model
        if L5_2 then
          goto lbl_66
        end
      end
    end
    L5_2 = "NOVA S26 Ultra"
    ::lbl_66::
    return L5_2
  end
  L4_2 = "PearPhone"
  return L4_2
end
L119_1[L120_1] = L121_1
L119_1 = _ENV
L120_1 = "DefaultModels"
function L121_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Android
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Android
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = {}
  L2_2 = "PearPhone 18 Pro Max"
  L3_2 = "PearPhone 18 Pro"
  L4_2 = "PearPhone 18"
  L5_2 = "PearPhone"
  L6_2 = "NOVA S26 Ultra"
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L2_2[L8_2] = true
  end
  function L3_2(A0_3)
    local L1_3, L2_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "string" == L1_3 and "" ~= A0_3 then
      L1_3 = L2_2
      L1_3 = L1_3[A0_3]
      if not L1_3 then
        L1_3 = L2_2
        L1_3[A0_3] = true
        L1_3 = L1_2
        L1_3 = #L1_3
        L2_3 = L1_3 + 1
        L1_3 = L1_2
        L1_3[L2_3] = A0_3
      end
    end
  end
  L4_2 = L3_2
  L5_2 = L0_2.model
  L4_2(L5_2)
  L4_2 = pairs
  L5_2 = Config
  L5_2 = L5_2.Devices
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L3_2
    L11_2 = L9_2.model
    L10_2(L11_2)
  end
  L4_2 = table
  L4_2 = L4_2.sort
  L5_2 = L1_2
  function L6_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = #A0_3
    L3_3 = #A1_3
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L4_2(L5_2, L6_2)
  return L1_2
end
L119_1[L120_1] = L121_1
L119_1 = _ENV
L120_1 = "RegisterNetEvent"
L119_1 = L119_1[L120_1]
L120_1 = "apex_phone:server:phoneState"
function L121_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = source
  L3_2 = RateLimitAllow
  L4_2 = L2_2
  L5_2 = "event.phoneState"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    return
  end
  A0_2 = true == A0_2
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L4_2 = A1_2
    L3_2 = A1_2.sub
    L5_2 = 1
    L6_2 = 32
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    A1_2 = L3_2
    L4_2 = A1_2
    L3_2 = A1_2.match
    L5_2 = "^[%w_%-%.]+$"
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      A1_2 = nil
    end
  else
    A1_2 = nil
  end
  if A1_2 then
    L3_2 = Config
    L3_2 = L3_2.Devices
    if L3_2 then
      L3_2 = Config
      L3_2 = L3_2.Devices
      L3_2 = L3_2[A1_2]
      if L3_2 then
        L3_2 = LastDevice
        L3_2[L2_2] = A1_2
      end
    end
  end
  L3_2 = Player
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L3_2.state
  if A1_2 then
    L4_2 = Config
    L4_2 = L4_2.Devices
    if L4_2 then
      L4_2 = Config
      L4_2 = L4_2.Devices
      L4_2 = L4_2[A1_2]
      if L4_2 and A1_2 then
        goto lbl_62
        L4_2 = A1_2 or L4_2
      end
    end
  end
  L4_2 = false
  ::lbl_62::
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = L3_2.apex_device
    L1_3 = L4_2
    if L0_3 ~= L1_3 then
      L0_3 = L3_2
      L1_3 = L0_3
      L0_3 = L0_3.set
      L2_3 = "apex_device"
      L3_3 = L4_2
      L4_3 = true
      L0_3(L1_3, L2_3, L3_3, L4_3)
    end
  end
  L5_2(L6_2)
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = L3_2.apex_phoneOpen
    L1_3 = A0_2
    if L0_3 ~= L1_3 then
      L0_3 = L3_2
      L1_3 = L0_3
      L0_3 = L0_3.set
      L2_3 = "apex_phoneOpen"
      L3_3 = A0_2
      L4_3 = true
      L0_3(L1_3, L2_3, L3_3, L4_3)
    end
  end
  L5_2(L6_2)
  L5_2 = L115_1
  L5_2 = L5_2[L2_2]
  if not L5_2 then
    L6_2 = {}
    L6_2.open = false
    L5_2 = L6_2
    L6_2 = L115_1
    L6_2[L2_2] = L5_2
  end
  if A0_2 then
    L6_2 = L5_2.open
    if L6_2 then
      L5_2.device = A1_2
      return
    end
  end
  L6_2 = L5_2.open
  if A0_2 == L6_2 then
    return
  end
  L6_2 = A0_2
  L7_2 = A1_2 or L7_2
  if not A0_2 or not A1_2 then
    L7_2 = nil
  end
  L5_2.device = L7_2
  L5_2.open = L6_2
  L6_2 = Dbg
  L7_2 = "phone"
  L8_2 = "%s %s%s"
  L9_2 = L2_2
  if A0_2 then
    L10_2 = "opened"
    if L10_2 then
      goto lbl_107
    end
  end
  L10_2 = "closed"
  ::lbl_107::
  if A1_2 then
    L11_2 = " ("
    L12_2 = A1_2
    L13_2 = ")"
    L11_2 = L11_2 .. L12_2 .. L13_2
    if L11_2 then
      goto lbl_116
    end
  end
  L11_2 = ""
  ::lbl_116::
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  if A0_2 then
    L6_2 = TriggerEvent
    L7_2 = "apex_phone:phoneOpened"
    L8_2 = L2_2
    L9_2 = A1_2
    L6_2(L7_2, L8_2, L9_2)
  else
    L6_2 = TriggerEvent
    L7_2 = "apex_phone:phoneClosed"
    L8_2 = L2_2
    L6_2(L7_2, L8_2)
  end
end
L119_1(L120_1, L121_1)
L119_1 = AddEventHandler
L120_1 = "onResourceStop"
function L121_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L115_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    if L6_2 then
      L7_2 = L6_2.open
      if L7_2 then
        L7_2 = pcall
        function L8_2()
          local L0_3, L1_3, L2_3, L3_3, L4_3
          L0_3 = Player
          L1_3 = L5_2
          L0_3 = L0_3(L1_3)
          L0_3 = L0_3.state
          L1_3 = L0_3
          L0_3 = L0_3.set
          L2_3 = "apex_phoneOpen"
          L3_3 = false
          L4_3 = true
          L0_3(L1_3, L2_3, L3_3, L4_3)
        end
        L7_2(L8_2)
      end
    end
  end
end
L119_1(L120_1, L121_1)
L119_1 = nil
function L120_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L119_1
  if not L1_2 then
    L1_2 = {}
    L119_1 = L1_2
    function L1_2(A0_3)
      local L1_3, L2_3
      L1_3 = type
      L2_3 = A0_3
      L1_3 = L1_3(L2_3)
      if "string" == L1_3 and "" ~= A0_3 then
        L1_3 = GetHashKey
        L2_3 = A0_3
        L1_3 = L1_3(L2_3)
        L2_3 = L1_3 % 4294967296
        L1_3 = L119_1
        L1_3[L2_3] = true
      end
    end
    L2_2 = L1_2
    L3_2 = Config
    L3_2 = L3_2.PhoneProp
    L2_2(L3_2)
    L2_2 = pairs
    L3_2 = Config
    L3_2 = L3_2.Devices
    if not L3_2 then
      L3_2 = {}
    end
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L1_2
      L9_2 = L7_2.prop
      L8_2(L9_2)
      L8_2 = type
      L9_2 = L7_2.fold
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L8_2 = L1_2
        L9_2 = L7_2.fold
        L9_2 = L9_2.base
        L8_2(L9_2)
        L8_2 = L1_2
        L9_2 = L7_2.fold
        L9_2 = L9_2.leaf
        L8_2(L9_2)
      end
    end
    L2_2 = pairs
    L3_2 = Config
    L3_2 = L3_2.FrameProps
    if not L3_2 then
      L3_2 = {}
    end
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L1_2
      L9_2 = L7_2
      L8_2(L9_2)
    end
  end
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  L2_2 = L1_2 % 4294967296
  L1_2 = L119_1
  L1_2 = L1_2[L2_2]
  L1_2 = true == L1_2
  return L1_2
end
L121_1 = _ENV
L122_1 = "RegisterNetEvent"
L121_1 = L121_1[L122_1]
L122_1 = "apex_phone:server:propNet"
function L123_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = source
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2)
  A0_2 = L3_2
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2)
  A1_2 = L3_2
  if A1_2 then
    if not (A1_2 <= 0) then
      L3_2 = 65535
      if not (A1_2 > L3_2) then
        goto lbl_24
      end
    end
    A1_2 = nil
  end
  ::lbl_24::
  if A0_2 and not (A0_2 <= 0) then
    L3_2 = 65535
    if not (A0_2 > L3_2) then
      goto lbl_46
    end
  end
  L3_2 = L118_1
  L4_2 = L118_1
  L4_2 = L4_2[L2_2]
  if not L4_2 then
    L4_2 = 0
  end
  L4_2 = L4_2 + 1
  L3_2[L2_2] = L4_2
  L3_2 = L116_1
  L4_2 = L117_1
  L5_2 = nil
  L4_2[L2_2] = nil
  L3_2[L2_2] = L5_2
  do return end
  ::lbl_46::
  L3_2 = RateLimitAllow
  L4_2 = L2_2
  L5_2 = "event.propNet"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    return
  end
  L3_2 = L118_1
  L3_2 = L3_2[L2_2]
  if not L3_2 then
    L3_2 = 0
  end
  L3_2 = L3_2 + 1
  L4_2 = L118_1
  L4_2[L2_2] = L3_2
  L4_2 = CreateThread
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = 1
    L1_3 = 15
    L2_3 = 1
    for L3_3 = L0_3, L1_3, L2_3 do
      L5_3 = L2_2
      L4_3 = L118_1
      L4_3 = L4_3[L5_3]
      L5_3 = L3_2
      if L4_3 ~= L5_3 then
        return
      end
      L4_3 = NetworkGetEntityFromNetworkId
      L5_3 = A0_2
      L4_3 = L4_3(L5_3)
      if L4_3 and 0 ~= L4_3 then
        L5_3 = DoesEntityExist
        L6_3 = L4_3
        L5_3 = L5_3(L6_3)
        if L5_3 then
          L5_3 = GetEntityType
          L6_3 = L4_3
          L5_3 = L5_3(L6_3)
          if 3 == L5_3 then
            L5_3 = NetworkGetEntityOwner
            L6_3 = L4_3
            L5_3 = L5_3(L6_3)
            L6_3 = L2_2
            if L5_3 == L6_3 then
              L5_3 = L120_1
              L6_3 = GetEntityModel
              L7_3 = L4_3
              L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L6_3(L7_3)
              L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
              if L5_3 then
                L6_3 = L2_2
                L5_3 = L116_1
                L7_3 = A0_2
                L5_3[L6_3] = L7_3
                L6_3 = L2_2
                L5_3 = L117_1
                L5_3[L6_3] = nil
                L5_3 = A1_2
                if L5_3 then
                  L5_3 = 1
                  L6_3 = 10
                  L7_3 = 1
                  for L8_3 = L5_3, L6_3, L7_3 do
                    L10_3 = L2_2
                    L9_3 = L118_1
                    L9_3 = L9_3[L10_3]
                    L10_3 = L3_2
                    if L9_3 ~= L10_3 then
                      return
                    end
                    L9_3 = NetworkGetEntityFromNetworkId
                    L10_3 = A1_2
                    L9_3 = L9_3(L10_3)
                    if L9_3 and 0 ~= L9_3 then
                      L10_3 = DoesEntityExist
                      L11_3 = L9_3
                      L10_3 = L10_3(L11_3)
                      if L10_3 then
                        L10_3 = GetEntityType
                        L11_3 = L9_3
                        L10_3 = L10_3(L11_3)
                        if 3 == L10_3 then
                          L10_3 = NetworkGetEntityOwner
                          L11_3 = L9_3
                          L10_3 = L10_3(L11_3)
                          L11_3 = L2_2
                          if L10_3 == L11_3 then
                            L10_3 = L120_1
                            L11_3 = GetEntityModel
                            L12_3 = L9_3
                            L11_3, L12_3 = L11_3(L12_3)
                            L10_3 = L10_3(L11_3, L12_3)
                            if L10_3 then
                              L11_3 = L2_2
                              L10_3 = L117_1
                              L12_3 = A1_2
                              L10_3[L11_3] = L12_3
                            end
                          end
                        end
                        break
                      end
                    end
                    L10_3 = Wait
                    L11_3 = 200
                    L10_3(L11_3)
                  end
                end
            end
          end
          else
            L5_3 = Dbg
            L6_3 = "phone"
            L7_3 = "propNet rejected from %s (netId %s is not their prop)"
            L8_3 = L2_2
            L9_3 = A0_2
            L5_3(L6_3, L7_3, L8_3, L9_3)
          end
          return
        end
      end
      L5_3 = Wait
      L6_3 = 200
      L5_3(L6_3)
    end
  end
  L4_2(L5_2)
end
L121_1(L122_1, L123_1)
L121_1 = _ENV
L122_1 = "FW"
L121_1 = L121_1[L122_1]
L121_1 = L121_1.OnPlayerLoaded
function L122_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    return
  end
  L2_2 = L2_1
  L2_2[A0_2] = nil
  L2_2 = L68_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = L68_1
    L2_2 = L2_2[A0_2]
    L2_2 = L2_2.cid
    if L2_2 ~= L1_2 then
      L2_2 = L68_1
      L2_2[A0_2] = nil
    end
  end
  L2_2 = Push
  L3_2 = A0_2
  L4_2 = "session"
  L5_2 = {}
  L5_2.citizenid = L1_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = MySQL
  L2_2 = L2_2.single
  L3_2 = "SELECT * FROM apex_phone_accounts WHERE citizenid = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    if A0_3 then
      L1_3 = Accounts
      L2_3 = L1_2
      L3_3 = L53_1
      L4_3 = A0_3
      L3_3 = L3_3(L4_3)
      L1_3[L2_3] = L3_3
    end
    L1_3 = SyncPhoneNumberState
    L2_3 = A0_2
    if A0_3 then
      L3_3 = A0_3.phone
      if L3_3 then
        goto lbl_17
      end
    end
    L3_3 = nil
    ::lbl_17::
    L1_3(L2_3, L3_3)
    if A0_3 then
      L1_3 = tostring
      L2_3 = A0_3.phone
      if not L2_3 then
        L2_3 = ""
      end
      L1_3 = L1_3(L2_3)
      if L1_3 then
        goto lbl_29
      end
    end
    L1_3 = ""
    ::lbl_29::
    if "" ~= L1_3 then
      L2_3 = Config
      L2_3 = L2_3.SyncNumberToCharInfo
      if L2_3 then
        L2_3 = FW
        L2_3 = L2_3.GetCidPhone
        L3_3 = A0_2
        L2_3, L3_3, L4_3 = L2_3(L3_3)
        if L2_3 then
          L5_3 = L1_2
          if L3_3 == L5_3 then
            L5_3 = tostring
            L6_3 = L4_3 or L6_3
            if not L4_3 then
              L6_3 = ""
            end
            L5_3 = L5_3(L6_3)
            if L5_3 ~= L1_3 then
              L5_3 = Dbg
              L6_3 = "account"
              L7_3 = "%s: framework number %s synced with the account number %s"
              L8_3 = L1_2
              L9_3 = tostring
              L10_3 = L4_3
              L9_3 = L9_3(L10_3)
              L10_3 = L1_3
              L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
              L5_3 = L36_1
              L6_3 = A0_2
              L7_3 = L1_3
              L5_3(L6_3, L7_3)
            end
          end
        end
      end
    end
  end
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = Wait
    L1_3 = 4000
    L0_3(L1_3)
    L0_3 = DeliverPendingNotifications
    L1_3 = A0_2
    L0_3(L1_3)
    L0_3 = FW
    L0_3 = L0_3.name
    if "standalone" == L0_3 then
      L0_3 = Wait
      L1_3 = 16000
      L0_3(L1_3)
      L0_3 = GetPlayerName
      L1_3 = A0_2
      L0_3 = L0_3(L1_3)
      if L0_3 then
        L0_3 = GetCid
        L1_3 = A0_2
        L0_3 = L0_3(L1_3)
        L1_3 = L1_2
        if L0_3 == L1_3 then
          L1_3 = A0_2
          L0_3 = L2_1
          L0_3 = L0_3[L1_3]
          L1_3 = L1_2
          if L0_3 ~= L1_3 then
            L0_3 = Push
            L1_3 = A0_2
            L2_3 = "session"
            L3_3 = {}
            L4_3 = L1_2
            L3_3.citizenid = L4_3
            L0_3(L1_3, L2_3, L3_3)
          end
        end
      end
    end
  end
  L2_2(L3_2)
end
L121_1(L122_1)
L121_1 = _ENV
L122_1 = "FW"
L121_1 = L121_1[L122_1]
L122_1 = "OnPlayerDropped"
L121_1 = L121_1[L122_1]
function L122_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L0_1
  L1_2[A0_2] = nil
  L1_2 = L111_1
  L2_2 = A0_2
  L1_2(L2_2)
  L1_2 = L68_1
  L1_2[A0_2] = nil
  L1_2 = L115_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = L1_2.open
    if L2_2 then
      L2_2 = TriggerEvent
      L3_2 = "apex_phone:phoneClosed"
      L4_2 = A0_2
      L2_2(L3_2, L4_2)
    end
  end
  L2_2 = L115_1
  L2_2[A0_2] = nil
  L2_2 = LastDevice
  L2_2[A0_2] = nil
end
L121_1(L122_1)
L121_1 = AddEventHandler
L122_1 = "playerDropped"
function L123_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = source
  end
  L1_2 = L56_1
  L2_2 = L57_1
  L3_2 = L2_1
  L4_2 = nil
  L5_2 = nil
  L3_2[L0_2] = nil
  L2_2[L0_2] = L5_2
  L1_2[L0_2] = L4_2
  L1_2 = L68_1
  L2_2 = L70_1
  L3_2 = nil
  L2_2[L0_2] = nil
  L1_2[L0_2] = L3_2
  L1_2 = L116_1
  L1_2 = L1_2[L0_2]
  L2_2 = L117_1
  L2_2 = L2_2[L0_2]
  L3_2 = L116_1
  L4_2 = L117_1
  L5_2 = L118_1
  L6_2 = nil
  L7_2 = nil
  L5_2[L0_2] = nil
  L4_2[L0_2] = L7_2
  L3_2[L0_2] = L6_2
  L3_2 = ipairs
  L4_2 = {}
  L5_2 = L1_2 or L5_2
  if not L1_2 then
    L5_2 = false
  end
  L6_2 = L2_2 or L6_2
  if not L2_2 then
    L6_2 = false
  end
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L8_2 then
      L9_2 = NetworkGetEntityFromNetworkId
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if L9_2 and 0 ~= L9_2 then
        L10_2 = DoesEntityExist
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        if L10_2 then
          L10_2 = L120_1
          L11_2 = GetEntityModel
          L12_2 = L9_2
          L11_2, L12_2 = L11_2(L12_2)
          L10_2 = L10_2(L11_2, L12_2)
          if L10_2 then
            L10_2 = DeleteEntity
            L11_2 = L9_2
            L10_2(L11_2)
          end
        end
      end
    end
  end
end
L121_1(L122_1, L123_1)
L121_1 = "apex_phone:propfit"
L122_1 = _ENV
L123_1 = "GetResourceKvpString"
L122_1 = L122_1[L123_1]
L123_1 = L121_1
L122_1 = L122_1(L123_1)
L123_1 = _ENV
L124_1 = "pcall"
L123_1 = L123_1[L124_1]
L124_1 = _ENV
L125_1 = "json"
L124_1 = L124_1[L125_1]
L125_1 = "decode"
L124_1 = L124_1[L125_1]
L125_1 = L122_1 or L125_1
if not L122_1 then
  L125_1 = ""
end
L123_1, L124_1 = L123_1(L124_1, L125_1)
L125_1 = _ENV
L126_1 = "GlobalState"
L125_1 = L125_1[L126_1]
if L123_1 then
  L126_1 = _ENV
  L127_1 = "type"
  L126_1 = L126_1[L127_1]
  L127_1 = L124_1
  L126_1 = L126_1(L127_1)
  L127_1 = "table"
  if L126_1 == L127_1 and L124_1 then
    goto lbl_1462
    L126_1 = L124_1 or L126_1
  end
end
L126_1 = {}
::lbl_1462::
L125_1[L121_1] = L126_1
L122_1 = _ENV
L123_1 = "FW"
L122_1 = L122_1[L123_1]
L123_1 = "AddCommand"
L122_1 = L122_1[L123_1]
L123_1 = _ENV
L124_1 = "Config"
L123_1 = L123_1[L124_1]
L124_1 = "PropFitCommand"
L123_1 = L123_1[L124_1]
if not L123_1 then
  L123_1 = "phonepos"
end
L124_1 = "Ajustar a posi\195\167\195\163o do telem\195\179vel na m\195\163o, com a anima\195\167\195\163o a correr (admin)"
L125_1 = {}
function L126_1(A0_2)
  local L1_2, L2_2, L3_2
  if 0 == A0_2 then
    L1_2 = print
    L2_2 = "[unique_phone] /phonepos must be used in game"
    L1_2(L2_2)
    return
  end
  L1_2 = TriggerClientEvent
  L2_2 = "apex_phone:client:posEditor"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
L127_1 = "admin"
L122_1(L123_1, L124_1, L125_1, L126_1, L127_1)
L122_1 = _ENV
L123_1 = "RegisterNetEvent"
L122_1 = L122_1[L123_1]
L123_1 = "apex_phone:server:propFit"
function L124_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L3_2 = source
  L4_2 = FW
  L4_2 = L4_2.IsAdmin
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    return
  end
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 and "" ~= A0_2 then
    L4_2 = Config
    L4_2 = L4_2.Devices
    if L4_2 then
      L4_2 = Config
      L4_2 = L4_2.Devices
      L4_2 = L4_2[A0_2]
      if L4_2 then
        goto lbl_32
      end
    end
  end
  L4_2 = FW
  L4_2 = L4_2.Notify
  L5_2 = L3_2
  L6_2 = "Aparelho desconhecido."
  L7_2 = "error"
  L4_2(L5_2, L6_2, L7_2)
  do return end
  ::lbl_32::
  L4_2 = GlobalState
  L5_2 = L121_1
  L4_2 = L4_2[L5_2]
  L5_2 = {}
  L6_2 = type
  L7_2 = L4_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = pairs
    L7_2 = L4_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L5_2[L10_2] = L11_2
    end
  end
  function L6_2(A0_3, A1_3, A2_3, A3_3)
    local L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L4_3 = type
    L5_3 = A0_3
    L4_3 = L4_3(L5_3)
    if "table" ~= L4_3 then
      L4_3 = nil
      return L4_3
    end
    L4_3 = {}
    L5_3 = 1
    L6_3 = 3
    L7_3 = 1
    for L8_3 = L5_3, L6_3, L7_3 do
      L9_3 = tonumber
      L10_3 = A0_3[L8_3]
      L9_3 = L9_3(L10_3)
      if not L9_3 or L9_3 ~= L9_3 then
        L10_3 = nil
        return L10_3
      end
      L10_3 = math
      L10_3 = L10_3.floor
      L11_3 = math
      L11_3 = L11_3.max
      L12_3 = A1_3
      L13_3 = math
      L13_3 = L13_3.min
      L14_3 = A2_3
      L15_3 = L9_3
      L13_3 = L13_3(L14_3, L15_3)
      L11_3 = L11_3(L12_3, L13_3)
      L11_3 = L11_3 * A3_3
      L11_3 = L11_3 + 0.5
      L10_3 = L10_3(L11_3)
      L10_3 = L10_3 / A3_3
      L4_3[L8_3] = L10_3
    end
    return L4_3
  end
  if nil == A1_2 and nil == A2_2 then
    L5_2[A0_2] = nil
    L7_2 = FW
    L7_2 = L7_2.Notify
    L8_2 = L3_2
    L9_2 = "Posi\195\167\195\163o reposta (config.lua)."
    L10_2 = "success"
    L7_2(L8_2, L9_2, L10_2)
  else
    L7_2 = L6_2
    L8_2 = A1_2
    L9_2 = -0.5
    L10_2 = 0.5
    L11_2 = 10000
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
    L8_2 = L6_2
    L9_2 = A2_2
    L10_2 = -360
    L11_2 = 360
    L12_2 = 100
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
    if not L7_2 or not L8_2 then
      return
    end
    L9_2 = {}
    L9_2.pos = L7_2
    L9_2.rot = L8_2
    L5_2[A0_2] = L9_2
    L9_2 = FW
    L9_2 = L9_2.Notify
    L10_2 = L3_2
    L11_2 = "Posi\195\167\195\163o guardada para todos os jogadores."
    L12_2 = "success"
    L9_2(L10_2, L11_2, L12_2)
    L9_2 = print
    L10_2 = "[unique_phone] %s: pos = vector3(%.4f, %.4f, %.4f), rot = vector3(%.2f, %.2f, %.2f)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = A0_2
    L13_2 = L7_2[1]
    L14_2 = L7_2[2]
    L15_2 = L7_2[3]
    L16_2 = L8_2[1]
    L17_2 = L8_2[2]
    L18_2 = L8_2[3]
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  end
  L7_2 = SetResourceKvp
  L8_2 = L121_1
  L9_2 = json
  L9_2 = L9_2.encode
  L10_2 = L5_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L9_2(L10_2)
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L7_2 = GlobalState
  L8_2 = L121_1
  L7_2[L8_2] = L5_2
end
L122_1(L123_1, L124_1)
