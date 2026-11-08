local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1
L0_1 = "showcase_capps_backup"
L1_1 = true
L2_1 = "apex_phone_capp_items"
L3_1 = "apex_phone_capp_notes"
L4_1 = Config
L4_1 = L4_1.Currency
if L4_1 then
  L4_1 = Config
  L4_1 = L4_1.Currency
  L4_1 = L4_1.symbol
  if L4_1 then
    goto lbl_16
  end
end
L4_1 = "$"
::lbl_16::
L5_1 = " \194\183 "
L6_1 = {}
L7_1 = {}
L8_1 = "police"
L9_1 = "lspd"
L10_1 = "sheriff"
L11_1 = "bcso"
L12_1 = "sasp"
L13_1 = "statepolice"
L7_1[1] = L8_1
L7_1[2] = L9_1
L7_1[3] = L10_1
L7_1[4] = L11_1
L7_1[5] = L12_1
L7_1[6] = L13_1
L6_1.lspd = L7_1
L7_1 = {}
L8_1 = "ambulance"
L9_1 = "ems"
L10_1 = "doctor"
L11_1 = "medic"
L12_1 = "pillbox"
L7_1[1] = L8_1
L7_1[2] = L9_1
L7_1[3] = L10_1
L7_1[4] = L11_1
L7_1[5] = L12_1
L6_1.pillbox = L7_1
L7_1 = {}
L8_1 = "burgershot"
L9_1 = "burguershot"
L10_1 = "burger_shot"
L11_1 = "burger"
L7_1[1] = L8_1
L7_1[2] = L9_1
L7_1[3] = L10_1
L7_1[4] = L11_1
L6_1.burgershot = L7_1
L7_1 = {}
L8_1 = "mechanic"
L9_1 = "bennys"
L10_1 = "benny"
L11_1 = "tuner"
L7_1[1] = L8_1
L7_1[2] = L9_1
L7_1[3] = L10_1
L7_1[4] = L11_1
L6_1.bennys = L7_1
L7_1 = {}
L8_1 = "reporter"
L9_1 = "weazel"
L10_1 = "news"
L11_1 = "journalist"
L7_1[1] = L8_1
L7_1[2] = L9_1
L7_1[3] = L10_1
L7_1[4] = L11_1
L6_1.weazel = L7_1
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
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
    L8_2 = L7_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    L1_2[L6_2] = L8_2
  end
  return L1_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L7_2] = true
  end
  return L1_2
end
function L9_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = A0_2.apps
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = A0_2.apps
      if L1_2 then
        goto lbl_16
      end
    end
  end
  L1_2 = {}
  ::lbl_16::
  return L1_2
end
function L10_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2
  L5_2 = {}
  L5_2.id = A0_2
  L5_2.label = A1_2
  L5_2.color = A2_2
  L6_2 = A3_2 or L6_2
  if not A3_2 then
    L6_2 = nil
  end
  L5_2.closed = L6_2
  L6_2 = false ~= A4_2
  L5_2.notify = L6_2
  return L5_2
end
function L11_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2
  if not A3_2 then
    L4_2 = {}
    A3_2 = L4_2
  end
  L4_2 = {}
  L4_2.key = A0_2
  L4_2.label = A1_2
  L5_2 = A2_2 or L5_2
  if not A2_2 then
    L5_2 = "text"
  end
  L4_2.type = L5_2
  L5_2 = A3_2.req
  L5_2 = true == L5_2
  L4_2.required = L5_2
  L5_2 = A3_2.options
  if L5_2 then
    L5_2 = A3_2.options
    L4_2.options = L5_2
  end
  L5_2 = A3_2.ph
  if L5_2 then
    L5_2 = A3_2.ph
    L4_2.placeholder = L5_2
  end
  L5_2 = A3_2.help
  if L5_2 then
    L5_2 = A3_2.help
    L4_2.help = L5_2
  end
  L5_2 = A3_2.min
  if nil ~= L5_2 then
    L5_2 = A3_2.min
    L4_2.min = L5_2
  end
  L5_2 = A3_2.max
  if nil ~= L5_2 then
    L5_2 = A3_2.max
    L4_2.max = L5_2
  end
  L5_2 = A3_2.def
  if nil ~= L5_2 then
    L5_2 = A3_2.def
    L4_2.default = L5_2
  end
  L5_2 = A3_2.showIf
  if L5_2 then
    L5_2 = {}
    L6_2 = A3_2.showIf
    L6_2 = L6_2[1]
    L5_2.key = L6_2
    L6_2 = A3_2.showIf
    L6_2 = L6_2[2]
    L5_2.equals = L6_2
    L4_2.showIf = L5_2
  end
  return L4_2
end
function L12_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2
  if not A5_2 then
    L6_2 = {}
    A5_2 = L6_2
  end
  L6_2 = {}
  L6_2.id = A0_2
  L6_2.type = A1_2
  L6_2.title = A2_2
  L6_2.icon = A3_2
  L6_2.enabled = true
  L7_2 = A5_2.civil
  L7_2 = false ~= L7_2
  L6_2.civil = L7_2
  L6_2.staff = true
  L6_2.staffMinGrade = 0
  L6_2.options = A4_2
  return L6_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.key
    L10_2 = A1_2[L10_2]
    if nil ~= L10_2 and "" ~= L10_2 and false ~= L10_2 then
      L11_2 = L9_2.key
      L2_2[L11_2] = L10_2
      L11_2 = #L3_2
      L11_2 = L11_2 + 1
      L12_2 = L9_2.key
      L3_2[L11_2] = L12_2
    end
  end
  L4_2 = {}
  L4_2.fields = L2_2
  L4_2.order = L3_2
  return L4_2
end
L14_1 = {}
L15_1 = 1
L16_1 = 2
L17_1 = 3
L18_1 = 4
L19_1 = 5
L20_1 = 6
L21_1 = 7
L14_1[1] = L15_1
L14_1[2] = L16_1
L14_1[3] = L17_1
L14_1[4] = L18_1
L14_1[5] = L19_1
L14_1[6] = L20_1
L14_1[7] = L21_1
L15_1 = {}
L16_1 = 1
L17_1 = 2
L18_1 = 3
L19_1 = 4
L20_1 = 5
L21_1 = 6
L15_1[1] = L16_1
L15_1[2] = L17_1
L15_1[3] = L18_1
L15_1[4] = L19_1
L15_1[5] = L20_1
L15_1[6] = L21_1
L16_1 = {}
L17_1 = L11_1
L18_1 = "type"
L19_1 = "Type of incident"
L20_1 = "select"
L21_1 = {}
L21_1.req = true
L22_1 = {}
L23_1 = "Theft"
L24_1 = "Robbery"
L25_1 = "Assault"
L26_1 = "Vandalism"
L27_1 = "Fraud"
L28_1 = "Stolen vehicle"
L29_1 = "Threats"
L30_1 = "Other"
L22_1[1] = L23_1
L22_1[2] = L24_1
L22_1[3] = L25_1
L22_1[4] = L26_1
L22_1[5] = L27_1
L22_1[6] = L28_1
L22_1[7] = L29_1
L22_1[8] = L30_1
L21_1.options = L22_1
L17_1 = L17_1(L18_1, L19_1, L20_1, L21_1)
L18_1 = L11_1
L19_1 = "other"
L20_1 = "What kind?"
L21_1 = "text"
L22_1 = {}
L22_1.req = true
L23_1 = {}
L24_1 = "type"
L25_1 = "Other"
L23_1[1] = L24_1
L23_1[2] = L25_1
L22_1.showIf = L23_1
L22_1.ph = "Tell us what kind of incident"
L18_1 = L18_1(L19_1, L20_1, L21_1, L22_1)
L19_1 = L11_1
L20_1 = "where"
L21_1 = "Where did it happen"
L22_1 = "text"
L23_1 = {}
L23_1.ph = "Street, neighborhood or landmark"
L19_1 = L19_1(L20_1, L21_1, L22_1, L23_1)
L20_1 = L11_1
L21_1 = "date"
L22_1 = "Date"
L23_1 = "date"
L20_1 = L20_1(L21_1, L22_1, L23_1)
L21_1 = L11_1
L22_1 = "time"
L23_1 = "Approximate time"
L24_1 = "time"
L21_1 = L21_1(L22_1, L23_1, L24_1)
L22_1 = L11_1
L23_1 = "plate"
L24_1 = "Plate involved"
L25_1 = "plate"
L22_1 = L22_1(L23_1, L24_1, L25_1)
L23_1 = L11_1
L24_1 = "description"
L25_1 = "What happened"
L26_1 = "textarea"
L27_1 = {}
L27_1.req = true
L27_1.min = 20
L27_1.ph = "Describe it in as much detail as you can"
L27_1.help = "The more detail, the faster we can act."
L23_1 = L23_1(L24_1, L25_1, L26_1, L27_1)
L24_1 = L11_1
L25_1 = "witnesses"
L26_1 = "There were witnesses"
L27_1 = "checkbox"
L24_1 = L24_1(L25_1, L26_1, L27_1)
L25_1 = L11_1
L26_1 = "witness_info"
L27_1 = "Witness contact"
L28_1 = "textarea"
L29_1 = {}
L30_1 = {}
L31_1 = "witnesses"
L32_1 = "true"
L30_1[1] = L31_1
L30_1[2] = L32_1
L29_1.showIf = L30_1
L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1 = L25_1(L26_1, L27_1, L28_1, L29_1)
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
L16_1[15] = L31_1
L16_1[16] = L32_1
L16_1[17] = L33_1
L16_1[18] = L34_1
L16_1[19] = L35_1
L16_1[20] = L36_1
L16_1[21] = L37_1
L16_1[22] = L38_1
L16_1[23] = L39_1
L16_1[24] = L40_1
L16_1[25] = L41_1
L16_1[26] = L42_1
L16_1[27] = L43_1
L16_1[28] = L44_1
L16_1[29] = L45_1
L16_1[30] = L46_1
L16_1[31] = L47_1
L16_1[32] = L48_1
L16_1[33] = L49_1
L16_1[34] = L50_1
L16_1[35] = L51_1
L16_1[36] = L52_1
L16_1[37] = L53_1
L16_1[38] = L54_1
L16_1[39] = L55_1
L16_1[40] = L56_1
L16_1[41] = L57_1
L17_1 = {}
L18_1 = L11_1
L19_1 = "dob"
L20_1 = "Date of birth"
L21_1 = "date"
L18_1 = L18_1(L19_1, L20_1, L21_1)
L19_1 = L11_1
L20_1 = "charges"
L21_1 = "Charges"
L22_1 = "textarea"
L23_1 = {}
L23_1.req = true
L19_1 = L19_1(L20_1, L21_1, L22_1, L23_1)
L20_1 = L11_1
L21_1 = "fine"
L22_1 = "Fine"
L23_1 = "number"
L24_1 = {}
L24_1.min = 0
L20_1 = L20_1(L21_1, L22_1, L23_1, L24_1)
L21_1 = L11_1
L22_1 = "jail"
L23_1 = "Jail time (months)"
L24_1 = "number"
L25_1 = {}
L25_1.min = 0
L25_1.max = 600
L21_1 = L21_1(L22_1, L23_1, L24_1, L25_1)
L22_1 = L11_1
L23_1 = "notes"
L24_1 = "Notes"
L25_1 = "textarea"
L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1 = L22_1(L23_1, L24_1, L25_1)
L17_1[1] = L18_1
L17_1[2] = L19_1
L17_1[3] = L20_1
L17_1[4] = L21_1
L17_1[5] = L22_1
L17_1[6] = L23_1
L17_1[7] = L24_1
L17_1[8] = L25_1
L17_1[9] = L26_1
L17_1[10] = L27_1
L17_1[11] = L28_1
L17_1[12] = L29_1
L17_1[13] = L30_1
L17_1[14] = L31_1
L17_1[15] = L32_1
L17_1[16] = L33_1
L17_1[17] = L34_1
L17_1[18] = L35_1
L17_1[19] = L36_1
L17_1[20] = L37_1
L17_1[21] = L38_1
L17_1[22] = L39_1
L17_1[23] = L40_1
L17_1[24] = L41_1
L17_1[25] = L42_1
L17_1[26] = L43_1
L17_1[27] = L44_1
L17_1[28] = L45_1
L17_1[29] = L46_1
L17_1[30] = L47_1
L17_1[31] = L48_1
L17_1[32] = L49_1
L17_1[33] = L50_1
L17_1[34] = L51_1
L17_1[35] = L52_1
L17_1[36] = L53_1
L17_1[37] = L54_1
L17_1[38] = L55_1
L17_1[39] = L56_1
L17_1[40] = L57_1
L18_1 = {}
L19_1 = L11_1
L20_1 = "blood"
L21_1 = "Blood type"
L22_1 = "select"
L23_1 = {}
L24_1 = {}
L25_1 = "A+"
L26_1 = "A-"
L27_1 = "B+"
L28_1 = "B-"
L29_1 = "AB+"
L30_1 = "AB-"
L31_1 = "O+"
L32_1 = "O-"
L24_1[1] = L25_1
L24_1[2] = L26_1
L24_1[3] = L27_1
L24_1[4] = L28_1
L24_1[5] = L29_1
L24_1[6] = L30_1
L24_1[7] = L31_1
L24_1[8] = L32_1
L23_1.options = L24_1
L19_1 = L19_1(L20_1, L21_1, L22_1, L23_1)
L20_1 = L11_1
L21_1 = "allergies"
L22_1 = "Allergies"
L23_1 = "text"
L20_1 = L20_1(L21_1, L22_1, L23_1)
L21_1 = L11_1
L22_1 = "conditions"
L23_1 = "Conditions"
L24_1 = "textarea"
L21_1 = L21_1(L22_1, L23_1, L24_1)
L22_1 = L11_1
L23_1 = "treatment"
L24_1 = "Treatment"
L25_1 = "textarea"
L22_1 = L22_1(L23_1, L24_1, L25_1)
L23_1 = L11_1
L24_1 = "next_visit"
L25_1 = "Next visit"
L26_1 = "date"
L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1 = L23_1(L24_1, L25_1, L26_1)
L18_1[1] = L19_1
L18_1[2] = L20_1
L18_1[3] = L21_1
L18_1[4] = L22_1
L18_1[5] = L23_1
L18_1[6] = L24_1
L18_1[7] = L25_1
L18_1[8] = L26_1
L18_1[9] = L27_1
L18_1[10] = L28_1
L18_1[11] = L29_1
L18_1[12] = L30_1
L18_1[13] = L31_1
L18_1[14] = L32_1
L18_1[15] = L33_1
L18_1[16] = L34_1
L18_1[17] = L35_1
L18_1[18] = L36_1
L18_1[19] = L37_1
L18_1[20] = L38_1
L18_1[21] = L39_1
L18_1[22] = L40_1
L18_1[23] = L41_1
L18_1[24] = L42_1
L18_1[25] = L43_1
L18_1[26] = L44_1
L18_1[27] = L45_1
L18_1[28] = L46_1
L18_1[29] = L47_1
L18_1[30] = L48_1
L18_1[31] = L49_1
L18_1[32] = L50_1
L18_1[33] = L51_1
L18_1[34] = L52_1
L18_1[35] = L53_1
L18_1[36] = L54_1
L18_1[37] = L55_1
L18_1[38] = L56_1
L18_1[39] = L57_1
L19_1 = {}
L20_1 = L11_1
L21_1 = "delivery"
L22_1 = "Pick up or delivery"
L23_1 = "select"
L24_1 = {}
L24_1.req = true
L25_1 = {}
L26_1 = "Pick up at the counter"
L27_1 = "Delivery"
L25_1[1] = L26_1
L25_1[2] = L27_1
L24_1.options = L25_1
L24_1.def = "Pick up at the counter"
L20_1 = L20_1(L21_1, L22_1, L23_1, L24_1)
L21_1 = L11_1
L22_1 = "address"
L23_1 = "Delivery address"
L24_1 = "text"
L25_1 = {}
L25_1.req = true
L26_1 = {}
L27_1 = "delivery"
L28_1 = "Delivery"
L26_1[1] = L27_1
L26_1[2] = L28_1
L25_1.showIf = L26_1
L25_1.ph = "Street and number"
L21_1 = L21_1(L22_1, L23_1, L24_1, L25_1)
L22_1 = L11_1
L23_1 = "notes"
L24_1 = "Notes for the kitchen"
L25_1 = "textarea"
L26_1 = {}
L26_1.ph = "No pickles, sauce on the side..."
L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1 = L22_1(L23_1, L24_1, L25_1, L26_1)
L19_1[1] = L20_1
L19_1[2] = L21_1
L19_1[3] = L22_1
L19_1[4] = L23_1
L19_1[5] = L24_1
L19_1[6] = L25_1
L19_1[7] = L26_1
L19_1[8] = L27_1
L19_1[9] = L28_1
L19_1[10] = L29_1
L19_1[11] = L30_1
L19_1[12] = L31_1
L19_1[13] = L32_1
L19_1[14] = L33_1
L19_1[15] = L34_1
L19_1[16] = L35_1
L19_1[17] = L36_1
L19_1[18] = L37_1
L19_1[19] = L38_1
L19_1[20] = L39_1
L19_1[21] = L40_1
L19_1[22] = L41_1
L19_1[23] = L42_1
L19_1[24] = L43_1
L19_1[25] = L44_1
L19_1[26] = L45_1
L19_1[27] = L46_1
L19_1[28] = L47_1
L19_1[29] = L48_1
L19_1[30] = L49_1
L19_1[31] = L50_1
L19_1[32] = L51_1
L19_1[33] = L52_1
L19_1[34] = L53_1
L19_1[35] = L54_1
L19_1[36] = L55_1
L19_1[37] = L56_1
L19_1[38] = L57_1
L20_1 = {}
L21_1 = L11_1
L22_1 = "model"
L23_1 = "Model"
L24_1 = "text"
L25_1 = {}
L25_1.req = true
L21_1 = L21_1(L22_1, L23_1, L24_1, L25_1)
L22_1 = L11_1
L23_1 = "owner"
L24_1 = "Owner"
L25_1 = "text"
L22_1 = L22_1(L23_1, L24_1, L25_1)
L23_1 = L11_1
L24_1 = "mileage"
L25_1 = "Mileage"
L26_1 = "number"
L27_1 = {}
L27_1.min = 0
L23_1 = L23_1(L24_1, L25_1, L26_1, L27_1)
L24_1 = L11_1
L25_1 = "work"
L26_1 = "Work done"
L27_1 = "select"
L28_1 = {}
L29_1 = {}
L30_1 = "Service"
L31_1 = "Repair"
L32_1 = "Respray"
L33_1 = "Tuning"
L34_1 = "Tires"
L35_1 = "Towing"
L29_1[1] = L30_1
L29_1[2] = L31_1
L29_1[3] = L32_1
L29_1[4] = L33_1
L29_1[5] = L34_1
L29_1[6] = L35_1
L28_1.options = L29_1
L24_1 = L24_1(L25_1, L26_1, L27_1, L28_1)
L25_1 = L11_1
L26_1 = "cost"
L27_1 = "Cost"
L28_1 = "number"
L29_1 = {}
L29_1.min = 0
L25_1 = L25_1(L26_1, L27_1, L28_1, L29_1)
L26_1 = L11_1
L27_1 = "notes"
L28_1 = "Notes"
L29_1 = "textarea"
L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1 = L26_1(L27_1, L28_1, L29_1)
L20_1[1] = L21_1
L20_1[2] = L22_1
L20_1[3] = L23_1
L20_1[4] = L24_1
L20_1[5] = L25_1
L20_1[6] = L26_1
L20_1[7] = L27_1
L20_1[8] = L28_1
L20_1[9] = L29_1
L20_1[10] = L30_1
L20_1[11] = L31_1
L20_1[12] = L32_1
L20_1[13] = L33_1
L20_1[14] = L34_1
L20_1[15] = L35_1
L20_1[16] = L36_1
L20_1[17] = L37_1
L20_1[18] = L38_1
L20_1[19] = L39_1
L20_1[20] = L40_1
L20_1[21] = L41_1
L20_1[22] = L42_1
L20_1[23] = L43_1
L20_1[24] = L44_1
L20_1[25] = L45_1
L20_1[26] = L46_1
L20_1[27] = L47_1
L20_1[28] = L48_1
L20_1[29] = L49_1
L20_1[30] = L50_1
L20_1[31] = L51_1
L20_1[32] = L52_1
L20_1[33] = L53_1
L20_1[34] = L54_1
L20_1[35] = L55_1
L20_1[36] = L56_1
L20_1[37] = L57_1
L21_1 = {}
L22_1 = L11_1
L23_1 = "headline"
L24_1 = "Headline"
L25_1 = "text"
L26_1 = {}
L26_1.req = true
L26_1.ph = "What is the story?"
L22_1 = L22_1(L23_1, L24_1, L25_1, L26_1)
L23_1 = L11_1
L24_1 = "what"
L25_1 = "What happened"
L26_1 = "textarea"
L27_1 = {}
L27_1.req = true
L27_1.min = 10
L23_1 = L23_1(L24_1, L25_1, L26_1, L27_1)
L24_1 = L11_1
L25_1 = "where"
L26_1 = "Where"
L27_1 = "text"
L24_1 = L24_1(L25_1, L26_1, L27_1)
L25_1 = L11_1
L26_1 = "when"
L27_1 = "When"
L28_1 = "date"
L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1 = L25_1(L26_1, L27_1, L28_1)
L21_1[1] = L22_1
L21_1[2] = L23_1
L21_1[3] = L24_1
L21_1[4] = L25_1
L21_1[5] = L26_1
L21_1[6] = L27_1
L21_1[7] = L28_1
L21_1[8] = L29_1
L21_1[9] = L30_1
L21_1[10] = L31_1
L21_1[11] = L32_1
L21_1[12] = L33_1
L21_1[13] = L34_1
L21_1[14] = L35_1
L21_1[15] = L36_1
L21_1[16] = L37_1
L21_1[17] = L38_1
L21_1[18] = L39_1
L21_1[19] = L40_1
L21_1[20] = L41_1
L21_1[21] = L42_1
L21_1[22] = L43_1
L21_1[23] = L44_1
L21_1[24] = L45_1
L21_1[25] = L46_1
L21_1[26] = L47_1
L21_1[27] = L48_1
L21_1[28] = L49_1
L21_1[29] = L50_1
L21_1[30] = L51_1
L21_1[31] = L52_1
L21_1[32] = L53_1
L21_1[33] = L54_1
L21_1[34] = L55_1
L21_1[35] = L56_1
L21_1[36] = L57_1
L22_1 = "https://foodish-api.com/images/"
L23_1 = {}
L24_1 = {}
L24_1.id = "money_shot"
L24_1.label = "The Money Shot"
L24_1.price = 9
L24_1.category = "Burgers"
L24_1.desc = "Quarter pound beef, double cheese and our secret Shot Sauce."
L25_1 = L22_1
L26_1 = "burger/burger33.jpg"
L25_1 = L25_1 .. L26_1
L24_1.image = L25_1
L25_1 = {}
L25_1.id = "bleeder"
L25_1.label = "The Bleeder"
L25_1.price = 11
L25_1.category = "Burgers"
L25_1.desc = "Flame grilled beef, pickles, tomato and ketchup on a toasted bun."
L26_1 = L22_1
L27_1 = "burger/burger5.jpg"
L26_1 = L26_1 .. L27_1
L25_1.image = L26_1
L26_1 = {}
L26_1.id = "heart_stopper"
L26_1.label = "Heart Stopper"
L26_1.price = 15
L26_1.category = "Burgers"
L26_1.desc = "Two patties, two slices of cheese, zero regrets."
L27_1 = L22_1
L28_1 = "burger/burger9.jpg"
L27_1 = L27_1 .. L28_1
L26_1.image = L27_1
L27_1 = {}
L27_1.id = "torpedo"
L27_1.label = "Bacon Torpedo"
L27_1.price = 13
L27_1.category = "Burgers"
L27_1.desc = "Crispy bacon, cheddar, lettuce and smoky BBQ sauce."
L28_1 = L22_1
L29_1 = "burger/burger14.jpg"
L28_1 = L28_1 .. L29_1
L27_1.image = L28_1
L28_1 = {}
L28_1.id = "meat_free"
L28_1.label = "Meat Free"
L28_1.price = 10
L28_1.category = "Burgers"
L28_1.desc = "Plant patty, crunchy slaw, red onion and chipotle mayo."
L29_1 = L22_1
L30_1 = "burger/burger2.jpg"
L29_1 = L29_1 .. L30_1
L28_1.image = L29_1
L29_1 = {}
L29_1.id = "chicken"
L29_1.label = "Crispy Chicken"
L29_1.price = 10
L29_1.category = "Burgers"
L29_1.desc = "Buttermilk chicken, lettuce, tomato and garlic mayo."
L30_1 = L22_1
L31_1 = "burger/burger27.jpg"
L30_1 = L30_1 .. L31_1
L29_1.image = L30_1
L30_1 = {}
L30_1.id = "fries"
L30_1.label = "Freedom Fries"
L30_1.price = 4
L30_1.category = "Sides"
L30_1.desc = "Golden, salty and way too easy to finish."
L31_1 = {}
L31_1.id = "rings"
L31_1.label = "Onion Rings"
L31_1.price = 4
L31_1.category = "Sides"
L31_1.desc = "Beer battered, with ranch dip."
L32_1 = {}
L32_1.id = "sticks"
L32_1.label = "Mozzarella Sticks"
L32_1.price = 5
L32_1.category = "Sides"
L32_1.desc = "Six sticks with marinara sauce."
L33_1 = {}
L33_1.id = "sprunk"
L33_1.label = "Sprunk"
L33_1.price = 3
L33_1.category = "Drinks"
L33_1.desc = "The essence of life. Large cup."
L34_1 = {}
L34_1.id = "ecola"
L34_1.label = "eCola"
L34_1.price = 3
L34_1.category = "Drinks"
L34_1.desc = "Deliciously infectious. Large cup."
L35_1 = {}
L35_1.id = "orang"
L35_1.label = "Orang-O-Tang"
L35_1.price = 3
L35_1.category = "Drinks"
L35_1.desc = "Orange soda, extra fizzy."
L35_1.available = false
L36_1 = {}
L36_1.id = "donuts"
L36_1.label = "Glazed Donuts"
L36_1.price = 4
L36_1.category = "Desserts"
L36_1.desc = "Three sugar donuts with strawberry jam."
L37_1 = L22_1
L38_1 = "dessert/dessert19.jpg"
L37_1 = L37_1 .. L38_1
L36_1.image = L37_1
L37_1 = {}
L37_1.id = "sundae"
L37_1.label = "Berry Sundae"
L37_1.price = 5
L37_1.category = "Desserts"
L37_1.desc = "Vanilla ice cream, berries and whipped cream."
L38_1 = L22_1
L39_1 = "dessert/dessert25.jpg"
L38_1 = L38_1 .. L39_1
L37_1.image = L38_1
L38_1 = {}
L38_1.id = "muffin"
L38_1.label = "Choc Chunk Muffin"
L38_1.price = 3
L38_1.category = "Desserts"
L38_1.desc = "Baked every morning in Del Perro."
L39_1 = L22_1
L40_1 = "dessert/dessert15.jpg"
L39_1 = L39_1 .. L40_1
L38_1.image = L39_1
L23_1[1] = L24_1
L23_1[2] = L25_1
L23_1[3] = L26_1
L23_1[4] = L27_1
L23_1[5] = L28_1
L23_1[6] = L29_1
L23_1[7] = L30_1
L23_1[8] = L31_1
L23_1[9] = L32_1
L23_1[10] = L33_1
L23_1[11] = L34_1
L23_1[12] = L35_1
L23_1[13] = L36_1
L23_1[14] = L37_1
L23_1[15] = L38_1
L24_1 = {}
L25_1 = ipairs
L26_1 = L23_1
L25_1, L26_1, L27_1, L28_1 = L25_1(L26_1)
for L29_1, L30_1 in L25_1, L26_1, L27_1, L28_1 do
  L31_1 = L30_1.id
  L24_1[L31_1] = L30_1
