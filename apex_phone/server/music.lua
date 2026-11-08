local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1, L87_1, L88_1, L89_1, L90_1
L0_1 = Config
L0_1 = L0_1.Music
if L0_1 then
  L0_1 = Config
  L0_1 = L0_1.Music
  L0_1 = L0_1.Provider
  if L0_1 then
    goto lbl_12
  end
end
L0_1 = "internal"
::lbl_12::
L1_1 = "internal" == L0_1 or "" == L0_1 or nil == L0_1
L2_1 = nil
L3_1 = Config
L3_1 = L3_1.Music
if not L3_1 then
  L3_1 = {}
end
L4_1 = L1_1 or L4_1
if L1_1 then
  L4_1 = L3_1.Search
  L4_1 = false ~= L4_1
end
L5_1 = type
L6_1 = L3_1.SearchRegion
L5_1 = L5_1(L6_1)
if "string" == L5_1 then
  L5_1 = L3_1.SearchRegion
  L6_1 = L5_1
  L5_1 = L5_1.match
  L7_1 = "^%a%a$"
  L5_1 = L5_1(L6_1, L7_1)
  if L5_1 then
    L5_1 = L3_1.SearchRegion
    L6_1 = L5_1
    L5_1 = L5_1.upper
    L5_1 = L5_1(L6_1)
    if L5_1 then
      goto lbl_51
    end
  end
end
L5_1 = "US"
::lbl_51::
L6_1 = Config
L6_1 = L6_1.RateLimit
L7_1 = type
L8_1 = L6_1
L7_1 = L7_1(L8_1)
if "table" == L7_1 then
  L7_1 = type
  L8_1 = L6_1.costs
  L7_1 = L7_1(L8_1)
  if "table" ~= L7_1 then
    L7_1 = {}
    L6_1.costs = L7_1
  end
  L7_1 = L6_1.costs
  L7_1 = L7_1["music.search"]
  if nil == L7_1 then
    L7_1 = L6_1.costs
    L7_1["music.search"] = 2
  end
  L7_1 = L6_1.costs
  L7_1 = L7_1["music.alt"]
  if nil == L7_1 then
    L7_1 = L6_1.costs
    L7_1["music.alt"] = 2
  end
  L7_1 = L6_1.costs
  L7_1 = L7_1["music.radio"]
  if nil == L7_1 then
    L7_1 = L6_1.costs
    L7_1["music.radio"] = 2
  end
end
L6_1 = {}
L7_1 = {}
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = tostring
  L3_2 = A0_2.vid
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = {}
  L4_2 = "yt:"
  L5_2 = L2_2
  L4_2 = L4_2 .. L5_2
  L3_2.id = L4_2
  L3_2.vid = L2_2
  L4_2 = A0_2.t
  if not L4_2 then
    L4_2 = "Faixa "
    L5_2 = A1_2
    L4_2 = L4_2 .. L5_2
  end
  L3_2.t = L4_2
  L4_2 = A0_2.a
  if not L4_2 then
    L4_2 = "Desconhecido"
  end
  L3_2.a = L4_2
  L4_2 = A0_2.alb
  if not L4_2 then
    L4_2 = ""
  end
  L3_2.alb = L4_2
  L4_2 = tonumber
  L5_2 = A0_2.len
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.len = L4_2
  if "" ~= L2_2 then
    L4_2 = "https://i.ytimg.com/vi/"
    L5_2 = L2_2
    L6_2 = "/mqdefault.jpg"
    L4_2 = L4_2 .. L5_2 .. L6_2
    if L4_2 then
      goto lbl_47
    end
  end
  L4_2 = nil
  ::lbl_47::
  L3_2.img = L4_2
  return L3_2
end
L9_1 = CreateThread
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L1_1
  if not L0_2 then
    return
  end
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = Config
  L2_2 = L2_2.Music
  if not L2_2 then
    L2_2 = {}
  end
  L2_2 = L2_2.Library
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L8_1
    L8_2 = L6_2
    L9_2 = L5_2
    L7_2 = L7_2(L8_2, L9_2)
    L8_2 = L6_1
    L8_2 = #L8_2
    L9_2 = L8_2 + 1
    L8_2 = L6_1
    L8_2[L9_2] = L7_2
    L8_2 = L6_2.shelf
    if not L8_2 then
      L8_2 = "Do servidor"
    end
    L9_2 = L7_1
    L9_2 = L9_2[L8_2]
    if not L9_2 then
      L9_2 = L7_1
      L10_2 = {}
      L9_2[L8_2] = L10_2
      L9_2 = #L0_2
      L9_2 = L9_2 + 1
      L0_2[L9_2] = L8_2
    end
    L9_2 = table
    L9_2 = L9_2.insert
    L10_2 = L7_1
    L10_2 = L10_2[L8_2]
    L11_2 = L7_2
    L9_2(L10_2, L11_2)
  end
  L7_1.__order = L0_2
  L1_2 = print
  L2_2 = "[unique_phone] music: built-in catalogue with %d track(s) in %d shelf(s), open YouTube search %s (Config.Music.Search), no dependencies"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = L6_1
  L4_2 = #L4_2
  L5_2 = #L0_2
  L6_2 = L4_1
  if L6_2 then
    L6_2 = "ON"
    if L6_2 then
      goto lbl_70
    end
  end
  L6_2 = "OFF"
  ::lbl_70::
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
end
L9_1(L10_1)
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = L7_1.__order
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = #L0_2
    L7_2 = L7_2 + 1
    L8_2 = {}
    L8_2.title = L6_2
    L8_2.kind = "track"
    L9_2 = L7_1
    L9_2 = L9_2[L6_2]
    L8_2.items = L9_2
    L0_2[L7_2] = L8_2
  end
  return L0_2
end
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = {}
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L6_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.alb
    if "" ~= L8_2 then
      L8_2 = L7_2.alb
      L8_2 = L0_2[L8_2]
      if not L8_2 then
        L8_2 = L7_2.alb
        L0_2[L8_2] = true
        L8_2 = #L1_2
        L8_2 = L8_2 + 1
        L9_2 = {}
        L9_2.kind = "album"
        L10_2 = "alb:"
        L11_2 = L7_2.alb
        L10_2 = L10_2 .. L11_2
        L9_2.id = L10_2
        L10_2 = L7_2.alb
        L9_2.t = L10_2
        L10_2 = L7_2.a
        L9_2.a = L10_2
        L10_2 = L7_2.img
        L9_2.img = L10_2
        L1_2[L8_2] = L9_2
      end
    end
  end
  return L1_2
end
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = tostring
  L3_2 = A0_2.t
  L2_2 = L2_2(L3_2)
  L3_2 = " "
  L4_2 = tostring
  L5_2 = A0_2.a
  L4_2 = L4_2(L5_2)
  L5_2 = " "
  L6_2 = tostring
  L7_2 = A0_2.alb
  L6_2 = L6_2(L7_2)
  L2_2 = L2_2 .. L3_2 .. L4_2 .. L5_2 .. L6_2
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L4_2 = L2_2
  L3_2 = L2_2.find
  L5_2 = A1_2
  L6_2 = 1
  L7_2 = true
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L3_2 = nil ~= L3_2
  return L3_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if "" == A0_2 then
    L1_2 = {}
    L1_2.q = A0_2
    L1_2.top = nil
    L2_2 = {}
    L1_2.shelves = L2_2
    return L1_2
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L6_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L11_1
    L9_2 = L7_2
    L10_2 = A0_2
    L8_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L8_2 = #L1_2
      L8_2 = L8_2 + 1
      L1_2[L8_2] = L7_2
    end
  end
  L2_2 = {}
  L3_2 = #L1_2
  if L3_2 > 0 then
    L3_2 = #L2_2
    L3_2 = L3_2 + 1
    L4_2 = {}
    L4_2.title = "M\195\186sicas"
    L4_2.kind = "track"
    L4_2.items = L1_2
    L2_2[L3_2] = L4_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L10_1
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L5_2()
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = tostring
    L11_2 = L9_2.t
    L10_2 = L10_2(L11_2)
    L11_2 = L10_2
    L10_2 = L10_2.lower
    L10_2 = L10_2(L11_2)
    L11_2 = L10_2
    L10_2 = L10_2.find
    L12_2 = A0_2
    L13_2 = 1
    L14_2 = true
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
    if not L10_2 then
      L10_2 = tostring
      L11_2 = L9_2.a
      L10_2 = L10_2(L11_2)
      L11_2 = L10_2
      L10_2 = L10_2.lower
      L10_2 = L10_2(L11_2)
      L11_2 = L10_2
      L10_2 = L10_2.find
      L12_2 = A0_2
      L13_2 = 1
      L14_2 = true
      L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      if not L10_2 then
        goto lbl_87
      end
    end
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L3_2[L10_2] = L9_2
    ::lbl_87::
  end
  L4_2 = #L3_2
  if L4_2 > 0 then
    L4_2 = #L2_2
    L4_2 = L4_2 + 1
    L5_2 = {}
    L5_2.title = "\195\129lbuns"
    L5_2.kind = "card"
    L5_2.items = L3_2
    L2_2[L4_2] = L5_2
  end
  L4_2 = {}
  L4_2.q = A0_2
  L5_2 = L1_2[1]
  L4_2.top = L5_2
  L4_2.shelves = L2_2
  return L4_2
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = {}
  if "" == A0_2 then
    return L1_2
  end
  L2_2 = ipairs
  L3_2 = L6_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = tostring
    L9_2 = L7_2.t
    L8_2 = L8_2(L9_2)
    L9_2 = L8_2
    L8_2 = L8_2.lower
    L8_2 = L8_2(L9_2)
    L9_2 = L8_2
    L8_2 = L8_2.find
    L10_2 = A0_2
    L11_2 = 1
    L12_2 = true
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
    if L8_2 then
      L8_2 = #L1_2
      if L8_2 < 6 then
        L8_2 = #L1_2
        L8_2 = L8_2 + 1
        L9_2 = L7_2.t
        L1_2[L8_2] = L9_2
      end
    end
  end
  return L1_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L6_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.vid
    if L8_2 ~= A0_2 then
      L8_2 = #L1_2
      L8_2 = L8_2 + 1
      L1_2[L8_2] = L7_2
    end
  end
  L2_2 = #L1_2
  L3_2 = 2
  L4_2 = -1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = math
    L6_2 = L6_2.random
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    L7_2 = L1_2[L6_2]
    L8_2 = L1_2[L5_2]
    L1_2[L6_2] = L8_2
    L1_2[L5_2] = L7_2
  end
  return L1_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT data FROM apex_phone_music WHERE citizenid = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L1_2.data
    if L2_2 then
      goto lbl_21
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_21::
  L2_2 = pcall
  L3_2 = json
  L3_2 = L3_2.decode
  L4_2 = L1_2.data
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  L4_2 = L3_2 or L4_2
  if not L2_2 or not L3_2 then
    L4_2 = nil
  end
  return L4_2
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A0_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = json
  L2_2 = L2_2.encode
  L3_2 = A1_2 or L3_2
  if not A1_2 then
    L3_2 = {}
  end
  L2_2 = L2_2(L3_2)
  L3_2 = #L2_2
  L4_2 = 400000
  if L3_2 > L4_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO apex_phone_music (citizenid, data, updated) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data), updated = VALUES(updated)"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = L2_2
  L8_2 = Now
  L8_2 = L8_2()
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
L17_1 = {}
L18_1 = {}
L18_1.host = "https://music.youtube.com"
L18_1.key = "AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30"
L18_1.name = "WEB_REMIX"
L18_1.version = "1.20241202.01.00"
L18_1.num = "67"
L17_1.music = L18_1
L18_1 = {}
L18_1.host = "https://www.youtube.com"
L18_1.key = "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8"
L18_1.name = "WEB"
L18_1.version = "2.20241202.07.00"
L18_1.num = "1"
L17_1.web = L18_1
L18_1 = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
L19_1 = 6500
L20_1 = 3000
L21_1 = 5000
L22_1 = 6500
L23_1 = 3000000
L24_1 = 20
L25_1 = 24
L26_1 = {}
L27_1 = {}
L26_1.hit = L27_1
L27_1 = {}
L26_1.order = L27_1
L27_1 = 300
L28_1 = {}
L29_1 = 0
L30_1 = 0
L31_1 = math
L31_1 = L31_1.huge
L31_1 = -L31_1
L32_1 = {}
L33_1 = {}
L33_1.http = 0
L33_1.fail = 0
L33_1.hits = 0
L33_1.lastErr = nil
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
  L3_2 = "^%s+"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+$"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L35_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = A0_2
  L2_2 = 1
  L3_2 = select
  L4_2 = "#"
  L5_2, L6_2, L7_2, L8_2 = ...
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = type
    L7_2 = L1_2
    L6_2 = L6_2(L7_2)
    if "table" ~= L6_2 then
      L6_2 = nil
      return L6_2
    end
    L6_2 = select
    L7_2 = L5_2
    L8_2 = ...
    L6_2 = L6_2(L7_2, L8_2)
    L1_2 = L1_2[L6_2]
  end
  return L1_2
end
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2.simpleText
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = A0_2.simpleText
    if "" ~= L1_2 then
      L1_2 = A0_2.simpleText
      return L1_2
    end
  end
  L1_2 = A0_2.runs
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = type
      L10_2 = L8_2.text
      L9_2 = L9_2(L10_2)
      if "string" == L9_2 then
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L10_2 = L8_2.text
        L2_2[L9_2] = L10_2
      end
    end
  end
  L3_2 = table
  L3_2 = L3_2.concat
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2 or L4_2
  if "" == L3_2 or not L3_2 then
    L4_2 = nil
  end
  return L4_2
end
function L37_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L34_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = L37_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
    return L1_2
  end
  L1_2 = 0
  L3_2 = A0_2
  L2_2 = A0_2.gmatch
  L4_2 = "%d+"
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = L1_2 * 60
    L8_2 = tonumber
    L9_2 = L6_2
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L8_2 = 0
    end
    L1_2 = L7_2 + L8_2
  end
  return L1_2
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if 11 == L1_2 then
      goto lbl_11
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_11::
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^[%w_%-]+$"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    return A0_2
  end
  L1_2 = nil
  return L1_2
end
function L40_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L35_1
  L2_2 = A0_2
  L3_2 = "thumbnail"
  L4_2 = "musicThumbnailRenderer"
  L5_2 = "thumbnail"
  L6_2 = "thumbnails"
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  if not L1_2 then
    L1_2 = L35_1
    L2_2 = A0_2
    L3_2 = "thumbnailRenderer"
    L4_2 = "musicThumbnailRenderer"
    L5_2 = "thumbnail"
    L6_2 = "thumbnails"
    L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
    if not L1_2 then
      L1_2 = L35_1
      L2_2 = A0_2
      L3_2 = "thumbnail"
      L4_2 = "thumbnails"
      L1_2 = L1_2(L2_2, L3_2, L4_2)
    end
  end
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = nil
  L3_2 = -1
  L4_2 = ipairs
  L5_2 = L1_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = tonumber
      L11_2 = L9_2.width
      L10_2 = L10_2(L11_2)
      if L10_2 then
        goto lbl_48
      end
    end
    L10_2 = 0
    ::lbl_48::
    L11_2 = type
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = type
      L12_2 = L9_2.url
      L11_2 = L11_2(L12_2)
      if "string" == L11_2 and L3_2 < L10_2 then
        L11_2 = L9_2.url
        L3_2 = L10_2
        L2_2 = L11_2
      end
    end
  end
  if L2_2 then
    L4_2 = #L2_2
    L5_2 = 400
    if not (L4_2 > L5_2) then
      goto lbl_74
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_74::
  L5_2 = L2_2
  L4_2 = L2_2.find
  L6_2 = "^https://[%w%-]+%.googleusercontent%.com/"
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = L2_2
    L4_2 = L2_2.find
    L6_2 = "^https://[%w%-]+%.ggpht%.com/"
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = nil
      return L4_2
    end
  end
  L5_2 = L2_2
  L4_2 = L2_2.gsub
  L6_2 = "=w%d+%-h%d+"
  L7_2 = "=w400-h400"
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L2_2 = L4_2
  return L2_2
end
function L41_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L34_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "%s+%-%s+Topic$"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  return A0_2
end
function L42_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if not A2_2 then
    L4_2 = {}
    A2_2 = L4_2
  end
  if not A3_2 then
    A3_2 = 0
  end
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 or A3_2 > 48 then
    return A2_2
  end
  L4_2 = 1
  L5_2 = #A0_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L42_1
    L9_2 = A0_2[L7_2]
    L10_2 = A1_2
    L11_2 = A2_2
    L12_2 = A3_2 + 1
    L8_2(L9_2, L10_2, L11_2, L12_2)
  end
  L4_2 = {}
  L5_2 = pairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    if "string" == L11_2 then
      L11_2 = type
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if "table" == L11_2 then
        L11_2 = #L4_2
        L11_2 = L11_2 + 1
        L4_2[L11_2] = L9_2
      end
    end
  end
  L5_2 = table
  L5_2 = L5_2.sort
  L6_2 = L4_2
  L5_2(L6_2)
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    if L10_2 == A1_2 then
      L11_2 = #A2_2
      L11_2 = L11_2 + 1
      L12_2 = A0_2[L10_2]
      A2_2[L11_2] = L12_2
    else
      L11_2 = L42_1
      L12_2 = A0_2[L10_2]
      L13_2 = A1_2
      L14_2 = A2_2
      L15_2 = A3_2 + 1
      L11_2(L12_2, L13_2, L14_2, L15_2)
    end
  end
  return A2_2
end
function L43_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L26_1.hit
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L1_2.at
  L2_2 = L2_2 - L3_2
  L3_2 = L1_2.ttl
  if L2_2 > L3_2 then
    L2_2 = L26_1.hit
    L2_2[A0_2] = nil
    L2_2 = nil
    return L2_2
  end
  L2_2 = L1_2.val
  return L2_2
end
function L44_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L26_1.hit
  L3_2 = L3_2[A0_2]
  if nil == L3_2 then
    L3_2 = L26_1.order
    L4_2 = L26_1.order
    L4_2 = #L4_2
    L4_2 = L4_2 + 1
    L3_2[L4_2] = A0_2
    while true do
      L3_2 = L26_1.order
      L3_2 = #L3_2
      L4_2 = L27_1
      if not (L3_2 > L4_2) then
        break
      end
      L3_2 = table
      L3_2 = L3_2.remove
      L4_2 = L26_1.order
      L5_2 = 1
      L3_2 = L3_2(L4_2, L5_2)
      L4_2 = L26_1.hit
      L4_2[L3_2] = nil
    end
  end
  L3_2 = L26_1.hit
  L4_2 = {}
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L4_2.at = L5_2
  L4_2.ttl = A2_2
  L4_2.val = A1_2
  L3_2[A0_2] = L4_2
end
function L45_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = L43_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if nil ~= L2_2 then
    L3_2 = L33_1.hits
    L3_2 = L3_2 + 1
    L33_1.hits = L3_2
    return L2_2
  end
  L3_2 = L28_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L4_2 = promise
    L4_2 = L4_2.new
    L4_2 = L4_2()
    L5_2 = #L3_2
    L5_2 = L5_2 + 1
    L3_2[L5_2] = L4_2
    L5_2 = Citizen
    L5_2 = L5_2.Await
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = L5_2.v
      if L6_2 then
        goto lbl_35
      end
    end
    L6_2 = nil
    ::lbl_35::
    return L6_2
  end
  L4_2 = L28_1
  L5_2 = {}
  L4_2[A0_2] = L5_2
  L4_2 = table
  L4_2 = L4_2.pack
  L5_2 = pcall
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L5_2 = nil
  L6_2 = false
  L7_2 = 0
  L8_2 = L4_2[1]
  if L8_2 then
    L8_2 = L4_2[2]
    L9_2 = L4_2[3]
    L7_2 = L4_2[4]
    L6_2 = L9_2
    L5_2 = L8_2
  else
    L8_2 = print
    L9_2 = "^1[unique_phone] music: %s failed: %s^0"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = A0_2
    L12_2 = tostring
    L13_2 = L4_2[2]
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L12_2(L13_2)
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  end
  L8_2 = L28_1
  L8_2 = L8_2[A0_2]
  if not L8_2 then
    L8_2 = {}
  end
  L9_2 = L28_1
  L9_2[A0_2] = nil
  if nil ~= L5_2 and L6_2 then
    L9_2 = L44_1
    L10_2 = A0_2
    L11_2 = L5_2
    L12_2 = tonumber
    L13_2 = L7_2
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 600000
    end
    L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = ipairs
  L10_2 = L8_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L16_2 = L14_2
    L15_2 = L14_2.resolve
    L17_2 = {}
    L17_2.v = L5_2
    L15_2(L16_2, L17_2)
  end
  return L5_2
end
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2 or A0_2
  if not L2_2 then
    A0_2 = 0
  end
  if A0_2 <= 0 then
    L2_2 = true
    return L2_2
  end
  L2_2 = L32_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L3_2 = {}
    L2_2 = L3_2
    L3_2 = L32_1
    L3_2[A0_2] = L2_2
  end
  L3_2 = 0.6
  L4_2 = 8
  if "g" == A1_2 then
    L5_2 = 3
    L4_2 = 12
    L3_2 = L5_2
  end
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L6_2 = L2_2[A1_2]
  if not L6_2 then
    L7_2 = {}
    L7_2.tokens = L4_2
    L7_2.t = L5_2
    L6_2 = L7_2
    L2_2[A1_2] = L6_2
  end
  L7_2 = math
  L7_2 = L7_2.min
  L8_2 = L4_2
  L9_2 = L6_2.tokens
  L10_2 = L6_2.t
  L10_2 = L5_2 - L10_2
  L10_2 = L10_2 * L3_2
  L10_2 = L10_2 / 1000
  L9_2 = L9_2 + L10_2
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.tokens = L7_2
  L6_2.t = L5_2
  L7_2 = L6_2.tokens
  if L7_2 < 1 then
    L7_2 = false
    return L7_2
  end
  L7_2 = L6_2.tokens
  L7_2 = L7_2 - 1
  L6_2.tokens = L7_2
  L7_2 = true
  return L7_2
end
L47_1 = AddEventHandler
L48_1 = "playerDropped"
function L49_1()
  local L0_2, L1_2
  L1_2 = source
  L0_2 = L32_1
  L0_2[L1_2] = nil
end
L47_1(L48_1, L49_1)
function L47_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L5_2 = promise
  L5_2 = L5_2.new
  L5_2 = L5_2()
  L6_2 = false
  function L7_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3
    L3_3 = L6_2
    if L3_3 then
      return
    end
    L3_3 = true
    L6_2 = L3_3
    L3_3 = math
    L3_3 = L3_3.max
    L4_3 = 0
    L5_3 = L29_1
    L5_3 = L5_3 - 1
    L3_3 = L3_3(L4_3, L5_3)
    L29_1 = L3_3
    L3_3 = L5_2
    L4_3 = L3_3
    L3_3 = L3_3.resolve
    L5_3 = {}
    L6_3 = tonumber
    L7_3 = A0_3
    L6_3 = L6_3(L7_3)
    if not L6_3 then
      L6_3 = 0
    end
    L5_3.code = L6_3
    L5_3.text = A1_3
    L5_3.err = A2_3
    L3_3(L4_3, L5_3)
  end
  L8_2 = L29_1
  L8_2 = L8_2 + 1
  L29_1 = L8_2
  L8_2 = L33_1.http
  L8_2 = L8_2 + 1
  L33_1.http = L8_2
  L8_2 = SetTimeout
  L9_2 = A4_2
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = L7_2
    L1_3 = 0
    L2_3 = nil
    L3_3 = "deadline"
    L0_3(L1_3, L2_3, L3_3)
  end
  L8_2(L9_2, L10_2)
  L8_2 = pcall
  L9_2 = PerformHttpRequest
  L10_2 = A0_2
  function L11_2(A0_3, A1_3, A2_3, A3_3)
    local L4_3, L5_3, L6_3, L7_3
    L4_3 = L7_2
    L5_3 = A0_3
    L6_3 = A1_3
    L7_3 = A3_3
    L4_3(L5_3, L6_3, L7_3)
  end
  L12_2 = A1_2 or L12_2
  if not A1_2 then
    L12_2 = "GET"
  end
  L13_2 = A2_2 or L13_2
  if not A2_2 then
    L13_2 = ""
  end
  L14_2 = A3_2 or L14_2
  if not A3_2 then
    L14_2 = {}
  end
  L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L8_2 then
    L10_2 = L7_2
    L11_2 = 0
    L12_2 = nil
    L13_2 = tostring
    L14_2 = L9_2
    L13_2, L14_2 = L13_2(L14_2)
    L10_2(L11_2, L12_2, L13_2, L14_2)
  end
  return L5_2