end
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2
  L3_2 = A2_2[1]
  L4_2 = A2_2[3]
  if not L4_2 then
    L4_2 = #A2_2
    L4_2 = A2_2[L4_2]
  end
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L1_3 = {}
    L2_3 = ipairs
    L3_3 = A0_3
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = #L1_3
      L8_3 = L8_3 + 1
      L9_3 = {}
      L9_3.name = L7_3
      L9_3.minGrade = 0
      L1_3[L8_3] = L9_3
    end
    L2_3 = {}
    L2_3.public = true
    L2_3.jobs = L1_3
    L2_3.onDutyOnly = false
    return L2_3
  end
  L6_2 = {}
  L6_2.url = ""
  L7_2 = {}
  L6_2.events = L7_2
  L7_2 = {}
  L6_2.urls = L7_2
  L7_2 = {}
  L8_2 = #L7_2
  L8_2 = L8_2 + 1
  L9_2 = {}
  L9_2.id = "lspd"
  L9_2.name = "LSPD"
  L9_2.subtitle = "Los Santos Police Department"
  L9_2.description = "Report a crime, request a patrol and follow police news in Los Santos."
  L10_2 = {}
  L10_2.glyph = "badge"
  L10_2.bg = "#1F5EFF"
  L10_2.bg2 = "#0B2A8A"
  L10_2.fg = "#FFFFFF"
  L9_2.icon = L10_2
  L9_2.accent = "#1F5EFF"
  L9_2.category = L3_2
  L9_2.enabled = true
  L9_2.listed = true
  L9_2.preinstalled = true
  L10_2 = L5_2
  L11_2 = A1_2.lspd
  L10_2 = L10_2(L11_2)
  L9_2.audience = L10_2
  L10_2 = {}
  L10_2.phone = "911"
  L10_2.label = "Emergency"
  L9_2.contact = L10_2
  L10_2 = {}
  L10_2.staff = true
  L9_2.notify = L10_2
  L9_2.webhooks = L6_2
  L10_2 = A0_2.ago
  L11_2 = 8640
  L10_2 = L10_2(L11_2)
  L9_2.created = L10_2
  L10_2 = {}
  L11_2 = L12_1
  L12_2 = "dispatch"
  L13_2 = "dispatch"
  L14_2 = "Dispatch"
  L15_2 = "siren"
  L16_2 = {}
  L16_2.location = true
  L16_2.cooldown = 90
  L17_2 = {}
  L18_2 = {}
  L18_2.id = "robbery"
  L18_2.label = "Robbery in progress"
  L18_2.icon = "handcuffs"
  L19_2 = {}
  L19_2.id = "crash"
  L19_2.label = "Traffic accident"
  L19_2.icon = "car"
  L20_2 = {}
  L20_2.id = "assault"
  L20_2.label = "Assault"
  L20_2.icon = "siren"
  L21_2 = {}
  L21_2.id = "noise"
  L21_2.label = "Noise complaint"
  L21_2.icon = "speaker"
  L22_2 = {}
  L22_2.id = "suspicious"
  L22_2.label = "Suspicious person"
  L22_2.icon = "eye"
  L23_2 = {}
  L23_2.id = "patrol"
  L23_2.label = "Request a patrol"
  L23_2.icon = "shield"
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L17_2[4] = L21_2
  L17_2[5] = L22_2
  L17_2[6] = L23_2
  L16_2.types = L17_2
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
  L12_2 = L12_1
  L13_2 = "reports"
  L14_2 = "form"
  L15_2 = "Reports"
  L16_2 = "flag"
  L17_2 = {}
  L17_2.intro = "Tell us what happened. You can report anonymously. Filing a false report is a crime."
  L17_2.submitLabel = "Send report"
  L17_2.anonymous = true
  L17_2.location = true
  L17_2.photo = true
  L17_2.civilSeesOwn = true
  L17_2.replies = true
  L17_2.deleteGrade = 3
  L18_2 = L16_1
  L17_2.fields = L18_2
  L18_2 = {}
  L19_2 = L10_1
  L20_2 = "new"
  L21_2 = "New"
  L22_2 = "#5B8CFF"
  L19_2 = L19_2(L20_2, L21_2, L22_2)
  L20_2 = L10_1
  L21_2 = "review"
  L22_2 = "Under review"
  L23_2 = "#F5A524"
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L21_2 = L10_1
  L22_2 = "investigating"
  L23_2 = "Investigating"
  L24_2 = "#A855F7"
  L21_2 = L21_2(L22_2, L23_2, L24_2)
  L22_2 = L10_1
  L23_2 = "solved"
  L24_2 = "Solved"
  L25_2 = "#10B981"
  L26_2 = true
  L22_2 = L22_2(L23_2, L24_2, L25_2, L26_2)
  L23_2 = L10_1
  L24_2 = "archived"
  L25_2 = "Archived"
  L26_2 = "#8A8F98"
  L27_2 = true
  L28_2 = false
  L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L23_2(L24_2, L25_2, L26_2, L27_2, L28_2)
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L18_2[4] = L22_2
  L18_2[5] = L23_2
  L18_2[6] = L24_2
  L18_2[7] = L25_2
  L18_2[8] = L26_2
  L18_2[9] = L27_2
  L18_2[10] = L28_2
  L18_2[11] = L29_2
  L18_2[12] = L30_2
  L18_2[13] = L31_2
  L18_2[14] = L32_2
  L18_2[15] = L33_2
  L18_2[16] = L34_2
  L18_2[17] = L35_2
  L17_2.statuses = L18_2
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L13_2 = L12_1
  L14_2 = "records"
  L15_2 = "records"
  L16_2 = "Criminal records"
  L17_2 = "idCard"
  L18_2 = {}
  L18_2.subject = "person"
  L18_2.civilSeesOwn = false
  L19_2 = L17_1
  L18_2.fields = L19_2
  L19_2 = {}
  L20_2 = {}
  L20_2.id = "warrant"
  L20_2.label = "Active warrant"
  L20_2.color = "#E5484D"
  L21_2 = {}
  L21_2.id = "dangerous"
  L21_2.label = "Armed and dangerous"
  L21_2.color = "#EA580C"
  L22_2 = {}
  L22_2.id = "watch"
  L22_2.label = "Under surveillance"
  L22_2.color = "#A855F7"
  L23_2 = {}
  L23_2.id = "priors"
  L23_2.label = "Prior record"
  L23_2.color = "#8A8F98"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L19_2[4] = L23_2
  L18_2.tags = L19_2
  L19_2 = {}
  L19_2.civil = false
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L14_2 = L12_1
  L15_2 = "fines"
  L16_2 = "billing"
  L17_2 = "Fines"
  L18_2 = "ticket"
  L19_2 = {}
  L19_2.society = true
  L19_2.maxAmount = 5000
  L19_2.reasonRequired = true
  L20_2 = {}
  L21_2 = {}
  L21_2.label = "Speeding"
  L21_2.amount = 250
  L22_2 = {}
  L22_2.label = "Illegal parking"
  L22_2.amount = 100
  L23_2 = {}
  L23_2.label = "Reckless driving"
  L23_2.amount = 750
  L24_2 = {}
  L24_2.label = "Running a red light"
  L24_2.amount = 150
  L25_2 = {}
  L25_2.label = "Driving without a license"
  L25_2.amount = 1000
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L20_2[4] = L24_2
  L20_2[5] = L25_2
  L19_2.presets = L20_2
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L15_2 = L12_1
  L16_2 = "board"
  L17_2 = "posts"
  L18_2 = "Internal board"
  L19_2 = "clipboard"
  L20_2 = {}
  L20_2.postGrade = 0
  L20_2.notifyAll = false
  L20_2.audience = "staff"
  L20_2.pinLimit = 2
  L21_2 = {}
  L21_2.civil = false
  L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L16_2 = L12_1
  L17_2 = "news"
  L18_2 = "posts"
  L19_2 = "News"
  L20_2 = "megaphone"
  L21_2 = {}
  L21_2.postGrade = 0
  L21_2.notifyAll = false
  L21_2.audience = "all"
  L21_2.pinLimit = 2
  L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2)
  L17_2 = L12_1
  L18_2 = "duty"
  L19_2 = "duty"
  L20_2 = "On duty"
  L21_2 = "clock"
  L22_2 = {}
  L22_2.esxOffPrefix = "off"
  L22_2.showTeam = true
  L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2)
  L18_2 = L12_1
  L19_2 = "team"
  L20_2 = "roster"
  L21_2 = "Team"
  L22_2 = "users"
  L23_2 = {}
  L23_2.showOffDuty = true
  L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2)
  L19_2 = L12_1
  L20_2 = "station"
  L21_2 = "info"
  L22_2 = "Station"
  L23_2 = "building"
  L24_2 = {}
  L25_2 = A0_2.img
  L26_2 = "lspdmissionrow"
  L27_2 = 1080
  L28_2 = 600
  L25_2 = L25_2(L26_2, L27_2, L28_2)
  L24_2.hero = L25_2
  L25_2 = {}
  L26_2 = {}
  L26_2.type = "text"
  L26_2.title = "About us"
  L26_2.text = "The Los Santos Police Department keeps the city safe, from Mission Row to Paleto Bay. In an emergency, always call 911."
  L27_2 = {}
  L27_2.type = "hours"
  L27_2.title = "Front desk"
  L27_2.text = "Open around the clock, every day of the year."
  L28_2 = {}
  L28_2.from = 0
  L28_2.to = 24
  L29_2 = L14_1
  L28_2.days = L29_2
  L27_2.hours = L28_2
  L28_2 = {}
  L28_2.type = "location"
  L28_2.title = "Mission Row Police Station"
  L28_2.text = "Mission Row, Downtown Los Santos"
  L28_2.x = 441.2
  L28_2.y = -981.9
  L29_2 = {}
  L29_2.type = "contact"
  L29_2.title = "Non-emergency line"
  L29_2.text = "For reports that can wait."
  L29_2.phone = "555-0100"
  L30_2 = {}
  L30_2.type = "text"
  L30_2.title = "Lost and found"
  L30_2.text = "Found items stay at the front desk for 30 days. Bring an ID to pick them up."
  L25_2[1] = L26_2
  L25_2[2] = L27_2
  L25_2[3] = L28_2
  L25_2[4] = L29_2
  L25_2[5] = L30_2
  L24_2.blocks = L25_2
  L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2)
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L10_2[7] = L17_2
  L10_2[8] = L18_2
  L10_2[9] = L19_2
  L10_2[10] = L20_2
  L10_2[11] = L21_2
  L10_2[12] = L22_2
  L10_2[13] = L23_2
  L10_2[14] = L24_2
  L10_2[15] = L25_2
  L10_2[16] = L26_2
  L10_2[17] = L27_2
  L10_2[18] = L28_2
  L10_2[19] = L29_2
  L10_2[20] = L30_2
  L10_2[21] = L31_2
  L10_2[22] = L32_2
  L10_2[23] = L33_2
  L10_2[24] = L34_2
  L10_2[25] = L35_2
  L9_2.modules = L10_2
  L7_2[L8_2] = L9_2
  L8_2 = #L7_2
  L8_2 = L8_2 + 1
  L9_2 = {}
  L9_2.id = "pillbox"
  L9_2.name = "Pillbox Medical"
  L9_2.subtitle = "Pillbox Hill Medical Center"
  L9_2.description = "Book an appointment, call an ambulance and check your medical record."
  L10_2 = {}
  L10_2.glyph = "heartPulse"
  L10_2.bg = "#E5484D"
  L10_2.bg2 = "#8E1A1F"
  L10_2.fg = "#FFFFFF"
  L9_2.icon = L10_2
  L9_2.accent = "#E5484D"
  L9_2.category = L3_2
  L9_2.enabled = true
  L9_2.listed = true
  L9_2.preinstalled = true
  L10_2 = L5_2
  L11_2 = A1_2.pillbox
  L10_2 = L10_2(L11_2)
  L9_2.audience = L10_2
  L10_2 = {}
  L10_2.phone = "911"
  L10_2.label = "Medical emergency"
  L9_2.contact = L10_2
  L10_2 = {}
  L10_2.staff = true
  L9_2.notify = L10_2
  L9_2.webhooks = L6_2
  L10_2 = A0_2.ago
  L11_2 = 8610
  L10_2 = L10_2(L11_2)
  L9_2.created = L10_2
  L10_2 = {}
  L11_2 = L12_1
  L12_2 = "appointments"
  L13_2 = "appointments"
  L14_2 = "Appointments"
  L15_2 = "calendar"
  L16_2 = {}
  L17_2 = {}
  L18_2 = {}
  L18_2.id = "checkup"
  L18_2.label = "General check-up"
  L18_2.minutes = 30
  L19_2 = {}
  L19_2.id = "bloodwork"
  L19_2.label = "Blood work"
  L19_2.minutes = 20
  L20_2 = {}
  L20_2.id = "xray"
  L20_2.label = "X-ray and scans"
  L20_2.minutes = 45
  L21_2 = {}
  L21_2.id = "physio"
  L21_2.label = "Physiotherapy"
  L21_2.minutes = 60
  L22_2 = {}
  L22_2.id = "fitness"
  L22_2.label = "Fitness certificate"
  L22_2.minutes = 20
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L17_2[4] = L21_2
  L17_2[5] = L22_2
  L16_2.services = L17_2
  L17_2 = {}
  L17_2.from = 9
  L17_2.to = 21
  L16_2.hours = L17_2
  L17_2 = L15_1
  L16_2.days = L17_2
  L16_2.slot = 30
  L16_2.maxPerSlot = 2
  L16_2.notes = true
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
  L12_2 = L12_1
  L13_2 = "ambulance"
  L14_2 = "dispatch"
  L15_2 = "Ambulance"
  L16_2 = "siren"
  L17_2 = {}
  L17_2.location = true
  L17_2.cooldown = 120
  L18_2 = {}
  L19_2 = {}
  L19_2.id = "injured"
  L19_2.label = "Injured person"
  L19_2.icon = "drop"
  L20_2 = {}
  L20_2.id = "unconscious"
  L20_2.label = "Unconscious person"
  L20_2.icon = "eye"
  L21_2 = {}
  L21_2.id = "crash"
  L21_2.label = "Traffic accident"
  L21_2.icon = "car"
  L22_2 = {}
  L22_2.id = "breathing"
  L22_2.label = "Breathing problems"
  L22_2.icon = "heartPulse"
  L23_2 = {}
  L23_2.id = "other"
  L23_2.label = "Other emergency"
  L23_2.icon = "bell"
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L18_2[4] = L22_2
  L18_2[5] = L23_2
  L17_2.types = L18_2
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L13_2 = L12_1
  L14_2 = "charts"
  L15_2 = "records"
  L16_2 = "Medical records"
  L17_2 = "clipboard"
  L18_2 = {}
  L18_2.subject = "person"
  L18_2.civilSeesOwn = true
  L19_2 = L18_1
  L18_2.fields = L19_2
  L19_2 = {}
  L20_2 = {}
  L20_2.id = "allergy"
  L20_2.label = "Allergies"
  L20_2.color = "#E5484D"
  L21_2 = {}
  L21_2.id = "chronic"
  L21_2.label = "Chronic condition"
  L21_2.color = "#F59E0B"
  L22_2 = {}
  L22_2.id = "insured"
  L22_2.label = "Insured"
  L22_2.color = "#10B981"
  L23_2 = {}
  L23_2.id = "donor"
  L23_2.label = "Organ donor"
  L23_2.color = "#A855F7"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L19_2[4] = L23_2
  L18_2.tags = L19_2
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  L14_2 = L12_1
  L15_2 = "billing"
  L16_2 = "billing"
  L17_2 = "Billing"
  L18_2 = "coins"
  L19_2 = {}
  L19_2.society = true
  L19_2.maxAmount = 10000
  L19_2.reasonRequired = true
  L20_2 = {}
  L21_2 = {}
  L21_2.label = "Consultation"
  L21_2.amount = 150
  L22_2 = {}
  L22_2.label = "Wound treatment"
  L22_2.amount = 300
  L23_2 = {}
  L23_2.label = "Ambulance transport"
  L23_2.amount = 400
  L24_2 = {}
  L24_2.label = "X-ray"
  L24_2.amount = 250
  L25_2 = {}
  L25_2.label = "Surgery"
  L25_2.amount = 2500
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L20_2[4] = L24_2
  L20_2[5] = L25_2
  L19_2.presets = L20_2
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L15_2 = L12_1
  L16_2 = "duty"
  L17_2 = "duty"
  L18_2 = "On duty"
  L19_2 = "clock"
  L20_2 = {}
  L20_2.esxOffPrefix = "off"
  L20_2.showTeam = true
  L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L10_2[7] = L17_2
  L10_2[8] = L18_2
  L10_2[9] = L19_2
  L10_2[10] = L20_2
  L10_2[11] = L21_2
  L10_2[12] = L22_2
  L10_2[13] = L23_2
  L10_2[14] = L24_2
  L10_2[15] = L25_2
  L10_2[16] = L26_2
  L10_2[17] = L27_2
  L10_2[18] = L28_2
  L10_2[19] = L29_2
  L10_2[20] = L30_2
  L10_2[21] = L31_2
  L10_2[22] = L32_2
  L10_2[23] = L33_2
  L10_2[24] = L34_2
  L10_2[25] = L35_2
  L9_2.modules = L10_2
  L7_2[L8_2] = L9_2
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L23_1
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = #L8_2
    L15_2 = L15_2 + 1
    L16_2 = {}
    L17_2 = L14_2.id
    L16_2.id = L17_2
    L17_2 = L14_2.label
    L16_2.label = L17_2
    L17_2 = L14_2.desc
    L16_2.desc = L17_2
    L17_2 = "price"
    L18_2 = "price"
    L18_2 = L14_2[L18_2]
    L16_2[L17_2] = L18_2
    L17_2 = "image"
    L18_2 = "image"
    L18_2 = L14_2[L18_2]
    if not L18_2 then
      L18_2 = ""
    end
    L16_2[L17_2] = L18_2
    L17_2 = L14_2.category
    L16_2.category = L17_2
    L17_2 = "available"
    L18_2 = "available"
    L18_2 = L14_2[L18_2]
    L18_2 = false ~= L18_2
    L16_2[L17_2] = L18_2
    L8_2[L15_2] = L16_2
  end
  L9_2 = #L7_2
  L9_2 = L9_2 + 1
  L10_2 = {}
  L11_2 = "burgershot"
  L10_2.id = L11_2
  L11_2 = "Burger Shot"
  L10_2.name = L11_2
  L11_2 = "Del Perro"
  L10_2.subtitle = L11_2
  L11_2 = "Order ahead, track your food and skip the line."
  L10_2.description = L11_2
  L11_2 = {}
  L12_2 = "food"
  L11_2.glyph = L12_2
  L11_2.bg = "#EA580C"
  L12_2 = "#9A3412"
  L11_2.bg2 = L12_2
  L11_2.fg = "#FFFFFF"
  L10_2.icon = L11_2
  L10_2.accent = "#EA580C"
  L10_2.category = L4_2
  L10_2.enabled = true
  L10_2.listed = true
  L10_2.preinstalled = true
  L11_2 = L5_2
  L12_2 = "burgershot"
  L12_2 = A1_2[L12_2]
  L11_2 = L11_2(L12_2)
  L10_2.audience = L11_2
  L11_2 = {}
  L12_2 = "555-0110"
  L11_2.phone = L12_2
  L12_2 = "Burger Shot"
  L11_2.label = L12_2
  L10_2.contact = L11_2
  L11_2 = {}
  L11_2.staff = true
  L10_2.notify = L11_2
  L10_2.webhooks = L6_2
  L11_2 = A0_2.ago
  L12_2 = 7200
  L11_2 = L11_2(L12_2)
  L10_2.created = L11_2
  L11_2 = {}
  L12_2 = L12_1
  L13_2 = "menu"
  L14_2 = "catalog"
  L15_2 = "Menu"
  L16_2 = "food"
  L17_2 = {}
  L18_2 = "Order ahead and skip the line. Pick it up in Del Perro or get it delivered hot."
  L17_2.intro = L18_2
  L18_2 = "orderable"
  L17_2[L18_2] = true
  L17_2.billing = true
  L17_2.location = true
  L18_2 = "maxQty"
  L19_2 = 10
  L17_2[L18_2] = L19_2
  L18_2 = "currency"
  L19_2 = L4_1
  L17_2[L18_2] = L19_2
  L17_2.civilSeesOwn = true
  L17_2.replies = true
  L18_2 = "categories"
  L19_2 = {}
  L20_2 = "Burgers"
  L21_2 = "Sides"
  L22_2 = "Drinks"
  L23_2 = "Desserts"
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L19_2[4] = L23_2
  L17_2[L18_2] = L19_2
  L18_2 = "items"
  L17_2[L18_2] = L8_2
  L18_2 = L19_1
  L17_2.fields = L18_2
  L18_2 = {}
  L19_2 = L10_1
  L20_2 = "received"
  L21_2 = "Received"
  L22_2 = "#5B8CFF"
  L19_2 = L19_2(L20_2, L21_2, L22_2)
  L20_2 = L10_1
  L21_2 = "preparing"
  L22_2 = "Preparing"
  L23_2 = "#F5A524"
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L21_2 = L10_1
  L22_2 = "ready"
  L23_2 = "Ready for pickup"
  L24_2 = "#10B981"
  L21_2 = L21_2(L22_2, L23_2, L24_2)
  L22_2 = L10_1
  L23_2 = "onway"
  L24_2 = "On the way"
  L25_2 = "#0EA5E9"
  L22_2 = L22_2(L23_2, L24_2, L25_2)
  L23_2 = L10_1
  L24_2 = "delivered"
  L25_2 = "Delivered"
  L26_2 = "#8A8F98"
  L27_2 = true
  L28_2 = false
  L23_2 = L23_2(L24_2, L25_2, L26_2, L27_2, L28_2)
  L24_2 = L10_1
  L25_2 = "cancelled"
  L26_2 = "Cancelled"
  L27_2 = "#E5484D"
  L28_2 = true
  L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L24_2(L25_2, L26_2, L27_2, L28_2)
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L18_2[4] = L22_2
  L18_2[5] = L23_2
  L18_2[6] = L24_2
  L18_2[7] = L25_2
  L18_2[8] = L26_2
  L18_2[9] = L27_2
  L18_2[10] = L28_2
  L18_2[11] = L29_2
  L18_2[12] = L30_2
  L18_2[13] = L31_2
  L18_2[14] = L32_2
  L18_2[15] = L33_2
  L18_2[16] = L34_2
  L18_2[17] = L35_2
  L17_2.statuses = L18_2
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L13_2 = L12_1
  L14_2 = "billing"
  L15_2 = "billing"
  L16_2 = "Billing"
  L17_2 = "coins"
  L18_2 = {}
  L18_2.society = true
  L18_2.maxAmount = 5000
  L18_2.reasonRequired = true
  L19_2 = {}
  L20_2 = {}
  L21_2 = "Combo meal"
  L20_2.label = L21_2
  L21_2 = 15
  L20_2.amount = L21_2
  L21_2 = {}
  L22_2 = "Party box"
  L21_2.label = L22_2
  L21_2.amount = 45
  L22_2 = {}
  L23_2 = "Catering service"
  L22_2.label = L23_2
  L23_2 = 500
  L22_2.amount = L23_2
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L18_2.presets = L19_2
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  L14_2 = L12_1
  L15_2 = "duty"
  L16_2 = "duty"
  L17_2 = "On duty"
  L18_2 = "clock"
  L19_2 = {}
  L19_2.esxOffPrefix = "off"
  L19_2.showTeam = true
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L15_2 = L12_1
  L16_2 = "about"
  L17_2 = "info"
  L18_2 = "About"
  L19_2 = "info"
  L20_2 = {}
  L21_2 = L22_1
  L22_2 = "burger/burger9.jpg"
  L21_2 = L21_2 .. L22_2
  L20_2.hero = L21_2
  L21_2 = {}
  L22_2 = {}
  L22_2.type = "text"
  L23_2 = "Our story"
  L22_2.title = L23_2
  L23_2 = "Flame grilled burgers in Del Perro since 1998. Fresh beef, soft buns and the famous Shot Sauce."
  L22_2.text = L23_2
  L23_2 = {}
  L23_2.type = "hours"
  L24_2 = "Opening hours"
  L23_2.title = L24_2
  L24_2 = "Kitchen closes 30 minutes before closing time."
  L23_2.text = L24_2
  L24_2 = {}
  L25_2 = 11
  L24_2.from = L25_2
  L24_2.to = 24
  L25_2 = L14_1
  L24_2.days = L25_2
  L23_2.hours = L24_2
  L24_2 = {}
  L24_2.type = "location"
  L25_2 = "Burger Shot Del Perro"
  L24_2.title = L25_2
  L25_2 = "Prosperity Street, Del Perro"
  L24_2.text = L25_2
  L25_2 = -1183.5
  L24_2.x = L25_2
  L25_2 = -884.1
  L24_2.y = L25_2
  L25_2 = {}
  L25_2.type = "contact"
  L26_2 = "Order by phone"
  L25_2.title = L26_2
  L26_2 = "Ask for Leo."
  L25_2.text = L26_2
  L26_2 = "555-0110"
  L25_2.phone = L26_2
  L26_2 = {}
  L27_2 = "image"
  L26_2.type = L27_2
  L27_2 = "Fresh donuts every morning"
  L26_2.title = L27_2
  L27_2 = L22_1
  L28_2 = "dessert/dessert19.jpg"
  L27_2 = L27_2 .. L28_2
  L26_2.url = L27_2
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L21_2[4] = L25_2
  L21_2[5] = L26_2
  L20_2.blocks = L21_2
  L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L11_2[8] = L19_2
  L11_2[9] = L20_2
  L11_2[10] = L21_2
  L11_2[11] = L22_2
  L11_2[12] = L23_2
  L11_2[13] = L24_2
  L11_2[14] = L25_2
  L11_2[15] = L26_2
  L11_2[16] = L27_2
  L11_2[17] = L28_2
  L11_2[18] = L29_2
  L11_2[19] = L30_2
  L11_2[20] = L31_2
  L11_2[21] = L32_2
  L11_2[22] = L33_2
  L11_2[23] = L34_2
  L11_2[24] = L35_2
  L10_2.modules = L11_2
  L7_2[L9_2] = L10_2
  L9_2 = #L7_2
  L9_2 = L9_2 + 1
  L10_2 = {}
  L11_2 = "bennys"
  L10_2.id = L11_2
  L11_2 = "Benny's"
  L10_2.name = L11_2
  L11_2 = "Original Motor Works"
  L10_2.subtitle = L11_2
  L11_2 = "Price list, workshop bookings, your car history and towing around the clock."
  L10_2.description = L11_2
  L11_2 = {}
  L12_2 = "wrench"
  L11_2.glyph = L12_2
  L11_2.bg = "#F59E0B"
  L12_2 = "#92400E"
  L11_2.bg2 = L12_2
  L11_2.fg = "#FFFFFF"
  L10_2.icon = L11_2
  L10_2.accent = "#F59E0B"
  L10_2.category = L4_2
  L10_2.enabled = true
  L10_2.listed = true
  L10_2.preinstalled = true
  L11_2 = L5_2
  L12_2 = "bennys"
  L12_2 = A1_2[L12_2]
  L11_2 = L11_2(L12_2)
  L10_2.audience = L11_2
  L11_2 = {}
  L12_2 = "555-0104"
  L11_2.phone = L12_2
  L12_2 = "Benny's workshop"
  L11_2.label = L12_2
  L10_2.contact = L11_2
  L11_2 = {}
  L11_2.staff = true
  L10_2.notify = L11_2
  L10_2.webhooks = L6_2
  L11_2 = A0_2.ago
  L12_2 = 7155
  L11_2 = L11_2(L12_2)
  L10_2.created = L11_2
  L11_2 = {}
  L12_2 = L12_1
  L13_2 = "tow"
  L14_2 = "dispatch"
  L15_2 = "Tow truck"
  L16_2 = "towTruck"
  L17_2 = {}
  L17_2.location = true
  L17_2.cooldown = 120
  L18_2 = {}
  L19_2 = {}
  L20_2 = "tow"
  L19_2.id = L20_2
  L20_2 = "Tow truck"
  L19_2.label = L20_2
  L20_2 = "towTruck"
  L19_2.icon = L20_2
  L20_2 = {}
  L21_2 = "repair"
  L20_2.id = L21_2
  L21_2 = "Roadside repair"
  L20_2.label = L21_2
  L21_2 = "wrench"
  L20_2.icon = L21_2
  L21_2 = {}
  L22_2 = "tire"
  L21_2.id = L22_2
  L22_2 = "Flat tire"
  L21_2.label = L22_2
  L22_2 = "lifebuoy"
  L21_2.icon = L22_2
  L22_2 = {}
  L23_2 = "fuel"
  L22_2.id = L23_2
  L23_2 = "Out of fuel"
  L22_2.label = L23_2
  L23_2 = "fuel"
  L22_2.icon = L23_2
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L18_2[4] = L22_2
  L17_2.types = L18_2
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L13_2 = L12_1
  L14_2 = "booking"
  L15_2 = "appointments"
  L16_2 = "Bookings"
  L17_2 = "calendar"
  L18_2 = {}
  L19_2 = {}
  L20_2 = {}
  L21_2 = "service"
  L20_2.id = L21_2
  L21_2 = "Full service"
  L20_2.label = L21_2
  L20_2.minutes = 60
  L21_2 = {}
  L22_2 = "diag"
  L21_2.id = L22_2
  L22_2 = "Diagnostics"
  L21_2.label = L22_2
  L21_2.minutes = 30
  L22_2 = {}
  L23_2 = "respray"
  L22_2.id = L23_2
  L23_2 = "Respray"
  L22_2.label = L23_2
  L22_2.minutes = 120
  L23_2 = {}
  L24_2 = "tuning"
  L23_2.id = L24_2
  L24_2 = "Performance tuning"
  L23_2.label = L24_2
  L23_2.minutes = 120
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L19_2[4] = L23_2
  L18_2.services = L19_2
  L19_2 = {}
  L20_2 = 10
  L19_2.from = L20_2
  L19_2.to = 20
  L18_2.hours = L19_2
  L19_2 = L15_1
  L18_2.days = L19_2
  L18_2.slot = 30
  L18_2.maxPerSlot = 2
  L18_2.notes = true
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  L14_2 = L12_1
  L15_2 = "prices"
  L16_2 = "catalog"
  L17_2 = "Price list"
  L18_2 = "tag"
  L19_2 = {}
  L20_2 = "Prices include parts and labor. Final price confirmed after inspection."
  L19_2.intro = L20_2
  L20_2 = "orderable"
  L19_2[L20_2] = false
  L19_2.billing = false
  L20_2 = {}
  L21_2 = L10_1
  L22_2 = "received"
  L23_2 = "Received"
  L24_2 = "#5B8CFF"
  L21_2 = L21_2(L22_2, L23_2, L24_2)
  L22_2 = L10_1
  L23_2 = "workshop"
  L24_2 = "In the workshop"
  L25_2 = "#F5A524"
  L22_2 = L22_2(L23_2, L24_2, L25_2)
  L23_2 = L10_1
  L24_2 = "ready"
  L25_2 = "Ready"
  L26_2 = "#10B981"
  L23_2 = L23_2(L24_2, L25_2, L26_2)
  L24_2 = L10_1
  L25_2 = "collected"
  L26_2 = "Collected"
  L27_2 = "#8A8F98"
  L28_2 = true
  L29_2 = false
  L24_2 = L24_2(L25_2, L26_2, L27_2, L28_2, L29_2)
  L25_2 = L10_1
  L26_2 = "cancelled"
  L27_2 = "Cancelled"
  L28_2 = "#E5484D"
  L29_2 = true
  L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L25_2(L26_2, L27_2, L28_2, L29_2)
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L20_2[4] = L24_2
  L20_2[5] = L25_2
  L20_2[6] = L26_2
  L20_2[7] = L27_2
  L20_2[8] = L28_2
  L20_2[9] = L29_2
  L20_2[10] = L30_2
  L20_2[11] = L31_2
  L20_2[12] = L32_2
  L20_2[13] = L33_2
  L20_2[14] = L34_2
  L20_2[15] = L35_2
  L19_2.statuses = L20_2
  L20_2 = "currency"
  L21_2 = L4_1
  L19_2[L20_2] = L21_2
  L20_2 = "categories"
  L21_2 = {}
  L22_2 = "Maintenance"
  L23_2 = "Repairs"
  L24_2 = "Custom"
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L19_2[L20_2] = L21_2
  L20_2 = "items"
  L21_2 = {}
  L22_2 = {}
  L23_2 = "oil"
  L22_2.id = L23_2
  L23_2 = "Oil change"
  L22_2.label = L23_2
  L23_2 = "price"
  L22_2[L23_2] = 120
  L23_2 = "Maintenance"
  L22_2.category = L23_2
  L23_2 = "Synthetic oil and a new filter."
  L22_2.desc = L23_2
  L23_2 = {}
  L24_2 = "brakes"
  L23_2.id = L24_2
  L24_2 = "Brake job"
  L23_2.label = L24_2
  L24_2 = "price"
  L25_2 = 340
  L23_2[L24_2] = L25_2
  L24_2 = "Maintenance"
  L23_2.category = L24_2
  L24_2 = "Pads and discs, front axle."
  L23_2.desc = L24_2
  L24_2 = {}
  L25_2 = "tires"
  L24_2.id = L25_2
  L25_2 = "Set of 4 tires"
  L24_2.label = L25_2
  L25_2 = "price"
  L26_2 = 600
  L24_2[L25_2] = L26_2
  L25_2 = "Maintenance"
  L24_2.category = L25_2
  L25_2 = "Fitted and balanced."
  L24_2.desc = L25_2
  L25_2 = {}
  L26_2 = "diag"
  L25_2.id = L26_2
  L26_2 = "Diagnostics"
  L25_2.label = L26_2
  L26_2 = "price"
  L27_2 = 80
  L25_2[L26_2] = L27_2
  L26_2 = "Maintenance"
  L25_2.category = L26_2
  L26_2 = "Full computer scan and a test drive."
  L25_2.desc = L26_2
  L26_2 = {}
  L27_2 = "engine"
  L26_2.id = L27_2
  L27_2 = "Engine repair"
  L26_2.label = L27_2
  L27_2 = "price"
  L28_2 = 900
  L26_2[L27_2] = L28_2
  L27_2 = "Repairs"
  L26_2.category = L27_2
  L27_2 = "Starting price, quote after inspection."
  L26_2.desc = L27_2
  L27_2 = {}
  L28_2 = "body"
  L27_2.id = L28_2
  L28_2 = "Bodywork"
  L27_2.label = L28_2
  L28_2 = "price"
  L29_2 = 450
  L27_2[L28_2] = L29_2
  L28_2 = "Repairs"
  L27_2.category = L28_2
  L28_2 = "Dents, scratches and bumpers."
  L27_2.desc = L28_2
  L28_2 = {}
  L29_2 = "glass"
  L28_2.id = L29_2
  L29_2 = "Windshield"
  L28_2.label = L29_2
  L29_2 = "price"
  L30_2 = 220
  L28_2[L29_2] = L30_2
  L29_2 = "Repairs"
  L28_2.category = L29_2
  L29_2 = {}
  L30_2 = "respray"
  L29_2.id = L30_2
  L30_2 = "Full respray"
  L29_2.label = L30_2
  L30_2 = "price"
  L31_2 = 1500
  L29_2[L30_2] = L31_2
  L30_2 = "Custom"
  L29_2.category = L30_2
  L30_2 = "Any color, metallic, matte or pearl."
  L29_2.desc = L30_2
  L30_2 = {}
  L31_2 = "tint"
  L30_2.id = L31_2
  L31_2 = "Window tint"
  L30_2.label = L31_2
  L31_2 = "price"
  L32_2 = 260
  L30_2[L31_2] = L32_2
  L31_2 = "Custom"
  L30_2.category = L31_2
  L31_2 = {}
  L32_2 = "turbo"
  L31_2.id = L32_2
  L32_2 = "Turbo kit"
  L31_2.label = L32_2
  L32_2 = "price"
  L33_2 = 4500
  L31_2[L32_2] = L33_2
  L32_2 = "Custom"
  L31_2.category = L32_2
  L32_2 = "Install and dyno tune."
  L31_2.desc = L32_2
  L32_2 = {}
  L33_2 = "lowering"
  L32_2.id = L33_2
  L33_2 = "Lowering kit"
  L32_2.label = L33_2
  L33_2 = "price"
  L34_2 = 800
  L32_2[L33_2] = L34_2
  L33_2 = "Custom"
  L32_2.category = L33_2
  L33_2 = {}
  L34_2 = "neon"
  L33_2.id = L34_2
  L34_2 = "Underglow neon"
  L33_2.label = L34_2
  L34_2 = "price"
  L35_2 = 350
  L33_2[L34_2] = L35_2
  L34_2 = "Custom"
  L33_2.category = L34_2
  L34_2 = "Pick your color."
  L33_2.desc = L34_2
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L21_2[4] = L25_2
  L21_2[5] = L26_2
  L21_2[6] = L27_2
  L21_2[7] = L28_2
  L21_2[8] = L29_2
  L21_2[9] = L30_2
  L21_2[10] = L31_2
  L21_2[11] = L32_2
  L21_2[12] = L33_2
  L19_2[L20_2] = L21_2
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L15_2 = L12_1
  L16_2 = "history"
  L17_2 = "records"
  L18_2 = "Vehicle history"
  L19_2 = "car"
  L20_2 = {}
  L21_2 = "vehicle"
  L20_2.subject = L21_2
  L20_2.civilSeesOwn = false
  L21_2 = L20_1
  L20_2.fields = L21_2
  L21_2 = {}
  L22_2 = {}
  L23_2 = "warranty"
  L22_2.id = L23_2
  L23_2 = "Under warranty"
  L22_2.label = L23_2
  L22_2.color = "#10B981"
  L23_2 = {}
  L24_2 = "unpaid"
  L23_2.id = L24_2
  L24_2 = "Unpaid"
  L23_2.label = L24_2
  L23_2.color = "#E5484D"
  L24_2 = {}
  L25_2 = "vip"
  L24_2.id = L25_2
  L25_2 = "VIP client"
  L24_2.label = L25_2
  L25_2 = "#EAB308"
  L24_2.color = L25_2
  L21_2[1] = L22_2
  L21_2[2] = L23_2
  L21_2[3] = L24_2
  L20_2.tags = L21_2
  L21_2 = {}
  L21_2.civil = false
  L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L11_2[8] = L19_2
  L11_2[9] = L20_2
  L11_2[10] = L21_2
  L11_2[11] = L22_2
  L11_2[12] = L23_2
  L11_2[13] = L24_2
  L11_2[14] = L25_2
  L11_2[15] = L26_2
  L11_2[16] = L27_2
  L11_2[17] = L28_2
  L11_2[18] = L29_2
  L11_2[19] = L30_2
  L11_2[20] = L31_2
  L11_2[21] = L32_2
  L11_2[22] = L33_2
  L11_2[23] = L34_2
  L11_2[24] = L35_2
  L10_2.modules = L11_2
  L7_2[L9_2] = L10_2
  L9_2 = #L7_2
  L9_2 = L9_2 + 1
  L10_2 = {}
  L11_2 = "weazel"
  L10_2.id = L11_2
  L11_2 = "Weazel News"
  L10_2.name = L11_2
  L11_2 = "Los Santos news, 24/7"
  L10_2.subtitle = L11_2
  L11_2 = "Breaking news from all over San Andreas, and a direct line to our newsroom."
  L10_2.description = L11_2
  L11_2 = {}
  L12_2 = "newspaper"
  L11_2.glyph = L12_2
  L12_2 = "#DC2626"
  L11_2.bg = L12_2
  L12_2 = "#7F1D1D"
  L11_2.bg2 = L12_2
  L11_2.fg = "#FFFFFF"
  L10_2.icon = L11_2
  L11_2 = "#DC2626"
  L10_2.accent = L11_2
  L10_2.category = L4_2
  L10_2.enabled = true
  L10_2.listed = true
  L10_2.preinstalled = true
  L11_2 = L5_2
  L12_2 = "weazel"
  L12_2 = A1_2[L12_2]
  L11_2 = L11_2(L12_2)
  L10_2.audience = L11_2
  L11_2 = {}
  L12_2 = "555-0109"
  L11_2.phone = L12_2
  L12_2 = "Newsroom"
  L11_2.label = L12_2
  L10_2.contact = L11_2
  L11_2 = {}
  L11_2.staff = true
  L10_2.notify = L11_2
  L10_2.webhooks = L6_2
  L11_2 = A0_2.ago
  L12_2 = 5760
  L11_2 = L11_2(L12_2)
  L10_2.created = L11_2
  L11_2 = {}
  L12_2 = L12_1
  L13_2 = "news"
  L14_2 = "posts"
  L15_2 = "News"
  L16_2 = "newspaper"
  L17_2 = {}
  L17_2.postGrade = 0
  L17_2.notifyAll = false
  L17_2.audience = "all"
  L17_2.pinLimit = 2
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L13_2 = L12_1
  L14_2 = "tips"
  L15_2 = "form"
  L16_2 = "Send a tip"
  L17_2 = "send"
  L18_2 = {}
  L19_2 = "Saw something? Tell the newsroom. You can stay anonymous."
  L18_2.intro = L19_2
  L19_2 = "Send tip"
  L18_2.submitLabel = L19_2
  L18_2.anonymous = true
  L18_2.location = true
  L18_2.photo = true
  L18_2.civilSeesOwn = true
  L18_2.replies = true
  L19_2 = 1
  L18_2.deleteGrade = L19_2
  L19_2 = L21_1
  L18_2.fields = L19_2
  L19_2 = {}
  L20_2 = L10_1
  L21_2 = "received"
  L22_2 = "Received"
  L23_2 = "#5B8CFF"
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L21_2 = L10_1
  L22_2 = "review"
  L23_2 = "Under review"
  L24_2 = "#F5A524"
  L21_2 = L21_2(L22_2, L23_2, L24_2)
  L22_2 = L10_1
  L23_2 = "published"
  L24_2 = "Published"
  L25_2 = "#10B981"
  L26_2 = true
  L22_2 = L22_2(L23_2, L24_2, L25_2, L26_2)
  L23_2 = L10_1
  L24_2 = "dismissed"
  L25_2 = "Dismissed"
  L26_2 = "#8A8F98"
  L27_2 = true
  L28_2 = false
  L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L23_2(L24_2, L25_2, L26_2, L27_2, L28_2)
  L19_2[1] = L20_2
  L19_2[2] = L21_2
  L19_2[3] = L22_2
  L19_2[4] = L23_2
  L19_2[5] = L24_2
  L19_2[6] = L25_2
  L19_2[7] = L26_2
  L19_2[8] = L27_2
  L19_2[9] = L28_2
  L19_2[10] = L29_2
  L19_2[11] = L30_2
  L19_2[12] = L31_2
  L19_2[13] = L32_2
  L19_2[14] = L33_2
  L19_2[15] = L34_2
  L19_2[16] = L35_2
  L18_2.statuses = L19_2
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  L14_2 = L12_1
  L15_2 = "about"
  L16_2 = "info"
  L17_2 = "About"
  L18_2 = "info"
  L19_2 = {}
  L20_2 = A0_2.img
  L21_2 = "weazelnewsroom"
  L22_2 = 1080
  L23_2 = 600
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L19_2.hero = L20_2
  L20_2 = {}
  L21_2 = {}
  L21_2.type = "text"
  L22_2 = "Who we are"
  L21_2.title = L22_2
  L22_2 = "Weazel News has covered Los Santos for over 30 years. Breaking news, traffic, weather and the stories that matter to you."
  L21_2.text = L22_2
  L22_2 = {}
  L22_2.type = "hours"
  L23_2 = "Newsroom"
  L22_2.title = L23_2
  L23_2 = "Live on air every day."
  L22_2.text = L23_2
  L23_2 = {}
  L23_2.from = 0
  L23_2.to = 24
  L24_2 = L14_1
  L23_2.days = L24_2
  L22_2.hours = L23_2
  L23_2 = {}
  L23_2.type = "location"
  L24_2 = "Weazel News Plaza"
  L23_2.title = L24_2
  L24_2 = "Little Seoul, Los Santos"
  L23_2.text = L24_2
  L24_2 = -598.6
  L23_2.x = L24_2
  L24_2 = -929.9
  L23_2.y = L24_2
  L24_2 = {}
  L24_2.type = "contact"
  L25_2 = "Newsroom hotline"
  L24_2.title = L25_2
  L25_2 = "Breaking news? Call us."
  L24_2.text = L25_2
  L25_2 = "555-0109"
  L24_2.phone = L25_2
  L20_2[1] = L21_2
  L20_2[2] = L22_2
  L20_2[3] = L23_2
  L20_2[4] = L24_2
  L19_2.blocks = L20_2
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L11_2[8] = L19_2
  L11_2[9] = L20_2
  L11_2[10] = L21_2
  L11_2[11] = L22_2
  L11_2[12] = L23_2
  L11_2[13] = L24_2
  L11_2[14] = L25_2
  L11_2[15] = L26_2
  L11_2[16] = L27_2
  L11_2[17] = L28_2
  L11_2[18] = L29_2
  L11_2[19] = L30_2
  L11_2[20] = L31_2
  L11_2[21] = L32_2
  L11_2[22] = L33_2
  L11_2[23] = L34_2
  L11_2[24] = L35_2
  L10_2.modules = L11_2
  L7_2[L9_2] = L10_2
  return L7_2