end
function L48_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L5_2 = L30_1
  if L4_2 < L5_2 then
    L4_2 = {}
    L4_2.fail = "limited"
    return L4_2
  end
  L4_2 = L29_1
  L5_2 = L25_1
  if L4_2 >= L5_2 then
    L4_2 = {}
    L4_2.fail = "busy"
    return L4_2
  end
  L4_2 = L17_1
  L4_2 = L4_2[A0_2]
  if not L4_2 then
    L4_2 = L17_1.music
  end
  L5_2 = {}
  L6_2 = pairs
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = {}
  end
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L5_2[L10_2] = L11_2
  end
  L6_2 = {}
  L7_2 = {}
  L8_2 = L4_2.name
  L7_2.clientName = L8_2
  L8_2 = L4_2.version
  L7_2.clientVersion = L8_2
  L7_2.hl = "en"
  L8_2 = L5_1
  L7_2.gl = L8_2
  L7_2.timeZone = "UTC"
  L7_2.utcOffsetMinutes = 0
  L6_2.client = L7_2
  L7_2 = {}
  L7_2.lockedSafetyMode = false
  L6_2.user = L7_2
  L5_2.context = L6_2
  L6_2 = pcall
  L7_2 = json
  L7_2 = L7_2.encode
  L8_2 = L5_2
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "string" == L8_2 then
      goto lbl_71
    end
  end
  L8_2 = {}
  L8_2.fail = "bad"
  do return L8_2 end
  ::lbl_71::
  L8_2 = L4_2.host
  L9_2 = "/youtubei/v1/"
  L10_2 = A1_2
  L11_2 = "?key="
  L12_2 = L4_2.key
  L13_2 = "&prettyPrint=false"
  L8_2 = L8_2 .. L9_2 .. L10_2 .. L11_2 .. L12_2 .. L13_2
  L9_2 = {}
  L10_2 = L47_1
  L11_2 = L8_2
  L12_2 = "POST"
  L13_2 = L7_2
  L14_2 = {}
  L14_2["Content-Type"] = "application/json"
  L15_2 = L18_1
  L14_2["User-Agent"] = L15_2
  L14_2.Accept = "*/*"
  L14_2["Accept-Language"] = "en-US,en;q=0.9"
  L15_2 = L4_2.host
  L14_2.Origin = L15_2
  L15_2 = L4_2.host
  L16_2 = "/"
  L15_2 = L15_2 .. L16_2
  L14_2.Referer = L15_2
  L15_2 = L4_2.num
  L14_2["X-YouTube-Client-Name"] = L15_2
  L15_2 = L4_2.version
  L14_2["X-YouTube-Client-Version"] = L15_2
  L14_2.Cookie = "CONSENT=YES+cb; SOCS=CAI"
  L15_2 = A3_2
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L9_2.p = L10_2
  L10_2 = A0_2
  L11_2 = ":"
  L12_2 = A1_2
  L10_2 = L10_2 .. L11_2 .. L12_2
  L9_2.what = L10_2
  return L9_2
end
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = A0_2.fail
  if L1_2 then
    L1_2 = nil
    L2_2 = A0_2.fail
    return L1_2, L2_2
  end
  L1_2 = Citizen
  L1_2 = L1_2.Await
  L2_2 = A0_2.p
  L1_2 = L1_2(L2_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    L3_2 = "bad"
    return L2_2, L3_2
  end
  L2_2 = L1_2.code
  if 429 ~= L2_2 then
    L2_2 = L1_2.code
    if 403 ~= L2_2 then
      goto lbl_59
    end
  end
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L2_2 = L2_2 + 60000
  L30_1 = L2_2
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L31_1
  L2_2 = L2_2 - L3_2
  L3_2 = 300000
  if L2_2 > L3_2 then
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L31_1 = L2_2
    L2_2 = print
    L3_2 = "^3[unique_phone] music: YouTube answered HTTP %d to %s (too many requests from this server IP). Open search pauses for 60 s; cached results and Config.Music.Library still work.^0"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = L1_2.code
    L6_2 = A0_2.what
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = L33_1.fail
  L2_2 = L2_2 + 1
  L33_1.fail = L2_2
  L2_2 = "HTTP "
  L3_2 = L1_2.code
  L2_2 = L2_2 .. L3_2
  L33_1.lastErr = L2_2
  L2_2 = nil
  L3_2 = "limited"
  do return L2_2, L3_2 end
  ::lbl_59::
  L2_2 = L1_2.code
  if 200 == L2_2 then
    L2_2 = type
    L3_2 = L1_2.text
    L2_2 = L2_2(L3_2)
    if "string" == L2_2 then
      L2_2 = L1_2.text
      if "" ~= L2_2 then
        goto lbl_122
      end
    end
  end
  L2_2 = L33_1.fail
  L2_2 = L2_2 + 1
  L33_1.fail = L2_2
  L2_2 = L1_2.code
  if 0 == L2_2 then
    L2_2 = "no answer ("
    L3_2 = tostring
    L4_2 = L1_2.err
    if not L4_2 then
      L4_2 = "?"
    end
    L3_2 = L3_2(L4_2)
    L4_2 = ")"
    L2_2 = L2_2 .. L3_2 .. L4_2
    if L2_2 then
      goto lbl_91
    end
  end
  L2_2 = "HTTP "
  L3_2 = L1_2.code
  L2_2 = L2_2 .. L3_2
  ::lbl_91::
  L3_2 = " on "
  L4_2 = A0_2.what
  L2_2 = L2_2 .. L3_2 .. L4_2
  L33_1.lastErr = L2_2
  L2_2 = L1_2.code
  if 0 == L2_2 then
    L2_2 = L1_2.err
    if "deadline" ~= L2_2 then
      L2_2 = type
      L3_2 = L1_2.err
      L2_2 = L2_2(L3_2)
      if "string" ~= L2_2 then
        goto lbl_119
      end
      L2_2 = L1_2.err
      L3_2 = L2_2
      L2_2 = L2_2.lower
      L2_2 = L2_2(L3_2)
      L3_2 = L2_2
      L2_2 = L2_2.find
      L4_2 = "time"
      L5_2 = 1
      L6_2 = true
      L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
      if not L2_2 then
        goto lbl_119
      end
    end
    L2_2 = nil
    L3_2 = "timeout"
    return L2_2, L3_2
  end
  ::lbl_119::
  L2_2 = nil
  L3_2 = "offline"
  do return L2_2, L3_2 end
  ::lbl_122::
  L2_2 = L1_2.text
  L2_2 = #L2_2
  L3_2 = L23_1
  if L2_2 > L3_2 then
    L2_2 = nil
    L3_2 = "bad"
    return L2_2, L3_2
  end
  L2_2 = pcall
  L3_2 = json
  L3_2 = L3_2.decode
  L4_2 = L1_2.text
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_153
    end
  end
  L4_2 = L33_1.fail
  L4_2 = L4_2 + 1
  L33_1.fail = L4_2
  L4_2 = "bad JSON on "
  L5_2 = A0_2.what
  L4_2 = L4_2 .. L5_2
  L33_1.lastErr = L4_2
  L4_2 = nil
  L5_2 = "bad"
  do return L4_2, L5_2 end
  ::lbl_153::
  L4_2 = L3_2
  L5_2 = nil
  return L4_2, L5_2
end
function L50_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L6_2 = L39_1
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  A0_2 = L6_2
  L6_2 = L34_1
  L7_2 = A1_2
  L6_2 = L6_2(L7_2)
  A1_2 = L6_2
  if not A0_2 or "" == A1_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = L41_1
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = ""
  end
  L6_2 = L6_2(L7_2)
  L7_2 = {}
  L8_2 = "yt:"
  L9_2 = A0_2
  L8_2 = L8_2 .. L9_2
  L7_2.id = L8_2
  L7_2.vid = A0_2
  L9_2 = A1_2
  L8_2 = A1_2.sub
  L10_2 = 1
  L11_2 = 120
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L7_2.t = L8_2
  if "" ~= L6_2 then
    L9_2 = L6_2
    L8_2 = L6_2.sub
    L10_2 = 1
    L11_2 = 90
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if L8_2 then
      goto lbl_41
    end
  end
  L8_2 = nil
  ::lbl_41::
  L7_2.a = L8_2
  if A3_2 then
    L8_2 = L34_1
    L9_2 = A3_2
    L8_2 = L8_2(L9_2)
    if "" ~= L8_2 then
      L8_2 = L34_1
      L9_2 = A3_2
      L8_2 = L8_2(L9_2)
      L9_2 = L8_2
      L8_2 = L8_2.sub
      L10_2 = 1
      L11_2 = 90
      L8_2 = L8_2(L9_2, L10_2, L11_2)
      if L8_2 then
        goto lbl_59
      end
    end
  end
  L8_2 = nil
  ::lbl_59::
  L7_2.alb = L8_2
  L8_2 = math
  L8_2 = L8_2.max
  L9_2 = 0
  L10_2 = math
  L10_2 = L10_2.floor
  L11_2 = tonumber
  L12_2 = A4_2
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = 0
  end
  L10_2 = L10_2(L11_2)
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.len = L8_2
  L7_2.img = A5_2
  return L7_2
end
L51_1 = {}
L51_1.song = "song"
L51_1.video = "video"
L51_1.episode = "skip"
L51_1.podcast = "skip"
L51_1.artist = "skip"
L51_1.album = "skip"
L51_1.single = "skip"
L51_1.ep = "skip"
L51_1.playlist = "skip"
L51_1.profile = "skip"
L51_1.station = "skip"
L51_1.audiobook = "skip"
L51_1.channel = "skip"
L51_1.show = "skip"
function L52_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L2_2 = A0_2
  L1_2 = A0_2.lower
  L1_2 = L1_2(L2_2)
  L3_2 = L1_2
  L2_2 = L1_2.match
  L4_2 = "^[%d%.,]+[kmb]?%s+%a+$"
  L2_2 = L2_2(L3_2, L4_2)
  L2_2 = nil ~= L2_2
  return L2_2
end
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  if not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return A1_2
  end
  L2_2 = {}
  L3_2 = nil
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = L34_1
    L1_3 = table
    L1_3 = L1_3.concat
    L2_3 = L2_2
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3)
    if "" ~= L0_3 then
      L1_3 = A1_2
      L1_3 = #L1_3
      L2_3 = L1_3 + 1
      L1_3 = A1_2
      L3_3 = {}
      L3_3.text = L0_3
      L4_3 = L3_2
      L3_3.browse = L4_3
      L1_3[L2_3] = L3_3
    end
    L1_3 = {}
    L2_3 = nil
    L3_2 = L2_3
    L2_2 = L1_3
  end
  L5_2 = ipairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L10_2.text
      if L11_2 then
        goto lbl_29
      end
    end
    L11_2 = nil
    ::lbl_29::
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "string" == L12_2 then
      L13_2 = L11_2
      L12_2 = L11_2.match
      L14_2 = "^%s*\226\128\162%s*$"
      L12_2 = L12_2(L13_2, L14_2)
      if L12_2 then
        L12_2 = L4_2
        L12_2()
      else
        L12_2 = #L2_2
        L12_2 = L12_2 + 1
        L2_2[L12_2] = L11_2
        L12_2 = L35_1
        L13_2 = L10_2
        L14_2 = "navigationEndpoint"
        L15_2 = "browseEndpoint"
        L16_2 = "browseId"
        L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
        L13_2 = type
        L14_2 = L12_2
        L13_2 = L13_2(L14_2)
        if "string" == L13_2 and not L3_2 then
          L3_2 = L12_2
        end
      end
    end
  end
  L5_2 = L4_2
  L5_2()
  return A1_2
end
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = {}
  L1_2.cat = nil
  L1_2.artist = nil
  L1_2.album = nil
  L1_2.len = 0
  L1_2.skip = false
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.text
    L9_2 = L8_2
    L8_2 = L8_2.lower
    L8_2 = L8_2(L9_2)
    L9_2 = L7_2.browse
    if not L9_2 then
      L9_2 = ""
    end
    if 1 == L6_2 then
      L10_2 = L51_1
      L10_2 = L10_2[L8_2]
      if L10_2 then
        L1_2.cat = L8_2
        L10_2 = L51_1
        L10_2 = L10_2[L8_2]
        if "skip" == L10_2 then
          L1_2.skip = true
        end
    end
    else
      L11_2 = L9_2
      L10_2 = L9_2.sub
      L12_2 = 1
      L13_2 = 4
      L10_2 = L10_2(L11_2, L12_2, L13_2)
      if "MPED" ~= L10_2 then
        L11_2 = L9_2
        L10_2 = L9_2.sub
        L12_2 = 1
        L13_2 = 4
        L10_2 = L10_2(L11_2, L12_2, L13_2)
        if "MPSP" ~= L10_2 then
          goto lbl_46
        end
      end
      L1_2.skip = true
      goto lbl_85
      ::lbl_46::
      L10_2 = L37_1
      L11_2 = L7_2.text
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L10_2 = L38_1
        L11_2 = L7_2.text
        L10_2 = L10_2(L11_2)
        L1_2.len = L10_2
      else
        L11_2 = L9_2
        L10_2 = L9_2.sub
        L12_2 = 1
        L13_2 = 4
        L10_2 = L10_2(L11_2, L12_2, L13_2)
        if "MPRE" == L10_2 then
          L10_2 = L1_2.album
          if not L10_2 then
            L10_2 = L7_2.text
          end
          L1_2.album = L10_2
        else
          L10_2 = L7_2.text
          L11_2 = L10_2
          L10_2 = L10_2.match
          L12_2 = "^%d%d%d%d$"
          L10_2 = L10_2(L11_2, L12_2)
          if not L10_2 then
            L10_2 = L52_1
            L11_2 = L7_2.text
            L10_2 = L10_2(L11_2)
            if L10_2 then
            else
              L10_2 = L1_2.artist
              if not L10_2 then
                L10_2 = L7_2.text
                L1_2.artist = L10_2
              end
            end
          end
        end
      end
    end
    ::lbl_85::
  end
  return L1_2
end
function L55_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L35_1
  L2_2 = A0_2
  L3_2 = "watchEndpointMusicSupportedConfigs"
  L4_2 = "watchEndpointMusicConfig"
  L5_2 = "musicVideoType"
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L2_2 = L1_2 or L2_2
  if "string" ~= L2_2 or not L1_2 then
    L2_2 = ""
  end
  return L2_2
end
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = ipairs
  L2_2 = type
  L3_2 = A0_2.badges
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.badges
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = {}
  ::lbl_12::
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L7_2 = L6_2.liveBadgeRenderer
      if L7_2 then
        L7_2 = true
        return L7_2
      end
    end
  end
  L1_2 = false
  return L1_2