end
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L1_2 = {}
  L2_2 = FW
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.GetJobsList
    if L2_2 then
      L2_2 = pcall
      L3_2 = FW
      L3_2 = L3_2.GetJobsList
      L2_2, L3_2 = L2_2(L3_2)
      if L2_2 then
        L4_2 = type
        L5_2 = L3_2
        L4_2 = L4_2(L5_2)
        if "table" == L4_2 then
          L4_2 = ipairs
          L5_2 = L3_2
          L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
          for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
            L10_2 = type
            L11_2 = L9_2
            L10_2 = L10_2(L11_2)
            if "table" == L10_2 then
              L10_2 = type
              L11_2 = L9_2.name
              L10_2 = L10_2(L11_2)
              if "string" == L10_2 then
                L10_2 = L9_2.name
                L1_2[L10_2] = true
              end
            end
          end
        end
      end
    end
  end
  L2_2 = nil
  L3_2 = pcall
  L4_2 = FW
  L4_2 = L4_2.GetPlayer
  L5_2 = A0_2.src
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  if L3_2 and L4_2 then
    L5_2 = L4_2.job
    if L5_2 then
      L5_2 = type
      L6_2 = L4_2.job
      L6_2 = L6_2.name
      L5_2 = L5_2(L6_2)
      if "string" == L5_2 then
        L5_2 = L4_2.job
        L2_2 = L5_2.name
      end
    end
  end
  L5_2 = {}
  L6_2 = pairs
  L7_2 = L6_1
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = {}
    L13_2 = {}
    L14_2 = nil
    L15_2 = ipairs
    L16_2 = L11_2
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
      if L2_2 ~= L20_2 then
        if not L2_2 then
          goto lbl_86
        end
        L21_2 = "off"
        L22_2 = L20_2
        L21_2 = L21_2 .. L22_2
        if L2_2 ~= L21_2 then
          goto lbl_86
        end
      end
      L14_2 = L20_2
      ::lbl_86::
    end
    L15_2 = ipairs
    L16_2 = L11_2
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
      L21_2 = L1_2[L20_2]
      if L21_2 or L20_2 == L14_2 then
        L21_2 = L13_2[L20_2]
        if not L21_2 then
          L13_2[L20_2] = true
          L21_2 = #L12_2
          L21_2 = L21_2 + 1
          L12_2[L21_2] = L20_2
        end
      end
    end
    L15_2 = #L12_2
    if 0 == L15_2 then
      L15_2 = L11_2[1]
      L12_2[1] = L15_2
    end
    L5_2[L10_2] = L12_2
  end
  L6_2 = L5_2
  L7_2 = L2_2
  return L6_2, L7_2