end
function L57_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = type
    L3_2 = A0_2.flexColumns
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      goto lbl_13
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_13::
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = L35_1
    L2_3 = A0_2.flexColumns
    L3_3 = A0_3
    L4_3 = "musicResponsiveListItemFlexColumnRenderer"
    L5_3 = "text"
    L6_3 = "runs"
    return L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
  end
  L3_2 = L2_2
  L4_2 = 1
  L3_2 = L3_2(L4_2)
  L4_2 = L36_1
  L5_2 = {}
  L5_2.runs = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L35_1
  L6_2 = L3_2
  L7_2 = 1
  L8_2 = "navigationEndpoint"
  L9_2 = "watchEndpoint"
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L5_2 = L35_1
    L6_2 = A0_2
    L7_2 = "overlay"
    L8_2 = "musicItemThumbnailOverlayRenderer"
    L9_2 = "content"
    L10_2 = "musicPlayButtonRenderer"
    L11_2 = "playNavigationEndpoint"
    L12_2 = "watchEndpoint"
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L6_2 = L39_1
  L7_2 = L35_1
  L8_2 = A0_2
  L9_2 = "playlistItemData"
  L10_2 = "videoId"
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  if not L6_2 then
    L6_2 = L39_1
    L7_2 = L35_1
    L8_2 = L5_2
    L9_2 = "videoId"
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L7_2(L8_2, L9_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  end
  if not L6_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = L35_1
  L8_2 = L3_2
  L9_2 = 1
  L10_2 = "navigationEndpoint"
  L11_2 = "browseEndpoint"
  L12_2 = "browseId"
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L8_2 = type
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if "string" == L8_2 then
    L9_2 = L7_2
    L8_2 = L7_2.sub
    L10_2 = 1
    L11_2 = 4
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if "MPED" ~= L8_2 then
      L9_2 = L7_2
      L8_2 = L7_2.sub
      L10_2 = 1
      L11_2 = 4
      L8_2 = L8_2(L9_2, L10_2, L11_2)
      if "MPSP" ~= L8_2 then
        goto lbl_88
      end
    end
    L8_2 = nil
    return L8_2
  end
  ::lbl_88::
  L8_2 = L55_1
  L9_2 = L5_2
  L8_2 = L8_2(L9_2)
  L10_2 = L8_2
  L9_2 = L8_2.find
  L11_2 = "PODCAST"
  L12_2 = 1
  L13_2 = true
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  if not L9_2 then
    L9_2 = L56_1
    L10_2 = A0_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      goto lbl_105
    end
  end
  L9_2 = nil
  do return L9_2 end
  ::lbl_105::
  L9_2 = {}
  L10_2 = 2
  L11_2 = 4
  L12_2 = 1
  for L13_2 = L10_2, L11_2, L12_2 do
    L14_2 = L53_1
    L15_2 = L2_2
    L16_2 = L13_2
    L15_2 = L15_2(L16_2)
    L16_2 = L9_2
    L14_2(L15_2, L16_2)
  end
  L10_2 = L54_1
  L11_2 = L9_2
  L10_2 = L10_2(L11_2)
  L11_2 = L10_2.skip
  if L11_2 then
    L11_2 = nil
    return L11_2
  end
  L11_2 = L10_2.len
  if 0 == L11_2 then
    L11_2 = L36_1
    L12_2 = L35_1
    L13_2 = A0_2
    L14_2 = "fixedColumns"
    L15_2 = 1
    L16_2 = "musicResponsiveListItemFixedColumnRenderer"
    L17_2 = "text"
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L12_2 = L37_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      L12_2 = L38_1
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      L10_2.len = L12_2
    end
  end
  if "MUSIC_VIDEO_TYPE_ATV" ~= L8_2 then
    L11_2 = L10_2.cat
    if "song" ~= L11_2 then
      goto lbl_155
    end
  end
  L11_2 = "song"
  ::lbl_155::
  if not L11_2 then
    L11_2 = "video"
  end
  L12_2 = L50_1
  L13_2 = L6_2
  L14_2 = L4_2
  L15_2 = L10_2.artist
  if not L15_2 then
    L15_2 = A1_2
  end
  L16_2 = L10_2.album
  L17_2 = L10_2.len
  L18_2 = L40_1
  L19_2 = A0_2
  L18_2, L19_2 = L18_2(L19_2)
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L13_2 = L11_2
  return L12_2, L13_2
end
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L53_1
  L2_2 = L35_1
  L3_2 = A0_2
  L4_2 = "subtitle"
  L5_2 = "runs"
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L2_2 = L1_2[1]
  if L2_2 then
    L2_2 = L1_2[1]
    L2_2 = L2_2.text
    L3_2 = L2_2
    L2_2 = L2_2.lower
    L2_2 = L2_2(L3_2)
    if "artist" == L2_2 then
      L2_2 = L36_1
      L3_2 = A0_2.title
      return L2_2(L3_2)
    end
  end
  L2_2 = nil
  return L2_2
end
function L59_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L36_1
  L2_2 = A0_2.title
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L35_1
  L3_2 = A0_2
  L4_2 = "title"
  L5_2 = "runs"
  L6_2 = 1
  L7_2 = "navigationEndpoint"
  L8_2 = "watchEndpoint"
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L2_2 then
    L2_2 = L35_1
    L3_2 = A0_2
    L4_2 = "onTap"
    L5_2 = "watchEndpoint"
    L2_2 = L2_2(L3_2, L4_2, L5_2)
  end
  L3_2 = L39_1
  L4_2 = L35_1
  L5_2 = L2_2
  L6_2 = "videoId"
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L55_1
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L6_2 = L4_2
  L5_2 = L4_2.find
  L7_2 = "PODCAST"
  L8_2 = 1
  L9_2 = true
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if L5_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L54_1
  L6_2 = L53_1
  L7_2 = L35_1
  L8_2 = A0_2
  L9_2 = "subtitle"
  L10_2 = "runs"
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = L5_2.skip
  if L6_2 then
    L6_2 = nil
    return L6_2
  end
  if "MUSIC_VIDEO_TYPE_ATV" ~= L4_2 then
    L6_2 = L5_2.cat
    if "song" ~= L6_2 then
      goto lbl_74
    end
  end
  L6_2 = "song"
  ::lbl_74::
  if not L6_2 then
    L6_2 = "video"
  end
  L7_2 = L50_1
  L8_2 = L3_2
  L9_2 = L1_2
  L10_2 = L5_2.artist
  L11_2 = L5_2.album
  L12_2 = L5_2.len
  L13_2 = L40_1
  L14_2 = A0_2
  L13_2, L14_2 = L13_2(L14_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L8_2 = L6_2
  return L7_2, L8_2
end
function L60_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L39_1
  L2_2 = A0_2.videoId
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L35_1
  L3_2 = A0_2
  L4_2 = "navigationEndpoint"
  L5_2 = "reelWatchEndpoint"
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L35_1
  L3_2 = A0_2
  L4_2 = "navigationEndpoint"
  L5_2 = "commandMetadata"
  L6_2 = "webCommandMetadata"
  L7_2 = "url"
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L4_2 = L2_2
    L3_2 = L2_2.find
    L5_2 = "/shorts/"
    L6_2 = 1
    L7_2 = true
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
    if L3_2 then
      L3_2 = nil
      return L3_2
    end
  end
  L3_2 = ipairs
  L4_2 = type
  L5_2 = A0_2.badges
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A0_2.badges
    if L4_2 then
      goto lbl_56
    end
  end
  L4_2 = {}
  ::lbl_56::
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L35_1
    L10_2 = L8_2
    L11_2 = "metadataBadgeRenderer"
    L12_2 = "style"
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L11_2 = L9_2
      L10_2 = L9_2.find
      L12_2 = "LIVE"
      L13_2 = 1
      L14_2 = true
      L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      if L10_2 then
        L10_2 = nil
        return L10_2
      end
    end
  end
  L3_2 = ipairs
  L4_2 = type
  L5_2 = A0_2.thumbnailOverlays
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A0_2.thumbnailOverlays
    if L4_2 then
      goto lbl_91
    end
  end
  L4_2 = {}
  ::lbl_91::
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L35_1
    L10_2 = L8_2
    L11_2 = "thumbnailOverlayTimeStatusRenderer"
    L12_2 = "style"
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if "LIVE" == L9_2 or "UPCOMING" == L9_2 or "SHORTS" == L9_2 then
      L10_2 = nil
      return L10_2
    end
  end
  L3_2 = L38_1
  L4_2 = L36_1
  L5_2 = A0_2.lengthText
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if L3_2 <= 0 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L36_1
  L5_2 = A0_2.title
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L36_1
  L6_2 = A0_2.ownerText
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L36_1
    L6_2 = A0_2.longBylineText
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = L36_1
      L6_2 = A0_2.shortBylineText
      L5_2 = L5_2(L6_2)
    end
  end
  L6_2 = L50_1
  L7_2 = L1_2
  L8_2 = L4_2
  L9_2 = L5_2
  L10_2 = nil
  L11_2 = L3_2
  L12_2 = nil
  return L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
end
function L61_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L39_1
  L2_2 = A0_2.videoId
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = L39_1
    L2_2 = L35_1
    L3_2 = A0_2
    L4_2 = "navigationEndpoint"
    L5_2 = "watchEndpoint"
    L6_2 = "videoId"
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L36_1
  L3_2 = A0_2.title
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L55_1
  L4_2 = L35_1
  L5_2 = A0_2
  L6_2 = "navigationEndpoint"
  L7_2 = "watchEndpoint"
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = L3_2
  L3_2 = L3_2.find
  L5_2 = "PODCAST"
  L6_2 = 1
  L7_2 = true
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L54_1
  L4_2 = L53_1
  L5_2 = L35_1
  L6_2 = A0_2
  L7_2 = "longBylineText"
  L8_2 = "runs"
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L5_2 = L35_1
    L6_2 = A0_2
    L7_2 = "shortBylineText"
    L8_2 = "runs"
    L5_2 = L5_2(L6_2, L7_2, L8_2)
  end
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = L38_1
  L5_2 = L36_1
  L6_2 = A0_2.lengthText
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2 = L50_1
  L6_2 = L1_2
  L7_2 = L2_2
  L8_2 = L3_2.artist
  L9_2 = L3_2.album
  L10_2 = L4_2
  L11_2 = L40_1
  L12_2 = A0_2
  L11_2, L12_2 = L11_2(L12_2)
  return L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
end
function L62_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L34_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = #L1_2
  L3_2 = 400
  if not (L2_2 > L3_2) then
    L3_2 = L1_2
    L2_2 = L1_2.find
    L4_2 = "%s"
    L2_2 = L2_2(L3_2, L4_2)
    if not L2_2 then
      goto lbl_15
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_15::
  L3_2 = L1_2
  L2_2 = L1_2.lower
  L2_2 = L2_2(L3_2)
  L4_2 = L2_2
  L3_2 = L2_2.find
  L5_2 = "youtube%.com/"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = L2_2
    L3_2 = L2_2.find
    L5_2 = "youtu%.be/"
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      L4_2 = L2_2
      L3_2 = L2_2.find
      L5_2 = "youtube%-nocookie%.com/"
      L3_2 = L3_2(L4_2, L5_2)
      if not L3_2 then
        L3_2 = nil
        return L3_2
      end
    end
  end
  L4_2 = L1_2
  L3_2 = L1_2.match
  L5_2 = "[?&]v=([%w_%-]+)"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = L1_2
    L3_2 = L1_2.match
    L5_2 = "youtu%.be/([%w_%-]+)"
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      L4_2 = L1_2
      L3_2 = L1_2.match
      L5_2 = "/shorts/([%w_%-]+)"
      L3_2 = L3_2(L4_2, L5_2)
      if not L3_2 then
        L4_2 = L1_2
        L3_2 = L1_2.match
        L5_2 = "/embed/([%w_%-]+)"
        L3_2 = L3_2(L4_2, L5_2)
        if not L3_2 then
          L4_2 = L1_2
          L3_2 = L1_2.match
          L5_2 = "/live/([%w_%-]+)"
          L3_2 = L3_2(L4_2, L5_2)
          if not L3_2 then
            L4_2 = L1_2
            L3_2 = L1_2.match
            L5_2 = "/v/([%w_%-]+)"
            L3_2 = L3_2(L4_2, L5_2)
          end
        end
      end
    end
  end
  L4_2 = L39_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = false
  end
  return L4_2
end
function L63_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = "q:"
  L2_2 = L34_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%s+"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L1_2 .. L2_2
  return L1_2
end
function L64_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2
  L1_2 = L48_1
  L2_2 = "music"
  L3_2 = "search"
  L4_2 = {}
  L4_2.query = A0_2
  L5_2 = L19_1
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L2_2 = L48_1
  L3_2 = "web"
  L4_2 = "search"
  L5_2 = {}
  L5_2.query = A0_2
  L5_2.params = "EgIQAQ%3D%3D"
  L6_2 = L19_1
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = L49_1
  L4_2 = L1_2
  L3_2, L4_2 = L3_2(L4_2)
  L5_2 = L49_1
  L6_2 = L2_2
  L5_2, L6_2 = L5_2(L6_2)
  if not L3_2 and not L5_2 then
    if "limited" == L4_2 or "limited" == L6_2 then
      L7_2 = "limited"
      if L7_2 then
        goto lbl_50
      end
    end
    if "busy" == L4_2 and "busy" == L6_2 then
      L7_2 = "busy"
      if L7_2 then
        goto lbl_50
      end
    end
    if "timeout" == L4_2 or "timeout" == L6_2 then
      L7_2 = "timeout"
      if L7_2 then
        goto lbl_50
      end
    end
    L7_2 = "offline"
    ::lbl_50::
    L8_2 = nil
    L9_2 = L7_2
    return L8_2, L9_2
  end
  L7_2 = {}
  L8_2 = {}
  L9_2 = {}
  function L10_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    if A0_3 then
      L3_3 = A0_3.vid
      L2_3 = L9_2
      L2_3 = L2_3[L3_3]
      if not L2_3 then
        goto lbl_9
      end
    end
    do return end
    ::lbl_9::
    if "song" == A1_3 then
      L2_3 = L7_2
      if L2_3 then
        goto lbl_15
      end
    end
    L2_3 = L8_2
    ::lbl_15::
    L3_3 = #L2_3
    L4_3 = L24_1
    if L3_3 >= L4_3 then
      return
    end
    L4_3 = A0_3.vid
    L3_3 = L9_2
    L3_3[L4_3] = true
    L3_3 = #L2_3
    L3_3 = L3_3 + 1
    L2_3[L3_3] = A0_3
  end
  L11_2 = {}
  L12_2 = {}
  if L5_2 then
    L13_2 = ipairs
    L14_2 = L42_1
    L15_2 = L5_2
    L16_2 = "videoRenderer"
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2 = L14_2(L15_2, L16_2)
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
    for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
      L19_2 = L60_1
      L20_2 = L18_2
      L19_2 = L19_2(L20_2)
      if L19_2 then
        L20_2 = #L11_2
        L20_2 = L20_2 + 1
        L11_2[L20_2] = L19_2
        L20_2 = L19_2.vid
        L21_2 = L19_2.len
        L12_2[L20_2] = L21_2
      end
    end
  end
  L13_2 = nil
  if L3_2 then
    L14_2 = L42_1
    L15_2 = L3_2
    L16_2 = "musicCardShelfRenderer"
    L14_2 = L14_2(L15_2, L16_2)
    L15_2 = nil
    L16_2 = L59_1
    L17_2 = L14_2[1]
    L16_2, L17_2 = L16_2(L17_2)
    L15_2 = L17_2
    L13_2 = L16_2
    if L13_2 then
      L16_2 = L13_2.len
      if 0 == L16_2 then
        L16_2 = L13_2.vid
        L16_2 = L12_2[L16_2]
        if L16_2 then
          L16_2 = L13_2.vid
          L16_2 = L12_2[L16_2]
          L13_2.len = L16_2
        end
      end
      L16_2 = L10_2
      L17_2 = L13_2
      L18_2 = L15_2
      L16_2(L17_2, L18_2)
    end
    L16_2 = L58_1
    L17_2 = L14_2[1]
    L16_2 = L16_2(L17_2)
    L17_2 = ipairs
    L18_2 = L14_2[1]
    if L18_2 then
      L18_2 = L42_1
      L19_2 = L14_2[1]
      L20_2 = "musicResponsiveListItemRenderer"
      L18_2 = L18_2(L19_2, L20_2)
      if L18_2 then
        goto lbl_132
      end
    end
    L18_2 = {}
    ::lbl_132::
    L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
    for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
      L23_2 = L57_1
      L24_2 = L22_2
      L25_2 = L16_2
      L23_2, L24_2 = L23_2(L24_2, L25_2)
      if L23_2 then
        L25_2 = L23_2.len
        if 0 == L25_2 then
          L25_2 = L23_2.vid
          L25_2 = L12_2[L25_2]
          if L25_2 then
            L25_2 = L23_2.vid
            L25_2 = L12_2[L25_2]
            L23_2.len = L25_2
          end
        end
        L25_2 = L10_2
        L26_2 = L23_2
        L27_2 = L24_2
        L25_2(L26_2, L27_2)
      end
    end
    L17_2 = ipairs
    L18_2 = L42_1
    L19_2 = L3_2
    L20_2 = "musicResponsiveListItemRenderer"
    L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2 = L18_2(L19_2, L20_2)
    L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
    for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
      L23_2 = L57_1
      L24_2 = L22_2
      L23_2, L24_2 = L23_2(L24_2)
      if L23_2 then
        L25_2 = L23_2.len
        if 0 == L25_2 then
          L25_2 = L23_2.vid
          L25_2 = L12_2[L25_2]
          if L25_2 then
            L25_2 = L23_2.vid
            L25_2 = L12_2[L25_2]
            L23_2.len = L25_2
          end
        end
        L25_2 = L10_2
        L26_2 = L23_2
        L27_2 = L24_2
        L25_2(L26_2, L27_2)
      end
    end
  end
  L14_2 = ipairs
  L15_2 = L11_2
  L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
  for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
    L20_2 = L10_2
    L21_2 = L19_2
    L22_2 = "video"
    L20_2(L21_2, L22_2)
  end
  L14_2 = {}
  L15_2 = #L7_2
  if L15_2 > 0 then
    L15_2 = #L14_2
    L15_2 = L15_2 + 1
    L16_2 = {}
    L16_2.title = "M\195\186sicas"
    L16_2.kind = "track"
    L16_2.items = L7_2
    L14_2[L15_2] = L16_2
  end
  L15_2 = #L8_2
  if L15_2 > 0 then
    L15_2 = #L14_2
    L15_2 = L15_2 + 1
    L16_2 = {}
    L16_2.title = "V\195\173deos"
    L16_2.kind = "track"
    L16_2.items = L8_2
    L14_2[L15_2] = L16_2
  end
  L15_2 = #L14_2
  if 0 == L15_2 and (not L3_2 or not L5_2) then
    L15_2 = nil
    L16_2 = L4_2 or L16_2
    L16_2 = L6_2 or L16_2
    if not L4_2 and not L6_2 then
      L16_2 = "offline"
    end
    return L15_2, L16_2
  end
  L15_2 = {}
  L15_2.q = A0_2
  L16_2 = L13_2 or L16_2
  if not L13_2 then
    L16_2 = L7_2[1]
    if not L16_2 then
      L16_2 = L8_2[1]
    end
  end
  L15_2.top = L16_2
  L15_2.shelves = L14_2
  L16_2 = nil
  return L15_2, L16_2
end
function L65_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L45_1
  L2_2 = "v:"
  L3_2 = A0_2
  L2_2 = L2_2 .. L3_2
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = L49_1
    L1_3 = L48_1
    L2_3 = "music"
    L3_3 = "next"
    L4_3 = {}
    L5_3 = A0_2
    L4_3.videoId = L5_3
    L4_3.isAudioOnly = true
    L5_3 = L21_1
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    L1_3 = nil
    if L0_3 then
      L2_3 = ipairs
      L3_3 = L42_1
      L4_3 = L0_3
      L5_3 = "playlistPanelVideoRenderer"
      L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3, L5_3)
      L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
      for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
        L8_3 = L61_1
        L9_3 = L7_3
        L8_3 = L8_3(L9_3)
        if L8_3 then
          L9_3 = L8_3.vid
          L10_3 = A0_2
          if L9_3 == L10_3 then
            L1_3 = L8_3
            break
          end
        end
      end
    end
    if L1_3 then
      L2_3 = L1_3
      L3_3 = true
      L4_3 = 21600000
      return L2_3, L3_3, L4_3
    end
    L2_3 = L50_1
    L3_3 = A0_2
    L4_3 = "youtu.be/"
    L5_3 = A0_2
    L4_3 = L4_3 .. L5_3
    L5_3 = nil
    L6_3 = nil
    L7_3 = 0
    L8_3 = nil
    L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3)
    L3_3 = false
    L4_3 = 0
    return L2_3, L3_3, L4_3
  end
  return L1_2(L2_2, L3_2)
end
function L66_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L45_1
  L2_2 = "r:"
  L3_2 = A0_2
  L2_2 = L2_2 .. L3_2
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = L49_1
    L1_3 = L48_1
    L2_3 = "music"
    L3_3 = "next"
    L4_3 = {}
    L5_3 = A0_2
    L4_3.videoId = L5_3
    L5_3 = "RDAMVM"
    L6_3 = A0_2
    L5_3 = L5_3 .. L6_3
    L4_3.playlistId = L5_3
    L4_3.isAudioOnly = true
    L4_3.params = "wAEB"
    L5_3 = L22_1
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
    L0_3, L1_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
    if not L0_3 then
      L2_3 = {}
      L2_3.error = L1_3
      L3_3 = false
      L4_3 = 0
      return L2_3, L3_3, L4_3
    end
    L2_3 = {}
    L3_3 = {}
    L4_3 = A0_2
    L3_3[L4_3] = true
    L4_3 = ipairs
    L5_3 = L42_1
    L6_3 = L0_3
    L7_3 = "playlistPanelVideoRenderer"
    L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3 = L5_3(L6_3, L7_3)
    L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
    for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
      L10_3 = L61_1
      L11_3 = L9_3
      L10_3 = L10_3(L11_3)
      if L10_3 then
        L11_3 = L10_3.vid
        L11_3 = L3_3[L11_3]
        if not L11_3 then
          L11_3 = L10_3.vid
          L3_3[L11_3] = true
          L11_3 = #L2_3
          L11_3 = L11_3 + 1
          L2_3[L11_3] = L10_3
          L11_3 = #L2_3
          if L11_3 >= 25 then
            break
          end
        end
      end
    end
    L4_3 = L2_3
    L5_3 = #L2_3
    L5_3 = L5_3 > 0
    L6_3 = 1800000
    return L4_3, L5_3, L6_3
  end
  return L1_2(L2_2, L3_2)
end
function L67_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%b()"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%b[]"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "[%c%p]"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  L1_2 = L34_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
function L68_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "[%c%p]"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  L1_2 = L34_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
L69_1 = {}
L70_1 = "slowed"
L71_1 = "reverb"
L72_1 = "sped up"
L73_1 = "nightcore"
L74_1 = "8d"
L75_1 = "cover"
L76_1 = "karaoke"
L77_1 = "instrumental"
L78_1 = "live"
L79_1 = "remix"
L80_1 = "piano"
L81_1 = "acoustic"
L82_1 = "reaction"
L83_1 = "tutorial"
L84_1 = "lesson"
L85_1 = "bass boosted"
L86_1 = "mashup"
L87_1 = "edit"
L88_1 = "loop"
L89_1 = "hour"
L90_1 = "mix"
L69_1[1] = L70_1
L69_1[2] = L71_1
L69_1[3] = L72_1
L69_1[4] = L73_1
L69_1[5] = L74_1
L69_1[6] = L75_1
L69_1[7] = L76_1
L69_1[8] = L77_1
L69_1[9] = L78_1
L69_1[10] = L79_1
L69_1[11] = L80_1
L69_1[12] = L81_1
L69_1[13] = L82_1
L69_1[14] = L83_1
L69_1[15] = L84_1
L69_1[16] = L85_1
L69_1[17] = L86_1
L69_1[18] = L87_1
L69_1[19] = L88_1
L69_1[20] = L89_1
L69_1[21] = L90_1
function L70_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2
  L4_2 = L45_1
  L5_2 = "a:"
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3
    L0_3 = L34_1
    L1_3 = L41_1
    L2_3 = A2_2
    if not L2_3 then
      L2_3 = ""
    end
    L1_3 = L1_3(L2_3)
    L2_3 = " "
    L3_3 = tostring
    L4_3 = A1_2
    if not L4_3 then
      L4_3 = ""
    end
    L3_3 = L3_3(L4_3)
    L1_3 = L1_3 .. L2_3 .. L3_3
    L0_3 = L0_3(L1_3)
    L1_3 = L0_3
    L0_3 = L0_3.sub
    L2_3 = 1
    L3_3 = 100
    L0_3 = L0_3(L1_3, L2_3, L3_3)
    if "" == L0_3 then
      L1_3 = {}
      L2_3 = {}
      L1_3.alts = L2_3
      L2_3 = false
      L3_3 = 0
      return L1_3, L2_3, L3_3
    end
    L1_3 = L49_1
    L2_3 = L48_1
    L3_3 = "web"
    L4_3 = "search"
    L5_3 = {}
    L5_3.query = L0_3
    L5_3.params = "EgIQAQ%3D%3D"
    L6_3 = L19_1
    L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3 = L2_3(L3_3, L4_3, L5_3, L6_3)
    L1_3, L2_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3)
    if not L1_3 then
      L3_3 = {}
      L4_3 = {}
      L3_3.alts = L4_3
      L3_3.error = L2_3
      L4_3 = false
      L5_3 = 0
      return L3_3, L4_3, L5_3
    end
    L3_3 = L67_1
    L4_3 = A1_2
    L3_3 = L3_3(L4_3)
    L4_3 = " "
    L5_3 = L68_1
    L6_3 = tostring
    L7_3 = A1_2
    if not L7_3 then
      L7_3 = ""
    end
    L6_3 = L6_3(L7_3)
    L7_3 = " "
    L8_3 = tostring
    L9_3 = A2_2
    if not L9_3 then
      L9_3 = ""
    end
    L8_3 = L8_3(L9_3)
    L6_3 = L6_3 .. L7_3 .. L8_3
    L5_3 = L5_3(L6_3)
    L6_3 = " "
    L4_3 = L4_3 .. L5_3 .. L6_3
    L5_3 = {}
    L6_3 = ipairs
    L7_3 = L42_1
    L8_3 = L1_3
    L9_3 = "videoRenderer"
    L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3 = L7_3(L8_3, L9_3)
    L6_3, L7_3, L8_3, L9_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3)
    for L10_3, L11_3 in L6_3, L7_3, L8_3, L9_3 do
      L12_3 = L60_1
      L13_3 = L11_3
      L12_3 = L12_3(L13_3)
      if L12_3 then
        L13_3 = L12_3.vid
        L14_3 = A0_2
        if L13_3 ~= L14_3 then
          L13_3 = "" == L3_3
          if L13_3 then
            L14_3 = A3_2
            if L14_3 then
              L14_3 = A3_2
              if L14_3 > 0 then
                L14_3 = math
                L14_3 = L14_3.abs
                L15_3 = L12_3.len
                L16_3 = A3_2
                L15_3 = L15_3 - L16_3
                L14_3 = L14_3(L15_3)
                L15_3 = math
                L15_3 = L15_3.max
                L16_3 = 12
                L17_3 = A3_2
                L17_3 = L17_3 * 0.08
                L15_3 = L15_3(L16_3, L17_3)
                L13_3 = L14_3 <= L15_3
              end
            end
          end
          if L13_3 then
            L14_3 = " "
            L15_3 = L68_1
            L16_3 = L12_3.t
            L15_3 = L15_3(L16_3)
            L16_3 = " "
            L14_3 = L14_3 .. L15_3 .. L16_3
            L15_3 = ipairs
            L16_3 = L69_1
            L15_3, L16_3, L17_3, L18_3 = L15_3(L16_3)
            for L19_3, L20_3 in L15_3, L16_3, L17_3, L18_3 do
              L22_3 = L14_3
              L21_3 = L14_3.find
              L23_3 = " "
              L24_3 = L20_3
              L25_3 = " "
              L23_3 = L23_3 .. L24_3 .. L25_3
              L24_3 = 1
              L25_3 = true
              L21_3 = L21_3(L22_3, L23_3, L24_3, L25_3)
              if L21_3 then
                L22_3 = L4_3
                L21_3 = L4_3.find
                L23_3 = " "
                L24_3 = L20_3
                L25_3 = " "
                L23_3 = L23_3 .. L24_3 .. L25_3
                L24_3 = 1
                L25_3 = true
                L21_3 = L21_3(L22_3, L23_3, L24_3, L25_3)
                if not L21_3 then
                  L13_3 = false
                  break
                end
              end
            end
          end
          if L13_3 then
            L14_3 = #L5_3
            L14_3 = L14_3 + 1
            L15_3 = L12_3.vid
            L5_3[L14_3] = L15_3
            L14_3 = #L5_3
            if L14_3 >= 3 then
              break
            end
          end
        end
      end
    end
    L6_3 = {}
    L6_3.alts = L5_3
    L7_3 = true
    L8_3 = 3600000
    return L6_3, L7_3, L8_3
  end
  return L4_2(L5_2, L6_2)
end
function L71_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L45_1
  L2_2 = "s:"
  L3_2 = L34_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.lower
  L3_2 = L3_2(L4_2)
  L2_2 = L2_2 .. L3_2
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = L49_1
    L1_3 = L48_1
    L2_3 = "music"
    L3_3 = "music/get_search_suggestions"
    L4_3 = {}
    L5_3 = A0_2
    L4_3.input = L5_3
    L5_3 = L20_1
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    if not L0_3 then
      L1_3 = nil
      L2_3 = false
      L3_3 = 0
      return L1_3, L2_3, L3_3
    end
    L1_3 = {}
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L42_1
    L5_3 = L0_3
    L6_3 = "searchSuggestionRenderer"
    L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L4_3(L5_3, L6_3)
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = L36_1
      L10_3 = L8_3.suggestion
      L9_3 = L9_3(L10_3)
      if L9_3 then
        L10_3 = L2_3[L9_3]
        if not L10_3 then
          L10_3 = #L9_3
          if L10_3 <= 120 then
            L2_3[L9_3] = true
            L10_3 = #L1_3
            L10_3 = L10_3 + 1
            L1_3[L10_3] = L9_3
            L10_3 = #L1_3
            if L10_3 >= 8 then
              break
            end
          end
        end
      end
    end
    L3_3 = L1_3
    L4_3 = true
    L5_3 = 1800000
    return L3_3, L4_3, L5_3
  end
  return L1_2(L2_2, L3_2)
end
function L72_1()
  local L0_2, L1_2
  L0_2 = L1_1
  L0_2 = not L0_2
  return L0_2
end
function L73_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L72_1
  L0_2 = L0_2()
  if not L0_2 then
    L0_2 = nil
    L2_1 = L0_2
    L0_2 = false
    return L0_2
  end
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = exports
    L1_3 = L0_1
    L0_3 = L0_3[L1_3]
    L1_3 = L0_3
    L0_3 = L0_3.MusicConfig
    return L0_3(L1_3)
  end
  L0_2 = L0_2(L1_2)
  L2_1 = L0_2
  if not L0_2 then
    L1_2 = print
    L2_2 = "^1[unique_phone] music: the running %s does NOT have the MusicRPC export (old version in memory). Run \"restart %s\".^0"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = L0_1
    L5_2 = L0_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2)
    L1_2(L2_2, L3_2, L4_2, L5_2)
  end
  return L0_2
end
function L74_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L72_1
  L3_2 = L3_2()
  if not L3_2 then
    L3_2 = nil
    L4_2 = "noprovider"
    return L3_2, L4_2
  end
  L3_2 = L2_1
  if false == L3_2 then
    L3_2 = L73_1
    L3_2 = L3_2()
    if not L3_2 then
      L3_2 = nil
      L4_2 = "noexport"
      return L3_2, L4_2
    end
  end
  L3_2 = promise
  L3_2 = L3_2.new
  L3_2 = L3_2()
  L4_2 = false
  L5_2 = false
  function L6_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L4_2
    if L1_3 then
      return
    end
    L1_3 = true
    L4_2 = L1_3
    L1_3 = L3_2
    L2_3 = L1_3
    L1_3 = L1_3.resolve
    L3_3 = A0_3
    L1_3(L2_3, L3_3)
  end
  L7_2 = SetTimeout
  L8_2 = 12000
  function L9_2()
    local L0_3, L1_3
    L0_3 = L4_2
    if not L0_3 then
      L0_3 = true
      L5_2 = L0_3
    end
    L0_3 = L6_2
    L1_3 = nil
    L0_3(L1_3)
  end
  L7_2(L8_2, L9_2)
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = exports
    L1_3 = L0_1
    L0_3 = L0_3[L1_3]
    L1_3 = L0_3
    L0_3 = L0_3.MusicRPC
    L2_3 = A0_2
    L3_3 = A1_2
    L4_3 = A2_2
    if not L4_3 then
      L4_3 = {}
    end
    function L5_3(A0_4)
      local L1_4, L2_4
      L1_4 = L6_2
      L2_4 = A0_4
      L1_4(L2_4)
    end
    L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
  end
  L7_2, L8_2 = L7_2(L8_2)
  if not L7_2 then
    L9_2 = print
    L10_2 = "^1[unique_phone] music: %s failed \226\128\148 %s^0"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = tostring
    L13_2 = A0_2
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = L8_2
    L13_2, L14_2 = L13_2(L14_2)
    L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L9_2 = L6_2
    L10_2 = nil
    L9_2(L10_2)
    L9_2 = tostring
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    L10_2 = L9_2
    L9_2 = L9_2.find
    L11_2 = "MusicRPC"
    L9_2 = L9_2(L10_2, L11_2)
    if not L9_2 then
      L9_2 = tostring
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      L10_2 = L9_2
      L9_2 = L9_2.find
      L11_2 = "export"
      L9_2 = L9_2(L10_2, L11_2)
      if not L9_2 then
        goto lbl_68
      end
    end
    L9_2 = false
    L2_1 = L9_2
    L9_2 = nil
    L10_2 = "noexport"
    do return L9_2, L10_2 end
    ::lbl_68::
    L9_2 = nil
    L10_2 = "error"
    return L9_2, L10_2
  end
  L9_2 = Citizen
  L9_2 = L9_2.Await
  L10_2 = L3_2
  L9_2 = L9_2(L10_2)
  if L5_2 then
    L10_2 = nil
    L11_2 = "timeout"
    return L10_2, L11_2
  end
  return L9_2