end
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = AdminStore
  L2_2 = L2_2.Get
  L3_2 = "capps"
  L2_2 = L2_2(L3_2)
  L3_2 = L7_1
  L4_2 = L9_1
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = A1_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.id
    L4_2[L12_2] = true
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L13_2 = L11_2.id
    L5_2[L12_2] = L13_2
  end
  L6_2 = {}
  L7_2 = {}
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L3_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = type
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    if "table" == L15_2 then
      L15_2 = L14_2.id
      if L15_2 then
        L15_2 = L14_2.id
        L8_2[L15_2] = true
      end
    end
  end
  L9_2 = ipairs
  L10_2 = L5_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L8_2[L14_2]
    if not L15_2 then
      L15_2 = #L7_2
      L15_2 = L15_2 + 1
      L7_2[L15_2] = L14_2
    end
  end
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = A1_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = L15_2
  end
  L10_2 = ipairs
  L11_2 = L3_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = type
    L17_2 = L15_2
    L16_2 = L16_2(L17_2)
    if "table" == L16_2 then
      L16_2 = L15_2.id
      if L16_2 then
        L16_2 = L15_2.id
        L16_2 = L4_2[L16_2]
        if not L16_2 then
          L16_2 = L7_1
          L17_2 = L15_2
          L16_2 = L16_2(L17_2)
          L17_2 = L1_1
          if L17_2 then
            L17_2 = L16_2.enabled
            if false ~= L17_2 then
              L16_2.enabled = false
              L17_2 = #L6_2
              L17_2 = L17_2 + 1
              L18_2 = L15_2.id
              L6_2[L17_2] = L18_2
            end
          end
          L17_2 = #L9_2
          L17_2 = L17_2 + 1
          L9_2[L17_2] = L16_2
        end
      end
    end
  end
  L10_2 = AdminStore
  L10_2 = L10_2.Get
  L11_2 = L0_1
  L10_2 = L10_2(L11_2)
  if nil == L10_2 then
    L10_2 = AdminStore
    L10_2 = L10_2.Set
    L11_2 = L0_1
    L12_2 = {}
    L13_2 = nil ~= L2_2
    L12_2.had = L13_2
    L12_2.apps = L3_2
    L12_2.mine = L5_2
    L12_2.hidden = L6_2
    L12_2.added = L7_2
    L13_2 = A0_2.now
    L12_2.at = L13_2
    L13_2 = A0_2.src
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    if not L10_2 then
      L11_2 = error
      L12_2 = "could not save the capps backup"
      L11_2(L12_2)
    end
  end
  L10_2 = AdminStore
  L10_2 = L10_2.Set
  L11_2 = "capps"
  L12_2 = {}
  L12_2.apps = L9_2
  L13_2 = A0_2.src
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  if not L10_2 then
    L10_2 = error
    L11_2 = "could not save the showcase apps"
    L10_2(L11_2)
  end
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = AdminStore
  L1_2 = L1_2.Get
  L2_2 = L0_1
  L1_2 = L1_2(L2_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return
  end
  L2_2 = type
  L3_2 = L1_2.apps
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L1_2.apps
    if L2_2 then
      goto lbl_21
    end
  end
  L2_2 = {}
  ::lbl_21::
  L3_2 = L8_1
  L4_2 = L1_2.mine
  L3_2 = L3_2(L4_2)
  L4_2 = L8_1
  L5_2 = L1_2.hidden
  L4_2 = L4_2(L5_2)
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = L12_2.id
      if L13_2 then
        L13_2 = L12_2.id
        L5_2[L13_2] = L12_2
        L13_2 = L12_2.id
        L6_2[L13_2] = L11_2
      end
    end
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L9_1
  L10_2 = AdminStore
  L10_2 = L10_2.Get
  L11_2 = "capps"
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L10_2(L11_2)
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = type
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = L13_2.id
      if L14_2 then
        L14_2 = L13_2.id
        L14_2 = L3_2[L14_2]
        if not L14_2 then
          L14_2 = L13_2.id
          L14_2 = L4_2[L14_2]
          if L14_2 then
            L14_2 = L13_2.id
            L14_2 = L5_2[L14_2]
            if L14_2 then
              L14_2 = #L7_2
              L14_2 = L14_2 + 1
              L15_2 = L13_2.id
              L15_2 = L5_2[L15_2]
              L7_2[L14_2] = L15_2
          end
          else
            L14_2 = #L7_2
            L14_2 = L14_2 + 1
            L7_2[L14_2] = L13_2
          end
        end
      end
    end
  end
  L8_2 = ipairs
  L9_2 = L2_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = type
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = L13_2.id
      if L14_2 then
        L14_2 = L13_2.id
        L14_2 = L3_2[L14_2]
        if L14_2 then
          L14_2 = table
          L14_2 = L14_2.insert
          L15_2 = L7_2
          L16_2 = math
          L16_2 = L16_2.min
          L17_2 = L13_2.id
          L17_2 = L6_2[L17_2]
          L18_2 = #L7_2
          L18_2 = L18_2 + 1
          L16_2 = L16_2(L17_2, L18_2)
          L17_2 = L13_2
          L14_2(L15_2, L16_2, L17_2)
        end
      end
    end
  end
  L8_2 = nil
  L9_2 = #L7_2
  if 0 == L9_2 then
    L9_2 = L1_2.had
    if true ~= L9_2 then
      L9_2 = AdminStore
      L9_2 = L9_2.Set
      L10_2 = "capps"
      L11_2 = nil
      L12_2 = A0_2.src
      L9_2 = L9_2(L10_2, L11_2, L12_2)
      L8_2 = L9_2
  end
  else
    L9_2 = AdminStore
    L9_2 = L9_2.Set
    L10_2 = "capps"
    L11_2 = {}
    L11_2.apps = L7_2
    L12_2 = A0_2.src
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L8_2 = L9_2
  end
  if L8_2 then
    L9_2 = AdminStore
    L9_2 = L9_2.Set
    L10_2 = L0_1
    L11_2 = nil
    L12_2 = A0_2.src
    L9_2(L10_2, L11_2, L12_2)
  else
    L9_2 = print
    L10_2 = "^1[apex_phone showcase]^0 jobs: capps restore failed, backup kept"
    L9_2(L10_2)
  end
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if "me" == A1_2 then
    L2_2 = A0_2.cid
    L3_2 = A0_2.name
    if "" ~= L3_2 then
      L3_2 = A0_2.name
      if L3_2 then
        goto lbl_11
      end
    end
    L3_2 = A0_2.username
    ::lbl_11::
    L4_2 = A0_2.number
    return L2_2, L3_2, L4_2
  end
  L2_2 = Showcase
  L2_2 = L2_2.byKey
  L2_2 = L2_2[A1_2]
  L3_2 = L2_2.cid
  L4_2 = L2_2.name
  L5_2 = L2_2.phone
  return L3_2, L4_2, L5_2
end
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = {}
  L3_2 = A1_2.app
  L2_2.app = L3_2
  L3_2 = A1_2.module
  L2_2.module = L3_2
  L3_2 = A1_2.kind
  L2_2.kind = L3_2
  L3_2 = A1_2.status
  L2_2.status = L3_2
  L3_2 = A1_2.title
  L2_2.title = L3_2
  L3_2 = A1_2.subject
  L2_2.subject = L3_2
  L3_2 = A1_2.data
  L2_2.data = L3_2
  L3_2 = A1_2.anon
  if L3_2 then
    L3_2 = 1
    if L3_2 then
      goto lbl_24
    end
  end
  L3_2 = 0
  ::lbl_24::
  L2_2.anonymous = L3_2
  L3_2 = A1_2.pinned
  if L3_2 then
    L3_2 = 1
    if L3_2 then
      goto lbl_32
    end
  end
  L3_2 = 0
  ::lbl_32::
  L2_2.pinned = L3_2
  L3_2 = A1_2.x
  L2_2.x = L3_2
  L3_2 = A1_2.y
  L2_2.y = L3_2
  L3_2 = A1_2.z
  L2_2.z = L3_2
  L3_2 = A1_2.at
  L2_2.at = L3_2
  L3_2 = A0_2.ago
  L4_2 = A1_2.ago
  L3_2 = L3_2(L4_2)
  L2_2.created = L3_2
  L3_2 = A0_2.ago
  L4_2 = A1_2.upd
  if not L4_2 then
    L4_2 = A1_2.ago
  end
  L3_2 = L3_2(L4_2)
  L2_2.updated = L3_2
  L3_2 = A1_2.owner
  if L3_2 then
    L3_2 = L29_1
    L4_2 = A0_2
    L5_2 = A1_2.owner
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L2_2.owner = L3_2
    L6_2 = A1_2.anon
    if not L6_2 then
      L6_2 = A1_2.ownerName
      if not L6_2 then
        L6_2 = L4_2
      end
      L2_2.owner_name = L6_2
      L2_2.owner_phone = L5_2
    end
  end
  L3_2 = A1_2.as
  if L3_2 then
    L3_2 = L29_1
    L4_2 = A0_2
    L5_2 = A1_2.as
    L3_2, L4_2 = L3_2(L4_2, L5_2)
    L5_2 = L3_2
    L2_2.assignee_name = L4_2
    L2_2.assignee = L5_2
  end
  L3_2 = A0_2.insert
  L4_2 = L2_1
  L5_2 = L2_2
  return L3_2(L4_2, L5_2)
end
function L31_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  if not A1_2 then
    return
  end
  L7_2 = L29_1
  L8_2 = A0_2
  L9_2 = A2_2
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  L9_2 = A0_2.insert
  L10_2 = L3_1
  L11_2 = {}
  L11_2.item = A1_2
  L11_2.author = L7_2
  L11_2.author_name = L8_2
  if A5_2 then
    L12_2 = 1
    if L12_2 then
      goto lbl_21
    end
  end
  L12_2 = 0
  ::lbl_21::
  L11_2.staff = L12_2
  if A6_2 then
    L12_2 = 1
    if L12_2 then
      goto lbl_28
    end
  end
  L12_2 = 0
  ::lbl_28::
  L11_2.private = L12_2
  L11_2.text = A4_2
  L12_2 = A0_2.ago
  L13_2 = A3_2
  L12_2 = L12_2(L13_2)
  L11_2.created = L12_2
  L9_2(L10_2, L11_2)
end
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = os
  L2_2 = L2_2.date
  L3_2 = "%Y-%m-%d"
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = A0_2.now
  L5_2 = L5_2 / 1000
  L4_2 = L4_2(L5_2)
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = A1_2 * 86400
  L5_2 = L5_2(L6_2)
  L4_2 = L4_2 + L5_2
  return L2_2(L3_2, L4_2)
end
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = os
  L2_2 = L2_2.date
  L3_2 = "%H:%M"
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = A0_2.now
  L6_2 = A1_2 * 60000
  L5_2 = L5_2 - L6_2
  L5_2 = L5_2 / 1000
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L34_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L5_2 = L8_1
  L6_2 = A4_2
  L5_2 = L5_2(L6_2)
  L6_2 = os
  L6_2 = L6_2.date
  L7_2 = "*t"
  L8_2 = math
  L8_2 = L8_2.floor
  L9_2 = A0_2.now
  L9_2 = L9_2 / 1000
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  if A1_2 < 0 then
    L7_2 = -1
    if L7_2 then
      goto lbl_20
    end
  end
  L7_2 = 1
  ::lbl_20::
  L8_2 = 0
  L9_2 = 20
  L10_2 = 1
  for L11_2 = L8_2, L9_2, L10_2 do
    L12_2 = L11_2 * L7_2
    L12_2 = A1_2 + L12_2
    L13_2 = os
    L13_2 = L13_2.time
    L14_2 = {}
    L15_2 = L6_2.year
    L14_2.year = L15_2
    L15_2 = L6_2.month
    L14_2.month = L15_2
    L15_2 = L6_2.day
    L15_2 = L15_2 + L12_2
    L14_2.day = L15_2
    L14_2.hour = A2_2
    L14_2.min = A3_2
    L14_2.sec = 0
    L13_2 = L13_2(L14_2)
    L14_2 = tonumber
    L15_2 = os
    L15_2 = L15_2.date
    L16_2 = "%w"
    L17_2 = L13_2
    L15_2, L16_2, L17_2, L18_2, L19_2 = L15_2(L16_2, L17_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
    if 0 == L14_2 then
      L14_2 = 7
    end
    L15_2 = L5_2[L14_2]
    if L15_2 then
      if not (A1_2 < 0) then
        L15_2 = L13_2 * 1000
        L16_2 = A0_2.now
        L16_2 = L16_2 + 1200000
        if not (L15_2 > L16_2) then
          goto lbl_79
        end
      end
      L15_2 = os
      L15_2 = L15_2.date
      L16_2 = "%Y-%m-%d"
      L17_2 = L13_2
      L15_2 = L15_2(L16_2, L17_2)
      L16_2 = "%02d:%02d"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = A2_2
      L19_2 = A3_2
      L16_2 = L16_2(L17_2, L18_2, L19_2)
      L17_2 = L13_2 * 1000
      return L15_2, L16_2, L17_2
    end
    ::lbl_79::
  end
  L8_2 = os
  L8_2 = L8_2.time
  L8_2 = L8_2()
  L9_2 = A1_2 * 86400
  L8_2 = L8_2 + L9_2
  L9_2 = os
  L9_2 = L9_2.date
  L10_2 = "%Y-%m-%d"
  L11_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = "%02d:%02d"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = A2_2
  L13_2 = A3_2
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  L11_2 = L8_2 * 1000
  return L9_2, L10_2, L11_2
end
function L35_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L6_2 = A5_2.svc
  L6_2 = A3_2[L6_2]
  L7_2 = L34_1
  L8_2 = A0_2
  L9_2 = A5_2.d
  L10_2 = A5_2.h
  L11_2 = A5_2.m
  L12_2 = A4_2
  L7_2, L8_2, L9_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L10_2 = L30_1
  L11_2 = A0_2
  L12_2 = {}
  L12_2.app = A1_2
  L12_2.module = A2_2
  L12_2.kind = "appt"
  L13_2 = A5_2.st
  L12_2.status = L13_2
  L13_2 = L6_2.label
  L12_2.title = L13_2
  L13_2 = A5_2.owner
  L12_2.owner = L13_2
  L13_2 = A5_2.as
  L12_2.as = L13_2
  L12_2.at = L9_2
  L13_2 = A5_2.ago
  L12_2.ago = L13_2
  L13_2 = A5_2.upd
  L12_2.upd = L13_2
  L13_2 = {}
  L13_2.day = L7_2
  L13_2.time = L8_2
  L14_2 = A5_2.svc
  L13_2.service = L14_2
  L14_2 = L6_2.label
  L13_2.service_label = L14_2
  L14_2 = L6_2.minutes
  L13_2.minutes = L14_2
  L14_2 = A5_2.notes
  L13_2.notes = L14_2
  L12_2.data = L13_2
  return L10_2(L11_2, L12_2)
end
function L36_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L5_2 = A4_2.type
  L5_2 = A3_2[L5_2]
  L6_2 = L30_1
  L7_2 = A0_2
  L8_2 = {}
  L8_2.app = A1_2
  L8_2.module = A2_2
  L8_2.kind = "call"
  L9_2 = A4_2.st
  L8_2.status = L9_2
  L8_2.title = L5_2
  L9_2 = A4_2.owner
  L8_2.owner = L9_2
  L9_2 = A4_2.as
  L8_2.as = L9_2
  L9_2 = A4_2.ago
  L8_2.ago = L9_2
  L9_2 = A4_2.upd
  L8_2.upd = L9_2
  L9_2 = A4_2.pos
  L9_2 = L9_2[1]
  L8_2.x = L9_2
  L9_2 = A4_2.pos
  L9_2 = L9_2[2]
  L8_2.y = L9_2
  L9_2 = A4_2.pos
  L9_2 = L9_2[3]
  L8_2.z = L9_2
  L9_2 = {}
  L10_2 = A4_2.type
  L9_2.type = L10_2
  L9_2.type_label = L5_2
  L10_2 = A4_2.msg
  L9_2.message = L10_2
  L8_2.data = L9_2
  return L6_2(L7_2, L8_2)
end
function L37_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L29_1
  L5_2 = A0_2
  L6_2 = A3_2.by
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  L6_2 = L30_1
  L7_2 = A0_2
  L8_2 = {}
  L8_2.app = A1_2
  L8_2.module = A2_2
  L8_2.kind = "post"
  L8_2.status = "published"
  L9_2 = A3_2.title
  L8_2.title = L9_2
  L9_2 = A3_2.pinned
  L8_2.pinned = L9_2
  L9_2 = A3_2.by
  L8_2.as = L9_2
  L9_2 = A3_2.ago
  L8_2.ago = L9_2
  L9_2 = {}
  L10_2 = A3_2.body
  L9_2.body = L10_2
  L10_2 = A3_2.image
  L9_2.image = L10_2
  L9_2.author = L5_2
  L8_2.data = L9_2
  return L6_2(L7_2, L8_2)
end
function L38_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L5_2 = L29_1
  L6_2 = A0_2
  L7_2 = A4_2.to
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  L8_2 = L30_1
  L9_2 = A0_2
  L10_2 = {}
  L10_2.app = A1_2
  L10_2.module = A2_2
  L10_2.kind = "bill"
  L11_2 = A4_2.st
  L10_2.status = L11_2
  L11_2 = A4_2.reason
  L10_2.title = L11_2
  L11_2 = A4_2.to
  L10_2.owner = L11_2
  L11_2 = A4_2.by
  L10_2.as = L11_2
  L11_2 = A4_2.ago
  L10_2.ago = L11_2
  L11_2 = A4_2.upd
  L10_2.upd = L11_2
  L11_2 = {}
  L12_2 = A4_2.amount
  L11_2.amount = L12_2
  L12_2 = A4_2.reason
  L11_2.reason = L12_2
  L11_2.to = L7_2
  L11_2.society = A3_2
  L10_2.data = L11_2
  return L8_2(L9_2, L10_2)
end
function L39_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L7_2 = L29_1
  L8_2 = A0_2
  L9_2 = A3_2
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  L9_2 = A0_2.ago
  L10_2 = A5_2
  L9_2 = L9_2(L10_2)
  L10_2 = A6_2 * 60000
  L10_2 = L9_2 + L10_2
  L11_2 = A0_2.now
  L11_2 = L11_2 - 60000
  if L10_2 > L11_2 then
    L11_2 = A0_2.now
    L10_2 = L11_2 - 60000
    L11_2 = math
    L11_2 = L11_2.max
    L12_2 = 1
    L13_2 = math
    L13_2 = L13_2.floor
    L14_2 = L10_2 - L9_2
    L14_2 = L14_2 / 60000
    L13_2 = L13_2(L14_2)
    L11_2 = L11_2(L12_2, L13_2)
    A6_2 = L11_2
  end
  L11_2 = A0_2.insert
  L12_2 = L2_1
  L13_2 = {}
  L13_2.app = A1_2
  L13_2.module = A2_2
  L13_2.kind = "shift"
  L13_2.status = "closed"
  L13_2.title = L8_2
  L13_2.owner = L7_2
  L13_2.owner_name = L8_2
  L13_2.assignee = L7_2
  L13_2.assignee_name = L8_2
  L13_2.anonymous = 0
  L13_2.pinned = 0
  L13_2.at = L9_2
  L13_2.created = L9_2
  L13_2.updated = L10_2
  L14_2 = {}
  L14_2.start = L9_2
  L14_2.job = A4_2
  L14_2.stop = L10_2
  L14_2.minutes = A6_2
  L13_2.data = L14_2
  L11_2(L12_2, L13_2)
end
function L40_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L29_1
  L5_2 = A0_2
  L6_2 = A3_2.by
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  L6_2 = L13_1
  L7_2 = A3_2.defs
  L8_2 = A3_2.fields
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = A3_2.tags
  if not L7_2 then
    L7_2 = {}
  end
  L6_2.tags = L7_2
  L6_2.author = L5_2
  L7_2 = {}
  L7_2.app = A1_2
  L7_2.module = A2_2
  L7_2.kind = "record"
  L8_2 = A3_2.st
  if not L8_2 then
    L8_2 = "open"
  end
  L7_2.status = L8_2
  L8_2 = A3_2.subject
  L7_2.title = L8_2
  L8_2 = A3_2.subject
  L7_2.subject = L8_2
  L8_2 = A3_2.by
  L7_2.as = L8_2
  L8_2 = A3_2.ago
  L7_2.ago = L8_2
  L8_2 = A3_2.upd
  L7_2.upd = L8_2
  L7_2.data = L6_2
  L8_2 = A3_2.owner
  if L8_2 then
    L8_2 = A3_2.owner
    L7_2.owner = L8_2
    L8_2 = A3_2.subject
    L7_2.ownerName = L8_2
  end
  L8_2 = L30_1
  L9_2 = A0_2
  L10_2 = L7_2
  return L8_2(L9_2, L10_2)
end
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = 0
  L4_2 = 0
  L5_2 = ipairs
  L6_2 = A1_2.lines
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L12_2 = L10_2[1]
    L11_2 = L24_1
    L11_2 = L11_2[L12_2]
    L12_2 = #L2_2
    L12_2 = L12_2 + 1
    L13_2 = {}
    L14_2 = L11_2.id
    L13_2.id = L14_2
    L14_2 = L11_2.label
    L13_2.label = L14_2
    L14_2 = L11_2.price
    L13_2.price = L14_2
    L14_2 = L10_2[2]
    L13_2.qty = L14_2
    L2_2[L12_2] = L13_2
    L12_2 = L11_2.price
    L13_2 = L10_2[2]
    L12_2 = L12_2 * L13_2
    L3_2 = L3_2 + L12_2
    L12_2 = L10_2[2]
    L4_2 = L4_2 + L12_2
  end
  L5_2 = L13_1
  L6_2 = L19_1
  L7_2 = A1_2.fields
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L2_2
  L7_2 = L3_2
  L8_2 = L4_2
  L9_2 = L4_1
  L5_2.currency = L9_2
  L5_2.count = L8_2
  L5_2.total = L7_2
  L5_2.lines = L6_2
  L6_2 = L2_2[1]
  L6_2 = L6_2.label
  L7_2 = #L2_2
  if L7_2 > 1 then
    L7_2 = " +"
    L8_2 = #L2_2
    L8_2 = L8_2 - 1
    L7_2 = L7_2 .. L8_2
    if L7_2 then
      goto lbl_63
    end
  end
  L7_2 = ""
  ::lbl_63::
  L6_2 = L6_2 .. L7_2
  L7_2 = A1_2.pos
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = L30_1
  L9_2 = A0_2
  L10_2 = {}
  L10_2.app = "burgershot"
  L10_2.module = "menu"
  L10_2.kind = "order"
  L11_2 = A1_2.st
  L10_2.status = L11_2
  L10_2.title = L6_2
  L11_2 = A1_2.owner
  L10_2.owner = L11_2
  L11_2 = A1_2.as
  L10_2.as = L11_2
  L11_2 = A1_2.ago
  L10_2.ago = L11_2
  L11_2 = A1_2.upd
  L10_2.upd = L11_2
  L11_2 = L7_2[1]
  L10_2.x = L11_2
  L11_2 = L7_2[2]
  L10_2.y = L11_2
  L11_2 = L7_2[3]
  L10_2.z = L11_2
  L10_2.data = L5_2
  return L8_2(L9_2, L10_2)
end
function L42_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = "lspd"
  L3_2 = {}
  L3_2.robbery = "Robbery in progress"
  L3_2.crash = "Traffic accident"
  L3_2.assault = "Assault"
  L3_2.noise = "Noise complaint"
  L3_2.suspicious = "Suspicious person"
  L3_2.patrol = "Request a patrol"
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "waiting"
  L9_2.ago = 3
  L9_2.owner = "emma"
  L9_2.type = "robbery"
  L10_2 = {}
  L11_2 = 25.7
  L12_2 = -1347.3
  L13_2 = 29.5
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "Two guys in ski masks just ran into the 24/7 on Innocence Blvd. One of them has a baseball bat."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "waiting"
  L9_2.ago = 9
  L9_2.owner = "ryan"
  L9_2.type = "crash"
  L10_2 = {}
  L11_2 = -1216.2
  L12_2 = -657.4
  L13_2 = 25.9
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "Three car pileup at the Del Perro Freeway off ramp. One of the drivers is not moving."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "accepted"
  L9_2.ago = 16
  L9_2.upd = 12
  L9_2.owner = "luna"
  L9_2.as = "jake"
  L9_2.type = "assault"
  L10_2 = {}
  L11_2 = -1388.4
  L12_2 = -586.6
  L13_2 = 30.2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "Big fight outside Bahama Mamas, the bouncers cannot hold them back."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "accepted"
  L9_2.ago = 27
  L9_2.upd = 21
  L9_2.owner = "sofia"
  L9_2.as = "me"
  L9_2.type = "suspicious"
  L10_2 = {}
  L11_2 = -716.0
  L12_2 = -155.0
  L13_2 = 37.4
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "Guy in a gray hoodie checking car doors in the Rockford Plaza parking lot."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "waiting"
  L9_2.ago = 38
  L9_2.owner = "chloe"
  L9_2.type = "noise"
  L10_2 = {}
  L11_2 = -1110.0
  L12_2 = -1040.0
  L13_2 = 2.1
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "House party next door has been going since 2 AM. The bass is literally shaking my windows."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "done"
  L9_2.ago = 190
  L9_2.upd = 150
  L9_2.owner = "kai"
  L9_2.as = "jake"
  L9_2.type = "patrol"
  L10_2 = {}
  L11_2 = -662.0
  L12_2 = -878.0
  L13_2 = 24.5
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "Someone followed me home from the Little Seoul station two nights in a row. Could a unit swing by tonight?"
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "done"
  L9_2.ago = 420
  L9_2.upd = 380
  L9_2.owner = "mia"
  L9_2.as = "me"
  L9_2.type = "crash"
  L10_2 = {}
  L11_2 = 295.0
  L12_2 = 175.0
  L13_2 = 104.1
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "Car flipped on its roof on Vinewood Blvd. The driver is out and talking."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = L36_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "dispatch"
  L8_2 = L3_2
  L9_2 = {}
  L9_2.st = "cancelled"
  L9_2.ago = 1500
  L9_2.upd = 1495
  L9_2.owner = "marcus"
  L9_2.type = "robbery"
  L10_2 = {}
  L11_2 = -205.6
  L12_2 = -1308.5
  L13_2 = 31.3
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L9_2.msg = "False alarm, sorry. The shop alarm at Benny's went off on its own."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = L13_1
    L2_3 = L16_1
    L3_3 = A0_3.f
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = A0_3.photo
    L1_3.photo = L2_3
    L2_3 = A0_3.pos
    if not L2_3 then
      L2_3 = {}
    end
    L3_3 = L30_1
    L4_3 = A0_2
    L5_3 = {}
    L6_3 = L2_2
    L5_3.app = L6_3
    L5_3.module = "reports"
    L5_3.kind = "form"
    L6_3 = A0_3.st
    L5_3.status = L6_3
    L6_3 = A0_3.f
    L6_3 = L6_3.type
    L5_3.title = L6_3
    L6_3 = A0_3.owner
    L5_3.owner = L6_3
    L6_3 = A0_3.anon
    L5_3.anon = L6_3
    L6_3 = A0_3.as
    L5_3.as = L6_3
    L6_3 = A0_3.ago
    L5_3.ago = L6_3
    L6_3 = A0_3.upd
    L5_3.upd = L6_3
    L6_3 = L2_3[1]
    L5_3.x = L6_3
    L6_3 = L2_3[2]
    L5_3.y = L6_3
    L6_3 = L2_3[3]
    L5_3.z = L6_3
    L5_3.data = L1_3
    return L3_3(L4_3, L5_3)
  end
  L5_2 = L4_2
  L6_2 = {}
  L6_2.st = "new"
  L6_2.ago = 22
  L6_2.owner = "mia"
  L7_2 = A0_2.img
  L8_2 = "lspdvespucciissi"
  L9_2 = 1080
  L10_2 = 720
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.photo = L7_2
  L7_2 = {}
  L8_2 = -1290.0
  L9_2 = -1660.0
  L10_2 = 4.4
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L6_2.pos = L7_2
  L7_2 = {}
  L7_2.type = "Stolen vehicle"
  L7_2.where = "Vespucci Beach parking lot"
  L8_2 = L32_1
  L9_2 = A0_2
  L10_2 = 0
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.date = L8_2
  L8_2 = L33_1
  L9_2 = A0_2
  L10_2 = 150
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.time = L8_2
  L7_2.plate = "4MIA247"
  L7_2.description = "My silver Issi was parked by the lifeguard tower at Vespucci Beach. I came back from a shoot and it was gone. There is a camera bag in the trunk."
  L6_2.f = L7_2
  L5_2(L6_2)
  L5_2 = L4_2
  L6_2 = {}
  L6_2.st = "new"
  L6_2.ago = 47
  L6_2.owner = "derek"
  L6_2.anon = true
  L7_2 = {}
  L7_2.type = "Fraud"
  L7_2.where = "Online, on the Zapp marketplace"
  L8_2 = L32_1
  L9_2 = A0_2
  L10_2 = -1
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.date = L8_2
  L7_2.description = "Someone is selling fake Maze Bank Arena tickets for the Saturday show. I paid 300 and the QR code does not work. The seller deleted the profile."
  L6_2.f = L7_2
  L5_2(L6_2)
  L5_2 = L4_2
  L6_2 = {}
  L6_2.st = "new"
  L6_2.ago = 70
  L6_2.owner = "sofia"
  L7_2 = {}
  L7_2.type = "Theft"
  L7_2.where = "Rockford Hills, Eclipse Blvd"
  L8_2 = L32_1
  L9_2 = A0_2
  L10_2 = 0
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.date = L8_2
  L7_2.description = "Packages keep disappearing from the porch of a house I am selling. Third time this week, always around noon."
  L6_2.f = L7_2
  L5_2(L6_2)
  L5_2 = L4_2
  L6_2 = {}
  L6_2.st = "review"
  L6_2.ago = 180
  L6_2.upd = 60
  L6_2.owner = "nina"
  L6_2.as = "jake"
  L7_2 = A0_2.img
  L8_2 = "weazelvanvandal"
  L9_2 = 1080
  L10_2 = 720
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.photo = L7_2
  L7_2 = {}
  L7_2.type = "Vandalism"
  L7_2.where = "Vinewood Blvd, outside the Weazel News studio"
  L8_2 = L32_1
  L9_2 = A0_2
  L10_2 = -1
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.date = L8_2
  L7_2.time = "03:40"
  L7_2.description = "Our news van got spray painted overnight. The whole side panel and the windshield. We have the studio camera footage if you need it."
  L7_2.witnesses = true
  L7_2.witness_info = "Night security guard, Paul, at the front desk."
  L6_2.f = L7_2
  L5_2 = L5_2(L6_2)
  L6_2 = L31_1
  L7_2 = A0_2
  L8_2 = L5_2
  L9_2 = "jake"
  L10_2 = 95
  L11_2 = "Thanks Nina. Can you send the footage to Mission Row? An officer will stop by the studio this afternoon."
  L12_2 = true
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = L31_1
  L7_2 = A0_2
  L8_2 = L5_2
  L9_2 = "nina"
  L10_2 = 60
  L11_2 = "Sent it to the front desk, ask for Paul. Thank you!"
  L12_2 = false
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = L4_2
  L7_2 = {}
  L7_2.st = "review"
  L7_2.ago = 300
  L7_2.upd = 200
  L7_2.owner = "me"
  L7_2.as = "jake"
  L8_2 = {}
  L8_2.type = "Vandalism"
  L8_2.where = "Legion Square garage, level 2"
  L9_2 = L32_1
  L10_2 = A0_2
  L11_2 = 0
  L9_2 = L9_2(L10_2, L11_2)
  L8_2.date = L9_2
  L8_2.description = "Someone keyed the whole driver side of my car while it was parked at the Legion Square garage, between 2 PM and 5 PM."
  L7_2.f = L8_2
  L6_2 = L6_2(L7_2)
  L7_2 = L31_1
  L8_2 = A0_2
  L9_2 = L6_2
  L10_2 = "jake"
  L11_2 = 200
  L12_2 = "We requested the garage camera footage. Expect an update within 48 hours."
  L13_2 = true
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L7_2 = L4_2
  L8_2 = {}
  L8_2.st = "investigating"
  L8_2.ago = 1500
  L8_2.upd = 240
  L8_2.owner = "kai"
  L8_2.as = "me"
  L9_2 = {}
  L9_2.type = "Theft"
  L9_2.where = "Office building, Little Seoul"
  L10_2 = L32_1
  L11_2 = A0_2
  L12_2 = -2
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.date = L10_2
  L9_2.description = "Two laptops and a prototype drive were taken from our office after hours. No sign of forced entry and the alarm was not triggered."
  L8_2.f = L9_2
  L7_2 = L7_2(L8_2)
  L8_2 = L31_1
  L9_2 = A0_2
  L10_2 = L7_2
  L11_2 = "me"
  L12_2 = 300
  L13_2 = "We pulled the building key card logs. Someone used a card that was reported lost last week. We will keep you posted."
  L14_2 = true
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L8_2 = L31_1
  L9_2 = A0_2
  L10_2 = L7_2
  L11_2 = "me"
  L12_2 = 290
  L13_2 = "Card belongs to an ex-employee, Brad K. Check his alibi before contacting him."
  L14_2 = true
  L15_2 = true
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L8_2 = L31_1
  L9_2 = A0_2
  L10_2 = L7_2
  L11_2 = "kai"
  L12_2 = 240
  L13_2 = "Thank you, that makes sense. He left on bad terms."
  L14_2 = false
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L8_2 = L4_2
  L9_2 = {}
  L9_2.st = "solved"
  L9_2.ago = 2900
  L9_2.upd = 1690
  L9_2.owner = "emma"
  L9_2.as = "jake"
  L10_2 = {}
  L10_2.type = "Theft"
  L10_2.where = "Bean Machine, Legion Square"
  L11_2 = L32_1
  L12_2 = A0_2
  L13_2 = -2
  L11_2 = L11_2(L12_2, L13_2)
  L10_2.date = L11_2
  L10_2.time = "08:15"
  L10_2.description = "A guy grabbed the tip jar off the counter and ran towards Legion Square. About 20 years old, red cap, white sneakers."
  L9_2.f = L10_2
  L8_2 = L8_2(L9_2)
  L9_2 = L31_1
  L10_2 = A0_2
  L11_2 = L8_2
  L12_2 = "jake"
  L13_2 = 1700
  L14_2 = "We caught him two blocks away. The jar and the money are at Mission Row, pick them up with your ID."
  L15_2 = true
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L9_2 = L31_1
  L10_2 = A0_2
  L11_2 = L8_2
  L12_2 = "emma"
  L13_2 = 1690
  L14_2 = "You guys are the best. Free coffee next time you stop by!"
  L15_2 = false
  L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L9_2 = L4_2
  L10_2 = {}
  L10_2.st = "archived"
  L10_2.ago = 5800
  L10_2.upd = 5000
  L10_2.owner = "ryan"
  L10_2.as = "jake"
  L11_2 = {}
  L11_2.type = "Threats"
  L11_2.where = "Downtown Cab Co. depot"
  L12_2 = L32_1
  L13_2 = A0_2
  L14_2 = -4
  L12_2 = L12_2(L13_2, L14_2)
  L11_2.date = L12_2
  L11_2.description = "A passenger refused to pay and said he would come back for me. I have his face on my dash cam."
  L10_2.f = L11_2
  L9_2 = L9_2(L10_2)
  L10_2 = L31_1
  L11_2 = A0_2
  L12_2 = L9_2
  L13_2 = "jake"
  L14_2 = 5000
  L15_2 = "We identified the passenger and gave him a formal warning. Call 911 right away if you see him again."
  L16_2 = true
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  function L10_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = L17_1
    A0_3.defs = L1_3
    L1_3 = L40_1
    L2_3 = A0_2
    L3_3 = L2_2
    L4_3 = "records"
    L5_3 = A0_3
    return L1_3(L2_3, L3_3, L4_3, L5_3)
  end
  L11_2 = Showcase
  L11_2 = L11_2.byKey
  L11_2 = L11_2.tyler
  L12_2 = L10_2
  L13_2 = {}
  L14_2 = L11_2.name
  L13_2.subject = L14_2
  L13_2.owner = "tyler"
  L13_2.by = "jake"
  L13_2.ago = 4300
  L13_2.upd = 900
  L14_2 = {}
  L15_2 = "priors"
  L16_2 = "watch"
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L13_2.tags = L14_2
  L14_2 = {}
  L14_2.dob = "1999-03-14"
  L14_2.charges = "Street racing on the Del Perro Freeway. Reckless driving. Evading a traffic stop."
  L14_2.fine = 1250
  L14_2.jail = 0
  L14_2.notes = "Drives a modified Annis Elegy. Known to organize meets at the Sandy Shores airfield."
  L13_2.fields = L14_2
  L12_2 = L12_2(L13_2)
  L13_2 = L31_1
  L14_2 = A0_2
  L15_2 = L12_2
  L16_2 = "jake"
  L17_2 = 900
  L18_2 = "Pulled over on the Great Ocean Highway doing 140. Fined and the car was impounded for 24 hours."
  L19_2 = true
  L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L13_2 = L10_2
  L14_2 = {}
  L14_2.subject = "Vincent Moreno"
  L14_2.by = "me"
  L14_2.ago = 2000
  L14_2.upd = 600
  L15_2 = {}
  L16_2 = "warrant"
  L17_2 = "dangerous"
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L14_2.tags = L15_2
  L15_2 = {}
  L15_2.dob = "1988-11-02"
  L15_2.charges = "Armed robbery of the Fleeca Bank on Route 68. Possession of an illegal firearm."
  L15_2.fine = 15000
  L15_2.jail = 120
  L15_2.notes = "Last seen in a black Baller near Paleto Bay. Do not approach alone."
  L14_2.fields = L15_2
  L13_2 = L13_2(L14_2)
  L14_2 = L31_1
  L15_2 = A0_2
  L16_2 = L13_2
  L17_2 = "me"
  L18_2 = 1900
  L19_2 = "Warrant signed by Judge Harlow."
  L20_2 = true
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  L14_2 = L31_1
  L15_2 = A0_2
  L16_2 = L13_2
  L17_2 = "me"
  L18_2 = 600
  L19_2 = "Informant says he is hiding at a ranch near Grapeseed."
  L20_2 = true
  L21_2 = true
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L14_2 = L10_2
  L15_2 = {}
  L15_2.subject = "Dmitri Volkov"
  L15_2.by = "me"
  L15_2.ago = 35
  L16_2 = {}
  L17_2 = "warrant"
  L16_2[1] = L17_2
  L15_2.tags = L16_2
  L16_2 = {}
  L16_2.dob = "1979-01-30"
  L16_2.charges = "Fraud and identity theft. Fake Maze Bank Arena tickets sold online."
  L16_2.fine = 5000
  L16_2.jail = 36
  L16_2.notes = "Linked to the ticket fraud report from this morning."
  L15_2.fields = L16_2
  L14_2(L15_2)
  L14_2 = Showcase
  L14_2 = L14_2.byKey
  L14_2 = L14_2.ryan
  L15_2 = L10_2
  L16_2 = {}
  L17_2 = L14_2.name
  L16_2.subject = L17_2
  L16_2.owner = "ryan"
  L16_2.by = "jake"
  L16_2.ago = 7000
  L17_2 = {}
  L16_2.tags = L17_2
  L17_2 = {}
  L17_2.dob = "1991-07-09"
  L17_2.charges = "Three unpaid parking tickets in Downtown."
  L17_2.fine = 300
  L17_2.notes = "Paid at the front desk."
  L16_2.fields = L17_2
  L15_2(L16_2)
  L15_2 = L10_2
  L16_2 = {}
  L16_2.subject = "Carla Ruiz"
  L16_2.st = "archived"
  L16_2.by = "jake"
  L16_2.ago = 10000
  L16_2.upd = 9000
  L17_2 = {}
  L18_2 = "priors"
  L17_2[1] = L18_2
  L16_2.tags = L17_2
  L17_2 = {}
  L17_2.dob = "1995-06-21"
  L17_2.charges = "Shoplifting at the Binco in Vespucci."
  L17_2.fine = 300
  L17_2.notes = "Fine paid. Community service completed."
  L16_2.fields = L17_2
  L15_2(L16_2)
  L15_2 = L38_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "fines"
  L19_2 = A1_2
  L20_2 = {}
  L20_2.to = "tyler"
  L20_2.by = "me"
  L20_2.amount = 750
  L20_2.reason = "Reckless driving on the Great Ocean Highway"
  L20_2.st = "pending"
  L20_2.ago = 35
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L15_2 = L38_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "fines"
  L19_2 = A1_2
  L20_2 = {}
  L20_2.to = "kai"
  L20_2.by = "jake"
  L20_2.amount = 250
  L20_2.reason = "Speeding in Little Seoul"
  L20_2.st = "pending"
  L20_2.ago = 95
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L15_2 = L38_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "fines"
  L19_2 = A1_2
  L20_2 = {}
  L20_2.to = "ryan"
  L20_2.by = "jake"
  L20_2.amount = 100
  L20_2.reason = "Illegal parking on Alta Street"
  L20_2.st = "paid"
  L20_2.ago = 300
  L20_2.upd = 260
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L15_2 = L38_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "fines"
  L19_2 = A1_2
  L20_2 = {}
  L20_2.to = "sofia"
  L20_2.by = "jake"
  L20_2.amount = 150
  L20_2.reason = "Running a red light in Rockford Hills"
  L20_2.st = "paid"
  L20_2.ago = 1400
  L20_2.upd = 1300
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L15_2 = L38_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "fines"
  L19_2 = A1_2
  L20_2 = {}
  L20_2.to = "luna"
  L20_2.by = "me"
  L20_2.amount = 250
  L20_2.reason = "Speeding on Vinewood Blvd"
  L20_2.st = "refused"
  L20_2.ago = 2600
  L20_2.upd = 2500
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L15_2 = L38_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "fines"
  L19_2 = A1_2
  L20_2 = {}
  L20_2.to = "marcus"
  L20_2.by = "me"
  L20_2.amount = 1000
  L20_2.reason = "Driving without a license"
  L20_2.st = "cancelled"
  L20_2.ago = 4000
  L20_2.upd = 3900
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L15_2 = L37_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "board"
  L19_2 = {}
  L19_2.by = "me"
  L19_2.pinned = true
  L19_2.ago = 120
  L19_2.title = "Tonight: extra units at Bahama Mamas"
  L19_2.body = "Two fights there this week. From 10 PM, units 3 and 5 patrol Del Perro and stay visible near the entrance. Radio channel 2."
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = L37_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "board"
  L19_2 = {}
  L19_2.by = "jake"
  L19_2.ago = 1440
  L19_2.title = "Bodycams on, every call"
  L19_2.body = "Footage saved the department twice this month. If it is not recorded, it did not happen."
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = L37_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "board"
  L19_2 = {}
  L19_2.by = "me"
  L19_2.ago = 3000
  L19_2.title = "New radar guns in the armory"
  L19_2.body = "Sign them out with the desk sergeant and bring them back charged. Please stop leaving them in the cruisers."
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = L37_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "news"
  L19_2 = {}
  L19_2.by = "jake"
  L19_2.ago = 25
  L19_2.title = "Stolen vehicle: silver Issi"
  L20_2 = A0_2.img
  L21_2 = "lspdstolenissi"
  L22_2 = 1080
  L23_2 = 720
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L19_2.image = L20_2
  L19_2.body = "A silver Issi was taken from the Vespucci Beach parking lot today around noon. If you see it, call 911. Do not approach the driver."
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = L37_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "news"
  L19_2 = {}
  L19_2.by = "me"
  L19_2.pinned = true
  L19_2.ago = 200
  L19_2.title = "Vinewood Marathon: road closures on Sunday"
  L20_2 = A0_2.img
  L21_2 = "lspdmarathon"
  L22_2 = 1080
  L23_2 = 720
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L19_2.image = L20_2
  L19_2.body = "Vinewood Blvd and Hawick Ave will be closed from 6 AM to 2 PM. Use the Del Perro Freeway and expect delays around Legion Square."
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = L37_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "news"
  L19_2 = {}
  L19_2.by = "jake"
  L19_2.ago = 2880
  L19_2.title = "Open day at Mission Row this Saturday"
  L20_2 = A0_2.img
  L21_2 = "lspdopenday"
  L22_2 = 1080
  L23_2 = 720
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L19_2.image = L20_2
  L19_2.body = "Meet the officers, sit in a cruiser and watch the K9 unit in action. Free hot dogs, 10 AM to 4 PM. Bring the kids!"
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = L37_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "news"
  L19_2 = {}
  L19_2.by = "me"
  L19_2.ago = 6000
  L19_2.title = "Scam alert: fake event tickets"
  L20_2 = A0_2.img
  L21_2 = "lspdscamalert"
  L22_2 = 1080
  L23_2 = 720
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L19_2.image = L20_2
  L19_2.body = "We are getting reports of fake Maze Bank Arena tickets sold online. Only buy from the official box office and never pay in advance to strangers."
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = L39_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "duty"
  L19_2 = "me"
  L20_2 = A1_2
  L21_2 = 390
  L22_2 = 345
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L15_2 = L39_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "duty"
  L19_2 = "me"
  L20_2 = A1_2
  L21_2 = 1830
  L22_2 = 480
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L15_2 = L39_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "duty"
  L19_2 = "me"
  L20_2 = A1_2
  L21_2 = 3270
  L22_2 = 420
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L15_2 = L39_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "duty"
  L19_2 = "me"
  L20_2 = A1_2
  L21_2 = 4720
  L22_2 = 505
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L15_2 = L39_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "duty"
  L19_2 = "me"
  L20_2 = A1_2
  L21_2 = 7600
  L22_2 = 360
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L15_2 = L39_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "duty"
  L19_2 = "jake"
  L20_2 = A1_2
  L21_2 = 600
  L22_2 = 480
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L15_2 = L39_1
  L16_2 = A0_2
  L17_2 = L2_2
  L18_2 = "duty"
  L19_2 = "jake"
  L20_2 = A1_2
  L21_2 = 2040
  L22_2 = 510
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
end
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = "pillbox"
  L3_2 = {}
  L4_2 = {}
  L4_2.label = "General check-up"
  L4_2.minutes = 30
  L3_2.checkup = L4_2
  L4_2 = {}
  L4_2.label = "Blood work"
  L4_2.minutes = 20
  L3_2.bloodwork = L4_2
  L4_2 = {}
  L4_2.label = "X-ray and scans"
  L4_2.minutes = 45
  L3_2.xray = L4_2
  L4_2 = {}
  L4_2.label = "Physiotherapy"
  L4_2.minutes = 60
  L3_2.physio = L4_2
  L4_2 = {}
  L4_2.label = "Fitness certificate"
  L4_2.minutes = 20
  L3_2.fitness = L4_2
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = "appointments"
  L8_2 = L3_2
  L9_2 = L15_1
  L10_2 = {}
  L10_2.svc = "checkup"
  L10_2.d = 2
  L10_2.h = 10
  L10_2.m = 30
  L10_2.st = "confirmed"
  L10_2.owner = "me"
  L10_2.as = "ava"
  L10_2.ago = 1300
  L10_2.upd = 1250
  L10_2.notes = "Annual check-up. I have been getting headaches after night shifts."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L34_1
  L5_2 = A0_2
  L6_2 = 2
  L7_2 = 10
  L8_2 = 30
  L9_2 = L15_1
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = "appointments"
  L9_2 = L3_2
  L10_2 = L15_1
  L11_2 = {}
  L11_2.svc = "xray"
  L11_2.d = 0
  L11_2.h = 18
  L11_2.m = 0
  L11_2.st = "confirmed"
  L11_2.owner = "tyler"
  L11_2.as = "ava"
  L11_2.ago = 400
  L11_2.upd = 380
  L11_2.notes = "Wrist still hurts after the crash on Saturday."
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = "appointments"
  L9_2 = L3_2
  L10_2 = L15_1
  L11_2 = {}
  L11_2.svc = "physio"
  L11_2.d = 1
  L11_2.h = 9
  L11_2.m = 30
  L11_2.st = "pending"
  L11_2.owner = "chloe"
  L11_2.ago = 150
  L11_2.notes = "Shoulder pain after a heavy bench session."
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = "appointments"
  L9_2 = L3_2
  L10_2 = L15_1
  L11_2 = {}
  L11_2.svc = "bloodwork"
  L11_2.d = 1
  L11_2.h = 14
  L11_2.m = 0
  L11_2.st = "confirmed"
  L11_2.owner = "mia"
  L11_2.as = "ava"
  L11_2.ago = 700
  L11_2.upd = 690
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = "appointments"
  L9_2 = L3_2
  L10_2 = L15_1
  L11_2 = {}
  L11_2.svc = "bloodwork"
  L11_2.d = 3
  L11_2.h = 11
  L11_2.m = 0
  L11_2.st = "pending"
  L11_2.owner = "ryan"
  L11_2.ago = 90
  L11_2.notes = "Routine check, fasting."
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = "appointments"
  L9_2 = L3_2
  L10_2 = L15_1
  L11_2 = {}
  L11_2.svc = "fitness"
  L11_2.d = 4
  L11_2.h = 15
  L11_2.m = 30
  L11_2.st = "pending"
  L11_2.owner = "luna"
  L11_2.ago = 30
  L11_2.notes = "I need it for the Vinewood Marathon."
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = "appointments"
  L9_2 = L3_2
  L10_2 = L15_1
  L11_2 = {}
  L11_2.svc = "checkup"
  L11_2.d = -2
  L11_2.h = 16
  L11_2.m = 0
  L11_2.st = "done"
  L11_2.owner = "emma"
  L11_2.as = "ava"
  L11_2.ago = 4000
  L11_2.upd = 2700
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = "appointments"
  L9_2 = L3_2
  L10_2 = L15_1
  L11_2 = {}
  L11_2.svc = "physio"
  L11_2.d = -1
  L11_2.h = 12
  L11_2.m = 0
  L11_2.st = "cancelled"
  L11_2.owner = "kai"
  L11_2.ago = 3000
  L11_2.upd = 1700
  L11_2.notes = "Sorry, investor meeting moved."
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = {}
  L5_2.injured = "Injured person"
  L5_2.unconscious = "Unconscious person"
  L5_2.crash = "Traffic accident"
  L5_2.breathing = "Breathing problems"
  L5_2.other = "Other emergency"
  L6_2 = L36_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = "ambulance"
  L10_2 = L5_2
  L11_2 = {}
  L11_2.st = "waiting"
  L11_2.ago = 5
  L11_2.owner = "derek"
  L11_2.type = "unconscious"
  L12_2 = {}
  L13_2 = 237.0
  L14_2 = -413.0
  L15_2 = 48.1
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L11_2.pos = L12_2
  L11_2.msg = "Man collapsed on the courthouse steps. He is breathing but not responding."
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = L36_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = "ambulance"
  L10_2 = L5_2
  L11_2 = {}
  L11_2.st = "accepted"
  L11_2.ago = 14
  L11_2.upd = 10
  L11_2.owner = "tyler"
  L11_2.as = "ava"
  L11_2.type = "crash"
  L12_2 = {}
  L13_2 = 180.0
  L14_2 = -1350.0
  L15_2 = 29.3
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L11_2.pos = L12_2
  L11_2.msg = "Motorbike vs taxi on Strawberry Ave. The rider has a deep cut on his leg."
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = L36_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = "ambulance"
  L10_2 = L5_2
  L11_2 = {}
  L11_2.st = "waiting"
  L11_2.ago = 24
  L11_2.owner = "chloe"
  L11_2.type = "injured"
  L12_2 = {}
  L13_2 = -1200.0
  L14_2 = -1570.0
  L15_2 = 4.6
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L11_2.pos = L12_2
  L11_2.msg = "A guy fell off the pull up bars at Muscle Beach. Possible broken arm."
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = L36_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = "ambulance"
  L10_2 = L5_2
  L11_2 = {}
  L11_2.st = "done"
  L11_2.ago = 1500
  L11_2.upd = 1440
  L11_2.owner = "me"
  L11_2.as = "ava"
  L11_2.type = "injured"
  L12_2 = {}
  L13_2 = 200.0
  L14_2 = -930.0
  L15_2 = 30.7
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L11_2.pos = L12_2
  L11_2.msg = "Cut my hand pretty badly. The bleeding will not stop."
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = L36_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = "ambulance"
  L10_2 = L5_2
  L11_2 = {}
  L11_2.st = "done"
  L11_2.ago = 3000
  L11_2.upd = 2950
  L11_2.owner = "luna"
  L11_2.as = "ava"
  L11_2.type = "breathing"
  L12_2 = {}
  L13_2 = -1388.4
  L14_2 = -586.6
  L15_2 = 30.2
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L11_2.pos = L12_2
  L11_2.msg = "My friend is having an asthma attack at Bahama Mamas and has no inhaler."
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = L36_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = "ambulance"
  L10_2 = L5_2
  L11_2 = {}
  L11_2.st = "cancelled"
  L11_2.ago = 4500
  L11_2.upd = 4490
  L11_2.owner = "ryan"
  L11_2.type = "other"
  L12_2 = {}
  L13_2 = 900.0
  L14_2 = -170.0
  L15_2 = 74.0
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L11_2.pos = L12_2
  L11_2.msg = "Never mind, he got up and walked off."
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  function L6_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = L18_1
    A0_3.defs = L1_3
    A0_3.by = "ava"
    L1_3 = L40_1
    L2_3 = A0_2
    L3_3 = L2_2
    L4_3 = "charts"
    L5_3 = A0_3
    return L1_3(L2_3, L3_3, L4_3, L5_3)
  end
  L7_2 = L29_1
  L8_2 = A0_2
  L9_2 = "me"
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  L9_2 = L6_2
  L10_2 = {}
  L10_2.subject = L8_2
  L10_2.owner = "me"
  L10_2.ago = 9000
  L10_2.upd = 1250
  L11_2 = {}
  L12_2 = "allergy"
  L13_2 = "insured"
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L10_2.tags = L11_2
  L11_2 = {}
  L11_2.blood = "O+"
  L11_2.allergies = "Penicillin"
  L11_2.conditions = "Mild tension headaches, probably linked to night shifts."
  L11_2.treatment = "Ibuprofen as needed. More water, fewer energy drinks."
  L11_2.next_visit = L4_2
  L10_2.fields = L11_2
  L9_2 = L9_2(L10_2)
  L10_2 = L31_1
  L11_2 = A0_2
  L12_2 = L9_2
  L13_2 = "ava"
  L14_2 = 9000
  L15_2 = "Routine check-up done. Blood pressure 120/80. All good."
  L16_2 = true
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L10_2 = L31_1
  L11_2 = A0_2
  L12_2 = L9_2
  L13_2 = "ava"
  L14_2 = 1250
  L15_2 = "Follow up booked for the headaches."
  L16_2 = true
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L10_2 = Showcase
  L10_2 = L10_2.byKey
  L10_2 = L10_2.tyler
  L11_2 = L6_2
  L12_2 = {}
  L13_2 = L10_2.name
  L12_2.subject = L13_2
  L12_2.owner = "tyler"
  L12_2.ago = 2600
  L12_2.upd = 380
  L13_2 = {}
  L14_2 = "insured"
  L13_2[1] = L14_2
  L12_2.tags = L13_2
  L13_2 = {}
  L13_2.blood = "A-"
  L13_2.allergies = "None known"
  L13_2.conditions = "Sprained left wrist after a car crash."
  L13_2.treatment = "Splint for two weeks. X-ray booked."
  L12_2.fields = L13_2
  L11_2 = L11_2(L12_2)
  L12_2 = L31_1
  L13_2 = A0_2
  L14_2 = L11_2
  L15_2 = "ava"
  L16_2 = 2600
  L17_2 = "Splint fitted, painkillers for five days."
  L18_2 = true
  L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L12_2 = L31_1
  L13_2 = A0_2
  L14_2 = L11_2
  L15_2 = "ava"
  L16_2 = 380
  L17_2 = "Third crash this year. Talked to him about the street racing."
  L18_2 = true
  L19_2 = true
  L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L12_2 = Showcase
  L12_2 = L12_2.byKey
  L12_2 = L12_2.chloe
  L13_2 = L6_2
  L14_2 = {}
  L15_2 = L12_2.name
  L14_2.subject = L15_2
  L14_2.owner = "chloe"
  L14_2.ago = 5200
  L15_2 = {}
  L16_2 = "allergy"
  L15_2[1] = L16_2
  L14_2.tags = L15_2
  L15_2 = {}
  L15_2.blood = "B+"
  L15_2.allergies = "Peanuts"
  L15_2.conditions = "Shoulder strain (rotator cuff)."
  L15_2.treatment = "Physiotherapy twice a week, no overhead lifting."
  L14_2.fields = L15_2
  L13_2(L14_2)
  L13_2 = Showcase
  L13_2 = L13_2.byKey
  L13_2 = L13_2.ryan
  L14_2 = L6_2
  L15_2 = {}
  L16_2 = L13_2.name
  L15_2.subject = L16_2
  L15_2.owner = "ryan"
  L15_2.ago = 12000
  L16_2 = {}
  L17_2 = "chronic"
  L18_2 = "donor"
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L15_2.tags = L16_2
  L16_2 = {}
  L16_2.blood = "AB+"
  L16_2.allergies = "None known"
  L16_2.conditions = "Type 2 diabetes, well controlled."
  L16_2.treatment = "Metformin daily. Blood work every three months."
  L15_2.fields = L16_2
  L14_2(L15_2)
  L14_2 = L38_1
  L15_2 = A0_2
  L16_2 = L2_2
  L17_2 = "billing"
  L18_2 = A1_2
  L19_2 = {}
  L19_2.to = "tyler"
  L19_2.by = "ava"
  L19_2.amount = 400
  L19_2.reason = "Ambulance transport"
  L19_2.st = "paid"
  L19_2.ago = 380
  L19_2.upd = 300
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L14_2 = L38_1
  L15_2 = A0_2
  L16_2 = L2_2
  L17_2 = "billing"
  L18_2 = A1_2
  L19_2 = {}
  L19_2.to = "ryan"
  L19_2.by = "ava"
  L19_2.amount = 150
  L19_2.reason = "Consultation"
  L19_2.st = "pending"
  L19_2.ago = 80
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L14_2 = L38_1
  L15_2 = A0_2
  L16_2 = L2_2
  L17_2 = "billing"
  L18_2 = A1_2
  L19_2 = {}
  L19_2.to = "mia"
  L19_2.by = "ava"
  L19_2.amount = 300
  L19_2.reason = "Wound treatment"
  L19_2.st = "paid"
  L19_2.ago = 2000
  L19_2.upd = 1900
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L14_2 = L38_1
  L15_2 = A0_2
  L16_2 = L2_2
  L17_2 = "billing"
  L18_2 = A1_2
  L19_2 = {}
  L19_2.to = "luna"
  L19_2.by = "ava"
  L19_2.amount = 250
  L19_2.reason = "X-ray"
  L19_2.st = "pending"
  L19_2.ago = 1400
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L14_2 = L39_1
  L15_2 = A0_2
  L16_2 = L2_2
  L17_2 = "duty"
  L18_2 = "ava"
  L19_2 = A1_2
  L20_2 = 500
  L21_2 = 480
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L14_2 = L39_1
  L15_2 = A0_2
  L16_2 = L2_2
  L17_2 = "duty"
  L18_2 = "ava"
  L19_2 = A1_2
  L20_2 = 1950
  L21_2 = 600
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L14_2 = L39_1
  L15_2 = A0_2
  L16_2 = L2_2
  L17_2 = "duty"
  L18_2 = "ava"
  L19_2 = A1_2
  L20_2 = 3400
  L21_2 = 540
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
end
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = "Pick up at the counter"
  L3_2 = "Delivery"
  L4_2 = L41_1
  L5_2 = A0_2
  L6_2 = {}
  L6_2.st = "received"
  L6_2.ago = 3
  L6_2.owner = "luna"
  L7_2 = {}
  L8_2 = {}
  L9_2 = "heart_stopper"
  L10_2 = 1
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L9_2 = {}
  L10_2 = "fries"
  L11_2 = 1
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = {}
  L11_2 = "sprunk"
  L12_2 = 1
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L6_2.lines = L7_2
  L7_2 = {}
  L7_2.delivery = L2_2
  L7_2.notes = "No pickles please!"
  L6_2.fields = L7_2
  L4_2(L5_2, L6_2)
  L4_2 = L41_1
  L5_2 = A0_2
  L6_2 = {}
  L6_2.st = "preparing"
  L6_2.ago = 7
  L6_2.upd = 5
  L6_2.owner = "me"
  L6_2.as = "leo"
  L7_2 = {}
  L8_2 = 195.0
  L9_2 = -933.0
  L10_2 = 30.7
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L6_2.pos = L7_2
  L7_2 = {}
  L8_2 = {}
  L9_2 = "money_shot"
  L10_2 = 2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L9_2 = {}
  L10_2 = "rings"
  L11_2 = 1
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = {}
  L11_2 = "ecola"
  L12_2 = 2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L6_2.lines = L7_2
  L7_2 = {}
  L7_2.delivery = L3_2
  L7_2.address = "Legion Square, by the fountain"
  L7_2.notes = "Extra Shot Sauce"
  L6_2.fields = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L31_1
  L6_2 = A0_2
  L7_2 = L4_2
  L8_2 = "leo"
  L9_2 = 5
  L10_2 = "On the grill now! About 10 minutes."
  L11_2 = true
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L41_1
  L6_2 = A0_2
  L7_2 = {}
  L7_2.st = "preparing"
  L7_2.ago = 12
  L7_2.as = "leo"
  L7_2.owner = "tyler"
  L8_2 = {}
  L9_2 = -1110.0
  L10_2 = -1040.0
  L11_2 = 2.1
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L7_2.pos = L8_2
  L8_2 = {}
  L9_2 = {}
  L10_2 = "torpedo"
  L11_2 = 2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = {}
  L11_2 = "fries"
  L12_2 = 2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L11_2 = {}
  L12_2 = "sprunk"
  L13_2 = 2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L7_2.lines = L8_2
  L8_2 = {}
  L8_2.delivery = L3_2
  L8_2.address = "Vespucci Canals, the blue house"
  L8_2.notes = "Hungry crew, hurry!"
  L7_2.fields = L8_2
  L5_2(L6_2, L7_2)
  L5_2 = L41_1
  L6_2 = A0_2
  L7_2 = {}
  L7_2.st = "ready"
  L7_2.ago = 20
  L7_2.upd = 6
  L7_2.owner = "chloe"
  L7_2.as = "leo"
  L8_2 = {}
  L9_2 = {}
  L10_2 = "meat_free"
  L11_2 = 1
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = {}
  L11_2 = "sundae"
  L12_2 = 1
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L7_2.lines = L8_2
  L8_2 = {}
  L8_2.delivery = L2_2
  L7_2.fields = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L31_1
  L7_2 = A0_2
  L8_2 = L5_2
  L9_2 = "leo"
  L10_2 = 6
  L11_2 = "Ready at the counter, ask for Leo."
  L12_2 = true
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = L41_1
  L7_2 = A0_2
  L8_2 = {}
  L8_2.st = "onway"
  L8_2.ago = 34
  L8_2.upd = 14
  L8_2.owner = "kai"
  L8_2.as = "leo"
  L9_2 = {}
  L10_2 = -662.0
  L11_2 = -878.0
  L12_2 = 24.5
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.pos = L9_2
  L9_2 = {}
  L10_2 = {}
  L11_2 = "bleeder"
  L12_2 = 3
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L11_2 = {}
  L12_2 = "fries"
  L13_2 = 3
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L12_2 = {}
  L13_2 = "ecola"
  L14_2 = 3
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L13_2 = {}
  L14_2 = "donuts"
  L15_2 = 1
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L8_2.lines = L9_2
  L9_2 = {}
  L9_2.delivery = L3_2
  L9_2.address = "Little Seoul, office tower, 4th floor"
  L9_2.notes = "Team lunch!"
  L8_2.fields = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L31_1
  L8_2 = A0_2
  L9_2 = L6_2
  L10_2 = "kai"
  L11_2 = 30
  L12_2 = "Ring twice, the doorbell is broken."
  L13_2 = false
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L7_2 = L31_1
  L8_2 = A0_2
  L9_2 = L6_2
  L10_2 = "leo"
  L11_2 = 14
  L12_2 = "Driver just left, see you soon."
  L13_2 = true
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L7_2 = L41_1
  L8_2 = A0_2
  L9_2 = {}
  L9_2.st = "delivered"
  L9_2.ago = 150
  L9_2.upd = 110
  L9_2.owner = "mia"
  L9_2.as = "leo"
  L10_2 = {}
  L11_2 = {}
  L12_2 = "chicken"
  L13_2 = 1
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L12_2 = {}
  L13_2 = "fries"
  L14_2 = 1
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L13_2 = {}
  L14_2 = "ecola"
  L15_2 = 1
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.lines = L10_2
  L10_2 = {}
  L10_2.delivery = L2_2
  L9_2.fields = L10_2
  L7_2(L8_2, L9_2)
  L7_2 = L41_1
  L8_2 = A0_2
  L9_2 = {}
  L9_2.st = "cancelled"
  L9_2.ago = 400
  L9_2.upd = 396
  L9_2.owner = "ryan"
  L10_2 = {}
  L11_2 = {}
  L12_2 = "money_shot"
  L13_2 = 1
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L10_2[1] = L11_2
  L9_2.lines = L10_2
  L10_2 = {}
  L10_2.delivery = L2_2
  L10_2.notes = "Sorry, got a fare to the airport."
  L9_2.fields = L10_2
  L7_2(L8_2, L9_2)
  L7_2 = L41_1
  L8_2 = A0_2
  L9_2 = {}
  L9_2.st = "delivered"
  L9_2.ago = 1500
  L9_2.upd = 1460
  L9_2.owner = "me"
  L9_2.as = "leo"
  L10_2 = {}
  L11_2 = {}
  L12_2 = "bleeder"
  L13_2 = 1
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L12_2 = {}
  L13_2 = "donuts"
  L14_2 = 1
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L13_2 = {}
  L14_2 = "sprunk"
  L15_2 = 1
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.lines = L10_2
  L10_2 = {}
  L10_2.delivery = L2_2
  L9_2.fields = L10_2
  L7_2(L8_2, L9_2)
  L7_2 = L41_1
  L8_2 = A0_2
  L9_2 = {}
  L9_2.st = "delivered"
  L9_2.ago = 2900
  L9_2.upd = 2850
  L9_2.owner = "sofia"
  L9_2.as = "leo"
  L10_2 = {}
  L11_2 = -800.0
  L12_2 = -150.0
  L13_2 = 37.0
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.pos = L10_2
  L10_2 = {}
  L11_2 = {}
  L12_2 = "heart_stopper"
  L13_2 = 2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L12_2 = {}
  L13_2 = "rings"
  L14_2 = 2
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L13_2 = {}
  L14_2 = "muffin"
  L15_2 = 2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L9_2.lines = L10_2
  L10_2 = {}
  L10_2.delivery = L3_2
  L10_2.address = "Rockford Hills, open house on Eclipse Blvd"
  L9_2.fields = L10_2
  L7_2(L8_2, L9_2)
  L7_2 = L38_1
  L8_2 = A0_2
  L9_2 = "burgershot"
  L10_2 = "billing"
  L11_2 = A1_2
  L12_2 = {}
  L12_2.to = "sofia"
  L12_2.by = "leo"
  L12_2.amount = 500
  L12_2.reason = "Catering service for an open house"
  L12_2.st = "paid"
  L12_2.ago = 2900
  L12_2.upd = 2700
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = L38_1
  L8_2 = A0_2
  L9_2 = "burgershot"
  L10_2 = "billing"
  L11_2 = A1_2
  L12_2 = {}
  L12_2.to = "kai"
  L12_2.by = "leo"
  L12_2.amount = 45
  L12_2.reason = "Party box"
  L12_2.st = "pending"
  L12_2.ago = 30
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = L38_1
  L8_2 = A0_2
  L9_2 = "burgershot"
  L10_2 = "billing"
  L11_2 = A1_2
  L12_2 = {}
  L12_2.to = "tyler"
  L12_2.by = "leo"
  L12_2.amount = 15
  L12_2.reason = "Combo meal"
  L12_2.st = "paid"
  L12_2.ago = 600
  L12_2.upd = 590
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = L39_1
  L8_2 = A0_2
  L9_2 = "burgershot"
  L10_2 = "duty"
  L11_2 = "leo"
  L12_2 = A1_2
  L13_2 = 300
  L14_2 = 290
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2 = L39_1
  L8_2 = A0_2
  L9_2 = "burgershot"
  L10_2 = "duty"
  L11_2 = "leo"
  L12_2 = A1_2
  L13_2 = 1700
  L14_2 = 540
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
end
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = "bennys"
  L2_2 = {}
  L2_2.tow = "Tow truck"
  L2_2.repair = "Roadside repair"
  L2_2.tire = "Flat tire"
  L2_2.fuel = "Out of fuel"
  L3_2 = L36_1
  L4_2 = A0_2
  L5_2 = L1_2
  L6_2 = "tow"
  L7_2 = L2_2
  L8_2 = {}
  L8_2.st = "accepted"
  L8_2.ago = 6
  L8_2.upd = 4
  L8_2.owner = "me"
  L8_2.as = "marcus"
  L8_2.type = "repair"
  L9_2 = {}
  L10_2 = 215.8
  L11_2 = -810.1
  L12_2 = 30.7
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.pos = L9_2
  L8_2.msg = "Car will not start in the Legion Square garage, level 2. Battery light is on."
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = L36_1
  L4_2 = A0_2
  L5_2 = L1_2
  L6_2 = "tow"
  L7_2 = L2_2
  L8_2 = {}
  L8_2.st = "waiting"
  L8_2.ago = 12
  L8_2.owner = "mia"
  L8_2.type = "tire"
  L9_2 = {}
  L10_2 = -3170.0
  L11_2 = 1090.0
  L12_2 = 20.8
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.pos = L9_2
  L8_2.msg = "Flat tire on the Great Ocean Highway near the Chumash pier."
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = L36_1
  L4_2 = A0_2
  L5_2 = L1_2
  L6_2 = "tow"
  L7_2 = L2_2
  L8_2 = {}
  L8_2.st = "waiting"
  L8_2.ago = 31
  L8_2.owner = "emma"
  L8_2.type = "fuel"
  L9_2 = {}
  L10_2 = 1100.0
  L11_2 = -650.0
  L12_2 = 57.0
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.pos = L9_2
  L8_2.msg = "Ran out of gas on Mirror Park Blvd. So embarrassing."
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = L36_1
  L4_2 = A0_2
  L5_2 = L1_2
  L6_2 = "tow"
  L7_2 = L2_2
  L8_2 = {}
  L8_2.st = "done"
  L8_2.ago = 300
  L8_2.upd = 240
  L8_2.owner = "tyler"
  L8_2.as = "marcus"
  L8_2.type = "tow"
  L9_2 = {}
  L10_2 = 550.0
  L11_2 = 2690.0
  L12_2 = 42.0
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.pos = L9_2
  L8_2.msg = "Elegy in the ditch on Route 68. The front axle is done."
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = L36_1
  L4_2 = A0_2
  L5_2 = L1_2
  L6_2 = "tow"
  L7_2 = L2_2
  L8_2 = {}
  L8_2.st = "done"
  L8_2.ago = 2000
  L8_2.upd = 1950
  L8_2.owner = "ryan"
  L8_2.as = "marcus"
  L8_2.type = "tire"
  L9_2 = {}
  L10_2 = -1037.0
  L11_2 = -2737.0
  L12_2 = 20.2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.pos = L9_2
  L8_2.msg = "Flat tire at the airport taxi rank."
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = L36_1
  L4_2 = A0_2
  L5_2 = L1_2
  L6_2 = "tow"
  L7_2 = L2_2
  L8_2 = {}
  L8_2.st = "cancelled"
  L8_2.ago = 3500
  L8_2.upd = 3490
  L8_2.owner = "luna"
  L8_2.type = "fuel"
  L9_2 = {}
  L10_2 = -1388.4
  L11_2 = -586.6
  L12_2 = 30.2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L8_2.pos = L9_2
  L8_2.msg = "Got a ride, thanks anyway!"
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = {}
  L4_2 = {}
  L4_2.label = "Full service"
  L4_2.minutes = 60
  L3_2.service = L4_2
  L4_2 = {}
  L4_2.label = "Diagnostics"
  L4_2.minutes = 30
  L3_2.diag = L4_2
  L4_2 = {}
  L4_2.label = "Respray"
  L4_2.minutes = 120
  L3_2.respray = L4_2
  L4_2 = {}
  L4_2.label = "Performance tuning"
  L4_2.minutes = 120
  L3_2.tuning = L4_2
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = L1_2
  L7_2 = "booking"
  L8_2 = L3_2
  L9_2 = L15_1
  L10_2 = {}
  L10_2.svc = "service"
  L10_2.d = 1
  L10_2.h = 11
  L10_2.m = 0
  L10_2.st = "pending"
  L10_2.owner = "me"
  L10_2.ago = 45
  L10_2.notes = "Brakes squeal when cold and the AC smells weird."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = L1_2
  L7_2 = "booking"
  L8_2 = L3_2
  L9_2 = L15_1
  L10_2 = {}
  L10_2.svc = "tuning"
  L10_2.d = 1
  L10_2.h = 15
  L10_2.m = 0
  L10_2.st = "confirmed"
  L10_2.owner = "tyler"
  L10_2.as = "marcus"
  L10_2.ago = 600
  L10_2.upd = 560
  L10_2.notes = "More boost on the Elegy before Friday."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = L1_2
  L7_2 = "booking"
  L8_2 = L3_2
  L9_2 = L15_1
  L10_2 = {}
  L10_2.svc = "respray"
  L10_2.d = 2
  L10_2.h = 10
  L10_2.m = 0
  L10_2.st = "confirmed"
  L10_2.owner = "sofia"
  L10_2.as = "marcus"
  L10_2.ago = 1400
  L10_2.upd = 1300
  L10_2.notes = "Pearl white, like the brochure."
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = L1_2
  L7_2 = "booking"
  L8_2 = L3_2
  L9_2 = L15_1
  L10_2 = {}
  L10_2.svc = "diag"
  L10_2.d = 3
  L10_2.h = 13
  L10_2.m = 30
  L10_2.st = "pending"
  L10_2.owner = "kai"
  L10_2.ago = 200
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = L1_2
  L7_2 = "booking"
  L8_2 = L3_2
  L9_2 = L15_1
  L10_2 = {}
  L10_2.svc = "service"
  L10_2.d = -1
  L10_2.h = 10
  L10_2.m = 30
  L10_2.st = "done"
  L10_2.owner = "ryan"
  L10_2.as = "marcus"
  L10_2.ago = 3000
  L10_2.upd = 1500
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = L20_1
    A0_3.defs = L1_3
    A0_3.by = "marcus"
    L1_3 = L40_1
    L2_3 = A0_2
    L3_3 = L1_2
    L4_3 = "history"
    L5_3 = A0_3
    return L1_3(L2_3, L3_3, L4_3, L5_3)
  end
  L5_2 = L4_2
  L6_2 = {}
  L6_2.subject = "06TBR420"
  L6_2.ago = 600
  L6_2.upd = 240
  L7_2 = {}
  L8_2 = "vip"
  L7_2[1] = L8_2
  L6_2.tags = L7_2
  L7_2 = {}
  L7_2.model = "Annis Elegy RH8"
  L7_2.owner = "Tyler Brooks"
  L7_2.mileage = 48210
  L7_2.work = "Tuning"
  L7_2.cost = 4500
  L7_2.notes = "Stage 2 turbo and a new intercooler. Customer warned about street use."
  L6_2.fields = L7_2
  L5_2 = L5_2(L6_2)
  L6_2 = L31_1
  L7_2 = A0_2
  L8_2 = L5_2
  L9_2 = "marcus"
  L10_2 = 590
  L11_2 = "Dyno run: 512 hp at the wheels."
  L12_2 = true
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = L31_1
  L7_2 = A0_2
  L8_2 = L5_2
  L9_2 = "marcus"
  L10_2 = 240
  L11_2 = "Towed in again from Route 68. Front axle replaced."
  L12_2 = true
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = L4_2
  L7_2 = {}
  L7_2.subject = "SOFIA 07"
  L7_2.ago = 2600
  L8_2 = {}
  L9_2 = "warranty"
  L8_2[1] = L9_2
  L7_2.tags = L8_2
  L8_2 = {}
  L8_2.model = "Enus Cognoscenti"
  L8_2.owner = "Sofia Vega"
  L8_2.mileage = 12850
  L8_2.work = "Respray"
  L8_2.cost = 1500
  L8_2.notes = "Pearl white respray with ceramic coating."
  L7_2.fields = L8_2
  L6_2(L7_2)
  L6_2 = L4_2
  L7_2 = {}
  L7_2.subject = "41RYC512"
  L7_2.ago = 1500
  L8_2 = {}
  L9_2 = "unpaid"
  L8_2[1] = L9_2
  L7_2.tags = L8_2
  L8_2 = {}
  L8_2.model = "Vapid Stanier taxi"
  L8_2.owner = "Ryan Cole"
  L8_2.mileage = 301440
  L8_2.work = "Service"
  L8_2.cost = 450
  L8_2.notes = "Oil, filters and brake pads. Rear suspension is worn, quote sent."
  L7_2.fields = L8_2
  L6_2(L7_2)
  L6_2 = L4_2
  L7_2 = {}
  L7_2.subject = "2KAI114"
  L7_2.ago = 5000
  L8_2 = {}
  L9_2 = "warranty"
  L10_2 = "vip"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L7_2.tags = L8_2
  L8_2 = {}
  L8_2.model = "Pfister Neon"
  L8_2.owner = "Kai Nakamura"
  L8_2.mileage = 6900
  L8_2.work = "Tires"
  L8_2.cost = 600
  L8_2.notes = "Performance tires fitted. Software update done."
  L7_2.fields = L8_2
  L6_2(L7_2)
end
function L46_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = "weazel"
  L2_2 = L37_1
  L3_2 = A0_2
  L4_2 = L1_2
  L5_2 = "news"
  L6_2 = {}
  L6_2.by = "nina"
  L6_2.ago = 15
  L6_2.title = "Pileup closes the Del Perro Freeway exit"
  L7_2 = A0_2.img
  L8_2 = "weazelpileup"
  L9_2 = 1080
  L10_2 = 720
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.image = L7_2
  L6_2.body = "Emergency crews are on scene at the Del Perro Freeway off ramp after a three car crash. Expect delays heading into Vespucci. One person was taken to Pillbox Medical."
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = L37_1
  L3_2 = A0_2
  L4_2 = L1_2
  L5_2 = "news"
  L6_2 = {}
  L6_2.by = "nina"
  L6_2.pinned = true
  L6_2.ago = 45
  L6_2.title = "Vinewood Marathon: 4,000 runners sign up"
  L7_2 = A0_2.img
  L8_2 = "weazelmarathon"
  L9_2 = 1080
  L10_2 = 720
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.image = L7_2
  L6_2.body = "The biggest race in the city is back on Sunday. Runners start at Legion Square and finish at the Vinewood Bowl. Road closures from 6 AM."
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = L37_1
  L3_2 = A0_2
  L4_2 = L1_2
  L5_2 = "news"
  L6_2 = {}
  L6_2.by = "nina"
  L6_2.ago = 240
  L6_2.title = "Burger Shot launches the Heart Stopper"
  L7_2 = L22_1
  L8_2 = "burger/burger9.jpg"
  L7_2 = L7_2 .. L8_2
  L6_2.image = L7_2
  L6_2.body = "Two patties, two slices of cheese and a lot of sauce. Del Perro manager Leo Martinez says the line went around the block on day one."
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = L37_1
  L3_2 = A0_2
  L4_2 = L1_2
  L5_2 = "news"
  L6_2 = {}
  L6_2.by = "nina"
  L6_2.ago = 1400
  L6_2.title = "Brawl at Bahama Mamas, two arrested"
  L7_2 = A0_2.img
  L8_2 = "weazelnightclub"
  L9_2 = 1080
  L10_2 = 720
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.image = L7_2
  L6_2.body = "LSPD broke up a fight outside the Del Perro club late on Friday. Two men were arrested and the club says security will be doubled."
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = L37_1
  L3_2 = A0_2
  L4_2 = L1_2
  L5_2 = "news"
  L6_2 = {}
  L6_2.by = "nina"
  L6_2.ago = 2900
  L6_2.title = "Little Seoul startup raises 2 million"
  L7_2 = A0_2.img
  L8_2 = "weazelstartup"
  L9_2 = 1080
  L10_2 = 720
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.image = L7_2
  L6_2.body = "Founder Kai Nakamura says the money will go to new hires and a bigger office. \"We are just getting started,\" he told Weazel News."
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = L37_1
  L3_2 = A0_2
  L4_2 = L1_2
  L5_2 = "news"
  L6_2 = {}
  L6_2.by = "nina"
  L6_2.ago = 4300
  L6_2.title = "Police crack down on airfield street racing"
  L7_2 = A0_2.img
  L8_2 = "weazelracing"
  L9_2 = 1080
  L10_2 = 720
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.image = L7_2
  L6_2.body = "Officers set up checkpoints around the Sandy Shores airfield after complaints from residents about late night races."
  L2_2(L3_2, L4_2, L5_2, L6_2)
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = L13_1
    L2_3 = L21_1
    L3_3 = A0_3.f
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = A0_3.photo
    L1_3.photo = L2_3
    L2_3 = A0_3.pos
    if not L2_3 then
      L2_3 = {}
    end
    L3_3 = L30_1
    L4_3 = A0_2
    L5_3 = {}
    L6_3 = L1_2
    L5_3.app = L6_3
    L5_3.module = "tips"
    L5_3.kind = "form"
    L6_3 = A0_3.st
    L5_3.status = L6_3
    L6_3 = A0_3.f
    L6_3 = L6_3.headline
    L5_3.title = L6_3
    L6_3 = A0_3.owner
    L5_3.owner = L6_3
    L6_3 = A0_3.anon
    L5_3.anon = L6_3
    L6_3 = A0_3.as
    L5_3.as = L6_3
    L6_3 = A0_3.ago
    L5_3.ago = L6_3
    L6_3 = A0_3.upd
    L5_3.upd = L6_3
    L6_3 = L2_3[1]
    L5_3.x = L6_3
    L6_3 = L2_3[2]
    L5_3.y = L6_3
    L6_3 = L2_3[3]
    L5_3.z = L6_3
    L5_3.data = L1_3
    return L3_3(L4_3, L5_3)
  end
  L3_2 = L2_2
  L4_2 = {}
  L4_2.st = "received"
  L4_2.ago = 10
  L4_2.owner = "luna"
  L4_2.anon = true
  L5_2 = A0_2.img
  L6_2 = "weazelcelebrity"
  L7_2 = 1080
  L8_2 = 720
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L4_2.photo = L5_2
  L5_2 = {}
  L6_2 = 686.0
  L7_2 = 577.0
  L8_2 = 130.5
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L4_2.pos = L5_2
  L5_2 = {}
  L5_2.headline = "Movie star spotted at the Vinewood Bowl"
  L5_2.what = "A famous actor is rehearsing on stage right now with a full band. Nobody knows about it yet."
  L5_2.where = "Vinewood Bowl"
  L6_2 = L32_1
  L7_2 = A0_2
  L8_2 = 0
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.when = L6_2
  L4_2.f = L5_2
  L3_2(L4_2)
  L3_2 = L2_2
  L4_2 = {}
  L4_2.st = "received"
  L4_2.ago = 50
  L4_2.owner = "derek"
  L5_2 = {}
  L5_2.headline = "Courthouse elevator stuck for two hours"
  L5_2.what = "Six people, including a judge, were stuck in the elevator. Firefighters got them out."
  L5_2.where = "Courthouse, Vinewood Blvd"
  L6_2 = L32_1
  L7_2 = A0_2
  L8_2 = 0
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.when = L6_2
  L4_2.f = L5_2
  L3_2(L4_2)
  L3_2 = L2_2
  L4_2 = {}
  L4_2.st = "review"
  L4_2.ago = 130
  L4_2.upd = 55
  L4_2.owner = "mia"
  L4_2.as = "nina"
  L5_2 = A0_2.img
  L6_2 = "weazelsinkhole"
  L7_2 = 1080
  L8_2 = 720
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L4_2.photo = L5_2
  L5_2 = {}
  L6_2 = 400.0
  L7_2 = -760.0
  L8_2 = 29.3
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L4_2.pos = L5_2
  L5_2 = {}
  L5_2.headline = "Huge sinkhole on Alta Street"
  L5_2.what = "A sinkhole opened in the middle of the road this morning. Two cars almost fell in."
  L5_2.where = "Alta Street"
  L6_2 = L32_1
  L7_2 = A0_2
  L8_2 = 0
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.when = L6_2
  L4_2.f = L5_2
  L3_2 = L3_2(L4_2)
  L4_2 = L31_1
  L5_2 = A0_2
  L6_2 = L3_2
  L7_2 = "nina"
  L8_2 = 90
  L9_2 = "Great shot, Mia! Can we use your photo with credit?"
  L10_2 = true
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L31_1
  L5_2 = A0_2
  L6_2 = L3_2
  L7_2 = "mia"
  L8_2 = 55
  L9_2 = "Sure, credit Mia Torres Photography."
  L10_2 = false
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L2_2
  L5_2 = {}
  L5_2.st = "published"
  L5_2.ago = 1500
  L5_2.upd = 1380
  L5_2.owner = "me"
  L5_2.as = "nina"
  L6_2 = {}
  L6_2.headline = "Free concert at Legion Square tonight"
  L6_2.what = "A local band is setting up a stage in Legion Square. Free entry, starts at 9 PM."
  L6_2.where = "Legion Square"
  L7_2 = L32_1
  L8_2 = A0_2
  L9_2 = -1
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.when = L7_2
  L5_2.f = L6_2
  L4_2 = L4_2(L5_2)
  L5_2 = L31_1
  L6_2 = A0_2
  L7_2 = L4_2
  L8_2 = "nina"
  L9_2 = 1380
  L10_2 = "Thanks for the tip! It made the evening news."
  L11_2 = true
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = L2_2
  L6_2 = {}
  L6_2.st = "dismissed"
  L6_2.ago = 3000
  L6_2.upd = 2800
  L6_2.owner = "tyler"
  L6_2.as = "nina"
  L7_2 = {}
  L7_2.headline = "Strange lights over Sandy Shores"
  L7_2.what = "Bright lights over the airfield last night. Definitely not drones."
  L7_2.where = "Sandy Shores airfield"
  L8_2 = L32_1
  L9_2 = A0_2
  L10_2 = -2
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.when = L8_2
  L6_2.f = L7_2
  L5_2(L6_2)
end
L47_1 = {}
L47_1.Preto = "Black"
L47_1.Branco = "White"
L47_1["Azul-gelo"] = "Ice Blue"
L47_1["Bord\195\180"] = "Burgundy"
L47_1.Violeta = "Violet"
L47_1["Azul-celeste"] = "Sky Blue"
L47_1["Azul-noite"] = "Midnight Blue"
L47_1["Branco-estrela"] = "Starlight"
L47_1.Lavanda = "Lavender"
L47_1.Cinzento = "Gray"
L47_1.Creme = "Cream"
L47_1["Pist\195\161cio"] = "Pistachio"
L47_1["Preto e prata"] = "Black and Silver"
L48_1 = {}
L48_1.pear18 = 9
L48_1.s26 = 7
L48_1.airpods = 6
L48_1.pearfold = 5
L48_1.novaflip = 4
L48_1.slate_buds = 3
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L1_2 = ShopEffective
  if L1_2 then
    L1_2 = select
    L2_2 = 2
    L3_2 = pcall
    L4_2 = ShopEffective
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L3_2(L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
    if L1_2 then
      goto lbl_13
    end
  end
  L1_2 = nil
  ::lbl_13::
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = Config
    L1_2 = L2_2.Shop
  end
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2.products
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.enabled
      if false ~= L9_2 then
        L9_2 = type
        L10_2 = L8_2.variants
        L9_2 = L9_2(L10_2)
        if "table" == L9_2 then
          L9_2 = ipairs
          L10_2 = L8_2.variants
          L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
          for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
            L15_2 = type
            L16_2 = L14_2
            L15_2 = L15_2(L16_2)
            if "table" == L15_2 then
              L15_2 = type
              L16_2 = L14_2.item
              L15_2 = L15_2(L16_2)
              if "string" == L15_2 then
                L15_2 = L14_2.enabled
                if false ~= L15_2 then
                  L16_2 = L8_2.id
                  L15_2 = L48_1
                  L15_2 = L15_2[L16_2]
                  if not L15_2 then
                    L15_2 = 2
                  end
                  L16_2 = 1
                  L17_2 = L15_2
                  L18_2 = 1
                  for L19_2 = L16_2, L17_2, L18_2 do
                    L20_2 = #L2_2
                    L20_2 = L20_2 + 1
                    L21_2 = {}
                    L21_2.p = L8_2
                    L21_2.v = L14_2
                    L2_2[L20_2] = L21_2
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  L3_2 = #L2_2
  if 0 == L3_2 then
    return
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L1_2.shops
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L9_2.id
      if L10_2 then
        L10_2 = #L3_2
        L10_2 = L10_2 + 1
        L11_2 = L9_2.id
        L3_2[L10_2] = L11_2
      end
    end
  end
  L4_2 = #L3_2
  if 0 == L4_2 then
    L3_2[1] = "legion"
  end
  L4_2 = 20261004
  function L5_2(A0_3)
    local L1_3
    L1_3 = L4_2
    L1_3 = L1_3 * 1103515245
    L1_3 = L1_3 + 12345
    L1_3 = L1_3 % 2147483648
    L4_2 = L1_3
    L1_3 = L4_2
    L1_3 = L1_3 % A0_3
    L1_3 = L1_3 + 1
    return L1_3
  end
  L6_2 = os
  L6_2 = L6_2.date
  L7_2 = "*t"
  L8_2 = math
  L8_2 = L8_2.floor
  L9_2 = A0_2.now
  L9_2 = L9_2 / 1000
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
  L7_2 = 0
  L8_2 = 0
  L6_2.sec = 0
  L6_2.min = L8_2
  L6_2.hour = L7_2
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = A0_2.now
  L9_2 = os
  L9_2 = L9_2.time
  L10_2 = L6_2
  L9_2 = L9_2(L10_2)
  L9_2 = L9_2 * 1000
  L8_2 = L8_2 - L9_2
  L8_2 = L8_2 / 60000
  L7_2 = L7_2(L8_2)
  L8_2 = {}
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = Showcase
  L11_2 = L11_2.people
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L9_2[L16_2] = L15_2
  end
  L10_2 = 1
  L11_2 = 40
  L12_2 = 1
  for L13_2 = L10_2, L11_2, L12_2 do
    L14_2 = nil
    if L13_2 <= 6 then
      L15_2 = L5_2
      L16_2 = math
      L16_2 = L16_2.max
      L17_2 = 10
      L18_2 = L7_2 - 8
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L16_2(L17_2, L18_2)
      L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L15_2 = 4 + L15_2
      L14_2 = L15_2 - 1
    else
      L15_2 = L5_2
      L16_2 = 18720
      L15_2 = L15_2(L16_2)
      L14_2 = 1440 + L15_2
    end
    L15_2 = L5_2
    L16_2 = #L2_2
    L15_2 = L15_2(L16_2)
    L15_2 = L2_2[L15_2]
    L16_2 = L5_2
    L17_2 = #L9_2
    L16_2 = L16_2(L17_2)
    L16_2 = L9_2[L16_2]
    L17_2 = L16_2.cid
    L18_2 = L16_2.name
    if 3 == L13_2 then
      L19_2 = A0_2.cid
      L20_2 = A0_2.name
      if "" ~= L20_2 then
        L20_2 = A0_2.name
        if L20_2 then
          goto lbl_217
          L18_2 = L20_2 or L18_2
        end
      end
      L18_2 = A0_2.username
      ::lbl_217::
      L17_2 = L19_2
    end
    L19_2 = math
    L19_2 = L19_2.floor
    L20_2 = tonumber
    L21_2 = L15_2.v
    L21_2 = L21_2.price
    if not L21_2 then
      L21_2 = L15_2.p
      L21_2 = L21_2.price
    end
    L20_2 = L20_2(L21_2)
    if not L20_2 then
      L20_2 = 0
    end
    L19_2 = L19_2(L20_2)
    L20_2 = #L8_2
    L20_2 = L20_2 + 1
    L21_2 = {}
    L21_2.age = L14_2
    L22_2 = {}
    L22_2.cid = L17_2
    L22_2.name = L18_2
    L23_2 = L15_2.v
    L23_2 = L23_2.item
    L22_2.item = L23_2
    L23_2 = tostring
    L24_2 = L15_2.p
    L24_2 = L24_2.id
    if not L24_2 then
      L24_2 = ""
    end
    L23_2 = L23_2(L24_2)
    L24_2 = L23_2
    L23_2 = L23_2.sub
    L25_2 = 1
    L26_2 = 32
    L23_2 = L23_2(L24_2, L25_2, L26_2)
    L22_2.product = L23_2
    L23_2 = tostring
    L24_2 = L15_2.p
    L24_2 = L24_2.name
    if not L24_2 then
      L24_2 = L15_2.v
      L24_2 = L24_2.item
    end
    L23_2 = L23_2(L24_2)
    L24_2 = L5_1
    L25_2 = L15_2.v
    L26_2 = L25_2.color
    L25_2 = L47_1
    L25_2 = L25_2[L26_2]
    if not L25_2 then
      L25_2 = tostring
      L26_2 = L15_2.v
      L26_2 = L26_2.color
      if not L26_2 then
        L26_2 = ""
      end
      L25_2 = L25_2(L26_2)
    end
    L23_2 = L23_2 .. L24_2 .. L25_2
    L24_2 = L23_2
    L23_2 = L23_2.sub
    L25_2 = 1
    L26_2 = 120
    L23_2 = L23_2(L24_2, L25_2, L26_2)
    L22_2.label = L23_2
    L22_2.price = L19_2
    L23_2 = L5_2
    L24_2 = 4
    L23_2 = L23_2(L24_2)
    if 1 == L23_2 then
      L23_2 = "cash"
      if L23_2 then
        goto lbl_295
      end
    end
    L23_2 = "bank"
    ::lbl_295::
    L22_2.account = L23_2
    L23_2 = L5_2
    L24_2 = #L3_2
    L23_2 = L23_2(L24_2)
    L23_2 = L3_2[L23_2]
    L22_2.shop = L23_2
    L21_2.row = L22_2
    L8_2[L20_2] = L21_2
  end
  L10_2 = table
  L10_2 = L10_2.sort
  L11_2 = L8_2
  function L12_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.age
    L3_3 = A1_3.age
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L10_2(L11_2, L12_2)
  L10_2 = ipairs
  L11_2 = L8_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.row
    L17_2 = A0_2.ago
    L18_2 = L15_2.age
    L17_2 = L17_2(L18_2)
    L16_2.at = L17_2
    L16_2 = A0_2.insert
    L17_2 = "apex_phone_shop_sales"
    L18_2 = L15_2.row
    L16_2(L17_2, L18_2)
  end
end
function L50_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L1_2 = nil
  L2_2 = pcall
  L3_2 = GetPlayerIdentifiers
  L4_2 = A0_2.src
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = ipairs
      L5_2 = L3_2
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = tostring
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        L11_2 = L10_2
        L10_2 = L10_2.sub
        L12_2 = 1
        L13_2 = 8
        L10_2 = L10_2(L11_2, L12_2, L13_2)
        if "license:" == L10_2 then
          L1_2 = L9_2
          break
        end
      end
    end
  end
  if not L1_2 then
    L1_2 = A0_2.cid
  end
  L4_2 = A0_2.name
  if "" ~= L4_2 then
    L4_2 = A0_2.name
    if L4_2 then
      goto lbl_41
    end
  end
  L4_2 = A0_2.username
  ::lbl_41::
  L5_2 = {}
  L6_2 = {}
  L7_2 = 8640
  L8_2 = "settings.save"
  L9_2 = "4 settings changed, 1 app disabled"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L7_2 = {}
  L8_2 = 8620
  L9_2 = "webhooks.save"
  L10_2 = "Log: on"
  L11_2 = L5_1
  L12_2 = "Shop: on"
  L10_2 = L10_2 .. L11_2 .. L12_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = {}
  L9_2 = 7110
  L10_2 = "shop.save"
  L11_2 = "Shop enabled"
  L12_2 = L5_1
  L13_2 = "6 products"
  L14_2 = L5_1
  L15_2 = "2 shops"
  L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2 .. L15_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L9_2 = {}
  L10_2 = 7170
  L11_2 = "capps.save"
  L12_2 = "LSPD (lspd)"
  L13_2 = L5_1
  L14_2 = "9 modules"
  L12_2 = L12_2 .. L13_2 .. L14_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = {}
  L11_2 = 7175
  L12_2 = "capps.save"
  L13_2 = "Pillbox Medical (pillbox)"
  L14_2 = L5_1
  L15_2 = "5 modules"
  L13_2 = L13_2 .. L14_2 .. L15_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L11_2 = {}
  L12_2 = 5760
  L13_2 = "capps.save"
  L14_2 = "Burger Shot (burgershot)"
  L15_2 = L5_1
  L16_2 = "4 modules"
  L14_2 = L14_2 .. L15_2 .. L16_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L12_2 = {}
  L13_2 = 5745
  L14_2 = "capps.save"
  L15_2 = "Benny's (bennys)"
  L16_2 = L5_1
  L17_2 = "4 modules"
  L15_2 = L15_2 .. L16_2 .. L17_2
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L13_2 = {}
  L14_2 = 4320
  L15_2 = "capps.save"
  L16_2 = "Weazel News (weazel)"
  L17_2 = L5_1
  L18_2 = "3 modules"
  L16_2 = L16_2 .. L17_2 .. L18_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L14_2 = {}
  L15_2 = 4310
  L16_2 = "capps.order"
  L17_2 = "5 apps reordered"
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L15_2 = {}
  L16_2 = 2880
  L17_2 = "shop.save"
  L18_2 = "Price change: PearPhone Fold"
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L16_2 = {}
  L17_2 = 1200
  L18_2 = "settings.save"
  L19_2 = "2 settings changed, 0 apps disabled"
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L17_2 = {}
  L18_2 = 300
  L19_2 = "capps.save"
  L20_2 = "LSPD (lspd)"
  L21_2 = L5_1
  L22_2 = "9 modules"
  L20_2 = L20_2 .. L21_2 .. L22_2
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L18_2 = {}
  L19_2 = 35
  L20_2 = "shop.save"
  L21_2 = "Shop enabled"
  L22_2 = L5_1
  L23_2 = "6 products"
  L24_2 = L5_1
  L25_2 = "2 shops"
  L21_2 = L21_2 .. L22_2 .. L23_2 .. L24_2 .. L25_2
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L5_2[7] = L12_2
  L5_2[8] = L13_2
  L5_2[9] = L14_2
  L5_2[10] = L15_2
  L5_2[11] = L16_2
  L5_2[12] = L17_2
  L5_2[13] = L18_2
  L6_2 = ipairs
  L7_2 = L5_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = A0_2.insert
    L13_2 = "apex_phone_admin_log"
    L14_2 = {}
    L15_2 = A0_2.ago
    L16_2 = L11_2[1]
    L15_2 = L15_2(L16_2)
    L14_2.at = L15_2
    L14_2.admin = L4_2
    L15_2 = tostring
    L16_2 = L1_2
    L15_2 = L15_2(L16_2)
    L16_2 = L15_2
    L15_2 = L15_2.sub
    L17_2 = 1
    L18_2 = 80
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L14_2.ident = L15_2
    L15_2 = L11_2[2]
    L14_2.action = L15_2
    L15_2 = L11_2[3]
    L14_2.detail = L15_2
    L12_2(L13_2, L14_2)
  end
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = AdminSanitizeCApp
  if L1_2 then
    L1_2 = AdminStore
    if L1_2 then
      goto lbl_10
    end
  end
  L1_2 = error
  L2_2 = "admin panel not loaded (server/admin.lua)"
  L1_2(L2_2)
  ::lbl_10::
  L1_2 = type
  L2_2 = Config
  L2_2 = L2_2.CustomApps
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = Config
    L2_2 = L2_2.CustomApps
    L2_2 = L2_2.categories
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = Config
      L1_2 = L1_2.CustomApps
      L1_2 = L1_2.categories
      L1_2 = #L1_2
      if L1_2 > 0 then
        L1_2 = Config
        L1_2 = L1_2.CustomApps
        L1_2 = L1_2.categories
        if L1_2 then
          goto lbl_40
        end
      end
    end
  end
  L1_2 = {}
  L2_2 = "Public services"
  L3_2 = "Jobs"
  L4_2 = "Companies"
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  ::lbl_40::
  L2_2 = L26_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L25_1
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = L1_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L6_2(L7_2, L8_2, L9_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = AdminSanitizeCApp
    L12_2 = L10_2
    L11_2, L12_2, L13_2 = L11_2(L12_2)
    if not L11_2 then
      L14_2 = error
      L15_2 = "app %s rejected by the sanitizer: %s %s"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L10_2.id
      L18_2 = tostring
      L19_2 = L12_2
      L18_2 = L18_2(L19_2)
      L19_2 = tostring
      L20_2 = L13_2 or L20_2
      if not L13_2 then
        L20_2 = ""
      end
      L19_2, L20_2 = L19_2(L20_2)
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
      L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    end
    L14_2 = #L4_2
    L14_2 = L14_2 + 1
    L4_2[L14_2] = L11_2
  end
  L5_2 = L27_1
  L6_2 = A0_2
  L7_2 = L4_2
  L5_2(L6_2, L7_2)
  L5_2 = print
  L6_2 = "[apex_phone showcase] jobs: lspd=%s pillbox=%s burgershot=%s bennys=%s weazel=%s (admin job: %s)"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = table
  L8_2 = L8_2.concat
  L9_2 = L2_2.lspd
  L10_2 = ","
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = table
  L9_2 = L9_2.concat
  L10_2 = L2_2.pillbox
  L11_2 = ","
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = table
  L10_2 = L10_2.concat
  L11_2 = L2_2.burgershot
  L12_2 = ","
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = table
  L11_2 = L11_2.concat
  L12_2 = L2_2.bennys
  L13_2 = ","
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = table
  L12_2 = L12_2.concat
  L13_2 = L2_2.weazel
  L14_2 = ","
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = tostring
  L14_2 = L3_2
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L13_2(L14_2)
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  L5_2 = L42_1
  L6_2 = A0_2
  L7_2 = L2_2.lspd
  L7_2 = L7_2[1]
  L5_2(L6_2, L7_2)
  L5_2 = L43_1
  L6_2 = A0_2
  L7_2 = L2_2.pillbox
  L7_2 = L7_2[1]
  L5_2(L6_2, L7_2)
  L5_2 = L44_1
  L6_2 = A0_2
  L7_2 = L2_2.burgershot
  L7_2 = L7_2[1]
  L5_2(L6_2, L7_2)
  L5_2 = L45_1
  L6_2 = A0_2
  L5_2(L6_2)
  L5_2 = L46_1
  L6_2 = A0_2
  L5_2(L6_2)
  L5_2 = L49_1
  L6_2 = A0_2
  L5_2(L6_2)
  L5_2 = L50_1
  L6_2 = A0_2
  L5_2(L6_2)
end
function L52_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT params FROM apex_phone_showcase_rows WHERE tbl = ?"
  L5_2 = {}
  L6_2 = L2_1
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = pcall
    L9_2 = json
    L9_2 = L9_2.decode
    L10_2 = L7_2.params
    if not L10_2 then
      L10_2 = "[]"
    end
    L8_2, L9_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = tonumber
        L11_2 = L9_2[1]
        L10_2 = L10_2(L11_2)
        if L10_2 then
          goto lbl_40
        end
      end
    end
    L10_2 = nil
    ::lbl_40::
    if L10_2 then
      L11_2 = #L1_2
      L11_2 = L11_2 + 1
      L12_2 = math
      L12_2 = L12_2.floor
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      L1_2[L11_2] = L12_2
    end
  end
  L2_2 = 1
  L3_2 = #L1_2
  L4_2 = 200
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = {}
    L7_2 = L5_2
    L8_2 = math
    L8_2 = L8_2.min
    L9_2 = #L1_2
    L10_2 = L5_2 + 199
    L8_2 = L8_2(L9_2, L10_2)
    L9_2 = 1
    for L10_2 = L7_2, L8_2, L9_2 do
      L11_2 = #L6_2
      L11_2 = L11_2 + 1
      L12_2 = L1_2[L10_2]
      L6_2[L11_2] = L12_2
    end
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "DELETE FROM apex_phone_capp_notes WHERE item IN ("
    L9_2 = "?,"
    L10_2 = L9_2
    L9_2 = L9_2.rep
    L11_2 = #L6_2
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = L9_2
    L9_2 = L9_2.sub
    L11_2 = 1
    L12_2 = -2
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = ")"
    L8_2 = L8_2 .. L9_2 .. L10_2
    L9_2 = L6_2
    L7_2(L8_2, L9_2)
  end
  L2_2 = AdminStore
  if L2_2 then
    L2_2 = AdminStore
    L2_2 = L2_2.Get
    L3_2 = L0_1
    L2_2 = L2_2(L3_2)
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = ipairs
    L4_2 = type
    L5_2 = L2_2.added
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = L2_2.added
      if L4_2 then
        goto lbl_114
      end
    end
    L4_2 = {}
    ::lbl_114::
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "string" == L9_2 then
        L10_2 = L8_2
        L9_2 = L8_2.match
        L11_2 = "^[a-z0-9_]+$"
        L9_2 = L9_2(L10_2, L11_2)
        if L9_2 then
          L9_2 = MySQL
          L9_2 = L9_2.query
          L9_2 = L9_2.await
          L10_2 = "SELECT id FROM apex_phone_capp_items WHERE app = ?"
          L11_2 = {}
          L12_2 = L8_2
          L11_2[1] = L12_2
          L9_2 = L9_2(L10_2, L11_2)
          if not L9_2 then
            L9_2 = {}
          end
          L10_2 = {}
          L11_2 = ipairs
          L12_2 = L9_2
          L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
          for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
            L17_2 = #L10_2
            L17_2 = L17_2 + 1
            L18_2 = tonumber
            L19_2 = L16_2.id
            L18_2 = L18_2(L19_2)
            L10_2[L17_2] = L18_2
          end
          L11_2 = 1
          L12_2 = #L10_2
          L13_2 = 200
          for L14_2 = L11_2, L12_2, L13_2 do
            L15_2 = {}
            L16_2 = L14_2
            L17_2 = math
            L17_2 = L17_2.min
            L18_2 = #L10_2
            L19_2 = L14_2 + 199
            L17_2 = L17_2(L18_2, L19_2)
            L18_2 = 1
            for L19_2 = L16_2, L17_2, L18_2 do
              L20_2 = #L15_2
              L20_2 = L20_2 + 1
              L21_2 = L10_2[L19_2]
              L15_2[L20_2] = L21_2
            end
            L16_2 = MySQL
            L16_2 = L16_2.update
            L16_2 = L16_2.await
            L17_2 = "DELETE FROM apex_phone_capp_notes WHERE item IN ("
            L18_2 = "?,"
            L19_2 = L18_2
            L18_2 = L18_2.rep
            L20_2 = #L15_2
            L18_2 = L18_2(L19_2, L20_2)
            L19_2 = L18_2
            L18_2 = L18_2.sub
            L20_2 = 1
            L21_2 = -2
            L18_2 = L18_2(L19_2, L20_2, L21_2)
            L19_2 = ")"
            L17_2 = L17_2 .. L18_2 .. L19_2
            L18_2 = L15_2
            L16_2(L17_2, L18_2)
          end
          L11_2 = MySQL
          L11_2 = L11_2.update
          L11_2 = L11_2.await
          L12_2 = "DELETE FROM apex_phone_capp_items WHERE app = ?"
          L13_2 = {}
          L14_2 = L8_2
          L13_2[1] = L14_2
          L11_2(L12_2, L13_2)
        end
      end
    end
    L3_2 = L28_1
    L4_2 = A0_2
    L3_2(L4_2)
  end
end
L53_1 = Showcase
L53_1 = L53_1.register
L54_1 = "jobs"
L55_1 = 60
L56_1 = L51_1
L57_1 = L52_1
L53_1(L54_1, L55_1, L56_1, L57_1)