end
function L75_1()
  local L0_2, L1_2, L2_2
  L0_2 = nil
  L1_2 = L72_1
  L1_2 = L1_2()
  if L1_2 then
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3
      L0_3 = exports
      L1_3 = L0_1
      L0_3 = L0_3[L1_3]
      L1_3 = L0_3
      L0_3 = L0_3.MusicConfig
      L0_3 = L0_3(L1_3)
      L0_2 = L0_3
    end
    L1_2(L2_2)
  end
  L1_2 = L0_2 or L1_2
  if not L0_2 then
    L1_2 = {}
    L1_2.mode = "auto"
    L2_2 = {}
    L1_2.piped = L2_2
    L2_2 = {}
    L1_2.invidious = L2_2
    L1_2.quality = "small"
    L1_2.persist = true
  end
  return L1_2
end
L76_1 = RPC
function L77_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L1_1
  if L1_2 then
    L1_2 = L6_1
    L1_2 = #L1_2
    L1_2 = L1_2 > 0 or L1_2
    L2_2 = {}
    L2_2.ok = L1_2
    L2_2.provider = "internal"
    L3_2 = L4_1
    L2_2.search = L3_2
    L3_2 = GetResourceState
    L4_2 = "apex_carplay"
    L3_2 = L3_2(L4_2)
    L3_2 = "started" == L3_2
    L2_2.carplay = L3_2
    L3_2 = Config
    L3_2 = L3_2.Music
    if L3_2 then
      L3_2 = Config
      L3_2 = L3_2.Music
      L3_2 = L3_2.CarPlay
      L3_2 = false ~= L3_2
    end
    L2_2.car = L3_2
    L3_2 = {}
    L3_2.mode = "auto"
    L4_2 = {}
    L3_2.piped = L4_2
    L4_2 = {}
    L3_2.invidious = L4_2
    L3_2.quality = "small"
    L3_2.persist = true
    L2_2.cfg = L3_2
    L3_2 = L6_1
    L3_2 = #L3_2
    L2_2.tracks = L3_2
    if not L1_2 then
      L3_2 = "nolibrary"
      if L3_2 then
        goto lbl_59
      end
    end
    L3_2 = nil
    ::lbl_59::
    L2_2.error = L3_2
    return L2_2
  end
  L1_2 = L72_1
  L1_2 = L1_2()
  L2_2 = {}
  L2_2.ok = L1_2
  L3_2 = L0_1
  L2_2.provider = L3_2
  L3_2 = GetResourceState
  L4_2 = "apex_carplay"
  L3_2 = L3_2(L4_2)
  L3_2 = "started" == L3_2
  L2_2.carplay = L3_2
  L3_2 = Config
  L3_2 = L3_2.Music
  if L3_2 then
    L3_2 = Config
    L3_2 = L3_2.Music
    L3_2 = L3_2.CarPlay
    L3_2 = false ~= L3_2
  end
  L2_2.car = L3_2
  L3_2 = L75_1
  L3_2 = L3_2()
  L2_2.cfg = L3_2
  if not L1_2 then
    L3_2 = "noprovider"
    if L3_2 then
      goto lbl_97
    end
  end
  L3_2 = nil
  ::lbl_97::
  L2_2.error = L3_2
  return L2_2
end
L76_1["music.status"] = L77_1
L76_1 = RPC
function L77_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L1_1
  if L1_2 then
    L1_2 = L9_1
    L1_2 = L1_2()
    L2_2 = L10_1
    L2_2 = L2_2()
    L3_2 = #L2_2
    if L3_2 > 0 then
      L3_2 = #L1_2
      L3_2 = L3_2 + 1
      L4_2 = {}
      L4_2.title = "\195\129lbuns"
      L4_2.kind = "card"
      L4_2.items = L2_2
      L1_2[L3_2] = L4_2
    end
    L3_2 = {}
    L3_2.shelves = L1_2
    return L3_2
  end
  L1_2 = L74_1
  L2_2 = "mxHome"
  L3_2 = A0_2
  L4_2 = {}
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    return L1_2
  end
  L3_2 = {}
  L4_2 = {}
  L3_2.shelves = L4_2
  L4_2 = L2_2 or L4_2
  if not L2_2 then
    L4_2 = "empty"
  end
  L3_2.error = L4_2
  return L3_2
end
L76_1["music.home"] = L77_1
L76_1 = RPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L1_1
  if L2_2 then
    L2_2 = L34_1
    L3_2 = tostring
    L4_2 = A1_2.q
    if not L4_2 then
      L4_2 = ""
    end
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    L3_2 = L2_2
    L2_2 = L2_2.sub
    L4_2 = 1
    L5_2 = 400
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L3_2 = L4_1
    if not L3_2 then
      L3_2 = L12_1
      L4_2 = L2_2
      return L3_2(L4_2)
    end
    if "" == L2_2 then
      L3_2 = {}
      L3_2.q = ""
      L3_2.top = nil
      L4_2 = {}
      L3_2.shelves = L4_2
      return L3_2
    end
    L3_2 = L62_1
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if false == L3_2 then
      L4_2 = {}
      L4_2.q = L2_2
      L4_2.top = nil
      L5_2 = {}
      L4_2.shelves = L5_2
      L4_2.error = "badlink"
      return L4_2
    end
    if L3_2 then
      L4_2 = L43_1
      L5_2 = "v:"
      L6_2 = L3_2
      L5_2 = L5_2 .. L6_2
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = "v:"
        L5_2 = L3_2
        L4_2 = L4_2 .. L5_2
        L5_2 = L28_1
        L4_2 = L5_2[L4_2]
        if not L4_2 then
          L4_2 = L46_1
          L5_2 = A0_2
          L6_2 = "s"
          L4_2 = L4_2(L5_2, L6_2)
          if not L4_2 then
            L4_2 = {}
            L4_2.q = L2_2
            L4_2.top = nil
            L5_2 = {}
            L4_2.shelves = L5_2
            L4_2.error = "ratelimit"
            return L4_2
          end
        end
      end
      L4_2 = L65_1
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = L50_1
        L5_2 = L3_2
        L6_2 = "youtu.be/"
        L7_2 = L3_2
        L6_2 = L6_2 .. L7_2
        L7_2 = nil
        L8_2 = nil
        L9_2 = 0
        L10_2 = nil
        L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
      end
      L5_2 = {}
      L5_2.q = L2_2
      L5_2.link = L3_2
      L5_2.top = L4_2
      L6_2 = {}
      L7_2 = {}
      L7_2.title = "M\195\186sicas"
      L7_2.kind = "track"
      L8_2 = {}
      L9_2 = L4_2
      L8_2[1] = L9_2
      L7_2.items = L8_2
      L6_2[1] = L7_2
      L5_2.shelves = L6_2
      return L5_2
    end
    L5_2 = L2_2
    L4_2 = L2_2.sub
    L6_2 = 1
    L7_2 = 120
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L5_2 = L63_1
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L6_2 = L43_1
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L7_2 = L33_1.hits
      L7_2 = L7_2 + 1
      L33_1.hits = L7_2
      return L6_2
    end
    L7_2 = L28_1
    L7_2 = L7_2[L5_2]
    if not L7_2 then
      L7_2 = L46_1
      L8_2 = A0_2
      L9_2 = "s"
      L7_2 = L7_2(L8_2, L9_2)
      if not L7_2 then
        L7_2 = L12_1
        L8_2 = L4_2
        L7_2 = L7_2(L8_2)
        L7_2.error = "ratelimit"
        return L7_2
      end
    end
    L7_2 = L45_1
    L8_2 = L5_2
    function L9_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = L64_1
      L1_3 = L4_2
      L0_3, L1_3 = L0_3(L1_3)
      if L0_3 then
        L2_3 = L0_3
        L3_3 = true
        L4_3 = 900000
        return L2_3, L3_3, L4_3
      end
      L2_3 = {}
      L3_3 = L4_2
      L2_3.q = L3_3
      L3_3 = L1_3 or L3_3
      if not L1_3 then
        L3_3 = "offline"
      end
      L2_3.error = L3_3
      L3_3 = false
      L4_3 = 0
      return L2_3, L3_3, L4_3
    end
    L7_2 = L7_2(L8_2, L9_2)
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2.error
      if not L8_2 then
        return L7_2
      end
    end
    L8_2 = L12_1
    L9_2 = L4_2
    L8_2 = L8_2(L9_2)
    L8_2.q = L4_2
    L9_2 = type
    L10_2 = L7_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L7_2.error
      if L9_2 then
        goto lbl_179
      end
    end
    L9_2 = "offline"
    ::lbl_179::
    L8_2.error = L9_2
    return L8_2
  end
  L2_2 = L74_1
  L3_2 = "mxSearch"
  L4_2 = A0_2
  L5_2 = {}
  L6_2 = tostring
  L7_2 = A1_2.q
  if not L7_2 then
    L7_2 = ""
  end
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    return L2_2
  end
  L4_2 = {}
  L5_2 = {}
  L4_2.shelves = L5_2
  L5_2 = L3_2 or L5_2
  if not L3_2 then
    L5_2 = "empty"
  end
  L4_2.error = L5_2
  return L4_2
end
L76_1["music.search"] = L77_1
L76_1 = RPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L1_1
  if L2_2 then
    L2_2 = L34_1
    L3_2 = tostring
    L4_2 = A1_2.q
    if not L4_2 then
      L4_2 = ""
    end
    L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
    L3_2 = L2_2
    L2_2 = L2_2.sub
    L4_2 = 1
    L5_2 = 100
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L3_2 = L4_1
    if L3_2 then
      L3_2 = #L2_2
      if not (L3_2 < 2) then
        L3_2 = L62_1
        L4_2 = L2_2
        L3_2 = L3_2(L4_2)
        if nil == L3_2 then
          goto lbl_41
        end
      end
    end
    L3_2 = L13_1
    L4_2 = L2_2
    do return L3_2(L4_2) end
    ::lbl_41::
    L3_2 = "s:"
    L5_2 = L2_2
    L4_2 = L2_2.lower
    L4_2 = L4_2(L5_2)
    L3_2 = L3_2 .. L4_2
    L4_2 = L43_1
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = L28_1
      L4_2 = L4_2[L3_2]
      if not L4_2 then
        L4_2 = L46_1
        L5_2 = A0_2
        L6_2 = "g"
        L4_2 = L4_2(L5_2, L6_2)
        if not L4_2 then
          L4_2 = L13_1
          L5_2 = L2_2
          return L4_2(L5_2)
        end
      end
    end
    L4_2 = L71_1
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L5_2 = #L4_2
      if L5_2 > 0 then
        return L4_2
      end
    end
    L5_2 = L13_1
    L6_2 = L2_2
    return L5_2(L6_2)
  end
  L2_2 = L74_1
  L3_2 = "mxSuggest"
  L4_2 = A0_2
  L5_2 = {}
  L6_2 = tostring
  L7_2 = A1_2.q
  if not L7_2 then
    L7_2 = ""
  end
  L6_2, L7_2 = L6_2(L7_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L2_2 = {}
  end
  return L2_2
end
L76_1["music.suggest"] = L77_1
L76_1 = RPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L4_1
  if not L2_2 then
    L2_2 = {}
    L3_2 = {}
    L2_2.alts = L3_2
    return L2_2
  end
  L2_2 = L39_1
  L3_2 = A1_2.vid
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L4_2 = {}
    L3_2.alts = L4_2
    return L3_2
  end
  L3_2 = L43_1
  L4_2 = "a:"
  L5_2 = L2_2
  L4_2 = L4_2 .. L5_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = "a:"
    L4_2 = L2_2
    L3_2 = L3_2 .. L4_2
    L4_2 = L28_1
    L3_2 = L4_2[L3_2]
    if not L3_2 then
      L3_2 = L46_1
      L4_2 = A0_2
      L5_2 = "s"
      L3_2 = L3_2(L4_2, L5_2)
      if not L3_2 then
        L3_2 = {}
        L4_2 = {}
        L3_2.alts = L4_2
        L3_2.error = "ratelimit"
        return L3_2
      end
    end
  end
  L3_2 = type
  L4_2 = A1_2.t
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.t
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 120
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_71
    end
  end
  L3_2 = ""
  ::lbl_71::
  L4_2 = type
  L5_2 = A1_2.a
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = A1_2.a
    L5_2 = L4_2
    L4_2 = L4_2.sub
    L6_2 = 1
    L7_2 = 90
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_84
    end
  end
  L4_2 = ""
  ::lbl_84::
  L5_2 = L70_1
  L6_2 = L2_2
  L7_2 = L3_2
  L8_2 = L4_2
  L9_2 = math
  L9_2 = L9_2.floor
  L10_2 = tonumber
  L11_2 = A1_2.len
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 0
  end
  L9_2, L10_2, L11_2 = L9_2(L10_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = type
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L6_2 = L5_2 or L6_2
  if "table" ~= L6_2 or not L5_2 then
    L6_2 = {}
    L7_2 = {}
    L6_2.alts = L7_2
  end
  return L6_2
end
L76_1["music.alt"] = L77_1
L76_1 = RPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L1_1
  if L2_2 then
    L2_2 = tostring
    L3_2 = A1_2.id
    if not L3_2 then
      L3_2 = ""
    end
    L2_2 = L2_2(L3_2)
    L4_2 = L2_2
    L3_2 = L2_2.gsub
    L5_2 = "^alb:"
    L6_2 = ""
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L4_2 = {}
    L5_2 = nil
    L6_2 = nil
    L7_2 = ipairs
    L8_2 = L6_1
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = L12_2.alb
      if L13_2 == L3_2 then
        L13_2 = #L4_2
        L13_2 = L13_2 + 1
        L4_2[L13_2] = L12_2
        if not L5_2 then
          L5_2 = L12_2.a
        end
        if not L6_2 then
          L6_2 = L12_2.img
        end
      end
    end
    L7_2 = #L4_2
    if 0 == L7_2 then
      L7_2 = {}
      L7_2.error = "notfound"
      return L7_2
    end
    L7_2 = {}
    L7_2.id = L2_2
    L7_2.kind = "album"
    L7_2.t = L3_2
    L8_2 = L5_2 or L8_2
    if not L5_2 then
      L8_2 = ""
    end
    L7_2.a = L8_2
    L7_2.img = L6_2
    L7_2.tracks = L4_2
    return L7_2
  end
  L2_2 = L74_1
  L3_2 = "mxBrowse"
  L4_2 = A0_2
  L5_2 = {}
  L6_2 = tostring
  L7_2 = A1_2.id
  if not L7_2 then
    L7_2 = ""
  end
  L6_2 = L6_2(L7_2)
  L7_2 = tostring
  L8_2 = A1_2.kind
  if not L8_2 then
    L8_2 = "playlist"
  end
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L7_2(L8_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L5_2[7] = L12_2
  L5_2[8] = L13_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    return L2_2
  end
  L4_2 = {}
  L5_2 = L3_2 or L5_2
  if not L3_2 then
    L5_2 = "empty"
  end
  L4_2.error = L5_2
  return L4_2
end
L76_1["music.browse"] = L77_1
L76_1 = RPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L1_1
  if L2_2 then
    L2_2 = tostring
    L3_2 = A1_2.vid
    if not L3_2 then
      L3_2 = ""
    end
    L2_2 = L2_2(L3_2)
    L3_2 = L39_1
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    L4_2 = L4_1
    if L4_2 and L3_2 then
      L4_2 = L43_1
      L5_2 = "r:"
      L6_2 = L3_2
      L5_2 = L5_2 .. L6_2
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = "r:"
        L5_2 = L3_2
        L4_2 = L4_2 .. L5_2
        L5_2 = L28_1
        L4_2 = L5_2[L4_2]
        if not L4_2 then
          L4_2 = L46_1
          L5_2 = A0_2
          L6_2 = "s"
          L4_2 = L4_2(L5_2, L6_2)
          if not L4_2 then
            goto lbl_63
          end
        end
      end
      L4_2 = L66_1
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      L5_2 = type
      L6_2 = L4_2
      L5_2 = L5_2(L6_2)
      if "table" == L5_2 then
        L5_2 = L4_2.error
        if not L5_2 then
          L5_2 = #L4_2
          if L5_2 > 0 then
            return L4_2
          end
        end
      end
    end
    ::lbl_63::
    L4_2 = L14_1
    L5_2 = L2_2
    return L4_2(L5_2)
  end
  L2_2 = L74_1
  L3_2 = "mxRadio"
  L4_2 = A0_2
  L5_2 = {}
  L6_2 = tostring
  L7_2 = A1_2.vid
  if not L7_2 then
    L7_2 = ""
  end
  L6_2, L7_2 = L6_2(L7_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L2_2 = {}
  end
  return L2_2
end
L76_1["music.radio"] = L77_1
L76_1 = RPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L1_1
  if L2_2 then
    L2_2 = {}
    L2_2.text = nil
    L2_2.source = nil
    L2_2.error = "nolyrics"
    return L2_2
  end
  L2_2 = L74_1
  L3_2 = "mxLyrics"
  L4_2 = A0_2
  L5_2 = {}
  L6_2 = tostring
  L7_2 = A1_2.vid
  if not L7_2 then
    L7_2 = ""
  end
  L6_2, L7_2 = L6_2(L7_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  return L2_2(L3_2, L4_2, L5_2)
end
L76_1["music.lyrics"] = L77_1
L76_1 = RPC
function L77_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L1_1
  if L1_2 then
    L1_2 = L15_1
    L2_2 = GetCid
    L3_2 = A0_2
    L2_2, L3_2, L4_2 = L2_2(L3_2)
    return L1_2(L2_2, L3_2, L4_2)
  end
  L1_2 = L74_1
  L2_2 = "mxLoad"
  L3_2 = A0_2
  L4_2 = {}
  return L1_2(L2_2, L3_2, L4_2)
end
L76_1["music.load"] = L77_1
L76_1 = RPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L1_1
  if L2_2 then
    L2_2 = {}
    L3_2 = L16_1
    L4_2 = GetCid
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    L5_2 = A1_2
    L3_2 = L3_2(L4_2, L5_2)
    L2_2.ok = L3_2
    return L2_2
  end
  L2_2 = {}
  L3_2 = L74_1
  L4_2 = "mxSave"
  L5_2 = A0_2
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = true == L3_2
  L2_2.ok = L3_2
  return L2_2
end
L76_1["music.save"] = L77_1
L76_1 = RegisterCommand
L77_1 = "phonemusic"
function L78_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  if 0 ~= A0_2 then
    return
  end
  L2_2 = print
  L3_2 = "[unique_phone] music: provider=%s, open search=%s, region=%s, library=%d track(s), cache=%d entr(ies), HTTP requests=%d (failed %d, cache hits %d), in flight=%d%s%s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = tostring
  L6_2 = L0_1
  L5_2 = L5_2(L6_2)
  L6_2 = L4_1
  if L6_2 then
    L6_2 = "ON"
    if L6_2 then
      goto lbl_17
    end
  end
  L6_2 = "OFF"
  ::lbl_17::
  L7_2 = L5_1
  L8_2 = L6_1
  L8_2 = #L8_2
  L9_2 = L26_1.order
  L9_2 = #L9_2
  L10_2 = L33_1.http
  L11_2 = L33_1.fail
  L12_2 = L33_1.hits
  L13_2 = L29_1
  L14_2 = GetGameTimer
  L14_2 = L14_2()
  L15_2 = L30_1
  if L14_2 < L15_2 then
    L14_2 = ", PAUSED for "
    L15_2 = math
    L15_2 = L15_2.ceil
    L16_2 = L30_1
    L17_2 = GetGameTimer
    L17_2 = L17_2()
    L16_2 = L16_2 - L17_2
    L16_2 = L16_2 / 1000
    L15_2 = L15_2(L16_2)
    L16_2 = " s after HTTP 429/403"
    L14_2 = L14_2 .. L15_2 .. L16_2
    if L14_2 then
      goto lbl_47
    end
  end
  L14_2 = ""
  ::lbl_47::
  L15_2 = L33_1.lastErr
  if L15_2 then
    L15_2 = ", last error: "
    L16_2 = L33_1.lastErr
    L15_2 = L15_2 .. L16_2
    if L15_2 then
      goto lbl_56
    end
  end
  L15_2 = ""
  ::lbl_56::
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L2_2 = table
  L2_2 = L2_2.concat
  L3_2 = A1_2 or L3_2
  if not A1_2 then
    L3_2 = {}
  end
  L4_2 = " "
  L2_2 = L2_2(L3_2, L4_2)
  if "" ~= L2_2 then
    L3_2 = L4_1
    if L3_2 then
      goto lbl_72
    end
  end
  do return end
  ::lbl_72::
  L3_2 = CreateThread
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3
    L0_3 = GetGameTimer
    L0_3 = L0_3()
    L1_3 = RPC
    L1_3 = L1_3["music.search"]
    L2_3 = 0
    L3_3 = {}
    L4_3 = L2_2
    L3_3.q = L4_3
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = 0
    L3_3 = ipairs
    L4_3 = type
    L5_3 = L1_3
    L4_3 = L4_3(L5_3)
    if "table" == L4_3 then
      L4_3 = L1_3.shelves
      if L4_3 then
        goto lbl_23
      end
    end
    L4_3 = {}
    ::lbl_23::
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = L8_3.items
      if not L9_3 then
        L9_3 = {}
      end
      L9_3 = #L9_3
      L2_3 = L2_3 + L9_3
    end
    L3_3 = type
    L4_3 = L1_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = L1_3.top
      if L3_3 then
        goto lbl_45
      end
    end
    L3_3 = nil
    ::lbl_45::
    L4_3 = print
    L5_3 = "[unique_phone] music: search \"%s\" \226\134\146 %d track(s) in %d ms%s%s"
    L6_3 = L5_3
    L5_3 = L5_3.format
    L7_3 = L2_2
    L8_3 = L2_3
    L9_3 = GetGameTimer
    L9_3 = L9_3()
    L9_3 = L9_3 - L0_3
    if L3_3 then
      L10_3 = ", first: "
      L11_3 = tostring
      L12_3 = L3_3.t
      L11_3 = L11_3(L12_3)
      L12_3 = " / "
      L13_3 = tostring
      L14_3 = L3_3.a
      if not L14_3 then
        L14_3 = "?"
      end
      L13_3 = L13_3(L14_3)
      L14_3 = " ("
      L15_3 = tostring
      L16_3 = L3_3.vid
      L15_3 = L15_3(L16_3)
      L16_3 = ")"
      L10_3 = L10_3 .. L11_3 .. L12_3 .. L13_3 .. L14_3 .. L15_3 .. L16_3
      if L10_3 then
        goto lbl_76
      end
    end
    L10_3 = ""
    ::lbl_76::
    L11_3 = type
    L12_3 = L1_3
    L11_3 = L11_3(L12_3)
    if "table" == L11_3 then
      L11_3 = L1_3.error
      if L11_3 then
        L11_3 = ", error: "
        L12_3 = tostring
        L13_3 = L1_3.error
        L12_3 = L12_3(L13_3)
        L11_3 = L11_3 .. L12_3
        if L11_3 then
          goto lbl_92
        end
      end
    end
    L11_3 = ""
    ::lbl_92::
    L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
    L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3)
  end
  L3_2(L4_2)
end
L79_1 = true
L76_1(L77_1, L78_1, L79_1)
L76_1 = CreateThread
function L77_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = Wait
  L1_2 = 2000
  L0_2(L1_2)
  L0_2 = L1_1
  if L0_2 then
    return
  end
  L0_2 = L72_1
  L0_2 = L0_2()
  if L0_2 then
    L0_2 = L73_1
    L0_2 = L0_2()
    if L0_2 then
      L0_2 = print
      L1_2 = "[unique_phone] music: TubeMusic via %s"
      L2_2 = L1_2
      L1_2 = L1_2.format
      L3_2 = L0_1
      L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
      L0_2(L1_2, L2_2, L3_2)
    end
  else
    L0_2 = print
    L1_2 = "^3[unique_phone] music: \"%s\" is not running. Set Config.Music.Provider = \"internal\" so the phone handles music by itself.^0"
    L2_2 = L1_2
    L1_2 = L1_2.format
    L3_2 = L0_1
    L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
    L0_2(L1_2, L2_2, L3_2)
  end
end
L76_1(L77_1)
L76_1 = AddEventHandler
L77_1 = "onResourceStart"
function L78_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L1_1
  if not L1_2 then
    L1_2 = L0_1
    if A0_2 == L1_2 then
      goto lbl_8
    end
  end
  do return end
  ::lbl_8::
  L1_2 = nil
  L2_1 = L1_2
  L1_2 = SetTimeout
  L2_2 = 1500
  function L3_2()
    local L0_3, L1_3
    L0_3 = L73_1
    L0_3()
  end
  L1_2(L2_2, L3_2)
end
L76_1(L77_1, L78_1)
